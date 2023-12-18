import 'dart:async';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class PinVerificationController extends GetxController {
  bool _pinVerificationInProgress = false;
  StreamController<ErrorAnimationType>? errorController;
  bool _hasError = false;
  String _currentText = "";

  set currentText(String value) {
    _currentText = value;
  }

  String _errorMessage = '';

  bool get pinVerificationInProgress => _pinVerificationInProgress;
  bool get hasError => _hasError;
  String get currentText => _currentText;
  String get errorMessage => _errorMessage;

  Future<bool> pinVerification(String email, String pin) async {
    if (_currentText.length != 6) {
      errorController?.add(ErrorAnimationType.shake);
      _hasError = true;
      update();
      return false;
    } else {
      _hasError = false;
      _pinVerificationInProgress = true;
      update();

      final NetworkResponse response = await NetworkCaller().getRequest(
        Urls.pinVerification(email, pin),
      );

      _pinVerificationInProgress = false;
      update();

      if (response.isSuccess) {
        return true;
      } else {
        _errorMessage = response.jsonResponse?['data'] ?? 'Error message not available';
        update();
        return false;
      }
    }
  }
}
