// lib/features/profile/logic/profile_cubit.dart

import 'package:compaintsystem/featuer/profile/presentation/manger/cubit/edit_profile_cubit.dart';
import 'package:compaintsystem/featuer/profile/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdatState> {
  final ProfileRepo _profileRepo;

  ProfileUpdateCubit(this._profileRepo) : super(ProfileUpdateInitial());

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    emit(UpdateProfileLoading());
    try {
      final responseModel = await _profileRepo.updateProfile(
        name: name,
        phone: phone,
      );

      emit(UpdateProfileSuccess(responseModel));
    } catch (e) {
      emit(UpdateProfileFailure(e.toString()));
    }
  }
}
