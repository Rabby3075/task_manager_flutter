import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/controllers/registration_controller.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/snack_message.dart';

import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegistrationController _registrationController = Get.find<RegistrationController>();


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
                Text('Join with us',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _emailTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your valid email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _firstNameTEController,
                  decoration: const InputDecoration(
                    hintText: 'First name',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your First Name';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!)) {
                      return 'First Name must contain only alphabetic letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(
                    hintText: 'Last name',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Last Name';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!)) {
                      return 'Last Name must contain only alphabetic letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Phone number required';
                      } else if (value?.length != 11) {
                        return 'Please enter a 11 digit phone number';
                      } else if (int.tryParse(value!) == null) {
                        return 'Please give only number';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
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
                    }),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: double.infinity,
                    child: GetBuilder<RegistrationController>(
                      builder: (registrationController) {
                        return Visibility(
                          visible: registrationController.signUpInProgress == false,
                          replacement: Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                              onPressed: _SignUp,
                              child: const Icon(Icons.arrow_circle_right_outlined)),
                        );
                      }
                    )),
                const SizedBox(
                  height: 48,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
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
  Future<void>_SignUp() async {
    if (_formKey.currentState!.validate()) {
      // _signUpInProgress = true;
      // if(mounted){
      //   setState(() {});
      // }
      // final NetworkResponse response =
      // await NetworkCaller()
      //     .postRequest(Urls.registration,body: {
      //   "email":_emailTEController.text.trim(),
      //   "firstName":_firstNameTEController.text.trim(),
      //   "lastName":_lastNameTEController.text.trim(),
      //   "mobile":_mobileTEController.text.trim(),
      //   "password":_passwordTEController.text,
      // });
      // _signUpInProgress = false;
      // if(mounted){
      //   setState(() {});
      // }
      final response = await _registrationController.SignUp(_emailTEController.text.trim(), _firstNameTEController.text.trim(), _lastNameTEController.text.trim(), _mobileTEController.text.trim(), _passwordTEController.text.trim());
      if (response) {
        _clearTextFields();
        if (mounted) {
          showSnackMessage(
              context, _registrationController.successMessage);
        }
      } else {
        if (mounted) {
          showSnackMessage(
              context, _registrationController.failedMessage, true);
        }
      }
    }
  }
  void _clearTextFields(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
