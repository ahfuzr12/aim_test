import "package:aim_test/model/period.dart";
import "package:equatable/equatable.dart";

abstract class PeriodEvent extends Equatable {
  const PeriodEvent();

  @override
  List<Object> get props => [];
}

class LoadPeriods extends PeriodEvent {}

class SelectPeriod extends PeriodEvent {
  final Period period;

  const SelectPeriod(this.period);

  @override
  List<Object> get props => [period];
}
