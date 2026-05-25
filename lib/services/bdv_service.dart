import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plaza_grill_tipuro/enums/bdv_response.dart';
import 'package:plaza_grill_tipuro/exceptions/api_exception.dart';
import 'package:plaza_grill_tipuro/models/payment.dart';

class BdvService {
  final _dio = Dio();

  /// Verifies a Pagomóvil transaction movement via the Banco de Venezuela (BDV) API.
  ///
  /// This method maps internal English parameters to the bank's Spanish API requirements:
  /// - [payerID] -> 'cedulaPagador' (e.g., V12345678)
  /// - [payerPhone] -> 'telefonoPagador'
  /// - [reference] -> 'referencia' (Transaction reference number)
  /// - [amount] -> 'importe' (Will be formatted to string with "." decimals)
  /// - [originBankCode] -> 'bancoOrigen' (Bank's 4-digit code, e.g., 0102)
  /// - [destinationPhone] -> 'telefonoDestino' (Merchant's registered phone)
  Future<Payment> verifyMobilePay({
    required String payerID,
    required String payerPhone,
    required String reference,
    required double amount,
    required String originBankCode,
    String? destinationPhone,
    String? apiKey,
    String? apiEndpoint,
  }) async {
    try {
      final String resolvedDestinationPhone =
          destinationPhone ?? dotenv.env['TELEFONO_DESTINO'] ?? '04128798008';
      final String resolvedApiKey =
          apiKey ??
          dotenv.env['BDV_API_KEY'] ??
          '9576945A28CC7EA4F67FF8179CC77ED1';
      final String resolvedApiEndpoint =
          apiEndpoint ??
          dotenv.env['BDV_API_ENDPOINT'] ??
          'https://bdvconciliacion.banvenez.com/getMovement';

      final String paymentDate = DateTime.now().toIso8601String().split("T")[0];
      final String formattedAmount = "1.00"; //amount.toStringAsFixed(2);

      final bool requiresIDValidation = originBankCode == "0102";

      final Map<String, dynamic> requestData = {
        "cedulaPagador": payerID,
        "telefonoPagador": payerPhone,
        "telefonoDestino": resolvedDestinationPhone,
        "referencia": reference,
        "fechaPago": paymentDate,
        "importe": formattedAmount,
        "bancoOrigen": originBankCode,
        "reqCed": requiresIDValidation.toString(),
      };

      final response = await _dio.post(
        resolvedApiEndpoint,
        data: requestData,
        options: Options(
          headers: {
            "X-Api-Key": resolvedApiKey,
            "Content-Type": "application/json",
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      return Payment.fromBankResponse(response.data, reference, amount);
    } on DioException catch (err) {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          throw ApiException(
            "El servidor tardó demasiado en responder. Revisa tu conexión.",
          );

        case DioExceptionType.connectionError:
          throw ApiException(
            "Parece que no tienes conexión a internet. Revisa tu señal e inténtalo de nuevo.",
          );

        case DioExceptionType.badResponse:
          final data = err.response?.data;
          final message = data is Map<String, dynamic>
              ? (data["message"] ?? "Error de validacion en el banco")
              : "Error de validacion en el banco";
          final bdvResponse = BdvResponse.fromMessage(message.toString());

          final finalMessage = bdvResponse.message;
          throw ApiException(
            finalMessage,
            statusCode: err.response?.statusCode,
          );
        case DioExceptionType.cancel:
          throw ApiException("Petición cancelada");
        default:
          throw ApiException("Error de red: $err");
      }
    } catch (err) {
      throw ApiException(
        "Error inesperado al procesar los datos: $err",
        statusCode: HttpStatus.internalServerError,
      );
    }
  }
}
