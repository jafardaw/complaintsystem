import 'package:compaintsystem/featuer/auth/presentation/manger/resend_code_state.dart';
import 'package:compaintsystem/featuer/auth/repo/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendCodeCubit extends Cubit<ResendCodeState> {
  final LoginRepo _resendCodeRepo;

  ResendCodeCubit(this._resendCodeRepo) : super(ResendCodeInitial());

  Future<void> resendCode({required String email}) async {
    emit(ResendCodeLoading());
    try {
      final message = await _resendCodeRepo.resendCode(email: email);
      emit(ResendCodeSuccess(message));
    } catch (e) {
      emit(ResendCodeFailure(e.toString()));
    }
  }
}
