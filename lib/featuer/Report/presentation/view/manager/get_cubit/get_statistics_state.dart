// lib/cubits/stats_state.dart
import 'package:compaintsystem/featuer/Report/data/statistics_model.dart';
import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final ComplaintStats stats;

  const StatsLoaded(this.stats);

  @override
  List<Object> get props => [stats];
}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object> get props => [message];
}
