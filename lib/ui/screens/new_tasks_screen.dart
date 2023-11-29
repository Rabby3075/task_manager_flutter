import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_count.dart';
import 'package:task_manager/data/models/task_count_summary_list_model.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/network_caller/network_response.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';

import '../widget/profile_summary_card.dart';
import '../widget/summary_card.dart';
import '../widget/task_item_card.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  bool getNewTaskInProgress = false;
  bool getTaskCountSummaryInProgress = false;
  TaskListModel taskListModel = TaskListModel();
  Future<void> getNewTaskList() async {
    getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.getNewTask('New'));
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse!);
    }
    getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  TaskSummaryCountListModel taskSummaryCountListModel = TaskSummaryCountListModel();
  Future<void> getTaskCountSummaryList() async {
    getTaskCountSummaryInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    if (response.isSuccess) {
      taskSummaryCountListModel = TaskSummaryCountListModel.fromJson(response.jsonResponse!);
    }
    getTaskCountSummaryInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewTaskList();
    getTaskCountSummaryList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNewTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
        body: SafeArea(
      child: Column(
        children: [
          const ProfileSummary(),
          Visibility(
            visible: getTaskCountSummaryInProgress == false && (taskSummaryCountListModel.taskCountList?.isNotEmpty ?? false),
              replacement: const LinearProgressIndicator(),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: taskSummaryCountListModel.taskCountList?.length ?? 0,
                    itemBuilder: (context,index){
                    TaskCount taskCount = taskSummaryCountListModel.taskCountList![index];
            return FittedBox(child: SummaryCard(count: taskCount.sum.toString(), title: taskCount.sId??''));
          }),
              )),
          Expanded(
              child: Visibility(
                visible: getNewTaskInProgress == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: RefreshIndicator(
                  onRefresh: getNewTaskList,
                  child: ListView.builder(
                      itemCount: taskListModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return  TaskItemCard(
                            task: taskListModel.taskList![index],
                          onStatusChange: (){
                              getNewTaskList();
                          },
                          showProgress: (inprogress){
                              getNewTaskInProgress = inprogress;
                              if(mounted){
                                setState(() {});
                              }
                          },
                        );
                      }),
                ),
              ))
        ],
      ),
    ));
  }
}


