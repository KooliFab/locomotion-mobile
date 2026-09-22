# Lot 1 — Authentification et éligibilité emprunteur

## Mission du sous-agent

Rendre le compte mobile fiable et permettre à un membre de connaître, compléter et soumettre son dossier emprunteur. Ce lot prépare l’autorisation de réserver un véhicule nécessitant un emprunteur validé, sans construire encore le parcours de réservation.

Le backend Laravel existant est la source de vérité. Ne pas modifier son schéma ou créer de nouveaux endpoints dans ce lot sans accord explicite.

## Résultat attendu

Un utilisateur peut :

1. se connecter, rester connecté après relance de l’application et se déconnecter ;
2. consulter l’état réel de son dossier emprunteur dans le profil ;
3. ouvrir le formulaire, téléverser les pièces demandées et soumettre son dossier ;
4. comprendre clairement s’il peut réserver un véhicule nécessitant une validation, sans recevoir de faux positif local.

## Périmètre

### Inclus

- Vérifier et finaliser les contrats mobile utilisés pour login, inscription, utilisateur courant, rafraîchissement de session et déconnexion.
- Ajouter un modèle `Borrower` basé sur la réponse Laravel `BorrowerResource` : `approved`, `suspended`, `validated`, `submitted_at`, `approved_at`, `suspended_at`, `user_id`, et, lorsque le propriétaire du dossier y est autorisé, `drivers_license_number`, `has_not_been_sued_last_ten_years`, `gaa`, `saaq`.
- Enrichir le modèle utilisateur avec le dossier `borrower` renvoyé par la ressource utilisateur complète. Ne pas déduire son état d’un unique booléen tel que `isBorrowerApproved`.
- Créer l’écran « Dossier conducteur & permis », accessible depuis le profil : état, explication, bouton d’action et formulaire.
- Implémenter le téléversement de fichiers vers `POST /files` en multipart. Le champ texte `field` et la partie de fichier doivent porter le même nom (`gaa` ou `saaq`), conformément à `FileController`.
- Implémenter la soumission via `PUT /users/{userId}/borrower/submit` avec le payload ci-dessous.
- Remplacer les entrées fictives du profil par des actions fonctionnelles ou les masquer si elles sont hors périmètre.
- Ajouter les tests unitaires, data source et widget nécessaires.

### Hors périmètre

- Fiche véhicule, calendrier de disponibilité et création d’une demande : Lot 2 / Lot 3.
- Acceptation/refus d’une demande par un propriétaire : Lot 5.
- Paiements, factures, crédits et Stripe.
- Approbation, suspension ou réinitialisation d’un dossier : ces actions restent administratives côté backend.
- Notifications push.

## Contrats backend à respecter

### État du dossier

Utiliser les champs `borrower` de la réponse utilisateur détaillée et le résultat de soumission `BorrowerResource`.

| État affiché | Condition | Action proposée |
| --- | --- | --- |
| À compléter | `borrower` absent ou `submitted_at == null` | Ouvrir le formulaire |
| En cours de validation | `submitted_at != null`, `approved == false`, `suspended == false` | Consulter les informations envoyées |
| Validé | `validated == true` | Afficher la confirmation |
| Suspendu | `suspended == true` | Afficher un message de blocage et l’orientation vers le support |

En cas de combinaison inattendue, afficher un état « Vérification requise » et conserver la réponse dans les logs de diagnostic ; ne pas autoriser une réservation de voiture par défaut.

### Téléversement

`POST /files` reçoit un `multipart/form-data` :

- `field`: `gaa` ou `saaq` ;
- un fichier dont la clé multipart est la même valeur ;
- authentification Bearer existante.

La réponse est une ressource fichier contenant au minimum :

```json
{ "id": 123, "original_filename": "document.pdf", "field": "gaa" }
```

Conserver uniquement les métadonnées nécessaires à l’affichage et l’identifiant pour la soumission. Ne jamais écrire le numéro de permis ou les fichiers dans les logs, les exceptions affichées, les préférences non chiffrées ou les fixtures versionnées.

### Soumission

`PUT /users/{userId}/borrower/submit` requiert :

```json
{
  "user_id": 42,
  "drivers_license_number": "…",
  "has_not_been_sued_last_ten_years": true,
  "gaa": [{ "id": 101 }],
  "saaq": [{ "id": 102 }]
}
```

Traiter explicitement :

- `401` : session expirée, retour au flux de connexion ;
- `403` : l’utilisateur ne peut pas modifier ce dossier ;
- `422` : afficher les erreurs par champ, conserver le contenu local non sensible du formulaire et ne pas marquer le dossier comme soumis ;
- erreur réseau : permettre une nouvelle tentative ; ne pas déduire que les fichiers ou la soumission ont réussi.

Après une réponse réussie, rafraîchir l’utilisateur courant puis invalider les providers dépendants.

