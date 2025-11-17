import 'package:compaintsystem/featuer/auth/presentation/manger/google_login_state.dart';
import 'package:compaintsystem/featuer/auth/repo/google_login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleLoginCubit extends Cubit<GoogleLoginState> {
  final GoogleLoginService _googleLoginService;

  GoogleLoginCubit(this._googleLoginService) : super(GoogleLoginInitial());
  Future<void> loginWithGoogle() async {
    emit(GoogleLoginLoading());
    try {
      // 🔑 تنفيذ المنطق
      final result = await _googleLoginService.loginWithGoogle();

      if (result != null && result['success'] == true) {
        emit(GoogleLoginSuccess(token: result['token'], user: result['user']));
      } else {
        emit(GoogleLoginFailure(result?['error'] ?? 'Login failed'));
      }
    } catch (e) {
      emit(GoogleLoginFailure(e.toString()));
    }
  }
}
