import 'package:compaintsystem/featuer/profile/presentation/manger/profile_state.dart';
import 'package:compaintsystem/featuer/profile/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileInitial());

  // دالة لجلب البيانات
  Future<void> getProfileData() async {
    emit(ProfileLoading());
    try {
      final userModel = await _profileRepo.getProfileData();
      emit(ProfileSuccess(userModel));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
