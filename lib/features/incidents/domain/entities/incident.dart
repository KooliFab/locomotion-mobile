import '../../../loanables/domain/entities/loanable_image.dart';
import 'incident_category.dart';
import 'incident_note.dart';

class Incident {
  final int id;
  final int? loanableId;
  final String? loanableName;
  final int? loanId;
  final int? loanCommunityId;
  final String incidentType;
  final String status;
  final String? commentsOnIncident;
  final DateTime? blockingUntil;
  final bool isBlocking;
  final DateTime? startAt;
  final DateTime? createdAt;
  final DateTime? executedAt;
  final DateTime? updatedAt;
  final bool detailsHidden;
  final int? reportedByUserId;
  final String? reportedByUserName;
  final int? resolvedByUserId;
  final String? resolvedByUserName;
  final int? assigneeId;
  final String? assigneeName;
  final List<IncidentNote> notes;
  final List<String> photoUrls;
  final List<int> photoImageIds;
  final List<LoanableImage> photos;
  final List<int> vehicleOwnerIds;
  final bool? canResolveServer;
  final bool? canAddNoteServer;
  final bool? canReopenServer;
  final bool? canChangeAssigneeServer;

  const Incident({
    required this.id,
    this.loanableId,
    this.loanableName,
    this.loanId,
    this.loanCommunityId,
    required this.incidentType,
    required this.status,
    this.commentsOnIncident,
    this.blockingUntil,
    this.isBlocking = false,
    this.startAt,
    this.createdAt,
    this.executedAt,
    this.updatedAt,
    this.detailsHidden = false,
    this.reportedByUserId,
    this.reportedByUserName,
    this.resolvedByUserId,
    this.resolvedByUserName,
    this.assigneeId,
    this.assigneeName,
    this.notes = const [],
    this.photoUrls = const [],
    this.photoImageIds = const [],
    this.photos = const [],
    this.vehicleOwnerIds = const [],
    this.canResolveServer,
    this.canAddNoteServer,
    this.canReopenServer,
    this.canChangeAssigneeServer,
  });

  bool get isCompleted => status == 'completed';
  bool get isResolved => isCompleted;
  bool get isInProcess => status == 'in_process';
  IncidentCategory get category =>
      IncidentCategory.fromCommentsOrType(commentsOnIncident, incidentType);

  String get cleanComments {
    if (commentsOnIncident == null) return '';
    var text = IncidentCategory.stripPrefix(commentsOnIncident!);
    // Strip trailing [Preuves: ...]
    final proofRegex = RegExp(r'\[Preuves?:?[^\]]*\]');
    text = text.replaceAll(proofRegex, '').trim();
    return text;
  }

  bool canResolve(int currentUserId, {bool isOwner = false, bool isAdmin = false}) {
    if (canResolveServer != null) return canResolveServer!;
    if (isOwner || isAdmin) return true;
    if (vehicleOwnerIds.contains(currentUserId)) return true;
    if (assigneeId != null && assigneeId == currentUserId) return true;
    return false;
  }

  bool canAddNote(int currentUserId, {bool isOwner = false, bool isAdmin = false}) {
    if (canAddNoteServer != null) return canAddNoteServer!;
    if (isOwner || isAdmin) return true;
    if (vehicleOwnerIds.contains(currentUserId)) return true;
    if (assigneeId != null && assigneeId == currentUserId) return true;
    if (reportedByUserId != null && reportedByUserId == currentUserId) return true;
    return false;
  }

