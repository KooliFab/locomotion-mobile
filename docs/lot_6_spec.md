# Spécification Technique — Lot 6 : Notifications Push (FCM) & Gestion des Appareils

## 1. Contexte et Objectifs

Le présent document définit le contrat technique complet entre le backend Laravel et l'application mobile Flutter pour l'implémentation des notifications push via Firebase Cloud Messaging (FCM).

### Objectifs principaux :
1. Notifier de manière fiable les emprunteurs et propriétaires lors des événements clés du cycle de vie d'une réservation (`loans`).
2. Permettre à l'utilisateur d'ouvrir directement l'écran de détail de la réservation concernée (`/loans/:id`) en cliquant sur la notification.
3. Garantir une confidentialité absolue : **aucun contenu sensible ni donnée personnelle** dans le payload FCM (`notification` et `data`), sans révélation intrusive de statut sur écran verrouillé.
4. Réutiliser fidèlement la logique de filtrage des préférences de notification existante (`UserMail` et `loan_notifications.level`).
5. Préserver l'intégralité des envois d'emails existants dans `EventServiceProvider`.
6. Assurer un découplage et une testabilité totale côté Flutter grâce à une abstraction `PushNotificationService`.

---

## 2. Spécification Backend Laravel

### 2.1. Schéma de base de données : table `user_push_tokens`

Une table dédiée stocke les jetons FCM associés aux utilisateurs et à leurs appareils.

#### Migration : `create_user_push_tokens_table`

```php
Schema::create('user_push_tokens', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
    $table->string('token', 512)->unique();
    $table->string('platform', 16); // 'android' | 'ios'
    $table->string('installation_id', 128); // UUID généré côté app, stable par installation
    $table->string('app_version', 32)->nullable();
    $table->timestamp('last_active_at')->useCurrent();
    $table->timestamps();

    $table->index(['user_id', 'platform']);
    $table->index('installation_id');
    $table->index('last_active_at');
});
```

#### Règles d'intégrité, renouvellement et réassignation :
1. **Unicité sur `token`** : Le jeton FCM identifie de façon unique une instance de notification. Un index unique strict est posé sur la colonne `token`.
2. **Prévention des doublons lors du renouvellement (`onTokenRefresh`)** :
   Lorsqu'un appareil renouvelle son token FCM, le nouvel enregistrement s'exécute dans une **transaction de base de données** :
   - Toute ancienne ligne ayant le même `installation_id` avec un token différent est **immédiatement supprimée**.
   - L'upsert (`updateOrCreate`) est ensuite exécuté sur le nouveau token.
   Cela garantit qu'un appareil physique (`installation_id`) ne possède jamais plusieurs tokens actifs simultanément, éliminant ainsi toute double notification.
3. **Réassignation de compte** :
   Si un utilisateur B se connecte sur un appareil précédemment utilisé par l'utilisateur A, le `POST` avec le token de l'appareil réassigne la ligne à l'utilisateur B (`user_id = B.id`) et met à jour `last_active_at`. Aucun token orphelin ne reste rattaché au compte précédent.

### 2.2. Politique de rétention et purge des tokens

1. **Rétention des appareils inactifs** : Un appareil sans activité enregistrée (`last_active_at`) depuis plus de **90 jours** est considéré comme inactif.
2. **Commande planifiée Laravel** :
   ```bash
   php artisan push:purge-inactive-tokens
   ```
   Exécutée quotidiennement via le Task Scheduler Laravel (`App\Console\Kernel`) :
   ```php
   $schedule->command('push:purge-inactive-tokens')->daily();
   ```
   Supprime les enregistrements où `last_active_at < now()->subDays(90)`.
3. **Purge réactive des tokens invalides FCM** :
   Lors de l'envoi d'une notification via FCM HTTP v1, si FCM renvoie une erreur signalant que le token n'est plus enregistré (`UNREGISTERED`, code HTTP 404 ou erreur `registration-token-not-registered`), le service d'envoi supprime immédiatement le token concerné de la base de données :
   ```php
   UserPushToken::where('token', $invalidToken)->delete();
   ```

---

## 3. Contrat d'API REST Laravel

