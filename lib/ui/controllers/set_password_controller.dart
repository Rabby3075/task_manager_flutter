import 'package:get/get.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class SetPasswordController extends GetxController {
  bool _setPasswordInProgress = false;
  String _successMessage = '';
  String _errorMessage = '';
  bool _hasError = false;

  bool get hasError => _hasError;

  bool get setPasswordInProgress => _setPasswordInProgress;

  String get successMessage => _successMessage;

  String get errorMessage => _errorMessage;

  Future<bool> ResetPassword(
      String password, String confirmPassword, String email, String otp) async {
    if (password == confirmPassword) {
      _setPasswordInProgress = true;
      _hasError = false;
      update();
      final NetworkResponse response = await NetworkCaller().postRequest(
          Urls.recoveryPassword,
          body: {"email": email, "OTP": otp, "password": password});
      _setPasswordInProgress = false;
      update();
      if (response.isSuccess) {
        // if (mounted) {
        //   showSnackMessage(
        //       context, 'Password reset successfully');
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => const LoginScreen()),
        //           (route) => false);
        // }
        _successMessage = 'Password reset successfully';
        return true;
      } else {
        // if (mounted) {
        //   showSnackMessage(
        //       context, 'Failed to reset the password', true);
        // }
        _errorMessage = 'Failed to reset the password';
      }
    } else {
      _hasError = true;
      _errorMessage = "Password and Confirm password doesn't match";
      update();
    }
    return false;
  }
}
