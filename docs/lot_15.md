# Lot 15 — Incidents et signalements

## Mission du sous-agent

Déclarer un dommage, une panne ou un retard et avertir les bons intervenants avec traçabilité.

## Dépendances

Lot 8; liens avec Lots 10/11/14.

## Périmètre et découpage d’implémentation

### Contrats vérifiés
- `GET/POST /incidents`; mutations `PUT /incidents/{id}`, `/complete`, `/reopen`, `/block`, `/assignee`, `/subscription`; notes via `POST /incidents/{id}/note`.
- Création : `loanable_id`, `incident_type` parmi accident/small_incident/general, `comments_on_incident`; `loan_id` et `blocking_until` facultatifs.
- Le serveur fixe actuellement un blocage d’un jour pour accident et émet `IncidentCreatedEvent`; ne pas en déduire qu’un push propriétaire/admin existe.
- Photos d’incident et endpoint de détail : à vérifier/spécifier au Lot 8, aucune route inventée.

### Découpage
1. Proposer signalement depuis le prêt et le véhicule; préremplir identifiants accessibles, description et catégorie.
2. Définir mapping dommage/crevaison/retard vers les catégories existantes; un retard ne doit pas devenir accident par défaut.
3. Ajouter preuves uniquement via contrat autorisé; confirmer incident créé et montrer son statut.
4. Afficher consignes en cas d’urgence et contacts configurés. Le signalement n’est pas un service d’assistance garanti.
5. Ajouter suivi/notes et résolution selon policies; emprunteur ne reçoit pas automatiquement droits admin.
6. Brancher push propriétaire et administrateurs concernés sur les événements serveur, avec minimisation des détails et déduplication. Tester échec d’envoi et consulter l’incident même sans push.
7. Relier blocage au calendrier et aux prêts affectés; définir conduite à tenir pour une réservation future sans annulation automatique ni capture de caution.

### Hors périmètre
Dossier d’assurance complet, expertise, collecte GPS permanente et indemnisation automatique.

### Tests et acceptation
- Catégories, descriptions obligatoires, identifiants hors accès, notes et résolution par rôles.
- Accident et blocage, retard non bloquant selon décision, prêts affectés et détails cachés aux tiers.
- Push exacts aux destinataires autorisés, pas aux admins globaux sans justification.
- Timeout de création récupérable sans doublon; signalement lié au bon prêt dans la timeline.

## Règles communes et consignes de livraison

- Lire `docs/roadmap_post_mvp_plan.md`, le présent brief et les sources Laravel citées avant de coder. Les routes ci-dessous sont relatives à la base API configurée.
- Préserver les Lots 0–7 et les modifications existantes. Réutiliser les couches data/domain/presentation, les providers Riverpod, le routage et l’invalidation des vues existants.
- Backend souverain pour droits, disponibilité, montants et statut. Aucun succès optimiste; boutons non réentrants; traiter 401/403/404/422, timeout et réponse obsolète.
- Ne jamais rejouer automatiquement une mutation financière ou une création après timeout. Recharger l’état serveur; proposer une reprise contrôlée.
- Ne journaliser ni données bancaires, secrets, photos, signatures, instructions privées ni descriptions d’incident. Aucun secret dans le dépôt public.
- Les contrats nouveaux proposés ne sont pas des API existantes. Les documenter et faire valider les choix produit avant leur implémentation; ne pas contourner une policy.
- Vérification : `rtk flutter analyze`, `rtk flutter test`, `rtk git diff --check` depuis mobile; tests Laravel ciblés depuis backend pour toute modification serveur. Générer les fichiers dérivés avec les outils du projet.
- Livrer un tableau exigence → fichier → test, les contrats utilisés, migrations éventuelles, sorties réelles des validations, limites et étapes de recette. Distinguer fixtures, lecture de code et tests sur staging.

