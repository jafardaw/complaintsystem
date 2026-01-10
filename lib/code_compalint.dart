import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintTrackModel {
  final String referenceCode;
  final String status;
  final String lastUpdate;
  final String title;

  ComplaintTrackModel({
    required this.referenceCode,
    required this.status,
    required this.lastUpdate,
    required this.title,
  });

  factory ComplaintTrackModel.fromJson(Map<String, dynamic> json) {
    return ComplaintTrackModel(
      referenceCode: json['reference_code'],
      status: json['status'],
      lastUpdate: json['last_update'],
      title: json['title'],
    );
  }
}

class TrackRepository {
  final ApiService _apiService;
  TrackRepository(this._apiService);

  Future<ComplaintTrackModel> trackComplaint(String code) async {
    // نمرر الكود في المسار كما هو مطلوب
    final response = await _apiService.get('complaints/track/$code');
    return ComplaintTrackModel.fromJson(response.data);
  }
}

abstract class TrackState {}

class TrackInitial extends TrackState {}

class TrackLoading extends TrackState {}

class TrackSuccess extends TrackState {
  final ComplaintTrackModel complaint;
  TrackSuccess(this.complaint);
}

class TrackError extends TrackState {
  final String message;
  TrackError(this.message);
}

class TrackCubit extends Cubit<TrackState> {
  final TrackRepository _repo;
  TrackCubit(this._repo) : super(TrackInitial());

  @override
  void emit(TrackState state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> getTrackInfo(String code) async {
    emit(TrackLoading());
    try {
      final result = await _repo.trackComplaint(code);
      emit(TrackSuccess(result));
    } catch (e) {
      emit(TrackError("لم يتم العثور على شكوى بهذا الكود"));
    }
  }
}

class TrackComplaintScreen extends StatefulWidget {
  const TrackComplaintScreen({super.key});

  @override
  State<TrackComplaintScreen> createState() => _TrackComplaintScreenState();
}

class _TrackComplaintScreenState extends State<TrackComplaintScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackCubit(TrackRepository(ApiService())),
      child: Builder(
        builder: (context) {
          // هذا الـ context الآن يرى الـ TrackCubit
          return Scaffold(
            backgroundColor: const Color(0xFFF4F7FA),
            appBar: AppBar(
              title: const Text(
                "تتبع حالة الشكوى",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0.5,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // تمرير الـ context الصحيح (الخاص بالـ Builder)
                  _buildSearchBox(context),

                  const SizedBox(height: 30),

                  BlocBuilder<TrackCubit, TrackState>(
                    builder: (context, state) {
                      if (state is TrackLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TrackSuccess) {
                        return _buildTrackDetails(state.complaint);
                      } else if (state is TrackError) {
                        return _buildError(state.message);
                      }
                      return _buildEmptyState();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ويدجت صندوق البحث
  Widget _buildSearchBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "أدخل رمز المرجع للشكوى",
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              hintText: "مثال: CMP-2026-00001",
              prefixIcon: const Icon(Icons.confirmation_number_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_codeController.text.isNotEmpty) {
                  context.read<TrackCubit>().getTrackInfo(
                    _codeController.text.trim(),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "تتبع الآن",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عرض تفاصيل الشكوى عند النجاح
  Widget _buildTrackDetails(ComplaintTrackModel complaint) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade50, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          _buildStatusIcon(complaint.status),
          const SizedBox(height: 16),
          Text(
            _translateStatus(complaint.status),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            complaint.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Cairo'),
          ),
          const Divider(height: 40),
          _buildInfoRow("كود المرجع", complaint.referenceCode),
          _buildInfoRow("آخر تحديث", complaint.lastUpdate.substring(0, 10)),
        ],
      ),
    );
  }

  // واجهة الحالة الفارغة (قبل البحث)
  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(Icons.track_changes, size: 80, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        const Text(
          "بانتظار إدخال رمز الشكوى...",
          style: TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
        ),
      ],
    );
  }

  // أيقونة الحالة الملونة
  Widget _buildStatusIcon(String status) {
    IconData icon;
    Color color;
    switch (status.toLowerCase()) {
      case 'resolved':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'pending':
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        break;
      case 'in_progress':
        icon = Icons.sync;
        color = Colors.blue;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 50),
    );
  }

  // سطر المعلومات (Key - Value)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ترجمة الحالات للعربية
  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return "تم الحل";
      case 'pending':
        return "قيد الانتظار";
      case 'in_progress':
        return "جاري العمل عليها";
      default:
        return "غير معروف";
    }
  }

  // واجهة الخطأ عند عدم العثور على الشكوى
  Widget _buildError(String msg) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Cairo', color: Colors.red),
          ),
        ],
      ),
    );
  }
}
