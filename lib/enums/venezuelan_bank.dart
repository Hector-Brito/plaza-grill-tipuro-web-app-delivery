enum VenezuelanBank {
  bancoDeVenezuela('0102', 'Banco de Venezuela'),
  banesco('0134', 'Banesco'),
  mercantil('0105', 'Banco Mercantil'),
  provincial('0108', 'Banco Provincial'),
  bancamiga('0172', 'Bancamiga'),
  bancaribe('0114', 'Bancaribe'),
  bnc('0191', 'BNC'),
  bicentenario('0175', 'Banco Bicentenario'),
  delTesoro('0163', 'Banco del Tesoro'),
  bfc('0151', 'BFC Banco Fondo Común'),
  banplus('0174', 'Banplus'),
  delSur('0157', 'DelSur'),
  exterior('0115', 'Banco Exterior');

  final String code;
  final String name;

  const VenezuelanBank(this.code, this.name);
}
