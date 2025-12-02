import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_coplaint_state.dart';
import 'package:compaintsystem/featuer/complaint/repo/coplaint_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final ComplaintsRepo _repo;
  int _currentPage = 1;
  int _lastPage = 1;

  ComplaintsCubit(this._repo) : super(ComplaintsInitial());

  // دالة جلب الشكاوى
  Future<void> fetchComplaints({int page = 1, required int agencyid}) async {
    if (page == 1) {
      emit(ComplaintsLoading());
    }

    try {
      final response = await _repo.fetchComplaints(
        page: page,
        agencyid: agencyid,
      );

      _currentPage = response.currentPage;
      _lastPage = response.lastPage;

      emit(
        ComplaintsSuccess(
          complaints: response.complaints,
          currentPage: _currentPage,
          lastPage: _lastPage,
          total: response.total,
        ),
      );
    } catch (e) {
      emit(ComplaintsError(e.toString()));
    }
  }

  // التنقل للصفحة التالية
  nextPage(int agencyid) {
    if (_currentPage < _lastPage) {
      fetchComplaints(page: _currentPage + 1, agencyid: agencyid);
    }
  }

  // التنقل للصفحة السابقة
  previousPage(int agencyid) {
    if (_currentPage > 1) {
      fetchComplaints(page: _currentPage - 1, agencyid: agencyid);
    }
  }
}
