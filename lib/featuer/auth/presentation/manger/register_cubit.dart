import 'package:compaintsystem/featuer/auth/presentation/manger/register_state.dart';
import 'package:compaintsystem/featuer/auth/repo/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final LoginRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(RegisterInitial());

  Future<void> register({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(RegisterLoading());
    try {
      final message = await _registerRepo.register(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(RegisterSuccess(message));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
