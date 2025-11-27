import 'package:compaintsystem/featuer/auth/presentation/manger/verify_email_state.dart';
import 'package:compaintsystem/featuer/auth/repo/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final LoginRepo _verifyEmailRepo;

  VerifyEmailCubit(this._verifyEmailRepo) : super(VerifyEmailInitial());

  Future<void> verifyEmail({
    required int userId,
    required String verificationCode,
  }) async {
    emit(VerifyEmailLoading());
    try {
      final message = await _verifyEmailRepo.verifyEmail(
        userId: userId,
        verificationCode: verificationCode,
      );
      emit(VerifyEmailSuccess(message));
    } catch (e) {
      // هنا e ستحتوي على رسالة الخطأ الصحيحة
      emit(VerifyEmailFailure(e.toString()));
    }
  }
}
