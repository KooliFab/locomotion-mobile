# Spécification Technique & Cadrage — Lot 7 (QA et première distribution)

Ce document formalise la spécification technique, la vérification bloquante des préconditions (Lots 0 à 6), l'audit des écarts connus, la conception des flavors/CI et la matrice QA du **Lot 7** du projet LocoMotion.

---

## 1. Mission & Périmètre du Lot 7

### 1.1 Mission
Préparer une version de test Android/iOS de l'ensemble du MVP de réservation LocoMotion, avec preuves de qualité vérifiables, configuration des environnements `staging` et `prod`, et procédure documentée de retour arrière (rollback). Ce lot ne doit pas masquer des défauts fonctionnels sous une distribution.

### 1.2 Périmètre inclus
1. **Vérification des préconditions (Lots 0 à 6)** : audit exhaustif de chaque critère d'acceptation par le code et les tests.
2. **Contrôle des 9 écarts connus** : traçabilité et identification des anomalies sans correction masquée.
3. **Flavors applicatives** : configuration `staging` (`app.locomotion.mobile.staging`) et `prod` (`app.locomotion.mobile`) avec nom, bundle ID et icône distincts sur Android et iOS.
4. **Pipeline CI automatisé** : configuration GitHub Actions intégrant `dart format`, `flutter analyze`, `flutter test` et les tests Laravel (`php artisan test`).
5. **Tests automatisés manquants (Backend)** : ajout des tests de concurrence sur les conflits de réservation et d'acceptation dans Laravel.
6. **Matrice QA minimale** : couverture des 9 domaines critiques (Session, Éligibilité, Fuseaux, Demande, Suivi, Propriétaire, Push, Réseau, Deep-links).
7. **Vérification Sécurité** : étanchéité Git des secrets, sécurisation des logs réseau (`LogInterceptor` / Zero PII) et intégrité du stockage des jetons.
8. **Guide de distribution & procédure de rollback** : procédure pas à pas de packaging et de retour arrière.

### 1.3 Consigne de livraison & Règle d'arrêt
> [!IMPORTANT]
> Conformément aux consignes de `mobile/docs/lot_7.md`, le sous-agent ne lance **aucun upload** vers TestFlight, Google Play Console ou Firebase App Distribution. Il prépare les configurations, valide les suites de tests, produit les checklists et s'arrête pour attendre la confirmation explicite du responsable produit.

---

## 2. Vérification des Préconditions (Lots 0 à 6)

La première tâche bloquante consiste à auditer chaque lot précédent afin de certifier que chaque critère d'acceptation est réellement couvert par le code et les tests.

