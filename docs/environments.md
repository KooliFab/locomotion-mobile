# Guide des Environnements et Builds Mobile

Ce guide détaille la gestion multi-environnement de l'application LocoMotion (Flutter), les points d'entrée, les règles de validation à la construction, la signature des binaires et les commandes de build pour Android et iOS.

---

## 1. Environnements disponibles

| Environnement | Point d'entrée | Flavor Android | Scheme iOS | URL API par défaut | Clé Stripe attendue |
|---|---|---|---|---|---|
| **dev** | `lib/main_dev.dart` (ou `lib/main.dart`) | `dev` | `Runner` | Machine locale / Wi-Fi (`192.168.0.198:8000/api/v1` ou `10.0.2.2:8000/api/v1`) | `pk_test_...` (ou demo) |
| **staging** | `lib/main_staging.dart` | `staging` | `Runner` | `https://staging.locomotion.app/api/v1` | `pk_test_...` (valide non vide) |
| **prod** | `lib/main_prod.dart` | `prod` | `Runner` | `https://api.locomotion.app/api/v1` | `pk_live_...` (clé live obligatoire) |

---

## 2. Règles de validation (`AppConfig.validate()`)

À l'initialisation de l'application (dans `main()`), `AppConfig.validate()` est systématiquement exécuté pour interdire tout déploiement non sécurisé :

1. **En production (`Environment.prod`)** :
   - L'URL de l'API **doit obligatoirement commencer par `https://`** (HTTP strictement interdit).
   - L'URL **ne doit pas pointer vers localhost ou une plage IP privée** (`127.0.0.1`, `10.0.2.2`, `192.168.*`, `10.*`, `172.16-31.*`).
   - La clé publiable Stripe ne doit **pas être vide ni correspondre à la clé de démo** (`pk_test_locomotion_demo`).
   - La clé Stripe **doit obligatoirement être une clé de production** commençant par `pk_live_`.

2. **En staging (`Environment.staging`)** :
   - L'URL de l'API **doit obligatoirement commencer par `https://`**.
   - La clé Stripe ne doit pas être vide.

3. **En développement (`Environment.dev`)** :
   - L'URL de base ne doit pas être vide.
   - Le sélecteur d'URL et les outils de test réseau ne sont affichés que dans cet environnement.

---

## 3. Signature Android Release

La configuration Gradle (`android/app/build.gradle.kts`) supporte deux modes d'alimentation des identifiants de signature release :

### A. Fichier `key.properties` (local)
Créer le fichier `android/key.properties` (ignoré par git) à partir du modèle `android/key.properties.example` :
```properties
storePassword=votre_mot_de_passe_keystore
keyPassword=votre_mot_de_passe_cle
keyAlias=votre_alias_de_cle
storeFile=/chemin/vers/votre/upload-keystore.jks
```

### B. Variables d'environnement (CI/CD)
Définir les variables d'environnement suivantes dans votre pipeline (ex. GitHub Actions secrets) :
- `ANDROID_KEYSTORE_PATH`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

### C. Repli de secours développement
Si aucun keystore release n'est configuré, Gradle utilise automatiquement la clé de debug pour permettre aux développeurs de tester les builds release localement (`flutter run --release`) sans bloquer le script de build.

---

## 4. Commandes de Build

### Android

#### Développement :
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

#### Staging (APK de test interne) :
```bash
flutter build apk --flavor staging -t lib/main_staging.dart --dart-define=APP_ENV=staging
```

#### Staging (AppBundle / Google Play Test) :
```bash
flutter build appbundle --flavor staging -t lib/main_staging.dart --dart-define=APP_ENV=staging
```

#### Production (AppBundle release avec clé live Stripe) :
```bash
flutter build appbundle --flavor prod -t lib/main_prod.dart \
  --dart-define=APP_ENV=prod \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_votre_cle_reelle
```

---

### iOS

Le projet Xcode utilise le scheme `Runner` configuré avec les certificats provisionnés pour la cible.

#### Développement :
```bash
flutter run -t lib/main_dev.dart
```

#### Staging (Archive IPA TestFlight) :
```bash
flutter build ipa -t lib/main_staging.dart --dart-define=APP_ENV=staging
```

#### Staging (Vérification locale sans signature de code) :
```bash
flutter build ios -t lib/main_staging.dart --dart-define=APP_ENV=staging --no-codesign
```

#### Production (Archive IPA App Store) :
```bash
flutter build ipa -t lib/main_prod.dart \
  --dart-define=APP_ENV=prod \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_votre_cle_reelle
```

---

## 5. Intégration Continue (CI)

Le pipeline GitHub Actions (`.github/workflows/mobile-ci.yml`) compile systématiquement :
- L'APK Staging : `flutter build apk --flavor staging -t lib/main_staging.dart --dart-define=APP_ENV=staging`
- L'APK Production : `flutter build apk --flavor prod -t lib/main_prod.dart --dart-define=APP_ENV=prod --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_locomotion_ci_mock`

---

## 6. Firebase / notifications push par environnement

Le service push n'utilise **jamais** de faux token hors tests. Si Firebase n'est pas initialisé, `DisabledPushNotificationService` est injecté : permission refusée, aucun token, aucun appareil enregistré au backend. `FakePushNotificationService` n'est utilisable que par injection explicite dans les tests.

### Configuration native (fichiers hors dépôt, ignorés par git)
- **Android** : `android/app/google-services.json` ou, par flavor, `android/app/src/{dev,staging,prod}/google-services.json`. Le plugin `com.google.gms.google-services` est appliqué automatiquement par `android/app/build.gradle.kts` dès qu'un de ces fichiers existe.
- **iOS** : `GoogleService-Info.plist` à ajouter dans la cible Runner via Xcode (référence projet non versionnée, à finaliser par l'équipe).

### Configuration explicite (alternative, sans fichier natif)
Fournir toutes les valeurs via `--dart-define` : `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID` (et `FIREBASE_STORAGE_BUCKET` en option). `Firebase.initializeApp(options: ...)` est alors utilisé.

### Recette restante (non exécutée)
Réception et ouverture des notifications Android/iOS en premier plan, arrière-plan et démarrage à froid : à valider sur appareil réel avec un projet Firebase staging. Les tests automatisés ne couvrent que le service injecté.
