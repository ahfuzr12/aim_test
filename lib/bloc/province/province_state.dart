import "package:aim_test/model/province.dart";
import "package:equatable/equatable.dart";

abstract class ProvinceState extends Equatable {
  const ProvinceState();

  @override
  List<Object?> get props => [];
}

class ProvinceInitial extends ProvinceState {}

class ProvinceLoading extends ProvinceState {}

class ProvinceLoaded extends ProvinceState {
  final List<Province> provinces;
  final Province? selected;

  const ProvinceLoaded({required this.provinces, this.selected});

  @override
  List<Object?> get props => [provinces, selected ?? ""];
}

class ProvinceError extends ProvinceState {
  final String message;

  const ProvinceError(this.message);

  @override
  List<Object?> get props => [message];
}
