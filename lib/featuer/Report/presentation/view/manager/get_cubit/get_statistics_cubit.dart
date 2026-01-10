import 'package:compaintsystem/featuer/Report/presentation/view/manager/get_cubit/get_statistics_state.dart';
import 'package:compaintsystem/featuer/Report/repo/repo_statistics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsCubit extends Cubit<StatsState> {
  final StatsRepository _repository;

  StatsCubit(this._repository) : super(StatsInitial());

  @override
  void emit(StatsState state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> loadStats() async {
    emit(StatsLoading());
    try {
      final stats = await _repository.fetchComplaintStats();
      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError('حدث خطأ غير متوقع: $e'));
    }
  }

  void refreshStats() {
    if (state is! StatsLoading) {
      loadStats();
    }
  }
}
