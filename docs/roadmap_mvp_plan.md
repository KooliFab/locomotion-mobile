# Roadmap MVP — Réserver un véhicule LocoMotion

## Résumé

Objectif du premier lancement : permettre à un emprunteur de trouver un véhicule, vérifier sa disponibilité, envoyer une demande de réservation, puis permettre au propriétaire de l’accepter ou de la refuser depuis l’application.

Périmètre retenu :

- Voitures, vélos et remorques
- Demande avec approbation du propriétaire
- Rôles emprunteur et propriétaire
- Dossier emprunteur géré dans l’app
- Notifications push Firebase + emails existants
- Aucun paiement dans le MVP
- API mobile alignée sur l’API Laravel actuelle

## Roadmap par lots

### Lot 0 — Stabilisation du contrat API

Corriger l’écart actuel entre Flutter et Laravel avant d’ajouter l’interface de réservation.

- Adapter `Loanable` aux ressources Laravel : localisation, fuseau horaire, disponibilité, durée minimale/maximale, images, détails et incidents.
- Adapter `Loan` aux réponses imbriquées `loanable`, `community` et aux statuts réels :
  `requested`, `accepted`, `confirmed`, `ongoing`, `ended`, `completed`, `canceled`, `rejected`.
- Envoyer le payload réellement attendu par `POST /loans` :

```json
{
  "loanable_id": 123,
  "borrower_user_id": 456,
  "departure_at": "2026-10-01T09:00:00",
  "duration_in_minutes": 120,
  "estimated_distance": 20,
  "alternative_to": "public_transit",
  "alternative_to_other": null,
  "message_for_owner": "..."
}
```

- Utiliser `/loanables/{id}/availability` comme source de vérité.
- Utiliser `/loans/dashboard` pour séparer :
  - demandes de l’emprunteur ;
  - demandes nécessitant une approbation propriétaire ;
  - réservations futures, en cours et terminées.
- Supprimer les données de démonstration en environnement réel; les conserver uniquement pour les tests.

### Lot 1 — Authentification et éligibilité

- Finaliser login, inscription, renouvellement de token et récupération de l’utilisateur courant.
- Afficher l’état du dossier emprunteur :
  - non commencé ;
  - soumis ;
  - approuvé ;
  - suspendu.
- Ajouter le formulaire de validation :
  - numéro de permis ;
  - déclaration obligatoire ;
  - pièces `gaa` et `saaq` via `/files` ;
  - soumission via `/users/{user}/borrower/submit`.
- Empêcher clairement la réservation d’une voiture ou d’une remorque de voiture si l’emprunteur n’est pas validé.
- Autoriser les types ne nécessitant pas cette validation selon la réponse du backend.
- Remplacer les menus actuellement fictifs du profil par des écrans fonctionnels ou les masquer du MVP.

### Lot 2 — Recherche et fiche véhicule

- Liste des véhicules avec états réels venant du backend.
- Filtres par type et communauté.
- Recherche textuelle.
- Vue liste et vue carte.
- Fiche véhicule comprenant :
  - photos ;
  - type et caractéristiques ;
  - emplacement ;
  - communauté ;
  - instructions ;
  - incidents bloquants ;
  - durée minimale/maximale ;
  - statut de disponibilité.
- Calendrier de disponibilité basé sur le fuseau horaire du véhicule.
- Gestion des états vides, erreurs réseau, véhicule supprimé ou devenu indisponible.

### Lot 3 — Création d’une réservation emprunteur

Créer un parcours en plusieurs étapes :

1. Choix du départ et de la durée.
2. Vérification de disponibilité.
3. Distance estimée.
4. Mode de transport remplacé :
   - `delivery` ;
   - `car` ;
   - `public_transit` ;
   - `bike` ;
   - `walking` ;
   - `other`.
5. Message facultatif au propriétaire.
6. Résumé et confirmation.

Règles :

- Respecter les durées minimale et maximale du véhicule.
- Afficher les dates dans le fuseau horaire du véhicule.
- Refaire une vérification serveur juste avant l’envoi.
- Traiter explicitement les réponses `403`, `409` et `422`.
- Après création, afficher la réservation avec le statut `requested`.
- Ne jamais confirmer localement une réservation avant la réponse du serveur.

