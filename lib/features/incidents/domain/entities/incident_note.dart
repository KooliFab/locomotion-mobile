class IncidentNote {
  final int id;
  final int? incidentId;
  final int? authorId;
  final String? authorName;
  final String? authorAvatarUrl;
  final String text;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const IncidentNote({
    required this.id,
    this.incidentId,
    this.authorId,
    this.authorName,
    this.authorAvatarUrl,
    required this.text,
    this.createdAt,
    this.updatedAt,
  });

  factory IncidentNote.fromJson(Map<String, dynamic> json) {
    String? authorName;
    String? avatarUrl;

    if (json['author'] is Map<String, dynamic>) {
      final authorMap = json['author'] as Map<String, dynamic>;
      final first = authorMap['first_name'] as String? ?? '';
      final last = authorMap['last_name'] as String? ?? '';
      final full = '$first $last'.trim();
      authorName = full.isNotEmpty ? full : (authorMap['name'] as String?);
      if (authorMap['avatar'] is Map<String, dynamic>) {
        avatarUrl =
            (authorMap['avatar'] as Map<String, dynamic>)['url'] as String?;
      }
    } else if (json['author_name'] != null) {
      authorName = json['author_name'] as String?;
    }

    return IncidentNote(
      id: json['id'] as int,
      incidentId: json['incident_id'] as int?,
      authorId: json['author_id'] as int?,
      authorName: authorName ?? 'Intervenant',
      authorAvatarUrl: avatarUrl,
      text: json['text'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incident_id': incidentId,
      'author_id': authorId,
      'author_name': authorName,
      'text': text,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
