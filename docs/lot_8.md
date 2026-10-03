# Lot 8 — Contrats post-MVP et socle serveur

## Mission du sous-agent

Transformer les demandes produit en contrats explicites, sécurisés et testables avant les interfaces.

## Dépendances

Aucun; MVP déclaré terminé par le porteur de projet, sans nouvelle certification dans cette roadmap.

## Périmètre et découpage d’implémentation

### Sources existantes
- `backend/routes/api.php`, `LoanController`, `Loan.php`, `LoanPolicy.php`, `PaymentMethodController`, `IncidentController`, `IncidentPolicy.php`, `LoanableController`, `AvailabilityHelper.php`.
- `Loan::prepay()` marque le prépaiement et change le statut; `Loan::pay()` comptabilise des factures et modifie les soldes utilisateurs. Ces fonctions ne prouvent pas une autorisation/capture Stripe par prêt.
- Les cartes existantes utilisent `createCardBySourceId`; ne pas supposer leur compatibilité directe avec un nouveau parcours Stripe mobile.
- `/factors` expose des images de compteur, pas un album complet d’état des lieux. `/validate` valide les informations, pas une signature dessinée.

### Découpage
1. Produire une matrice rôle × statut × action, incluant auto-service, propriétaire emprunteur et véhicules sans compteur.
2. Décider et consigner : modèle solde/prépaiement/caution, devise, unité des montants, tarifs, taxes, remboursement, annulation, impayé et litige. Éviter deux débits pour une seule contribution.
3. Définir le cycle de caution : création, authentification, expiration, renouvellement, capture partielle et libération. Vérifier les contraintes Stripe dans la documentation officielle au moment de l’implémentation.
4. Spécifier état des lieux départ/retour : champs, photos, conservation, accès, version, validations et valeur attendue de la signature. Une simple signature graphique ne vaut pas une garantie juridique.
5. Auditer l’atomicité des disponibilités et des paiements; définir idempotence, verrous, transactions, traitement des webhooks dupliqués/désordonnés et réconciliation.
6. Documenter les nouveaux contrats nécessaires dans `docs/post_mvp_contracts.md` : méthode, route proposée, payload, ressource, erreurs, policy, transitions et événement. Ajouter serveur/migrations seulement après validation des décisions; livrer au minimum les contrats approuvés et tests nécessaires aux lots suivants.
7. Définir la stratégie push : événements, destinataires autorisés, payload minimal et ouverture du bon écran. Prévoir flags et configuration par environnement.

### Hors périmètre
Interfaces complètes, paiement réel, tarification arbitraire, refonte du MVP.

### Tests et acceptation
- Matrice de permissions testée côté serveur; négatifs d’accès croisé aux prêts/images.
- Tests de concurrence et de double traitement financier planifiés puis implémentés avec les contrats concernés.
- Aucun lot dépendant ne démarre sur un contrat financier ou d’état des lieux non approuvé.
- Chaque choix encore ouvert a un responsable et bloque uniquement la fonctionnalité concernée.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

