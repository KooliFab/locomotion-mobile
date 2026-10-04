# Spécification Technique & Cadrage — Lot 13 (Gestion mobile de la flotte propriétaire)

Ce document formalise l'architecture, les contrats d'API backend et mobile, la gestion fine des permissions (propriétaire, co-propriétaire, administrateur), les règles de validation et de publication, le patch logique des champs autorisés pour véhicules publiés, le mécanisme de suspension temporaire autonome sans perte d'historique ni altération du calendrier existant, l'idempotence et la gestion des conflits de concurrence optimiste (409 Conflict), ainsi que l'ensemble des écrans Flutter et la stratégie de tests pour le **Lot 13** du projet LocoMotion.

---

## 1. Mission & Périmètre du Lot 13

### 1.1 Mission du sous-agent
Permettre à un propriétaire ou co-propriétaire de gérer son parc de véhicules depuis l'application mobile :
1. **Consulter sa flotte gérable** via un endpoint serveur filtré et sécurisé (`GET /api/v1/owner/fleet`) dans le groupe de middleware existant `auth:api` (Passport), interdisant tout contournement ou usurpation d'`owner_id`.
2. **Créer un véhicule** par type (`car`, `bike`, `trailer`, `car_trailer`) avec toutes les informations requises (identité, détails techniques, géolocalisation, consignes, photos réordonnées, mode de partage), avec sécurisation serveur stricte de l'identité du propriétaire et support d'une clé d'idempotence anti-doublon en cas de timeout.
3. **Modifier un véhicule** par un *patch logique* des champs autorisés avec contrôle de concurrence optimiste (`lock_version` $\rightarrow$ `409 Conflict`), en respectant le verrouillage des champs techniques critiques d'une voiture publiée (`LoanablePolicy@updatePublishedFields`).
4. **Prévisualiser et publier** un véhicule avec contrôle strict des exigences administratives bloquantes avant mise en ligne.
5. **Suspendre et réactiver** un véhicule (`PUT /api/v1/loanables/{id}/suspend` et `PUT /api/v1/loanables/{id}/unsuspend`) via un état de suspension distinct (`is_suspended`, `suspended_at`, `suspension_reason`), **sans jamais altérer ni inverser les règles de calendrier existantes** (`availability_mode` et `availability_json`), tout en **préservant scrupuleusement l'historique et les réservations actives ou futures confirmées** (aucune annulation implicite).
6. **Synchroniser et rafraîchir** instantanément l'exploration, la fiche détaillée, le calendrier public et la flotte propriétaire en ciblant les providers Riverpod réels du projet.

---

### 1.2 Périmètre inclus

