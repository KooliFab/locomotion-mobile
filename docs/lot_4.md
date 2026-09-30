# Lot 4 — Suivi des réservations côté emprunteur

## Mission du sous-agent

Donner à l’emprunteur une vue fiable de ses demandes et réservations, avec un détail permettant les actions que Laravel autorise réellement.

## Contrats backend

- `GET /loans/dashboard` : catégories `started`, `waiting`, `need_approval`, `future`, `completed`, avec `total` et `loans`.
- `GET /loans` : collection paginée `ListLoanResource`; `GET /loans/{id}` : détail `LoanResource`.
- Actions prévues, après vérification de leurs payloads et permissions : `PUT /loans/{loan}/cancel`, `PUT /loans/{loan}/dates`, `POST /loans/{loan}/comment`.
- Les statuts incluent notamment `requested`, `accepted`, `confirmed`, `ongoing`, `ended`, `validated`, `completed`, `canceled`, `rejected`.

## Faits backend vérifiés (à relire dans le code avant de coder)

Sources : `backend/app/Http/Controllers/LoanController.php`, `backend/app/Models/Policies/LoanPolicy.php`, `backend/app/Http/Resources/Loan/*`.

### Dashboard (`LoanController@dashboard`)

| Catégorie | Contenu réel | Rôle |
|---|---|---|
| `started` | statuts `ongoing`, `ended`, `validated` | **mélangé** emprunteur + propriétaire |
| `waiting` | `requested` où `borrower_user_id == moi` | emprunteur uniquement |
| `need_approval` | `requested` où j’ai un accès propriétaire | propriétaire uniquement (Lot 5) |
| `future` | `accepted`, `confirmed` | **mélangé** |
| `completed` | `completed`, trié `updated_at desc` | **mélangé** |

- Chaque catégorie est **limitée à 5 prêts** (`limit(5)`); `total` est le vrai compte. Le dashboard n’est donc pas exhaustif : prévoir « Voir tout » vers `GET /loans`.
- `started`, `future` et `completed` contiennent aussi des prêts où l’utilisateur est propriétaire. Pour le suivi emprunteur, **filtrer côté client sur `borrower_user.id == currentUser.id`** et ne pas afficher les autres ici (ou les étiqueter explicitement « En tant que propriétaire »). C’est le critère « les catégories ne mélangent pas les rôles ».
- `canceled` et `rejected` n’apparaissent dans aucune catégorie : ils ne sont visibles que via `GET /loans`.
- Ressource : `DashboardLoanResource` (champs réduits, `community` = `{id}` seulement). Ne pas réutiliser aveuglément le mapper `LoanResource`.

### Liste (`GET /loans`)

- `WebQueryBuilder` : pagination via `page` et `per_page` (défaut 10). Vérifier dans `app/Http/WebQueryBuilder.php` la syntaxe des filtres (statut, `borrower_user_id`) et des relations (`fields`/`relations`) avant de les utiliser. Consigner la requête exacte utilisée.
- Réponse paginée Laravel (`data`, `meta`, `links`) : parser `meta.current_page`/`meta.last_page`, ne pas supposer une liste nue.

### Détail (`GET /loans/{id}`, `LoanResource`)

- Champs disponibles notamment : `status`, `departure_at`, `duration_in_minutes`, `accepted_at`, `prepaid_at`, `canceled_at`, `actual_return_at`, `owner_validated_at`, `borrower_validated_at`, `comments[]`, `borrower_user`, `loanable`, `community`, `borrower_action_required`, `owner_action_required`, `is_free`.
- **Aucun champ de permission** (`can_cancel`, `actions`…) n’est exposé. Les actions affichées sont donc **déduites** du statut et du rôle, puis Laravel tranche (403). Documenter cette règle de déduction dans le code et dans le compte-rendu.
- Il n’existe pas de `rejected_at` : la timeline ne doit afficher que les horodatages réellement présents; pour `rejected`, afficher le statut sans date inventée.

### Actions

| Action | Payload | Règle policy (résumé) | Erreurs attendues |
|---|---|---|---|
| `PUT /loans/{id}/cancel` | aucun | statut « en cours de processus » (`requested` → `validated`). Emprunteur : autorisé si prêt gratuit, pas `ongoing`, avant le départ ou incident bloquant; sinon refus `must_not_be_ongoing_with_cost` | 403 avec message |
| `PUT /loans/{id}/dates` | `departure_at` (date, heure **naïve dans le fuseau du véhicule**), `duration_in_minutes` (entier ≥ 15) | statut `requested`, `accepted` ou `confirmed`; emprunteur, (co)propriétaire ou admin | 403, 422 (dont **indisponibilité = 422** « Le véhicule n’est pas disponible sur cette période. ») |
| `POST /loans/{id}/comment` | `text` (requis, ≤ 1024) | emprunteur, (co)propriétaire ou admin | 403, 422 |

