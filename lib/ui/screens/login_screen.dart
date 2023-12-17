import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/ui/controllers/login_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/signup_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import '../widget/snack_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController _loginController = Get.find<LoginController>();

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
                Text('Get Started With',
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
                GetBuilder<LoginController>(builder: (loginController) {
                  return Visibility(
                    visible: loginController.signinInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => login(),
                            child:
                                const Icon(Icons.arrow_circle_right_outlined))),
                  );
                }),
                const SizedBox(
                  height: 48,
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                            color: Colors.green.shade300, fontSize: 16),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                        child: const Text(
                          "Sign Up",
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

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // _signinInProgress = true;
    // update();  //set state
    // NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
    //     body: {
    //       "email": email.trim(),
    //       "password": password
    //     },isLogin: true);
    // _signinInProgress = false;
    // update();//set state
    final response = await _loginController.login(
        _emailTEController.text.trim(), _passwordTEController.text.trim());
    if (response /*.isSuccess*/) {
      // await AuthController.SaveUserInformation(
      //     response.jsonResponse?['token'],
      //     UserModel.fromJson(response.jsonResponse?['data']));
      // return true;
      if (mounted) {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=> MainBottomNavbar()));
        Get.offAll(const MainBottomNavbar());
      }
    } else {
      // if (response.statusCode == 401) {
      if (mounted) {
        showSnackMessage(context, _loginController.failureMessage, true);
      }
      // } else {
      //   // if (mounted) {
      //   //   showSnackMessage(context, response.errorMessage.toString(), true);
      //   // }
      //   _failedMessage = response.errorMessage.toString();
      // }
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
