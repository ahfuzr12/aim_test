import "package:equatable/equatable.dart";

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeaderboard extends LeaderboardEvent {}

class FilterLeaderboard extends LeaderboardEvent {
  final String? sportId;
  final String? provinceCode;
  final String? periodId;

  const FilterLeaderboard({this.sportId, this.provinceCode, this.periodId});

  @override
  List<Object?> get props => [sportId, provinceCode, periodId];
}
