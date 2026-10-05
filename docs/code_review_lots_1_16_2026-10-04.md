# Revue mobile lots 1 à 16 et impact sur le backend

Date : 4 octobre 2026. Revue en lecture seule du code applicatif ; seul ce rapport a été ajouté.

## Conclusion

**La version ne peut pas être déclarée conforme ni prête pour un pilote financier.** Les fonctionnalités des lots sont largement présentes, mais plusieurs défauts touchent l'isolation des comptes, le paiement réel, les preuves d'inspection et la compatibilité avec la web app.

**27 points à corriger : 8 P1 et 19 P2.** P1 signifie blocage de lancement ou risque important de sécurité, de facturation ou de perte de preuve. P2 signifie défaut fonctionnel, exigence non tenue ou défaut de validation à traiter avant de certifier les lots concernés. Ces priorités ne constituent pas une estimation d'effort.

Le backend réutilise bien ses modèles, factures, policies, uploads et routes historiques de prolongation. Cependant, il ajoute aussi un deuxième chemin de règlement et modifie globalement les règles de confirmation. Cela contrevient à l'objectif d'un mobile qui réutilise une web app fonctionnelle : certains nouveaux parcours mobiles cassent ou contournent les parcours web existants.

## Règle de référence précisée après la revue

**Le backend en place et ses parcours web fonctionnels sont le référentiel. Le mobile est un client supplémentaire de ce système.** Les spécifications des lots mobiles doivent être corrigées lorsqu'elles imposent une règle incompatible avec ce référentiel ; elles ne justifient pas à elles seules une modification du backend.

Cette référence vise les contrats et règles métier existants, avant les régressions introduites pour le mobile. Elle ne signifie pas qu'il faut reproduire dans Flutter les nouveaux défauts financiers identifiés. Tarifs, taxes, soldes, droits, éligibilité, disponibilités, transitions des prêts et résultat des mutations restent déterminés par le serveur. Le mobile affiche ces résultats, gère les interactions et recharge l'état serveur après une mutation ou une interruption ; un calcul local ne doit pas autoriser une action ou remplacer une valeur comptable serveur.

L'ordre de préférence est : **route existante → adaptation du mobile → petit complément d'API réutilisant le métier existant**. Un changement de règle métier partagé n'entre pas dans le minimum technique mobile. Il nécessite une décision produit distincte et une validation du web.

Les constats R01–R27 restent valides. En revanche, « indispensable si la fonctionnalité est conservée » dans l'inventaire ci-dessous exprime une dépendance technique conditionnelle, pas une recommandation de conserver toutes les fonctionnalités des lots. La stratégie prioritaire est de réduire le périmètre mobile aux capacités actuelles du backend avant de compléter celui-ci.

| Domaine | Cible avec modifications backend minimales |
|---|---|
| Réservation, acceptation, confirmation, facture et solde | Appeler les routes et transitions existantes. Présenter les montants et actions permis par le serveur. Retirer la caution globale introduite pour le mobile de ce périmètre. |
| Paiement | Reprendre le parcours métier web existant et son règlement commun. PaymentSheet est une option d'interface : sa conservation peut nécessiter une adaptation serveur ciblée, mais ne justifie pas un nouveau circuit comptable. À défaut d'une adaptation minimale sûre, différer cette interface native. |
| Départ et retour | Utiliser les facteurs, uploads, validations et capacités existants, notamment `requires_mileage`. Différer l'album/signature/scellement enrichis si leur conservation exige une nouvelle fonctionnalité serveur. |
| Prolongation | Conserver estimation et mutation historiques. Retirer les promesses de renouvellement de caution absentes du référentiel. |
| Flotte | Utiliser le listing propriétaire et le CRUD existants ; retirer la dépendance à `/owner/fleet`. Adapter les actions aux états déjà supportés. Différer le nouvel état `suspended` s'il exige une évolution du métier partagé. |
| Disponibilités | Réutiliser le moteur et les formats actuels. Adapter le parsing, les erreurs et la reprise mobile. Les protections de concurrence côté serveur peuvent rester si elles corrigent un problème réel partagé, avec validation web. |
| Incidents | Réutiliser création, notes, résolution, permissions et pièces jointes existantes. Ajouter seulement une lecture authentifiée manquante si le détail ne peut pas être obtenu via l'API actuelle. |
| Notifications natives | Le stockage des installations et l'envoi push constituent un ajout propre au canal mobile si les push sont retenus. Réutiliser les événements et destinataires existants. |

La suppression d'ajouts déjà utilisés ne doit pas être un retour Git aveugle : vérifier auparavant les migrations appliquées, preuves enregistrées et opérations Stripe en cours. Tout paiement ou caution engagé doit être apuré même si le parcours est retiré du périmètre mobile.

## Périmètre et preuves

- Mobile examiné à `91e0f4881dc4e64b2506b0f7e82f034b494b2a7b` : docs des lots, roadmaps, contrats, infrastructure Flutter, parcours, data sources, entités, tests et configuration native/CI.
- Backend examiné à `f79db27f79c854fa823b46343501b39b1929bc38`, comparé à `286ecab836a0e53784cb7b560119ddd6f620ba09`, juste avant les changements liés au mobile. Cette base historique permet d'attribuer les ajouts ; elle n'est pas une certification du backend antérieur.
- Comparaison avec les consommateurs Vue existants, les transitions de `Loan`, les commandes automatiques, les resources Laravel et les dépendances natives réellement installées.
- Les deux dépôts étaient propres au début de la revue. Aucun correctif, commit, migration, déploiement ou paiement n'a été exécuté.
- Les constats ci-dessous sont des chemins démontrés par lecture croisée du code. Les défauts natifs et financiers n'ont pas été reproduits sur un appareil ou sur Stripe Sandbox pendant cette revue.

