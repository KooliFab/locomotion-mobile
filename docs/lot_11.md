# Lot 11 — Retour, validation et règlement final

## Mission du sous-agent

Clôturer le prêt avec état des lieux, validations et contribution réelle réconciliée.

## Dépendances

Lots 8–10.

## Périmètre et découpage d’implémentation

### Contrats et sources
- `PUT /loans/{id}/factors` : `mileage_end`, `mileage_end_image_id`; actuellement fin strictement supérieure au début (`gt`). Zéro km demande un arbitrage et, si retenu, une évolution serveur testée.
- `PUT /loans/{id}/return` traite le retour anticipé d’un prêt `ongoing`; ce n’est pas une transaction atomique inspection + paiement.
- `PUT /loans/{id}/validate`, `PUT /loans/{id}/pay`, `GET /loans/{id}/estimate`; lire transitions dans `Loan.php`.
- Modifier les facteurs réinitialise les validations. Signature/album et paiement Stripe final suivent le Lot 8.

### Découpage
1. Construire le parcours compteur final → photos → observations → récapitulatif → confirmation.
2. Estimer via Laravel la contribution réelle, en distinguant distance, durée et autres lignes applicables; afficher écart avec estimation et caution.
3. Gérer retour anticipé et prêt déjà terminé sans appeler systématiquement `/return`; documenter la séquence serveur autorisée et reprise de chaque étape.
4. Ajouter validation emprunteur/propriétaire, horodatage et version des données; invalider un accord si les preuves/chiffres changent.
5. Ajouter la signature prévue au contrat, sans la confondre avec `/validate`; désaccord ouvre un signalement, sans validation forcée.
6. Régler une seule fois selon le modèle financier approuvé, libérer/ajuster la caution et afficher facture/confirmation autorisée.
7. Gérer échec de paiement après restitution, validation en attente et contestation; « véhicule rendu » n’implique pas « paiement encaissé ».

### Hors périmètre
Capture automatique de caution pour dommage non arbitré, expertise et traitement administratif complet de litige.

### Tests et acceptation
- Fin < début, zéro km, changement après validation, un seul validateur, auto-validation existante et propriétaire emprunteur.
- Retour réussit puis paiement échoue : état récupérable et aucune seconde facturation.
- Paiement dupliqué/concurrent, total nul, remboursement/libération et webhook retardé.
- Timeline, montants et états serveur cohérents sur les deux rôles; recette photo/signature sur appareils réels.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