| Lot | Critère d'acceptation | Preuve (fichier d'implémentation & test) | Statut |
|---|---|---|---|
| **Lot 0** | **0.1 Parsing unifié Loanables** : mapping strict `ListLoanableResource` et `LoanableResource` sans invention de données | `lib/features/loanables/domain/entities/loanable.dart`<br>`test/features/loanables/loanable_mapping_test.dart` | **OK** |
| **Lot 0** | **0.2 Chargement images** : récupération via octets `GET /images/{id}` authentifié | `lib/features/loanables/presentation/widgets/loanable_image_widget.dart` | **OK** |
| **Lot 0** | **0.3 Disponibilité backend** : parsing `{type, start, end, data:{available}}` via `GET /loanables/{id}/availability` | `lib/features/loanables/domain/entities/loanable_availability.dart`<br>`test/features/loanables/loanables_remote_data_source_test.dart` | **OK** |
| **Lot 0** | **0.4 Fuseaux horaires** : respect du fuseau véhicule (`timezone`) sans conversion implicite | `lib/features/loanables/domain/entities/vehicle_local_dates.dart`<br>`test/features/loanables/vehicle_local_dates_test.dart` | **OK** |
| **Lot 0** | **0.5 Dashboard 5 catégories** : parsing `started`, `waiting`, `need_approval`, `future`, `completed` | `lib/features/loans/domain/entities/loan_dashboard.dart`<br>`test/features/loans/loans_screen_dashboard_test.dart` | **OK** |
| **Lot 0** | **0.6 Contrat POST /loans** : sérialisation exacte des champs Laravel (`loanable_id`, `departure_at`, `duration_in_minutes`, etc.) | `lib/features/loans/domain/entities/loan_creation_request.dart`<br>`test/features/loans/loans_remote_data_source_test.dart` | **OK** |
| **Lot 0** | **0.7 Pas de faux fallback** : propagation des erreurs réseau/parsing sans données de démo | `lib/features/loans/presentation/controllers/loans_controller.dart`<br>`test/features/controllers/error_propagation_test.dart` | **OK** |
| **Lot 1** | **1.1 Session & Déconnexion** : persistance sécurisée, renouvellement et logout propre | `lib/features/auth/presentation/controllers/auth_controller.dart`<br>`lib/core/storage/secure_storage.dart` | **OK** |
| **Lot 1** | **1.2 Modèle Borrower** : parsing complet des états `approved`, `suspended`, `validated` | `lib/features/borrower/domain/entities/borrower.dart`<br>`test/features/borrower/borrower_mapping_test.dart` | **OK** |
| **Lot 1** | **1.3 Téléversement multipart** : `POST /files` avec clés `gaa` et `saaq` | `lib/features/borrower/data/datasources/borrower_remote_data_source.dart`<br>`test/features/borrower/borrower_data_source_test.dart` | **OK** |
| **Lot 1** | **1.4 Soumission dossier** : `PUT /users/{userId}/borrower/submit` avec listes `{id}` | `lib/features/borrower/presentation/controllers/borrower_controller.dart`<br>`test/features/borrower/borrower_widget_test.dart` | **OK** |
| **Lot 1** | **1.5 Éligibilité véhicules** : restriction stricte `car`/`car_trailer` si profil non validé | `lib/features/borrower/domain/entities/borrower_eligibility.dart`<br>`test/features/borrower/borrower_eligibility_test.dart` | **OK** |
| **Lot 1** | **1.6 Confidentialité PII** : aucun numéro de permis dans logs Dio ou chaînes d'erreur | `lib/core/network/api_client.dart`<br>`lib/features/borrower/domain/entities/borrower_submission_request.dart` | **OK** |
| **Lot 2** | **2.1 Liste paginée & filtres** : pagination, rafraîchissement, filtres par type et communauté | `lib/features/loanables/presentation/screens/explore_screen.dart`<br>`test/features/loanables/explore_screen_test.dart` | **OK** |
| **Lot 2** | **2.2 Carte adaptative** : Apple Maps (iOS) / OSM (Android/Desktop) sans crash sur coordonnées nulles | `lib/core/maps/adaptive_map_widget.dart`<br>`test/features/loanables/explore_screen_test.dart` | **OK** |
| **Lot 2** | **2.3 Fiche véhicule complète** : galerie, caractéristiques, incidents, instructions | `lib/features/loanables/presentation/screens/loanable_detail_screen.dart`<br>`test/features/loanables/loanable_detail_screen_test.dart` | **OK** |
| **Lot 2** | **2.4 Calendrier de disponibilité** : affichage par fenêtre 7 jours dans le fuseau du véhicule | `lib/features/loanables/presentation/screens/loanable_detail_screen.dart`<br>`test/features/loanables/vehicle_local_dates_test.dart` | **OK** |
| **Lot 2** | **2.5 CTA éligibilité informatif** : désactivation avec bulle d'aide pour profil non validé | `lib/features/loanables/presentation/screens/loanable_detail_screen.dart`<br>`test/features/loanables/loanable_detail_screen_test.dart` | **OK** |
| **Lot 3** | **3.1 Flux multi-étapes** : créneau, durée, distance, alternative de transport, résumé | `lib/features/loans/presentation/screens/loan_reservation_screen.dart`<br>`test/features/loans/loan_reservation_screen_test.dart` | **OK** |
| **Lot 3** | **3.2 Validation pure du brouillon** : respect des bornes véhicule et formats naifs | `lib/features/loans/domain/entities/loan_draft.dart`<br>`test/features/loans/loan_draft_test.dart` | **OK** |
| **Lot 3** | **3.3 Anti-double soumission** : verrouillage pendant `isSubmitting` | `lib/features/loans/presentation/controllers/loan_creation_controller.dart`<br>`test/features/loans/loan_reservation_screen_test.dart` | **OK** |
| **Lot 3** | **3.4 Traitement 401/403/409/422** : maintien de l'état local et mapping des erreurs de champ | `lib/features/loans/presentation/controllers/loan_creation_controller.dart`<br>`test/features/loans/loan_reservation_screen_test.dart` | **OK** |
| **Lot 3** | **3.5 Écran de succès** : affichage exclusif de la `LoanResource` avec statut `requested` | `lib/features/loans/presentation/screens/loan_success_screen.dart` | **OK** |
| **Lot 4** | **4.1 Dashboard 5 sections** : `waiting`, `future`, `started`, `completed`, `canceled/rejected` | `lib/features/loans/presentation/screens/loans_screen.dart`<br>`test/features/loans/loans_screen_dashboard_test.dart` | **OK** |
| **Lot 4** | **4.2 Séparation stricte des rôles** : filtrage `borrower_user.id == currentUser.id` pour l'emprunteur | `lib/features/loans/presentation/controllers/loans_controller.dart`<br>`test/features/loans/loans_screen_dashboard_test.dart` | **OK** |
| **Lot 4** | **4.3 Pagination & "Voir tout"** : accès complet à `GET /loans` si `total > 5` | `lib/features/loans/presentation/screens/loans_screen.dart`<br>`test/features/loans/loans_list_screen_test.dart` | **OK** |
| **Lot 4** | **4.4 Détail & Timeline** : timeline basée uniquement sur horodatages réels, commentaires | `lib/features/loans/presentation/screens/loan_detail_screen.dart`<br>`test/features/loans/loan_detail_screen_test.dart` | **OK** |
| **Lot 4** | **4.5 Actions emprunteur** : annulation (`PUT /loans/{id}/cancel`), dates (`PUT /loans/{id}/dates`) | `lib/features/loans/presentation/widgets/update_dates_dialog.dart`<br>`test/features/loans/loan_detail_screen_test.dart` | **OK** |
| **Lot 4** | **4.6 Invalidation centralisée** : fonction unique `invalidateLoanViews(ref, loanId, loanableId)` | `lib/features/loans/presentation/controllers/loans_controller.dart` | **OK** |
| **Lot 5** | **5.1 File "Demandes à traiter"** : consommation de `need_approval` issue du dashboard | `lib/features/loans/presentation/screens/loans_screen.dart`<br>`test/features/loans/loans_screen_dashboard_test.dart` | **OK** |
| **Lot 5** | **5.2 Décisions propriétaire** : acceptation et refus avec motif facultatif | `lib/features/loans/presentation/widgets/owner_decision_dialog.dart`<br>`test/features/loans/loan_detail_screen_test.dart` | **OK** |
| **Lot 5** | **5.3 Dialogues non réentrants** : boutons bloqués pendant la requête (anti-double tap) | `lib/features/loans/presentation/widgets/owner_decision_dialog.dart`<br>`test/features/loans/loan_detail_screen_test.dart` | **OK** |
| **Lot 5** | **5.4 Gestion conflit 422** : indisponibilité à l'acceptation affichée dans le dialogue | `lib/features/loans/presentation/widgets/owner_decision_dialog.dart`<br>`test/features/loans/loan_detail_screen_test.dart` | **OK** |
| **Lot 5** | **5.5 Statut dynamique** : affichage du statut retourné (`accepted`, `confirmed`, `ongoing`) | `lib/features/loans/presentation/widgets/owner_decision_dialog.dart`<br>`test/features/loans/loan_detail_screen_test.dart` | **OK** |
| **Lot 5** | **5.6 Isolation emprunteur** : masquage strict des actions propriétaire pour emprunteur | `lib/features/loans/presentation/screens/loan_detail_screen.dart`<br>`test/features/loans/loan_detail_screen_test.dart` | **OK** |
| **Lot 6** | **6.1 Table & API tokens FCM** : migration, modèle `UserPushToken`, contrôleur, dédoublonnage | `backend/app/Http/Controllers/PushTokenController.php`<br>`backend/tests/Integration/PushTokenApiTest.php` | **OK** |
| **Lot 6** | **6.2 Listeners FCM réels** : envoi sur les 5 événements avec `ShouldQueue` et `$afterCommit` | `backend/app/Listeners/SendLoan*PushNotification.php`<br>`backend/tests/Integration/Loans/PushNotificationsEventTest.php` | **OK** |
| **Lot 6** | **6.3 Purge automatique** : suppression sur jeton invalide (`NotFound`) et commande 90 jours | `backend/app/Services/FcmNotificationService.php`<br>`backend/tests/Integration/PushTokenApiTest.php` | **OK** |
| **Lot 6** | **6.4 Zero PII Payload** : seul `loan_id` technique transmis dans `data` | `mobile/lib/features/notifications/domain/entities/push_payload.dart`<br>`mobile/test/features/notifications/push_payload_test.dart` | **OK** |
| **Lot 6** | **6.5 Service & Bannière** : abstraction Flutter, SnackBar en premier plan, déduplication 60s | `mobile/lib/features/notifications/`<br>`mobile/test/features/notifications/` | **OK** |
| **Lot 6** | **6.6 Révocation au logout** : suppression locale et distante sans blocage hors-ligne | `mobile/lib/features/notifications/presentation/controllers/notifications_controller.dart`<br>`mobile/test/features/notifications/notifications_controller_test.dart` | **OK** |
| **Lot 6** | **6.7 Tests sur matériel physique** : réceptions premier plan/APNs/FCM réelles | `mobile/docs/lot_6.md` §3 | **Non vérifiable** *(Environnement sans device physique connecté ni certificat APNs dev)* |

