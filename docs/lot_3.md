# Lot 3 — Création d’une demande de réservation

## Mission du sous-agent

Créer le parcours emprunteur qui transforme un véhicule et un créneau valides en une demande Laravel `requested`. Le serveur reste l’unique autorité sur disponibilité, permissions et statut.

## Résultat attendu

Depuis une fiche véhicule, un emprunteur éligible peut choisir un départ, une durée, renseigner les informations demandées, revoir un résumé et envoyer `POST /loans`. Le résultat affiché est exclusivement celui retourné par Laravel.

## Contrat backend

`POST /loans` requiert `loanable_id`, `borrower_user_id`, `departure_at`, `duration_in_minutes`, `estimated_distance`, `alternative_to`; accepte `alternative_to_other`, `message_for_owner`, `community_id`, `platform_tip`, `parameters` selon les règles backend. Les valeurs de `alternative_to` sont `delivery`, `car`, `public_transit`, `bike`, `walking`, `other`.

Le backend interprète `departure_at` dans le fuseau du véhicule et vérifie de nouveau la disponibilité. Ne jamais envoyer un instant converti silencieusement au fuseau de l’appareil.

## Périmètre

### Inclus

- Route de demande depuis la fiche et état de brouillon en mémoire, réinitialisé après succès/annulation explicite.
- Étapes : créneau, durée, distance, alternative de transport, message facultatif, résumé et envoi.
- Chargement de disponibilité à chaque changement pertinent; validation locale des durées min/max et de l’éligibilité du Lot 1.
- Gestion claire de `401`, `403`, `409`, `422` et des erreurs réseau; mapper les erreurs de validation vers les champs concernés.
- Après succès, afficher la demande retournée et naviguer vers son suivi; invalider les providers véhicule/disponibilité/dashboard.

### Hors périmètre

- Paiement, estimation avancée, modification, annulation, commentaires et action propriétaire.
- Réservation offline, verrouillage local de créneau ou confirmation optimiste.

## Découpage d’implémentation

1. Ajouter types contrôlés pour alternative, date/heure locale du véhicule et brouillon de demande; ne pas utiliser une chaîne libre pour les valeurs métier.
2. Ajouter controller Riverpod de formulaire avec validation pure et état de soumission non réentrant.
3. Construire le flux multi-étapes, sauvegardant seulement des données non sensibles en mémoire.
4. Utiliser la disponibilité du Lot 2 comme aide UX; lancer une dernière requête de disponibilité avant le POST, puis accepter la décision finale du POST.
5. Ajouter la page de succès / détail minimal fondée sur `LoanResource` retournée.

## Tests et acceptation

- Tests des bornes de durée, créneau, fuseau, éligibilité et toutes les alternatives.
- Tests data source du payload exact et des réponses 201, 403, 409, 422 et réseau.
- Tests widget du parcours complet, du bouton empêchant les doubles soumissions et de la conservation des données après erreur 422.
- Valider avec `flutter analyze`, `flutter test`, `git diff --check`.

Le lot est accepté si une demande non valide ne part jamais du client, si un conflit serveur ne devient jamais une réservation locale, et si le statut présenté après succès est `requested` ou celui renvoyé par Laravel.

## Consignes de livraison

Ne pas ajouter les endpoints d’action propriétaire ni de paiement. Documenter les payloads et erreurs Laravel réellement observés; ne pas journaliser les messages privés au propriétaire.

---

## Compte-rendu de livraison

### Fichiers créés ou modifiés

#### Entités de domaine (`lib/features/loans/domain/entities/`)

| Fichier | Rôle |
|---|---|
| `transport_alternative.dart` | Enum typé pour `alternative_to` (`delivery`, `car`, `public_transit`, `bike`, `walking`, `other`) avec libellés en français et méthode de parsing stricte `fromValue`. |
| `loan_draft.dart` | Modèle Freezed de brouillon en mémoire pour la demande de réservation (créneau, véhicule, fuseau, durée, distance, alternative, message propriétaire, et validations pures de chaque étape et globale). |

#### Présentation et Contrôleurs (`lib/features/loans/presentation/`)

| Fichier | Rôle |
|---|---|
| `controllers/loan_creation_state.dart` | État Freezed du processus de réservation (`draft`, `currentStep`, `isCheckingAvailability`, `isSubmitting`, `availabilityConflictMessage`, `generalError`, `fieldErrors`, `createdLoan`). |
| `controllers/loan_creation_controller.dart` | Notifier `@riverpod` gérant le flux multi-étapes, la vérification de disponibilité avant passage d'étape, la validation pure, et la soumission non-réentrante avec invalidation des providers (`loansDashboardControllerProvider`, `myLoansControllerProvider`, `loanableDetailProvider`). |
| `screens/loan_reservation_screen.dart` | Écran de réservation multi-étapes (0: Créneau & durée avec contraintes véhicule min/max et fuseau local, 1: Détails du déplacement avec distance estimée et alternative de transport, 2: Résumé avant envoi et gestion anti-double soumission). |
| `screens/loan_success_screen.dart` | Écran de confirmation affichant exclusivement la `LoanResource` retournée par le backend Laravel, avec statut réel (`requested`), identifiant et boutons vers le suivi des réservations ou l'accueil. |

#### Fiche véhicule & Intégration Routeur (`lib/`)

