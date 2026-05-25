class SauceOption {
  final String name;
  final double extraCostUsd;
  bool selected;

  SauceOption({
    required this.name,
    this.extraCostUsd = 0.0,
    this.selected = false,
  });

  String get displayPrice {
    if (extraCostUsd <= 0) return 'Gratis';
    return '+\$${extraCostUsd.toStringAsFixed(2)}';
  }
}