## Découpage d’implémentation

### 1. Assainir le contrat d’authentification

- Auditer les chemins et enveloppes réellement servis par Laravel pour login, inscription, utilisateur courant, renouvellement et logout avant toute modification.
- Faire propager les erreurs de parsing ou de réseau : aucune session, aucun utilisateur et aucun statut ne doivent être fabriqués en fallback.
- Préserver la stratégie actuelle de stockage sécurisé des jetons ; vérifier le renouvellement unique en cas de plusieurs requêtes qui reçoivent simultanément un `401`.
- Ajouter ou corriger les endpoints dans `ApiEndpoints` uniquement après vérification contre les routes backend.

### 2. Modèles, data layer et état Riverpod

- Ajouter `Borrower`, `UploadedFile` et `BorrowerSubmissionRequest` sous `features/profile` ou `features/borrower` ; préférer ce dernier domaine isolé si le code nouveau dépasse le profil.
- Ajouter data source, repository et providers dédiés pour : utilisateur courant, téléversement et soumission.
- Ne pas exposer le numéro de permis dans un `toString`, `copyWith` de debug, logs Dio ou erreurs utilisateur.
- Invalider/rafraîchir l’état utilisateur après login, logout et soumission réussie.

### 3. Interface dossier emprunteur

- Faire de la ligne « Dossier conducteur & permis » du profil une navigation réelle.
- Afficher un écran d’état avant le formulaire : statut, date de soumission si disponible, documents déjà liés si l’API les autorise, et prochaine action.
- Le formulaire contient : numéro de permis, attestation obligatoire, au moins une pièce GAA et une pièce SAAQ.
- Choisir un sélecteur de documents adapté Android/iOS, avec affichage du nom, progression par fichier, suppression locale avant soumission et réessai individuel d’un upload échoué.
- Désactiver « Soumettre » tant que tous les champs requis et les uploads ne sont pas valides. Préserver l’accessibilité, les états de chargement et les messages d’erreur.
- N’afficher jamais le permis complet après saisie : masquer sa valeur ou utiliser un affichage partiellement masqué.

### 4. Garde d’éligibilité préparatoire

- Exposer une règle métier testée, par exemple `BorrowerEligibility.canRequest(loanableType)`.
- Pour `car` et `car_trailer`, exiger `borrower.validated == true`, conformément au backend actuel.
- Pour `bike` et `trailer`, ne pas bloquer localement sans règle backend explicite.
- Cette règle ne remplace pas l’autorisation Laravel lors de `POST /loans`; elle servira aux lots 2 et 3 pour informer l’utilisateur avant le formulaire de réservation.

## Corrections préalables au Lot 0

Avant de brancher cette interface aux données réelles, corriger ou isoler les éléments suivants relevés en revue :

- faire échouer le parsing d’une disponibilité invalide au lieu de créer un intervalle indisponible daté de 1970 ;
- faire échouer le parsing d’un prêt dépourvu de `departure_at` ou `status` au lieu d’inventer des valeurs ;
- réaligner les fixtures `ListLoanableResource` sur la ressource Laravel réelle ;
- régénérer/formater les fichiers générés afin que `git diff --check` soit propre.

Ces corrections peuvent faire l’objet d’un petit commit préalable ; ne pas les dissimuler dans les changements de formulaire sans tests de régression.

## Tests et critères d’acceptation

- Tests des mappings `BorrowerResource` : à compléter, soumis, validé, suspendu et combinaison inattendue.
- Tests de sérialisation du payload de soumission, y compris les listes `gaa` et `saaq` d’objets `{id}`.
- Tests du multipart : clé `field`, clé du fichier correspondante, authentification, succès et erreurs `422`/réseau.
- Tests des controllers : erreur propagée, état rafraîchi après succès, absence de fallback fictif.
- Tests widget : profil → dossier → formulaire incomplet → upload → erreur de validation → succès simulé.
- Tests de la règle d’éligibilité pour les quatre types de véhicules.
- Vérifications finales depuis `mobile/` :

```bash
dart format lib test
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
git diff --check
```

Le lot est accepté si l’état affiché provient d’une réponse backend réelle, si le dossier peut être soumis avec les documents requis, si les erreurs restent actionnables, et si aucune donnée sensible n’est persistée ou journalisée en clair.

## Consignes de livraison

- Travailler dans `mobile/` et ne pas modifier le backend sauf demande explicite.
- Ne pas committer les secrets, les fichiers réels, les jetons ou les numéros de permis.
- Documenter dans le compte-rendu les routes effectivement vérifiées et toute divergence de contrat découverte.
- Fournir le diff, les tests exécutés et les limites restantes ; ne pas déclarer le lot terminé si les endpoints d’authentification n’ont pas été vérifiés contre Laravel.