### Lot 4 — Suivi côté emprunteur

- Tableau de bord des réservations :
  - en attente ;
  - acceptées/confirmées ;
  - en cours ;
  - terminées ;
  - annulées/refusées.
- Écran de détail avec timeline et informations du véhicule.
- Annulation selon les règles du backend.
- Modification des dates avant confirmation via `/loans/{loan}/dates`.
- Ajout de commentaires via `/loans/{loan}/comment`.
- Actualisation manuelle et automatique après retour depuis une notification.

### Lot 5 — Actions propriétaire

Ajouter une section “Demandes à traiter” alimentée par `need_approval` de `/loans/dashboard`.

Le propriétaire ou co-propriétaire pourra :

- consulter la demande ;
- voir l’emprunteur et les dates ;
- accepter via `/loans/{loan}/accept` ;
- refuser avec commentaire via `/loans/{loan}/reject` ;
- commenter la demande ;
- annuler une réservation existante si le backend l’autorise.

La création/modification des véhicules, des tarifs, des rôles et des périodes d’indisponibilité reste hors MVP.

### Lot 6 — Notifications push

Ajouter Firebase Cloud Messaging pour Android et iOS.

Backend minimal :

- table des appareils utilisateurs ;
- `POST /auth/user/push-tokens` ;
- `DELETE /auth/user/push-tokens/{id}` ;
- stockage du token, plateforme et date de dernière activité ;
- envoi push sur :
  - nouvelle demande au propriétaire ;
  - demande acceptée ;
  - demande refusée ;
  - réservation annulée ;
  - nouveau commentaire.

Chaque notification contiendra le type d’événement et l’identifiant de réservation afin d’ouvrir directement `/loans/{id}`.

Les emails Laravel existants restent actifs en complément.

### Lot 7 — QA et première distribution

Publier une version de test Android/iOS sur l’environnement staging.

Critères d’acceptation :

- Un utilisateur peut se connecter et voir les véhicules accessibles.
- Il peut ouvrir une fiche et visualiser les disponibilités.
- Il peut envoyer une demande valide.
- Une demande invalide ou conflictuelle est expliquée clairement.
- Le propriétaire voit la demande et peut l’accepter ou la refuser.
- L’emprunteur reçoit la mise à jour dans l’app et par push.
- Une réservation annulée apparaît correctement pour les deux rôles.
- Aucun véhicule indisponible ne peut être réservé à cause d’un état local obsolète.

## Interfaces et types à ajouter

Côté Flutter :

- `LoanableAvailabilityInterval`
- `LoanCreationRequest`
- `BorrowerStatus`
- `PushToken`
- enums partagés pour les types de véhicules, statuts de réservation et modes de transport remplacés
- mappers dédiés pour les ressources Laravel imbriquées

Côté backend :

- endpoints de tokens push ;
- tests de permissions propriétaire/emprunteur ;
- tests de concurrence sur la disponibilité ;
- événements push branchés sur les événements de réservation existants.

## Plan de tests

- Tests unitaires Flutter pour les DTO, mappers, statuts et validations de formulaire.
- Tests des data sources avec réponses API réalistes.
- Tests widget du parcours :
  login → véhicule → disponibilité → demande → suivi.
- Tests widget du parcours propriétaire :
  demande → acceptation/refus → commentaire.
- Tests Laravel pour :
  - création de réservation ;
  - emprunteur non validé ;
  - conflit de disponibilité ;
  - permissions propriétaire ;
  - annulation ;
  - tokens push.
- Vérifications finales :

```bash
flutter analyze
flutter test
php artisan test
```

## Après le MVP

À planifier ensuite :

- paiements Stripe et prépaiement ;
- estimation et facturation ;
- kilométrage, photos et retour du véhicule ;
- validation de fin de prêt ;
- extensions de réservation ;
- création et édition de véhicules ;
- gestion avancée des disponibilités ;
- incidents et signalements ;
- historique, statistiques et rappels automatiques.
