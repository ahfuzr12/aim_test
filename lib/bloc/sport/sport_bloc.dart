import "package:aim_test/model/sport.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "sport_event.dart";
import "sport_state.dart";

class SportBloc extends Bloc<SportEvent, SportState> {
  SportBloc() : super(SportInitial()) {
    on<LoadSports>((event, emit) async {
      emit(SportLoading());

      await Future.delayed(const Duration(seconds: 2)); // load from server simulation

      final sports = [
        Sport(id: "SPORT001", name: "Mini Soccer"),
        Sport(id: "SPORT002", name: "Basketball"),
        Sport(id: "SPORT003", name: "Futsal"),
      ];

      emit(SportLoaded(sports: sports, selected: sports.first));
    });

    on<SelectSport>((event, emit) {
      if (state is SportLoaded) {
        final current = state as SportLoaded;
        final selected = current.sports.firstWhere((s) => s.id == event.sportId);
        emit(SportLoaded(sports: current.sports, selected: selected));
      }
    });
  }
}
