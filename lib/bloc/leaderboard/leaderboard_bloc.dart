import "package:aim_test/model/community.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "leaderboard_event.dart";
import "leaderboard_state.dart";

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc() : super(LeaderboardInitial()) {
    on<LoadLeaderboard>((event, emit) async {
      emit(LeaderboardLoading());

      await Future.delayed(const Duration(seconds: 2)); // load from server simulation

      final dummyData = [
        Community(name: "Purple", city: "Surabaya", points: 201, rank: 1),
        Community(name: "Teal", city: "Surabaya", points: 201, rank: 2),
        Community(name: "Pinky", city: "Surabaya", points: 201, rank: 3),
        Community(name: "Bleu House", city: "Surabaya", points: 105, rank: 4),
        Community(name: "UFO Enthusiast", city: "Surabaya", points: 100, rank: 5),
        Community(name: "Grizzly Community", city: "Surabaya", points: 96, rank: 6),
        Community(name: "Komunitas Kawan AYO", city: "Surabaya", points: 90, rank: 7),
      ];

      emit(LeaderboardLoaded(dummyData));
    });
  }
}