  factory Incident.fromJson(Map<String, dynamic> json) {
    // 1. Vehicle info
    String? loanableName;
    int? loanableId = json['loanable_id'] as int?;
    final vehicleOwnerIds = <int>[];
    if (json['loanable'] is Map<String, dynamic>) {
      final loanableMap = json['loanable'] as Map<String, dynamic>;
      loanableName = loanableMap['name'] as String?;
      loanableId ??= loanableMap['id'] as int?;
      final roles = loanableMap['merged_user_roles'];
      if (roles is List) {
        for (final r in roles) {
          if (r is Map) {
            final uid = r['user_id'] ?? (r['user'] is Map ? r['user']['id'] : null);
            final role = r['role']?.toString();
            if (uid is int &&
                (role == 'owner' || role == 'coowner' || role == 'manager')) {
              vehicleOwnerIds.add(uid);
            }
          }
        }
      }
    } else if (json['loanable_name'] != null) {
      loanableName = json['loanable_name'] as String?;
    }

    // 2. Reporter info
    String? reporterName;
    int? reportedById = json['reported_by_user_id'] as int?;
    if (json['reported_by_user'] is Map<String, dynamic>) {
      final repMap = json['reported_by_user'] as Map<String, dynamic>;
      reportedById ??= repMap['id'] as int?;
      final first = repMap['first_name'] as String? ?? '';
      final last = repMap['last_name'] as String? ?? '';
      reporterName = '$first $last'.trim();
      if (reporterName.isEmpty) reporterName = repMap['name'] as String?;
    }

    // 3. Resolver info
    String? resolverName;
    int? resolvedById = json['resolved_by_user_id'] as int?;
    if (json['resolved_by_user'] is Map<String, dynamic>) {
      final resMap = json['resolved_by_user'] as Map<String, dynamic>;
      resolvedById ??= resMap['id'] as int?;
      final first = resMap['first_name'] as String? ?? '';
      final last = resMap['last_name'] as String? ?? '';
      resolverName = '$first $last'.trim();
      if (resolverName.isEmpty) resolverName = resMap['name'] as String?;
    }

    // 4. Assignee info
    String? assigneeName;
    int? assigneeId = json['assignee_id'] as int?;
    if (json['assignee'] is Map<String, dynamic>) {
      final assMap = json['assignee'] as Map<String, dynamic>;
      assigneeId ??= assMap['id'] as int?;
      final first = assMap['first_name'] as String? ?? '';
      final last = assMap['last_name'] as String? ?? '';
      assigneeName = '$first $last'.trim();
      if (assigneeName.isEmpty) assigneeName = assMap['name'] as String?;
    }

    // 5. Notes parsing
    List<IncidentNote> notes = [];
    if (json['notes'] is List) {
      notes = (json['notes'] as List)
          .whereType<Map<String, dynamic>>()
          .map((n) => IncidentNote.fromJson(n))
          .toList();
    }

    // 6. Photo IDs & URLs extraction from images and comments
    final comments = json['comments_on_incident'] as String?;
    final photoImageIds = <int>[];
    final photoUrls = <String>[];
    final photos = <LoanableImage>[];

    if (json['images'] is List) {
      for (final imgJson in json['images']) {
        if (imgJson is Map<String, dynamic>) {
          try {
            final img = LoanableImage.fromJson(imgJson);
            photos.add(img);
            if (!photoImageIds.contains(img.id)) {
              photoImageIds.add(img.id);
              photoUrls.add('/api/v1/images/${img.id}');
            }
          } catch (_) {}
        }
      }
    }

    if (comments != null) {
      // Format: image_id#123 or image#123 or /api/v1/images/123
      final idRegex = RegExp(r'image(?:_id)?#?(\d+)|/api/v1/images/(\d+)', caseSensitive: false);
      for (final match in idRegex.allMatches(comments)) {
        final idStr = match.group(1) ?? match.group(2);
        if (idStr != null) {
          final idVal = int.tryParse(idStr);
          if (idVal != null && !photoImageIds.contains(idVal)) {
            photoImageIds.add(idVal);
            photoUrls.add('/api/v1/images/$idVal');
          }
        }
      }
    }

    for (final id in photoImageIds) {
      if (!photos.any((p) => p.id == id)) {
        photos.add(LoanableImage(id: id));
      }
    }

    return Incident(
      id: json['id'] as int,
      loanableId: loanableId,
      loanableName: loanableName,
      loanId: json['loan_id'] as int?,
      loanCommunityId: json['loan_community_id'] as int?,
      incidentType: json['incident_type'] as String? ?? 'general',
      status: json['status'] as String? ?? 'in_process',
      commentsOnIncident: comments,
      blockingUntil: json['blocking_until'] != null
          ? DateTime.tryParse(json['blocking_until'] as String)
          : null,
      isBlocking: json['is_blocking'] as bool? ?? false,
      startAt: json['start_at'] != null
          ? DateTime.tryParse(json['start_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      executedAt: json['executed_at'] != null
          ? DateTime.tryParse(json['executed_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      detailsHidden: json['details_hidden'] as bool? ?? false,
      reportedByUserId: reportedById,
      reportedByUserName: reporterName,
      resolvedByUserId: resolvedById,
      resolvedByUserName: resolverName,
      assigneeId: assigneeId,
      assigneeName: assigneeName,
      notes: notes,
      photoUrls: photoUrls,
      photoImageIds: photoImageIds,
      photos: photos,
      vehicleOwnerIds: vehicleOwnerIds,
      canResolveServer: json['can_resolve'] as bool?,
      canAddNoteServer: json['can_add_note'] as bool?,
      canReopenServer: json['can_reopen'] as bool?,
      canChangeAssigneeServer: json['can_change_assignee'] as bool?,
    );
  }

  Incident copyWith({
    String? status,
    String? commentsOnIncident,
    DateTime? blockingUntil,
    bool? isBlocking,
    DateTime? executedAt,
    DateTime? updatedAt,
    int? resolvedByUserId,
    String? resolvedByUserName,
    int? assigneeId,
    String? assigneeName,
    List<IncidentNote>? notes,
    List<int>? vehicleOwnerIds,
  }) {
    return Incident(
      id: id,
      loanableId: loanableId,
      loanableName: loanableName,
      loanId: loanId,
      loanCommunityId: loanCommunityId,
      incidentType: incidentType,
      status: status ?? this.status,
      commentsOnIncident: commentsOnIncident ?? this.commentsOnIncident,
      blockingUntil: blockingUntil ?? this.blockingUntil,
      isBlocking: isBlocking ?? this.isBlocking,
      startAt: startAt,
      createdAt: createdAt,
      executedAt: executedAt ?? this.executedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      detailsHidden: detailsHidden,
      reportedByUserId: reportedByUserId,
      reportedByUserName: reportedByUserName,
      resolvedByUserId: resolvedByUserId ?? this.resolvedByUserId,
      resolvedByUserName: resolvedByUserName ?? this.resolvedByUserName,
      assigneeId: assigneeId ?? this.assigneeId,
      assigneeName: assigneeName ?? this.assigneeName,
      notes: notes ?? this.notes,
      photoUrls: photoUrls,
      photoImageIds: photoImageIds,
      photos: photos,
      vehicleOwnerIds: vehicleOwnerIds ?? this.vehicleOwnerIds,
      canResolveServer: canResolveServer,
      canAddNoteServer: canAddNoteServer,
      canReopenServer: canReopenServer,
      canChangeAssigneeServer: canChangeAssigneeServer,
    );
  }
}
