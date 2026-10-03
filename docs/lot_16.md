# Lot 16 — QA post-MVP et distribution progressive

## Mission du sous-agent

Valider le cycle complet sur staging et appareils réels avant activation publique.

## Dépendances

Lots 8–15 intégrés; aucun blocage contractuel restant sur fonctionnalités activées.

## Périmètre et découpage d’implémentation

### Découpage
1. Matrice Android/iOS × emprunteur/propriétaire × types de véhicule × états et montants; données synthétiques sur staging.
2. Recette intégrale : réservation → acceptation → paiement/caution → prise en charge → prolongation → retour → double validation → règlement/libération.
3. Recettes négatives : tiers, conflit, refus, annulation, incident, validation contestée, caution expirée et impayé.
4. Tests concurrence à deux appareils et backend, timeouts après commit, webhooks retardés/désordonnés, relance app, fuseaux et DST.
5. Tester permissions caméra, push, deep-links, nettoyage des brouillons, accessibilité et grands textes sur matériel Android/iOS.
6. Vérifier configuration séparée Stripe test/live, secrets uniquement serveur, logs expurgés, accès aux médias et rétention documentée.
7. Livrer migrations/compatibilité avec clients MVP, flags serveur, procédure de rollback non destructive et réconciliation financière. Une désactivation UI ne rembourse pas une opération déjà engagée.
8. Documenter déploiement staging puis pilote restreint, critères go/no-go et surveillance actionnable (pas de données sensibles).

### Tests et acceptation
- `flutter analyze`, suite Flutter complète, tests Laravel concernés et `git diff --check` avec sorties réelles.
- Builds Android/iOS et parcours exécutés sur appareils réels, captures non sensibles et versions documentées.
- Aucun défaut bloquant de droits, double débit, conflit de réservation ou perte de preuve.
- Chaque lot dispose de sa matrice exigence/fichier/test; limites restantes explicites et fonctionnalité désactivée si non sûre.

### Hors périmètre
Publication store ou paiement réel sans autorisation explicite du porteur de projet.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

