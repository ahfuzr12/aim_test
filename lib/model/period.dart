class Period {
  final String id;
  final String label;
  final bool isCurrent;

  Period({
    required this.id,
    required this.label,
    this.isCurrent = false,
  });
}
