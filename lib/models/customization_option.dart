class CustomizationOption {
  final String id;
  final String name;
  bool isRemoved;

  CustomizationOption({
    required this.id,
    required this.name,
    this.isRemoved = false,
  });
}
