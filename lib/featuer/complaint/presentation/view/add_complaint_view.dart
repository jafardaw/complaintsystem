import 'package:compaintsystem/core/style/color.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/core/widget/app_bar_widget.dart';
import 'package:compaintsystem/core/widget/custom_field.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/post_cubit/add_complaint_cubit.dart';
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/post_cubit/add_complaint_state.dart';
import 'package:compaintsystem/featuer/complaint/repo/coplaint_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<String> _priorities = ['high', 'medium', 'low'];

class NewComplaintView extends StatelessWidget {
  const NewComplaintView({super.key, required this.agencyId});
  final int agencyId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewComplaintCubit(ComplaintsRepo(ApiService())),
      child: NewComplaintForm(agencyId: agencyId),
    );
  }
}

class NewComplaintForm extends StatefulWidget {
  const NewComplaintForm({super.key, required this.agencyId});
  final int agencyId;

  @override
  State<NewComplaintForm> createState() => _NewComplaintFormState();
}

class _NewComplaintFormState extends State<NewComplaintForm> {
  final _formKey = GlobalKey<FormState>();

  // متحكمات الحقول
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  // القيم المحددة للقوائم المنسدلة
  String? _selectedType;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    // تعيين قيم افتراضية
    _selectedPriority = _priorities.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // إغلاق لوحة المفاتيح
      FocusScope.of(context).unfocus();

      final cubit = context.read<NewComplaintCubit>();

      cubit.submitComplaint(
        agencyId: widget.agencyId,
        type: _selectedType!,
        title: _titleController.text,
        description: _descriptionController.text,
        locationText: _locationController.text,
        priority: _selectedPriority!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        title: 'تسجيل شكوى جديدة',
        automaticallyImplyLeading: true,
      ),
      body: BlocListener<NewComplaintCubit, NewComplaintState>(
        listener: (context, state) {
          if (state is NewComplaintSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // تفريغ النموذج بعد النجاح
            _titleController.clear();
            _descriptionController.clear();
            _locationController.clear();
            // يمكن هنا إضافة Navigator.pop(context) للعودة للشاشة السابقة
          } else if (state is NewComplaintError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: ${state.error}'),
                backgroundColor: Palette.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                _buildDropdownField(
                  label: 'الأولوية',
                  value: _selectedPriority,
                  items: _priorities
                      .map(
                        (priority) => DropdownMenuItem<String>(
                          value: priority,
                          child: Text(priority),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  },
                ),
                const SizedBox(height: 30),
                // 3. عنوان الشكوى (Title)
                _buildTextField(
                  controller: _titleController,
                  label: 'عنوان الشكوى',
                  hint: 'أدخل عنواناً واضحاً وموجزاً',
                  validator: (value) =>
                      value!.isEmpty ? 'الرجاء إدخال عنوان الشكوى' : null,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _typeController,
                  label: 'نوع الشكوى',
                  hint: 'صف نوع المشكلة ',
                  // maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? 'الرجاء إدخال نوع الشكوى' : null,
                ),
                const SizedBox(height: 20),

                // 4. وصف الشكوى (Description)
                _buildTextField(
                  controller: _descriptionController,
                  label: 'وصف الشكوى',
                  hint: 'صف المشكلة بالتفصيل',
                  maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? 'الرجاء إدخال تفاصيل الشكوى' : null,
                ),

                const SizedBox(height: 20),

                // 5. الموقع (Location Text)
                _buildTextField(
                  controller: _locationController,
                  label: 'الموقع',
                  hint: 'أدخل اسم المدينة أو المنطقة',
                  validator: (value) =>
                      value!.isEmpty ? 'الرجاء إدخال الموقع' : null,
                ),
                const SizedBox(height: 20),

                // 6. الأولوية (Priority)

                // زر الإرسال
                BlocBuilder<NewComplaintCubit, NewComplaintState>(
                  builder: (context, state) {
                    return ElevatedButton.icon(
                      onPressed: state is NewComplaintLoading
                          ? null
                          : _submitForm,
                      icon: state is NewComplaintLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        state is NewComplaintLoading
                            ? 'جاري الإرسال...'
                            : 'تسجيل الشكوى',
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return CustomTextField(
      controller: controller,
      maxLines: maxLines,
      label: Text(label),
      validator: validator,
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Palette.primary, width: 2),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
