# Lot 6 — Notifications push (FCM)

Ce document formalise la spécification technique et le compte-rendu de recette du Lot 6 (Notifications push via Firebase Cloud Messaging).

---

## Périmètre fonctionnel

Le lot 6 implémente l’envoi et la réception de notifications push pour les événements clés du cycle de vie des prêts :

| Événement | Déclencheur | Destinataire(s) |
|---|---|---|
| `loan_created` | Création d’une demande de réservation | Propriétaire(s) du véhicule |
| `loan_accepted` | Validation de la réservation par le propriétaire | Emprunteur |
| `loan_rejected` | Refus de la réservation par le propriétaire | Emprunteur |
| `loan_canceled` | Annulation de la réservation | L’autre partie (emprunteur ou propriétaire selon qui annule) |
| `loan_comment_added` | Nouveau message dans le fil de discussion | Tous les participants au prêt sauf l’auteur du message |

Les notifications respectent les préférences utilisateur (`loan_notifications.level`) :
- `all` : toutes les notifications sont transmises.
- `messages_only` : seuls les messages (`loan_comment_added`) sont transmis.
- `none` : aucune notification n’est transmise.

Les listeners push sont exécutés **en arrière-plan** (`ShouldQueue` avec `$afterCommit = true` pour attendre la validation de la transaction SQL) sans impacter les listeners d’envoi d’emails existants, qui restent inchangés.

---

## Architecture technique

### Backend (Laravel)

- **Modèle et table** : `UserPushToken` (`user_push_tokens`)
  - `user_id` (clé étrangère cascade)
  - `token` (jeton FCM unique)
  - `platform` (`android` ou `ios`)
  - `installation_id` (identifiant unique de l’installation)
  - `app_version` (version applicative mobile)
  - `last_used_at` (horodatage pour la purge des jetons inactifs)
- **API Tokens** :
  - `POST /api/v1/auth/user/push-tokens` : enregistrement ou rafraîchissement d'un jeton (dédoublonnage strict par `installation_id` dans une transaction SQL).
  - `DELETE /api/v1/auth/user/push-tokens/installations/{installation_id}` : révocation par installation.
  - `DELETE /api/v1/auth/user/push-tokens/{id}` : révocation par ID (404 si étranger).
- **Service d'envoi** : `FcmNotificationService` via `kreait/laravel-firebase` (HTTP v1).
  - Chargement des credentials via `config('firebase.projects.app.credentials')`.
  - Capture de toute exception d'envoi (`\Throwable`) pour ne jamais interrompre la transaction métier.
  - Purge automatique immédiate du token en base si FCM renvoie une erreur d'invalidation (`UNREGISTERED`, `NotFound`, `InvalidMessage`).
  - Commande planifiée `php artisan push:purge-inactive-tokens` (purge des jetons inactifs > 90 jours).

### Mobile (Flutter)

- **Service de notifications** : `PushNotificationService` (interface)
  - Implémentation réelle : `FirebasePushNotificationService` (initialise Firebase Messaging, journalise les erreurs de `getToken()`).
  - Implémentation de test : `FakePushNotificationService` (simulation hermétique des flux de messages et de tokens).
- **Contrôleur Riverpod** : `NotificationsController`
  - Gestion du cycle de vie du token : enregistrement non-réentrant avec file d'attente sur rafraîchissement concurrent (`_queuedToken`), suppression locale et révocation distante au logout.
  - Déduplication mémoire avec TTL de 60 secondes sur `messageId`.
  - Redirection différée post-login (`pendingRedirectPath`) : enregistrée **uniquement** si l'utilisateur est déconnecté lors du tap, consommée à la connexion et vidée au logout.
  - Demande contextuelle de permission post-connexion (`requestPermissionContextual()`), rafraîchissement automatique de permission au retour des réglages système (`WidgetsBindingObserver` sur `ProfileScreen`).
