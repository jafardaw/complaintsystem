import 'package:compaintsystem/core/func/show_snak_bar.dart';
import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/widget/app_bar_widget.dart';
import 'package:compaintsystem/core/widget/custom_button.dart';
import 'package:compaintsystem/core/widget/custom_field.dart';
import 'package:compaintsystem/featuer/goverment_agencies/data/governmentagency_model.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/post_cubit/add_goverment_agencies_cubit.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/post_cubit/add_goverment_agencies_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateGovernmentAgencyView extends StatelessWidget {
  const UpdateGovernmentAgencyView({super.key, required this.governmentAgency});

  final GovernmentAgency governmentAgency;

  @override
  Widget build(BuildContext context) {
    return UpdateGovernmentAgencyViewBody(governmentAgency: governmentAgency);
  }
}

class UpdateGovernmentAgencyViewBody extends StatefulWidget {
  const UpdateGovernmentAgencyViewBody({
    super.key,
    required this.governmentAgency,
  });

  final GovernmentAgency governmentAgency;

  @override
  State<UpdateGovernmentAgencyViewBody> createState() =>
      _UpdateGovernmentAgencyViewBodyState();
}

class _UpdateGovernmentAgencyViewBodyState
    extends State<UpdateGovernmentAgencyViewBody> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _cityController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.governmentAgency.name);
    _categoryController = TextEditingController(
      text: widget.governmentAgency.category,
    );
    _cityController = TextEditingController(text: widget.governmentAgency.city);
    _addressController = TextEditingController(
      text: widget.governmentAgency.address,
    );
    _phoneController = TextEditingController(
      text: widget.governmentAgency.phone,
    );
  }

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
      context.read<CreateGovernmentAgencyCubit>().UpdateAgency(
        id: widget.governmentAgency.id,
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
        title: 'تعديل بيانات الهيئة الحكومية',
        automaticallyImplyLeading: true,
      ),
      body:
          BlocListener<
            CreateGovernmentAgencyCubit,
            CreateGovernmentAgencyState
          >(
            listener: (context, state) {
              if (state is UpdatGovernmentAgencySuccess) {
                showCustomSnackBar(
                  context,
                  state.message,
                  color: Palette.success,
                );
                Navigator.pop(context, true);
              } else if (state is UpdatGovernmentAgencyError) {
                showCustomSnackBar(context, state.error, color: Palette.error);
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: SizedBox(
                  width: 1100, // العرض الثابت المناسب للويب
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 48),

                            // شبكة الحقول (Web Grid)
                            _buildFieldsGrid(),

                            const SizedBox(height: 60),

                            // زر التعديل مركزي
                            Center(
                              child:
                                  BlocBuilder<
                                    CreateGovernmentAgencyCubit,
                                    CreateGovernmentAgencyState
                                  >(
                                    builder: (context, state) {
                                      return CustomButton(
                                        onTap:
                                            state
                                                is UpdatGovernmentAgencyLoading
                                            ? null
                                            : _submitForm,
                                        text:
                                            state
                                                is UpdatGovernmentAgencyLoading
                                            ? "جارٍ حفظ التعديلات..."
                                            : 'تحديث البيانات الآن',
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
            Icon(Icons.edit_note_rounded, size: 40, color: Palette.primary),
            const SizedBox(width: 20),
            const Text(
              "تحديث معلومات الهيئة",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "قم بتعديل الحقول المطلوبة واضغط على تحديث لحفظ التغييرات في قاعدة البيانات.",
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
          crossAxisAlignment: CrossAxisAlignment.start,
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

  // الحقول الفردية
  Widget _buildNameField() => _buildTextField(
    controller: _nameController,
    labelText: 'اسم الهيئة الحكومية',
    icon: Icons.apartment_outlined,
    validator: (v) => v!.isEmpty ? 'الرجاء إدخال اسم الهيئة' : null,
  );

  Widget _buildCategoryField() => _buildTextField(
    controller: _categoryController,
    labelText: 'الفئة (وزارة، هيئة، مديرية...)',
    icon: Icons.category_outlined,
    validator: (v) => v!.isEmpty ? 'الرجاء إدخال الفئة' : null,
  );

  Widget _buildCityField() => _buildTextField(
    controller: _cityController,
    labelText: 'المدينة / المحافظة',
    icon: Icons.location_city_outlined,
    validator: (v) => v!.isEmpty ? 'الرجاء إدخال المدينة' : null,
  );

  Widget _buildAddressField() => _buildTextField(
    controller: _addressController,
    labelText: 'العنوان التفصيلي',
    icon: Icons.place_outlined,
    validator: (v) => v!.isEmpty ? 'الرجاء إدخال العنوان' : null,
  );

  Widget _buildPhoneField() => _buildTextField(
    controller: _phoneController,
    labelText: 'رقم هاتف التواصل',
    icon: Icons.phone_outlined,
    keyboardType: TextInputType.phone,
    validator: (v) => v!.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
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
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }
}
