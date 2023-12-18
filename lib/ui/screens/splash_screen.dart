import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToLogin();
  }

  Future<void> goToLogin() async {
    final bool isLogin = await Get.find<AuthController>().checkAuthState();
    log(isLogin.toString());
    Future.delayed(const Duration(seconds: 2)).then((value) {
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> !isLogin? const LoginScreen() : const MainBottomNavbar()), (route) => false);
      Get.offAll(isLogin ? const MainBottomNavbar() : const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
      child: Center(
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          width: 120,
        ),
      ),
    ));
  }
}