Tous les endpoints sont préfixés par `/api/v1` et protégés par le middleware d'authentification `auth:api` (Passport).

### 3.1. Enregistrement / Actualisation d'un token push

- **Route** : `POST /api/v1/auth/user/push-tokens`
- **Authentification** : `Bearer <passport_jwt>` (Requis)
- **Headers** :
  ```http
  Content-Type: application/json
  Accept: application/json
  ```
- **Corps de la requête (Request Body)** :
  ```json
  {
    "token": "fcm_token_string_here_up_to_512_chars",
    "platform": "android",
    "installation_id": "c7a8b6e2-9d3e-4b1a-8c5a-2f4b8c9d0e1f",
    "app_version": "1.0.0+1"
  }
  ```

#### Règles de validation Laravel (`StorePushTokenRequest`) :
| Champ | Règles | Description |
|---|---|---|
| `token` | `required|string|max:512` | Jeton d'enregistrement FCM |
| `platform` | `required|string|in:android,ios` | Plateforme OS (`android` ou `ios`) |
| `installation_id` | `required|string|max:128` | UUID v4 persistant propre à l'installation |
| `app_version` | `nullable|string|max:32` | Version applicative (ex. `1.0.0+1`) |

#### Comportement serveur (Idempotence & Transaction) :
```php
public function store(StorePushTokenRequest $request)
{
    $user = $request->user();

    $pushToken = DB::transaction(function () use ($request, $user) {
        // 1. Purge des anciens tokens éventuels pour cette même installation
        UserPushToken::where('installation_id', $request->installation_id)
            ->where('token', '!=', $request->token)
            ->delete();

        // 2. Recherche existant ou création
        $tokenRecord = UserPushToken::where('token', $request->token)->first();
        $isNew = is_null($tokenRecord);

        $pushToken = UserPushToken::updateOrCreate(
            ['token' => $request->token],
            [
                'user_id' => $user->id,
                'platform' => $request->platform,
                'installation_id' => $request->installation_id,
                'app_version' => $request->app_version,
                'last_active_at' => now(),
            ]
        );

        return [$pushToken, $isNew];
    });

    [$record, $wasCreated] = $pushToken;

    return response()->json(
        new PushTokenResource($record),
        $wasCreated ? 201 : 200
    );
}
```

#### Décision sur les codes d'état HTTP :
- **Pas de code 409 Conflict** : L'enregistrement est strictement idempotent.
- **`201 Created`** : Renvoyé si une nouvelle ligne de token a été créée en base.
- **`200 OK`** : Renvoyé si le token existait déjà et a été mis à jour / réassigné.
- **`401 Unauthorized`** : Jeton d'authentification absent ou invalide.
- **`422 Unprocessable Entity`** : Validation échouée (token manquant, platform invalide, etc.).

---

### 3.2. Révocation / Suppression d'un token push

Pour éviter tout problème de transport avec des corps JSON sur méthode HTTP `DELETE` (filtrés par certains reverse-proxies ou clients mobiles), la suppression s'effectue via des chemins URL explicites.

#### Route principale (recommandée pour le client mobile) :
- **Route** : `DELETE /api/v1/auth/user/push-tokens/installations/{installation_id}`
- **Authentification** : `auth:api`
- **Comportement** : Supprime tous les tokens associés à cet `installation_id` pour le compte authentifié.
- **Réponse** : **`204 No Content`** (idempotent, renvoyé que le token existait ou non).

#### Route alternative (par identifiant de ressource) :
- **Route** : `DELETE /api/v1/auth/user/push-tokens/{id}`
- **Authentification** : `auth:api`
- **Comportement** :
  - Si la ligne existe ET appartient à l'utilisateur courant : suppression et retour **`204 No Content`**.
  - Si la ligne n'existe pas OU appartient à un autre utilisateur : retour **`404 Not Found`** (au lieu de 403, afin de ne pas révéler l'existence d'identifiants tiers).

---

### 3.3. Gestion de la déconnexion (En ligne et Hors ligne)

Pour respecter scrupuleusement la règle d'absence de stockage de token en clair (`lot_6.md:54`), aucune persistance locale d'un token de révocation en attente n'est mise en œuvre.

