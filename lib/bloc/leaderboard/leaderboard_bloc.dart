import "package:aim_test/model/community.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "leaderboard_event.dart";
import "leaderboard_state.dart";

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  List<Community> _allCommunities = [];

  LeaderboardBloc() : super(LeaderboardInitial()) {
    on<LoadLeaderboard>((event, emit) async {
      emit(LeaderboardLoading());

      await Future.delayed(const Duration(seconds: 1)); // load from server simulation

      final dummyData = [
        Community(
          name: "Purple",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
          points: 203,
          rank: 1,
          sportId: "SPORT001",
        ),
        Community(
          name: "Teal",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIzkMEj_Lw4C24VVJSy1P_Ahu9F_7fLnt_qw&s",
          points: 202,
          rank: 2,
          sportId: "SPORT001",
        ),
        Community(
          name: "Pinky",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl:
              "https://pngdownload.io/wp-content/uploads/2023/12/Reddit-Logo-emblem-of-the-online-platform-transparent-png-image-jpg.webp",
          points: 201,
          rank: 3,
          sportId: "SPORT001",
        ),
        Community(
          name: "Bleu House",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl:
              "https://static.vecteezy.com/system/resources/previews/023/654/784/non_2x/golden-logo-template-free-png.png",
          points: 105,
          rank: 4,
          sportId: "SPORT001",
        ),
        Community(
          name: "UFO Enthusiast",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl:
              "https://thumbs.dreamstime.com/b/best-quality-illustration-famous-superman-logo-isolated-transparent-background-high-detailed-original-version-104743115.jpg",
          points: 100,
          rank: 5,
          sportId: "SPORT001",
        ),
        Community(
          name: "Grizzly Community",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnsepRSZ2Dfxh6ZdBFeZoCsm_KW5WwCFn2qw&s",
          points: 96,
          rank: 6,
          sportId: "SPORT001",
        ),
        Community(
          name: "Komunitas Kawan AYO",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTOYoE1HtHVYNaRM8o6cY7VKg1kkQPkdx7iA&s",
          points: 90,
          rank: 7,
          sportId: "SPORT001",
        ),
        Community(
          name: "Komunitas Semangat",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl:
              "https://static.vecteezy.com/system/resources/previews/023/654/784/non_2x/golden-logo-template-free-png.png",
          points: 87,
          rank: 8,
          sportId: "SPORT001",
        ),
        Community(
          name: "Aye Komunitas",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIzkMEj_Lw4C24VVJSy1P_Ahu9F_7fLnt_qw&s",
          points: 81,
          rank: 9,
          sportId: "SPORT001",
        ),
        Community(
          name: "Go Komunitas Ye",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
          points: 77,
          rank: 10,
          sportId: "SPORT001",
        ),

        // Sport 2
        Community(
          name: "Komunitas Kawan AYO",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTOYoE1HtHVYNaRM8o6cY7VKg1kkQPkdx7iA&s",
          points: 90,
          rank: 1,
          sportId: "SPORT002",
        ),
        Community(
          name: "Komunitas Semangat",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl:
              "https://static.vecteezy.com/system/resources/previews/023/654/784/non_2x/golden-logo-template-free-png.png",
          points: 87,
          rank: 2,
          sportId: "SPORT002",
        ),
        Community(
          name: "Aye Komunitas",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIzkMEj_Lw4C24VVJSy1P_Ahu9F_7fLnt_qw&s",
          points: 81,
          rank: 3,
          sportId: "SPORT002",
        ),
        Community(
          name: "Go Komunitas Ye",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
          points: 77,
          rank: 4,
          sportId: "SPORT002",
        ),

        // Sport 3
        Community(
          name: "Purple",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0SBMZfIwGVGw7tKsZjS6JfnQGECTm6luDaw&s",
          points: 203,
          rank: 1,
          sportId: "SPORT003",
        ),
        Community(
          name: "Teal",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIzkMEj_Lw4C24VVJSy1P_Ahu9F_7fLnt_qw&s",
          points: 202,
          rank: 2,
          sportId: "SPORT003",
        ),
        Community(
          name: "Pinky",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl:
              "https://pngdownload.io/wp-content/uploads/2023/12/Reddit-Logo-emblem-of-the-online-platform-transparent-png-image-jpg.webp",
          points: 201,
          rank: 3,
          sportId: "SPORT003",
        ),
        Community(
          name: "Bleu House",
          periodId: "current_season",
          province: "Aceh",
          provinceCode: "11",
          logoUrl:
              "https://static.vecteezy.com/system/resources/previews/023/654/784/non_2x/golden-logo-template-free-png.png",
          points: 105,
          rank: 4,
          sportId: "SPORT003",
        ),
      ];

      _allCommunities = dummyData;
      emit(LeaderboardLoaded(dummyData.take(10).toList()));
    });

    on<FilterLeaderboard>((event, emit) {
      if (_allCommunities.isEmpty) return;

      var filtered = _allCommunities;

      if (event.sportId != null && event.sportId!.isNotEmpty) {
        filtered = filtered.where((c) => c.sportId == event.sportId).toList();
      }
      if (event.provinceCode != null && event.provinceCode!.isNotEmpty) {
        filtered = filtered.where((c) => c.provinceCode == event.provinceCode).toList();
      }
      if (event.periodId != null && event.periodId!.isNotEmpty) {
        filtered = filtered.where((c) => c.periodId == event.periodId).toList();
      }

      emit(LeaderboardLoaded(filtered));
    });
  }
}
