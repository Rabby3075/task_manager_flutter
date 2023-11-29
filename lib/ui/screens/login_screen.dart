import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/network_caller/network_response.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/signup_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import '../../data/utility/urls.dart';
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
  bool _signinInProgress = false;

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
                Visibility(
                  visible: _signinInProgress == false,
                  replacement: Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () => login(),
                          child:
                              const Icon(Icons.arrow_circle_right_outlined))),
                ),
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
    if (_formKey.currentState!.validate()) {
      _signinInProgress = true;
      if (mounted) {
        setState(() {});
      }
      NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
          body: {
            "email": _emailTEController.text.trim(),
            "password": _passwordTEController.text
          },isLogin: true);
      _signinInProgress = false;
      if (mounted) {
        setState(() {});
      }
      if (response.isSuccess) {
        await AuthController.SaveUserInformation(
            response.jsonResponse?['token'],
            UserModel.fromJson(response.jsonResponse?['data']));
        _clearTextFields();
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainBottomNavbar()));
        }
      } else {
        if (response.statusCode == 401) {
          if (mounted) {
            showSnackMessage(context, 'Please check your email/password', true);
          }
        } else {
          if (mounted) {
            showSnackMessage(context, 'Login failed try again', true);
          }
        }
      }
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
