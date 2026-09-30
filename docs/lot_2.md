# Lot 2 — Recherche et fiche véhicule

## Mission du sous-agent

Permettre à un emprunteur authentifié de trouver un véhicule accessible, d’ouvrir sa fiche et de consulter des disponibilités réelles. Le lot ne crée aucune réservation.

## Résultat attendu

L’utilisateur peut filtrer les véhicules par type et communauté, basculer liste/carte, ouvrir une fiche complète et consulter un calendrier dans le fuseau horaire du véhicule. Les erreurs et les données incomplètes sont visibles, jamais remplacées par des résultats fictifs.

## Contrats backend

- `GET /loanables` : collection paginée `ListLoanableResource`. Ne pas supposer qu’elle contient les champs de détail, les images ou une communauté directement.
- `GET /loanables/{id}` : `LoanableResource`, pour les photos, détails, position, instructions, incidents et limites de durée.
- `GET /loanables/{id}/availability?start=…&end=…&responseMode=available` : événements `{type,start,end,data:{available}}` dans le fuseau `timezone` du véhicule.
- `GET /images/{id}` renvoie les octets de l’image, pas du JSON. Utiliser l’authentification requise et une URL construite depuis la base API.
- Vérifier les filtres réellement supportés par `Loanable::webQueryBuilder()` avant de promettre une recherche texte ou un filtre backend. Tout filtre non supporté doit être explicitement local, borné à la page chargée, ou reporté.

## Périmètre

### Inclus

- Corriger les fixtures et erreurs de parsing identifiées au Lot 0 avant de réutiliser les données dans l’UI.
- Ajouter pagination, rafraîchissement, états vide/chargement/erreur et conservation du filtre sélectionné.
- Ajouter sélecteur de type et communauté ; lister les communautés accessibles à l’utilisateur.
- Ajouter une carte adaptative, avec marqueurs uniquement pour les véhicules dont latitude et longitude sont valides, et une liste de repli sur plateformes non prises en charge.
- Ajouter une route de fiche véhicule, avec galerie, caractéristiques, localisation, incidents, conditions/instructions visibles et limites de durée.
- Ajouter un calendrier ou une vue de créneaux de disponibilité, en chargeant une fenêtre bornée et en évitant les conversions implicites vers le fuseau de l’appareil.
- Ajouter une porte d’éligibilité informative issue du Lot 1 pour `car` et `car_trailer`; elle informe, sans se substituer au contrôle Laravel.

### Hors périmètre

- Saisie d’une demande, pré-réservation locale ou `POST /loans`.
- Création/édition de véhicules, disponibilité, tarifs ou incidents.
- Navigation depuis une push notification.

## Découpage d’implémentation

1. Ajouter les routes `/loanables/:id` et les providers détail/disponibilité, avec invalidation lors du changement de véhicule ou de période.
2. Séparer les modèles de réponse liste et détail si nécessaire; ne pas remplir artificiellement le détail depuis la liste.
3. Finaliser la liste et ses filtres, puis la carte ; sélectionner un marqueur ouvre la même fiche.
4. Construire la fiche autour des champs réellement présents, avec placeholders sobres pour image, position ou détails absents.
5. Construire la vue disponibilité : navigation de période, chargement, légende, erreur explicite et accessibilité.
6. Ajouter un CTA « Continuer vers la demande » désactivé/informatif tant que le Lot 3 n’est pas livré ; ne pas créer de faux flux.

## Tests et acceptation

- Tests data source pour pagination, détail, disponibilité, image URL et réponse JSON invalide.
- Tests de timezone : les dates affichées conservent l’heure du véhicule.
- Tests widget : filtres, vide, erreur, sélection carte/liste, fiche sans photo/position, incident et créneau indisponible.
- `dart format lib test`, build_runner si requis, `flutter analyze`, `flutter test`, `git diff --check` doivent passer.

Le lot est accepté si aucun véhicule sans coordonnée ne casse la carte, si une indisponibilité ne peut pas être affichée comme disponible, et si l’interface distingue clairement données absentes, vide réel et erreur réseau.

## Consignes de livraison

Travailler uniquement dans `mobile/`, documenter les filtres backend effectivement disponibles, ne pas modifier Laravel ni ajouter de réservation. Fournir le diff et les commandes exécutées.

---

## Compte-rendu de livraison

### Fichiers créés ou modifiés

#### Entités de domaine (`lib/features/loanables/domain/entities/`)