---

## 3. Traçabilité des 9 Écarts Connus (Issus de la review du Lot 3)

| Écart identifié | Diagnostic dans le code actuel | Statut d'audit | Action requise Lot 7 |
|---|---|---|---|
| **1. Vérification disponibilité avant POST /loans** | Implémentée dans `LoanCreationController.submitReservation()` (l. 270-280) via `_checkAvailability()`. | **Conforme (Résolu)** | Couvert par test existant. |
| **2. Comparaison des intervalles : UTC vs naïve** | Implémentée via comparaison directe des chaînes naïves `rawStart`/`rawEnd` avec `departureAtString`. | **Conforme (Résolu)** | Maintenir les tests de non-régression. |
| **3. Erreurs 422 par champ invisibles depuis résumé** | `_clearFieldError` n'efface que le champ touché. Cependant, l'étape 2 (résumé) n'affiche pas les erreurs spécifiques de champ si la redirection échoue. | **Partiellement conforme** | Ajouter un récapitulatif des erreurs de champ dans le dialogue/bannière du résumé. |
| **4. Conflit Laravel = 422 (pas 409)** | Géré dans `LoanCreationController` : `ValidationException` (422) teste `isAvailabilityError` et bascule à l'étape 0 avec message d'indisponibilité. | **Conforme (Résolu)** | Vérifier l'affichage du message exact dans les tests d'intégration. |
| **5. Éligibilité CTA actif si non connecté** | `canRequest` dans `loanable_detail_screen.dart` exige explicitement `user != null`. Bouton désactivé avec message d'orientation. | **Conforme (Résolu)** | Couvert par `loanable_detail_screen_test.dart`. |
| **6. Bouton « Suivant » réentrant (disponibilité)** | Désactivé côté UI (`onPressed: null`), mais le contrôleur `goToTripDetailsStep()` ne vérifiait pas `state.isCheckingAvailability`. | **Anomalie identifiée** | Ajouter la garde `if (state.isCheckingAvailability \|\| state.isSubmitting) return false;` dans `goToTripDetailsStep()`. |
| **7. Sélecteur de date borné par l'horloge appareil** | `firstDate` est calculé avec `DateTime.now()` (horloge appareil) au lieu de `VehicleLocalDates.nowYmdInZone(loanable.timezone)`. Autorise une date passée si décalage de fuseau/horloge. | **Anomalie identifiée (KO)** | Utiliser `VehicleLocalDates.nowYmdInZone(loanable.timezone)` pour borner `firstDate`. |
| **8. Écran de succès de repli avec données non Laravel** | La route `/loans/:id/success` sans `extra` affiche un écran sobre avec l'ID de la demande, sans inventer de données. | **Conforme (Résolu)** | Recommander de charger `GET /loans/{id}` si l'ID est disponible sans `extra`. |
| **9. Payload présenté comme « observé » vs fixture** | Clarifié dans la documentation des lots 3 à 6 pour isoler formellement les fixtures hermétiques des logs réels. | **Conforme (Résolu)** | Respecter cette règle dans le compte-rendu du Lot 7. |

