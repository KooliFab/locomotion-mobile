import 'borrower.dart';

/// Borrower dossier status computed from backend BorrowerResource fields.
/// Never inferred from a single boolean — follows the state table in lot_1.md.
enum BorrowerStatus {
  /// borrower absent or submittedAt == null
  incomplete,

  /// submittedAt != null, approved == false, suspended == false
  pending,

  /// validated == true
  validated,

  /// suspended == true
  suspended,

  /// Unexpected combination — do NOT allow reservation by default
  checkRequired,
}

extension BorrowerStatusX on BorrowerStatus {
  static BorrowerStatus from(Borrower? borrower) {
    if (borrower == null || borrower.submittedAt == null) {
      return BorrowerStatus.incomplete;
    }
    if (borrower.suspended) return BorrowerStatus.suspended;
    if (borrower.validated) return BorrowerStatus.validated;
    if (!borrower.approved && !borrower.suspended) {
      return BorrowerStatus.pending;
    }
    // Unexpected combination: log diagnostics, block by default
    return BorrowerStatus.checkRequired;
  }

  String get label {
    switch (this) {
      case BorrowerStatus.incomplete:
        return 'À compléter';
      case BorrowerStatus.pending:
        return 'En cours de validation';
      case BorrowerStatus.validated:
        return 'Validé';
      case BorrowerStatus.suspended:
        return 'Suspendu';
      case BorrowerStatus.checkRequired:
        return 'Vérification requise';
    }
  }

  String get description {
    switch (this) {
      case BorrowerStatus.incomplete:
        return 'Complétez votre dossier conducteur pour réserver un véhicule motorisé.';
      case BorrowerStatus.pending:
        return 'Votre dossier est en cours d\'examen. Vous serez notifié dès qu\'une décision sera rendue.';
      case BorrowerStatus.validated:
        return 'Votre dossier est validé. Vous pouvez réserver des véhicules motorisés.';
      case BorrowerStatus.suspended:
        return 'Votre dossier est suspendu. Contactez le support pour plus d\'informations.';
      case BorrowerStatus.checkRequired:
        return 'Une vérification manuelle est requise. Contactez le support.';
    }
  }

  bool get canReserveCar => this == BorrowerStatus.validated;
}
