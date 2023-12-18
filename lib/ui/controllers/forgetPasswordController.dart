import 'package:get/get.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class ForgetPasswordController extends GetxController{
  bool _forgetPasswordInProgress = false;

  bool get forgetPasswordInProgress => _forgetPasswordInProgress;
  String _failedMessage = '';
  Future<bool> recoveryVerifyEmail(String email) async {
      _forgetPasswordInProgress = true;
      update();
      final NetworkResponse response = await NetworkCaller()
          .getRequest(Urls.recoverVerifyEmail(email));
      _forgetPasswordInProgress = false;
      update();
      if (response.isSuccess) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PinVerificationScreen(
        //             email: _emailTEController.text.trim())));
        return true;
      } else {
        _failedMessage = response.jsonResponse?['data'] ?? 'Error message not available';
      }
      return false;
  }

  String get failedMessage => _failedMessage;
}