---

## 4. Spécification des Flavors & Environnements

### 4.1 Configuration Android (`mobile/android/app/build.gradle.kts`)
- `flavorDimensions += listOf("environment")`
- **Flavor `staging`** :
  - `applicationIdSuffix = ".staging"` → Identifiant effectif : `app.locomotion.mobile.staging`
  - `resValue("string", "app_name", "LocoMotion (Staging)")`
- **Flavor `prod`** :
  - `applicationId = "app.locomotion.mobile"`
  - `resValue("string", "app_name", "LocoMotion")`

### 4.2 Configuration iOS (`mobile/ios/Runner.xcodeproj`)
- Schémas Xcode : `staging` et `prod`
- **Target `staging`** :
  - `PRODUCT_BUNDLE_IDENTIFIER = app.locomotion.mobile.staging`
  - `BUNDLE_DISPLAY_NAME = LocoMotion (Staging)`
- **Target `prod`** :
  - `PRODUCT_BUNDLE_IDENTIFIER = app.locomotion.mobile`
  - `BUNDLE_DISPLAY_NAME = LocoMotion`

### 4.3 Configuration Mobile Dart (`lib/core/config/env.dart`)
- Support des entrypoints :
  - `lib/main_staging.dart` (`Environment.staging`, URL par défaut HTTPS staging)
  - `lib/main.dart` (`Environment.prod` par défaut en release, `Environment.dev` en debug)
