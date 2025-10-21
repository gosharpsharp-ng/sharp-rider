class NotificationModel {
  final int id;
  final String? notifiableType;
  final int? notifiableId;
  final int? userId;
  final String title;
  final String message;
  final String priority;
  final String? status;
  final String? readAt;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    this.notifiableType,
    this.notifiableId,
    this.userId,
    required this.title,
    required this.message,
    required this.priority,
    this.status,
    this.readAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      priority: json['priority'] ?? 'normal',
      status: json['status'],
      readAt: json['read_at'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'user_id': userId,
      'title': title,
      'message': message,
      'priority': priority,
      'status': status,
      'read_at': readAt,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Convenience getters
  bool get isRead => readAt != null;
  bool get isUnread => readAt == null;
  bool get isDeleted => deletedAt != null;

  DateTime? get createdAtDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }

  String get formattedTime {
    final date = createdAtDateTime;
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