#### Protocole de déconnexion (`logout`) :
1. **Appel serveur préalable (si en ligne)** :
   Le client appelle `DELETE /api/v1/auth/user/push-tokens/installations/{installation_id}` avec un timeout court (3s) **avant** de révoquer la session Passport.
2. **Invalidation locale systématique chez Firebase** :
   Que le réseau soit disponible ou non, le client appelle toujours :
   ```dart
   await pushNotificationService.deleteToken(); // FirebaseMessaging.instance.deleteToken()
   ```
   Cette action invalide immédiatement l'instance du token auprès des serveurs Firebase.
3. **Cas de déconnexion hors ligne** :
   - L'appel `DELETE` réseau échoue ou timeout. L'application poursuit la déconnexion locale sans bloquer l'utilisateur.
   - Étant donné que `deleteToken()` a invalidé le jeton auprès de Firebase, si le backend Laravel tente d'envoyer un push vers cet ancien token, Firebase répondra `UNREGISTERED`.
   - Le listener Laravel purgera alors immédiatement le token de la table `user_push_tokens`.
   - Aucun token ni drapeau n'est conservé dans le stockage local de l'application.

---

## 4. Envoi FCM & Architecture Backend

### 4.1. Librairie & Configuration FCM HTTP v1

- **Librairie** : Utilisation du package officiel standard Laravel `kreait/laravel-firebase` (v5+), qui exploite l'API moderne Firebase Cloud Messaging HTTP v1.
- **Compte de service (Credentials)** :
  - Le fichier JSON de clé de compte de service Firebase est stocké **hors du dépôt de code** (par exemple sous `backend/secrets/firebase_credentials.json`).
  - L'emplacement est référencé par variable d'environnement :
    ```env
    FIREBASE_CREDENTIALS=secrets/firebase_credentials.json
    ```
  - `backend/.gitignore` exclut explicitement `secrets/*.json`.
  - En environnement de test / CI, un mock de la factory Firebase ou le driver `null` est utilisé.

### 4.2. Exécution Asynchrone (Queue)

L'envoi vers FCM implique des appels réseau externes :
- Tous les listeners push Laravel implémentent l'interface **`Illuminate\Contracts\Queue\ShouldQueue`**.
- La méthode `handle()` s'exécute sur le système de queue Laravel (worker queue : `default` ou `notifications`).
- Aucune requête API utilisateur (acceptation, refus, commentaire, etc.) n'est ralentie ou bloquée par l'acheminement des notifications push.

### 4.3. Nommage du service backend : `FcmNotificationService`

Pour éviter toute confusion avec l'interface Flutter (`PushNotificationService`), le service backend est nommé **`FcmNotificationService`** (`App\Services\FcmNotificationService`).

---

## 5. Format du Payload FCM (Garantie de Confidentialité)

### 5.1. Principe de protection des données (Zero PII)

- **Aucun nom ni prénom.**
- **Aucune marque, modèle ni immatriculation de véhicule.**
- **Aucune adresse ni localisation géographique.**
- **Aucun contenu de commentaire ni message utilisateur.**
- Le dictionnaire `data` ne transporte que des identifiants techniques minimaux.

### 5.2. Structure du message FCM

