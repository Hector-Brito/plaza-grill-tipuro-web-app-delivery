import 'package:plaza_grill_tipuro/enums/payment_status.dart';
import 'package:plaza_grill_tipuro/enums/bdv_response.dart';

class Payment {
  final String reference;
  final PaymentStatus status;
  final DateTime confirmedAt;
  final double amount;
  final String bankMessage;

  Payment({
    required this.status,
    required this.reference,
    required this.confirmedAt,
    required this.amount,
    required this.bankMessage,
  });

  factory Payment.fromBankResponse(Map<String, dynamic> json,
      String originalReference, double originalAmount) {
    final String msg = json["message"] ?? "";
    final bdvResponse = BdvResponse.fromMessage(msg);
    final data = json["data"] ?? {};

    return Payment(
        reference: data["referencia"]?.toString() ?? originalReference,
        amount: originalAmount,
        status: bdvResponse.isSuccess
            ? PaymentStatus.completed
            : PaymentStatus.failed,
        bankMessage: bdvResponse.message,
        confirmedAt: DateTime.now());
  }
}