- Aucune URL de production dans le build staging. URLs strictement HTTPS pour staging/prod.

---

## 5. Pipeline CI (`.github/workflows/ci.yml`)

Mise en place d'un workflow GitHub Actions complet et bloquant :

```yaml
name: CI

on:
  push:
    branches: [ main, 'feat/**', 'fix/**' ]
  pull_request:
    branches: [ main ]

jobs:
  mobile:
    name: Mobile Quality & Tests
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true
      - name: Install dependencies
        run: flutter pub get
        working-directory: mobile
      - name: Verify Code Formatting
        run: dart format --output=none --set-exit-if-changed lib test
        working-directory: mobile
      - name: Analyze Static Analysis
        run: flutter analyze
        working-directory: mobile
      - name: Run Flutter Tests
        run: flutter test
        working-directory: mobile

  backend:
    name: Backend Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: mbstring, intl, pdo_pgsql, zip
          coverage: none
      - name: Install Composer dependencies
        run: composer install --prefer-dist --no-interaction
        working-directory: backend
      - name: Run Backend Tests
        run: php artisan test
        working-directory: backend
        env:
          DB_CONNECTION: sqlite
          DB_DATABASE: ':memory:'
```

---

## 6. Tests Automatisés Laravel Exigés (Backend Concurrence)