```json
{
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

*(Note : `click_action` est omis car obsolète dans FCM v1. Toutes les valeurs sous `data` sont des chaînes de caractères `string`).*

### 5.3. Textes affichés et discrétion sur écran verrouillé

Pour concilier clarté et respect de la vie privée sur écran verrouillé, la formulation générique suivante est adoptée :

| Valeur de `event_type` | Événement déclencheur | Titre affiché | Corps affiché (`body`) | Destinataire cible |
|---|---|---|---|---|
| `loan_created` | Nouvelle demande | `LocoMotion` | `Nouvelle demande reçue` | (Co)propriétaires du véhicule |
| `loan_accepted` | Demande acceptée | `LocoMotion` | `Activité sur votre réservation` | Emprunteur |
| `loan_rejected` | Demande refusée | `LocoMotion` | `Activité sur votre réservation` | Emprunteur |
| `loan_canceled` | Réservation annulée | `LocoMotion` | `Activité sur votre réservation` | L'autre partie (pas l'auteur) |
| `loan_comment_added` | Nouveau commentaire | `LocoMotion` | `Nouveau message reçu` | Participants (sauf auteur) |

> **Arbitrage vie privée (Privacy by design)** : Le statut précis (`acceptée`, `refusée`, `annulée`) n'est pas étalé sur l'écran de verrouillage du téléphone. La notification indique sobrement qu'une activité a eu lieu, invitant l'utilisateur à déverrouiller son appareil pour consulter le détail.

---

## 6. Déclencheurs Laravel, Événements & Niveaux de Notification

### 6.1. Alignement strict sur la logique de `UserMail`

Le service backend `FcmNotificationService` réutilise **rigoureusement la même logique de ciblage et de filtrage** que `App\Mail\UserMail`, garantissant une cohérence parfaite entre notifications push et emails :

1. **Méthode `sendToLoanOwners(Loan $loan, array $payload)`** :
   - Extrait les utilisateurs via `$loan->loanable->mergedUserRoles()` avec les rôles `Owner` ou `Coowner`.
   - Exclut les utilisateurs archivés (`trashed()`) et l'emprunteur s'il est co-propriétaire (`$user->is($loan->borrowerUser)`).
   - *Comportement identique à `UserMail::queueToLoanOwners`*.
2. **Méthode `sendToLoanBorrower(Loan $loan, array $payload)`** :
   - Vérifie la ligne de l'emprunteur dans `$loan->notifiedUsers`.
   - **Règle** : Si l'emprunteur est présent ET que son niveau pivot est `LoanNotificationLevel::All`, le push est envoyé. Si aucune ligne n'existe ou que le niveau est différent de `All`, aucun push n'est envoyé.
   - *Comportement identique à `UserMail::queueToLoanBorrower`*.
3. **Méthode `sendToLoanNotifiedUsers(Loan $loan, array $payload, ?User $exception = null, array $acceptedLevels = [LoanNotificationLevel::All])`** :
   - Parcourt `$loan->notifiedUsers`.
   - Si un utilisateur n'a pas de ligne dans le pivot, il n'est **pas notifié**.
   - Si son niveau pivot n'est pas dans `$acceptedLevels`, il est **ignoré**.
   - Si `$exception` est fourni (auteur de l'action) et correspond à l'utilisateur, il est **exclu**.
   - *Comportement identique à `UserMail::queueToLoanNotifiedUsers`*.

### 6.2. Matrice des événements retenus (Périmètre MVP Lot 6)

| Événement produit | Événement Laravel branché | Listener Push (ShouldQueue) | Méthode de distribution | Destinataires effectifs |
|---|---|---|---|---|
| **Nouvelle demande** | `LoanCreatedEvent` (statut `requested`) | `SendLoanCreatedPushNotification` | `sendToLoanOwners` | Propriétaires / co-propriétaires (sauf si auteur) |
| **Demande acceptée** | `LoanAcceptedEvent` | `SendLoanAcceptedPushNotification` | `sendToLoanBorrower` | Emprunteur (si niveau `All`) |
| **Demande refusée** | `LoanRejectedEvent` | `SendLoanRejectedPushNotification` | `sendToLoanBorrower` | Emprunteur (si niveau `All`) |
| **Réservation annulée** | `App\Events\Loan\CanceledEvent` | `SendLoanCanceledPushNotification` | `sendToLoanNotifiedUsers` | Tous les participants au prêt (niveau `All`), avec `$exception = $event->canceler` |
| **Nouveau commentaire** | `LoanCommentAddedEvent` | `SendLoanCommentAddedPushNotification` | `sendToLoanNotifiedUsers` | Tous les participants (niveaux `[All, MessagesOnly]`), avec `$exception = $event->user` |

#### Précisions sur les cas particuliers :
- **Annulation par un administrateur** : L'administrateur annulant le prêt est passé dans `$event->canceler`. Il est exclu de l'envoi via `$exception`. L'emprunteur et les propriétaires reçoivent la notification (si abonnés `All`).
- **Événement `LoanCanceledMail` dans `EventServiceProvider.php:96`** : Il s'agit d'une entrée orpheline / legacy. Le push d'annulation est branché **exclusivement sur `App\Events\Loan\CanceledEvent`**, évitant tout risque de double émission.
- **Événement `LoanUpdatedEvent` (Dates modifiées)** : Conformément au périmètre strict du MVP, **`LoanUpdatedEvent` n'est pas retenu** pour le Lot 6. Il pourra être activé lors d'un lot ultérieur sans modification d'architecture.
- **Préservation des emails** : Tous les listeners emails (`SendLoanCreatedEmails`, etc.) restent enregistrés en parallèle dans `EventServiceProvider`.

---

## 7. Spécification Client Mobile (Flutter)

### 7.1. Architecture & Abstraction testable

Pour garantir qu'aucun test unitaire ou widget n'appelle `FirebaseMessaging.instance` directement, une interface d'abstraction est définie.

#### Contrat : `PushNotificationService`
```dart
abstract class PushNotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
  Stream<PushPayload> get onForegroundMessage;
  Stream<PushPayload> get onMessageOpenedApp;
  Future<PushPayload?> getInitialMessage();
  Future<void> deleteToken();
  Future<void> revokeTokenOnBackend();
}
```

- **Implémentation de production** : `FirebasePushNotificationService` (encapsule `firebase_messaging`).
- **Implémentation de test** : `FakePushNotificationService` (permet de simuler la réception de messages, les rafraîchissements de token et les permissions sans dépendance native Firebase).

### 7.2. Modèle de données & Validation stricte du payload

#### Entité : `PushPayload`
```dart
enum PushEventType {
  loanCreated,
  loanAccepted,
  loanRejected,
  loanCanceled,
  loanCommentAdded,
  unknown,
}

