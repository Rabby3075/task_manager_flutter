import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_manager/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/cancel_controller.dart';
import 'package:task_manager/ui/controllers/completed_controller.dart';
import 'package:task_manager/ui/controllers/edit_profile_controller.dart';
import 'package:task_manager/ui/controllers/forgetPasswordController.dart';
import 'package:task_manager/ui/controllers/login_controller.dart';
import 'package:task_manager/ui/controllers/new_task_controller.dart';
import 'package:task_manager/ui/controllers/pin_verification_controller.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import 'package:task_manager/ui/controllers/registration_controller.dart';
import 'package:task_manager/ui/controllers/set_password_controller.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      navigatorKey: navigationKey,
      home: const SplashScreen(),
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true, // fill the text field white
          border: OutlineInputBorder(
              borderSide: BorderSide.none // remove the bottom border
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none // remove the bottom border
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600
          )
        ),
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
          )
        )
      ),
      initialBinding: ControllerBinder(),
    );
  }
}
class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(RegistrationController());
    Get.put(ProfileEditController());
    Get.put(NewTaskController());
    Get.put(AuthController());
    Get.put(AddNewTaskController());
    Get.put(ProgressController());
    Get.put(CompletedController());
    Get.put(CancelController());
    Get.put(ForgetPasswordController());
    Get.put(SetPasswordController());
    Get.put(PinVerificationController());
    // TODO: implement dependencies
  }

}
