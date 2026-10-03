# Lot 13 — Gestion mobile de la flotte propriétaire

## Mission du sous-agent

Créer et modifier un véhicule, et suspendre sa réservation sans perdre l’historique.

## Dépendances

Lot 8; réutilisation de l’upload du Lot 10.

## Périmètre et découpage d’implémentation

### Contrats et sources
- `GET/POST /loanables`, `GET/PUT /loanables/{id}`, `PUT /loanables/{id}/publish`, `DELETE /loanables/{id}`, `PUT /loanables/{id}/restore`.
- Sources : `LoanableController@create|update|publish|destroy|restore`, policies, validation des détails et resources.
- Création : `type`, `owner_user.id`, `name` requis; détails varient entre bike/car/trailer/car_trailer.
- Certains champs d’une voiture publiée sont interdits sans permission spécifique.
- `availability_mode=never`, dépublication et suppression sont des mécanismes différents : choisir précisément le contrat de désactivation, sans assimiler supprimer à suspendre.

### Découpage
1. Lister uniquement les véhicules gérables par l’utilisateur via un filtre serveur vérifié; aucun `owner_id` inventé.
2. Formulaire par type : identité, détails nécessaires, localisation, consignes, photos et mode de partage.
3. Réutiliser les validations Laravel; conserver saisie et erreurs par champ. Restreindre sélection propriétaire selon droits réels.
4. Modifier par patch logique des champs autorisés; ne pas envoyer toute la ressource avec des champs publiés verrouillés.
5. Prévisualiser puis publier selon workflow existant; afficher les exigences administratives bloquantes.
6. Suspendre avec confirmation des conséquences et affichage des réservations existantes; pas d’annulation implicite. Réactiver selon policy.
7. Rafraîchir exploration, fiche, parc propriétaire et disponibilités; traiter accès retiré et modification concurrente.

### Hors périmètre
Gestion complète des rôles, import massif, éditeur de tarifs avancé et suppression définitive.

### Tests et acceptation
- CRUD par type, photos ordonnées, champs verrouillés, propriétaire/co-propriétaire/tiers/admin.
- Véhicule suspendu non réservable; historique et prêts actifs préservés.
- Si aucun filtre propriétaire sûr n’existe, le contrat serveur manquant est livré avant la liste mobile.
- Double création, réponse perdue et conflit d’édition récupérables.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