class PushPayload {
  final String schemaVersion;
  final PushEventType eventType;
  final int loanId;
  final String? messageId;
  ...
}
```

#### Règles de validation stricte :
1. **`schema_version`** : Seule la version `"1"` est supportée. Si une version inconnue ou incompatible est reçue, le message est consigné dans les logs sans planter l'application et ignoré.
2. **`event_type`** : Mappé vers `PushEventType`. Si la chaîne reçue est inconnue (`unknown`), le payload est ignoré sans navigation.
3. **`loan_id`** : Doit être convertible en entier strictement positif (`> 0`). Si absent, nul, ou <= 0, aucune navigation n'est initiée.

### 7.3. Gestion des trois états applicatifs

1. **Application au premier plan (Foreground)** :
   - **Configuration iOS** : Désactivation explicite de la bannière système native au premier plan afin d'éviter un doublon d'affichage :
     ```dart
     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
       alert: false, // Pas de bannière système par-dessus l'app
       badge: true,
       sound: false,
     );
     ```
   - **Règle UI** : **Aucune redirection automatique d'écran**.
   - **Action utilisateur** : Affichage d'un `SnackBar` in-app sobre avec bouton d'action (« Activité sur votre réservation — [Voir] »).
   - **Actualisation des données** : Invalidation immédiate et centralisée des providers Riverpod :
     ```dart
     invalidateLoanViews(ref, loanId: payload.loanId);
     ```
2. **Application en arrière-plan (Background)** :
   - La notification système FCM est affichée par l'OS.
   - Au tap utilisateur : réception de l'événement via `onMessageOpenedApp`.
   - Déduplication via `messageId`.
   - Navigation sécurisée vers `/loans/${payload.loanId}`.
3. **Application terminée (Terminated)** :
   - Au tap utilisateur pour ouvrir l'app : récupération du message via `getInitialMessage()`.
   - Déduplication via `messageId`.
   - Après chargement initial du routeur et confirmation de l'authentification, redirection vers `/loans/${payload.loanId}`.

### 7.4. Déduplication d'ouverture

Sur Android et iOS, `getInitialMessage` et `onMessageOpenedApp` peuvent dans certains cas livrer le même événement d'ouverture pour un message donné.
- Un cache mémoire LRU / Set horodaté `Set<String> _processedMessageIds` mémorise les `messageId` traités durant les 60 dernières secondes.
- Tout message dont le `messageId` a déjà été traité est immédiatement ignoré.

### 7.5. Navigation sécurisée et contrôle d'accès

Lorsque l'utilisateur navigue vers `/loans/:id` suite à une notification :
1. **Utilisateur non authentifié** :
   - L'application sauvegarde la destination cible.
   - Redirection vers l'écran de connexion (`LoginScreen`).
   - Après connexion réussie, redirection vers la réservation demandée.
2. **Réservation inaccessible ou supprimée (Erreurs HTTP 403 / 404)** :
   - `LoanDetailScreen` charge les données via `GET /loans/{id}`.
   - Si l'API renvoie `403 Forbidden` ou `404 Not Found`, un écran d'erreur contrôlé est affiché (« Cette réservation n'est plus accessible ou vous n'avez pas les droits nécessaires ») avec un bouton de retour vers le tableau de bord. Aucun crash ni écran noir.

### 7.6. Permissions & Cycle de vie

1. **Timing de demande des permissions (iOS & Android 13+)** :
   - La demande de permission n'est jamais faite au premier lancement à froid avant l'authentification.
   - Demande contextuelle après la première connexion réussie.
   - Sur Android 13+, demande de la permission `POST_NOTIFICATIONS` et création du canal de notification :
     - `id`: `locomotion_loans`
     - `name`: `Réservations LocoMotion`
     - `importance`: `Importance.high`
2. **Refus de permission** :
   - L'application fonctionne sans altération.
   - Dans l'écran de profil, présence d'un statut « Notifications désactivées » avec bouton ouvrant les réglages du système (`openAppSettings()`), sans boucle de sollicitation.
3. **Journalisation et Sécurité** :
   - Les tokens FCM complets ne sont **jamais journalisés** (masquage : 6 premiers caractères au maximum).
   - Les fichiers `google-services.json` et `GoogleService-Info.plist` demeurent ignorés par Git.

---

## 8. Matrice de Tests & Critères d'Acceptation

### 8.1. Tests Backend Laravel
- **Migration & Modèle** : Création de la table `user_push_tokens`, contrainte d'unicité, suppression en cascade sur l'utilisateur.
- **Idempotence & Transaction** :
  - `POST /auth/user/push-tokens` crée un token (201).
  - Renouvellement de token pour une même installation supprime l'ancien et enregistre le nouveau (200, zéro doublon).
  - Réassignation d'un token existant à un autre utilisateur (200, unicité conservée).
- **Révocation API** :
  - `DELETE /auth/user/push-tokens/installations/{installation_id}` supprime les tokens associés (204).
  - `DELETE /auth/user/push-tokens/{id}` supprime si propriétaire (204), renvoie 404 si ID inconnu ou appartenant à un tiers.
- **Purge** :
  - Commande `push:purge-inactive-tokens` supprimant les enregistrements inactifs > 90 jours.
  - Purge automatique sur erreur FCM `UNREGISTERED`.
- **Listeners & Événements** :
  - Listeners push implémentant `ShouldQueue`.
  - Émission sur `LoanCreatedEvent`, `LoanAcceptedEvent`, `LoanRejectedEvent`, `Loan\CanceledEvent`, `LoanCommentAddedEvent`.
  - Exclusion de l'auteur de l'annulation ou du commentaire.
  - Respect exact du filtre `UserMail` et de `loan_notifications.level`.
  - Préservation des listeners d'emails sans régression.

### 8.2. Tests Mobiles Flutter
- **Validation DTO / Payload** :
  - Parsing de payload valide (`schema_version: "1"`, `loan_id: "42"`, `event_type`).
  - Tolérance aux anomalies (version inconnue, `loan_id` <= 0, `event_type` inconnu).
- **Cycle de vie du token** :
  - Enregistrement post-login et au démarrage si session active.
  - Écoute du flux `onTokenRefresh`.
  - Séquence de logout : révocation API préalable, appel `deleteToken()` local, effacement des jetons locaux.
- **États applicatifs & Navigation** :
  - Premier plan : réception, affichage SnackBar, invalidation des providers via `invalidateLoanViews`, aucune navigation intempestive.
  - Arrière-plan / Terminé : ouverture notification, déduplication `messageId`, navigation vers `/loans/:id`.
  - Gestion des erreurs 403 / 404 sur `LoanDetailScreen`.
  - Mémorisation de redirection si non authentifié.
