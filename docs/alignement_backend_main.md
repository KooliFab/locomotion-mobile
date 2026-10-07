# Alignement du mobile sur le backend `main`

Date : 7 octobre 2026. Suite de la revue [code_review_lots_1_16_2026-10-04.md](code_review_lots_1_16_2026-10-04.md).

## Référence

Le référentiel est la branche **`main` du dépôt backend GitLab** (`reseau-locomotion/locomotion.app`), c'est-à-dire les fonctionnalités déjà exposées à la web app. La branche `main` locale du backend contient les lots mobiles L8 à L14 et ne sert pas de référence.

Le mobile n'utilise que des routes présentes sur `main`. La seule addition backend est le module push, isolé dans la branche `mobile-push-on-main` (créée depuis `origin/main`) :

- table `user_push_tokens`, routes `auth/user/push-tokens`, purge quotidienne des tokens inactifs ;
- envoi FCM branché sur les événements existants : demande, acceptation, refus et annulation d'emprunt, commentaire, demande, acceptation et refus de prolongation, création d'incident ;
- aucun changement des règles métier ni des parcours web. Les emails existants restent envoyés.

## Correspondance des parcours

| Parcours mobile | Route `main` utilisée | Remarques |
|---|---|---|
| Prépaiement | `GET /loans/{id}/estimate?platform_tip=`, puis `PUT /auth/user/balance` si le solde est insuffisant, puis `PUT /loans/{id}/prepay` | Même logique que la boîte de paiement web. Montants calculés par le serveur. Frais Stripe ajoutés par le serveur. |
| Paiement final | Idem avec `PUT /loans/{id}/pay` | Remplace `/settle`. |
| Kilométrage et dépenses | `PUT /loans/{id}/factors` avec photos via `POST /images` | Remplace les états des lieux enrichis. Champs affichés selon `requires_detailed_mileage` et `can_add_expenses`, comme le web. |
| Fin anticipée | `PUT /loans/{id}/return` | |
| Validation | `PUT /loans/{id}/validate` | Proposée quand le kilométrage détaillé est complet. |
| Flotte | `GET /loanables?for=profile`, détail `GET /loanables/{id}` | `published` est déduit de `availability_status` dans la liste. |
| Détail d'un incident | `GET /incidents?id=` | Il n'y a pas de `GET /incidents/{id}` sur `main`. |

## Retiré du périmètre mobile

- PaymentSheet Stripe, caution de 250 $, `payment-intent`, `settle` et le package `flutter_stripe`. L'ajout d'une carte reste sur le web.
- États des lieux avec album, signature et scellement, ainsi que leurs brouillons.
- Suspension et réactivation de véhicule, compteurs de prêts dans la flotte.
- Photos jointes aux incidents. Le web n'en propose pas non plus.
- Feature flags `post_mvp_*`.

## Corrections de revue reprises dans cette version

- R01 : la déconnexion réinitialise aussi les communautés, les filtres et la recherche de véhicules, le détail des prêts et le détail de la flotte.
- R02 : une coupure réseau ou une erreur 5xx pendant le renouvellement du token ne déconnecte plus l'utilisateur. Seul un refus du serveur (4xx) purge la session.
- R17 : un build release sans keystore échoue. La signature debug exige `ALLOW_DEBUG_SIGNING=true`, ce qui est réservé aux builds de vérification de la CI.
- R19 : la récupération de photo après destruction de l'activité Android est conservée pour les photos de compteur et de reçu.

## Vérifications effectuées

- Mobile : `flutter analyze` sans problème, `dart format` conforme, toute la suite `flutter test` réussie.
- Backend `mobile-push-on-main` : suite PHPUnit complète sur PostgreSQL/PostGIS. 1 042 tests exécutés ; les 19 échecs sont liés à l'environnement local (Imagick absent, variable `LOCOMOTION_INACTIVITY_PERIOD_MONTHS` vide dans `.env`) et ne concernent pas le module push. Les 20 tests push passent.
- Contrats : un test temporaire a exercé contre ce backend les requêtes exactes du mobile (filtre `id` des incidents, `for=profile`, estimation avec contribution, `factors`, `prepay`, `return`).

## Reste à faire avant pilote

- Recette sur appareils Android et iOS réels : FCM/APNs, caméra avec recréation d'activité, approvisionnement du solde avec une carte réelle en Stripe test.
- Confirmer les URL `staging` et `prod` codées dans `lib/core/config/env.dart`.
- Avant de supprimer les branches backend des lots 8 à 16, vérifier qu'aucune migration n'est appliquée et qu'aucune opération Stripe n'est en cours sur un environnement partagé.
