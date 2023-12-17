import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/edit_profile_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

class ProfileSummary extends StatefulWidget {
  const ProfileSummary({
    super.key,
    this.enableOnTap = true,
  });

  final bool enableOnTap;

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
  Widget _buildUserImage(String? imageBytes) {
    try {
      if (imageBytes != null) {
        Uint8List imageBytess = const Base64Decoder()
            .convert(imageBytes.replaceAll('data:image/png;base64,', ''));
        return Image.memory(
          imageBytess,
          height: 45,
          width: 45,
          fit: BoxFit.cover,
        );
      }
    } catch (e) {
      log('Error loading user image: $e');
    }

    // Return a default image or placeholder if an error occurs
    return const CircleAvatar(
      child: Icon(Icons.error),
    );
  }
  @override
  Widget build(BuildContext context) {
    // Uint8List imageBytes =
    //     const Base64Decoder().convert(AuthController.user?.photo ?? '');

    return ListTile(
      onTap: () {
        if (widget.enableOnTap) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditProfileScreen()));
        }
      },
      leading: CircleAvatar(
        child: AuthController.user?.photo == null
            ? const Icon(Icons.person)
            : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: _buildUserImage(AuthController.user?.photo)
              ),
      ),
      title: Text(
        fullName,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        AuthController.user?.email ?? '<email>',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: IconButton(
        onPressed: () async {
          await AuthController.ClearAuthData();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
        },
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
      tileColor: Colors.green,
    );
  }


  String get fullName {
    return '${AuthController.user?.firstName ?? ''} ${AuthController.user?.lastName ?? ''}';
  }
}