⚠️ Un conflit de disponibilité Laravel renvoie **422, pas 409** (`abort(422, …)` dans `checkLoanableAvailable`). Le mapping 409 du Lot 3 est donc à revoir, et l’UI doit afficher le message 422 général quand il n’a pas de clé de champ.

⚠️ **Divergence roadmap / backend sur la modification de dates.** La roadmap prévoit « modification des dates *avant confirmation* », alors que la policy Laravel l’autorise aussi en `confirmed`. Règle MVP retenue : proposer l’action seulement en `requested` et `accepted` (conforme à la roadmap). Signaler dans le compte-rendu si le produit veut l’étendre à `confirmed`.

⚠️ Modifier les dates d’un prêt `confirmed` le repasse en `accepted` (prépaiement réinitialisé). Afficher le statut renvoyé, ne pas conserver l’ancien.

## Sections attendues (roadmap MVP)

La roadmap impose ces 5 sections côté emprunteur. Voici leur source réelle :

| Section roadmap | Source |
|---|---|
| En attente | dashboard `waiting` |
| Acceptées / confirmées | dashboard `future`, filtré sur emprunteur |
| En cours | dashboard `started`, filtré sur emprunteur |
| Terminées | dashboard `completed`, filtré sur emprunteur |
| Annulées / refusées | **absent du dashboard** → `GET /loans` filtré sur `canceled`/`rejected` et emprunteur (vérifier le filtre dans `WebQueryBuilder`) |

La section « Annulées / refusées » est obligatoire : une réservation annulée doit rester visible pour l’emprunteur (critère du Lot 7).

## Périmètre

### Inclus

- Remplacer l’écran « Mes réservations » actuel par un dashboard emprunteur fondé sur l’API.
- Actualisation automatique au retour depuis une notification (point d’entrée prévu pour le Lot 6) et au retour au premier plan de l’app.
- Ajouter liste paginée, détail de prêt, timeline de statut, véhicule, créneaux, messages et états d’action.
- Ajouter annulation, modification de dates et commentaire uniquement si la permission et l’état retournés le permettent.
- Rafraîchir après action, pull-to-refresh et retour vers l’écran; fournir un point d’extension pour les push du Lot 6.

### Hors périmètre

- Accepter/refuser pour un propriétaire, extension, retour de véhicule, kilométrage, validation de fin, facture et paiement.

## Découpage d’implémentation

1. Compléter les mappers sans valeurs inventées et ajouter la route détail `loans/:id`. Un statut inconnu devient une valeur `unknown` affichée neutre, jamais un crash ni un statut par défaut.
2. Construire le dashboard et les filtres de statut; ne pas afficher `need_approval` comme une demande emprunteur; appliquer le filtre de rôle décrit plus haut.
3. Construire le détail avec une timeline dérivée des champs retournés, sans horodatage supposé.
4. Ajouter les actions une par une après lecture de leurs règles Laravel; confirmation destructive pour l’annulation.
5. Centraliser l’invalidation dashboard/liste/détail après mutation dans **une seule fonction** (ex. `invalidateLoanViews(ref, loanId)`), réutilisée par le Lot 5 et le Lot 6.

## Exigences détaillées (retour d’expérience du Lot 3)

Ces points ont été oubliés au Lot 3; ils sont obligatoires ici.

- **Dates et fuseaux.**
  - `departure_at` renvoyé par Laravel est un instant sérialisé (ISO 8601, UTC). L’afficher **converti dans le fuseau du véhicule** (`loanable.timezone`), pas celui de l’appareil.
  - Pour `PUT /dates`, envoyer une chaîne naïve `Y-m-d H:i:s` dans le fuseau du véhicule.
  - Ne jamais comparer un `DateTime` UTC avec un `DateTime` local naïf : normaliser les deux côtés dans un même repère.
  - Test obligatoire avec un appareil en fuseau différent du véhicule.