- **Composants d'affichage et navigation** :
  - Premier plan : `ForegroundNotificationBanner` (SnackBar flottant avec bouton « Voir » et invalidation des caches de prêt via `invalidateLoanViews`, sans navigation forcée).
  - Détail du prêt : En cas d'erreur 403 / 404 lors de l'accès à un prêt notifié, affichage du message contrôlé et bouton explicite « Retour au tableau de bord » vers `/loans`.
- **Plateformes natives** :
  - Android : Permission `POST_NOTIFICATIONS`, métadonnées FCM et création explicite du canal de notification `locomotion_loans` (`IMPORTANCE_HIGH`) dans `MainActivity.kt`.
  - iOS : Capability Push Notifications configurée dans `Runner.entitlements` (`aps-environment: development`) et déclarée dans `project.pbxproj` (`CODE_SIGN_ENTITLEMENTS`). `UIBackgroundModes` restreint à `remote-notification` (sans `fetch`).

---

## Compte-rendu de livraison — Lot 6

### 1. Spécification approuvée
- **Document de référence** : [`mobile/docs/lot_6_spec.md`](./lot_6_spec.md)
- **Date d'approbation** : 2026-10-01 (Feu vert du responsable produit après arbitrage des cas limites).

---

### 2. Tableau Exigence → Fichier d'implémentation → Test

