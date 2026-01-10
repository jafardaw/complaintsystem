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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppareWidget(
        title: 'بوابة إضافة الهيئات الحكومية',
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
                _clearControllers();
                Navigator.pop(context, true);
              } else if (state is CreateGovernmentAgencyError) {
                showCustomSnackBar(context, state.error, color: Palette.error);
              }
            },
            child: SingleChildScrollView(
              // التأكد من وجود مساحة كافية في الأسفل ليظهر الزر عند التمرير
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: SizedBox(
                  width: 1100, // العرض الثابت للويب
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(60),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // ليأخذ العمود مساحة محتواه فقط
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 48),
                            _buildFieldsGrid(),
                            const SizedBox(height: 48),

                            // زر الإرسال
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
                                      ? "جارٍ الحفظ..."
                                      : 'إنشاء الهيئة الجديدة',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.add_business_rounded, size: 40, color: Palette.primary),
            const SizedBox(width: 20),
            const Text(
              "إضافة هيئة حكومية جديدة",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "يرجى تعبئة كافة الحقول بدقة. هذه البيانات ستظهر للمواطنين في واجهة الشكاوى.",
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        const Divider(thickness: 1.5),
      ],
    );
  }

  Widget _buildFieldsGrid() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // لضمان توازن الحقول
          children: [
            Expanded(child: _buildNameField()),
            const SizedBox(width: 40),
            Expanded(child: _buildCategoryField()),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCityField()),
            const SizedBox(width: 40),
            Expanded(child: _buildPhoneField()),
          ],
        ),
        const SizedBox(height: 32),
        _buildAddressField(),
      ],
    );
  }

  Widget _buildNameField() => _buildTextField(
    controller: _nameController,
    labelText: 'اسم الهيئة الحكومية',
    icon: Icons.apartment_rounded,
    validator: (v) => v!.isEmpty ? 'يرجى إدخال اسم الهيئة' : null,
  );

  Widget _buildCategoryField() => _buildTextField(
    controller: _categoryController,
    labelText: 'التصنيف (وزارة، هيئة، مديرية...)',
    icon: Icons.category_rounded,
    validator: (v) => v!.isEmpty ? 'يرجى تحديد الفئة' : null,
  );

  Widget _buildCityField() => _buildTextField(
    controller: _cityController,
    labelText: 'المدينة / المحافظة',
    icon: Icons.location_city_rounded,
    validator: (v) => v!.isEmpty ? 'يرجى إدخال المدينة' : null,
  );

  Widget _buildAddressField() => _buildTextField(
    controller: _addressController,
    labelText: 'العنوان التفصيلي ومكان التواجد',
    icon: Icons.map_rounded,
    validator: (v) => v!.isEmpty ? 'يرجى إدخال العنوان' : null,
  );

  Widget _buildPhoneField() => _buildTextField(
    controller: _phoneController,
    labelText: 'رقم هاتف التواصل الرسمي',
    icon: Icons.phone_android_rounded,
    keyboardType: TextInputType.phone,
    validator: (v) => v!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: labelText,
      prefixIcon: Icon(icon, color: Palette.primary, size: 24),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  void _clearControllers() {
    _nameController.clear();
    _categoryController.clear();
    _cityController.clear();
    _addressController.clear();
    _phoneController.clear();
  }
}