- **Vérification finale avant mutation.** Pour la modification de dates, relancer une vérification de disponibilité juste avant le `PUT` (aide UX), puis accepter la décision de Laravel.
- **Erreurs 422 visibles.**
  - Les erreurs de champ doivent être affichées **sur l’écran où l’utilisateur se trouve au moment de l’erreur** (dialogue ou formulaire).
  - Une erreur sans clé connue s’affiche en message général.
  - Modifier un champ n’efface que l’erreur de ce champ.
- **Non-réentrance de tous les boutons asynchrones.** Chaque bouton est désactivé (`onPressed: null`) pendant sa requête : annuler, modifier, envoyer un commentaire, pull-to-refresh, « charger plus ». `isLoading` seul ne suffit pas si le bouton reste cliquable.
- **Pas d’écran de repli qui invente des données.** Un deep-link `loans/:id` sans `extra` doit **charger** `GET /loans/{id}` (chargement / erreur / 404 / 403), pas afficher un texte générique.
- **Parsing défensif.** Aucun cast forcé (`as Map<String, dynamic>`) sans vérification : lever une `FormatException` explicite.
- **Données privées.** Les commentaires et messages au propriétaire ne doivent pas apparaître dans les logs (vérifier l’intercepteur Dio / `LogInterceptor` pour les corps de requête et de réponse).
- **Après échec, aucun changement local.** La timeline, le statut et la liste restent ceux du dernier `GET` réussi.

## Tests et acceptation

- Fixtures pour chaque catégorie et statut, liste paginée, détail et erreurs de format. Les fixtures sont **copiées de réponses réelles** (ou du code des Resources Laravel) et le compte-rendu indique leur provenance.
- Tests des permissions et états UI : action absente si non autorisée, erreur 403/422 intelligible, pas de succès optimiste.
- Tests widget dashboard → détail → action → rafraîchissement.
- Tests obligatoires supplémentaires :
  - prêt propriétaire présent dans `future` → absent du suivi emprunteur (ou étiqueté);
  - `total` > 5 → « Voir tout » visible et pagination fonctionnelle (page 2, fin de liste);
  - annulation : confirmation, double tap → un seul `PUT`, 403 → message et statut inchangé;
  - modification de dates : payload naïf exact dans le fuseau du véhicule, 422 d’indisponibilité affiché;
  - commentaire : `text` vide bloqué localement, > 1024 bloqué, 422 affiché, message non journalisé;
  - deep-link détail sans `extra` → chargement réel, 404 et 403 contrôlés.
- `flutter analyze`, `flutter test`, `git diff --check` passent.

Le lot est accepté si les catégories ne mélangent pas les rôles, si les données obsolètes sont remplacées après mutation et si une action échouée ne modifie jamais la timeline locale.

## Consignes de livraison

Ne pas implémenter les actions propriétaire. Vérifier chaque payload d’action dans le contrôleur Laravel avant de coder et consigner les divergences.

Le compte-rendu doit contenir :

1. Un tableau **exigence → fichier → test** couvrant chaque puce de « Périmètre inclus », « Découpage » et « Exigences détaillées ». Toute exigence non couverte est listée explicitement comme **non faite** avec la raison.
2. Les payloads et réponses, en distinguant clairement **« observé sur backend réel »** (avec environnement et date) de **« dérivé du code / fixture »**. Ne jamais présenter une fixture comme une réponse observée.
3. Les commandes exécutées avec leur sortie résumée réelle (nombre de tests, issues).

---

## Compte-rendu de livraison (Lot 4 - Révisé suite à la revue)

### 1. Tableau de correspondance Exigence → Fichier → Test

