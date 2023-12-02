import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/screens/pin_verification_screen.dart';
import 'package:task_manager/ui/screens/signup_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../widget/snack_message.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _forgetPasswordInProgress = false;
  Future<void>_recoveryVerifyEmail() async {
    if (_formKey.currentState!.validate()) {
      _forgetPasswordInProgress = true;
      if(mounted){
        setState(() {});
      }
      final NetworkResponse response =
      await NetworkCaller()
          .getRequest(Urls.recoverVerifyEmail(_emailTEController.text.trim()));
      _forgetPasswordInProgress = false;
      if(mounted){
        setState(() {});
      }
      if (response.isSuccess) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PinVerificationScreen(email: _emailTEController.text.trim())));
      } else {
        if (mounted) {
          showSnackMessage(
              context, 'Account Creation failed', true);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                        const SizedBox(height: 80,),
                        Text('Your email address',style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8,),
                        const Text('A 6 digits OTP will be send to your email address',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600)),
                        const SizedBox(height: 24,),
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
                        const SizedBox(height: 16,),
                        SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: _forgetPasswordInProgress == false,
                              replacement: Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                  onPressed: _recoveryVerifyEmail,
                                  child: const Icon(Icons.arrow_circle_right_outlined)),
                            )),
                        const SizedBox(height: 48,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Have an account",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: const Text("Sign In",style: TextStyle(fontSize: 16),))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
        )
    );
  }
}