Le Lot 7 exige la présence et la validation des tests Laravel pour :
1. Création de réservation (`LoanTest.php` : déjà couvert).
2. Emprunteur non validé (`testCannotCreateCarLoanWhenBorrowerSuspended` : déjà couvert).
3. **Conflit de disponibilité et concurrence (À ajouter dans `LoanRequestTest.php`)** :
   - Deux demandes de réservation sur le même créneau sont toutes les deux créées au statut `requested` (comportement normal du mode sur demande).
   - Dès que le propriétaire accepte la première demande (`PUT /loans/{id}/accept`), celle-ci passe à `accepted` (ou `confirmed`).
   - Lorsque le propriétaire tente d'accepter la deuxième demande en conflit, l'appel renvoie immédiatement **422** avec le message `« Le véhicule n'est pas disponible sur cette période. »`, et la deuxième demande demeure au statut `requested` sans altération.
4. Permissions propriétaire/emprunteur (`LoanPolicyTest.php` & `LoanRequestTest.php` : déjà couvert).
5. Annulation (`LoanTest.php` : déjà couvert).
6. Tokens push (`PushTokenApiTest.php` & `PushNotificationsEventTest.php` : déjà couvert).

---

## 7. Matrice QA Minimale (Recette Manuelle & Automatisée)

Chaque cas de recette est consigné avec son résultat attendu et exécuté :

| Domaine | Cas obligatoires | Condition de succès attendue |
|---|---|---|
| **Session** | Login OK / Bad credentials | Token JWT enregistré dans `SecureStorage`, rafraîchi sans déconnexion; mot de passe incorrect affiche une erreur claire. |
| **Session** | Refresh token expiré | Retour propre à l'écran de login sans boucle infinie, stockage local nettoyé. |
| **Session** | Logout | Révocation distante du jeton push sur le backend, nettoyage des jetons locaux, réinitialisation des contrôleurs. |
| **Éligibilité** | Utilisateur non connecté | Fiche véhicule affiche CTA désactivé avec message invitant à la connexion. |
| **Éligibilité** | Dossier absent / soumis / validé / suspendu | Seul l'état `validated` active la réservation de voitures et remorques d'autos; vélos et remorques simples autorisés. |
| **Fuseaux** | Appareil dans un fuseau ≠ véhicule | Les dates affichées, les créneaux envoyés et les disponibilités respectent strictement l'heure locale du véhicule sans conversion implicite. |
| **Demande** | Parcours complet vers `requested` | Créneau valide → vérification disponibilité → distance/alternative → résumé → `POST /loans` → écran de confirmation `requested`. |
| **Demande** | Créneau réservé entre-temps | Erreur serveur 422 reçue → affichage du message d'indisponibilité, redirection étape 0, aucune réservation locale créée. |
| **Demande** | Double tap soumission | Un seul appel `POST /loans` émis sur le réseau (`isSubmitting` non-réentrant). |
| **Demande** | Erreur 422 de validation de champ | Formulaire conservé en mémoire, champs en erreur surlignés avec message serveur. |
| **Suivi** | Séparation des catégories | L'emprunteur ne voit que ses propres réservations dans `started`, `future`, `completed`; les demandes à traiter sont isolées. |
| **Suivi** | Modification de dates | `PUT /loans/{id}/dates` envoie l'heure naïve dans le fuseau du véhicule; conflit 422 affiche l'erreur sans altérer les dates locales. |
| **Propriétaire** | Acceptation & Statut renvoyé | Acceptation met à jour le prêt vers son statut serveur (`accepted`, `confirmed` ou `ongoing`) et rafraîchit la file. |
| **Propriétaire** | Refus avec/sans commentaire | Refus met à jour vers `rejected` et envoie la notification push/email à l'emprunteur. |
| **Propriétaire** | Traitement concurrent par co-propriétaire | Si une demande a déjà été acceptée/refusée, tentative ultérieure renvoie 403/422 géré sans crash. |
| **Push** | Réception premier plan | Affichage d'un SnackBar flottant sans navigation brutale, invalidation des caches de données de prêt. |
| **Push** | Tap notification app en arrière-plan/tuée | Navigation vers `/loans/:id`. Si prêt inaccessible (403/404), message contrôlé avec bouton retour dashboard. |
| **Réseau** | Perte réseau pendant l'envoi | Message d'erreur réseau explicite, pas de faux succès, réessai possible. |
| **Deep-links** | `/loans/:id` et `/loanables/:id/reserve` à froid | Chargement sécurisé des ressources depuis l'API sans plantage sur paramètre manquant. |

