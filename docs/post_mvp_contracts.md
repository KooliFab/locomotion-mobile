# LocoMotion — Spécification des Contrats d'API Post-MVP (`post_mvp_contracts.md`)

Ce document formalise les contrats d'API nécessaires pour le cycle post-MVP de LocoMotion (Lots 9 à 15), élaborés et validés dans le cadre du **Lot 8 (Contrats post-MVP et socle serveur)**.

---

## 1. Principes & Conventions Générales

### 1.1 Protocole et Sécurité
* **Base URL** : `/api/v1`
* **Authentification** : `Authorization: Bearer <oauth_token>` (Laravel Passport).
* **Idempotence** : Pour toutes les mutations financières et créations d'état des lieux, le client mobile DOIT envoyer un en-tête `Idempotency-Key: <uuid-v4>`.
* **Zero PII & Secret Redaction** : Aucune donnée bancaire brute (numéro PAN, CVV) ne transite par les serveurs LocoMotion. Toutes les données cartes sont traitées directement par Stripe via SetupIntent ou PaymentIntent.
* **Format des montants** :
  * Dans les contrats d'API et Stripe : **entier en cents** (`integer cents`, ex: `2500` pour 25,00 $ CAD).
  * Dans la facture et affichage : devise **CAD** ($ CA), arrondi à 2 décimales.
  * Taxes : TPS (5,0 %) et TVQ (9,975 %) calculées et identifiées distinctement.

