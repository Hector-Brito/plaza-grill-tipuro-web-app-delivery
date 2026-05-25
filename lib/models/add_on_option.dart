class AddOnOption {
  final String id;
  final String name;
  final double price;
  bool isSelected;

  AddOnOption({
    required this.id,
    required this.name,
    this.price = 0.0,
    this.isSelected = false,
  });
}
