# Spécification Technique & Cadrage — Lot 15 (Incidents et signalements)

Ce document formalise l'architecture, l'analyse exhaustive du système d'incidents existant (`IncidentController`, `Incident`, `IncidentPolicy`), les contrats d'API backend et mobile, le mapping précis des catégories (dommages, pannes, crevaisons, retards), la politique de non-blocage abusif, la gestion des consignes d'urgence et contacts configurés, l'intégration des notifications push Zero PII côté serveur, l'architecture Flutter (Riverpod, GoRouter, widgets de signalement et de suivi), ainsi que la matrice de tests pour le **Lot 15** du projet LocoMotion.

---

## 1. Mission & Périmètre du Lot 15

### 1.1 Mission du sous-agent
Permettre à un emprunteur, un propriétaire ou un co-propriétaire de déclarer un dommage, une avarie, une panne ou un retard, et d'avertir les intervenants légitimes avec traçabilité complète, sans créer de blocage intempestif ni impacter silencieusement les réservations futures ou la caution :
1. **Documenter exhaustivement le schéma existant** de l'entité `Incident` et `IncidentNote`, ainsi que les policies associées (`backend/app/Models/Policies/IncidentPolicy.php`).
2. **Définir un mapping rigoureux des catégories du brief** (`dommage`, `crevaison`, `panne`, `retard`, `accident`, `autre`) vers l'énumération backend existante (`accident`, `small_incident`, `general`), en s'assurant qu'un retard ne devienne jamais un accident ni ne provoque de blocage automatique.
3. **Afficher un avertissement clair et des consignes d'urgence** : rappeler que l'application n'est pas un service d'assistance routière d'urgence 24/7 et afficher les numéros d'urgence (112 / 911) ainsi que les contacts configurés du propriétaire ou de la communauté.
4. **Permettre l'ajout de preuves photographiques** via le contrat autorisé existant (`POST /api/v1/images`), sans inventer de routes non autorisées.
5. **Permettre le suivi chronologique, l'ajout de notes et la résolution** selon les rôles stricts : un emprunteur peut reporter et ajouter des notes, mais ne peut ni résoudre, ni réassigner, ni rouvrir un incident (droits réservés aux propriétaires, assignés et administrateurs).
6. **Brancher les notifications push côté serveur** sur `IncidentCreatedEvent` à destination exclusive des propriétaires, co-propriétaires et administrateurs de la communauté concernée (en excluant formellement le déclarant et sans polluer les administrateurs globaux sans justification), avec garantie Zero PII.
7. **Assurer la résilience réseau** : gestion des timeouts, aucune création de doublon lors des réessais, confirmation visuelle du statut d'incident, et consultation possible même en cas d'échec de distribution du push.
8. **Relier le blocage au calendrier et aux prêts affectés** : interdire l'annulation automatique d'un prêt futur sans intervention humaine et interdire toute capture automatique de caution lors d'un incident.

---

### 1.2 Périmètre inclus

1. **Backend Laravel (`backend/app/`)** :
   - Enrichissement du contrôleur `IncidentController` :
     - Ajout de l'endpoint standard `GET /api/v1/incidents/{incident}` avec filtrage de sécurité et masquage des détails (`details_hidden`) pour les utilisateurs non autorisés.
     - Conservation stricte des mutations existantes : `POST /incidents`, `PUT /incidents/{id}`, `PUT /incidents/{id}/complete`, `PUT /incidents/{id}/reopen`, `POST /incidents/{id}/note`, `PUT /incidents/{id}/note/{note}`, `DELETE /incidents/{id}/note/{note}`, `PUT /incidents/{id}/block`, `PUT /incidents/{id}/assignee`, `PUT /incidents/{id}/subscription`.
   - Création du listener de push notifications `SendIncidentCreatedPushNotification` branché sur `IncidentCreatedEvent` :
     - Destinataires : Propriétaires et co-propriétaires du véhicule (`$loanable->mergedUserRoles`), et administrateurs de la communauté si un prêt est associé (`$incident->loan->community_id`).
     - Exclusion absolue de l'utilisateur ayant signalé l'incident (`reported_by_user_id`).
     - Non-diffusion aux administrateurs globaux système pour éviter le spam.
     - Payload Zero PII : Titre neutre `"LocoMotion"`, corps `"Signalement d'incident sur votre véhicule"`, données techniques `event_type: "incident_created"`, `incident_id`, `loanable_id`, `loan_id`.
     - Isolation totale dans un bloc `try/catch` avec log applicatif, évitant toute rupture de transaction en cas d'erreur FCM.
   - Respect strict de `LoanPolicy@cancel` : maintien de l'autorisation d'annulation d'un prêt payant en cours pour un emprunteur si et seulement si un incident actif et bloquant couvre le prêt.