### Vérifications exécutées

| Vérification | Résultat et limite |
|---|---|
| `flutter analyze` | Réussi, aucun problème signalé. Avertissement de compatibilité Swift Package Manager pour `apple_maps_flutter`. |
| `flutter test --reporter compact` | **336 tests réussis**, environ 84 secondes. Tests unitaires/widget ; pas une recette mobile–Laravel–Stripe réelle. |
| `dart format --output=none --set-exit-if-changed mobile/lib mobile/test` | Échec : **97 fichiers sur 290** seraient reformattés. Aucun fichier n'a été réécrit. Le contrôle de format de la CI mobile échoue sur cet état. |
| `git diff --check` sur les plages historiques | Échec : espaces en fin de ligne et lignes vides finales dans docs, fichiers générés et quelques sources/tests. Ce n'est pas une preuve de bug métier. |
| PHPUnit ciblé `LoanPolicyTest` et `AvailabilityHelperTest` | Respectivement **38 et 13 erreurs, 0 assertion** : connexion MySQL refusée dans l'environnement de test local. Le serveur PostgreSQL local n'était pas disponible non plus. **Suite backend non validée par cette revue.** |
| `composer check-platform-reqs` | `ext-imagick` manque localement. La CI ajoutée omet également cette extension pourtant requise par `composer.json`. |
| Recette Android/iOS, FCM/APNs, caméra, 3DS et Stripe Sandbox | Non exécutée. Le document du lot 16 reconnaît lui-même que plusieurs de ces validations restent à faire. |

Le succès des tests Flutter ne contredit pas les défauts ci-dessous : plusieurs tests substituent les repositories, Stripe et les notifications, et contournent donc les frontières où les problèmes apparaissent.

## Points P1 : à corriger en premier

### R01 — Les données privées persistent lors d'un changement de compte

**Lots : 1, 2, 4, 5, 13 et transversal.**

Les providers persistants du dashboard, de la flotte et d'autres données personnelles ne dépendent pas de l'identité authentifiée. Le logout invalide seulement le controller d'authentification. Après A → déconnexion → B dans le même `ProviderScope`, B peut voir les données précédemment chargées pour A.

Preuves : [logout](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/auth/presentation/controllers/auth_controller.dart:93), [dashboard persistant](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/controllers/loans_controller.dart:43), [flotte persistante](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/fleet/presentation/controllers/fleet_controller.dart:23), [solde persistant](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/profile/presentation/controllers/profile_controller.dart:7).

Correction : indexer les états privés par session/utilisateur ou réinitialiser centralement leur scope à la déconnexion et au changement de compte. Ajouter un test A → B conservant le même container et vérifiant l'absence des données de A.

### R02 — Le renouvellement de token peut bloquer indéfiniment

**Lot : 1.** `AuthInterceptor` hérite de `QueuedInterceptor` et attend le refresh puis la reprise sur le même Dio intercepté. Si le refresh échoue, son erreur entre dans la file `onError` derrière le handler initial ; celui-ci attend justement cette requête. La purge des tokens et le retour au login ne se produisent pas. Une reprise qui échoue rencontre le même problème.

Preuve : [refresh et reprise récursifs](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/core/network/auth_interceptor.dart:48). La file d'erreurs séquentielle est confirmée dans le code installé de Dio 5.11.1.

Correction : Dio séparé pour le refresh, un refresh partagé pour les requêtes concurrentes et une reprise bornée qui évite cette file récursive. Tester refresh refusé, timeout, reprise encore en 401 et plusieurs 401 simultanés. Aucun test direct de cet interceptor n'a été trouvé.

### R03 — PaymentSheet Stripe ne peut pas fonctionner sur Android

**Lots : 9 et 16.** L'activité Android hérite de `FlutterActivity`. Le plugin installé `stripe_android 14.1.0` exige `FlutterFragmentActivity` et refuse explicitement cette classe au démarrage de son intégration.

Preuve : [MainActivity](/Users/fabapps/Documents/Dev/locomotion/mobile/android/app/src/main/kotlin/app/locomotion/mobile/MainActivity.kt:7). Vérification dans `StripeAndroidPlugin.kt`, lignes 331–334 du package installé.

Correction : activité et thèmes compatibles avec le package, puis recette PaymentSheet/3DS sur Android réel. Les tests avec Stripe factice ne peuvent pas valider ce prérequis.

### R04 — La nouvelle caution bloque les réservations de la web app

**Lot : 9 ; régression backend partagé.** Une voiture ou remorque automobile empruntée par un tiers reste maintenant `accepted`, même avec un solde suffisant. `/prepay` exige ensuite un ID de caution Stripe. Le composant web historique envoie uniquement `platform_tip`, et n'initialise pas ce nouveau parcours Stripe : il reçoit une erreur 422 et ne peut confirmer ces réservations.

