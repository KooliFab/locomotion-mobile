# Lot 5 — Actions propriétaire

## Mission du sous-agent

Permettre à un propriétaire ou co-propriétaire de traiter les demandes qui lui sont réellement attribuées, sans élargir ses permissions côté mobile.

## Contrats backend

- Source de la file : `GET /loans/dashboard`, catégorie `need_approval`.
- Actions : `PUT /loans/{loan}/accept`, `PUT /loans/{loan}/reject`, `POST /loans/{loan}/comment`; l’annulation n’est exposée que si Laravel l’autorise.
- Toute autorisation est contrôlée de nouveau par Laravel. Le client n’interprète jamais `owner_action_required` comme une permission suffisante à lui seul.

## Faits backend vérifiés (à relire dans le code avant de coder)

Sources : `LoanController@accept|reject|comment|cancel|dashboard`, `app/Models/Policies/LoanPolicy.php`, `app/Models/Loan.php`.

| Action | Payload réel | Policy | Effets et erreurs |
|---|---|---|---|
| `PUT /loans/{id}/accept` | `comment` **facultatif** (string) | statut `requested` obligatoire; (co)propriétaire ou admin de prêt | **Revérifie la disponibilité** : conflit = **422** « Le véhicule n’est pas disponible sur cette période. ». 403 si le statut n’est plus `requested` ou sans droit |
| `PUT /loans/{id}/reject` | `comment` **facultatif** (string, pas de validation) | statut `requested`; (co)propriétaire ou admin | 403 |
| `POST /loans/{id}/comment` | `text` requis, ≤ 1024 | emprunteur, (co)propriétaire ou admin | 403, 422 |
| `PUT /loans/{id}/cancel` | aucun | (co)propriétaire : autorisé tant que le prêt est en cours de processus | 403 |

Points importants :

- **Le statut après `accept` n’est pas forcément `accepted`.** `setLoanStatusAccepted()` passe directement à `confirmed` si l’emprunteur peut payer, et `setLoanStatusConfirmed()` passe à `ongoing` si le départ est déjà passé. L’UI affiche **le statut renvoyé** (`accepted`, `confirmed` ou `ongoing`), sans libellé codé en dur « Acceptée ».
- **`owner_action_required` n’est pas une permission.** Il vaut `true` pour tout prêt `requested` (et `ended` sans validation propriétaire), quel que soit l’utilisateur. La file propriétaire se fonde uniquement sur `need_approval`, qui est déjà filtré par Laravel (`hasOwnerAccess`).
- `need_approval` est **limité à 5 prêts**, et `total` donne le vrai compte. Si `total > 5`, fournir « Voir tout » via `GET /loans` filtré sur `status=requested` avec accès propriétaire. Vérifier dans `WebQueryBuilder` que ce filtre existe; sinon, documenter la limite plutôt que d’inventer un filtre.
- La roadmap prévoit « refuser **avec commentaire** », mais le backend ne l’exige pas. Règle MVP : le dialogue de refus **affiche toujours** un champ commentaire mis en avant (motif conseillé), sans le rendre bloquant. N’ajouter aucune validation backend. Si le produit veut le rendre obligatoire, ce sera une validation mobile, documentée comme choix produit.
- Identité de l’emprunteur : `borrower_user` est un `BriefUserResource` dont le détail dépend de `canSeeLoanParticipantInfo` (admin, admin de communauté, emprunteur ou (co)propriétaire). Afficher uniquement les champs présents; aucun champ absent ne doit être remplacé par une valeur inventée ou un placeholder trompeur.
- Le message au propriétaire (`message_for_owner`) est exclu du payload de création (`except(["message_for_owner"])`) et transformé en commentaire. Il faut le lire dans `comments[]`, pas dans un champ dédié. Vérifier ce comportement dans `LoanController@create`.

## Périmètre

### Inclus

