import 'package:aqaviatec/core/func/show_snak_bar.dart';
import 'package:aqaviatec/core/style/color.dart';
import 'package:aqaviatec/core/style/styles.dart';
import 'package:aqaviatec/core/util/api_service.dart';
import 'package:aqaviatec/core/util/assetimage.dart';
import 'package:aqaviatec/core/util/const.dart';
import 'package:aqaviatec/core/widget/background_viwe.dart';
import 'package:aqaviatec/core/widget/custom_button.dart';
import 'package:aqaviatec/core/widget/custom_field.dart';
import 'package:aqaviatec/core/widget/error_widget_view.dart';
import 'package:aqaviatec/core/widget/loading_view.dart';
import 'package:aqaviatec/features/auth/presentation/view/verify_email_view.dart';
import 'package:aqaviatec/features/change_password/presentation/manger/chek_email_cubit.dart';
import 'package:aqaviatec/features/change_password/presentation/manger/chek_email_state.dart';
import 'package:aqaviatec/features/change_password/repo/chang_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChekEmailView extends StatefulWidget {
  const ChekEmailView({super.key});

  @override
  State<ChekEmailView> createState() => _ChekEmailViewState();
}

class _ChekEmailViewState extends State<ChekEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChekEmailCubit(ChangPasswordRepo(ApiService())),
      // استخدام الـ Wrapper الجديد
      child: BackgroundWrapper(
        backgroundImagePath: Assets.assetsImagesPhoto20250924164616,
        applyOverlay: true, // تريد التعتيم هنا
        child: ChekEmailViewBody(
          formKey: _formKey,
          emailController: _emailController,
        ),
      ),
    );
  }
}

class ChekEmailViewBody extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  const ChekEmailViewBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
  }) : _formKey = formKey,
       _emailController = emailController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidthRegster),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    height: 300,
                    width: 300,
                    Assets.assetsImagesPhoto20250924144805RemovebgPreview,
                    fit: BoxFit.contain,
                  ),
                ),

                const Text(
                  'أدخل الايميل الخاص بك  لو سمحت', // تعديل رسالة الترحيب
                  style: Styles.textStyle16,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني',
                  hintText: 'أدخل البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.email, color: Colors.blueGrey),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني';
                    }
                    // يمكنك إضافة المزيد من قواعد التحقق من صحة البريد الإلكتروني هنا
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                BlocConsumer<ChekEmailCubit, ChekEmailState>(
                  listener: (context, state) {
                    if (state is ChekEmailSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyEmailView(
                            email: _emailController.text,
                            chektap: 1,
                          ),
                        ),
                      );
                      showCustomSnackBar(
                        context,
                        state.massege,
                        color: Palette.success,
                      );
                    } else if (state is ChekEmailFailure) {
                      showCustomSnackBar(
                        context,
                        state.error,
                        color: Palette.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ChekEmailLoading) {
                      return LoadingViewWidget();
                    }
                    if (state is ChekEmailFailure) {
                      return ShowErrorWidgetView.inlineError(
                        errorMessage: state.error,
                        onRetry: () {
                          context.read<ChekEmailCubit>().chekEmail(
                            usernameOrPhone: _emailController.text,
                          );
                        },
                      );
                    }
                    return CustomButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ChekEmailCubit>().chekEmail(
                            usernameOrPhone: _emailController.text,
                          );
                        }
                      },
                      text: 'إنشاء حساب',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
