class MenuItem {
  final String name;
  final String description;
  final double price;
  final String category;
  int quantity;
  String note;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.quantity = 0,
    this.note = '',
  });

  double get totalPrice => price * quantity;
}
