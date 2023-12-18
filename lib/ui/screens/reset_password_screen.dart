import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/ui/controllers/set_password_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/pin_verification_screen.dart';
import 'package:task_manager/ui/screens/signup_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../widget/snack_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SetPasswordController _setPasswordController =
      Get.find<SetPasswordController>();

  bool hasError = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
            child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text('Set password',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                    'Minimum password length should be more than 8 letters',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Password required';
                    } else if (value!.length < 5) {
                      return 'Please enter at least 5 digits password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _confirmPasswordTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Password required';
                    } else if (value!.length < 5) {
                      return 'Please enter at least 5 digits password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  hasError ? errorMessage : '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: double.infinity,
                    child: GetBuilder<SetPasswordController>(
                        builder: (setPasswordController) {
                      return Visibility(
                        visible: setPasswordController.setPasswordInProgress ==
                            false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                            onPressed: _ResetPassword,
                            child: const Text('Confirm Password')),
                      );
                    })),
                const SizedBox(
                  height: 48,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    )));
  }

  Future<void> _ResetPassword() async {
    if (_formKey.currentState!.validate()) {
      final response = await _setPasswordController.ResetPassword(
          _passwordTEController.text.trim(),
          _confirmPasswordTEController.text.trim(),
          widget.email,
          widget.otp);

      if (response) {
        _clearTextFields();
        if (mounted) {
          showSnackMessage(context, _setPasswordController.successMessage);
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const LoginScreen()),
          //         (route) => false);
          Get.offAll(const LoginScreen());
        }
      } else {
        if (mounted) {
          showSnackMessage(context, _setPasswordController.errorMessage, true);
        }
      }
    }
  }

  void _clearTextFields() {
    _passwordTEController.clear();
    _confirmPasswordTEController.clear();
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
