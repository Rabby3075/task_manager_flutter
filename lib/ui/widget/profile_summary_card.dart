import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/edit_profile_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({
    super.key, this.enableOnTap = true,
  });
final bool enableOnTap;

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = Base64Decoder().convert(AuthController.user?.photo ?? '');
    return ListTile(
      onTap: (){
        if(enableOnTap) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const EditProfileScreen()));
        }
      },
      leading: CircleAvatar(
        child: AuthController.user?.photo == null
            ? const Icon(Icons.person)
            : ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.memory(
            imageBytes,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(fullName,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
      subtitle: Text(AuthController.user?.email ?? '<email>',style: const TextStyle(color: Colors.white),),
      trailing: IconButton(
        onPressed: () async {
          await AuthController.ClearAuthData();
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()), (
                    route) => false);
        
        },
        icon: const Icon(Icons.logout,color: Colors.white,),
      ),
      tileColor: Colors.green,
    );
  }

  String get fullName {
    return '${AuthController.user?.firstName ?? ''} ${AuthController.user?.lastName ?? ''}';
  }
}