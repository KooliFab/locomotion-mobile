# LocoMotion Mobile App (Flutter)

Application mobile LocoMotion pour les emprunts et partages de véhicules, développée en Flutter / Dart avec gestion d'état Riverpod.

## 1. Environnements et points d'entrée

L'application supporte trois environnements (`dev`, `staging`, `prod`) avec des configurations distinctes, validation d'URL HTTPS et contrôle de clés Stripe.

Pour le détail complet, consultez la documentation dédiée : [docs/environments.md](docs/environments.md).

| Environnement | Point d'entrée | Flavor Android | Scheme iOS | URL API par défaut |
|---|---|---|---|---|
| **dev** | `lib/main_dev.dart` | `dev` | `Runner` | Machine locale / Wi-Fi (`192.168.0.198:8000/api/v1` ou `10.0.2.2:8000/api/v1`) |
| **staging** | `lib/main_staging.dart` | `staging` | `Runner` | `https://staging.locomotion.app/api/v1` |
| **prod** | `lib/main_prod.dart` | `prod` | `Runner` | `https://api.locomotion.app/api/v1` |

## 2. Commandes de lancement et build

### Android

```bash
# Développement local
flutter run --flavor dev -t lib/main_dev.dart

# Build APK Staging
flutter build apk --flavor staging -t lib/main_staging.dart --dart-define=APP_ENV=staging

# Build AppBundle Production (Google Play)
flutter build appbundle --flavor prod -t lib/main_prod.dart \
  --dart-define=APP_ENV=prod
```

### iOS

```bash
# Développement local
flutter run -t lib/main_dev.dart

# Build Archive IPA Staging (TestFlight)
flutter build ipa -t lib/main_staging.dart --dart-define=APP_ENV=staging

# Build Archive IPA Production (App Store)
flutter build ipa -t lib/main_prod.dart \
  --dart-define=APP_ENV=prod
```

## 3. Signature Android Release

Pour signer les binaires release, configurez `android/key.properties` (voir `android/key.properties.example`) ou définissez les variables d'environnement `ANDROID_KEYSTORE_PATH`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.

Sans keystore, un build release échoue volontairement. Pour un build de vérification local ou CI non distribuable, définissez `ALLOW_DEBUG_SIGNING=true` : l'artefact est alors signé avec la clé debug et ne doit jamais être publié.

## 4. Tests

```bash
flutter test
```
