import 'package:get/get.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import 'new_task_controller.dart';

class AddNewTaskController extends GetxController{
  bool _progress = false;

  bool get progress => _progress;
  String _successMessage = '';
  String _failedMessage = '';
  Future<bool> createTask(String subject, String description) async{
      _progress = true;
      update();
      final NetworkResponse response = await NetworkCaller().postRequest(
          Urls.createTask,body:
      {
        "title":subject,
        "description":description,
        "status":"New"
      });
      _progress = false;
      update();
      if(response.isSuccess){
        Get.find<NewTaskController>().fullPageRefresh();
        // if(mounted){
        //   Navigator.pop(context);
        //   showSnackMessage(context, 'New Task added');
        // }
        _successMessage = 'New Task added';
        return true;
      }else{
        // if(mounted) {
        //   showSnackMessage(context, 'Something went wrong please try again!',true);
        // }
        _failedMessage = 'Something went wrong please try again!';
      }
      return false;
  }

  String get successMessage => _successMessage;

  String get failedMessage => _failedMessage;
}