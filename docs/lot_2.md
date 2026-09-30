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
| `loanable.dart` | Modèle unifié liste+détail avec prétraitement JSON pour `position`, communauté et image |
| `loanable_availability.dart` | Intervalle de disponibilité; parsing strict avec rejet des dates manquantes ou mal formées |
| `loanable_availability_window.dart` | Fenêtre combinée `available`+`unavailable` sur une période bornée |
| `loanable_availability_window.dart` | Tri des intervalles par `rawStart` pour rendu jour par jour |
| `loanable_image.dart` | Métadonnées d'image (id, filename, sizes) sans URL directe |
| `loanable_incident.dart` | Incident actif (`type`, `status`, `is_blocking`, `blocking_until`) |
| `loanables_page.dart` | Page paginée avec `hasMore`, `isLoadingMore` et `loadMoreError` |
| `vehicle_local_dates.dart` | Utilitaires de dates naïves (fuseau véhicule) : `formatYmd`, `shiftYmd`, `daysFrom`, `hhmm`, `dayOf`, `shortLabel` |

#### Couche données (`lib/features/loanables/data/`)

| Fichier | Rôle |
|---|---|
| `datasources/loanables_remote_data_source.dart` | `getLoanables` (paginé), `getLoanableDetails`, `getAvailability` avec `responseMode` |
| `repositories/loanables_repository_impl.dart` | Délégation directe vers le data source |

#### Présentation (`lib/features/loanables/presentation/`)

| Fichier | Rôle |
|---|---|
| `controllers/loanables_controller.dart` | `LoanablesListController` (pagination + loadMore), `loanableDetailProvider`, `LoanableAvailabilityPeriod`, `loanableAvailabilityWindowProvider`, `SelectedLoanableType`, `SelectedLoanableCommunity` |
| `screens/explore_screen.dart` | Liste filtrée (type + communauté), basculement liste/carte, états chargement/vide/erreur, sélection d'un marqueur ouvre la fiche |
| `screens/loanable_detail_screen.dart` | Galerie, caractéristiques, localisation (carte adaptative), incidents, instructions/conditions, calendrier de disponibilité par fenêtre de 7 jours, CTA désactivé vers Lot 3, porte d'éligibilité informative |
| `widgets/loanable_image_widget.dart` | Chargement d'image via `GET /images/{id}` authentifié, placeholder si absent |

#### Infrastructure (`lib/core/maps/`)

| Fichier | Rôle |
|---|---|
| `adaptive_map_widget.dart` | Carte Google Maps si coordonnées valides, liste de repli sinon; aucun marqueur pour véhicule sans lat/lng |
| `map_marker.dart` | Modèle de marqueur avec `id`, `lat`, `lng`, `label` |

#### Routeur (`lib/core/router/app_router.dart`)

Route `/loanables/:id` ajoutée dans le `ShellRoute`. Validation de l'`id` avec écran d'erreur dédié (`_InvalidLoanableIdScreen`) si le paramètre est absent ou non-entier.

#### Tests (`test/features/loanables/`)

| Fichier | Couverture |
|---|---|
| `loanables_remote_data_source_test.dart` | Pagination (liste, page 2, liste brute), détail (`data` et `loanable` wrappers), disponibilité (parsing, éléments invalides, réponse non-liste), filtres type et communauté |
| `loanable_mapping_test.dart` | Position (tableau, `position_google`, `latitude`/`longitude` directs, absence), communauté depuis `library`, image URL, `isAvailable` pour tous les statuts connus |
| `explore_screen_test.dart` | Chargement, vide, erreur, liste de véhicules, filtre type, basculement carte/liste |
| `loanable_detail_screen_test.dart` | Fiche sans photo, sans position, incident, indisponibilité, navigation CTA désactivé |
| `vehicle_local_dates_test.dart` | `formatYmd`, `shiftYmd` (positif, négatif, traversée de mois/année), `hhmm`, `dayOf`, `shortLabel` |

#### Fixtures (`test/fixtures/loanables_fixtures.dart`)

- `laravelPaginatedLoanablesJson` : page 1/3, deux véhicules, champ `library` avec `community_id` imbriqué
- `laravelPaginatedLoanablesPage2Json` : dernière page (3/3), `links.next == null`
- `laravelLoanableDetailJson` : détail complet avec `position_google`, multi-images, incidents, `details`
- `laravelAvailabilityEventsJson` : trois événements dont un indisponible

---

### Décisions d'implémentation

