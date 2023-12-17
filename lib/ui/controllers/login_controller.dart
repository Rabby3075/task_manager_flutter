import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController{
  bool _signinInProgress = false;
  String _failedMessage = '';
  bool get signinInProgress =>_signinInProgress;
  String get failureMessage => _failedMessage;

  Future<bool> login(String email, String password) async {
      _signinInProgress = true;
      update();  //set state
      NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
          body: {
            "email": email.trim(),
            "password": password
          },isLogin: true);
      _signinInProgress = false;
      update();//set state
      if (response.isSuccess) {
        await AuthController.SaveUserInformation(
            response.jsonResponse?['token'],
            UserModel.fromJson(response.jsonResponse?['data']));
        return true;
       // _clearTextFields();
       //  if (mounted) {
       //    Navigator.push(
       //        context,
       //        MaterialPageRoute(
       //            builder: (context) => const MainBottomNavbar()));
       //  }
      } else {
        if (response.statusCode == 401) {
          // if (mounted) {
          //   showSnackMessage(context, 'Please check your email/password', true);
          // }
          _failedMessage = 'Please check your email/password';
        } else {
          // if (mounted) {
          //   showSnackMessage(context, response.errorMessage.toString(), true);
          // }
          _failedMessage = response.errorMessage.toString();
        }
      }
      return false;
  }
}