Preuves : [confirmation modifiée](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loan.php:1188), [caution obligatoire](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanController.php:659), [payload web](/Users/fabapps/Documents/Dev/locomotion/backend/resources/app/src/components/Loan/LoanPaymentBox.vue:270).

Correction : préserver le contrat web et isoler l'activation de cette nouvelle règle, ou adapter/recetter le web avant toute activation globale. Ajouter une régression acceptation → prépaiement avec le payload web existant. L'obligation globale de caution est une évolution produit, pas un prérequis technique au mobile.

### R05 — Un paiement partiel suivi d'une relance peut encaisser deux contributions

**Lots : 8, 9 et 16.** Chaque appel à `payment-intent` crée de nouveaux intents, sans clé Stripe d'idempotence ni sauvegarde de leurs IDs avant le retour au mobile. Le mobile ne garde la contribution déjà payée qu'en RAM. Contribution réussie → caution abandonnée → fermeture de l'app → reprise : une nouvelle contribution peut être encaissée. L'ancien paiement ne figure pas nécessairement dans `Loan.meta`, donc la commande actuelle de réconciliation ne le retrouve pas.

Preuves : [création des intents](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanPaymentController.php:114), [wrapper Stripe sans options d'idempotence](/Users/fabapps/Documents/Dev/locomotion/backend/app/Services/StripeService.php:180), [mémoire volatile](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/controllers/loan_payment_controller.dart:52), [paiement mémorisé](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/controllers/loan_payment_controller.dart:158).

Correction : état financier persistant côté serveur, IDs enregistrés dès la création, rôle de chaque intent, clé stable jusqu'à Stripe, reprise du même essai et traitement des événements différés. Le mobile doit relire cet état après redémarrage. Tester interruption entre les deux feuilles Stripe avec un nouveau controller/container.

### R06 — Une contribution peut être utilisée à la place de la caution

**Lots : 9 et 16.** Le serveur accepte une caution au statut `succeeded`, sans vérifier rôle, montant, devise, client Stripe ou `capture_method`. Un emprunteur peut envoyer son intent de contribution réussi comme ID de contribution **et** comme ID de caution. Les métadonnées prêt/utilisateur correspondent ; le serveur inscrit pourtant une caution « authorized » de 250 $, sans retenue distincte.

Preuve : [validation et inscription de la caution](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanController.php:671). Les contrôles de métadonnées sont également facultatifs si celles-ci sont absentes. La contribution accepte `processing` sans suivi ultérieur démontré.

Correction : vérifier les intents attendus enregistrés par le serveur, leur rôle distinct, client, devise, montant et statut effectif. Refuser la même référence pour les deux opérations. Tester cette substitution exacte, les mauvais montants et les états non définitifs.

### R07 — Les règlements web et automatiques contournent la réconciliation mobile

**Lots : 9, 11, 12 et 16.** La déduction du prépaiement Stripe est implémentée uniquement dans `LoanPaymentController::settle`. Le endpoint web `/pay`, l'auto-validation et `MoveLoanForward` appellent encore `Loan::pay()`, qui débite la facture entière. Les contrôles de solvabilité soustraient pourtant désormais le prépaiement.

Effet : deuxième déduction sur le solde si celui-ci suffit, sinon erreur 422 alors qu'une contribution a déjà été encaissée ; caution non libérée par ces chemins. Le modèle utilisateur interdit le solde négatif, ce qui transforme certains cas en blocage plutôt qu'en découvert.

Preuves : [réconciliation dédiée](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanPaymentController.php:242), [pay historique](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanController.php:726), [auto-paiement](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loan.php:1268), [commande](/Users/fabapps/Documents/Dev/locomotion/backend/app/Console/Commands/MoveLoanForward.php:168), [débit intégral](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loan.php:1297).

Correction : une seule opération métier atomique de règlement, appelée par tous ces chemins, avec crédit du montant réellement encaissé et libération/reprise de la caution. Tester un prêt mobile clôturé par le web et par la commande automatique.

### R08 — Une photo d'inspection scellée peut être supprimée par `/factors`

**Lots : 10 et 11.** La preuve du compteur est réutilisée comme `mileageStartImage` ou `mileageEndImage`, relations historiquement éditables. Une modification autorisée des facteurs avec un ID différent ou `null` supprime l'ancienne ligne Image. L'inspection reste `completed` et conserve son hash et une URL qui renvoie désormais une image introuvable.

Preuves : [association de la preuve](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanInspectionController.php:278), [facteurs modifiables](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanController.php:463), [suppression de la ligne liée](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/BaseModelTrait.php:308).

Précision : la suppression par la relation est une suppression SQL en masse ; elle ne garantit pas le déclenchement de l'événement de suppression d'une instance Image. Le défaut confirmé est la perte de la référence accessible, sans prétendre que tous les octets sont immédiatement effacés.

Correction : conserver les preuves d'inspection immuables indépendamment des images kilométriques éditables et empêcher leur suppression/remplacement destructif. Tester modification des facteurs après scellement et vérifier que les preuves restent consultables.

## Points P2 : corrections fonctionnelles et conformité

### R09 — Le reliquat final est calculé sans les taxes

`settle` utilise `Invoice.total`, somme des montants avant taxes ; `Loan::pay()` utilise le changement réel de solde incluant les taxes. Le reliquat et le remboursement annoncés peuvent être faux, ou le règlement échouer malgré un solde égal au reliquat affiché.

Preuves : [calcul final](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanPaymentController.php:240), [total avant taxes](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Invoice.php:123), [valeur débitée](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/BillItem.php:61).

Correction : une valeur comptable unique issue du changement de solde réel ; test avec facture taxable, prépaiement partiel et solde exactement égal au reliquat.

### R10 — Une panne Stripe entraîne l'invention d'un montant prépayé

Si la récupération de l'intent échoue pendant `settle`, le serveur remplace le montant encaissé inconnu par la contribution obligatoire actuelle et crédite cette somme. Cette estimation peut différer de l'encaissement initial, notamment après modification/prolongation. `getPrepaidAmountDollars()` fait aussi ce raccourci tant que les cents réels ne sont pas enregistrés.

Preuves : [fallback financier](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanPaymentController.php:243), [estimation dans le modèle](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loan.php:1037).

Correction : persister le montant réellement encaissé ; en état inconnu, passer en réconciliation et ne pas créditer une estimation. Test : erreur Stripe après changement de prix.

### R11 — Annuler un prêt ne traite pas ses opérations Stripe

`cancel` change le statut sans libérer la caution ni traiter la contribution selon les règles d'annulation. La réconciliation ne libère que `release_pending/release_failed`, et journalise seulement les contributions de prêts annulés. Une caution encore `authorized` n'entre pas dans cette reprise.

Preuves : [annulation](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanController.php:787), [réconciliation limitée](/Users/fabapps/Documents/Dev/locomotion/backend/app/Console/Commands/ReconcileStripePrepayments.php:39).

Correction : opération d'annulation financière partagée avec reprise idempotente, suivant les règles produit retenues. Tester annulation après contribution et après autorisation de caution.

### R12 — Le cycle de caution longue et le re-prépaiement sont annoncés mais absents

La caution est créée immédiatement, quelle que soit la date du départ ; `deposit_expires_at` est fixé arbitrairement à maintenant + 7 jours. Les inspections n'imposent pas une retenue encore valide. L'estimation de prolongation signale seulement l'expiration. `LoanPolicy::prepay` autorise uniquement `accepted`, alors que le contrat annonce une reprise sur un prêt `ongoing`. Aucun renouvellement correspondant n'a été trouvé.

Preuves : [création immédiate](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanPaymentController.php:130), [expiration calculée](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanController.php:693), [warning uniquement](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanController.php:1051), [policy](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Policies/LoanPolicy.php:310), [contrat](/Users/fabapps/Documents/Dev/locomotion/mobile/docs/post_mvp_contracts.md:95).

Correction : implémenter un cycle fondé sur l'état effectif Stripe et les capacités activées, ou restreindre explicitement le périmètre autorisé. Ne pas assimiler le timestamp local à une garantie de validité bancaire. Tester départ lointain, expiration avant départ et prolongation au-delà de la retenue.

### R13 — Une libération échouée est annoncée comme réussie et ne se rejoue pas

Le backend renvoie 200 avec `deposit_status=release_failed` en cas d'échec de libération. Le mobile annonce toujours « caution libérée ». Au rejeu, le backend considère `release_failed/release_pending` comme déjà traités et retourne avant le bloc de reprise ; le mobile masque aussi l'action dès que le prêt est payé.

Preuves : [retour anticipé](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanPaymentController.php:217), [échec enregistré](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanPaymentController.php:316), [succès mobile](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/controllers/loan_settle_controller.dart:59), [message erroné](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart:719).

Correction : séparer les états du règlement et de la libération, traiter les états non terminaux et proposer une reprise sans refacturer. Test indispensable : premier échec, deuxième appel réussi, une seule facturation.

### R14 — Une remorque automobile doit fournir un compteur et un tableau de bord

Le mobile et le nouveau contrôleur d'inspection traitent `car_trailer` comme un véhicule motorisé. Ils exigent compteur et photo du tableau de bord. Le contrat métier existant expose déjà `requires_mileage`, calculé à partir des tarifs ; le DTO Flutter l'ignore.

Preuves : [classification mobile](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/domain/entities/loan.dart:139), [classification serveur](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanInspectionController.php:57), [règle métier existante](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loan.php:602).

Correction : réutiliser la capacité serveur pour le kilométrage et définir les photos indépendamment. Tester remorque automobile sans compteur et véhicule sans tarification kilométrique.

### R15 — Le profil affiche un solde réel à zéro

Flutter attend `{balance: ...}`, mais Laravel renvoie directement le scalaire. Toute autre forme et toute erreur réseau sont converties en `0.0`.

Preuves : [parsing mobile](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/profile/presentation/controllers/profile_controller.dart:14), [contrat serveur historique](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/UserController.php:683).

Correction **uniquement mobile** : parser le scalaire numérique réel et afficher les erreurs au lieu d'inventer un solde. Tester réponse numérique/chaîne numérique et panne réseau.

### R16 — Les conflits d'édition du calendrier ne sont pas récupérés

Le repository disponibilité intercepte `DioException`, alors qu'ApiClient convertit déjà 409 et 422 en `ConflictException` et `ValidationException`. Les exceptions métier attendues par le controller ne sont jamais produites avec l'API réelle. Le verrou reste obsolète après 409, et les détails des prêts conflictuels sont perdus.

Preuves : [catch incorrect](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/availability/data/repositories/availability_repository_impl.dart:102), [conversion réseau](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/core/network/api_client.dart:178).

Correction : traduire les exceptions applicatives et leur payload, recharger la version après 409, garder les conflits 422. Tester la chaîne Dio → ApiClient → repository → controller, actuellement contournée par les mocks.

### R17 — Les builds staging/prod ne sélectionnent pas leur environnement

`AppConfig.environment` est fixé à `dev`. Sans `API_BASE_URL` explicitement fourni, les flavors staging/prod utilisent aussi les adresses locales HTTP. La CI ne fournit pas cette variable. La distribution iOS staging/prod et la signature Android release ne sont pas finalisées ; Android release utilise la clé debug.

Preuves : [configuration](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/core/config/env.dart:10), [builds CI](/Users/fabapps/Documents/Dev/locomotion/mobile/.github/workflows/mobile-ci.yml:42), [signature debug](/Users/fabapps/Documents/Dev/locomotion/mobile/android/app/build.gradle.kts:48).

Correction : configuration effective par environnement, validation de l'URL/clé à la construction, commandes documentées qui correspondent aux entrypoints/schemes présents, artefacts staging et release correctement signés.

### R18 — Firebase non configuré bascule vers des notifications factices en production

Le plugin Google Services Android n'est pas appliqué ; aucun plist Firebase n'est référencé dans le projet iOS examiné, et `Firebase.initializeApp()` n'utilise pas d'options explicites. Déposer simplement les fichiers comme le guide le prévoit ne finalise pas l'intégration native. En cas d'échec, le provider emploie sans restriction un fake annonçant une permission accordée et le token constant `fake_fcm_token_123456`, qui peut être enregistré au backend.

Preuves : [Gradle](/Users/fabapps/Documents/Dev/locomotion/mobile/android/app/build.gradle.kts:1), [initialisation](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/main.dart:26), [fallback](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/notifications/presentation/controllers/notifications_controller.dart:23), [token factice](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/notifications/data/services/fake_push_notification_service.dart:5).

Correction : intégration native/configuration par environnement ; fake injecté seulement dans les tests. Hors tests, un service indisponible doit être explicite et ne pas enregistrer de faux appareil. Recetter réception et ouverture Android/iOS en premier plan, arrière-plan et démarrage à froid.

### R19 — Capture photo non récupérable après destruction de l'activité Android

La capture attend uniquement `pickImage`; aucun `retrieveLostData` n'est utilisé. Si Android tue l'app pendant la caméra, le résultat n'est pas rattaché au brouillon après redémarrage. Ce cas est documenté par le package `image_picker` installé.

Preuve : [capture](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/core/services/inspection_photo_service.dart:48).

Correction : enregistrer le contexte utilisateur/prêt/champ avant la capture et traiter les données perdues au redémarrage. Faire une recette de destruction/recréation d'activité.

### R20 — La déduplication des créations véhicule/incident n'est pas atomique

Le véhicule utilise recherche puis insertion, avec un simple index non unique sur `idempotency_key`. L'incident utilise lecture de cache puis insertion puis écriture de cache. Deux requêtes simultanées avec la même clé peuvent toutes deux créer un objet. Le cache incident expirant en un jour ne constitue pas une identité durable de l'opération.

Preuves : [création véhicule](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanableController.php:114), [index non unique](/Users/fabapps/Documents/Dev/locomotion/backend/database/migrations/2026_10_03_190000_add_suspension_and_idempotency_to_loanables_table.php:17), [cache incident](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/IncidentController.php:261), [écriture après création](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/IncidentController.php:350).

Correction : unicité par auteur/type d'opération/clé, traitement atomique du doublon et résultat stable ; vérifier aussi que la même clé ne masque pas un payload différent. Tester deux transactions réellement concurrentes.

### R21 — Le nouveau statut `suspended` n'est pas intégré au web et aux filtres

Le modèle retourne `availability_status=suspended`, mais le composant web ne l'affiche pas et `scopeAvailabilityStatus` ne le traite pas. Le filtre historique `has_availabilities` peut inclure un véhicule suspendu, puisqu'il examine toujours le calendrier/publication sans cette nouvelle condition.

Preuves : [nouvelle valeur](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loanable.php:840), [filtres incomplets](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loanable.php:913), [affichage web](/Users/fabapps/Documents/Dev/locomotion/backend/resources/app/src/components/Loanable/AvailabilityStatus.vue:26).

Correction : traiter la valeur dans tous les consommateurs, filtres et traductions ; vérifier également recherche et listings historiques. La garde finale serveur empêche la réservation, mais ne corrige pas ces incohérences de présentation.

### R22 — Le nouveau listing flotte charge tout et multiplie les requêtes

`ownerFleet` utilise `get()` sans pagination, y compris pour un admin qui récupère toute la flotte. Chaque resource recalcule plusieurs `count()` ; `future_loans_count` relance des compteurs déjà calculés, et les rôles utilisés ne sont pas préchargés. Le nombre de requêtes croît avec le nombre de véhicules.

Preuves : [listing non borné](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Controllers/LoanableController.php:913), [resource](/Users/fabapps/Documents/Dev/locomotion/backend/app/Http/Resources/Loanable/OwnerFleetResource.php:26), [compteurs](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loanable.php:863).

Correction : réutiliser le listing paginé existant, ou borner cette projection et agréger les compteurs avec `withCount`/requêtes groupées. Vérifier un budget de requêtes stable sur plusieurs pages.

### R23 — Des réponses tardives affichent les prêts du mauvais filtre

La liste ne capture pas une génération de requête ni ne vérifie le filtre avant d'intégrer la réponse. Deux filtres rapides avec réponses inversées peuvent afficher les données du premier sous la puce du second ; une ancienne pagination peut également mélanger les pages.

Preuve : [chargement et insertion](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loans_list_screen.dart:53).

Correction : identifiant de requête/filtre capturé et rejet des réponses obsolètes, ou annulation. Tester des futures contrôlées terminées dans l'ordre inverse.

### R24 — Quitter le formulaire conducteur pendant l'upload provoque une erreur de cycle de vie

Le succès et le catch exécutent `setState` après `await` sans vérifier `mounted`, alors que l'écran peut être quitté. La sélection de fichier présente le même schéma.

Preuve : [callbacks d'upload](/Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/borrower/presentation/screens/borrower_form_screen.dart:92).

Correction : garde de cycle de vie et politique de poursuite/annulation explicite. Test : upload en attente, navigation retour, terminaison du future.

### R25 — Les feature flags de rollback n'ont aucun effet

Le helper `FeatureFlag` n'a aucun appel dans `app`, `routes` ou `tests`. Les trois valeurs de configuration ne contrôlent donc ni inspections, ni prolongations, ni push incidents. La procédure de rollback du lot 16 promet pourtant cette désactivation.

Preuves : [helper inutilisé](/Users/fabapps/Documents/Dev/locomotion/backend/app/Helpers/FeatureFlag.php:5), [procédure](/Users/fabapps/Documents/Dev/locomotion/mobile/docs/lot_16_spec.md:236).

Correction : brancher une activation réellement testée, préservant l'apurement des prêts engagés et le fonctionnement web, ou supprimer le faux mécanisme et corriger le protocole. Tester chaque flag désactivé.

### R26 — Les contrôles CI ajoutés ne valident pas correctement la livraison

Le format Flutter échoue sur 97 fichiers. La CI Laravel installe Composer sans `imagick`, extension obligatoire. Sa commande répète `--filter` : PHPUnit conserve le dernier filtre, donc elle n'exécute pas les deux groupes annoncés ; `PushTokenTest` ne correspond d'ailleurs pas au nom `PushTokenApiTest`. Les suites post-MVP et les régressions web ne sont pas incluses dans cette commande.

Preuves : [format CI mobile](/Users/fabapps/Documents/Dev/locomotion/mobile/.github/workflows/mobile-ci.yml:31), [extensions backend](/Users/fabapps/Documents/Dev/locomotion/backend/.github/workflows/backend-ci.yml:37), [filtrage](/Users/fabapps/Documents/Dev/locomotion/backend/.github/workflows/backend-ci.yml:65). Le comportement du filtre a été vérifié dans `PHPUnit 10.5.40`, `TextUI/Configuration/Cli/Builder.php:396`.

Correction : formater, fournir les prérequis PHP et une configuration de test autonome, employer un filtre unique correct ou des suites explicites, puis exécuter les contrôles post-MVP et web pertinents. Ne pas assimiler un APK debug à un artefact de distribution validé.

### R27 — La certification du lot 16 dépasse les preuves et sa matrice référence des fichiers inexistants

La matrice confond les lots 11/12/13 et référence notamment `LoanExtensionController`, `LoanExtensionService`, `LoanSettlementService`, `loan_validation_screen` et d'autres fichiers absents. Elle affirme une persistance de contribution qui n'est qu'une map en RAM, et certifie l'intégrité financière malgré les défauts R04–R13. Le test nommé `testConcurrentSettleIsIdempotent` fait deux appels séquentiels ; il ne valide pas le chevauchement des transactions. La recette appareil et Stripe Sandbox est encore marquée à exécuter.

Preuves : [matrice](/Users/fabapps/Documents/Dev/locomotion/mobile/docs/lot_16_spec.md:38), [statut déclaré](/Users/fabapps/Documents/Dev/locomotion/mobile/docs/lot_16_spec.md:210), [rejeu séquentiel](/Users/fabapps/Documents/Dev/locomotion/backend/tests/Integration/Loans/LoanInspectionReturnTest.php:724).

Correction : refaire la matrice exigence → fichier réel → test réel → preuve de recette. Reclasser les validations en code examiné, tests simulés réussis, tests serveur exécutés et staging/matériel à faire. Ajouter des tests avec deux connexions/transactions et un véritable redémarrage client.

## Conformité par lot

« Partiel » signifie que l'implémentation existe mais ne remplit pas toutes les exigences. Aucun lot dépendant des paiements réels ne doit être certifié sur le seul succès de fixtures.

| Lot | Résultat de la revue | Principales réserves |
|---|---|---|
| 1 — Auth et dossier emprunteur | Partiel | R01, R02, R24 ; dossier/upload/éligibilité présents. |
| 2 — Recherche et fiche | Présent, conformité partielle | Isolation des données R01 ; parsing et états réels largement présents. Suspension R21 à harmoniser. |
| 3 — Réservation | Présent, validation intégrée restante | Garde anti-double tap et vérification serveur présentes ; dépend des corrections auth et de la recette des conflits réels. |
| 4 — Suivi emprunteur | Partiel | R01, R23 ; dashboard, commentaires et modification des dates présents. |
| 5 — Actions propriétaire | Présent, réserves transversales | Actions et invalidation présentes ; sessions R01 et changements de confirmation R04. |
| 6 — Push | Partiel, non validé sur matériel | Backend FCM/tokens présent ; R18 et recette FCM/APNs restante. |
| 7 — Distribution MVP | Partiel | R17, R18, R26 ; flavors déclarés sans configuration effective complète. |
| 8 — Contrats et socle | Non aligné entièrement | Idempotence, cycle de caution et reprise R05, R06, R10–R12 ; contrats annoncent plus que le code. |
| 9 — Paiement/caution | Non conforme pour activation | R03–R07, R10–R12. |
| 10 — Départ/inspection | Partiel | R08, R14, R19 ; contrôle des accès et verrou du prêt présents. |
| 11 — Retour/validation/règlement | Non conforme sur le financier | R07–R10, R13, R14 ; preuve et reprise caméra à traiter. |
| 12 — Prolongation | Partiel | Bonne réutilisation des routes historiques/verrous ; cycle de caution/re-prépaiement R12 et comptabilité commune R07. |
| 13 — Flotte propriétaire | Partiel | R01, R20–R22 ; CRUD existant réutilisé, route flotte supplémentaire évitable. |
| 14 — Disponibilités | Partiel | Moteur Laravel réutilisé et règles inconnues conservées ; chaîne de conflits R16, effets suspension R21. |
| 15 — Incidents | Partiel | Détail, notes, permissions et mapping présents ; déduplication R20 et push R18 à valider. |
| 16 — QA et pilote | Non terminé au sens des critères d'acceptation | R25–R27 ; plusieurs P1, recette physique/Sandbox non exécutée. |

## Ce qui a été ajouté dans le backend

Le diff historique représente **64 fichiers, 9 049 lignes ajoutées et 835 supprimées**. Il comprend 4 610 lignes ajoutées de tests et 586 dans le lock Composer ; le reste représente 3 853 ajouts et 326 suppressions de code/configuration/CI. Le volume brut ne permet donc pas de conclure que tout ce développement est superflu.

Deux migrations ont été ajoutées : table `user_push_tokens`, puis champs de suspension et clé d'idempotence de `loanables`. Les inspections et états Stripe utilisent le `meta` existant des prêts, sans nouvelle table dédiée. Douze routes ont été ajoutées : trois pour les tokens push, une de détail incident, une de PaymentIntent, trois d'inspection, une de règlement, une de flotte et deux de suspension/réactivation.

| Ajout | Fonction | Indispensable pour cette version ? |
|---|---|---|
| `UserPushToken`, migration, controller/resource/request, service FCM, listeners, dépendance Firebase et purge | Enregistrer les installations et notifier les événements existants | **Oui si les push sont conservés.** Le web n'avait pas ce canal. Réutiliser ses événements/destinataires/emails est la bonne approche. |
| Session Stripe PaymentIntent, clé éphémère et méthodes de `StripeService` | Alimenter PaymentSheet sans exposer de secret serveur | **Oui si PaymentSheet est conservé.** Une petite adaptation serveur est nécessaire. Le suivi persistant et la validation des intents sont aussi indispensables, mais incomplets. |
| Caution systématique de 250 $, nouveaux champs de réponse et changement global de confirmation | Ajouter une retenue bancaire par prêt | **Conditionnel, évolution produit.** Le fait d'avoir un client mobile ne l'impose pas ; les documents post-MVP la demandent, mais son activation doit préserver le web et respecter le cycle financier complet. |
| `LoanInspectionController`, album/signature dans `Loan.meta`, permissions médias et champs de réponse | Enregistrer les inspections enrichies des lots 10/11 | **Oui pour les inspections enrichies retenues.** Les facteurs historiques n'offraient pas seuls cet album/scellement. Réutiliser images, autorisations et facteurs existants, tout en préservant l'immuabilité des preuves. |
| `/settle` et réconciliation prépaiement/libération | Finaliser les nouveaux paiements | **La capacité est indispensable ; le deuxième chemin métier ne l'est pas.** Elle doit être intégrée au règlement commun, pas vivre à côté de `/pay` et de l'automatisation. |
| `ReconcileStripePrepayments` | Reprendre les libérations et détecter certaines incohérences | **Nécessaire avec ces opérations externes**, mais actuellement trop limitée : intents jamais persistés invisibles, annulations incomplètes. À étendre autour d'un état financier commun. |
| Verrous et transactions réservation/acceptation/dates/prolongations ; `community_id` nullable | Sécuriser les mutations et accepter le payload mobile cohérent | **Justifié.** Correction du backend partagé et alignement de contrat ; conserver et tester aussi les consommateurs web. |
| Validation des conflits calendrier et verrou optimiste | Éviter écrasement concurrent et blocage silencieux de prêts existants | **Justifié pour le lot 14**, sans nouveau moteur calendrier. La correction du mapping d'erreurs doit être mobile. |
| `/owner/fleet`, `OwnerFleetResource`, getters de compteurs/rôle | Listing propriétaire prêt à afficher | **Évitable comme nouvelle route.** `GET /loanables?for=profile` et `scopeManagedBy` existaient déjà. Une projection/enrichissement borné peut rester utile ; la sélection propriétaire n'avait pas besoin d'être reconstruite. |
| Suspension/réactivation et migration associée | Geler les nouvelles demandes en conservant calendrier et historique | **Conditionnel au contrat du lot 13.** L'état indépendant a un intérêt si dépublication et `availability_mode=never` ne correspondent pas aux conséquences souhaitées. Ce n'est pas un prérequis technique au mobile ; intégrer tous les consommateurs avant activation. |
| Détail incident, relation images, policy et push | Ouvrir un signalement depuis une notification et fournir ses preuves | **Justifié si le lot 15 est conservé.** Étendre le modèle incident existant est préférable à créer un domaine parallèle. La création/notes/résolution existaient déjà. |
| `FeatureFlag` et trois configurations | Activation/rollback annoncé | **Superflu en l'état : code mort.** Brancher réellement avec tests si ce pilotage est retenu, sinon retirer et rectifier la documentation. |
| Fallback GD dans images | Faire fonctionner les environnements sans Imagick | **Pas indispensable au mobile.** Changement d'environnement général ; ne corrige pas le prérequis Composer/CI qui exige encore Imagick. |
| Tests et CI | Contrôler sécurité et régressions | **Justifié**, mais corriger les prérequis, filtres et faux tests de concurrence. Le volume de tests n'est pas un doublon métier. |

### Réutilisation déjà pertinente

Les authentifications Passport, dossiers emprunteurs, uploads `/files` et `/images`, factures et calculs tarifaires, dashboard, acceptation/refus, commentaires, CRUD véhicule, calendrier et prolongations sont largement réutilisés. Il n'y a pas de nouveau backend mobile complet ni de second moteur de disponibilité.

Le filtre sûr des véhicules gérés existait dans [scopeFor profile](/Users/fabapps/Documents/Dev/locomotion/backend/app/Models/Loanable.php:1022). Cela invalide la justification selon laquelle une nouvelle route flotte serait indispensable faute de filtre propriétaire existant.

### Développement à réduire ou à recentrer

1. **Fusionner les chemins financiers**, plutôt qu'ajouter des correctifs uniquement à `/settle`. Garder les controllers comme adaptateurs et centraliser encaissement, crédit, facturation, remboursement/libération et reprise.
2. **Retirer le listing flotte parallèle ou en faire une projection paginée de l'existant.** Mutualiser les compteurs et relations ; ne pas charger tout le parc admin.
3. **Utiliser les capacités métier déjà exposées**, notamment `requires_mileage`, plutôt que répéter une classification `car/car_trailer` dans plusieurs couches.
4. **Séparer les changements produit des adaptations mobiles.** Caution globale et suspension peuvent être légitimes, mais ne doivent pas modifier silencieusement les garanties et parcours web.
5. **Supprimer les dispositifs sans effet**, ou les terminer : flags de rollback, promesses de renouvellement et certifications sans preuves.
6. **Conserver les renforcements de sécurité et tests utiles.** Les verrous, vérifications de permissions et essais de régression ne sont pas du développement superflu parce qu'ils ne servent pas exclusivement Flutter.

Avec la priorité donnée au référentiel existant, **aucun nouveau moteur métier n'est nécessaire pour le mobile**. Le minimum backend candidat est le canal push, si retenu, et les rares lectures/adaptations d'API dont l'absence est démontrée. L'adaptation Stripe native et les inspections enrichies restent conditionnelles : les différer est préférable à élargir le backend pour satisfaire les lots. Les protections de sécurité partagées doivent être évaluées séparément des fonctionnalités nouvelles. Une règle de paiement ou de facture ne doit pas diverger selon le client qui l'appelle.

## Ordre de correction et critères de nouvelle validation

1. Recentrer les contrats des lots sur le backend historique : retirer les exigences de caution globale, règlement parallèle, flotte parallèle et suspension nouvelle du périmètre minimal. Identifier les opérations déjà engagées à préserver/apurer avant tout retrait.
2. Traiter R01–R08 sur le périmètre conservé : isolation/refresh, compatibilité web et conservation des preuves ; Stripe natif, idempotence et validation financière seulement si ce parcours est retenu. Les opérations financières déjà engagées restent à sécuriser dans tous les cas.
3. Si les nouvelles opérations Stripe sont conservées, fiabiliser la comptabilité et le cycle de caution R09–R13 ; tester les annulations, expirations, erreurs Stripe et reprises après redémarrage.
4. Corriger les contrats et parcours R14–R24 sur le périmètre conservé ; supprimer les doublons identifiés sans changer inutilement les API historiques.
5. Rendre CI et rollout vérifiables R25–R27, puis réexécuter mobile et suites Laravel dans une base de test isolée PostGIS.
6. Réaliser la recette croisée du périmètre conservé : web → mobile et mobile → web ; Android/iOS réels ; FCM/APNs si retenu ; caméra avec recréation d'activité ; Stripe Sandbox/3DS si retenu ; concurrence avec transactions qui se chevauchent ; coupure réseau après effet serveur.

Pour accepter la version : aucune donnée du compte précédent, aucun second encaissement, aucune fausse caution, aucune perte de preuve, aucun parcours web bloqué par une exigence mobile, et chaque affirmation de la matrice lot 16 reliée à une preuve effectivement exécutée.
