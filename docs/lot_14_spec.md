# Spécification Technique & Cadrage — Lot 14 (Indisponibilités exceptionnelles et récurrentes)

Ce document formalise l'architecture, l'analyse exhaustive du moteur de disponibilité existant (`AvailabilityHelper`), les contrats d'API backend et mobile, la gestion mathématique des intervalles et des fuseaux horaires, les règles de concurrence optimiste et de détection pré-enregistrement des conflits avec les prêts existants, l'architecture Flutter (Riverpod, GoRouter, widgets de gestion et de prévisualisation) et la matrice de tests pour le **Lot 14** du projet LocoMotion.

---

## 1. Mission & Périmètre du Lot 14

### 1.1 Mission du sous-agent
Permettre au propriétaire ou co-propriétaire d'un véhicule de configurer et gérer finement son calendrier d'indisponibilités (ponctuelles ou récurrentes) sans contourner ni impacter silencieusement les prêts déjà acceptés, en cours ou en attente d'approbation :
1. **Documenter rigoureusement le schéma existant** de règles de disponibilité (`availability_mode` et `availability_json`), ses postulats mathématiques et ses limites intrinsèques dans Laravel (`backend/app/Calendar/AvailabilityHelper.php`).
2. **Créer, modifier et supprimer des indisponibilités ponctuelles** (date unique ou intervalle multi-jours avec horaires spécifiques ou journée entière) avec un aperçu dynamique du créneau.
3. **Configurer des indisponibilités récurrentes hebdomadaires** (`weekdays` avec jours et créneau horaire) compatibles avec le moteur serveur.
4. **Détecter et afficher les réservations affectées en amont** de l'enregistrement via `GET /loanables/{id}/loans/unavailable` ; appliquer une politique ferme de **rejet strict des conflits** afin de garantir **qu'aucune annulation silencieuse** ne puisse survenir.
5. **Préserver scrupuleusement les règles existantes non éditables par cette UI** et prévenir l'écrasement concurrent via un contrôle de concurrence optimiste (`lock_version` / `If-Match` $\rightarrow$ `409 Conflict`).
6. **Vérifier la cohérence immédiate** de la recherche, des nouvelles réservations et des prolongations après sauvegarde via l'invalidation des providers Riverpod ciblés.

---

### 1.2 Périmètre inclus

1. **Analyse et respect du moteur de calcul (`AvailabilityHelper.php`)** :
   - Prise en compte de la dualité `availability_mode = "always"` (disponible par défaut, les règles définissent des *indisponibilités*) et `availability_mode = "never"` (indisponible par défaut, les règles définissent des *disponibilités*).
   - Prise en charge des 3 types de règles existants du backend :
     - `"dates"` : liste de dates explicites `["YYYY-MM-DD", ...]`.
     - `"dateRange"` : intervalle de dates défini par ses bornes `["YYYY-MM-DD", "YYYY-MM-DD"]` inclusives.
     - `"weekdays"` : récurrence hebdomadaire sur un ensemble de jours `["MO", "TU", "WE", "TH", "FR", "SA", "SU"]`.
   - Respect strict du format horaire `period` (`"HH:MM-HH:MM"`), de la convention d'intervalle demi-ouvert `[start, end)` et des cas limites :
     - Fin de journée `23:59` ou `24:00` ramenée à `24:00:00` (qui translate vers `00:00:00` du jour suivant via Carbon).
     - Expression de journée entière `"00:00-00:00"` normalisée en `"00:00-24:00"`.
   - Préservation de toutes les règles non gérées ou complexes déjà présentes dans le JSON du véhicule.
   - En mode `never`, affichage en lecture seule explicite avec avertissement produit, car le moteur Laravel ne supporte pas la soustraction d'indisponibilité sur une règle d'inclusion positive sans altérer la définition originelle de l'inclusion.

2. **Détection préventive des conflits & Rejet strict (`GET /loanables/{id}/loans/unavailable`)** :
   - Avant toute sauvegarde, soumission de la nouvelle configuration (`availability_mode` + `availability_json`) à l'API serveur.
   - Restitution des prêts futurs ou en cours qui entreraient en collision avec la nouvelle indisponibilité.
   - **Politique de non-annulation absolue** : rejet de l'enregistrement côté client (bouton désactivé avec message bloquant) et contrôle de garde côté serveur dans `LoanableController@update` pour éviter les courses critiques (*race conditions*) lors de réservations concurrentes.

