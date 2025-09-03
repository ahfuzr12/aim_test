import "package:equatable/equatable.dart";

abstract class PeriodEvent extends Equatable {
  const PeriodEvent();

  @override
  List<Object?> get props => [];
}

class LoadPeriods extends PeriodEvent {}

class SelectPeriod extends PeriodEvent {
  final String id;

  const SelectPeriod(this.id);

  @override
  List<Object?> get props => [id];
}