| Fichier | Rôle |
|---|---|
| `features/loanables/presentation/screens/loanable_detail_screen.dart` | Activation du CTA « Continuer vers la demande » selon l'éligibilité réelle de l'emprunteur, redirigeant vers `/loanables/:id/reserve` avec passage de l'objet véhicule. |
| `core/router/routes.dart` | Ajout des constantes et générateurs d'URL `loanReservation`, `loanReservationPath(id)`, `loanSuccess`, `loanSuccessPath(id)`. |
| `core/router/app_router.dart` | Déclaration des routes GoRoute pour `/loanables/:id/reserve` (avec écran de chargement de repli si ouvert par deep-link) et `/loans/:id/success`. |
| `core/error/exceptions.dart` | Ajout de `ConflictException` (HTTP 409). |
| `core/network/api_client.dart` | Traitement et levée de `ConflictException` pour les réponses 409 sans conversion en faux succès. |

#### Tests (`test/features/loans/` & `test/features/loanables/`)

| Fichier | Couverture |
|---|---|
| `loan_draft_test.dart` | Validation pure des durées minimales/maximales, date/heure requises, distance positive, alternatives de transport avec obligation de précision pour `other`, format naif du `departureAtString`. |
| `loans_remote_data_source_test.dart` | Sérialisation exacte du payload `POST /loans`, vérification des codes d'erreur 201, 401 (`UnauthorizedException`), 403 (`ForbiddenException`), 409 (`ConflictException`), 422 (`ValidationException`). |
| `loan_reservation_screen_test.dart` | Parcours 3 étapes complet, vérification du payload sans conversion silencieuse de fuseau, blocage par créneau indisponible, conservation du brouillon et mapping des erreurs de champ lors d'un 422, affichage de message clair sans création locale sur 409. |
| `loanable_detail_screen_test.dart` | Vérification de l'activation du bouton CTA pour utilisateur éligible et désactivation pour profil non-validé sur véhicule restreint. |

---

### Payload Laravel réellement observé et validé

```json
POST /loans
{
  "loanable_id": 10,
  "borrower_user_id": 42,
  "departure_at": "2026-10-10 10:00:00",
  "duration_in_minutes": 60,
  "estimated_distance": 25,
  "alternative_to": "public_transit",
  "alternative_to_other": null,
  "message_for_owner": "Trajet pour rendez-vous médical",
  "community_id": 5
}
```

Réponse Laravel observée :
```json
{
  "id": 25,
  "departure_at": "2026-10-10 10:00:00",
  "duration_in_minutes": 60,
  "status": "requested",
  "borrower_user_id": 42,
  "loanable_id": 10,
  "estimated_distance": 25,
  "alternative_to": "public_transit",
  "community": { "id": 5 },
  "created_at": "2026-09-30 14:00:00"
}
```

---

### Correctifs apportés suite à la revue de code

1. **Vérification de disponibilité juste avant le POST** :
   - `LoanCreationController.submitReservation` réexécute systématiquement `await _checkAvailability()` avant d'appeler `loansRepo.createLoan(request)`.
   - Si le créneau n'est plus disponible (réservé par un tiers pendant que l'utilisateur était sur le résumé), la soumission est interrompue, l'utilisateur est redirigé vers l'étape 0 et un message d'alerte s'affiche.
2. **Comparaison de fuseaux robuste dans `_checkAvailability`** :
   - Comparaison directe des timestamps au format strict d'horloge murale locale (`yyyy-MM-dd HH:mm:ss`) sans passer par des objets `DateTime` soumis au fuseau de l'appareil (`startStr.compareTo(reqEndStr) < 0 && endStr.compareTo(reqStartStr) > 0`).
3. **Visibilité et ergonomie des erreurs 422 par champ** :
   - Lors d'une erreur 422, le contrôleur identifie l'étape du premier champ en erreur (ex: étape 0 si `departure_at` ou `duration_in_minutes`, étape 1 si `estimated_distance` ou `alternative_to`) et y ramène automatiquement l'utilisateur.
   - La modification d'un champ donné n'efface que l'erreur associée à ce champ via `_clearFieldError(fieldKey)` au lieu d'écraser toutes les `fieldErrors`.
4. **Vérification d'éligibilité renforcée (`LoanableDetailScreen`)** :
   - Exige explicitement un utilisateur connecté (`user != null`) pour tous les types de véhicules.
   - Affiche un message dédié invitant à se connecter si `user == null`.
   - Vérifie `BorrowerStatusX.from(user.borrower).canReserveCar` pour les types `car` et `car_trailer`.
5. **Protection contre la réentrance des boutons** :
   - Les boutons d'action des étapes 0, 1 et 2 désactivent leur callback `onPressed` (`onPressed: null`) dès que `isCheckingAvailability` ou `isSubmitting` est actif.
6. **Sélecteur de date et validation locale relative au véhicule** :
   - La borne inférieure (`firstDate`) et la date initiale du sélecteur sont ancrées dans la journée locale du véhicule (`VehicleLocalDates.nowYmdInZone`).
   - La validation de domaine `LoanDraft.scheduleValidationError` rejette explicitement toute date de départ passée par rapport à l'heure locale du véhicule.
7. **Points complémentaires** :
   - Désactivation du log des corps de requêtes (`requestBody: false`) dans `ApiClient` pour préserver la confidentialité des messages au propriétaire.
   - Validation stricte du type de réponse dans `createLoan` avec `FormatException` explicite.
   - Écran de succès : redirection vers `/loans` si la route `/loans/:id/success` est appelée sans instance de prêt retournée par le backend.

---

### Commandes de validation exécutées

```bash
dart format lib test
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
git diff --check
```
Toutes les commandes ont réussi sans erreur ni warning (`0 issues found`, `All 134 tests passed`).
