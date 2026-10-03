# Lot 10 — Prise en charge et état des lieux départ

## Mission du sous-agent

Permettre un relevé fiable du départ et des preuves photo accessibles uniquement aux participants autorisés.

## Dépendances

Lot 8 état des lieux; Lot 9 si paiement/caution préalable requis.

## Périmètre et découpage d’implémentation

### Contrats et sources
- Existant : `PUT /loans/{id}/factors` avec `mileage_start` et `mileage_start_image_id`; upload d’images à vérifier dans les contrôleurs/routes.
- Lire `LoanController@updateFactors`, les relations images et `LoanPolicy@update`.
- Une modification des facteurs peut réinitialiser les validations et le statut financier. Ne pas présenter cet appel comme un simple « démarrer le prêt ».
- Album d’inspection et confirmation de prise en charge : contrat nouveau du Lot 8.

### Découpage
1. Ajouter l’entrée « Prendre en charge » selon rôle, statut, horaire et exigences financières serveur.
2. Présenter consignes et checklist; saisir un compteur entier avec unité explicite, et cas sans compteur.
3. Photographier compteur et état du véhicule; gérer permissions caméra, refus définitif, compression/orientation et limites serveur.
4. Conserver un brouillon local minimal, séparé par utilisateur/prêt, et reprendre les uploads interrompus; aucun envoi final automatique hors ligne.
5. Envoyer les preuves, puis associer leurs identifiants au prêt/inspection. Empêcher la confirmation si une preuve obligatoire manque.
6. Afficher le récapitulatif, confirmer selon contrat et recharger prêt/timeline/dashboard; ne pas déduire le statut du seul bouton.
7. Définir suppression des brouillons/photos temporaires et traitement des uploads orphelins.

### Hors périmètre
Photos visibles publiquement, OCR obligatoire, déverrouillage connecté, règlement final.

### Tests et acceptation
- Compteur invalide, photo manquante, refus caméra, upload partiel, perte réseau, relance app et double tap.
- Accès à la preuve interdit à un tiers; backend refuse identifiant d’image non autorisé.
- Deux appareils ne peuvent écraser silencieusement une inspection confirmée.
- Recette caméra et reprise sur Android/iOS physiques; véhicules sans kilométrage couverts.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

