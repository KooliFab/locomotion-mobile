# Lot 14 — Indisponibilités exceptionnelles et récurrentes

## Mission du sous-agent

Permettre au propriétaire de gérer son calendrier sans contourner les prêts déjà acceptés.

## Dépendances

Lots 8 et 13; coordination avec Lot 12.

## Périmètre et découpage d’implémentation

### Contrats et sources
- `PUT /loanables/{id}` accepte `availability_mode` et `availability_json`.
- Lecture : `GET /loanables/{id}/availability`, `/events`, `/loans/unavailable`.
- Lire `backend/app/Calendar/AvailabilityHelper.php`, tests associés et contrôleurs; le format récurrent doit être documenté, pas inventé depuis une bibliothèque de calendrier.

### Découpage
1. Documenter le schéma de règles existant et ses limites : dates, heures, fuseau, récurrence, exceptions, priorité et bornes.
2. Créer/modifier/supprimer une indisponibilité ponctuelle avec aperçu du créneau.
3. Ajouter récurrence hebdomadaire minimale (jours, heures, date de fin ou horizon explicite) uniquement si compatible avec le backend.
4. Afficher les prêts affectés avant enregistrement; décider rejet ou traitement explicite des conflits. Aucune annulation silencieuse.
5. Préserver les règles non éditables par cette UI; prévenir l’écrasement concurrent et le remplacement accidentel de tout `availability_json`.
6. Vérifier cohérence immédiate de recherche, nouvelles réservations et prolongations après sauvegarde.

### Hors périmètre
Synchronisation calendrier externe, moteur universel RRULE et remplacement du moteur existant.

### Tests et acceptation
- Minuit, intervalle multi-jours, frontières inclusives/exclusives et transitions heure d’été/hiver.
- Exception dans une récurrence, règles croisées, date de fin, suppression d’occurrence/série selon capacités documentées.
- Concurrence indisponibilité/réservation/prolongation testée serveur.
- Aperçu et résultat Laravel identiques; en cas de règle non supportée, affichage lecture seule explicite.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