| Exigence Lot 4 | Fichiers implémentés / modifiés | Tests de validation associés | Statut |
| :--- | :--- | :--- | :--- |
| **Tableau de bord emprunteur (5 sections claires)** | [`loans_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loans_screen.dart) | [`loans_screen_dashboard_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_screen_dashboard_test.dart) : `renders all 5 borrower sections and excludes owner loans from borrower view` | Fait |
| **Filtrage strict des rôles (exclure prêts propriétaire de la vue emprunteur et compteurs justes)** | [`loans_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loans_screen.dart) | [`loans_screen_dashboard_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_screen_dashboard_test.dart) : `renders all 5 borrower sections and excludes owner loans from borrower view` | Fait |
| **Bouton « Voir tout », route `/loans/all` et pagination fonctionnelle (page 1, page 2, fin de liste)** | [`app_router.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/core/router/app_router.dart), [`loans_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loans_screen.dart), [`loans_list_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loans_list_screen.dart) | [`loans_screen_dashboard_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_screen_dashboard_test.dart) : `shows Voir tout when total > 5`, [`loans_list_screen_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_list_screen_test.dart) : `LoansListScreen displays page 1, loads page 2, and hides button at end` | Fait |
| **Filtre emprunteur via `borrower_user.id` sur `GET /loans`** | [`loans_remote_data_source.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/data/datasources/loans_remote_data_source.dart) | [`loans_remote_data_source_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_remote_data_source_test.dart) : `getLoansPage sends page, per_page, status and borrower_id correctly` | Fait |
| **Écran de détail `/loans/:id` sans `extra` (deep-link réel)** | [`loan_detail_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart), [`app_router.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/core/router/app_router.dart) | [`loan_detail_screen_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loan_detail_screen_test.dart) : `renders detail from GET /loans/{id} without extra` | Fait |
| **Gestion des erreurs 404 / 403 sur le détail de prêt** | [`loan_detail_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart) | [`loan_detail_screen_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loan_detail_screen_test.dart) : `displays intelligible error on 404`, `displays intelligible error on 403` | Fait |
| **Affichage dans le fuseau du véhicule (ex. appareil UTC vs véhicule America/Montreal EDT)** | [`loan_status_helper.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/widgets/loan_status_helper.dart), [`update_dates_dialog.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/widgets/update_dates_dialog.dart) | [`loan_detail_screen_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loan_detail_screen_test.dart) : `formats dates in vehicle timezone when device is in different timezone` | Fait |
| **Timeline d’historique basée strictement sur les champs réels** | [`loan_timeline_widget.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/widgets/loan_timeline_widget.dart), [`loan.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/domain/entities/loan.dart) | [`loan_detail_screen_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loan_detail_screen_test.dart) : `renders detail from GET /loans/{id} without extra` | Fait |
| **Annulation côté emprunteur (`PUT /loans/{id}/cancel`) & non-réentrance double tap** | [`loans_remote_data_source.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/data/datasources/loans_remote_data_source.dart), [`loan_detail_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart), [`loans_controller.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/controllers/loans_controller.dart) (`@Riverpod(keepAlive: true)`) | [`loans_remote_data_source_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_remote_data_source_test.dart) : `cancelLoan sends PUT /loans/{id}/cancel and returns updated Loan`, [`loan_detail_screen_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loan_detail_screen_test.dart) : `cancels loan with confirmation dialog and disables button during call`, `double tap on cancel button sends only a single PUT request` | Fait |
| **Modification des dates avant confirmation (`PUT /loans/{id}/dates`) et affichage erreur 422** | [`update_dates_dialog.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/widgets/update_dates_dialog.dart), [`loans_remote_data_source.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/data/datasources/loans_remote_data_source.dart) | [`loans_remote_data_source_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_remote_data_source_test.dart) : `updateLoanDates sends PUT /loans/{id}/dates with naive vehicle timezone payload`, [`loan_detail_screen_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loan_detail_screen_test.dart) : `opens UpdateDatesDialog and updates dates`, `displays inline 422 error on date conflict without altering state` | Fait |
| **Ajout de commentaires (`POST /loans/{id}/comment`), préservation du texte si échec, max 1024** | [`loan_comments_section.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/widgets/loan_comments_section.dart), [`loans_remote_data_source.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/data/datasources/loans_remote_data_source.dart) | [`loans_remote_data_source_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_remote_data_source_test.dart) : `addComment sends POST /loans/{id}/comment and parses LoanComment`, [`loan_detail_screen_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loan_detail_screen_test.dart) : `handles comment input validation and preserves text upon server error` | Fait |
| **Actualisation automatique au retour au premier plan (`resumed`) et manuelle** | [`loans_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loans_screen.dart) | [`loans_screen_dashboard_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_screen_dashboard_test.dart) : `refreshes dashboard when app lifecycle changes to resumed` | Fait |
| **Enchaînement complet dashboard → détail → action (annulation) → retour et rafraîchissement** | [`loans_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loans_screen.dart), [`loan_detail_screen.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart) | [`loans_screen_dashboard_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_screen_dashboard_test.dart) : `complete flow: dashboard -> detail -> cancel -> returns and refreshes` | Fait |
| **Protection de la confidentialité des messages/commentaires dans les logs** | [`api_client.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/core/network/api_client.dart) (`responseBody: false`, `requestBody: false`) | [`loans_remote_data_source_test.dart`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/test/features/loans/loans_remote_data_source_test.dart) : `LogInterceptor in ApiClient does not log request or response bodies (privacy check)` | Fait |
| **Actions propriétaire (approbation, rejet, restitution)** | Non implémentées | *Exclu du Lot 4 conformément aux consignes (réservé au Lot 5)* | Exclu |

---

### 2. Payloads et réponses (Divergences et sources réelles)

#### A. Source et dérivation des structures :
- **`GET /loans/dashboard`** : Dérivé de `backend/app/Http/Controllers/LoanController.php::dashboard()` et `DashboardLoanResource.php`. Structure renvoyant `{started, waiting, need_approval, future, completed}` avec `total` et liste `loans`.
- **`GET /loans`** : Dérivé de `LoanController.php::index()` et `WebQueryBuilder.php`. Le filtrage par emprunteur utilise la relation `borrower_user.id` (la colonne directe `borrower_id` sur la table `loans` ayant été supprimée par la migration `2024_06_25_141602_remove_borrower_id_from_loans`).
- **`GET /loans/{id}`** : Dérivé de `LoanController.php::show()` et `LoanResource.php`. Retourne un objet enveloppé dans `{"data": {...}}` avec dates ISO 8601 UTC terminant par `Z` (`Y-m-d\TH:i:s.u\Z`).
- **`PUT /loans/{id}/cancel`** : Dérivé de `LoanController.php::cancel()`. Ne prend aucun corps obligatoire. Retourne le prêt mis à jour (`status: "canceled"`).
- **`PUT /loans/{id}/dates`** : Dérivé de `LoanController.php::updateDates()`. Validation interne au contrôleur : `['departure_at' => ['date'], 'duration_in_minutes' => ['integer', 'min:15']]`. L'indisponibilité est signalée par `checkLoanableAvailable` via un code HTTP 422 (`abort(422, "Le véhicule n'est pas disponible sur cette période.")`).
- **`POST /loans/{id}/comment`** : Dérivé de `LoanController.php::storeComment()`. Validation interne : `['text' => ['required', 'string', 'max:1024']]`. Renvoie `LoanCommentResource`.

#### B. Corrections apportées suite à la review :
1. **Fuseau horaire du véhicule** : `LoanDateFormatter.toVehicleDateTime(dt, timezone)` et `formatInVehicleZone` convertissent désormais explicitement les dates ISO 8601 UTC vers le fuseau IANA du véhicule (`loanable.timezone`, ex. `America/Montreal`). `UpdateDatesDialog` initialise la sélection à partir de l'heure locale calculée du véhicule et transmet une heure naïve dans ce fuseau pour éviter tout décalage lors de la sauvegarde.
2. **Ordre des routes dans `app_router.dart`** : La route `AppRoutes.loansList` (`/loans/all`) est positionnée avant `AppRoutes.loanDetail` (`/loans/:id`) pour empêcher l'interception incorrecte de l'URL `/loans/all`.
3. **Filtre `borrower_user.id`** : Dans `loans_remote_data_source.dart`, la requête utilise `borrower_user.id` au lieu de `borrower_id`.
4. **Persistance de `LoanActionsController`** : Annoté avec `@Riverpod(keepAlive: true)` pour éliminer le risque d'auto-dispose durant les opérations réseau asynchrones.
5. **Robustesse du sélecteur de dates** : Les bornes `firstDate` et `lastDate` dans `UpdateDatesDialog` s'adaptent dynamiquement à la date actuelle du prêt pour éviter toute assertion Flutter.
6. **Préservation du commentaire en cas d'erreur** : `_NewCommentInput` n'efface son contrôleur textuel qu'en cas de succès réseau et affiche l'erreur en ligne sans perte de saisie pour l'utilisateur.
7. **Rafraîchissement de la liste paginée** : `LoansListScreen` attend désormais le retour de `context.push` pour actualiser la première page.

---

### 3. Commandes exécutées et résultats réels

| Commande | Résultat | Remarques |
| :--- | :--- | :--- |
| `dart run build_runner build --delete-conflicting-outputs` | **Succès** (0 conflit) | Régénération du code Riverpod (`keepAlive: true`). |
| `flutter analyze` | **0 issues found** (en 3.9s) | Analyse statique propre à 100%. |
| `flutter test` | **155 passés, 0 échec** | Tous les tests unitaires et widgets passent avec succès sur l'ensemble de l'application mobile. |
| `git diff --check` | **0 erreur** | Aucun problème d'espaces ou de conflits. |

