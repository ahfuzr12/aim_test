import "dart:convert";
import "package:aim_test/model/province.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:http/http.dart" as http;
import "province_event.dart";
import "province_state.dart";

class ProvinceBloc extends Bloc<ProvinceEvent, ProvinceState> {
  ProvinceBloc() : super(ProvinceInitial()) {
    on<LoadProvinces>((event, emit) async {
      emit(ProvinceLoading());
      try {
        final response = await http.get(
          Uri.parse("https://wilayah.id/api/provinces.json"),
        );

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          final List data = body["data"];

          final provinces = data.map((e) => Province.fromJson(e)).toList();

          emit(ProvinceLoaded(provinces: List<Province>.from(provinces), selected: provinces.first));
        } else {
          emit(const ProvinceError("Failed to load provinces"));
        }
      } catch (e) {
        emit(ProvinceError(e.toString()));
      }
    });

    on<SelectProvince>((event, emit) {
      if (state is ProvinceLoaded) {
        final current = state as ProvinceLoaded;
        final selected = current.provinces.firstWhere((p) => p.code == event.provinceCode);
        emit(ProvinceLoaded(provinces: current.provinces, selected: selected));
      }
    });
  }
}
