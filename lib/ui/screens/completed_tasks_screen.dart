import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/ui/controllers/completed_controller.dart';

import '../../data/models/task_count.dart';
import '../widget/profile_summary_card.dart';
import '../widget/summary_card.dart';
import '../widget/task_item_card.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<CompletedController>().fullPageRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const ProfileSummary(),
              GetBuilder<CompletedController>(builder: (completedController) {
                return Visibility(
                    visible: completedController.getTaskCountSummaryInProgress ==
                        false,
                    replacement: const LinearProgressIndicator(),
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: completedController.taskSummaryCountListModel
                              .taskCountList?.length ??
                              0,
                          itemBuilder: (context, index) {
                            TaskCount taskCount = completedController
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
              GetBuilder<CompletedController>(builder: (completedController) {
                return Visibility(
                  visible: completedController.getNewTaskInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: () => completedController.fullPageRefresh(),
                    child: ListView.builder(
                        itemCount:
                        completedController.taskListModel.taskList?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: completedController
                                .taskListModel.taskList![index],
                            onStatusChange: () {
                              completedController.getNewTaskList();
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
