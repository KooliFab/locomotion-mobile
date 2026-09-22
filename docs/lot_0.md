# Lot 0 — Stabilisation du contrat API mobile

## Objectif

Rendre les échanges Flutter–Laravel prévisibles pour les quatre opérations nécessaires au futur parcours de réservation : lister les véhicules, consulter une disponibilité, créer une demande et charger le tableau de bord des réservations. Ce lot n’ajoute pas encore le parcours UI de réservation ni les actions du propriétaire.

Le backend existant est la source de vérité. Aucun endpoint ou changement de schéma backend n’est prévu dans ce lot. Si les tests révèlent un contrat impossible à consommer ou une règle incohérente, documenter le cas et le traiter séparément plutôt que d’inventer un contrat mobile parallèle.

## Contrats à aligner

### Véhicules

- Adapter le parsing de `GET /loanables` à la collection paginée `ListLoanableResource` et celui de `GET /loanables/{id}` à `LoanableResource`. Les deux réponses n’exposent pas les mêmes champs; garder un mapping explicite liste/détail et ne pas supposer que chaque champ de détail est présent dans la liste.
- Cartographier les champs utiles au futur parcours : identifiant, nom, type (`bike`, `car`, `trailer`, `car_trailer`), position, fuseau horaire, mode et état de disponibilité, durées minimale/maximale, images, détails et incidents actifs. Les champs qui ne sont pas renvoyés restent absents plutôt que de recevoir une valeur métier inventée.
- Une ressource image contient des métadonnées (`id`, `filename`, `sizes`, etc.), pas une URL prête à afficher. Charger les octets via `GET /images/{image}` et construire l’adresse à partir de la configuration de base de l’API; ne pas traiter cet endpoint comme une ressource JSON d’image.

### Disponibilité

- Appeler `GET /loanables/{id}/availability` avec `start`, `end` et `responseMode=available`.
- Parser la réponse comme une liste d’événements Laravel de la forme `type`, `start`, `end`, `data.available`. Le booléen est dans `data.available`; la réponse ne contient pas de champ `isAvailable` à la racine.
- Interpréter et afficher les dates dans le fuseau du véhicule (`timezone`). Ne pas assimiler l’intervalle retourné à une réservation confirmée : la disponibilité peut changer et Laravel reste l’autorité lors de la création.

### Demandes et tableau de bord

- Aligner les modèles sur les propriétés réellement renvoyées par `LoanResource`, `DashboardLoanResource` et `ListLoanResource`, dont les relations imbriquées `loanable`, `community` et `borrower_user`.
- Reconnaître les statuts persistés `requested`, `accepted`, `confirmed`, `ongoing`, `ended`, `validated`, `completed`, `canceled` et `rejected`. Prévoir aussi un comportement sûr pour un statut futur ou inconnu; ne pas le faire échouer au parsing.
- Parser `GET /loans/dashboard` selon ses catégories `started`, `waiting`, `need_approval`, `future` et `completed`, chacune contenant `total` et `loans`. `need_approval` sera consommé par le futur lot propriétaire; ce lot vérifie seulement son contrat.
- Créer un DTO de demande pour `POST /loans` avec les clés requises par Laravel : `loanable_id`, `borrower_user_id`, `departure_at`, `duration_in_minutes`, `estimated_distance` et `alternative_to`. `alternative_to` accepte `delivery`, `car`, `public_transit`, `bike`, `walking` ou `other`. `alternative_to_other` et `message_for_owner` sont facultatifs/nullables. `community_id` est normalement résolu par le backend.
- Envoyer `departure_at` comme heure locale du véhicule, sans la convertir implicitement en heure locale de l’appareil. `duration_in_minutes` remplace le couple mobile actuel `start_at`/`end_at`.

## Changements Flutter

- Mettre à jour les entités et mappings véhicule, disponibilité et réservation; inclure `validated` parmi les statuts et tolérer les champs optionnels des différentes ressources.
- Adapter les data sources et repositories aux enveloppes JSON et aux paramètres ci-dessus; exposer la lecture du dashboard et de la disponibilité, ainsi que la création conforme d’une demande.
- Adapter les controllers Riverpod pour propager les erreurs réseau et de parsing. Supprimer les véhicules de démonstration comme fallback en exécution normale; les erreurs ne doivent pas être présentées comme une liste vide ou des données réelles. Utiliser des fixtures explicites dans les tests.
- Ne pas ajouter dans ce lot les méthodes `accept`, `reject` ou `cancel`, les écrans/onglets de réservation, le statut/dossier emprunteur, les notifications push, ni les fonctionnalités de paiement.
- Régénérer les fichiers Freezed/JSON avec `build_runner` après modification des annotations.

## Tests et critères d’acceptation

- Ajouter des fixtures JSON représentatives des ressources Laravel pour la liste paginée, le détail d’un véhicule, les événements de disponibilité, les catégories du dashboard et la création d’une demande.
- Tester les mappers pour les champs absents/nullables, les relations imbriquées, chaque statut connu, un statut inconnu et la réponse paginée. Les données des fixtures doivent correspondre aux ressources backend, pas à des exemples simplifiés inventés.
- Tester les data sources : chemin et paramètres de disponibilité, sérialisation exacte du payload `POST /loans`, enveloppes de réponse et erreurs HTTP/JSON mal formé.
- Vérifier qu’une erreur réseau ou de parsing n’affiche jamais les véhicules de démonstration ni une fausse liste vide.
- Le lot est accepté quand `flutter analyze` et `flutter test` passent, que les contrats ci-dessus sont couverts par tests, et qu’aucune action ou écran du lot suivant n’a été ajouté.

Commandes de validation, depuis `mobile/` :

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Un essai manuel avec `http://localhost:8000/api/v1` est complémentaire si le backend local est disponible; il ne remplace pas les tests déterministes basés sur les fixtures.
