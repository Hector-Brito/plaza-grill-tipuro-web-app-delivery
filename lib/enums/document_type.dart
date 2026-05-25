enum DocumentType {
  venezuelan('V', 'Venezolano'),
  foreigner('E', 'Extranjero'),
  juridical('J', 'Jurídico'),
  governmental('G', 'Gubernamental'),
  communal('C', 'Comunal'),
  passport('P', 'Pasaporte');

  final String code;
  final String label;
  const DocumentType(this.code, this.label);

  static DocumentType fromCode(String code) {
    return DocumentType.values.firstWhere(
      (e) => e.code == code.toUpperCase(),
      orElse: () => DocumentType.venezuelan,
    );
  }
}
