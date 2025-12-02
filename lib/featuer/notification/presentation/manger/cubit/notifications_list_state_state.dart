import 'package:compaintsystem/featuer/notification/data/model/notification_model.dart';

abstract class NotificationsListState {}

class NotificationsListInitial extends NotificationsListState {}

// حالة التحميل الأولي
class NotificationsListLoading extends NotificationsListState {}

// حالة النجاح الرئيسية
class NotificationsListSuccess extends NotificationsListState {
  final List<NotificationModel> notifications;
  final int currentPage;
  final int lastPage;
  final bool hasMore; // هل توجد صفحات أخرى لجلبها

  NotificationsListSuccess({
    required this.notifications,
    required this.currentPage,
    required this.lastPage,
  }) : hasMore = currentPage < lastPage; // حساب hasMore تلقائياً
}

// حالة الفشل
class NotificationsListFailure extends NotificationsListState {
  final String error;

  NotificationsListFailure(this.error);
}

class NotificationsListLoadingMore extends NotificationsListSuccess {
  NotificationsListLoadingMore({
    required super.notifications,
    required super.currentPage,
    required super.lastPage,
  });
}
