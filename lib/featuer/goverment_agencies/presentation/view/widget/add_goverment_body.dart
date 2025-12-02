// 💡 الودجت الذي يحتوي على النموذج

import 'package:compaintsystem/core/func/show_snak_bar.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/widget/app_bar_widget.dart';
import 'package:compaintsystem/core/widget/custom_button.dart';
import 'package:compaintsystem/core/widget/custom_field.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/post_cubit/add_goverment_agencies_cubit.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/post_cubit/add_goverment_agencies_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGovernmentAgencyViewBody extends StatefulWidget {
  const CreateGovernmentAgencyViewBody({super.key});

  @override
  State<CreateGovernmentAgencyViewBody> createState() =>
      _CreateGovernmentAgencyViewBodyState();
}

class _CreateGovernmentAgencyViewBodyState
    extends State<CreateGovernmentAgencyViewBody> {
  final _formKey = GlobalKey<FormState>();

  // متحكمات الحقول
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // دالة إرسال النموذج
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<CreateGovernmentAgencyCubit>().createAgency(
        name: _nameController.text,
        category: _categoryController.text,
        city: _cityController.text,
        address: _addressController.text,
        phone: _phoneController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        title: 'إنشاء هيئة حكومية جديدة',
        automaticallyImplyLeading: true,
      ),
      body:
          BlocListener<
            CreateGovernmentAgencyCubit,
            CreateGovernmentAgencyState
          >(
            listener: (context, state) {
              if (state is CreateGovernmentAgencySuccess) {
                showCustomSnackBar(
                  context,
                  state.message,
                  color: Palette.success,
                );
                _nameController.clear();
                _categoryController.clear();
                _cityController.clear();
                _addressController.clear();
                _phoneController.clear();
                Navigator.pop(context, true);
              } else if (state is CreateGovernmentAgencyError) {
                showCustomSnackBar(context, state.error, color: Palette.error);
              }
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // حقل اسم الهيئة
                      _buildTextField(
                        controller: _nameController,
                        labelText: 'اسم الهيئة (مثال: وزارة الصحة)',
                        icon: Icons.apartment_outlined,
                        validator: (value) =>
                            value!.isEmpty ? 'الرجاء إدخال اسم الهيئة' : null,
                      ),
                      const SizedBox(height: 15),

                      // حقل الفئة
                      _buildTextField(
                        controller: _categoryController,
                        labelText: 'الفئة (مثال: وزارة، هيئة، مديرية)',
                        icon: Icons.category_outlined,
                        validator: (value) =>
                            value!.isEmpty ? 'الرجاء إدخال الفئة' : null,
                      ),
                      const SizedBox(height: 15),

                      // حقل المدينة
                      _buildTextField(
                        controller: _cityController,
                        labelText: 'المدينة (مثال: دمشق)',
                        icon: Icons.location_city_outlined,
                        validator: (value) =>
                            value!.isEmpty ? 'الرجاء إدخال المدينة' : null,
                      ),
                      const SizedBox(height: 15),

                      // حقل العنوان
                      _buildTextField(
                        controller: _addressController,
                        labelText: 'العنوان التفصيلي (مثال: شارع أبو رمانة)',
                        icon: Icons.place_outlined,
                        validator: (value) =>
                            value!.isEmpty ? 'الرجاء إدخال العنوان' : null,
                      ),
                      const SizedBox(height: 15),

                      // حقل الهاتف
                      _buildTextField(
                        controller: _phoneController,
                        labelText: 'رقم الهاتف (مثال: +963112345678)',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            value!.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
                      ),
                      const SizedBox(height: 40),

                      // زر الإرسال الجميل والمتحرك
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.12,
                        ),
                        child:
                            BlocBuilder<
                              CreateGovernmentAgencyCubit,
                              CreateGovernmentAgencyState
                            >(
                              builder: (context, state) {
                                return CustomButton(
                                  onTap: state is CreateGovernmentAgencyLoading
                                      ? null
                                      : _submitForm,

                                  text: state is CreateGovernmentAgencyLoading
                                      ? "جار الأضافة"
                                      : 'إنشاء هيئة جديدة',
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  // دالة مساعدة لبناء CustomTextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return CustomTextField(
      controller: controller,
      label: Text(labelText),
      prefixIcon: Icon(icon, color: Palette.primary),
      keyboardType: keyboardType,
      validator: validator,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }
}
