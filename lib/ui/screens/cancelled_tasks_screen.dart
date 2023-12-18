import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/ui/controllers/cancel_controller.dart';

import '../../data/models/task_count.dart';
import '../../data/models/task_count_summary_list_model.dart';
import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../widget/profile_summary_card.dart';
import '../widget/summary_card.dart';
import '../widget/task_item_card.dart';

class CancelledTasksScreen extends StatefulWidget {
  const CancelledTasksScreen({super.key});

  @override
  State<CancelledTasksScreen> createState() => _CancelledTasksScreenState();
}

class _CancelledTasksScreenState extends State<CancelledTasksScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<CancelController>().fullPageRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const ProfileSummary(),
              GetBuilder<CancelController>(builder: (cancelController) {
                return Visibility(
                    visible: cancelController.getTaskCountSummaryInProgress ==
                        false,
                    replacement: const LinearProgressIndicator(),
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cancelController.taskSummaryCountListModel
                              .taskCountList?.length ??
                              0,
                          itemBuilder: (context, index) {
                            TaskCount taskCount = cancelController
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
              GetBuilder<CancelController>(builder: (cancelController) {
                return Visibility(
                  visible: cancelController.getNewTaskInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: () => cancelController.fullPageRefresh(),
                    child: ListView.builder(
                        itemCount:
                        cancelController.taskListModel.taskList?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: cancelController
                                .taskListModel.taskList![index],
                            onStatusChange: () {
                              cancelController.getNewTaskList();
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
