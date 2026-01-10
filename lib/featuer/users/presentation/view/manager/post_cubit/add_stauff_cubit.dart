// add_user_cubit.dart
import 'package:compaintsystem/featuer/users/presentation/view/manager/post_cubit/add_stauff_state.dart';
import 'package:compaintsystem/featuer/users/repo/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserCubit extends Cubit<AddUserState> {
  final UsersRepository _repository;
  AddUserCubit(this._repository) : super(AddUserInitial());

  Future<void> addUser({
    required int agencyId,
    required Map<String, dynamic> userData,
  }) async {
    emit(AddUserLoading());
    try {
      await _repository.addUser(agencyId: agencyId, userData: userData);
      emit(AddUserSuccess("تم إضافة الموظف بنجاح"));
    } catch (e) {
      emit(AddUserError(e.toString()));
    }
  }
}
