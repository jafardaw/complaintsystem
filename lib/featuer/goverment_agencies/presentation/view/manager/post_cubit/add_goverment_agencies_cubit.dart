import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/post_cubit/add_goverment_agencies_state.dart';
import 'package:compaintsystem/featuer/goverment_agencies/repo/repo_governmentagency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGovernmentAgencyCubit extends Cubit<CreateGovernmentAgencyState> {
  final GovernmentAgenciesRepo _repo;

  CreateGovernmentAgencyCubit(this._repo)
    : super(CreateGovernmentAgencyInitial());

  // دالة إنشاء الهيئة
  Future<void> createAgency({
    required String name,
    required String category,
    required String city,
    required String address,
    required String phone,
  }) async {
    emit(CreateGovernmentAgencyLoading());
    try {
      final Map<String, dynamic> data = {
        "name": name,
        "category": category,
        "city": city,
        "address": address,
        "phone": phone,
      };

      final response = await _repo.createAgency(data);

      // التحقق من نجاح العملية
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreateGovernmentAgencySuccess("تم إنشاء الهيئة الحكومية بنجاح!"));
      } else {
        emit(
          CreateGovernmentAgencyError(
            "فشل في إنشاء الهيئة: ${response.statusCode}",
          ),
        );
      }
    } catch (e) {
      emit(CreateGovernmentAgencyError(e.toString()));
    }
  }

  Future<void> UpdateAgency({
    required int id,
    required String name,
    required String category,
    required String city,
    required String address,
    required String phone,
  }) async {
    emit(UpdatGovernmentAgencyLoading());
    try {
      final Map<String, dynamic> data = {
        "name": name,
        "category": category,
        "city": city,
        "address": address,
        "phone": phone,
      };

      final response = await _repo.UpdateAgency(data, id);

      // التحقق من نجاح العملية
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(UpdatGovernmentAgencySuccess("تم تعديل الهيئة الحكومية بنجاح!"));
      } else {
        emit(
          UpdatGovernmentAgencyError(
            "فشل في إنشاء الهيئة: ${response.statusCode}",
          ),
        );
      }
    } catch (e) {
      emit(UpdatGovernmentAgencyError(e.toString()));
    }
  }
}
