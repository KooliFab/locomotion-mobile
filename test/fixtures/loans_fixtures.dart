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
