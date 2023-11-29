import 'package:flutter/material.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/profile_summary_card.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(enableOnTap: false,),
            Expanded(
                child: BodyBackground(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32,),
                          Text('Update Profile',style: Theme.of(context).textTheme.titleLarge,),
                          const SizedBox(height: 16,),
                         PhotoPicker(),
                          const SizedBox(height: 8,),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: 'Email'
                            ),
                          ),
                          const SizedBox(height: 8,),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'First Name'
                            ),
                          ),
                          const SizedBox(height: 8,),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Last Name'
                            ),
                          ),
                          const SizedBox(height: 8,),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Mobile'
                            ),
                          ),
                          const SizedBox(height: 8,),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Password'
                            ),
                          ),
                          const SizedBox(height: 8,),
                          const SizedBox(height: 16,),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){},
                              child: Icon(Icons.arrow_circle_right_outlined),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Container PhotoPicker() {
    return Container(
                         height: 50,
                           decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(8)
                           ),
                         child: Row(
                           children: [
                             Expanded(
                               flex:1,
                                 child: Container(
                                   height: 50,
                                   decoration: BoxDecoration(
                                     color: Colors.grey,
                                     borderRadius: BorderRadius.only(
                                         topLeft: Radius.circular(8),
                                         bottomLeft: Radius.circular(8),
                                     )
                                   ),
                                   alignment: Alignment.center,
                                   child: Text('Photos',style: TextStyle(
                                     color: Colors.white
                                   ),),
                             )
                             ),
                             Expanded(
                                 flex:3,
                                 child: Container(
                                   padding: EdgeInsets.only(left: 16),
                                   child: Text('Empty'),
                                 )
                             ),
                           ],
                         )
                       );
  }
}