1. **Consultation de la flotte propriétaire (`GET /api/v1/owner/fleet`)** :
   - Route sécurisée sous le middleware `auth:api`.
   - Filtrage serveur obligatoire via `Loanable::scopeManagedBy($user->id)` (propriétaire, co-propriétaire ou manager), ou l'ensemble du parc si administrateur. **Aucun paramètre `owner_id` client n'est accepté**, éliminant tout risque de fuite de données ou d'usurpation.
   - Restitution des compteurs de réservations précis :
     - `active_loans_count` : tous les prêts `status == LoanStatus::Ongoing` (y compris ceux ayant dépassé l'heure prévue de retour).
     - `confirmed_future_loans_count` : réservations futures fermes (`status in [Accepted, Confirmed]` et `departure_at > now()`).
     - `pending_requests_count` : demandes futures en attente d'approbation (`status == LoanStatus::Requested` et `departure_at > now()`).
     - `future_loans_count` : cumul futur (`confirmed_future_loans_count + pending_requests_count`).
     - État de suspension (`is_suspended`), état de publication (`published`), date de mise à jour ISO (`updated_at` servant de `lock_version`), image principale et communauté de rattachement.
   - Accès direct depuis `ProfileScreen` via une entrée dédiée *"Ma flotte de véhicules"*.

2. **Création de véhicule sécurisée & Idempotence (`POST /api/v1/loanables`)** :
   - Support des 4 types : voiture (`car`), vélo (`bike`), remorque (`trailer`), remorque d'auto (`car_trailer`).
   - **Sécurisation stricte de l'identité du propriétaire** : si l'utilisateur n'est pas administrateur, le serveur force et valide `owner_user.id == auth()->id()`. Toute tentative d'assigner un `owner_user.id` différent est immédiatement rejetée avec HTTP `403 Forbidden` (`"Vous ne pouvez déclarer un véhicule que pour vous-même."`).
   - **Clé d'idempotence (`idempotency_key` / UUID v4)** : transmise dans l'en-tête `Idempotency-Key` ou dans le corps. Si une coupure réseau ou un timeout survient, le client mobile rejoue avec la même clé : le serveur renvoie la ressource déjà créée (`200 OK`) au lieu de générer un doublon.
   - Téléversement multi-photos avec ordonnancement (`images.*.id`, `images.*.order`), réutilisant le pipeline d'upload multipart du Lot 10 (`POST /api/v1/images`).
   - Saisie des consignes de prise en charge, restitution et consignes privées pour emprunteurs de confiance.
   - Saisie de la géolocalisation (`position = [lat, lng]`) et de la description du stationnement.
   - Mode de partage : sur demande (`on_demand`), auto-service (`self_service`) ou hybride (`hybrid`).

3. **Modification sécurisée, Concurrence optimiste & Patch logique (`PUT /api/v1/loanables/{id}`)** :
   - **Contrôle de concurrence optimiste** : envoi de la version connue (`lock_version` ou `If-Match: "{updated_at}"`). Si l'entité a été modifiée en base par un autre gestionnaire depuis le chargement, le backend rejette avec HTTP `409 Conflict` et renvoie l'état frais du véhicule.
   - **Patch sélectif** n'envoyant que les champs autorisés et modifiés.
   - **Respect absolu du verrouillage des voitures publiées** : pour toute voiture publiée (`published == true` et `type == car`), les champs techniques (`type`, `brand`, `model`, `engine`, `transmission_mode`, `year_of_circulation`, `pricing_category`, `value_category`) sont verrouillés dans l'UI mobile (badge cadenas et texte explicatif) et systématiquement omis du payload de mise à jour pour les non-administrateurs afin d'éviter le rejet `422 Unprocessable Entity` (`field_cannot_be_updated`).
   - Mappage bidirectionnel des erreurs 422 avec les champs du formulaire.

4. **Prévisualisation & Publication (`PUT /api/v1/loanables/{id}/publish`)** :
   - Écran de prévisualisation affichant la fiche telle que les emprunteurs la verront.
   - Contrôle pré-vol des exigences bloquantes de publication selon le type (ex: plaque, papiers, moteur pour auto ; type, taille pour vélo ; coordonnées GPS pour tous).
   - Affichage explicite des critères manquants avec redirection ciblée vers la section du formulaire à compléter.
   - Publication atomique avec émission de l'événement `LoanablePublishedEvent`.

5. **Suspension temporaire étanche & Rétablissement (`PUT /api/v1/loanables/{id}/suspend` & `/unsuspend`)** :
   - **État de suspension autonome** :
     - Utilisation d'un drapeau dédié `is_suspended` (avec horodatage `suspended_at` et motif optionnel `suspension_reason`).
     - **Préservation totale du calendrier** : `availability_mode` et `availability_json` restent intacts, évitant tout effet d'inversion des règles selon [`AvailabilityHelper.php:320`](file:///Users/fabapps/Documents/Dev/locomotion/backend/app/Calendar/AvailabilityHelper.php#L320).
     - Lors du calcul des disponibilités (`computeAvailability`, `getAvailability` ou `LoanableController@availability`), si `is_suspended == true`, aucun créneau n'est rendu disponible.
     - Dans [`Loanable::isAvailable()`](file:///Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loanable.php#L408), le contrôle retourne immédiatement `false` si `is_suspended == true`.
     - Au rétablissement (`unsuspend`), `is_suspended` repasse à `false` et le véhicule retrouve instantanément son calendrier initial sans altération.
   - **Garantie de non-annulation implicite** : les réservations en cours (`Ongoing`, même en retard) et futures confirmées (`Accepted`, `Confirmed`) **ne sont pas annulées** et restent pleinement exécutables.
   - Boîte de dialogue de confirmation présentant explicitement les conséquences et le décompte exact des prêts actifs, des réservations confirmées et des demandes en attente.
   - Retrait immédiat de la disponibilité dans l'écran Explorer (`ExploreScreen`) et dans le calendrier public.

6. **Invalidation ciblée des providers Riverpod réels** :
   - Actualisation de [`loanablesListControllerProvider`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loanables/presentation/controllers/loanables_controller.dart#L46) pour la liste Explorer.
   - Actualisation de [`loanableDetailProvider(loanableId)`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loanables/presentation/controllers/loanables_controller.dart#L109) pour la fiche détaillée.
   - Invalidation de [`loanableAvailabilityPeriodProvider(loanableId)`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loanables/presentation/controllers/loanables_controller.dart#L114) et de la famille [`loanableAvailabilityWindowProvider`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loanables/presentation/controllers/loanables_controller.dart#L133).
   - Actualisation de `ownerFleetControllerProvider` pour la liste de la flotte propriétaire.

---

### 1.3 Hors périmètre

- Gestion avancée des rôles utilisateurs (invitation d'autres co-propriétaires, délégation de gestion) : relève du module d'administration web des communautés.
- Import massif de véhicules via tableur / CSV.
- Éditeur avancé de formules tarifaires et règles de tarification personnalisées.
- Suppression définitive en base de données (*hard delete* / purge).

---

## 2. Architecture Technique & Découpage des Fichiers

### 2.1 Backend (Laravel 10 / PHP 8.2+)

```
backend/
├── database/migrations/
│   └── 2026_10_03_190000_add_suspension_and_idempotency_to_loanables_table.php
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── LoanableController.php         # Endpoints ownerFleet(), suspend(), unsuspend(),
│   │   │                                       # contrôle owner_user.id et idempotency_key dans create(),
│   │   │                                       # contrôle lock_version dans update()
│   │   ├── Resources/
│   │   │   └── Loanable/
│   │   │       ├── LoanableResource.php       # Enrichi avec is_suspended, published, updated_at
│   │   │       └── OwnerFleetResource.php     # Ressource optimisée pour la liste de flotte propriétaire
│   │   └── Requests/
│   │       └── Loanable/
│   │           └── SuspendLoanableRequest.php # Validation motif et confirmation de suspension
│   ├── Models/
│   │   ├── Loanable.php                       # Méthodes suspend(), unsuspend(), is_suspended, accesseurs de compteurs
│   │   └── Policies/
│   │       └── LoanablePolicy.php             # Autorisation suspend/unsuspend, create
│   └── Calendar/
│       └── AvailabilityHelper.php             # Prise en compte de is_suspended
└── routes/
    └── api.php                                # Enregistrement des routes sous le middleware auth:api
```

### 2.2 Mobile (Flutter 3.x / Dart 3.x / Riverpod 2.x)

```
mobile/lib/
├── core/
│   └── router/
│       ├── routes.dart                    # Constantes ownerFleet, vehicleCreate, vehicleDetail, vehicleEdit, vehiclePreview
│       └── app_router.dart                # Routes associées
├── features/
│   ├── fleet/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── fleet_vehicle.dart     # Entité avec @JsonKey stricts (sharing_mode, etc.)
│   │   │   │   └── vehicle_form_data.dart # État de formulaire, patch logique et gestion d'erreurs 422
│   │   │   └── repositories/
│   │   │       └── fleet_repository.dart  # Contrat getOwnerFleet, createVehicle, patchVehicle, suspend, unsuspend, publish
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── fleet_remote_data_source.dart # Appels HTTP Dio (gestion Idempotency-Key, If-Match, multipart photos)
│   │   │   └── repositories/
│   │   │       └── fleet_repository_impl.dart    # Implémentation du repository
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   ├── fleet_controller.dart         # AsyncNotifier de la liste de flotte
│   │       │   └── vehicle_form_controller.dart  # Contrôleur de formulaire (création, patch sélectif, concurrence 409)
│   │       ├── screens/
│   │       │   ├── owner_fleet_screen.dart       # Liste de la flotte propriétaire avec filtres et compteurs
│   │       │   ├── owner_vehicle_detail_screen.dart # Gestion propriétaire (actions, publication, suspension)
│   │       │   ├── vehicle_form_screen.dart      # Formulaire de création / édition avec sections et verrouillage
│   │       │   └── vehicle_preview_screen.dart   # Prévisualisation avant publication
│   │       └── widgets/
│   │           ├── fleet_vehicle_card.dart       # Carte véhicule avec badges de statut et compteurs de prêts
│   │           ├── vehicle_suspension_dialog.dart # Dialogue de confirmation avec décompte des réservations préservées
│   │           ├── vehicle_photo_uploader.dart   # Téléversement multi-photos et réordonnancement
│   │           └── locked_field_indicator.dart   # Indicateur visuel pour champs protégés post-publication
│   ├── loanables/
│   │   └── domain/entities/
│   │       └── loanable.dart              # Ajout des champs published, isSuspended
│   └── profile/
│       └── presentation/screens/
│           └── profile_screen.dart        # Entrée "Ma flotte de véhicules"
```

---

## 3. Spécification Détaillée des Contrats & Endpoints

### 3.1 `GET /api/v1/owner/fleet` (Liste sécurisée de la flotte propriétaire)

* **Méthode** : `GET`
* **Route** : `/api/v1/owner/fleet`
* **Middleware** : `auth:api` (Passport).
* **Comportement serveur** :
  - Si administrateur : renvoie tous les véhicules du réseau.
  - Si utilisateur standard : applique obligatoirement `Loanable::managedBy($user->id)`. Aucun paramètre `owner_id` client n'est pris en compte.

#### Response (200 OK)
```json
{
  "data": [
    {
      "id": 42,
      "name": "Hyundai Ioniq 5 Solon",
      "type": "car",
      "sharing_mode": "self_service",
      "published": true,
      "availability_mode": "always",
      "is_suspended": false,
      "active_loans_count": 1,
      "confirmed_future_loans_count": 2,
      "pending_requests_count": 1,
      "future_loans_count": 3,
      "location_description": "Stationné devant le 4520 rue de Bellechasse, borne #2",
      "position": [45.5412, -73.5789],
      "primary_image_url": "http://localhost:8000/api/v1/images/105",
      "image": {
        "id": 105,
        "url": "http://localhost:8000/api/v1/images/105"
      },
      "community": {
        "id": 8,
        "name": "LocoMotion Rosemont"
      },
      "user_role": "owner",
      "updated_at": "2026-10-03T18:00:00.000000Z"
    }
  ]
}
```

---

### 3.2 `POST /api/v1/loanables` (Création avec idempotence & contrôle de propriétaire)

* **Méthode** : `POST`
* **Route** : `/api/v1/loanables`
* **Middleware** : `auth:api`
* **En-tête optionnel / champ** : `Idempotency-Key: <UUID>` ou `"idempotency_key": "<UUID>"`.
* **Contrôles serveur** :
  1. Si `idempotency_key` est fournie et qu'un véhicule existe déjà avec cette clé pour cet utilisateur : renvoie immédiatement le véhicule créé (`200 OK`), évitant tout doublon suite à un timeout.
  2. Si l'utilisateur n'est pas admin et que `owner_user.id != auth()->id()` : rejet immédiat `403 Forbidden` (`"Vous ne pouvez déclarer un véhicule que pour vous-même."`).

#### Request Payload
```json
{
  "idempotency_key": "b7b4a2e5-3d92-4f8e-97c1-52a129d2f70a",
  "type": "car",
  "name": "Toyota Prius Prime Rosemont",
  "owner_user": { "id": 12 },
  "sharing_mode": "hybrid",
  "min_loan_duration_in_minutes": 60,
  "max_loan_duration_in_minutes": 2880,
  "availability_mode": "always",
  "location_description": "Allée privée côté ouest",
  "position": [45.542, -73.575],
  "instructions": "La clé se trouve dans la boîte à clé murale code 4589.",
  "return_instructions": "Brancher le véhicule sur la prise 120V et remettre la clé dans la boîte.",
  "trusted_borrower_instructions": "Code du garage pour le lave-glace : 1234.",
  "comments": "Véhicule non-fumeur, animaux acceptés uniquement en cage.",
  "images": [
    { "id": 201, "order": 0 },
    { "id": 202, "order": 1 }
  ],
  "details": {
    "brand": "Toyota",
    "model": "Prius Prime",
    "year_of_circulation": 2022,
    "engine": "hybrid",
    "transmission_mode": "automatic",
    "plate_number": "ABC-123",
    "papers_location": "in_the_car",
    "pricing_category": "small",
    "value_category": "lte50k",
    "insurer": "Intact Assurance",
    "has_onboard_notebook": true,
    "has_report_in_notebook": true,
    "has_informed_insurer": true
  }
}
```

#### Response (201 Created ou 200 OK si rejeu idempotent)
Retourne `LoanableResource` complet du véhicule (`published = false`, `is_suspended = false`).

---

### 3.3 `PUT /api/v1/loanables/{loanable}` (Patch logique & Concurrence optimiste)

* **Méthode** : `PUT`
* **Route** : `/api/v1/loanables/{loanable}`
* **Middleware** : `auth:api`
* **En-tête de version ou payload** : `If-Match: "{updated_at}"` ou champ `"lock_version": "{updated_at}"`.
* **Contrôles serveur** :
  1. Si `lock_version` ou `If-Match` est fourni et ne correspond pas au `updated_at` en base : rejet `409 Conflict` (`"Ce véhicule a été modifié par un autre gestionnaire. Veuillez recharger la page."`).
  2. Si le véhicule est une voiture publiée et que l'utilisateur n'est pas admin : interdiction des champs techniques protégés (`field_cannot_be_updated`).
  3. Le client mobile envoie uniquement les champs modifiés autorisés.

#### Response (200 OK)
Retourne `LoanableResource` actualisé avec son nouveau `updated_at`.

#### Erreurs de concurrence (409 Conflict)
```json
{
  "message": "Ce véhicule a été modifié par un autre gestionnaire. Veuillez recharger la page.",
  "loanable": { ... état frais ... }
}
```

---

### 3.4 `PUT /api/v1/loanables/{loanable}/publish` (Publication)

* **Méthode** : `PUT`
* **Route** : `/api/v1/loanables/{loanable}/publish`
* **Middleware** : `auth:api`
* **Validation des exigences administratives** :
  - `position` obligatoire.
  - Si `car` : `brand`, `engine`, `model`, `papers_location`, `plate_number`, `pricing_category`, `transmission_mode`, `value_category`, `year_of_circulation` obligatoires.
  - Si `bike` : `bike_type`, `model`, `size` obligatoires.
* **Effet serveur** :
  - `published = true`.
  - Émission de `LoanablePublishedEvent`.

---

### 3.5 `PUT /api/v1/loanables/{loanable}/suspend` (Suspension autonome)

* **Méthode** : `PUT`
* **Route** : `/api/v1/loanables/{loanable}/suspend`
* **Middleware** : `auth:api`
* **Payload** :
```json
{
  "reason": "Maintenance mécanique planifiée",
  "preserve_future_confirmed_loans": true
}
```
* **Effet serveur** :
  - `is_suspended = true`, `suspended_at = now()`, `suspension_reason = $reason`.
  - **`availability_mode` et `availability_json` NE SONT PAS MODIFIÉS**.
  - **Aucune annulation implicite** : les réservations en cours (`Ongoing`, y compris en retard) et futures confirmées (`Accepted`, `Confirmed`) restent valides.
  - Le véhicule n'offre plus aucun créneau disponible pour de nouvelles réservations.

#### Response (200 OK)
```json
{
  "message": "Le véhicule a été suspendu avec succès.",
  "loanable": {
    "id": 42,
    "name": "Hyundai Ioniq 5 Solon",
    "is_suspended": true,
    "availability_mode": "always",
    "published": true
  },
  "active_loans_count": 1,
  "confirmed_future_loans_count": 2,
  "pending_requests_count": 1,
  "future_loans_count": 3
}
```

---

### 3.6 `PUT /api/v1/loanables/{loanable}/unsuspend` (Rétablissement)

* **Méthode** : `PUT`
* **Route** : `/api/v1/loanables/{loanable}/unsuspend`
* **Middleware** : `auth:api`
* **Effet serveur** :
  - `is_suspended = false`, `suspended_at = null`, `suspension_reason = null`.
  - Le calendrier initial du véhicule redevient immédiatement actif sans aucune perte de configuration.

---

## 4. Modèle de Données & Entités Mobiles

### 4.1 Migration Backend

```php
Schema::table('loanables', function (Blueprint $table) {
    $table->boolean('is_suspended')->default(false)->index();
    $table->timestamp('suspended_at')->nullable();
    $table->text('suspension_reason')->nullable();
    $table->string('idempotency_key', 64)->nullable()->index();
});
```

### 4.2 Entité Mobile `FleetVehicle` (avec `@JsonKey` explicites)

```dart
@freezed
abstract class FleetVehicle with _$FleetVehicle {
  const factory FleetVehicle({
    required int id,
    required String name,
    required String type,
    @JsonKey(name: 'sharing_mode') String? sharingMode,
    @Default(false) bool published,
    @JsonKey(name: 'availability_mode') String? availabilityMode,
    @Default(false) @JsonKey(name: 'is_suspended') bool isSuspended,
    @Default(0) @JsonKey(name: 'active_loans_count') int activeLoansCount,
    @Default(0) @JsonKey(name: 'confirmed_future_loans_count') int confirmedFutureLoansCount,
    @Default(0) @JsonKey(name: 'pending_requests_count') int pendingRequestsCount,
    @Default(0) @JsonKey(name: 'future_loans_count') int futureLoansCount,
    @JsonKey(name: 'location_description') String? locationDescription,
    List<double>? position,
    @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
    LoanableImage? image,
    @Default([]) List<LoanableImage> images,
    Map<String, dynamic>? community,
    @JsonKey(name: 'user_role') String? userRole,
    Map<String, dynamic>? details,
    String? instructions,
    @JsonKey(name: 'return_instructions') String? returnInstructions,
    @JsonKey(name: 'trusted_borrower_instructions') String? trustedBorrowerInstructions,
    String? comments,
    @JsonKey(name: 'min_loan_duration_in_minutes') int? minLoanDurationInMinutes,
    @JsonKey(name: 'max_loan_duration_in_minutes') int? maxLoanDurationInMinutes,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _FleetVehicle;

  factory FleetVehicle.fromJson(Map<String, dynamic> json) => _$FleetVehicleFromJson(json);
}
```

---

## 5. Parcours Utilisateur Mobile & Interactions UI

### 5.1 Écran de Flotte Propriétaire (`OwnerFleetScreen`)
- Accessible depuis l'onglet `Profil` $\rightarrow$ *"Ma flotte de véhicules"*.
- Filtres rapides : Tous | Actifs | Suspendus | Brouillons.
- Cartes de véhicule (`FleetVehicleCard`) :
  - Miniature photo avec badge de type (Voiture, Vélo, Remorque).
  - Badges de statut visuels :
    - 🟢 **Actif / Publié** : disponible pour les membres.
    - 🟠 **Suspendu** : nouveaux emprunts suspendus, historique et prêts en cours intacts.
    - ⚪ **Brouillon** : non publié, visible uniquement du propriétaire.
  - Décompte précis :
    - *"1 prêt en cours"* (statut ongoing, même en retard).
    - *"2 réservations confirmées, 1 demande en attente"*.
  - Boutons d'action : *"Gérer"*, *"Modifier"*.
- Bouton flottant (FAB) *"Ajouter un véhicule"*.
- État vide avec guide d'accueil et bouton incitatif.

---

### 5.2 Formulaire de Véhicule (`VehicleFormScreen`)
- Découpage en sections : Type & Nom, Caractéristiques techniques selon le type, Localisation GPS & Stationnement, Paramètres de partage, Consignes, Galerie photos ordonnées.
- **Verrouillage post-publication** : pour une voiture publiée, les champs techniques sont en lecture seule avec cadenas (`LockedFieldIndicator`) pour les non-admins.
- **Patch sélectif** : n'envoie que les champs modifiés autorisés avec `lock_version`.
- **Gestion de concurrence 409** : si le véhicule a été modifié en parallèle, invite l'utilisateur à recharger les données fraîches sans perdre brutalement son travail.
- **Gestion du timeout & Clé d'idempotence** : conserve l'UUID de création pour permettre une ré-émission sans créer de doublon.

---

### 5.3 Fiche de Gestion & Suspension (`OwnerVehicleDetailScreen` & `VehicleSuspensionDialog`)
- **Bouton de suspension** ouvrant `VehicleSuspensionDialog` :
  - Présentation explicite du bilan :
    - *"1 prêt actuellement en cours continuera normalement."*
    - *"2 réservations futures confirmées restent maintenues."*
    - *"Aucune nouvelle réservation ne sera possible tant que le véhicule sera suspendu."*
  - Saisie optionnelle du motif.
  - Bouton de confirmation non réentrant.
- **Bouton de rétablissement** : réactive immédiatement le véhicule dans son calendrier initial.
- **Prévisualisation & Publication** : affichage du rendu public et détection des critères manquants avant appel de `PUT /publish`.

---

## 6. Invalidation Coordonnée des Providers Riverpod Réels

À chaque création, mise à jour, suspension, réactivation ou publication :
```dart
// 1. Liste de la flotte propriétaire
ref.invalidate(ownerFleetControllerProvider);

// 2. Fiche détaillée du véhicule
ref.invalidate(loanableDetailProvider(loanableId));

// 3. Liste Explorer publique
ref.invalidate(loanablesListControllerProvider);

// 4. Fenêtres et règles de disponibilité
ref.invalidate(loanableAvailabilityPeriodProvider(loanableId));
ref.invalidate(loanableAvailabilityWindowProvider);
```

---

## 7. Stratégie de Tests & Matrice d'Acceptation

### 7.1 Tests Backend (Laravel / Docker PHPUnit)

| Test | Fichier | Objectif vérifié |
|---|---|---|
| `testOwnerFleetReturnsOnlyManagedVehiclesUnderAuthApi` | `tests/Integration/Fleet/OwnerFleetTest.php` | Filtrage strict `scopeManagedBy` sous middleware `auth:api` |
| `testAdminSeesAllVehiclesInOwnerFleet` | `tests/Integration/Fleet/OwnerFleetTest.php` | Un administrateur consulte tous les véhicules |
| `testCreateLoanableRejectsDifferentOwnerForNonAdmin` | `tests/Integration/Fleet/OwnerFleetTest.php` | Rejet 403 si un non-admin tente d'assigner un tiers comme `owner_user.id` |
| `testCreateLoanableWithIdempotencyKeyPreventsDuplicate` | `tests/Integration/Fleet/OwnerFleetTest.php` | Rejeu avec même `idempotency_key` renvoie le véhicule existant sans créer de doublon |
| `testUpdatePublishedCarLocksProtectedFieldsForNonAdmin` | `tests/Integration/Fleet/OwnerFleetTest.php` | Rejet 422 si modification de marque/moteur sur auto publiée |
| `testUpdateWithOutdatedLockVersionReturns409Conflict` | `tests/Integration/Fleet/OwnerFleetTest.php` | Rejet 409 si `lock_version` périmé par une modification concurrente |
| `testSuspendLoanableSetsIsSuspendedWithoutAlteringCalendarRules` | `tests/Integration/Fleet/OwnerFleetTest.php` | `is_suspended = true`, `availability_mode` et `availability_json` préservés intacts |
| `testSuspendedLoanableHasNoAvailableIntervals` | `tests/Integration/Fleet/OwnerFleetTest.php` | `isAvailable()` retourne false et endpoint availability retourne aucun créneau |
| `testUnsuspendLoanableRestoresOriginalCalendarInstantly` | `tests/Integration/Fleet/OwnerFleetTest.php` | Rétablissement `is_suspended = false` et récupération du calendrier d'origine |
| `testActiveOngoingLoansAreCountedEvenIfPastReturnDate` | `tests/Integration/Fleet/OwnerFleetTest.php` | Les prêts `Ongoing` en retard sont correctement comptés comme actifs |
| `testPublishValidatesMandatoryDetailsByType` | `tests/Integration/Fleet/OwnerFleetTest.php` | Rejet 422 si plaque/moteur manquant sur voiture |

---

### 7.2 Tests Mobile (Flutter Test)

| Test | Fichier | Objectif vérifié |
|---|---|---|
| `renders fleet vehicle list with correct status badges and counts` | `test/features/fleet/owner_fleet_screen_test.dart` | Affichage des badges Publié, Suspendu, Brouillon et décomptes précis |
| `fleet vehicle decodes sharing_mode and all snake_case fields correctly` | `test/features/fleet/fleet_vehicle_test.dart` | Vérifie le parsing de `sharing_mode`, `active_loans_count`, etc. |
| `form locks published car fields for non-admin user` | `test/features/fleet/vehicle_form_screen_test.dart` | Champs techniques désactivés avec cadenas sur voiture publiée |
| `form handles 409 conflict and offers state reload` | `test/features/fleet/vehicle_form_screen_test.dart` | Réception 409, message d'avertissement et rechargement sans crash |
| `form preserves idempotency key on network retry` | `test/features/fleet/vehicle_form_screen_test.dart` | Maintien de l'UUID en cas de reprise après timeout |
| `suspension dialog displays consequence warning and loan counts` | `test/features/fleet/owner_vehicle_detail_screen_test.dart` | Bilan clair : prêts en cours et réservations futures préservés |
| `suspension action calls PUT /suspend and invalidates real providers` | `test/features/fleet/owner_vehicle_detail_screen_test.dart` | Invalidation de `loanablesListControllerProvider`, etc. |
| `preview screen displays blocking requirements when incomplete` | `test/features/fleet/vehicle_preview_screen_test.dart` | Bannières des champs manquants avant publication |
