import "package:aim_test/bloc/period/period_event.dart";
import "package:aim_test/bloc/period/period_state.dart";
import "package:aim_test/model/period.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PeriodBloc extends Bloc<PeriodEvent, PeriodState> {
  Period? _selected;

  PeriodBloc() : super(PeriodInitial()) {
    on<LoadPeriods>((event, emit) async {
      emit(PeriodLoading());

      await Future.delayed(const Duration(seconds: 1)); // load from server simulation

      List<Period> periods = [
        Period(id: "all", label: "All Time"),
        Period(id: "current_season", label: "Januari - Juli 2025", isCurrent: true),
        Period(id: "oct-dec-2024", label: "Oktober - Desember 2024"),
        Period(id: "jul-aug-2024", label: "Juli - Agustus 2024"),
      ];

      Period selected = _selected ?? periods.firstWhere((e) => e.isCurrent);

      emit(PeriodLoaded(periods: periods, selected: selected));
    });

    on<SelectPeriod>((event, emit) {
      if (state is PeriodLoaded) {
        final current = state as PeriodLoaded;
        final selected = current.periods.firstWhere((s) => s.id == event.period.id);

        _selected = selected;
        emit(PeriodLoaded(periods: current.periods, selected: selected));
      }
    });
  }
}
