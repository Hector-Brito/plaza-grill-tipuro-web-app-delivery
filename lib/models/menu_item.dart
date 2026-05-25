class MenuItem {
  final String name;
  final String description;
  final double priceUsd;
  final String category;
  int quantity;
  String note;

  MenuItem({
    required this.name,
    required this.description,
    required this.priceUsd,
    required this.category,
    this.quantity = 0,
    this.note = '',
  });

  double get totalUsd => priceUsd * quantity;
}
