import 'package:compaintsystem/featuer/goverment_agencies/data/governmentagency_model.dart';
import 'package:compaintsystem/featuer/goverment_agencies/presentation/view/manager/get_cubit/get_governmentagency_state.dart';
import 'package:compaintsystem/featuer/goverment_agencies/repo/repo_governmentagency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GovernmentAgenciesCubit extends Cubit<GovernmentAgenciesState> {
  final GovernmentAgenciesRepo _repo;

  GovernmentAgenciesCubit(this._repo) : super(GovernmentAgenciesInitial());

  // تخزين معلومات الترقيم الحالية
  int _currentPage = 1;
  int _lastPage = 1;
  List<GovernmentAgency> _loadedAgencies = [];

  // 💡 جلب البيانات
  Future<void> fetchAgencies({bool loadMore = false}) async {
    // إذا كنا نحمل المزيد، يجب أن نزيد رقم الصفحة
    if (loadMore) {
      if (_currentPage >= _lastPage) {
        // لا يوجد المزيد من الصفحات
        return;
      }
      _currentPage++;
    } else {
      // للتحميل الأولي أو التحديث
      _currentPage = 1;
      _loadedAgencies = [];
      emit(GovernmentAgenciesLoading());
    }

    try {
      final newPage = await _repo.getAgencies(page: _currentPage);

      // تحديث القائمة المجمّعة
      _loadedAgencies.addAll(newPage.agencies);
      _lastPage = newPage.lastPage;

      emit(
        GovernmentAgenciesSuccess(
          agencies: _loadedAgencies,
          currentPage: _currentPage,
          lastPage: _lastPage,
        ),
      );
    } catch (e) {
      // إذا فشل التحميل، نعود إلى الصفحة السابقة إذا كنا في وضع loadMore
      if (loadMore) {
        _currentPage--;
      }
      emit(GovernmentAgenciesError(e.toString()));
    }
  }
}
