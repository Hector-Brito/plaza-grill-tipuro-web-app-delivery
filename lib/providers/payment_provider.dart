import 'package:flutter/foundation.dart';
import 'package:plaza_grill_tipuro/enums/payment_status.dart';
import 'package:plaza_grill_tipuro/exceptions/api_exception.dart';
import 'package:plaza_grill_tipuro/models/payment.dart';
import 'package:plaza_grill_tipuro/services/bdv_service.dart';

class PaymentProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  final BdvService _bdvService = BdvService();

  Future<bool> verifyPayment({
    required String payerID,
    required String payerPhone,
    required String reference,
    required double amount,
    required String originBankCode,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final Payment payment = await _bdvService.verifyMobilePay(
        payerID: payerID,
        payerPhone: payerPhone,
        reference: reference,
        amount: amount,
        originBankCode: originBankCode,
      );

      if (payment.status == PaymentStatus.completed) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = payment.bankMessage;
      }
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
    return false;
  }
}
