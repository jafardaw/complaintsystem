import 'package:compaintsystem/featuer/auth/presentation/manger/register_state.dart';
import 'package:compaintsystem/featuer/auth/repo/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final LoginRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      // **التعديل هنا:** المتغير الآن يستقبل user_id كـ int
      final userId = await _registerRepo.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      // بما أن الـ Repo أصبح يرجع user_id فقط، نستخدم رسالة ثابتة للنجاح
      const successMessage = "تم إنشاء الحساب بنجاح، وتم إرسال كود التحقق.";

      // **إصدار حالة النجاح مع الرسالة و userId الجديد**
      emit(RegisterSuccess(successMessage, userId));
    } catch (e) {
      // تبقى معالجة الأخطاء كما هي
      emit(RegisterFailure(e.toString()));
    }
  }
}
