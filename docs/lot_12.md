# Lot 12 — Prolongations de réservation

## Mission du sous-agent

Permettre une demande de prolongation et sa décision sans créer de conflit de calendrier.

## Dépendances

Lot 8; Lots 9/11 pour les impacts financiers.

## Périmètre et découpage d’implémentation

### Contrats vérifiés
- `PUT /loans/{id}/extension` : `extension_duration_in_minutes` est la nouvelle durée totale depuis le départ, pas le nombre de minutes supplémentaires.
- Minimum actuel : durée initiale + 15 minutes (au moins 15).
- `PUT /loans/{id}/extension/accept|reject|cancel`.
- Laravel vérifie la disponibilité à la demande et à l’acceptation; auto-service ou utilisateur autorisé à accepter peut appliquer immédiatement la durée.
- Sources : `LoanController@requestExtension|acceptExtension|rejectExtension|cancelExtension`, `LoanPolicy.php`, `LoanResource.php`.

### Découpage
1. Afficher heure de retour actuelle, nouvelle heure dans le fuseau du véhicule, durée totale et supplément estimé serveur.
2. Séparer demande en attente et prolongation appliquée; ne modifier le calendrier local qu’après rechargement serveur.
3. Ajouter accepter/refuser côté propriétaire et annuler côté demandeur selon policies; rafraîchir toutes les vues.
4. Préserver créneau initial lors d’un conflit, refus ou annulation; gérer une demande déjà traitée par un autre appareil.
5. Tester/renforcer côté backend atomicité de la vérification et de la mutation; contrôle de disponibilité seul insuffisant face à deux écritures concurrentes.
6. Gérer re-prépaiement et durée de caution selon Lot 8; ajout push demande/décision avec rechargement à l’ouverture.

### Hors périmètre
Replanification complète du départ, approbation obligatoire contredisant l’auto-service sans changement produit validé.

### Tests et acceptation
- Frontières de créneau, DST/fuseau différent, minimum de durée, conflit apparu après demande.
- Demandes concurrentes, décision concurrente à une réservation, annulation, refus et cas auto-service.
- Une demande en attente ne se présente jamais comme acceptée; impacts financiers explicites et testés.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

