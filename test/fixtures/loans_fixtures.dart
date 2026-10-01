const Map<String, dynamic> laravelLoansDashboardJson = {
  "started": {
    "total": 1,
    "loans": [
      {
        "id": 10,
        "departure_at": "2026-10-01 09:00:00",
        "duration_in_minutes": 180,
        "status": "ongoing",
        "community": {"id": 10},
        "borrower_user": {
          "id": 100,
          "name": "Jean",
          "last_name": "Dupont",
          "full_name": "Jean Dupont",
        },
        "loanable": {"id": 1, "name": "Toyota Prius Hybride", "type": "car"},
        "needs_validation": false,
        "borrower_total": 24.50,
        "owner_total": 20.00,
      },
    ],
  },
  "waiting": {
    "total": 1,
    "loans": [
      {
        "id": 11,
        "departure_at": "2026-10-05 14:00:00",
        "duration_in_minutes": 120,
        "status": "requested",
        "community": {"id": 10},
        "borrower_user": {"id": 100, "full_name": "Jean Dupont"},
        "loanable": {"id": 2, "name": "Vélo Cargo Babboe", "type": "bike"},
      },
    ],
  },
  "need_approval": {
    "total": 1,
    "loans": [
      {
        "id": 12,
        "departure_at": "2026-10-06 10:00:00",
        "duration_in_minutes": 240,
        "status": "requested",
        "owner_action_required": true,
        "borrower_user": {"id": 105, "full_name": "Marie Curie"},
        "loanable": {"id": 1, "name": "Toyota Prius Hybride", "type": "car"},
      },
    ],
  },
  "future": {
    "total": 1,
    "loans": [
      {
        "id": 13,
        "departure_at": "2026-10-07 08:00:00",
        "duration_in_minutes": 60,
        "status": "confirmed",
        "community": {"id": 10},
        "borrower_user": {"id": 100, "full_name": "Jean Dupont"},
        "loanable": {"id": 3, "name": "Remorque Croozer", "type": "trailer"},
      },
    ],
  },
  "completed": {
    "total": 1,
    "loans": [
      {
        "id": 9,
        "departure_at": "2026-09-20 10:00:00",
        "actual_return_at": "2026-09-20 12:00:00",
        "duration_in_minutes": 120,
        "status": "completed",
        "borrower_user": {"id": 100, "full_name": "Jean Dupont"},
        "borrower_total": 15.50,
        "owner_total": 12.00,
        "loanable": {"id": 1, "name": "Toyota Prius Hybride", "type": "car"},
      },
    ],
  },
};

const Map<String, dynamic> laravelCreateLoanResponseJson = {
  "id": 25,
  "departure_at": "2026-10-10 10:00:00",
  "duration_in_minutes": 120,
  "status": "requested",
  "borrower_user_id": 100,
  "loanable_id": 1,
  "estimated_distance": 25,
  "alternative_to": "car",
  "community": {"id": 10},
  "created_at": "2026-09-21 20:00:00",
};

/// Derived from backend/app/Http/Resources/Loan/LoanResource.php
/// Laravel serializes CarbonImmutable to ISO 8601 UTC with 'Z' (e.g. 2026-10-15T14:00:00.000000Z)
const Map<String, dynamic> laravelLoanDetailJson = {
  "id": 42,
  "departure_at": "2026-10-15T14:00:00.000000Z",
  "duration_in_minutes": 180,
  "status": "requested",
  "accepted_at": null,
  "prepaid_at": null,
  "canceled_at": null,
  "actual_return_at": null,
  "borrower_validated_at": null,
  "owner_validated_at": null,
  "needs_validation": false,
  "is_free": false,
  "borrower_total": 35.00,
  "owner_total": 30.00,
  "owner_action_required": false,
  "borrower_action_required": false,
  "is_self_service": false,
  "estimated_distance": 50,
  "actual_distance": null,
  "alternative_to": "car",
  "created_at": "2026-10-01T10:00:00.000000Z",
  "community": {
    "id": 10,
    "name": "Communauté Rosemont",
  },
  "borrower_user": {
    "id": 100,
    "name": "Jean",
    "last_name": "Dupont",
    "full_name": "Jean Dupont",
    "email": "jean.dupont@example.com",
  },
  "loanable": {
    "id": 5,
    "name": "Hyundai Ioniq 5",
    "type": "car",
    "timezone": "America/Montreal",
    "merged_user_roles": [
      {
        "user_id": 200,
        "role": "owner",
      },
    ],
  },
  "comments": [
    {
      "id": 1,
      "loan_id": 42,
      "author_id": 100,
      "text": "Bonjour, je ramènerai le véhicule propre avec batterie à 80%.",
      "created_at": "2026-10-01T10:05:00.000000Z",
      "author": {
        "id": 100,
        "name": "Jean",
        "last_name": "Dupont",
        "full_name": "Jean Dupont",
      },
    },
  ],
};

/// Paginated response from GET /loans (WebQueryBuilder)
const Map<String, dynamic> laravelLoansPaginatedJson = {
  "data": [
    {
      "id": 50,
      "departure_at": "2026-09-01T10:00:00.000000Z",
      "duration_in_minutes": 120,
      "status": "canceled",
      "canceled_at": "2026-09-01T08:30:00.000000Z",
      "borrower_user": {"id": 100, "full_name": "Jean Dupont"},
      "loanable": {"id": 1, "name": "Toyota Prius Hybride", "type": "car"},
    },
    {
      "id": 51,
      "departure_at": "2026-08-15T14:00:00.000000Z",
      "duration_in_minutes": 60,
      "status": "rejected",
      "borrower_user": {"id": 100, "full_name": "Jean Dupont"},
      "loanable": {"id": 2, "name": "Vélo Babboe", "type": "bike"},
    },
  ],
  "meta": {
    "current_page": 1,
    "last_page": 2,
    "per_page": 2,
    "total": 4,
  },
  "links": {
    "first": "http://localhost:8000/api/v1/loans?page=1",
    "last": "http://localhost:8000/api/v1/loans?page=2",
    "prev": null,
    "next": "http://localhost:8000/api/v1/loans?page=2",
  },
};

