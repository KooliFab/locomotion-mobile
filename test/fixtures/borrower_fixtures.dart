// Borrower fixtures matching backend BorrowerResource.
// No real license numbers or sensitive data.

/// State: incomplete — borrower exists but submittedAt is null
const Map<String, dynamic> borrowerIncompleteJson = {
  'user_id': 42,
  'approved': false,
  'suspended': false,
  'validated': false,
  'submitted_at': null,
  'approved_at': null,
  'suspended_at': null,
};

/// State: pending — submitted but not yet approved or suspended
const Map<String, dynamic> borrowerPendingJson = {
  'user_id': 42,
  'approved': false,
  'suspended': false,
  'validated': false,
  'submitted_at': '2026-09-20T14:30:00.000000Z',
  'approved_at': null,
  'suspended_at': null,
};

/// State: validated — validated is true
const Map<String, dynamic> borrowerValidatedJson = {
  'user_id': 42,
  'approved': true,
  'suspended': false,
  'validated': true,
  'submitted_at': '2026-09-15T09:00:00.000000Z',
  'approved_at': '2026-09-16T10:00:00.000000Z',
  'suspended_at': null,
};

/// State: suspended
const Map<String, dynamic> borrowerSuspendedJson = {
  'user_id': 42,
  'approved': false,
  'suspended': true,
  'validated': false,
  'submitted_at': '2026-09-10T09:00:00.000000Z',
  'approved_at': null,
  'suspended_at': '2026-09-18T12:00:00.000000Z',
};

/// State: checkRequired — unexpected combination (approved=true, validated=false)
const Map<String, dynamic> borrowerUnexpectedJson = {
  'user_id': 42,
  'approved': true,
  'suspended': false,
  'validated': false,
  'submitted_at': '2026-09-10T09:00:00.000000Z',
  'approved_at': '2026-09-11T10:00:00.000000Z',
  'suspended_at': null,
};

/// FileResource fixture
const Map<String, dynamic> uploadedFileRefJson = {
  'id': 123,
  'original_filename': 'document.pdf',
  'field': 'gaa',
};

/// Submission request payload
const Map<String, dynamic> submissionRequestJson = {
  'user_id': 42,
  'drivers_license_number': 'TEST-PERMIT-XXXX',
  'has_not_been_sued_last_ten_years': true,
  'gaa': [
    {'id': 101},
  ],
  'saaq': [
    {'id': 102},
  ],
};
