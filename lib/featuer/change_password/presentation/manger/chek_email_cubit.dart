import 'package:compaintsystem/featuer/change_password/presentation/manger/chek_email_state.dart';
import 'package:compaintsystem/featuer/change_password/repo/chang_password_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChekEmailCubit extends Cubit<ChekEmailState> {
  final ChangPasswordRepo _chekEmailRepo;

  ChekEmailCubit(this._chekEmailRepo) : super(ChekEmailInitial());

  Future<void> chekEmail({required String usernameOrPhone}) async {
    emit(ChekEmailLoading());
    try {
      final userId = await _chekEmailRepo.chekEmail(
        usernameOrPhone: usernameOrPhone,
      );
      emit(ChekEmailSuccess(userId));
    } catch (e) {
      emit(ChekEmailFailure(e.toString()));
    }
  }
}