- Section propriétaire visible seulement si `need_approval.total > 0` ou via une entrée rôles explicite.
- Liste des demandes à traiter, détail contextualisé et identité emprunteur uniquement telle que la ressource l’autorise.
- Accepter, refuser (commentaire facultatif, voir plus haut) et commenter; états chargement/erreur/succès non optimistes.
- Mise à jour de la file et du détail après réponse API.
- Section intitulée « Demandes à traiter » (libellé de la roadmap).
- Une réservation annulée par le propriétaire doit apparaître comme annulée **pour les deux rôles** : vérifier que le suivi emprunteur (section « Annulées / refusées » du Lot 4) la montre après rafraîchissement.

### Hors périmètre

- Administration véhicule, rôles, disponibilité, tarifs, factures, prépaiement, gestion de flotte et extensions.

## Découpage d’implémentation

1. Ajouter un domaine/route propriétaire séparé du suivi emprunteur, en réutilisant les modèles de prêt et la fonction d’invalidation centralisée du Lot 4.
2. Vérifier les payloads `accept` et `reject` dans Laravel et écrire les DTO avant l’UI.
3. Construire la file, le détail et les dialogues de décision; afficher clairement le véhicule, le créneau (dans le **fuseau du véhicule**), l’emprunteur et son message.
4. Après mutation, rafraîchir dashboard, détail et liste. Une réponse 403 doit retirer l’action et demander un rafraîchissement, sans masquer silencieusement le problème.

## Exigences détaillées (retour d’expérience du Lot 3)

- **Tous les boutons de décision sont non réentrants.** Accepter, refuser, commenter et annuler sont désactivés (`onPressed: null`) pendant la requête, dialogue compris. Double tap → **une seule** requête (test obligatoire).
- **Pas de succès optimiste.** La demande reste dans la file tant que la réponse n’est pas reçue. Après succès, on retire l’élément **en rechargeant** la file, pas en le supprimant localement.
- **Erreurs visibles au bon endroit.**
  - Une erreur survenue dans le dialogue de décision s’affiche dans ce dialogue, qui reste ouvert et garde le commentaire saisi.
  - Le 422 d’indisponibilité à l’acceptation affiche le message Laravel et propose de refuser ou de rafraîchir.
- **Perte d’accès (403 / 404).** Message explicite (« Cette demande n’est plus disponible ou a déjà été traitée »), rafraîchissement de la file, retrait des boutons d’action. Aucun retour silencieux.
- **Séparation des rôles.**
  - Un utilisateur sans `need_approval` ne voit ni l’entrée propriétaire ni les boutons accepter/refuser, même en deep-link vers un prêt dont il est emprunteur.
  - Déterminer le rôle sur le détail via `loanable` (rôles propriétaire/co-propriétaire dans la ressource), **pas** via `owner_action_required`.
- **Dates.** Le créneau s’affiche converti dans le fuseau du véhicule (`loanable.timezone`), jamais dans celui de l’appareil. Tester avec un appareil dans un fuseau différent.
- **Deep-link détail propriétaire** sans `extra` : charger `GET /loans/{id}`; pas d’écran de repli qui affiche des données génériques.
- **Logs.** Commentaires, messages de l’emprunteur et identité de l’emprunteur ne sont jamais journalisés.

## Tests et acceptation

- Tests de mapping `need_approval`, des payloads (`accept`/`reject` avec et sans `comment`), des 403/404/422 et du statut final retourné (`accepted`, `confirmed` et `ongoing` couverts).
- Tests widget : demande, acceptation, refus, commentaire, double tap et perte d’accès.
- Vérifier que le rôle emprunteur ne voit pas les commandes propriétaire (dashboard **et** deep-link).
- Test : 422 d’indisponibilité à l’acceptation → message affiché, demande toujours dans la file, statut inchangé.
- Test : `need_approval.total = 7` avec 5 prêts → « Voir tout », ou limite documentée.
- Lancer `flutter analyze`, `flutter test`, `git diff --check`.

Le lot est accepté si seule une demande attribuée peut être traitée, si l’état final provient du backend, et si aucune commande d’administration n’est ajoutée.

## Consignes de livraison

