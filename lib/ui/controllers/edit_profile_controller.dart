import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class ProfileEditController extends GetxController {
  bool _updateProfileInProgress = false;

  bool get updateProfileInProgress => _updateProfileInProgress;
  String _successMessage = '';

  String get successMessage => _successMessage;
  String _failedMessage = '';

  String get failedMessage => _failedMessage;
  XFile? _photo;
  set photo(XFile? value) {
    _photo = value;
  }
  XFile? get photo => _photo;

  Future<bool> ProfileUpdate(String email, String firstName, String lastName,
      String mobile, String password) async {
    Map<String, dynamic> inputData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      //"password":_passwordTEController.text,
    };
    String? photoInBase64;
    _updateProfileInProgress = true;
    update();
    if (password.isNotEmpty) {
      inputData['password'] = password;
    }
    if (_photo != null) {
      List<int> imageBytes = await _photo!.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      inputData['photo'] = photoInBase64;
    }
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.updateProfile, body: inputData);
    _updateProfileInProgress = false;
    update();
    if (response.isSuccess) {
      Get.find<AuthController>().UpdateUserInformation(UserModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          mobile: mobile,
          photo: photoInBase64 ?? Get.find<AuthController>().user?.photo));
      // if(mounted) {
      //   showSnackMessage(context, 'Profile Update Successfully');
      // }
      _successMessage = 'Profile Update Successfully';
      return true;
    } else {
      // if (mounted) {
      //   showSnackMessage(context, 'Profile Update Failed', true);
      // }
      _failedMessage = 'Profile Update Failed';
    }
    return false;
  }
}
