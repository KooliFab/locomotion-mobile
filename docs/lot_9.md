# Lot 9 — Paiement mobile et caution Stripe

## Mission du sous-agent

Permettre un paiement compréhensible et récupérable, sans exposer de données bancaires ni confondre caution et contribution.

## Dépendances

Lot 8 validé pour les paiements.

## Périmètre et découpage d’implémentation

### Contrats et sources
- Existants : `GET/POST /payment_methods`, `GET/DELETE /payment_methods/{id}`, `PUT /loans/{id}/prepay`, `GET /loans/{id}/estimate`.
- Lire contrôleur, requests, resources et policies; les payloads de l’ancien modèle carte ne sont pas ceux d’un PaymentSheet.
- Nouveaux contrats Stripe, état de caution et webhooks : uniquement ceux approuvés au Lot 8.

### Découpage
1. Ajouter DTO/repository pour moyen de paiement, estimation et état financier; distinguer estimé, autorisé, encaissé, libéré et échoué.
2. Intégrer un parcours Stripe adapté au contrat choisi : clés publiques par environnement, secrets serveur, saisie via composants Stripe, authentification et retour d’application.
3. Afficher avant confirmation contribution estimée, caution distincte, devise et conditions de prélèvement; aucune formule tarifaire authoritative côté Flutter.
4. Ajouter/supprimer une carte selon policy, afficher uniquement métadonnées autorisées. Documenter l’effet d’une suppression sur une caution active.
5. Confirmer le prépaiement seulement après l’état serveur attendu; gérer frais nuls, solde suffisant et exemptions définies.
6. Gérer refus bancaire, abandon, authentification interrompue, webhook retardé, timeout et relance de l’app. Recharger l’état sans créer une seconde opération.
7. Ajouter reprise et notifications d’action requise; afficher expiration/renouvellement de caution pour réservations longues selon contrat.

### Hors périmètre
Règlement final au retour (Lot 11), remboursement administratif manuel, changement du modèle financier sans décision.

### Tests et acceptation
- En environnement Stripe test : succès, refus, authentification, abandon, double tap, timeout après succès, webhook dupliqué et remboursement/libération prévus.
- Contrôle serveur du montant, de la devise, de la propriété du moyen de paiement et de l’idempotence.
- Aucun numéro de carte/CVC persisté par l’app; secret absent du dépôt.
- Statut du prêt et état du paiement rechargés après retour Stripe; tests widget des états différés.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