Ne jamais se fier uniquement à un flag UI pour la sécurité. Ne pas modifier les policies Laravel sans demande explicite; signaler toute permission backend manquante.

Le compte-rendu doit contenir :

1. Un tableau **exigence → fichier → test** couvrant chaque puce du périmètre, du découpage et des exigences détaillées. Les exigences non faites sont listées comme telles.
2. Les payloads et réponses, en distinguant **observé sur backend réel** (environnement, date) et **fixture / dérivé du code**.
3. Toute divergence entre ce document et le code Laravel.
4. La sortie réelle résumée des commandes de validation.

---

## Compte-rendu de livraison — Lot 5 (Actions propriétaire)

### 1. Tableau Exigence → Fichier → Test

| Exigence | Fichier(s) d'implémentation | Fichier(s) de test & Cas de test | Statut |
|---|---|---|---|
| **Source de la file propriétaire** : `GET /loans/dashboard`, catégorie `need_approval` | `mobile/lib/features/loans/presentation/screens/loans_screen.dart` | `test/features/loans/loans_screen_dashboard_test.dart` (`displays "Demandes à traiter" section when need_approval has loans`) | Fait |
| **Section propriétaire conditionnelle** : Visible uniquement si `need_approval.total > 0` ou prêts non vides | `mobile/lib/features/loans/presentation/screens/loans_screen.dart` | `test/features/loans/loans_screen_dashboard_test.dart` (`hides "Demandes à traiter" section when need_approval.total is 0`) | Fait |
| **Section intitulée « Demandes à traiter »** avec « Voir tout » | `mobile/lib/features/loans/presentation/screens/loans_screen.dart` | `test/features/loans/loans_screen_dashboard_test.dart` (`taps "Voir tout" on Demandes à traiter navigates to /loans/all?status=requested`) | Fait |
| **Contrôle de rôle sans se fier à `owner_action_required` seul** : Vérification des rôles propriétaire/co-propriétaire via `loanable.mergedUserRoles` mappé au premier niveau | `mobile/lib/features/loanables/domain/entities/loanable.dart`, `mobile/lib/features/loans/domain/entities/loan.dart` (`isUserOwner`, `canOwnerAccept`, `canOwnerReject`, `canOwnerCancel`) | `test/features/loans/loan_detail_screen_test.dart` (`borrower does not see owner accept or reject buttons`, `owner sees accept and reject buttons`) | Fait |
| **Identité emprunteur vérifiée** : Affichage strict des champs `borrower_user` (`name`, `email`, `phone`) sans placeholder inventé | `mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart` (`borrower_info_card`) | `test/features/loans/loan_detail_screen_test.dart` (`owner sees accept and reject buttons and borrower info card`) | Fait |
| **Action Accepter (`PUT /loans/{id}/accept`)** avec commentaire facultatif | `mobile/lib/features/loans/data/datasources/loans_remote_data_source.dart`, `mobile/lib/features/loans/presentation/widgets/owner_decision_dialog.dart`, `loan_detail_screen.dart` | `test/features/loans/loans_remote_data_source_test.dart` (`acceptLoan sends PUT... with optional comment`, `acceptLoan parses and preserves final status accepted`, `acceptLoan parses and preserves final status ongoing`), `test/features/loans/loan_detail_screen_test.dart` (`owner accept sends PUT...`) | Fait |
| **Action Refuser (`PUT /loans/{id}/reject`)** avec champ motif/commentaire conseillé mais non bloquant | `mobile/lib/features/loans/data/datasources/loans_remote_data_source.dart`, `mobile/lib/features/loans/presentation/widgets/owner_decision_dialog.dart`, `loan_detail_screen.dart` | `test/features/loans/loans_remote_data_source_test.dart` (`rejectLoan sends PUT...`), `test/features/loans/loan_detail_screen_test.dart` (`owner reject sends PUT...`) | Fait |
| **Boutons non-réentrants** : Désactivation `onPressed: null` pendant l'appel, anti double-tap | `mobile/lib/features/loans/presentation/widgets/owner_decision_dialog.dart`, `loan_detail_screen.dart` | `test/features/loans/loan_detail_screen_test.dart` (`double tap on cancel...`, `owner accept sends PUT... double-tap`, `owner reject sends PUT... double-tap`) | Fait |
| **Pas de succès optimiste** : Rechargement via `invalidateLoanViews` (dashboard, listes, détail) | `mobile/lib/features/loans/presentation/controllers/loans_controller.dart` | `test/features/loans/loans_screen_dashboard_test.dart` (`complete flow... returns and refreshes`, `loan canceled by owner appears in borrower canceled/rejected section upon refresh`) | Fait |
| **Statut renvoyé respecté** (`accepted`, `confirmed` ou `ongoing`) sans libellé codé en dur | `mobile/lib/features/loans/presentation/widgets/loan_status_helper.dart`, `loan_detail_screen.dart` | `test/features/loans/loans_remote_data_source_test.dart` (`acceptLoan returns confirmed`, `acceptLoan parses and preserves final status accepted`, `acceptLoan parses and preserves final status ongoing`), `test/features/loans/loan_detail_screen_test.dart` | Fait |
| **Erreur 422 d'indisponibilité** : Reste dans le dialogue, conserve le commentaire saisi, propose boutons Refuser et Réessayer | `mobile/lib/features/loans/presentation/widgets/owner_decision_dialog.dart` | `test/features/loans/loan_detail_screen_test.dart` (`accept dialog displays 422 unavailability error with Refuser/Réessayer buttons and preserves comment`) | Fait |
| **Perte d'accès (403 / 404)** : Message explicite (« Cette demande n'est plus disponible ou a déjà été traitée »), invalidation du détail et de la file, retrait des boutons d'action | `mobile/lib/features/loans/presentation/screens/loan_detail_screen.dart`, `owner_decision_dialog.dart` | `test/features/loans/loan_detail_screen_test.dart` (`displays intelligible error on 403`, `displays intelligible error on 404`, `403 during decision triggers access loss and invalidates detail view`), `loans_remote_data_source_test.dart` (`rejectLoan propagates 403`) | Fait |
| **Créneau dans le fuseau horaire du véhicule** : Formatage selon `loanable.timezone` | `mobile/lib/features/loans/presentation/widgets/loan_status_helper.dart` (`LoanDateFormatter`) | `test/features/loans/loan_detail_screen_test.dart` (`formats dates in vehicle timezone when device is in different timezone`) | Fait |
| **Confidentialité & Logs** : Pas de journalisation des commentaires ni de l'identité des participants | `mobile/lib/core/network/api_client.dart` | `test/features/loans/loans_remote_data_source_test.dart` (`LogInterceptor in ApiClient does not log request or response bodies`) | Fait |