3. **Protection contre l'écrasement concurrent (`If-Match` / `lock_version`)** :
   - Envoi de la version courante (`lock_version = updated_at`) lors du `PUT /api/v1/loanables/{id}`.
   - Rejet `409 Conflict` si le calendrier ou le véhicule a été modifié en parallèle (par exemple sur l'interface web ou par un co-propriétaire), avec rechargement automatique de l'état frais.

4. **Interface Mobile de Gestion du Calendrier (`VehicleAvailabilityScreen`)** :
   - Écran dédié accessible depuis la fiche de gestion de flotte [`OwnerVehicleDetailScreen`](file:///Users/fabapps/Documents/Dev/locomotion/mobile/lib/features/fleet/presentation/screens/owner_vehicle_detail_screen.dart).
   - Deux onglets/sections :
     1. *Indisponibilités ponctuelles* (cartes détaillées avec dates, horaires, statut, bouton modifier et supprimer).
     2. *Indisponibilités récurrentes* (jours de la semaine, horaires, bouton modifier et supprimer).
   - Formulaire modal d'ajout / modification d'indisponibilité avec :
     - Choix du type (Ponctuelle vs Récurrente hebdomadaire).
     - Sélecteur de date (unique ou intervalle multi-jours).
     - Choix : Toute la journée vs Créneau horaire spécifique.
     - Contrôle des conflits en direct et affichage des prêts affectés le cas échéant.
   - Prévisualisation du calendrier synchronisée avec le backend (`GET /loanables/availability`).

5. **Cohérence d'état & Invalidation Riverpod** :
   - Invalidation immédiate de `fleetVehicleDetailProvider(id)`, `loanableDetailProvider(id)`, `loanableAvailabilityPeriodProvider(id)`, `loanableAvailabilityWindowProvider(id, ...)` et `loanablesListControllerProvider`.

---

### 1.3 Hors périmètre
- Moteur complet de règles iCalendar RFC 5545 (RRULE universel avec exclusions EXDATE, fréquences mensuelles, annuelles, énumération nième jour du mois, etc.).
- Synchronisation bidirectionnelle avec des calendriers externes (Google Calendar, Apple Calendar, CalDAV, ICS).
- Remplacement du moteur de calendrier Laravel existant (`AvailabilityHelper` et `DateIntervalHelper`).

---

## 2. Analyse Approfondie du Moteur Existant (`AvailabilityHelper`)

### 2.1 Schéma et Définition des Règles

Dans LocoMotion, la disponibilité d'un véhicule repose sur deux colonnes de la table `loanables` :
1. `availability_mode` : chaîne valant soit `'always'`, soit `'never'`.
2. `availability_json` : chaîne JSON contenant un tableau d'objets (règles).

```json
[
  {
    "id": "b3e945c1-7d12-4f3a-9e12-881c9e88d123",
    "type": "dates",
    "scope": ["2026-10-15", "2026-10-16"],
    "period": "14:00-18:00",
    "available": false
  },
  {
    "id": "e4f8812a-3b56-4c91-8172-1188339944bb",
    "type": "weekdays",
    "scope": ["SA", "SU"],
    "period": "00:00-24:00",
    "available": false
  }
]
```

#### Les 3 types de règles supportés

| Type | Champ `scope` | Champ `period` (optionnel) | Interprétation |
|---|---|---|---|
| `"dates"` | Tableau de chaînes de dates `["YYYY-MM-DD", ...]` | `"HH:MM-HH:MM"` (défaut `"00:00-24:00"`) | Génère un intervalle pour chaque date du tableau avec les heures définies. |
| `"dateRange"` | Tableau de 2 dates `["YYYY-MM-DD", "YYYY-MM-DD"]` (début et fin inclusifs) | `"HH:MM-HH:MM"` (défaut `"00:00-24:00"`) | Génère un intervalle **pour chaque jour** du range. |
| `"weekdays"` | Tableau de codes de jours ISO : `["MO", "TU", "WE", "TH", "FR", "SA", "SU"]` | `"HH:MM-HH:MM"` (défaut `"00:00-24:00"`) | Génère un intervalle pour chaque jour correspondant dans le contexte temporel évalué. |

---

### 2.2 Comportement Mathématique & Limites Techniques

1. **Dualité Inversée (`AvailabilityHelper::getAvailability`)** :
   ```php
   $intervals = self::getScheduleIntervals($availabilityParams, $context, $timezone);
   if ($availabilityParams["available"]) {
       // Si mode "always", les règles représentent des INDISPONIBILITÉS -> inversion
       return DateIntervalHelper::invert($context, $intervals);
   }
   return $intervals; // Si mode "never", les règles représentent des DISPONIBILITÉS
   ```
   - **Conséquence majeure** : En mode `"always"`, toute règle ajoutée soustrait du temps de disponibilité. En mode `"never"`, toute règle ajoutée ajoute du temps de disponibilité.
   - **Impossibilité de soustraction partielle en mode `"never"`** : Si un véhicule est configuré en mode `"never"` avec une règle `weekdays` (ex: ouvert du lundi au vendredi de 08:00 à 18:00), on ne peut pas simplement ajouter une règle `dates` pour dire "fermé le vendredi 13", car toutes les règles sont fusionnées (`array_merge`) et unifiées (`simplify`). L'ajout d'une règle en mode `"never"` ajouterait du temps au lieu d'en retrancher.
   - **Décision d'architecture** : L'interface mobile permet la gestion complète des indisponibilités lorsque le véhicule est en mode `"always"` (mode standard de la majorité du parc). Si un véhicule est en mode `"never"` avec des règles complexes, l'application mobile affiche un bandeau explicatif et passe le calendrier en mode consultation/lecture seule pour éviter toute altération destructrice de la configuration web.

2. **Fuseaux Horaires & Changements d'Heure (DST)** :
   - Les règles ne stockent pas de fuseau horaire en interne : elles sont interprétées dans le fuseau du véhicule (`$loanable->timezone`, ex: `America/Toronto` ou `Europe/Paris`).
   - Le parsing utilise `CarbonImmutable($dateStr, $timezone)->setTime(h, m, s)` : lors du passage à l'heure d'été ou d'hiver, Carbon gère nativement le décalage UTC sans dérive d'horloge.
   - Minuit est géré rigoureusement : `24:00` devient `00:00` du lendemain selon la convention demi-ouverte `[start, end)`.

3. **Absence d'ordre de priorité ou d'exceptions récursives** :
   - Toutes les règles d'un même véhicule ont un poids équivalent ; il n'y a pas de hiérarchie intrinsèque entre `weekdays` et `dates`.

4. **Horizon Temporel des Récurrences (`weekdays`)** :
   - Le schéma backend pour les règles `weekdays` ne prend pas en charge de date d'expiration (`until`) ni de compteur maximal (`count`) au sens iCalendar RFC 5545.
   - Par conséquent, toute règle `weekdays` configurée s'applique **perpétuellement** sur l'ensemble de la fenêtre temporelle évaluée par le moteur de disponibilité (`AvailabilityHelper`).
   - L'horizon de la récurrence est donc infini tant que la règle est présente dans `availability_json`. Pour limiter une indisponibilité dans le temps, le propriétaire doit utiliser des règles ponctuelles (`dates` ou bloc continu `dates`/`dateRange`) ou supprimer manuellement la récurrence lorsqu'elle n'est plus d'actualité.

5. **Gestion des Exceptions sur les Récurrences** :
   - En mode `"always"`, le moteur Laravel calcule l'indisponibilité par union d'intervalles (`simplify`). Il n'existe pas d'opérateur d'exclusion ponctuelle (`EXDATE`) permettant d'annuler une récurrence pour une journée donnée sans altérer la règle récurrente globale.
   - Si un propriétaire souhaite être disponible de manière exceptionnelle un jour normalement couvert par une récurrence hebdomadaire (ex: exceptionnellement disponible un mardi), le moteur actuel ne permet pas d'ajouter une règle "disponible" par-dessus une récurrence en mode `"always"`.
   - L'application mobile expose donc la récurrence comme une règle globale indivisible.

6. **Suppression d'Occurrence vs Suppression de Série** :
   - Chaque occurrence d'une règle récurrente n'a pas d'existence propre en base de données : seule la règle `weekdays` générique (`["MO", "WE"]`) est stockée dans le JSON.
   - Toute suppression effectuée depuis l'application mobile supprime **la règle récurrente entière** (la série complète).
   - Une suppression d'occurrence isolée exigerait une refonte du moteur serveur pour introduire des listes d'exceptions ou une matérialisation des occurrences.

7. **Décomposition Technique des Blocs Continus avec Horaires Partiels (`createContinuousBlock`)** :
   - Problème : dans `AvailabilityHelper`, une règle `dateRange` avec des horaires (ex: `14:00-11:00` ou `14:00-18:00`) est appliquée **quotidiennement à chaque jour** de l'intervalle et non sous la forme d'un bloc continu d'un jour A à une heure H1 jusqu'au jour B à une heure H2.
   - Solution d'architecture retenue : l'application mobile décompose automatiquement tout bloc multi-jours à horaires partiels via `AvailabilityRule.createContinuousBlock` :
     - **Jour 1 (départ partiel)** : règle `type: 'dates'`, `scope: [startDate]`, `period: "${startTime}-24:00"`, `group_role: 'start'`.
     - **Jours intermédiaires (journées pleines)** : règle `type: 'dateRange'`, `scope: [startDate + 1, endDate - 1]`, `period: "00:00-24:00"`, `group_role: 'middle'`.
     - **Dernier Jour (retour partiel)** : règle `type: 'dates'`, `scope: [endDate]`, `period: "00:00-${endTime}"`, `group_role: 'end'`.
     - Chaque tranche est rattachée par un même `group_id` UUID dans ses métadonnées.
     - Côté serveur Laravel, comme l'extrémité de chaque tranche correspond exactement à minuit (`24:00:00` $\equiv$ `00:00:00` du jour suivant), l'algorithme `DateIntervalHelper::simplify` fusionne mathématiquement ces tranches contiguës en **un seul et unique intervalle continu**.
     - Côté client mobile, les règles d'un même `group_id` sont regroupées et présentées comme un bloc unique dans l'UI (`AvailabilityConfig.punctualRules`), et leur suppression est atomique via `deleteRule(id, groupId: groupId)`.

---

## 3. Architecture des Contrats d'API & Endpoints Backend

### 3.1 Endpoints Existants Utilisés

#### 1. Lecture de la disponibilité réelle
```http
GET /api/v1/loanables/{id}/availability?start=2026-10-01 00:00:00&end=2026-11-01 00:00:00&responseMode=available
```
- Authentification : `auth:api`
- Calcule la disponibilité nette (règles de calendrier + soustraction des prêts existants + soustraction des incidents bloquants).
- Retourne les intervalles `[{ start, end, data: { available: true }, type: "availability" }]`.

#### 2. Prévisualisation dynamique des règles (avant sauvegarde)
```http
GET /api/v1/loanables/availability?start=2026-10-01 00:00:00&end=2026-11-01 00:00:00&responseMode=available&availability_mode=always&availability_json=[...]&timezone=America/Toronto
```
- Endpoint public/authentifié routé vers `LoanableController@genericAvailability`.
- Permet à l'application mobile de vérifier le rendu exact côté serveur des règles en cours d'édition avant toute validation.

#### 3. Détection des prêts affectés en conflit
```http
GET /api/v1/loanables/{id}/loans/unavailable?availability_mode=always&availability_json=[...]
```
- Endpoint sécurisé routé vers `LoanableController@loansDuringUnavailabilities`.
- Détecte l'ensemble des réservations futures ou actives dont l'intervalle `[departure_at, actual_return_at)` se retrouve dans une plage indisponible selon les nouvelles règles.
- Retourne une collection `DashboardLoanResource` avec `id`, `departure_at`, `return_at`, `status`, `borrowerUser.name`.

#### 4. Sauvegarde protégée des disponibilités (`LoanableController@update`)
```http
PUT /api/v1/loanables/{id}
Content-Type: application/json
If-Match: "2026-10-03T22:30:00.000000Z"
```
```json
{
  "availability_mode": "always",
  "availability_json": "[{\"id\":\"...\",\"type\":\"dates\",\"scope\":[\"2026-10-20\"],\"period\":\"14:00-18:00\"}]",
  "lock_version": "2026-10-03T22:30:00.000000Z"
}
```
- **Concurrence & Transaction Pessimiste** :
  - L'opération s'exécute intégralement au sein d'une transaction de base de données (`DB::transaction`).
  - Le véhicule cible est verrouillé explicitement via un verrou exclusif pessimiste (`Loanable::where('id', $loanable->id)->lockForUpdate()->first()`).
  - La version de verrouillage optimiste (`If-Match` ou `lock_version` vs `updated_at`) est revérifiée **sous ce verrou exclusif** $\rightarrow$ `409 Conflict` en cas de désynchronisation.
- **Contrôle Pré-Écriture & Préservation des Détails** :
  - Le contrôle des conflits de disponibilité est exécuté **avant toute écriture en base de données** et avant la suppression éventuelle des détails du véhicule (`$loanable->details?->delete()`) en cas de changement simultané de type de véhicule. Ainsi, un rejet `422` n'altère en aucun cas l'intégrité du véhicule.
- **Détection Exhaustive des Réservations Actives** :
  - Le filtre des réservations protégées couvre tous les prêts aux statuts `Ongoing`, `Accepted`, `Confirmed`, `Requested` qui sont soit futurs, soit en cours :
    `(departure_at > now() OR actual_return_at > now())`.
    Ceci garantit qu'un prêt accepté dont l'heure de départ est passée mais dont la fin de location est future ne peut en aucun cas être recouvert par une indisponibilité.
- **Rejet Strict Inconditionnel (Suppression du contournement `allow_conflicts`)** :
  - Tout conflit détecté sous le verrou retourne immédiatement `422 Unprocessable Entity` avec le tableau `conflicts`.
  - Aucun paramètre de contournement (`allow_conflicts=true`) n'est toléré : la politique de non-annulation absolue s'applique universellement.

---

## 4. Politique de Traitement des Conflits & Garantie de Non-Annulation

### 4.1 Politique Produit Arrêtée : Rejet Strict
- **Aucune annulation automatique ou silencieuse** : Une indisponibilité propriétaire ne doit en aucun cas annuler, tronquer ou invalider un prêt déjà accordé à un emprunteur.
- **Workflow de détection et d'aperçu dynamique mobile** :
  1. Lors de la saisie d'une règle (date, créneau horaire, récurrence), le formulaire modal `AvailabilityRuleFormSheet` déclenche automatiquement et en temps réel :
     - `GET /loanables/{id}/loans/unavailable` pour détecter les réservations impactées.
     - `GET /loanables/availability` (avec `responseMode=available` et la configuration candidate) pour afficher le rendu net calculé par le moteur Laravel.
  2. **Protection contre les courses critiques asynchrones** :
     - Chaque requête de contrôle est taguée d'un identifiant monotone `_conflictCheckRequestId`. Si l'utilisateur tape ou change rapidement les paramètres, toute réponse réseau obsolète est silencieusement ignorée, empêchant l'affichage d'un conflit désynchronisé.
  3. **Protection contre la réentrance des mutations** :
     - Durant la soumission (`isSubmitting == true`), les boutons d'action sont désactivés et le contrôleur `VehicleAvailabilityNotifier` rejette immédiatement tout second appel réentrant.
  4. Si des prêts sont en conflit :
     - Une bannière d'alerte rouge/orange s'affiche immédiatement.
     - La liste détaillée des prêts affectés est présentée (nom de l'emprunteur, dates et heures, statut).
     - Le bouton *"Enregistrer"* est désactivé avec le libellé explicite : *"Impossible d'enregistrer : créneau en conflit avec X réservation(s)"*.
     - Le propriétaire est invité à modifier son créneau d'indisponibilité ou à contacter l'emprunteur pour convenir d'un arrangement préalable.
  5. Si aucun conflit n'est détecté :
     - Le bouton d'enregistrement est activé et l'aperçu du calcul serveur est affiché (`X créneau(x) calculé(s)`).

---

## 5. Architecture Mobile (Flutter / Riverpod)

### 5.1 Découpage des Fichiers

```
mobile/
├── lib/
│   ├── core/
│   │   └── router/
│   │       ├── routes.dart                     # Ajout de AppRoutes.fleetAvailability(id)
│   │       └── app_router.dart                 # Route /fleet/:id/availability -> VehicleAvailabilityScreen
│   └── features/
│       ├── availability/
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── availability_rule.dart           # Modèle immuable Freezed pour une règle
│       │   │   │   ├── availability_rule.freezed.dart
│       │   │   │   ├── availability_rule.g.dart
│       │   │   │   └── conflicting_loan.dart            # Modèle pour un prêt en conflit
│       │   │   └── repositories/
│       │   │       └── availability_repository.dart     # Interface du repository
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── availability_remote_data_source.dart # Appels HTTP Dio (loans/unavailable, preview, update)
│       │   │   └── repositories/
│       │   │       └── availability_repository_impl.dart    # Implémentation repository
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   ├── vehicle_availability_controller.dart # Notifier gérant la liste des règles et mutations
│       │       │   └── vehicle_availability_controller.g.dart
│       │       ├── screens/
│       │       │   └── vehicle_availability_screen.dart     # Écran principal de gestion du calendrier
│       │       └── widgets/
│       │           ├── availability_rule_card.dart          # Carte de présentation d'une règle (ponctuelle ou récurrente)
│       │           ├── availability_rule_form_sheet.dart    # Modal d'ajout / édition de règle
│       │           ├── conflicting_loans_sheet.dart         # Liste des conflits détectés
│       │           └── availability_calendar_preview.dart   # Visualisation graphique du mois/semaine
```

### 5.2 Modèle de Données `AvailabilityRule`

```dart
@freezed
abstract class AvailabilityRule with _$AvailabilityRule {
  const AvailabilityRule._();

  const factory AvailabilityRule({
    required String id,
    required String type, // 'dates', 'dateRange', 'weekdays'
    @Default([]) List<String> scope,
    @Default('00:00-24:00') String period,
    @Default(false) bool available,
    String? title,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isCustomServerRule,
  }) = _AvailabilityRule;

  factory AvailabilityRule.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityRuleFromJson(json);

  bool get isAllDay => period == '00:00-24:00';
  bool get isPunctual => type == 'dates' || type == 'dateRange';
  bool get isRecurringWeekly => type == 'weekdays';
}
```

### 5.3 Préservation des Règles Non Éditables & Batches Multi-Dates
Lors de la lecture du JSON `loanable.availability_json` :
- Chaque règle parsée qui correspond aux critères de l'UI mobile (dates unique, bloc continu groupé ou weekdays standards) est mappée en `AvailabilityRule`.
- Toute règle exotique, complexe ou non supportée est marquée `isCustomServerRule: true`.
- **Règles multi-dates existantes (`type == 'dates'` avec `scope.length > 1`)** :
  - Historiquement générées via l'interface web administrative.
  - L'application mobile les marque comme non éditables (`isMultiDatesBatch = true`, `isEditableInApp = false`) avec un badge explicatif *"Géré via le web (multi-dates)"*.
  - Le bouton d'édition est masqué dans l'UI pour éliminer tout risque d'écrasement ou de troncature accidentelle des dates associées.
  - Si la configuration globale est sauvegardée, l'intégralité du tableau `scope` de ces règles est rigoureusement préservée.
- Lors de la ré-écriture et sauvegarde, les règles `isCustomServerRule` et les règles multi-dates sont **intégralement réinjectées sans modification**, prévenant tout écrasement accidentel.

---

## 6. Invalidation des Providers & Cohérence d'État

Après toute modification réussie d'une indisponibilité (`save` / `delete`) :
1. `ref.invalidate(fleetVehicleDetailProvider(vehicleId))` : recharge les détails du véhicule dans l'espace flotte.
2. `ref.invalidate(ownerFleetControllerProvider)` : rafraîchit la liste des véhicules de la flotte.
3. `ref.invalidate(loanableDetailProvider(vehicleId))` : rafraîchit la fiche d'exploration et les compteurs.
4. `ref.invalidate(loanableAvailabilityPeriodProvider(vehicleId))` : force le rechargement de la période de disponibilité.
5. `ref.invalidate(loanableAvailabilityWindowProvider)` : force le recalcul des fenêtres de disponibilité affichées par les vues emprunteur et propriétaire déjà montées.
6. Invalidation de `loanablesListControllerProvider` : ré-évalue les véhicules disponibles pour les recherches emprunteurs.

---

## 7. Matrice de Tests & Critères d'Acceptation

### 7.1 Backend (Laravel / PHPUnit)
Fichier cible : [`backend/tests/Integration/Calendar/LoanableAvailabilityManagementTest.php`](file:///Users/fabapps/Documents/Dev/locomotion/backend/tests/Integration/Calendar/LoanableAvailabilityManagementTest.php)

| ID Test | Description | Condition de succès |
|---|---|---|
| `TEST-BK-01` | Sauvegarde d'une indisponibilité ponctuelle (`dates`) | La règle est stockée dans `availability_json`, l'endpoint `/availability` retourne le créneau indisponible. |
| `TEST-BK-02` | Sauvegarde d'un intervalle multi-jours (`dateRange` et tranches journalières) | Les créneaux contigus à minuit se simplifient sans faille en un bloc continu. |
| `TEST-BK-03` | Sauvegarde d'une indisponibilité récurrente (`weekdays`) | Les jours spécifiés sont exclus sur toute la période d'évaluation. |
| `TEST-BK-04` | Détection de conflit avec prêt actif ou futur via `/loans/unavailable` | L'endpoint retourne le prêt en conflit et ses métadonnées. |
| `TEST-BK-05` | Rejet serveur strict lors d'une tentative de mise à jour conflictuelle | `PUT /loanables/{id}` retourne `422` ou bloque la sauvegarde sans annuler le prêt. |
| `TEST-BK-06` | Concurrence optimiste sous verrou pessimiste (`lockForUpdate` + `lock_version`) | `PUT /loanables/{id}` retourne `409 Conflict` si la version est désynchronisée sous le verrou. |
| `TEST-BK-07` | Préservation des règles tierces lors d'une mise à jour partielle | Les règles inconnues de l'UI sont conservées intactes dans `availability_json`. |
| `TEST-BK-08` | Transitions minuit et convention demi-ouverte `[start, end)` | Aucun chevauchement erroné à `00:00` ou `24:00`. |
| `TEST-BK-09` | Rejet strict même avec le flag `allow_conflicts=true` | Le serveur refuse l'enregistrement avec `422` et ne permet aucun contournement. |
| `TEST-BK-10` | Prêt accepté parti dans le passé et se terminant dans le futur | Le prêt est détecté comme conflit bloquant (`actual_return_at > now()`). |
| `TEST-BK-11` | Préservation des détails du véhicule lors d'un rejet 422 | En cas de changement de type avec calendrier conflictuel, les détails ne sont pas supprimés. |

### 7.2 Mobile (Flutter / Widget & Unit Tests)
Fichiers cibles :
- `test/features/availability/availability_rule_test.dart`
- `test/features/availability/vehicle_availability_screen_test.dart`

| ID Test | Description | Condition de succès |
|---|---|---|
| `TEST-MB-01` | Parsing et sérialisation des règles (`dates`, `dateRange`, `weekdays`) | Transformation bidirectionnelle exacte avec préservation des IDs et attributs bruts. |
| `TEST-MB-02` | Affichage des listes ponctuelles et récurrentes | Les cartes présentent clairement les dates, horaires et récurrences. |
| `TEST-MB-03` | Détection et affichage des conflits dans le formulaire | La liste des prêts affectés s'affiche en alerte et le bouton d'enregistrement se désactive. |
| `TEST-MB-04` | Ajout et suppression d'une indisponibilité sans conflit | Appel correct à l'API et mise à jour de la vue. |
| `TEST-MB-05` | Gestion du conflit 409 et rechargement de l'état frais | Un snackbar d'avertissement s'affiche et les données sont actualisées. |
| `TEST-MB-06` | Véhicule en mode `never` : affichage lecture seule explicite | Un bandeau d'avertissement informe l'utilisateur et bloque l'édition directe. |
| `TEST-MB-07` | Invalidation de tous les providers Riverpod associés | `loanableAvailabilityWindowProvider` et les providers associés sont ré-invoqués. |
| `TEST-MB-08` | Préservation des règles multi-dates web | Marqué non éditable dans l'UI, affichage du badge sans bouton modifier. |
| `TEST-MB-09` | Décomposition en bloc continu (`createContinuousBlock`) | Génération des tranches Jour 1, Jours intermédiaires et Dernier jour avec `group_id`. |
| `TEST-MB-10` | Aperçu calendrier : chevauchement complet et fin de mois exclusive | Les jours intermédiaires d'un bloc sont coloriés et le dernier jour du mois est inclus. |
| `TEST-MB-11` | Protection anti-réentrance et tokens de requêtes obsolètes | Rejet des mutations concurrentes et filtrage par `requestId`. |

---

## 8. Validation & Prochaines Étapes

Ce document est prêt pour soumission à validation. Une fois validé :
1. Implémentation des tests d'intégration backend et des renforcements de contrôle dans `LoanableController`.
2. Implémentation des entités, repositories, controllers et écrans Flutter pour l'espace de gestion du calendrier.
3. Exécution complète des suites `artisan test` et `flutter test`.
