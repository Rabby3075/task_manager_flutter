import 'package:get/get.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class RegistrationController extends GetxController {
  bool _signUpInProgress = false;

  bool get signUpInProgress => _signUpInProgress;
  String _successMessage = '';

  String get successMessage => _successMessage;
  String _failedMessage = '';

  String get failedMessage => _failedMessage;

  Future<bool> SignUp(String email, String firstName, String lastName,
      String mobile, String password) async {
    _signUpInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.registration, body: {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    });
    _signUpInProgress = false;
    update();
    if (response.isSuccess) {
      // _clearTextFields();
      //  if (mounted) {
      //    showSnackMessage(
      //        context, 'Account Creation Successfully');
      //  }
      _successMessage = 'Account Creation Successfully';
      return true;
    } else {
      // if (mounted) {
      //   showSnackMessage(
      //       context, 'Account Creation failed', true);
      // }
      _failedMessage = 'Account Creation failed';
    }
    return false;
  }
}
