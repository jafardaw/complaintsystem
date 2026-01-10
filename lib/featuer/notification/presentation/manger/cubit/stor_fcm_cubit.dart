// lib/features/notifications/logic/notification_cubit.dart

import 'package:compaintsystem/featuer/notification/presentation/manger/cubit/stor_fcm_state.dart';
import 'package:compaintsystem/featuer/notification/repo/notifacation_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _notificationRepo;

  NotificationCubit(this._notificationRepo) : super(NotificationInitial());

  Future<void> registerToken({
    required String fcmToken,
    required String deviceId,
  }) async {
    emit(RegisterTokenLoading());
    try {
      final message = await _notificationRepo.registerFcmToken(
        fcmToken: fcmToken,
        deviceId: deviceId,
      );

      // تمرير رسالة النجاح
      emit(RegisterTokenSuccess(message));
    } catch (e) {
      // تمرير رسالة الخطأ
      emit(RegisterTokenFailure(e.toString()));
    }
  }
}
