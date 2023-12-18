import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_count.dart';
import 'package:task_manager/data/models/task_count_summary_list_model.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/network_caller/network_response.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/ui/controllers/new_task_controller.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<NewTaskController>().fullPageRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final response = Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddNewTaskScreen()));
            if (response == true) {
              Get.find<NewTaskController>().fullPageRefresh();
            }
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const ProfileSummary(),
              GetBuilder<NewTaskController>(builder: (newTaskController) {
                return Visibility(
                    visible: newTaskController.getTaskCountSummaryInProgress ==
                        false,
                    replacement: const LinearProgressIndicator(),
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newTaskController.taskSummaryCountListModel
                                  .taskCountList?.length ??
                              0,
                          itemBuilder: (context, index) {
                            TaskCount taskCount = newTaskController
                                .taskSummaryCountListModel
                                .taskCountList![index];
                            return FittedBox(
                                child: SummaryCard(
                                    count: taskCount.sum.toString(),
                                    title: taskCount.sId ?? ''));
                          }),
                    ));
              }),
              Expanded(child:
                  GetBuilder<NewTaskController>(builder: (newTaskController) {
                return Visibility(
                  visible: newTaskController.getNewTaskInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: () => newTaskController.fullPageRefresh(),
                    child: ListView.builder(
                        itemCount:
                            newTaskController.taskListModel.taskList?.length ??
                                0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: newTaskController
                                .taskListModel.taskList![index],
                            onStatusChange: () {
                              newTaskController.getNewTaskList();
                            },
                            showProgress: (inprogress) {},
                          );
                        }),
                  ),
                );
              }))
            ],
          ),
        ));
  }
}