---

## 8. Vérification Sécurité & Audit des Traces

1. **Exclusion Git des secrets** :
   ```bash
   git ls-files | grep -Ei "google-services|GoogleService-Info|\.env|\.jks|\.p12|\.mobileprovision"
   ```
   Doit retourner uniquement `.env.example` dans `backend`. Aucun fichier de clé de production ou de keystore dans le dépôt.
2. **Protection Zero PII dans les logs Dio (`api_client.dart`)** :
   - `requestBody: false` et `responseBody: false` systématiques.
   - Les logs de débogage Dio ne doivent pas être inclus dans les builds staging/release.
3. **Nettoyage des fichiers temporaires** :
   - Les fichiers uploadés (`gaa`, `saaq`) sont stockés dans le cache temporaire et purgés après émission de la requête multipart.

---

## 9. Procédure de Packaging Staging & Procédure de Rollback

### 9.1 Préparation des artefacts Staging (sans publication automatique)
- Android (AAB) :
  ```bash
  flutter build appbundle --flavor staging -t lib/main_staging.dart
  ```
- iOS (IPA) :
  ```bash
  flutter build ipa --flavor staging -t lib/main_staging.dart
  ```

### 9.2 Procédure de Rollback Applicatif Mobile
1. **TestFlight (iOS)** :
   - Si une régression critique est constatée sur le build `staging` N, désactiver immédiatement le groupe de testeurs internes sur le build N dans App Store Connect.
   - Réactiver la distribution du build précédent stable N-1.
2. **Google Play Console (Android / Test interne)** :
   - Créer une nouvelle release sur le canal de test interne en important l'artefact N-1 précédent tout en incrémentant le versionCode si requis par la console (`versionCode` N+1 contenant le binaire stable N-1).
3. **Rollback Backend (Laravel)** :
   - En cas d'incompatibilité de schéma de base de données :
     ```bash
     php artisan migrate:rollback --step=1
     ```
   - Revenir au commit backend précédent et redémarrer les workers de file d'attente :
     ```bash
     php artisan queue:restart
     ```

---

## 10. Règle d'Arrêt & Prochaines Étapes

Conformément à la gouvernance de livraison :
1. ✅ **Étape 1 terminée** : Vérification des préconditions des Lots 0 à 6, audit des écarts connus et formalisation de la spécification technique [mobile/docs/lot_7_spec.md](file:///Users/fabapps/Documents/Dev/locomotion/mobile/docs/lot_7_spec.md).
2. ⏸️ **Point d'arrêt pour approbation** : Présentation au responsable produit du tableau d'audit, des anomalies identifiées et de la stratégie d'implémentation.
3. 🚀 **Étape 2 (après accord)** :
   - Correction des deux anomalies de contrôleur/UI identifiées (garde réentrante dans `goToTripDetailsStep`, calcul de `firstDate` avec le fuseau véhicule).
   - Ajout du test de concurrence d'acceptation dans `LoanRequestTest.php` sur Laravel.
   - Création du workflow GitHub Actions `.github/workflows/ci.yml`.
   - Configuration des flavors Android et iOS.
   - Formatage de code (`dart format`) et validation complète des suites de tests.
