import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plaza_grill_tipuro/providers/cart_provider.dart';
import 'package:plaza_grill_tipuro/providers/payment_provider.dart';
import 'package:plaza_grill_tipuro/screens/success_screen.dart';
import 'package:plaza_grill_tipuro/widgets/shared/custom_text_field.dart';
import 'package:plaza_grill_tipuro/widgets/shared/custom_dropdown_field.dart';
import 'package:plaza_grill_tipuro/widgets/shared/custom_snackbar.dart';
import 'package:plaza_grill_tipuro/enums/venezuelan_bank.dart';
import 'package:plaza_grill_tipuro/enums/document_type.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();

  DocumentType _documentType = DocumentType.venezuelan;
  final _documentController = TextEditingController();
  final _phoneController = TextEditingController();
  VenezuelanBank? _selectedBank;
  final _referenceController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isLoading = false;

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
      CustomSnackBar.showError(context, 'Selecciona un banco de origen');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final cartProvider = context.read<CartProvider>();
    final paymentProvider = context.read<PaymentProvider>();
    final formattedAmount = cartProvider.totalVes.toStringAsFixed(2);

    final isSuccess = await paymentProvider.verifyPayment(
      payerID: "${_documentType.code}-${_documentController.text}",
      payerPhone: _phoneController.text,
      reference: _referenceController.text,
      amount: cartProvider.totalVes,
      originBankCode: _selectedBank!.code,
    );
    final errorMessage = paymentProvider.errorMessage;

    setState(() {
      _isLoading = false;
    });

    if (isSuccess && mounted) {
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
      CustomSnackBar.showError(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cédula
          const _PaymentFieldLabel('CÉDULA O RIF DEL PAGADOR'),
          Row(
            children: [
              CustomDropdownField<DocumentType>(
                value: _documentType,
                items: const [
                  DocumentType.venezuelan,
                  DocumentType.foreigner,
                  DocumentType.juridical,
                  DocumentType.governmental,
                ],
                itemBuilder: (type) => Text(
                  type.code,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                onChanged: (v) {
                  if (v != null) setState(() => _documentType = v);
                },
                isExpanded: false,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextField(
                  controller: _documentController,
                  hintText: 'Número de documento',
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Teléfono
          CustomTextField(
            controller: _phoneController,
            hintText: 'Ej: 04141234567',
            labelText: 'TELÉFONO DEL PAGADOR',
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),

          // Banco
          CustomDropdownField<VenezuelanBank>(
            value: _selectedBank,
            items: VenezuelanBank.values,
            hintText: 'Selecciona el banco...',
            labelText: 'BANCO DE ORIGEN',
            itemBuilder: (bank) => Text(
              '${bank.code} - ${bank.name}',
              style: const TextStyle(fontSize: 14),
            ),
            onChanged: (v) => setState(() => _selectedBank = v),
            isExpanded: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Referencia
              Expanded(
                flex: 2,
                child: CustomTextField(
                  controller: _referenceController,
                  hintText: 'Últimos 6 dígitos',
                  labelText: 'REFERENCIA',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (v) => v!.length < 4 ? 'Inválido' : null,
                ),
              ),
              const SizedBox(width: 12),
              // Fecha
              Expanded(
                flex: 2,
                child: CustomTextField(
                  controller: _dateController,
                  hintText: 'DD/MM/AAAA',
                  labelText: 'FECHA',
                  readOnly: true,
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: AppTheme.darkText,
                    size: 18,
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppTheme.primaryRed,
                              onPrimary: Colors.white,
                              onSurface: AppTheme.darkText,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.primaryRed,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        _dateController.text = _formatDate(picked);
                      });
                    }
                  },
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
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
                backgroundColor: AppTheme.primaryRed,
                disabledBackgroundColor: AppTheme.disabledBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: AppTheme.darkText,
                    width: 2,
                  ),
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
        ],
      ),
    );
  }
}

class _PaymentFieldLabel extends StatelessWidget {
  final String text;

  const _PaymentFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppTheme.darkText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