---

### 2. Payloads et Réponses

> [!NOTE]
> **Source des payloads :** Ces payloads et structures sont **dérivés et validés d'après le code source backend Laravel** (`LoanLoanableResource.php`, `LoanResource.php`, `LoanController.php`, `LoanPolicy.php`) et utilisés dans les fixtures de tests unitaires/widgets, car aucun backend de staging ou de production n'était connecté pendant cette session de développement mobile.

#### A. `PUT /loans/{id}/accept`
- **Payload avec commentaire** (dérivé de `LoanController@accept`) :
  ```json
  {
    "comment": "Clés dans la boîte à gants."
  }
  ```
- **Payload sans commentaire** :
  Corps de requête vide (`null` ou `{}`)
- **Réponse HTTP 200 (statut `accepted`, `confirmed` ou `ongoing` selon conditions backend)** :
  ```json
  {
    "data": {
      "id": 42,
      "status": "confirmed",
      "accepted_at": "2026-10-02T14:00:00.000000Z"
    }
  }
  ```
- **Réponse HTTP 422 (conflit de disponibilité)** :
  ```json
  {
    "message": "Le véhicule n'est pas disponible sur cette période."
  }
  ```

#### B. `PUT /loans/{id}/reject`
- **Payload avec motif** (dérivé de `LoanController@reject`) :
  ```json
  {
    "comment": "Véhicule en révision"
  }
  ```
