// lib/features/notifications/logic/notifications_list_cubit.dart

import 'package:compaintsystem/featuer/notification/data/model/notification_model.dart';
import 'package:compaintsystem/featuer/notification/presentation/manger/cubit/notifications_list_state_state.dart';
import 'package:compaintsystem/featuer/notification/repo/notifacation_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsListCubit extends Cubit<NotificationsListState> {
  final NotificationRepo _notificationRepo;

  NotificationsListCubit(this._notificationRepo)
    : super(NotificationsListInitial());

  @override
  void emit(NotificationsListState state) {
    if (!isClosed) super.emit(state);
  }

  int _currentPage = 1; // لتتبع الصفحة الحالية
  int _lastPage = 1; // لتتبع آخر صفحة
  final List<NotificationModel> _notifications = []; // القائمة المخزنة

  // دالة الجلب الأولي والتحميل
  Future<void> getNotifications() async {
    // إذا لم يكن التحميل الأول، يجب التحقق من حالة التحميل
    if (_notifications.isEmpty) {
      emit(NotificationsListLoading());
    }

    try {
      final responseModel = await _notificationRepo.getNotifications(
        page: 1,
      ); // ابدأ دائماً بالصفحة 1

      // تحديث البيانات المخزنة
      _notifications.clear();
      _notifications.addAll(responseModel.data);
      _currentPage = responseModel.currentPage;
      _lastPage = responseModel.lastPage;

      emit(
        NotificationsListSuccess(
          notifications: List.from(_notifications),
          currentPage: _currentPage,
          lastPage: _lastPage,
        ),
      );
    } catch (e) {
      emit(NotificationsListFailure(e.toString()));
    }
  }

  // دالة جلب المزيد من الإشعارات (Load More)
  Future<void> loadMoreNotifications() async {
    // تحقق أولاً: هل ما زال هناك صفحات لجلبها؟
    if (_currentPage >= _lastPage) return;

    // استدعاء حالة التحميل الإضافي للحفاظ على بيانات النجاح السابقة
    emit(
      NotificationsListLoadingMore(
        notifications: List.from(_notifications),
        currentPage: _currentPage,
        lastPage: _lastPage,
      ),
    );

    try {
      final nextPage = _currentPage + 1;
      final responseModel = await _notificationRepo.getNotifications(
        page: nextPage,
      );

      // تحديث القائمة والصفحات
      _notifications.addAll(responseModel.data);
      _currentPage = responseModel.currentPage;
      _lastPage = responseModel.lastPage;

      // إصدار حالة النجاح الجديدة
      emit(
        NotificationsListSuccess(
          notifications: List.from(_notifications),
          currentPage: _currentPage,
          lastPage: _lastPage,
        ),
      );
    } catch (e) {
      // إذا فشل التحميل الإضافي، نعود إلى حالة النجاح السابقة
      emit(
        NotificationsListSuccess(
          notifications: List.from(_notifications),
          currentPage: _currentPage,
          lastPage: _lastPage,
        ),
      );
      // ونعرض رسالة خطأ للمستخدم
      // (هذه الخطوة تتطلب استخدام BlocListener في الـ UI)
      rethrow;
    }
  }
}
