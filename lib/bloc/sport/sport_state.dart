import "package:aim_test/model/sport.dart";
import "package:equatable/equatable.dart";

abstract class SportState extends Equatable {
  const SportState();

  @override
  List<Object?> get props => [];
}

class SportInitial extends SportState {}

class SportLoading extends SportState {}

class SportLoaded extends SportState {
  final List<Sport> sports;
  final Sport? selected;

  const SportLoaded({required this.sports, this.selected});

  @override
  List<Object?> get props => [sports, selected ?? ""];
}

class SportError extends SportState {
  final String message;

  const SportError(this.message);

  @override
  List<Object?> get props => [message];
}
