// lib/features/notifications/data/models/notification_model.dart

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final String type;
  final String? createdAt;
  // يمكن إضافة نموذج شكوى مختصر (ComplaintModel) هنا إذا لزم الأمر
  final Map<String, dynamic>? complaintData; // أو نموذج مخصص للشكوى

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.type,
    this.createdAt,
    this.complaintData,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] as bool,
      type: json['type'] as String,
      createdAt: json['created_at'] as String?,
      // حفظ بيانات الشكوى لسهولة الوصول
      complaintData: json['complaint'] as Map<String, dynamic>?,
    );
  }
}