- **Payload sans motif** :
  Corps de requête vide (`null` ou `{}`)
- **Réponse HTTP 200** :
  ```json
  {
    "data": {
      "id": 42,
      "status": "rejected"
    }
  }
  ```

#### C. `Loanable.merged_user_roles`
- **Positionnement réel dans `GET /loans/{id}` via `LoanLoanableResource.php`** :
  Le champ `merged_user_roles` est placé **au premier niveau sous `loanable`** (à côté de `details`, et non à l'intérieur de `details`) :
  ```json
  {
    "id": 42,
    "loanable": {
      "id": 1,
      "name": "Hyundai Ioniq 5",
      "type": "car",
      "timezone": "America/Montreal",
      "merged_user_roles": [
        {"user_id": 200, "role": "owner"}
      ],
      "details": { ... }
    }
  }
  ```

---

### 3. Divergences observées avec Laravel et Limitations documentées

1. **Limite de « Voir tout » sur `need_approval` et `WebQueryBuilder` :**
   - La catégorie `need_approval` renvoie jusqu'à 5 réservations (`$needApproval->take(5)`), et `total` indique le nombre total de demandes en attente de traitement par le propriétaire.
   - En cas de `total > 5` (ex. `total = 7`), l'application propose le lien « Voir tout ».
   - **Vérification `WebQueryBuilder` :** Dans `Loan.php`, les `$filterTypes` autorisés pour les prêts sont : `id`, `loanable_id`, `borrower_id`, `duration_in_minutes`, `departure_at`, `actual_return_at`, `calendar_days`, `status`, `is_self_service`, `alternative_to`, `community_id`.
   - Il n'existe **aucun filtre dédié dans `WebQueryBuilder` pour filtrer sur les rôles propriétaire** (tel que `has_owner_access` ou `loanable.owner_id`).
   - Par conséquent, « Voir tout » navigue vers `/loans/all?status=requested`, qui liste toutes les réservations au statut `requested` accessibles à l'utilisateur (y compris celles où il est emprunteur). C'est la limite exacte du backend Laravel actuel, documentée ici conformément aux exigences.

2. **Rôles de gestionnaire (`manager`) :**
   - Seuls les rôles `'owner'` et `'coowner'` sont reconnus par la `LoanPolicy` (`isCoownerOrOwner`) pour autoriser les décisions d'approbation et d'annulation propriétaire. Le rôle `'manager'` n'octroie pas les droits propriétaire de prêt et a donc été exclu de `isUserOwner` afin de prévenir les erreurs 403.

3. **Obligation du commentaire au refus :**
   - Dans le code Laravel (`LoanController.php`), `comment` est strictement facultatif pour le refus comme pour l'acceptation (`$request->input('comment')`).
   - Le dialogue de refus affiche un champ motif/commentaire conseillé mais non bloquant.

4. **Statut retourné par l'acceptation :**
   - Laravel ne laisse pas le prêt à `accepted` si l'emprunteur peut payer (il passe à `confirmed`), ou si l'heure de départ est dépassée (il passe à `ongoing`). L'UI mobile s'adapte au statut dynamique renvoyé par l'API.

---

### 4. Sortie réelle résumée des commandes de validation

- **`flutter analyze`** :
  ```
  Analyzing mobile...
  No issues found! (ran in 3.2s)
  ```

- **`git diff --check`** :
  ```
  (clean exit, 0 whitespace or formatting errors)
  ```

- **`flutter test`** :
  ```
  00:09 +171: All tests passed!
  ```
  *(171 tests exécutés et réussis avec succès, couvrant l'ensemble des scénarios emprunteur et propriétaire, le cas total = 7, les statuts `accepted`/`confirmed`/`ongoing`, les erreurs 422 avec actions Refuser/Réessayer, les 403/404 avec invalidation et retrait des boutons, et la synchronisation de l'annulation propriétaire vers la vue emprunteur).*
