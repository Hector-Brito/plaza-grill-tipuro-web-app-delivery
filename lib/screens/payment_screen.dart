import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _documentType = 'V';
  final _documentController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedBank;
  final _referenceController = TextEditingController();
  final _dateController = TextEditingController();
  
  bool _isLoading = false;

  final List<String> _banks = [
    '0102 - Banco de Venezuela',
    '0104 - Banco Venezolano de Crédito',
    '0105 - Banco Mercantil',
    '0108 - Banco Provincial',
    '0114 - Bancaribe',
    '0115 - Banco Exterior',
    '0134 - Banesco',
    '0151 - BFC Banco Fondo Común',
    '0156 - 100% Banco',
    '0172 - Bancamiga',
    '0174 - Banplus',
    '0191 - BNC Banco Nacional de Crédito',
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now());
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _documentController.dispose();
    _phoneController.dispose();
    _referenceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _verifyPayment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un banco de origen')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final provider = context.read<OrderProvider>();
    final formattedAmount = provider.totalVes.toStringAsFixed(2);
    
    final requestData = {
      "cedulaPagador": "$_documentType-${_documentController.text}",
      "telefonoPagador": _phoneController.text,
      "telefonoDestino": provider.pagoMovilTelefonoForm,
      "referencia": _referenceController.text,
      "fechaPago": _dateController.text,
      "importe": formattedAmount,
      "bancoOrigen": _selectedBank!.split(' - ')[0],
      "reqCed": "true"
    };

    final errorMessage = await provider.verifyPayment(requestData);

    setState(() {
      _isLoading = false;
    });

    if (errorMessage == null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
            reference: _referenceController.text,
            amount: formattedAmount,
          ),
        ),
      );
    } else if (errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B1B1B)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: const Color(0xFF1B1B1B), height: 2),
        ),
        title: const Text(
          'VERIFICAR PAGO MÓVIL',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFFB80035),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Validación de Datos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ingresa los datos de tu pago para validarlo al instante.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5C3F40),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Monto a pagar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF1B1B1B), width: 2),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'MONTO A PAGAR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1B1B1B),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${provider.totalVes.toStringAsFixed(2)} Bs',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1B1B1B),
                            ),
                          ),
                          Text(
                            '(\$${provider.totalUsd.toStringAsFixed(2)})',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5C3F40),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cédula
                    _buildLabel('CÉDULA O RIF DEL PAGADOR'),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF1B1B1B)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _documentType,
                              items: ['V', 'E', 'J', 'G'].map((type) => 
                                DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontWeight: FontWeight.w900)))
                              ).toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _documentType = v);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            controller: _documentController,
                            hint: 'Número de documento',
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Teléfono
                    _buildLabel('TELÉFONO DEL PAGADOR'),
                    _buildTextField(
                      controller: _phoneController,
                      hint: 'Ej: 04141234567',
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    // Banco
                    _buildLabel('BANCO DE ORIGEN'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF1B1B1B)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Selecciona el banco...', style: TextStyle(color: Color(0xFF906F70))),
                          value: _selectedBank,
                          items: _banks.map((bank) => 
                            DropdownMenuItem(value: bank, child: Text(bank, style: const TextStyle(fontSize: 14)))
                          ).toList(),
                          onChanged: (v) => setState(() => _selectedBank = v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        // Referencia
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('REFERENCIA'),
                              _buildTextField(
                                controller: _referenceController,
                                hint: 'Últimos 6 dígitos',
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                validator: (v) => v!.length < 4 ? 'Inválido' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Fecha
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('FECHA'),
                              _buildTextField(
                                controller: _dateController,
                                hint: 'DD/MM/AAAA',
                                keyboardType: TextInputType.datetime,
                                validator: (v) => v!.isEmpty ? 'Requerido' : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Botón Validar
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB80035),
                          disabledBackgroundColor: const Color(0xFFE5BDBE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFF1B1B1B), width: 2),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'VERIFICAR PAGO',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1B1B1B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF906F70), fontSize: 14),
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1B1B1B)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1B1B1B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB80035), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
