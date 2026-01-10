import 'package:compaintsystem/featuer/users/data/user_admin_model.dart';
import 'package:compaintsystem/featuer/users/presentation/view/manager/get_cubit/get_all_user_state.dart';
import 'package:compaintsystem/featuer/users/repo/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository _repository;

  @override
  void emit(UsersState state) {
    if (!isClosed) super.emit(state);
  }

  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isFetching = false; // مهم جداً لمنع تداخل الطلبات
  List<UserAdminModel> _allUsers = [];

  UsersCubit(this._repository) : super(UsersInitial());

  Future<void> fetchUsers({bool isRefresh = false}) async {
    // 1. منع الطلب إذا كنا نحمل حالياً أو لا يوجد بيانات إضافية
    if (_isFetching || (!isRefresh && !_hasMoreData)) return;

    _isFetching = true;

    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      // لا نفرغ القائمة فوراً لكي لا تظهر شاشة بيضاء، بل ننتظر نجاح الطلب
    }

    // إظهار التحميل الكامل فقط في الصفحة الأولى
    if (_currentPage == 1) emit(UsersLoading());

    try {
      final result = await _repository.getAllUsers(page: _currentPage);

      if (isRefresh) {
        _allUsers = result.users;
      } else {
        _allUsers.addAll(result.users);
      }

      _currentPage++;
      _hasMoreData = result.nextPageUrl != null;

      emit(UsersSuccess(List.from(_allUsers), hasMore: _hasMoreData));
    } catch (e) {
      emit(UsersError(e.toString()));
    } finally {
      _isFetching = false; // السماح بطلب جديد بعد الانتهاء
    }
  }

  void filterAndSearch({String? type, String? query}) {
    // الفلترة تتم على القائمة المحملة حالياً في الذاكرة
    if (_allUsers.isEmpty && state is! UsersSuccess) return;

    List<UserAdminModel> filtered = List.from(_allUsers);

    if (type != null && type != 'all') {
      filtered = filtered.where((u) => u.type == type).toList();
    }

    if (query != null && query.isNotEmpty) {
      filtered = filtered
          .where(
            (u) =>
                u.name.toLowerCase().contains(query.toLowerCase()) ||
                (u.email?.toLowerCase().contains(query.toLowerCase()) ?? false),
          )
          .toList();
    }

    emit(UsersSuccess(filtered, hasMore: _hasMoreData));
  }
}
