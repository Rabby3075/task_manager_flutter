import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/network_caller/network_response.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/profile_summary_card.dart';
import 'package:task_manager/ui/widget/snack_message.dart';

import '../../data/utility/urls.dart';
import '../controllers/new_task_controller.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _progress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
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
                            const SizedBox(height: 32,),
                            Text('Add New Task',style: Theme.of(context).textTheme.titleLarge,),
                            const SizedBox(height: 16,),
                            TextFormField(
                              controller: _subjectTEController,
                              decoration: const InputDecoration(
                                hintText: 'Subject'
                              ),
                              validator: (String? value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return 'Subject field required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              controller: _descriptionTEController,
                              maxLines: 8,
                              decoration: const InputDecoration(
                                  hintText: 'Description'
                              ),
                              validator: (String? value){
                                if (value?.trim().isEmpty ?? true) {
                                  return 'Description field required';
                                }
                                return null;
                            },
                            ),
                            const SizedBox(height: 16,),
                            SizedBox(
                                width: double.infinity,
                                child: Visibility(
                                  visible: _progress == false,
                                  replacement: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  child: ElevatedButton(
                                      onPressed: _createTask,
                                      child: const Icon(Icons.arrow_circle_right_outlined)),
                                )),
                          ],
                        ),
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

  Future<void> _createTask() async{
    if(_formKey.currentState!.validate()){
      _progress = true;
      if(mounted){
        setState(() {});
      }
      final NetworkResponse response = await NetworkCaller().postRequest(
          Urls.createTask,body:
      {
        "title":_subjectTEController.text.trim(),
        "description":_descriptionTEController.text.trim(),
        "status":"New"
      });
      _progress = false;
      if(mounted){
        setState(() {});
      }
      if(response.isSuccess){
        Get.find<NewTaskController>().getNewTaskList();
        _clearTextFields();
        if(mounted){
          Navigator.pop(context);
          showSnackMessage(context, 'New Task added');
        }
      }else{
        if(mounted) {
          showSnackMessage(context, 'Something went wrong please try again!',true);
        }
      }
    }
  }

  void _clearTextFields(){
    _subjectTEController.clear();
    _descriptionTEController.clear();

  }

  @override
  void dispose() {
    _subjectTEController.dispose();
    _descriptionTEController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
