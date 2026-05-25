class DeliveryZone {
  final String name;
  final double costUsd;

  const DeliveryZone({required this.name, required this.costUsd});

  String get displayCost {
    if (costUsd <= 0) return '\$0';
    return '\$${costUsd.toStringAsFixed(costUsd == costUsd.roundToDouble() ? 0 : 1)}';
  }
}