| Fichier | Rôle |
|---|---|
| `loanable.dart` | Modèle unifié liste+détail avec prétraitement JSON pour `position` (tableau, `position_google`, `latitude`/`longitude` directs) sans injection de données fictives |
| `loanable_availability.dart` | Intervalle de disponibilité; parsing strict avec rejet des dates manquantes ou mal formées |
| `loanable_availability_window.dart` | Fenêtre combinée `available`+`unavailable` sur une période bornée avec tri par `rawStart` pour rendu jour par jour |
| `loanable_image.dart` | Métadonnées d'image (id, filename, sizes) sans URL directe |
| `loanable_incident.dart` | Incident actif (`type`, `status`, `is_blocking`, `blocking_until`) |
| `loanables_page.dart` | Page paginée avec items typés `List<Loanable>`, `hasMore`, `isLoadingMore` et `loadMoreError` |
| `vehicle_local_dates.dart` | Utilitaires de dates naïves (fuseau véhicule) : `formatYmd`, `shiftYmd`, `daysFrom`, `hhmm`, `dayOf`, `shortLabel`, `splitByDay` |

#### Couche données (`lib/features/loanables/data/`)

| Fichier | Rôle |
|---|---|
| `datasources/loanables_remote_data_source.dart` | `getLoanables` (paginé, incluant `relations=library,image,activeIncidents`), `getLoanableDetails`, `getAvailability` avec `responseMode` |
| `repositories/loanables_repository_impl.dart` | Délégation directe vers le data source |

#### Présentation (`lib/features/loanables/presentation/`)

| Fichier | Rôle |
|---|---|
| `controllers/loanables_controller.dart` | `LoanablesListController` (pagination + loadMore avec garde anti-race), `loanableDetailProvider`, `LoanableAvailabilityPeriod`, `loanableAvailabilityWindowProvider`, `SelectedLoanableType`, `SelectedLoanableCommunity` |
| `screens/explore_screen.dart` | Liste filtrée (type + communauté), basculement liste/carte, fallback liste sous bannière si aucun véhicule n'a de position, sélection d'un marqueur ouvre la fiche |
| `screens/loanable_detail_screen.dart` | Galerie, caractéristiques traduites en français, localisation (carte adaptative avec marqueur du véhicule), incidents, instructions/conditions, calendrier de disponibilité par fenêtre de 7 jours avec bouton réessayer, CTA désactivé avec info-bulle vers Lot 3, porte d'éligibilité informative différenciant chargement/erreur/non-validé |
| `widgets/loanable_image_widget.dart` | Chargement d'image via `GET /images/{id}` authentifié avec mise en cache du token et placeholder sans flash 401 |

#### Infrastructure (`lib/core/maps/`)

| Fichier | Rôle |
|---|---|
| `adaptive_map_widget.dart` | Carte Apple Maps sur iOS et OpenStreetMap (flutter_map) ailleurs sans demande de permission de localisation (`myLocationEnabled: false`); marqueurs typés pour véhicules géolocalisés |
| `map_marker.dart` | Modèle de marqueur avec `id`, `latitude`, `longitude`, `title`, `snippet`, `type`, `onTap` |

#### Routeur (`lib/core/router/app_router.dart`)

Route `/loanables/:id` ajoutée dans le `ShellRoute`. Validation de l'`id` avec écran d'erreur dédié (`_InvalidLoanableIdScreen`) si le paramètre est absent ou non-entier.

#### Tests (`test/features/loanables/`)

| Fichier | Couverture |
|---|---|
| `loanables_remote_data_source_test.dart` | Pagination (liste, page 2, liste brute), relations demandées, détail (`data` et `loanable` wrappers), disponibilité (parsing, éléments invalides, réponse non-liste), filtres type et communauté |
| `loanable_mapping_test.dart` | Position (tableau, `position_google`, `latitude`/`longitude` directs, absence), pas de données fictives, `isAvailable` pour tous les statuts connus |
| `explore_screen_test.dart` | Chargement, vide, erreur, liste de véhicules, filtre type, basculement carte/liste, repli liste si carte vide |
| `loanable_detail_screen_test.dart` | Fiche sans photo, sans position, avec position et marqueur, incident, indisponibilité, navigation, retry d'erreur de disponibilité, CTA avec info-bulle désactivé |
| `vehicle_local_dates_test.dart` | `formatYmd`, `shiftYmd`, `hhmm`, `dayOf`, `shortLabel`, `splitByDay` (intervalle finissant à minuit sans faux créneau 00:00 - 00:00) |

#### Fixtures (`test/fixtures/loanables_fixtures.dart`)

- `laravelPaginatedLoanablesJson` : page 1/3, deux véhicules, champ `library` avec `community_id` imbriqué
- `laravelPaginatedLoanablesPage2Json` : dernière page (3/3), `links.next == null`
- `laravelLoanableDetailJson` : détail complet avec `position_google`, multi-images, incidents, `details`
- `laravelAvailabilityEventsJson` : trois événements dont un indisponible

---

### Décisions d'implémentation

