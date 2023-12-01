import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/network_caller/network_response.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/profile_summary_card.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/snack_message.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  XFile? photo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProfileInProgress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTEController.text = AuthController.user?.email ?? '';
    _firstNameTEController.text = AuthController.user?.firstName ?? '';
    _lastNameTEController.text = AuthController.user?.lastName ?? '';
    _mobileTEController.text = AuthController.user?.mobile ?? '';
  }
  Future<void>_ProfileUpdate() async {
    Map<String,dynamic> inputData ={
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      //"password":_passwordTEController.text,
    };
    String ?photoInBase64;
    if (_formKey.currentState!.validate()) {
      _updateProfileInProgress = true;
      if(mounted){
        setState(() {});
      }
     if(_passwordTEController.text.isNotEmpty){
       inputData['password'] = _passwordTEController.text;
     }
     if(photo != null){
       List<int> imageBytes = await photo!.readAsBytes();
       photoInBase64 = base64Encode(imageBytes);
       inputData['photo'] = photoInBase64;
     }
      final NetworkResponse response =
      await NetworkCaller()
          .postRequest(Urls.updateProfile,body: inputData);
      _updateProfileInProgress = false;
      if(mounted){
        setState(() {});
      }
      if(response.isSuccess){
        AuthController.UpdateUserInformation(UserModel(
            email: _emailTEController.text.trim(),
            firstName: _firstNameTEController.text.trim(),
            lastName: _lastNameTEController.text.trim(),
            mobile: _mobileTEController.text.trim(),
          photo: photoInBase64 ?? AuthController.user?.photo
        ));
        if(mounted) {
          showSnackMessage(context, 'Profile Update Successfully');
        }
      }else{
        if (mounted) {
          showSnackMessage(context, 'Profile Update Failed', true);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(
              enableOnTap: false,
            ),
            Expanded(
                child: BodyBackground(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Update Profile',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PhotoPicker(),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _emailTEController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: 'Email'),
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
                          height: 8,
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
                          height: 8,
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
                          height: 8,
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
                          height: 8,
                        ),
                        TextFormField(
                            controller: _passwordTEController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password (Optional)',
                            ),
                            validator: (String? value) {
                               if (value!.isNotEmpty && value!.length < 5) {
                                return 'Please enter at least 5 digits password';
                              }

                              return null;
                            }),
                        const SizedBox(
                          height: 8,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: _updateProfileInProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                  onPressed: _ProfileUpdate,
                                  child: const Icon(Icons.arrow_circle_right_outlined)),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Container PhotoPicker() {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      )),
                  alignment: Alignment.center,
                  child: Text(
                    'Photos',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () async{
                   final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                   if(image !=null){
                     photo = image;
                     if(mounted){
                     setState(() {});
                     }
                   }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: Visibility(
                      visible: photo == null,
                        replacement: Text(photo?.name ?? ''),
                        child:  Text(AuthController.user?.photo ?? 'Select Photo')
                    ),
                  ),
                )),
          ],
        ));
  }
}
