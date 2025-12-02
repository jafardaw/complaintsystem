import 'package:compaintsystem/featuer/complaint/presentation/view/manager/post_cubit/add_complaint_state.dart';
import 'package:compaintsystem/featuer/complaint/repo/coplaint_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewComplaintCubit extends Cubit<NewComplaintState> {
  // 1. الاعتمادية: يعتمد الكيوبت على الـ Repository
  final ComplaintsRepo _repo;

  NewComplaintCubit(this._repo) : super(NewComplaintInitial());

  // 2. دالة إرسال الشكوى: تركز فقط على إدارة الحالة (Loading, Success, Error)
  Future<void> submitComplaint({
    required int agencyId,
    required String type,
    required String title,
    required String description,
    required String locationText,
    required String priority,
  }) async {
    // إرسال حالة التحميل
    emit(NewComplaintLoading());

    try {
      // استدعاء دالة الإرسال من الـ Repository
      final responseData = await _repo.submitComplaint(
        agencyId: agencyId,
        type: type,
        title: title,
        description: description,
        locationText: locationText,
        priority: priority,
      );

      // إرسال حالة النجاح باستخدام البيانات المسترجعة
      emit(
        NewComplaintSuccess(
          'تم تسجيل الشكوى بنجاح. رمز الشكوى المرجعي: ${responseData['reference_code']}',
        ),
      );
    } catch (e) {
      // إرسال حالة الخطأ في حالة فشل الإرسال
      // إزالة بادئة "Exception: " للحصول على رسالة خطأ أنظف
      emit(NewComplaintError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
