# Roadmap post-MVP — Cycle complet du prêt LocoMotion

## Objectif et point de départ

Le porteur de projet annonce les Lots 0–7 terminés. Ce plan prend ce MVP comme base; il ne constitue pas une nouvelle certification de son code ou de sa recette matérielle.

Objectif : compléter le cycle réservation → paiement/caution → départ → prolongation éventuelle → retour/validation → règlement, avec gestion du parc et des incidents.

## Découpage et dépendances

| Lot | Livrable | Dépendance |
|---|---|---|
| 8 | [Contrats post-MVP et socle serveur](lot_8.md) | Aucun; MVP déclaré terminé par le porteur de projet, sans nouvelle certification dans cette roadmap. |
| 9 | [Paiement mobile et caution Stripe](lot_9.md) | Lot 8 validé pour les paiements. |
| 10 | [Prise en charge et état des lieux départ](lot_10.md) | Lot 8 état des lieux; Lot 9 si paiement/caution préalable requis. |
| 11 | [Retour, validation et règlement final](lot_11.md) | Lots 8–10. |
| 12 | [Prolongations de réservation](lot_12.md) | Lot 8; Lots 9/11 pour les impacts financiers. |
| 13 | [Gestion mobile de la flotte propriétaire](lot_13.md) | Lot 8; réutilisation de l’upload du Lot 10. |
| 14 | [Indisponibilités exceptionnelles et récurrentes](lot_14.md) | Lots 8 et 13; coordination avec Lot 12. |
| 15 | [Incidents et signalements](lot_15.md) | Lot 8; liens avec Lots 10/11/14. |
| 16 | [QA post-MVP et distribution progressive](lot_16.md) | Lots 8–15 intégrés; aucun blocage contractuel restant sur fonctionnalités activées. |

Ordre conseillé : 8 → 9 → 10 → 11 → 12, puis 13 → 14 → 15 → 16. Après le Lot 8, flotte et incidents peuvent avancer en parallèle du parcours financier si leurs contrats sont prêts. Ne pas faire modifier simultanément les mêmes modèles partagés sans coordination d’intégration.

## Décisions à prendre au Lot 8

- Modèle financier : compte/solde Laravel existant ou débit Stripe par prêt; articulation du prépaiement, de la caution et du règlement sans double facturation.
- Caution : montant, durée, renouvellement, annulation, capture autorisée, litige et libération.
- Inspection : photos obligatoires, cas sans compteur/zéro km, validations, signature, conservation et accès.
- Prolongation : auto-service existant ou approbation explicite; supplément et re-prépaiement.
- Suspension véhicule : interdire les nouveaux prêts tout en préservant les prêts actifs et l’historique.
- Calendrier : traitement d’un blocage créé sur une réservation déjà acceptée.
- Incidents : mapping des catégories, destinataires administratifs et politique de blocage.

Aucun montant, délai légal, format Stripe ou route nouvelle n’est présumé validé. Les décisions ouvertes bloquent la fonctionnalité concernée, pas les travaux indépendants.

## Écart entre existant et nouvelles fonctionnalités

Constats issus de la lecture du code local, pas de tests sur backend réel :
- Laravel expose prépaiement, paiement et estimation; le prépaiement marque un état, le paiement modifie des soldes et factures. Cela ne suffit pas à démontrer une caution Stripe par réservation.
- Les facteurs de prêt couvrent compteur et image de compteur. Album d’état des lieux et signature nécessitent un contrat complémentaire.
- Les prolongations existent, avec durée totale et vérification de disponibilité à la demande puis à l’acceptation. L’atomicité sous concurrence doit être testée.
- Le CRUD véhicule et les règles de disponibilité existent. Permissions, publication et désactivation ne sont pas interchangeables.
- Les incidents existent avec événement Laravel et catégories génériques. Push mobile, preuves et retard doivent être cadrés.

## Règles de travail des sous-agents

Chaque fichier de lot est un brief autonome. Implémenter uniquement le lot confié, réutiliser les composants existants et relire le contrat serveur. Livrer tests et compte-rendu avant d’intégrer le lot suivant. Toute évolution Laravel doit préserver le client MVP et prévoir migrations et compatibilité.

Les tests de fixtures ne remplacent ni les tests serveur, ni Stripe test, ni la recette caméra/push sur matériel. Aucune publication, aucun paiement réel et aucun secret dans le dépôt public sans autorisation correspondante.

## Jalons de livraison

1. Contrats approuvés (Lot 8).
2. Cycle financier et terrain utilisable sur staging (Lots 9–11).
3. Prolongation sécurisée (Lot 12).
4. Parc, calendrier et incidents utilisables (Lots 13–15).
5. Pilote post-MVP validé (Lot 16).

Pas d’estimation calendaire ferme avant le cadrage financier; la modernisation Stripe et les nouveaux contrats d’inspection peuvent représenter du travail backend significatif.

