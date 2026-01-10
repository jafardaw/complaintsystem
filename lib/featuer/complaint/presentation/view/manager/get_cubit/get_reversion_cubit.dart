// Cubit
import 'package:compaintsystem/featuer/complaint/presentation/view/manager/get_cubit/get_reversion_state.dart';
import 'package:compaintsystem/featuer/complaint/repo/coplaint_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevisionsCubit extends Cubit<RevisionsState> {
  final ComplaintsRepo _repo;
  RevisionsCubit(this._repo) : super(RevisionsInitial());

  @override
  void emit(RevisionsState state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> fetchRevisions(int complaintId) async {
    emit(RevisionsLoading());
    try {
      final data = await _repo.getRevisions(complaintId);
      emit(RevisionsSuccess(data));
    } catch (e) {
      emit(RevisionsError(e.toString()));
    }
  }
}