2. **Mobile Flutter (`mobile/lib/features/incidents/`)** :
   - **Écran de signalement (`IncidentReportScreen`)** :
     - Accessible depuis :
       - Fiche réservation ([`LoanDetailScreen`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart)).
       - Fiche véhicule ([`LoanableDetailScreen`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loanables/presentation/screens/loanable_detail_screen.dart)).
       - Fiche gestion de flotte ([`OwnerVehicleDetailScreen`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/fleet/presentation/screens/owner_vehicle_detail_screen.dart)).
       - Écran de profil / Aide ([`ProfileScreen`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/profile/presentation/screens/profile_screen.dart)).
       - État des lieux retour ([`LoanReturnInspectionScreen`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loan_return_inspection_screen.dart)).
     - Préremplissage contextuel des identifiants (`loan_id`, `loanable_id`).
     - Sélecteur de motif d'incident à 6 options claires avec description et icônes.
     - Bannière d'urgence et numéros d'assistance (112 / 911 / coordonnées propriétaire).
     - Description détaillée obligatoire (minimum 10 caractères, sans informations sensibles).
     - Prise de photo ou sélection galerie (upload via `POST /api/v1/images`).
     - Protection non-réentrante du bouton d'envoi et récupération sur timeout.
   - **Écran de détail & Suivi d'incident (`IncidentDetailScreen`)** :
     - Accessible via la route `/incidents/:id` (compatible deep-linking des push notifications).
     - Badge de statut dynamique (`En cours`, `Résolu`, `Bloquant jusqu'au ...`).
     - Section détails : type, date de déclaration, auteur, véhicule concerné, prêt lié le cas échéant.
     - Fil chronologique des notes et échanges (`IncidentNotesTimeline`).
     - Champ / modal d'ajout de note (`AddNoteBottomSheet`) pour les intervenants autorisés.
     - Actions soumises à permissions : bouton "Résoudre l'incident" visible et actif uniquement pour les propriétaires, assignés ou admins (masqué ou désactivé pour l'emprunteur).
   - **Écran de liste des incidents (`IncidentsListScreen`)** :
     - Liste des incidents liés à un véhicule ou à un utilisateur, avec filtres par statut (`En cours`, `Résolus`).

---

### 1.3 Hors périmètre
- Constitution d'un dossier complet d'assurance ou de constat amiable légal.
- Expertise automobile contradictoire ou mandatement d'experts agréés.
- Télémétrie GPS en temps réel ou tracking continu du véhicule.
- Capture automatique de la caution financière ou prélèvement bancaire automatique de pénalités.

---

## 2. Analyse Approfondie du Moteur d'Incidents Laravel

### 2.1 Modèle de Données `incidents`

| Colonne | Type | Nullable | Rôle Métier |
|---|---|---|---|
| `id` | `bigint unsigned` | Non | Identifiant primaire de l'incident. |
| `loanable_id` | `bigint unsigned` | Non | Clé étrangère vers le véhicule (`loanables.id`). |
| `loan_id` | `bigint unsigned` | Oui | Clé étrangère optionnelle vers le prêt lié (`loans.id`). |
| `incident_type` | `enum('accident','small_incident','general')` | Non | Type d'incident natif dans la base de données. |
| `comments_on_incident` | `text` | Non | Description détaillée initiale de l'incident. |
| `status` | `string` | Non | Statut courant : `'in_process'` ou `'completed'`. |
| `executed_at` | `timestamp` | Oui | Horodatage de passage à `'completed'` (null si `'in_process'`). |
| `reported_by_user_id` | `bigint unsigned` | Non | Utilisateur déclarant (emprunteur, propriétaire ou admin). |
| `resolved_by_user_id` | `bigint unsigned` | Oui | Utilisateur ayant résolu l'incident (null si réouvert). |
| `assignee_id` | `bigint unsigned` | Oui | Utilisateur en charge du traitement de l'incident. |
| `blocking_until` | `timestamp` | Oui | Date jusqu'à laquelle le véhicule est indisponible. |
| `show_details_to_blocked_borrowers` | `boolean` | Non | Si true, les emprunteurs des prêts bloqués peuvent voir les détails. |

---

### 2.2 Modèle de Données `incident_notes`

| Colonne | Type | Nullable | Rôle Métier |
|---|---|---|---|
| `id` | `bigint unsigned` | Non | Identifiant primaire de la note. |
| `incident_id` | `bigint unsigned` | Non | Incident parent (`incidents.id`). |
| `author_id` | `bigint unsigned` | Non | Auteur de la note (`users.id`). |
| `text` | `text` | Non | Contenu textuel de la note (max 10 000 caractères). |
| `created_at` / `updated_at` | `timestamp` | Non | Horodatage de création et mise à jour. |

---

### 2.3 Analyse des Mécanismes Spécifiques de `IncidentController`

1. **Blocage Automatique d'un Jour pour `accident`** :
   ```php
   if ($incident->incident_type === "accident") {
       $incident->blocking_until = CarbonImmutable::now()->addDay();
   }
   ```
   *Impact crucial* : Si le type est `accident`, le serveur impose automatiquement une indisponibilité de 24h sur le véhicule. Par conséquent, les signalements de type **retard**, **crevaison** ou **panne mineure** ne doivent **JAMAIS** être envoyés avec `incident_type = 'accident'`.

2. **Abonnements aux Notifications (`incident_notifications`)** :
   - `subscribeAllConcernedUsers` abonne au niveau `All` les propriétaires, co-propriétaires, l'assigné, l'emprunteur du prêt, et les admins.
   - `syncBlockedBorrowerNotifications` notifie par email les emprunteurs dont les réservations futures chevauchent `[start_at, blocking_until]`.
   - **Protection de la vie privée (`details_hidden`)** : Selon `viewIncidentDetails`, si un utilisateur n'est ni propriétaire, ni assigné, ni l'emprunteur du prêt d'origine, les commentaires et notes lui sont masqués (`details_hidden: true`).

3. **Endpoint de Détail Unique `GET /incidents/{incident}` & Scopes d'Accès** :
   - Le backend expose `GET /api/v1/incidents/{incident}` sous policy `IncidentPolicy@view` (et non `viewIncidentDetails`), permettant aux parties prenantes légitimes d'accéder au statut du véhicule tout en protégeant rigoureusement la vie privée : si l'utilisateur ne satisfait pas `viewIncidentDetails`, la ressource retourne `details_hidden: true` et masque `comments_on_incident`, les notes et les images de preuves.
   - De même, la collection `GET /incidents` applique le scope obligatoire `scopeAccessibleBy($user)` pour empêcher l'exposition d'incidents hors du périmètre de l'utilisateur connecté (déclarant, assigné, résolveur, emprunteur du prêt, gestionnaire/propriétaire du véhicule ou administrateur de communauté).

---

## 3. Mapping des Catégories & Règles de Blocage

### 3.1 Tableau de Mapping Métier $\rightarrow$ Backend

| Catégorie UI Mobile | Libellé Affiché | Description Utilisateur | `incident_type` Backend | Comportement de Blocage | Préfixe Description |
|---|---|---|---|---|---|
| `damage` | **Dommage matériel** | Rayure, choc léger, carrosserie, bris de glace sans immobilisation | `small_incident` | Non bloquant par défaut (`blocking_until = null`) | `[Dommage]` |
| `puncture` | **Crevaison / Pneu** | Pneu crevé, sous-gonflé ou avarie de roue | `small_incident` | Non bloquant par défaut (`blocking_until = null`) | `[Crevaison]` |
| `breakdown` | **Panne mécanique** | Problème moteur, batterie à plat, freins, transmission | `small_incident` | Non bloquant par défaut (ou blocage manuel par propriétaire) | `[Panne]` |
| `delay` | **Retard de restitution** | Impossibilité de rendre le véhicule à l'heure convenue | `general` | **Strictement non bloquant** (`blocking_until = null`) | `[Retard]` |
| `accident` | **Accident / Collision** | Collision avec un tiers, choc violent ou immobilisation totale | `accident` | **Bloquant 24h automatique** par le serveur | `[Accident]` |
| `other` | **Autre problème** | Propreté, accessoire manquant, odeur ou litige | `general` | Non bloquant par défaut (`blocking_until = null`) | `[Autre]` |

> [!IMPORTANT]
> Un retard de restitution (`delay`) est mappé vers `general`. Il n'est en aucun cas considéré comme un `accident`, ce qui préserve le calendrier public et les réservations suivantes d'un blocage intempestif d'une journée.

---

### 3.2 Preuves Photographiques & Rattachement Persistant

1. **Téléversement Initial** :
   - L'application téléverse chaque photographie via le contrat autorisé existant `POST /api/v1/images` (multipart `image`).
   - L'image est stockée temporairement dans le répertoire de l'utilisateur (`/images/tmp/{userId}/...`).
2. **Rattachement Persistant Polymorphique (`image_ids`)** :
   - Lors de la soumission de l'incident (`POST /api/v1/incidents`), le client transmet le tableau `image_ids: [452, 453]`.
   - Le serveur valide l'existence de chaque image et vérifie la stricte appartenance à l'utilisateur courant via regex anti-IDOR (`/images/tmp/{userId}/`).
   - Le modèle `Incident` implémente la relation polymorphique `images(): MorphMany` (`imageable_type = 'incident'`, `field = 'incident_proof'`), enregistrée dans le morph map global `Relation::enforceMorphMap(['incident' => Incident::class])`.
   - Les images validées sont associées atomiquement à l'incident (`$image->imageable()->associate($incident)`), et leur statut devient permanent (`field = 'incident_proof'`), les préservant de la commande de nettoyage automatique `FilesCleanDB`.
3. **Politique d'Accès Sécurisée (`ImagePolicy`)** :
   - Pour toute image rattachée à un incident (`imageable_type === 'incident'`), la consultation (`ImagePolicy@view`) délègue strictement à `IncidentPolicy@viewIncidentDetails`.
   - Les photographies de dégâts ne sont jamais exposées publiquement aux simples visiteurs du catalogue de véhicules.
4. **Consultation et Rendu Mobile** :
   - L'API expose les images via `IncidentResource` (`images: ImageResource::collection(...)`).
   - L'écran mobile `IncidentDetailScreen` affiche une galerie horizontale avec vignettes sécurisées (`LoanableImageWidget` / `Image.network` authentifié) et modale de prévisualisation plein écran (`_showPhotoPreview`).
   - Pour la rétrocompatibilité avec les signalements passés, l'extraction textuelle regex `[Preuves: image_id#...]` reste maintenue comme fallback.

---

## 4. Consignes d'Urgence & Contacts Configurés

L'interface de déclaration d'incident intègre une composante d'urgence bien en évidence avant tout envoi :

```
┌─────────────────────────────────────────────────────────────┐
│ ⚠️  AVERTISSEMENT D'URGENCE                                 │
│ Ce formulaire sert à documenter un incident pour la         │
│ communauté et le propriétaire. Il NE constitue PAS un       │
│ service d'assistance de secours 24h/24 ou d'urgence vitale. │
│                                                             │
│ • En cas de danger ou d'accident corporel :                 │
│   Appelez immédiatement le 112 (Europe) ou 911 (Am. Nord)   │
│                                                             │
│ • Coordonnées du propriétaire :                             │
│   Jean Dupont — 📞 +1 514 555-0199 / ✉️ jean@example.com   │
└─────────────────────────────────────────────────────────────┘
```

1. **Case à cocher d'attestation** :
   Pour les signalements de catégorie `accident` ou `breakdown`, l'utilisateur doit cocher une case attestant qu'il est en sécurité ou que les secours ont été prévenus si nécessaire.
2. **Accessibilité immédiate des contacts** :
   Boutons d'action directs pour composer le numéro de téléphone du propriétaire (`tel:`) ou lui envoyer un courriel (`mailto:`).

---

## 5. Rôles, Politiques d'Autorisation & Matrice des Droits

Le tableau suivant récapitule les droits d'accès définis dans `backend/app/Models/Policies/IncidentPolicy.php` et leur transcription dans l'application mobile :

| Action / Endpoint | Emprunteur du Prêt | Propriétaire / Co-proprio / Manager | Assigné | Admin Communauté | Admin Global |
|---|---|---|---|---|---|
| **Créer un incident** (`POST /incidents`) | ✅ (sur son prêt, avec `$loan->loanable_id === $loanable->id`) | ✅ (sur son véhicule) | ❌ | ✅ (sur sa communauté) | ✅ |
| **Voir les détails complets** (`comments`, notes, photos) | ✅ (sur son prêt) | ✅ (sur son véhicule) | ✅ | ✅ (sur sa communauté) | ✅ |
| **Voir incident sans détails** (`details_hidden`) | ✅ (si prêt bloqué ou membre) | ✅ | ✅ | ✅ | ✅ |
| **Modifier la description** (`PUT /incidents/{id}`) | ✅ (uniquement si déclarant) | ✅ (uniquement si déclarant) | ❌ | ❌ | ✅ |
| **Ajouter une note** (`POST /incidents/{id}/note`) | ❌ (✅ uniquement si déclarant) | ✅ | ✅ | ✅ (du prêt lié) | ✅ |
| **Modifier sa note** (`PUT /notes/{id}`) | ✅ (sa propre note) | ✅ (sa propre note) | ✅ (sa note) | ✅ (sa note) | ✅ |
| **Supprimer sa note** (`DELETE /notes/{id}`) | ✅ (sa propre note) | ✅ (sa propre note) | ✅ (sa note) | ✅ (sa note) | ✅ |
| **Résoudre l'incident** (`PUT /complete`) | ❌ **Interdit** | ✅ | ✅ | ✅ (du prêt lié) | ✅ |
| **Rouvrir l'incident** (`PUT /reopen`) | ❌ **Interdit** | ✅ | ✅ | ✅ (du prêt lié) | ✅ |
| **Changer l'assigné** (`PUT /assignee`) | ❌ **Interdit** | ✅ | ✅ | ✅ (du prêt lié) | ✅ |
| **Modifier le blocage** (`PUT /block`) | ❌ **Interdit** | ✅ | ✅ | ✅ (du prêt lié) | ✅ |

> [!IMPORTANT]
> **Permissions Calculées par le Serveur (`IncidentResource`)** :
> Pour éviter tout écart entre le backend Laravel et le client mobile (notamment sur les rôles gestionnaires `manager` ou administrateurs locaux), la ressource renvoie les drapeaux calculés par les policies Laravel :
> - `can_resolve` : `$user->can('complete', $incident)`
> - `can_add_note` : `$user->can('addNote', $incident)`
> - `can_reopen` : `$user->can('reopen', $incident)`
> - `can_change_assignee` : `$user->can('changeAssignee', $incident)`
> L'écran `IncidentDetailScreen` privilégie directement `incident.canResolveServer` avant d'évaluer le fallback local des rôles.

> [!CAUTION]
> L'emprunteur n'a JAMAIS le droit de résoudre (`complete`) ou de rouvrir (`reopen`) un incident. L'interface mobile masque ces boutons d'action dès lors que l'utilisateur connecté ne détient pas la permission requise. De plus, un emprunteur ne peut ajouter des notes que s'il est le déclarant de l'incident (`reported_by_user_id`), conformément à `IncidentPolicy@addNote`.

---

## 6. Notifications Push Serveur (Zero PII & Anti-Spam)

### 6.1 Listener `SendIncidentCreatedPushNotification`
Un nouveau listener Laravel est créé dans `backend/app/Listeners/SendIncidentCreatedPushNotification.php` et enregistré dans `EventServiceProvider` pour écouter `IncidentCreatedEvent`.

#### Règles d'adressage strictes :
1. **Destinataires autorisés** :
   - Propriétaires et co-propriétaires du véhicule (`$incident->loanable->mergedUserRoles`).
   - Administrateurs de la communauté rattachée au prêt (`User::adminOfCommunity(...)`) si `loan_id` est renseigné.
2. **Exclusions obligatoires** :
   - L'utilisateur ayant soumis l'incident (`reported_by_user_id`).
   - Les administrateurs globaux système (sauf s'ils sont explicitement propriétaires ou assignés du véhicule), afin de prévenir tout spam sur l'ensemble de la flotte.
3. **Déduplication** :
   - Utilisation de `unique('id')` sur la collection des destinataires avant envoi.

#### Contrat de Payload Push Zero PII :
```json
{
  "notification": {
    "title": "LocoMotion",
    "body": "Activité sur votre véhicule"
  },
  "data": {
    "schema_version": "1",
    "event_type": "incident_created",
    "incident_id": "84",
    "loanable_id": "12",
    "loan_id": "105"
  }
}
```

*Garanties fondamentales* :
- **Aucune donnée sensible** (aucun nom de personne, commentaire, description de dommage ou coordonnée) dans le payload push transitant par Google FCM ou Apple APNs.
- **Support des incidents hors prêt** : `loan_id` peut être nul dans le payload si l'incident est déclaré directement sur un véhicule de la flotte par un gestionnaire. Le parseur mobile `PushPayload.tryParse` exige impérativement un `incident_id > 0`.
- **Deep-linking direct** : Le contrôleur des notifications (`NotificationsController`) route immédiatement vers `/incidents/:id` (`AppRoutes.incidentDetailPath(payload.incidentId)`). Si l'utilisateur n'est pas authentifié, la redirection est stockée dans `pendingRedirectPath` pour être consommée après la connexion.

---

## 7. Contrats d'API Backend

### 7.1 Déclaration d'Incident (`POST /api/v1/incidents`)

#### Validation Métier & Sécurité Anti-Fraude
Avant toute création, le contrôleur valide :
1. **Association véhicule / prêt** : Si `loan_id` est renseigné, le serveur vérifie impérativement que `$loan->loanable_id === $loanable->id`. En cas de discordance, la requête est rejetée avec une erreur `422 Unprocessable Entity` ("Le prêt fourni ne correspond pas à ce véhicule").
2. **Clé d'Idempotence** : Le client transmet un en-tête `Idempotency-Key` (ou le champ `idempotency_key`). Le backend stocke la réponse en cache (`Cache::put("incident_idempotency_...", $incidentResource, 300)`). Si une même clé est soumise à nouveau (ex: après un timeout réseau), l'incident existant est retourné sans duplication ni réémission de push.
3. **Rattachement des preuves** : Les identifiants `image_ids` sont validés contre le répertoire temporaire de l'utilisateur (`/images/tmp/{userId}/`). Les images sont associées atomiquement avec `field = 'incident_proof'`.

#### Request
```http
POST /api/v1/incidents HTTP/1.1
Content-Type: application/json
Authorization: Bearer <token>
Idempotency-Key: 7b6e921d-9e3f-4221-81bf-653a1a1f0a50

{
  "loanable_id": 12,
  "loan_id": 105,
  "incident_type": "small_incident",
  "comments_on_incident": "[Dommage] Rétroviseur droit fissuré lors d'une manœuvre de stationnement.",
  "image_ids": [452, 453],
  "idempotency_key": "7b6e921d-9e3f-4221-81bf-653a1a1f0a50",
  "blocking_until": null,
  "show_details_to_blocked_borrowers": true
}
```

#### Response (201 Created)
```json
{
  "id": 84,
  "created_at": "2026-10-04T13:45:00.000000Z",
  "executed_at": null,
  "updated_at": "2026-10-04T13:45:00.000000Z",
  "status": "in_process",
  "incident_type": "small_incident",
  "blocking_until": null,
  "is_blocking": false,
  "start_at": "2026-10-04T13:45:00.000000Z",
  "loan_id": 105,
  "loan_community_id": 3,
  "loanable_id": 12,
  "comments_on_incident": "[Dommage] Rétroviseur droit fissuré lors d'une manœuvre de stationnement.",
  "assignee_id": null,
  "show_details_to_blocked_borrowers": true,
  "details_hidden": false,
  "can_resolve": true,
  "can_add_note": true,
  "can_reopen": false,
  "can_change_assignee": true,
  "images": [
    {
      "id": 452,
      "field": "incident_proof",
      "url": "http://localhost:8000/api/v1/images/452"
    }
  ],
  "reported_by_user": {
    "id": 42,
    "first_name": "Alice",
    "last_name": "Tremblay",
    "avatar": null
  },
  "notes": []
}
```

---

### 7.2 Consultation de Détail (`GET /api/v1/incidents/{incident}`)

#### Request
```http
GET /api/v1/incidents/84 HTTP/1.1
Authorization: Bearer <token>
```

#### Response (200 OK)
Même structure que ci-dessus, protégée par `IncidentPolicy@view`.
- **Si l'utilisateur détient les droits `viewIncidentDetails`** : Les champs complets (`comments_on_incident`, `notes`, `images`) sont renvoyés et `details_hidden: false`.
- **Si l'utilisateur ne détient que le droit `view` général** : `details_hidden: true`, les commentaires textuels sont masqués, `notes` et `images` sont vidés pour respecter la vie privée.

---

### 7.3 Liste des Incidents (`GET /api/v1/incidents`)

#### Paramètres de Requête (Filtres Plats)
Le backend utilise des filtres de requête plats (et non le formalisme imbriqué `filter[...]`) :
```http
GET /api/v1/incidents?loan_id=105&loanable_id=12&per_page=50 HTTP/1.1
Authorization: Bearer <token>
```

#### Cloisonnement des Données (`scopeAccessibleBy`)
Le backend applique systématiquement le scope d'autorisation obligatoire :
```php
$incidents = Incident::query()->accessibleBy($request->user());
```
Ce scope restreint la vue aux incidents où l'utilisateur est soit :
- Le déclarant (`reported_by_user_id`),
- L'assigné (`assignee_id`) ou le résolveur (`resolved_by_user_id`),
- L'emprunteur du prêt d'origine (`loans.borrower_user_id`),
- Le propriétaire, co-propriétaire ou gestionnaire du véhicule (`loanables` rôles `owner`, `coowner`, `manager`),
- L'administrateur de la communauté concernée.
Aucun incident tiers n'est ainsi divulgué, même en l'absence de paramètres de filtrage dans l'URL.

---

### 7.4 Ajout d'une Note (`POST /api/v1/incidents/{incident}/note`)

#### Request
```http
POST /api/v1/incidents/84/note HTTP/1.1
Content-Type: application/json
Authorization: Bearer <token>

{
  "text": "Le rétroviseur de remplacement a été commandé auprès du garage agréé."
}
```

#### Response (201 Created)
```json
{
  "id": 19,
  "incident_id": 84,
  "author_id": 8,
  "text": "Le rétroviseur de remplacement a été commandé auprès du garage agréé.",
  "created_at": "2026-10-04T14:10:00.000000Z",
  "updated_at": "2026-10-04T14:10:00.000000Z",
  "author": {
    "id": 8,
    "first_name": "Marc",
    "last_name": "Propriétaire",
    "avatar": null
  }
}
```

---

### 7.5 Résolution de l'Incident (`PUT /api/v1/incidents/{incident}/complete`)

#### Request
```http
PUT /api/v1/incidents/84/complete HTTP/1.1
Authorization: Bearer <token>
```

#### Response (200 OK)
Renvoie la ressource de l'incident avec `status: "completed"`, `executed_at: "<timestamp>"`, `resolved_by_user_id: <user_id>`, et `blocking_until: null`.

---

## 8. Architecture Mobile Flutter

### 8.1 Arborescence des Fichiers

```text
mobile/lib/features/incidents/
├── data/
│   ├── datasources/
│   │   └── incident_remote_data_source.dart
│   └── repositories/
│       └── incident_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── incident.dart
│   │   ├── incident.freezed.dart
│   │   ├── incident.g.dart
│   │   ├── incident_category.dart
│   │   ├── incident_note.dart
│   │   ├── incident_note.freezed.dart
│   │   └── incident_note.g.dart
│   └── repositories/
│       └── incident_repository.dart
└── presentation/
    ├── controllers/
    │   ├── incident_detail_controller.dart
    │   ├── incident_report_controller.dart
    │   └── incidents_list_controller.dart
    ├── screens/
    │   ├── incident_detail_screen.dart
    │   ├── incident_report_screen.dart
    │   └── incidents_list_screen.dart
    └── widgets/
        ├── add_note_dialog.dart
        ├── emergency_disclaimer_card.dart
        ├── incident_category_picker.dart
        ├── incident_notes_timeline.dart
        └── incident_status_badge.dart
```

---

### 8.2 Contrôleurs Riverpod, Résilience & Nettoyage d'État

1. `incidentReportControllerProvider` (`autoDispose`) :
   - Gère le formulaire de déclaration (sélection de catégorie, préremplissage véhicule/prêt, saisie description, gestion des photos).
   - Génère une clé d'idempotence unique à l'initialisation (`_generateIdempotencyKey()`) et la conserve intacte lors des reprises sur erreur afin de garantir l'absence de doublon côté serveur.
   - En cas d'erreur réseau ou de timeout, le contrôleur passe en état `hasUnknownResult: true`. L'interface affiche alors un bandeau d'avertissement et un bouton de réconciliation ("Vérifier et réconcilier").
   - La méthode `reconcile({loanableId, loanId})` interroge la liste des incidents du véhicule (`GET /incidents?loanable_id=...&loan_id=...`) pour vérifier si le signalement est déjà parvenu au serveur avant de proposer un nouvel envoi.
   - Le provider étant configuré en `autoDispose` et réinitialisé à la fermeture/réouverture de l'écran via `reset()`, aucune donnée résiduelle du signalement précédent (photos, catégorie, description, attestation) n'est conservée par inadvertance pour un véhicule différent.

2. `incidentsListControllerProvider` :
   - Récupère la liste des incidents avec `per_page: 50` pour éviter la troncature silencieuse à 10 éléments.
   - La méthode `updateStatusFilter` utilise `copyWith(filterStatus: status, clearFilter: status == null)` pour garantir que le choix du filtre "Tous" réinitialise véritablement le filtre d'état à `null`.

3. `IncidentRemoteDataSource` :
   - Intercepte `ServerException` avec `statusCode == 404` (et non de simples `DioException` masquées par le client HTTP) pour assurer un repli fonctionnel transparent sur les environnements backend antérieurs.

4. `incidentDetailControllerProvider.family<Incident, int>` :
   - Charge les données fraîches de l'incident et gère l'ajout de notes, la résolution (`complete`) et la réouverture (`reopen`).
   - S'appuie prioritairement sur les permissions calculées par le serveur (`canResolveServer`, `canAddNoteServer`) et intègre le rôle `manager` dans le fallback des rôles locaux.

---

## 9. Matrice de Tests & Plan de Recette

### 9.1 Tests Backend Laravel (`backend/tests/Integration/Incident/IncidentShowAndPushTest.php`)

| Exigence Validée | Scénario de Test | Statut |
|---|---|---|
| Sécurité association prêt / véhicule | `create fails with 422 when loan does not belong to loanable` | ✅ Validé (422) |
| Idempotence des signalements | `create handles idempotency key without duplicate record` | ✅ Validé |
| Rattachement persistant des photos | `create associates uploaded temporary images to incident permanently` | ✅ Validé (MorphMany) |
| Confidentialité des photos d'incident | `image policy restricts incident proof images to incident stakeholders` | ✅ Validé |
| Scopes d'accès à la liste | `index applies scopeAccessibleBy and does not leak third party incidents` | ✅ Validé |
| Détail & Masquage de vie privée | `show returns full details to owner/borrower and masked details to other users` | ✅ Validé (`details_hidden`) |
| Permissions calculées dans la ressource | `show includes server computed permissions can_resolve and can_add_note` | ✅ Validé |
| Envoi des Push Notifications Zero PII | `incident created event triggers push notification to owners and admins` | ✅ Validé (FCM) |
| Exclusion anti-spam du déclarant | `incident created push excludes reporting user from notification recipients` | ✅ Validé |
| Non-blocage des signalements retard | `delay category maps to general without blocking calendar` | ✅ Validé (`blocking_until = null`) |

### 9.2 Tests Mobile Flutter (`mobile/test/features/incidents/` & `notifications/`)

| Fichier de Test | Composant | Scénario |
|---|---|---|
| `incident_entity_test.dart` | `Incident`, `IncidentCategory` | Sérialisation JSON, mapping des catégories, détection des rôles `manager` et prise en compte prioritaire des permissions serveur. |
| `incident_report_screen_test.dart` | `IncidentReportScreen` | Formulaire de signalement, sélection de catégorie, attestation de sécurité obligatoire pour accident. |
| `incident_report_screen_test.dart` | Résilience & Timeout | Affichage du bandeau de réconciliation et du bouton `reconcile_incident_button` en cas de timeout. |
| `incidents_list_screen_test.dart` | `IncidentsListScreen` | Affichage des incidents, pagination et réinitialisation fonctionnelle du filtre "Tous". |
| `incident_detail_screen_test.dart` | `IncidentDetailScreen` | Galerie de photos de preuves, timeline des notes et restriction du bouton "Résoudre" aux rôles autorisés. |
| `push_payload_test.dart` | `PushPayload` | Parsing de l'événement `incident_created`, gestion des prêts optionnels (`loan_id` nullable), validation stricte `incident_id > 0`. |
| `notifications_controller_test.dart` | `NotificationsController` | Routage immédiat et reprise post-connexion vers `/incidents/:id`. |

---

## 10. Synthèse des Choix & Demande de Validation

1. **Catégories & Blocage** :
   - `damage`, `puncture`, `breakdown` $\rightarrow$ `small_incident` (non bloquant).
   - `delay`, `other` $\rightarrow$ `general` (non bloquant).
   - `accident` $\rightarrow$ `accident` (bloquant 24h automatique par le serveur).
2. **Preuves Photographiques Persistantes** : Téléversement via `POST /api/v1/images`, rattachement atomique polymorphique `images(): MorphMany` (`imageable_type = 'incident'`, `field = 'incident_proof'`), protection sous `ImagePolicy@view` via `IncidentPolicy@viewIncidentDetails`, et consultation via galerie mobile `IncidentDetailScreen`.
3. **Endpoint de Détail & Cloisonnement** : `GET /api/v1/incidents/{incident}` sous policy `view` avec masque de confidentialité `details_hidden: true` pour les tiers. Scope obligatoire `scopeAccessibleBy` sur la collection `GET /incidents`.
4. **Idempotence & Résilience** : Gestion des clés d'idempotence côté backend (`Cache::put`) et mobile (`idempotencyKey`), état `hasUnknownResult` en cas de timeout, réconciliation sécurisée avant toute reprise, et réinitialisation automatique du formulaire.
5. **Permissions & Rôles Étendus** : Transmission des permissions dynamiques calculées par le serveur (`can_resolve`, `can_add_note`, `can_reopen`, `can_change_assignee`), prise en charge du rôle `manager` de flotte et validation stricte de l'association prêt/véhicule.
6. **Push FCM Zero PII** : Intégration de l'événement `incident_created`, exclusion du déclarant, adressage aux propriétaires/gestionnaires/admins locaux, et routage direct vers `/incidents/:id`.
