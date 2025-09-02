import "package:aim_test/model/period.dart";
import "package:equatable/equatable.dart";

abstract class PeriodState extends Equatable {
  const PeriodState();

  @override
  List<Object?> get props => [];
}

class PeriodInitial extends PeriodState {}

class PeriodLoading extends PeriodState {}

class PeriodLoaded extends PeriodState {
  final List<Period> periods;
  final Period? selected;

  const PeriodLoaded({required this.periods, this.selected});

  @override
  List<Object?> get props => [periods, selected ?? ""];
}

class PeriodError extends PeriodState {
  final String message;

  const PeriodError(this.message);

  @override
  List<Object?> get props => [message];
}