| Exigence Lot 6 | Fichier d'implémentation | Fichier de test | Statut |
|---|---|---|---|
| Migration `user_push_tokens`, modèle `UserPushToken`, relation `User` | `backend/database/migrations/2026_10_01_100000_create_user_push_tokens_table.php`<br>`backend/app/Models/UserPushToken.php`<br>`backend/app/Models/User.php` | `backend/tests/Integration/PushTokenApiTest.php` | Conforme (Testé & Validé) |
| API `POST /auth/user/push-tokens` : création, rotation sans doublon par `installation_id`, réassignation utilisateur | `backend/app/Http/Controllers/PushTokenController.php`<br>`backend/app/Http/Requests/StorePushTokenRequest.php`<br>`backend/app/Http/Resources/PushTokenResource.php` | `backend/tests/Integration/PushTokenApiTest.php` | Conforme (Testé & Validé) |
| API `DELETE /auth/user/push-tokens/installations/{id}` et `DELETE /{id}` (404 si token tiers) | `backend/app/Http/Controllers/PushTokenController.php`<br>`backend/routes/api.php` | `backend/tests/Integration/PushTokenApiTest.php` | Conforme (Testé & Validé) |
| Commande `push:purge-inactive-tokens` (inactifs > 90j) enregistrée dans le scheduler | `backend/app/Console/Commands/PurgeInactivePushTokens.php`<br>`backend/routes/console.php` | `backend/tests/Integration/PushTokenApiTest.php` | Conforme (Testé & Validé) |
| Envoi réel FCM via `kreait/laravel-firebase` et purge automatique sur erreur `UNREGISTERED` / `NotFound` | `backend/app/Services/FcmNotificationService.php`<br>`backend/config/firebase.php` | `backend/tests/Integration/Loans/PushNotificationsEventTest.php` | Conforme (Testé & Validé) |
| Listeners push (`ShouldQueue`) avec `$afterCommit = true` et protection globale `try ... catch (\Throwable)` | `backend/app/Listeners/SendLoan*PushNotification.php`<br>`backend/app/Providers/EventServiceProvider.php` | `backend/tests/Integration/Loans/PushNotificationsEventTest.php`<br>`backend/tests/Integration/Loans/LoanNotificationTest.php` | Conforme (Testé & Validé) |
| Préservation des listeners d'emails sans régression | `backend/app/Providers/EventServiceProvider.php` | `backend/tests/Integration/Loans/LoanNotificationTest.php` | Conforme (Testé & Validé) |
| Abstraction et service client Flutter (`FirebasePushNotificationService` avec journalisation d'erreur, `FakePushNotificationService`) | `mobile/lib/features/notifications/domain/services/push_notification_service.dart`<br>`mobile/lib/features/notifications/data/services/` | `mobile/test/features/notifications/notifications_controller_test.dart` | Conforme (Testé & Validé) |
| Parsing et validation stricte du payload (`PushPayload`, `schema_version: "1"`, `loan_id > 0`, `PushEventType`) | `mobile/lib/features/notifications/domain/entities/push_payload.dart` | `mobile/test/features/notifications/push_payload_test.dart` | Conforme (Testé & Validé) |
| Client HTTP Mobile & Repository Tokens (`installation_id` persistant, masquage token en log) | `mobile/lib/features/notifications/data/datasources/push_tokens_remote_data_source.dart`<br>`mobile/lib/features/notifications/data/repositories/push_tokens_repository_impl.dart` | `mobile/test/features/notifications/push_tokens_data_test.dart` | Conforme (Testé & Validé) |
| Synchronisation non-réentrante avec file d'attente sur refresh, suppression locale et révocation serveur au logout | `mobile/lib/features/notifications/presentation/controllers/notifications_controller.dart`<br>`mobile/lib/features/auth/presentation/controllers/auth_controller.dart` | `mobile/test/features/notifications/notifications_controller_test.dart` | Conforme (Testé & Validé) |
| Gestion redirection différée (`pendingRedirectPath` uniquement si déconnecté, nettoyé au logout) | `mobile/lib/features/notifications/presentation/controllers/notifications_controller.dart`<br>`mobile/lib/core/router/app_router.dart` | `mobile/test/features/notifications/notifications_controller_test.dart` | Conforme (Testé & Validé) |
| Demande contextuelle de permission post-login et déduplication mémoire 60 secondes | `mobile/lib/features/notifications/presentation/controllers/notifications_controller.dart` | `mobile/test/features/notifications/notifications_controller_test.dart` | Conforme (Testé & Validé) |
| Premier plan : `ForegroundNotificationBanner` (SnackBar via `rootScaffoldMessengerKey`, `invalidateLoanViews`, pas d'auto-redirect) | `mobile/lib/features/notifications/presentation/widgets/foreground_notification_banner.dart`<br>`mobile/lib/main.dart` | `mobile/test/features/notifications/notifications_ui_test.dart` | Conforme (Testé & Validé) |
| Écran Profil : Statut des notifications, rafraîchissement au retour des réglages (`WidgetsBindingObserver`), ouverture réglages | `mobile/lib/features/profile/presentation/screens/profile_screen.dart` | `mobile/test/features/notifications/notifications_ui_test.dart` | Conforme (Testé & Validé) |
| Détail d'un prêt inaccessible (403/404) : message contrôlé et bouton « Retour au tableau de bord » | `mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart` | `mobile/test/features/loans/loan_detail_screen_test.dart` | Conforme (Testé & Validé) |
| Android : Permission `POST_NOTIFICATIONS`, métadonnées, création canal `locomotion_loans` (`IMPORTANCE_HIGH`) | `mobile/android/app/src/main/AndroidManifest.xml`<br>`mobile/android/app/src/main/kotlin/.../MainActivity.kt` | Inspection statique & compilation Android | Conforme |
| iOS : Capability Push Notifications, `Runner.entitlements`, `project.pbxproj`, `UIBackgroundModes` épuré | `mobile/ios/Runner/Runner.entitlements`<br>`mobile/ios/Runner.xcodeproj/project.pbxproj`<br>`mobile/ios/Runner/Info.plist` | Inspection statique & compilation iOS | Conforme |
| Protection secrets : Exclusion Git `google-services.json`, `GoogleService-Info.plist`, `secrets/*.json` | `mobile/.gitignore`<br>`backend/.gitignore` | `git ls-files` & `git check-ignore` | Conforme |

---

### 3. Matrice de Tests sur Appareils Physiques Réels (§3.3 & Règle §95)

Conformément à la règle de validation du lot (*« Un cas non testé est déclaré non testé, jamais réussi »*) :
Les tests d'intégration Firebase sur appareils physiques n'ont **pas été exécutés sur matériel réel** dans l'environnement de développement / CI.

| Cas de test sur appareil physique | Matériel / OS | Résultat | Commentaire |
|---|---|---|---|
| Réception premier plan (bannière in-app) | Android physique | **Non testé** | Aucun appareil Android physique connecté |
| Réception arrière-plan (notification système) | Android physique | **Non testé** | Aucun appareil Android physique connecté |
| Clic notification app fermée (cold start) | Android physique | **Non testé** | Aucun appareil Android physique connecté |
| Permission refusée (pas de boucle) | Android physique | **Non testé** | Aucun appareil Android physique connecté |
| Renouvellement de jeton (`onTokenRefresh`) | Android physique | **Non testé** | Aucun appareil Android physique connecté |
| Changement de compte utilisateur | Android physique | **Non testé** | Aucun appareil Android physique connecté |
| Réception premier plan (bannière in-app) | iPhone physique | **Non testé** | Aucun iPhone physique connecté ni certificat APNs de dev configuré |
| Réception arrière-plan (notification APNs) | iPhone physique | **Non testé** | Aucun iPhone physique connecté |
| Clic notification app fermée (cold start) | iPhone physique | **Non testé** | Aucun iPhone physique connecté |
| Permission refusée (affichage statut profil) | iPhone physique | **Non testé** | Aucun iPhone physique connecté |
| Renouvellement de jeton | iPhone physique | **Non testé** | Aucun iPhone physique connecté |
| Changement de compte utilisateur | iPhone physique | **Non testé** | Aucun iPhone physique connecté |

*Note* : L'intégralité du comportement métier, de la désérialisation, de la navigation et de la réassignation des tokens est couverte par la suite hermétique de tests automatisés (200 tests Flutter, 25 tests d'intégration Laravel).

---

### 4. Spécimens de Payloads et Traces de Journalisation

#### A. Payload FCM HTTP v1 généré par `FcmNotificationService` (Code de production) :
```json
{
  "token": "dGVzdF90b2tlbl8xMjM0NTY...",
  "notification": {
    "title": "LocoMotion",
    "body": "Activité sur votre réservation"
  },
  "data": {
    "schema_version": "1",
    "event_type": "loan_created",
    "loan_id": "42"
  }
}
```
*Garantie Zero PII* : Aucune donnée nominative (nom, prénom, courriel, adresse) n'est incluse dans `data` ou `notification`. Seul l'identifiant technique `loan_id` est transmis.

#### B. Traces de logs réelles extraites de l'exécution des tests d'intégration :
- **Backend (Laravel - Purge sur token UNREGISTERED)** :
  ```text
  [2026-10-01 11:48:58] testing.INFO: Purged unregistered FCM token upon delivery failure (NotFound) {"token_prefix":"stale_..."}
  ```
- **Mobile (Flutter - Enregistrement et rotation masqués)** :
  ```text
  [PushNotification] Registering token prefix: my_sup...
  [PushNotification] Token successfully registered for user ID 12
  [PushNotification] Foreground payload received: PushPayload(schemaVersion: 1, eventType: loan_created, loanId: 42, messageId: msg_fg_1)
  [PushNotification] Message msg_duplicate_test already processed, skipping duplicate navigation
  [PushNotification] Initiating push token revocation before logout
  ```

---

### 5. Sortie réelle résumée des commandes de validation

#### 1. Analyse statique Dart (mobile)
```bash
$ flutter analyze
The following plugins do not support Swift Package Manager for ios:
  - apple_maps_flutter
Analyzing mobile...
No issues found! (ran in 5.4s)
```

#### 2. Tests Flutter (mobile)
```bash
$ flutter test
00:12 +200: All tests passed!
```

#### 3. Tests API et événements Push Laravel (backend)
```bash
$ docker compose exec php php artisan test --filter=Push
[2026-10-01 11:48:58] testing.INFO: Purged unregistered FCM token upon delivery failure (NotFound) {"token_prefix":"stale_..."}

   PASS  Tests\Integration\Loans\PushNotificationsEventTest
  ✓ loan created sends push to owners and preserves email                0.63s
  ✓ loan accepted sends push to borrower when level is all               0.19s
  ✓ loan accepted does not send push when borrower level is not all      0.26s
  ✓ loan rejected sends push to borrower                                 0.15s
  ✓ loan canceled notifies other party and excludes canceler             0.25s
  ✓ loan comment added notifies participants excluding author and respe… 0.22s
  ✓ push payload enforces strict zero pii                                0.14s
  ✓ fcm dispatch calls kreait messaging send                             0.10s
  ✓ fcm automatically purges token when fcm returns not found unregiste… 0.17s

   PASS  Tests\Integration\PushTokenApiTest
  ✓ can register new push token returns 201                              0.27s
  ✓ token refresh replaces old token for same installation               0.17s
  ✓ token reassigned when another user logs in on same device            0.13s
  ✓ validation rejects invalid platform or missing token                 0.11s
  ✓ can revoke push token by installation                                0.12s
  ✓ can revoke push token by id                                          0.13s
  ✓ revoke by id returns 404 if belongs to another user                  0.21s
  ✓ purge inactive tokens command                                        0.33s

  Tests:    17 passed (63 assertions)
  Duration: 4.05s
```

#### 4. Tests non-régression Emails Laravel (backend)
```bash
$ docker compose exec php php artisan test --filter=LoanNotificationTest
   PASS  Tests\Integration\Loans\LoanNotificationTest
  ✓ subcribes all concerned users                                        2.15s
  ✓ subcribes owners as message only for new self service loans          1.02s
  ✓ subscribe to loan                                                    1.03s
  ✓ subscribe to loan forbidden for stranger                             0.50s
  ✓ notification seen at                                                 0.65s
  ✓ delete comment                                                       0.69s
  ✓ doesnt notify co owners for new self service loan                    0.83s
  ✓ does notify co owners for message in self service loan               0.44s

  Tests:    8 passed (39 assertions)
  Duration: 7.90s
```

#### 5. Contrôle d'absence de secrets et propreté Git
```bash
$ git ls-files | grep -Ei "google-services|GoogleService-Info"
(aucun fichier retourné)

$ git check-ignore secrets/firebase.json (backend)
secrets/firebase.json

$ git check-ignore android/app/google-services.json ios/Runner/GoogleService-Info.plist (mobile)
android/app/google-services.json
ios/Runner/GoogleService-Info.plist

$ git diff --check
(aucun problème d'espace ou de conflit)
```

---

### 6. Guide de Provisioning & Variables Secrètes

- **Compte de service Firebase (Backend)** :
  - Déposer la clé JSON de service Firebase dans `backend/secrets/firebase_credentials.json` (ignoré par Git).
  - Configurer dans le fichier `backend/.env` : `FIREBASE_CREDENTIALS=secrets/firebase_credentials.json`.
  - La configuration `backend/config/firebase.php` lit cette variable pour instancier le client `Kreait\Firebase\Factory`.
- **Fichiers de configuration Mobile** :
  - Android : Déposer `google-services.json` dans `mobile/android/app/` (ignoré par Git).
  - iOS : Déposer `GoogleService-Info.plist` dans `mobile/ios/Runner/` (ignoré par Git).
  - Dans la console Firebase (Paramètres du projet > Cloud Messaging), importer la clé APNs (`.p8`) avec son Key ID et Team ID Apple Developer.