**Modèle unique liste/détail.** Le parsing est fait dans `Loanable.fromJson` via `_preprocessJson`. Les champs absents restent strictement `null` : aucune valeur inventée ni recopiée artificiellement (pas de duplication d'adresses/descriptions ou de noms de communauté inventés à partir de la bibliothèque).

**Carte adaptative.** `AdaptiveMapWidget` s'appuie sur Apple Maps sur iOS et OpenStreetMap (flutter_map) sur les autres plateformes. `myLocationEnabled` est désactivé pour ne pas déclencher de demande intempestive de permission de localisation. En mode carte, si aucun véhicule ne possède de coordonnées valides, une liste de repli est affichée sous un bandeau explicatif. Sur la fiche véhicule, la position du véhicule est explicitement marquée.

**Fuseau du véhicule.** `VehicleLocalDates` opère exclusivement sur des chaînes `yyyy-MM-dd` et `Y-m-d H:i:s` naïves. L'arithmétique de décalage utilise `DateTime.utc` pour éviter tout effet DST de l'appareil. Le découpage jour par jour `splitByDay` ignore les fragments vides à minuit (`rawEnd == '<day> 00:00:00'`) pour éviter tout créneau fictif « 00:00 – 00:00 ».

**Double appel de disponibilité.** `loanableAvailabilityWindowProvider` appelle simultanément `responseMode=available` et `responseMode=unavailable` avec `Future.wait`. En cas d'erreur réseau, un message clair sans trace brute Dio est présenté avec un bouton « Réessayer ».

**Filtres backend documentés.** `type`, `shared_in_community=<id>` ainsi que les `relations=library,image,activeIncidents` sont transmis au backend. `WebQueryBuilder` supporte également le paramètre de recherche `q` (branché sur `Loanable::scopeSearch` pour chercher sur le nom) et `order` pour le tri, mais la recherche plein texte et le tri ne sont pas exposés dans l'UI mobile de ce lot.

**CTA Lot 3.** Le bouton « Continuer vers la demande » est présent dans la fiche mais rendu `onPressed: null` (désactivé) avec une info-bulle Tooltip explicative « La réservation sera disponible dans le Lot 3 ». Aucun flux de réservation factice n'existe.

**Porte d'éligibilité.** L'éligibilité est évaluée en distinguant l'état de chargement et d'erreur de l'authentification de l'état validé/non validé, évitant d'afficher prématurément un message d'inéligibilité à un emprunteur pourtant en règle.

---

### Filtres backend effectivement disponibles

Vérifiés contre `Loanable::webQueryBuilder()` et `Loanable` (backend Laravel) :

| Paramètre | Support Backend | Usage Mobile Lot 2 |
|---|---|---|
| `type` | ✅ Supporté (`$filterTypes`) | ✅ Utilisé via les puces de filtres |
| `shared_in_community=<id>` | ✅ Supporté (scope dédié) | ✅ Utilisé via le sélecteur de communauté |
| `relations` | ✅ Supporté (`allowRelations`) | ✅ Utilisé (`library,image,activeIncidents`) |
| `q` | ✅ Supporté (`scopeSearch` sur `name`) | Non exposé dans l'UI mobile Lot 2 |
| `order` | ✅ Supporté (`WebQueryBuilder::addOrderBy`) | Non exposé dans l'UI mobile Lot 2 |
| `sharing_mode` | ✅ Supporté (`$filterTypes`) | Non exposé dans l'UI mobile Lot 2 |
| `library_id` | ✅ Supporté (`$filterTypes`) | Non exposé (passe par `shared_in_community`) |
| Filtre par disponibilité | ❌ Absent du backend | Non disponible |

---

### Divergences et observations

- **Enveloppe de détail variable.** `GET /loanables/{id}` peut renvoyer le véhicule directement à la racine, sous `data`, ou sous `loanable`. Le data source gère les trois cas.
- **`position_google` vs `position`.** Les deux formats co-existent dans les réponses réelles. `_preprocessJson` priorise le tableau `position`, puis `position_google`, puis `latitude`/`longitude` directs.
- **Dates de disponibilité sans fuseau.** Le backend retourne des chaînes naïves `Y-m-d H:i:s`. Les vues de disponibilité utilisent exclusivement les chaînes brutes pour l'affichage de l'heure locale du véhicule.

---

### Limites restantes

- **Carte limitée à la page chargée.** La carte affiche uniquement les véhicules de la page courante; il n'y a pas de pagination globale sur la vue carte dans ce lot.
- Aucune mise en cache locale des fiches ou de la disponibilité. Chaque ouverture d'écran déclenche une requête réseau.
- Le calendrier de disponibilité navigue par fenêtres de 7 jours; il n'existe pas de sélecteur de mois complet ni de vue condensée.
- La recherche texte et le tri supportés par le backend ne sont pas encore reliés à un champ de saisie dans l'application mobile.
- Le CTA vers la demande (Lot 3) est présent mais non fonctionnel.

---

### Commandes de validation exécutées

```bash
dart format lib test
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
git diff --check
```
