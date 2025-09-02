import "package:aim_test/model/community.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "leaderboard_event.dart";
import "leaderboard_state.dart";

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc() : super(LeaderboardInitial()) {
    on<LoadLeaderboard>((event, emit) async {
      emit(LeaderboardLoading());

      await Future.delayed(const Duration(seconds: 1)); // load from server simulation

      final dummyData = [
        Community(
            name: "Purple",
            city: "Surabaya",
            logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
            points: 201,
            rank: 1),
        Community(
            name: "Teal",
            city: "Surabaya",
            logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIzkMEj_Lw4C24VVJSy1P_Ahu9F_7fLnt_qw&s",
            points: 201,
            rank: 2),
        Community(
            name: "Pinky",
            city: "Surabaya",
            logoUrl:
                "https://pngdownload.io/wp-content/uploads/2023/12/Reddit-Logo-emblem-of-the-online-platform-transparent-png-image-jpg.webp",
            points: 201,
            rank: 3),
        Community(
            name: "Bleu House",
            city: "Surabaya",
            logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
            points: 105,
            rank: 4),
        Community(
            name: "UFO Enthusiast",
            city: "Surabaya",
            logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
            points: 100,
            rank: 5),
        Community(
            name: "Grizzly Community",
            city: "Surabaya",
            logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
            points: 96,
            rank: 6),
        Community(
            name: "Komunitas Kawan AYO",
            city: "Surabaya",
            logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
            points: 90,
            rank: 7),
      ];

      emit(LeaderboardLoaded(dummyData));
    });
  }
}
