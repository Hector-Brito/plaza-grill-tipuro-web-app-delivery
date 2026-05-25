enum BdvResponse {
  alreadyConciliated(
      "La consulta realizada es exitosa. El movimiento ya fue conciliado anteriormente.",
      isSuccess: false),
  notExists("No se pudo validar el movimiento : Registro solicitado no existe",
      isSuccess: false),
  invalidRef("La referencia debe tener al menos 4 digitos", isSuccess: false),
  invalidId("La cedula debe tener al menos 5 digitos", isSuccess: false),
  invalidBank("Por favor, selecciona tu banco de origen", isSuccess: false),
  invalidPhone("El numero de telefono debe tener al menos 10 digitos",
      isSuccess: false),
  success("Transacci¿¿n realizada", isSuccess: true),
  unknown("Error desconocido en el banco", isSuccess: false);

  final String message;
  final bool isSuccess;

  const BdvResponse(this.message, {required this.isSuccess});

  static BdvResponse fromMessage(String msg) {
    String normalize(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    final normalizedInput = normalize(msg);

    return BdvResponse.values.firstWhere(
      (e) => normalizedInput.contains(normalize(e.message)),
      orElse: () => BdvResponse.unknown,
    );
  }
}
