import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/edit_profile_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

class ProfileSummary extends StatefulWidget {
  const ProfileSummary({
    super.key, this.enableOnTap = true,
  });
final bool enableOnTap;

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        if(widget.enableOnTap) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const EditProfileScreen()));
        }
      },
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(fullName,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
      subtitle: Text(AuthController.user?.email ?? '<email>',style: const TextStyle(color: Colors.white),),
      trailing: IconButton(
        onPressed: () async {
          await AuthController.ClearAuthData();
          if(mounted) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()), (
                    route) => false);
          }
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