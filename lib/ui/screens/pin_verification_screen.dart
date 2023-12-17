import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../widget/snack_message.dart';
import 'login_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _pinVerificationInProgress = false;
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  Future<void> _pinVerification() async {
    _formKey.currentState!.validate();
    // conditions for validating
    if (currentText.length != 6) {
      errorController!
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() => hasError = true);
    } else {
      setState(
        () async {
          hasError = false;
          _pinVerificationInProgress = true;
          if (mounted) {
            setState(() {});
          }
          final NetworkResponse response = await NetworkCaller().getRequest(
              Urls.pinVerification(widget.email, _pinTEController.text.trim()));
          _pinVerificationInProgress = false;
          if (mounted) {
            setState(() {});
          }
          if (response.isSuccess) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email, otp: _pinTEController.text.trim())));
          } else {
            if (mounted) {
              showSnackMessage(
                  context,
                  response.jsonResponse?['data'] ??
                      'Error message not available',
                  true);
            }
          }
        },
      );
    }
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
            child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text('Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 8,
                ),
                Text('A 6 digits OTP will be send in ${widget.email}',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 24,
                ),
                PinCodeTextField(
                  obscuringCharacter: '*',
                  length: 6,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      activeColor: Colors.green,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white),
                  animationDuration: Duration(milliseconds: 300),
                  // backgroundColor: Colors.blue.shade50,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: _pinTEController,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "Pin can't be empty";
                    } else if (v.length < 6) {
                      return "All pin should be filled";
                    } else {
                      return null;
                    }
                  },
                  onCompleted: (v) {
                    log("Completed");
                  },
                  onChanged: (value) {
                    log(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    log("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    hasError ? "*Please fill up all the cells properly" : "",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _pinVerificationInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                          onPressed: _pinVerification,
                          child: const Text('Verify')),
                    )),
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
}