### 1.2 Format Standard des Réponses d'Erreur (RFC 7807 / Laravel)
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "mileage_start": ["Le kilométrage de départ est obligatoire pour un véhicule motorisé."]
  },
  "error_code": "VALIDATION_FAILED"
}
```

---

## 2. Contrats Financiers & Caution Stripe (Lots 9 & 11)

### 2.1 Initialisation du Prépaiement & Caution Stripe
* **Méthode** : `POST`
* **Route** : `/loans/{loan}/payment-intent`
* **Policy** : `LoanPolicy@prepay` (Emprunteur ou Admin du prêt).
* **Statut du prêt requis** : `accepted` (ou `ongoing` en cas de re-prépaiement post-extension).

#### Request Headers
```http
Authorization: Bearer <token>
Idempotency-Key: 7b83f3e1-89dc-4c8d-b7c1-54129b8c9d21
Content-Type: application/json
```

#### Request Payload
```json
{
  "platform_tip_cents": 200,
  "use_balance_if_available": true
}
```

#### Response (200 OK)
```json
{
  "data": {
    "loan_id": 42,
    "currency": "CAD",
    "financial_breakdown": {
      "mandatory_contribution_cents": 3450,
      "estimated_distance_cents": 1200,
      "estimated_duration_cents": 1800,
      "taxes_tps_cents": 173,
      "taxes_tvq_cents": 344,
      "platform_tip_cents": 200,
      "total_estimated_contribution_cents": 3650,
      "user_balance_applied_cents": 1000,
      "remaining_contribution_to_pay_cents": 2650,
      "security_deposit_cents": 25000
    },
    "requires_stripe_action": true,
    "stripe": {
      "customer_id": "cus_N123abc456",
      "ephemeral_key_secret": "ek_test_987654321",
      "contribution_payment_intent_client_secret": "pi_3MtwLw2eZvKYlo2C0VvsmQry_secret_xyz",
      "deposit_payment_intent_client_secret": "pi_3MtwLw2eZvKYlo2C0VvsmDep_secret_abc",
      "publishable_key": "pk_test_locomotion_demo"
    }
  }
}
```

#### Règles d'Exécution & Souveraineté du Solde
1. Si le solde utilisateur couvre 100 % de la contribution obligatoire (`user_balance_applied_cents == total_estimated_contribution_cents`) et qu'aucune caution n'est requise (ex: vélo ou remorque), `requires_stripe_action` vaut `false`, aucun PaymentIntent n'est créé et le prêt est confirmé immédiatement.
2. Si une caution est requise (véhicule automobile), le `deposit_payment_intent` est créé avec `capture_method: "manual"` (autorisation hold sans encaissement).
3. Le PaymentIntent de caution a une durée de validité stricte de **7 jours** dans Stripe. Pour les réservations à plus de 7 jours, l'empreinte n'est demandée que 24 heures avant le départ (notification push de rappel).

#### Codes d'Erreur
* `403 Forbidden` : Utilisateur non autorisé ou solde insuffisant sans moyen de paiement.
* `409 Conflict` : Conflit de statut (prêt déjà confirmé ou annulé).
* `422 Unprocessable Entity` : Pourboire négatif ou montant erroné.

---

### 2.2 Confirmation de Prépaiement & Capture de Caution
* **Méthode** : `PUT`
* **Route** : `/loans/{loan}/prepay`
* **Policy** : `LoanPolicy@prepay`
* **Transitions de Statut** : `accepted` ➔ `confirmed` (ou `ongoing` si `departure_at` est déjà passé).

#### Request Payload
```json
{
  "stripe_contribution_payment_intent_id": "pi_3MtwLw2eZvKYlo2C0VvsmQry",
  "stripe_deposit_payment_intent_id": "pi_3MtwLw2eZvKYlo2C0VvsmDep"
}
```

#### Response (200 OK)
```json
{
  "data": {
    "id": 42,
    "status": "confirmed",
    "prepaid_at": "2026-10-01T14:30:00Z",
    "deposit_status": "authorized",
    "deposit_authorized_cents": 25000,
    "deposit_expires_at": "2026-10-08T14:30:00Z"
  }
}
```

#### Événements Émis
* `LoanPrepaidEvent($loan)`
* `PushNotificationEvent` vers le propriétaire : « La réservation #42 a été confirmée (caution et prépaiement validés). »

---

### 2.3 Règlement Final & Clôture (Settle)
* **Méthode** : `POST`
* **Route** : `/loans/{loan}/settle`
* **Policy** : `LoanPolicy@pay` (Emprunteur, Propriétaire ou Admin).
* **Statut requis** : `ended` ou `validated`.

#### Request Payload
```json
{
  "release_deposit": true,
  "incident_claim_cents": 0
}
```

#### Response (200 OK)
```json
{
  "data": {
    "id": 42,
    "status": "completed",
    "paid_at": "2026-10-01T18:45:00Z",
    "invoice": {
      "id": 108,
      "total_cents": 4125,
      "taxes_tps_cents": 196,
      "taxes_tvq_cents": 391,
      "user_balance_debited_cents": 1000,
      "stripe_captured_cents": 3125,
      "deposit_released": true,
      "deposit_released_at": "2026-10-01T18:45:01Z"
    }
  }
}
```

#### Idempotence & Anti-Double Débit
* La méthode vérifie atomiquement si `paid_at` est déjà renseigné. Si oui, elle renvoie la facture existante avec code 200 sans exécuter de double prélèvement Stripe.
* La caution est automatiquement libérée via `PaymentIntent::cancel()` si aucun sinistre n'est rattaché.

---

## 3. Contrats État des Lieux & Inspections Départ/Retour (Lots 10 & 11)

### 3.1 Soumission de l'État des Lieux Départ
* **Méthode** : `POST`
* **Route** : `/loans/{loan}/inspections/departure`
* **Policy** : `LoanPolicy@updateLoanInfo`
* **Statut requis** : `confirmed` ou `ongoing`.

#### Request Payload
```json
{
  "odometer_km": 124500,
  "fuel_battery_level_percent": 85,
  "cleanliness_rating": 4,
  "checklist": {
    "key_present": true,
    "insurance_paper_present": true,
    "charging_cable_present": true,
    "spare_wheel_present": true
  },
  "photos": [
    { "field": "front", "image_id": 501 },
    { "field": "back", "image_id": 502 },
    { "field": "left_side", "image_id": 503 },
    { "field": "right_side", "image_id": 504 },
    { "field": "dashboard_odometer", "image_id": 505 }
  ],
  "existing_damages_notes": "Légère rayure sur le pare-choc arrière droit constatée.",
  "signature": {
    "raw_svg_or_png_image_id": 506,
    "signer_full_name": "Fabien Emprunteur",
    "signed_at": "2026-10-01T09:05:00Z",
    "client_data_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  }
}
```

#### Règles Métier & Véhicules sans Compteur
* Si le véhicule est un vélo ou une remorque (`loanable.requires_mileage == false`) :
  * `odometer_km` et `dashboard_odometer` sont **optionnels** (ou ignorés).
  * `checklist.key_present` ou antivol est adapté.
* Les `image_id` soumis DOIVENT appartenir à l'utilisateur courant (téléversés dans son espace temporaire `images/tmp/{userId}/`). Le backend rejette tout ID d'image appartenant à un autre utilisateur par un `403 Forbidden`.

#### Response (201 Created)
```json
{
  "data": {
    "loan_id": 42,
    "inspection_type": "departure",
    "odometer_km": 124500,
    "fuel_battery_level_percent": 85,
    "status": "validated_by_borrower",
    "sealed_hash": "a4f89d31b2c45e89104fae56bc0182390a19f2e347c617b019da4c01f893450a",
    "created_at": "2026-10-01T09:05:01Z",
    "loan_status": "ongoing"
  }
}
```

---

### 3.2 Soumission de l'État des Lieux Retour
* **Méthode** : `POST`
* **Route** : `/loans/{loan}/inspections/return`
* **Policy** : `LoanPolicy@validateLoanInfo`
* **Statut requis** : `ongoing` ou `ended`.

#### Request Payload
```json
{
  "odometer_km": 124585,
  "fuel_battery_level_percent": 80,
  "cleanliness_rating": 4,
  "checklist": {
    "key_returned": true,
    "charging_cable_returned": true,
    "lock_closed": true
  },
  "photos": [
    { "field": "front", "image_id": 510 },
    { "field": "back", "image_id": 511 },
    { "field": "left_side", "image_id": 512 },
    { "field": "right_side", "image_id": 513 },
    { "field": "dashboard_odometer", "image_id": 514 }
  ],
  "new_damages_declared": false,
  "comments": "Restitution effectuée dans la cour, véhicule propre et verrouillé.",
  "signature": {
    "raw_svg_or_png_image_id": 515,
    "signer_full_name": "Fabien Emprunteur",
    "signed_at": "2026-10-01T18:00:00Z",
    "client_data_sha256": "c85a21098de742bf9e01824c32145e690a8412bc4f012e84127049adbc841029"
  }
}
```

#### Règles d'Arbitrage Odomètre
* Si `odometer_km < loan.mileage_start` : le serveur renvoie `422 Unprocessable Entity` avec message d'incohérence.
* Si `odometer_km == loan.mileage_start` (0 km parcouru) : **autorisé** côté serveur (cas du trajet annulé in extremis ou véhicule non déplacé pour cause d'intempérie).
* Enregistrement atomique : met à jour `mileage_end`, calcule la distance réelle (85 km), met à jour le statut vers `ended` puis `validated` (si auto-validé ou validé par le propriétaire).

---

### 3.3 Consultation des Inspections d'un Prêt
* **Méthode** : `GET`
* **Route** : `/loans/{loan}/inspections`
* **Policy** : `LoanPolicy@view` (Emprunteur, Propriétaire, Co-propriétaire, Admin).

#### Response (200 OK)
```json
{
  "data": {
    "loan_id": 42,
    "departure": {
      "completed": true,
      "odometer_km": 124500,
      "fuel_battery_level_percent": 85,
      "photos": {
        "front": "/api/v1/images/501",
        "back": "/api/v1/images/502",
        "left_side": "/api/v1/images/503",
        "right_side": "/api/v1/images/504",
        "dashboard_odometer": "/api/v1/images/505"
      },
      "signature": {
        "signer": "Fabien Emprunteur",
        "signed_at": "2026-10-01T09:05:00Z"
      }
    },
    "return": {
      "completed": true,
      "odometer_km": 124585,
      "distance_traveled_km": 85,
      "photos": {
        "front": "/api/v1/images/510",
        "back": "/api/v1/images/511",
        "left_side": "/api/v1/images/512",
        "right_side": "/api/v1/images/513",
        "dashboard_odometer": "/api/v1/images/514"
      },
      "signature": {
        "signer": "Fabien Emprunteur",
        "signed_at": "2026-10-01T18:00:00Z"
      }
    }
  }
}
```

---

## 4. Contrats de Prolongation de Prêt (Lot 12)

### 4.1 Demande de Prolongation
* **Méthode** : `PUT`
* **Route** : `/loans/{loan}/extension`
* **Policy** : `LoanPolicy@requestExtension`

#### Request Payload
```json
{
  "extension_duration_in_minutes": 180
}
```
*Note* : `extension_duration_in_minutes` représente la **nouvelle durée totale** du prêt depuis le départ, au moins égale à `duration_in_minutes + 15`.

#### Response (200 OK)
```json
{
  "data": {
    "id": 42,
    "status": "ongoing",
    "duration_in_minutes": 120,
    "extension_duration_in_minutes": 180,
    "is_self_service": false,
    "price_estimate": {
      "additional_duration_minutes": 60,
      "additional_estimated_cost_cents": 500,
      "currency": "CAD"
    }
  }
}
```
*Si le prêt est en auto-service (`is_self_service == true`) ou si l'utilisateur est le propriétaire, l'extension est appliquée immédiatement dans la transaction de disponibilité sans attente.*

---

## 5. Contrats Flotte & Indisponibilités Propriétaire (Lots 13 & 14)

### 5.1 Consultation Sécurisée de la Flotte Propriétaire
* **Méthode** : `GET`
* **Route** : `/owner/fleet`
* **Policy** : Utilisateur authentifié ayant au moins un rôle propriétaire/co-propriétaire ou administrateur.

#### Response (200 OK)
```json
{
  "data": [
    {
      "id": 3,
      "name": "Hyundai Ioniq 5 Solon",
      "type": "car",
      "sharing_mode": "self_service",
      "is_suspended": false,
      "active_loans_count": 1,
      "future_loans_count": 4,
      "primary_image_url": "/api/v1/images/120",
      "community": { "id": 8, "name": "LocoMotion Ahuntsic" }
    }
  ]
}
```

### 5.2 Suspension Temporaire d'un Véhicule
* **Méthode** : `PUT`
* **Route** : `/loanables/{loanable}/suspend`
* **Policy** : `LoanablePolicy@update`

#### Request Payload
```json
{
  "reason": "Entretien programmé (changement pneus)",
  "preserve_future_confirmed_loans": true
}
```

#### Effet Serveur
* Fixe `availability_mode = "never"` ou drapeau `is_suspended = true`.
* N'annule **aucun** prêt actif ni accepté existant sans confirmation explicite.
* Rend le véhicule immédiatement non réservable dans `ExploreScreen` et le calendrier public.

---

## 6. Contrats d'Incidents & Signalements (Lot 15)

### 6.1 Déclaration d'un Incident Post-MVP
* **Méthode** : `POST`
* **Route** : `/incidents`
* **Policy** : `IncidentPolicy@create`

#### Request Payload
```json
{
  "loanable_id": 3,
  "loan_id": 42,
  "incident_type": "delay",
  "severity": "minor",
  "comments_on_incident": "Retard estimé de 30 minutes dû à un embouteillage majeur.",
  "photos": [520, 521],
  "blocking_until": null
}
```

#### Catégories Autorisées
* `accident` : accident de circulation avec tiers ou obstacle (bloquant par défaut pour inspection).
* `puncture` : crevaison ou avarie pneumatique.
* `breakdown` : panne mécanique ou batterie déchargée.
* `delay` : retard de restitution (non bloquant matériellement, information de coordination).
* `general` : autre problème général ou saleté excessive.

---

## 7. Tableau Récapitulatif des Événements & Notifications Push Associées

| Événement Serveur | Déclencheur | Destinataires Autorisés | Écran Cible Mobile (Deep-link) |
|---|---|---|---|
| `LoanAcceptedEvent` | Décision propriétaire | Emprunteur | `/loans/:id` (avec invite caution/prépaiement) |
| `LoanPrepaidEvent` | Empreinte caution & prépaiement OK | Propriétaire & Emprunteur | `/loans/:id` (statut Confirmé) |
| `LoanDepartureInspectedEvent` | État des lieux départ validé | Propriétaire & Emprunteur | `/loans/:id` (statut En cours) |
| `LoanExtensionRequestedEvent` | Demande d'extension | Propriétaire | `/loans/:id/extension` |
| `LoanExtensionDecidedEvent` | Acceptation/Refus extension | Emprunteur | `/loans/:id` |
| `LoanReturnInspectedEvent` | Restitution & état des lieux retour | Propriétaire & Emprunteur | `/loans/:id` (statut Restitué/À valider) |
| `LoanSettledEvent` | Facture réglée & caution libérée | Emprunteur & Propriétaire | `/loans/:id/invoice` |
| `IncidentCreatedEvent` | Signalement créé | Propriétaire, Admin Communauté, Emprunteur | `/incidents/:id` |
