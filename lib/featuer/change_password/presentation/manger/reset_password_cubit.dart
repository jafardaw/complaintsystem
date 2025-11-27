import 'package:compaintsystem/featuer/change_password/presentation/manger/reset_password_state.dart';
import 'package:compaintsystem/featuer/change_password/repo/chang_password_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ChangPasswordRepo _changPasswordRepo;

  ResetPasswordCubit(this._changPasswordRepo) : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required int userId,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final message = await _changPasswordRepo.resetPassword(
        userId: userId,
        code: code,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(ResetPasswordSuccess(message));
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}
