class Province {
  static Comparator<Province> get codeComparator => ((a, b) => a.code.compareTo(b.code));
  static Comparator<Province> get nameComparator => ((a, b) => a.name.compareTo(b.name));

  final String code;
  final String name;

  Province({
    required this.code,
    required this.name,
  });

  String get acronym => _acronymByCode[code] ?? name;

  static const Map<String, String> _acronymByCode = {
    "11": "ACEH",
    "12": "SUMUT",
    "13": "SUMBAR",
    "14": "RIAU",
    "15": "JAMBI",
    "16": "SUMSEL",
    "17": "BENGKULU",
    "18": "LAMPUNG",
    "19": "BABEL",
    "21": "KEPRI",
    "31": "DKI",
    "32": "JABAR",
    "33": "JATENG",
    "34": "DIY",
    "35": "JATIM",
    "36": "BANTEN",
    "51": "BALI",
    "52": "NTB",
    "53": "NTT",
    "61": "KALBAR",
    "62": "KALTENG",
    "63": "KALSEL",
    "64": "KALTIM",
    "65": "KALTARA",
    "71": "SULUT",
    "72": "SULTENG",
    "73": "SULSEL",
    "74": "SULTRA",
    "75": "GOR",
    "76": "SULBAR",
    "81": "MALUKU",
    "82": "MALUT",
    "91": "PAPUA",
    "92": "PABAR",
    "96": "PABADAY",
    "95": "PAPEG",
    "93": "PASEL",
    "94": "PATENG",
  };

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json["code"] ?? "",
      name: json["name"] ?? "",
    );
  }
}
