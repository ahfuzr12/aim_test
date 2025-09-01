import "package:equatable/equatable.dart";

abstract class ProvinceEvent extends Equatable {
  const ProvinceEvent();

  @override
  List<Object?> get props => [];
}

class LoadProvinces extends ProvinceEvent {}

class SelectProvince extends ProvinceEvent {
  final String provinceCode;

  const SelectProvince(this.provinceCode);

  @override
  List<Object?> get props => [provinceCode];
}
