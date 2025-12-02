import 'package:compaintsystem/featuer/complaint/data/complaint_model';

abstract class ComplaintsState {}

class ComplaintsInitial extends ComplaintsState {}

// حالة التحميل الأولي
class ComplaintsLoading extends ComplaintsState {}

// حالة النجاح في جلب البيانات
class ComplaintsSuccess extends ComplaintsState {
  final List<Complaint> complaints;
  final int currentPage;
  final int lastPage;
  final int total;

  ComplaintsSuccess({
    required this.complaints,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

// حالة الخطأ
class ComplaintsError extends ComplaintsState {
  final String error;
  ComplaintsError(this.error);
}
