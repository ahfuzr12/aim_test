import "package:equatable/equatable.dart";

abstract class SportEvent extends Equatable {
  const SportEvent();

  @override
  List<Object?> get props => [];
}

class LoadSports extends SportEvent {}

class SelectSport extends SportEvent {
  final String sportId;

  const SelectSport(this.sportId);

  @override
  List<Object?> get props => [sportId];
}
