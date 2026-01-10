// update_user_cubit.dart
import 'package:compaintsystem/featuer/users/presentation/view/manager/update_cubit/update_user_state.dart';
import 'package:compaintsystem/featuer/users/repo/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  final UsersRepository _repository;
  UpdateUserCubit(this._repository) : super(UpdateUserInitial());

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    emit(UpdateUserLoading());
    try {
      await _repository.updateUser(id, data);
      emit(UpdateUserSuccess("تم تحديث بيانات المستخدم بنجاح"));
    } catch (e) {
      emit(UpdateUserError(e.toString()));
    }
  }
}
