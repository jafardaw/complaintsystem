// lib/features/notifications/data/models/notifications_response_model.dart

import 'notification_model.dart';

class NotificationsResponseModel {
  final int currentPage;
  final List<NotificationModel> data;
  final int lastPage;
  final int total;
  final int perPage;

  NotificationsResponseModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationsResponseModel(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      total: json['total'] as int,
      perPage: json['per_page'] as int,
      data: (json['data'] as List<dynamic>)
          .map(
            (item) => NotificationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
