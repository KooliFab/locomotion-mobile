/// Exact representation of Laravel's paginated collection for `GET /loanables`
/// wrapped with `ListLoanableResource`
const Map<String, dynamic> laravelPaginatedLoanablesJson = {
  "data": [
    {
      "id": 1,
      "sharing_mode": "self_service",
      "name": "Toyota Prius Hybride",
      "type": "car",
      "availability_status": "available",
      "timezone": "America/Montreal",
      "position": [45.5532, -73.6543],
      "active_incidents": [
        {
          "id": 101,
          "incident_type": "breakdown",
          "status": "open",
          "blocking_until": null,
          "is_blocking": false,
          "start_at": "2026-09-15 10:00:00",
          "loan_id": null,
          "loanable_id": 1,
        },
      ],
      "library": {
        "id": 5,
        "name": "Bibliothèque LocoMotion Ahuntsic",
        "phone_number": "514-555-0100",
        "created_at": "2025-01-01 10:00:00",
        "updated_at": "2025-01-01 10:00:00",
      },
    },
    {
      "id": 2,
      "sharing_mode": "on_demand",
      "name": "Vélo Cargo Babboe",
      "type": "bike",
      "availability_status": "unavailable",
      "timezone": "America/Montreal",
      "position": [45.5348, -73.5982],
      "active_incidents": [],
      "library": {
        "id": 6,
        "name": "Bibliothèque Petite-Patrie",
        "phone_number": "514-555-0101",
        "created_at": "2025-01-01 10:00:00",
        "updated_at": "2025-01-01 10:00:00",
      },
    },
  ],
  "links": {
    "first": "http://localhost:8000/api/v1/loanables?page=1",
    "last": "http://localhost:8000/api/v1/loanables?page=1",
    "prev": null,
    "next": null,
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 1,
    "per_page": 15,
    "to": 2,
    "total": 2,
  },
};

/// Exact representation of Laravel's `GET /loanables/{id}` (`LoanableResource`)
const Map<String, dynamic> laravelLoanableDetailJson = {
  "id": 1,
  "type": "car",
  "name": "Toyota Prius Hybride",
  "sharing_mode": "self_service",
  "availability_mode": "always",
  "availability_status": "available",
  "timezone": "America/Montreal",
  "position": [45.5532, -73.6543],
  "position_google": {"lat": 45.5532, "lng": -73.6543},
  "location_description": "Stationnement réservé rue Lajeunesse",
  "comments": "Véhicule propre et non-fumeur.",
  "instructions": "La clé se trouve dans la boîte à gants sécurisée.",
  "return_instructions":
      "Verrouiller les portes et remettre la clé dans le boîtier.",
  "min_loan_duration_in_minutes": 30,
  "max_loan_duration_in_minutes": 2880,
  "community_ids": [10],
  "image": {
    "id": 42,
    "field": "image",
    "filename": "prius.jpg",
    "original_filename": "toyota_prius.jpg",
    "width": 1200,
    "height": 800,
  },
  "images": [
    {
      "id": 42,
      "field": "image",
      "filename": "prius.jpg",
      "original_filename": "toyota_prius.jpg",
      "width": 1200,
      "height": 800,
    },
    {
      "id": 43,
      "field": "image",
      "filename": "prius_interior.jpg",
      "original_filename": "interieur.jpg",
      "width": 1200,
      "height": 800,
    },
  ],
  "active_incidents": [
    {
      "id": 101,
      "incident_type": "breakdown",
      "status": "open",
      "blocking_until": null,
      "is_blocking": false,
      "start_at": "2026-09-15 10:00:00",
      "loan_id": null,
      "loanable_id": 1,
    },
  ],
  "details": {
    "brand": "Toyota",
    "model": "Prius",
    "year": 2021,
    "seats": 5,
    "transmission": "automatic",
  },
};

/// Exact representation of Laravel's `LoanableController@availability` (`formatAvailabilities`)
const List<Map<String, dynamic>> laravelAvailabilityEventsJson = [
  {
    "type": "availability",
    "start": "2026-10-01 08:00:00",
    "end": "2026-10-01 12:00:00",
    "data": {"available": true},
  },
  {
    "type": "availability",
    "start": "2026-10-01 12:00:00",
    "end": "2026-10-01 14:00:00",
    "data": {"available": false},
  },
  {
    "type": "availability",
    "start": "2026-10-01 14:00:00",
    "end": "2026-10-01 18:00:00",
    "data": {"available": true},
  },
];
