import 'package:get/get.dart';

import '../../data/models/task_count_summary_list_model.dart';
import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class CancelController extends GetxController{
  bool _getNewTaskInProgress =false;
  bool _getTaskCountSummaryInProgress = false;
  TaskListModel _taskListModel = TaskListModel();
  TaskSummaryCountListModel taskSummaryCountListModel =
  TaskSummaryCountListModel();

  bool get getNewTaskInProgress => _getNewTaskInProgress;
  bool get getTaskCountSummaryInProgress => _getTaskCountSummaryInProgress;
  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _getNewTaskInProgress = true;
    // if (mounted) {
    //   setState(() {});
    // }
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getNewTask('Cancelled'));
    _getNewTaskInProgress = false;
    // if (mounted) {
    //   setState(() {});
    // }
    update();
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse!);
      isSuccess = true;
    }
    update();
    return isSuccess;

  }
  Future<bool> getTaskCountSummaryList() async {
    bool isSuccess = false;
    _getTaskCountSummaryInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    if (response.isSuccess) {
      taskSummaryCountListModel =
          TaskSummaryCountListModel.fromJson(response.jsonResponse!);
      isSuccess = true;
    }
    _getTaskCountSummaryInProgress = false;
    update();
    return isSuccess;
  }
  Future<void> fullPageRefresh() async {
    getNewTaskList();
    getTaskCountSummaryList();
  }
}