**Modèle unique liste/détail.** Le parsing est fait dans `Loanable.fromJson` via `_preprocessJson`. Les champs absents dans la liste restent `null`; aucune valeur inventée. Un champ présent dans le détail mais absent de la liste ne provoque pas d'erreur.

**Carte adaptative.** `AdaptiveMapWidget` n'affiche un marqueur que si `latitude != null && longitude != null`. Aucun véhicule sans coordonnées ne brise la carte. Sur les plateformes non supportées (Linux, Windows sans plugin carte), une liste de repli est affichée.

**Fuseau du véhicule.** `VehicleLocalDates` opère exclusivement sur des chaînes `yyyy-MM-dd` et `Y-m-d H:i:s` naïves. L'arithmetic de décalage utilise `DateTime.utc` pour éviter tout effet DST de l'appareil. Aucune conversion vers le fuseau local n'est effectuée.

**Double appel de disponibilité.** `loanableAvailabilityWindowProvider` appelle simultanément `responseMode=available` et `responseMode=unavailable` avec `Future.wait`. Un créneau indisponible ne peut jamais apparaître comme disponible car les deux listes sont réconciliées à l'affichage.

**Filtres backend documentés.** Seuls `type` et `shared_in_community=<id>` sont envoyés au backend. Il n'existe pas de recherche texte ni de filtre `availability_mode` supporté par `Loanable::webQueryBuilder()`. Tout filtrage supplémentaire est local et borné à la page chargée.

**CTA Lot 3.** Le bouton « Faire une demande » est présent dans la fiche mais rendu `onPressed: null` (désactivé) avec une info-bulle explicative tant que le Lot 3 n'est pas livré. Aucun flux de réservation factice n'existe.

**Porte d'éligibilité.** `BorrowerEligibility.canRequest(loanableType, borrower)` du Lot 1 est appelé dans la fiche. Pour `car` et `car_trailer`, si le dossier n'est pas validé, un bandeau informatif s'affiche. Ce contrôle informe l'utilisateur; il ne se substitue pas à l'autorisation Laravel lors de `POST /loans`.

---

### Filtres backend effectivement disponibles

Vérifiés contre `Loanable::webQueryBuilder()` (backend Laravel existant) :

| Paramètre | Support |
|---|---|
| `type` | ✅ Supporté (`$filterTypes`) |
| `shared_in_community=<id>` | ✅ Supporté (scope dédié) |
| `name` (texte libre) | ✅ Supporté mais NON utilisé côté mobile; aucun champ de recherche exposé dans cette version |
| `sharing_mode` | ✅ Supporté mais NON utilisé côté mobile |
| `library_id` | ✅ Supporté mais non exposé (les communautés passent par `shared_in_community`) |
| Recherche plein texte | ❌ Absent du backend |
| Filtre par disponibilité | ❌ Absent du backend |
| Tri configurable | ❌ Absent du backend |

---

### Divergences et observations

- **Enveloppe de détail variable.** `GET /loanables/{id}` peut renvoyer le véhicule directement à la racine, sous `data`, ou sous `loanable`. Le data source gère les trois cas.
- **`library` sans `community_id`.** Certaines bibliothèques (environnement de test) n'exposent pas `community_id`. Le prétraitement tente aussi `community_ids[0]` comme repli.
- **`position_google` vs `position`.** Les deux formats co-existent dans les réponses réelles. `_preprocessJson` priorise le tableau `position`, puis `position_google`, puis `latitude`/`longitude` directs.
- **Dates de disponibilité sans fuseau.** Le backend retourne des chaînes naïves `Y-m-d H:i:s`. `DateTime.tryParse` utilisé avec remplacement de l'espace par `T` crée un `DateTime` local — son heure est donc correcte si l'affichage utilise `rawStart`/`rawEnd` directement (ce que fait `VehicleLocalDates.hhmm`), mais incorrecte si on utilise `.hour` de la `DateTime` parsée sur un appareil en fuseau différent. Les vues de disponibilité utilisent exclusivement les chaînes brutes.

---

### Limites restantes

- Aucune mise en cache locale des fiches ou de la disponibilité. Chaque ouverture d'écran déclenche une requête réseau.
- Le calendrier de disponibilité navigue par fenêtres de 7 jours; il n'existe pas de sélecteur de mois complet ni de vue condensée.
- La liste des communautés accessibles est chargée depuis `GET /communities` (feature `communities`); aucun filtrage backend des communautés auxquelles l'utilisateur appartient n'est encore appliqué au sélecteur de communauté.
- La recherche texte locale est hors périmètre; elle sera abordée dans un lot ultérieur si le besoin est confirmé.
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
