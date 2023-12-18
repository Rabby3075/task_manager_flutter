import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import '../../data/models/task_count.dart';
import '../widget/profile_summary_card.dart';
import '../widget/summary_card.dart';
import '../widget/task_item_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<ProgressController>().fullPageRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const ProfileSummary(),
              GetBuilder<ProgressController>(builder: (progressController) {
                return Visibility(
                    visible: progressController.getTaskCountSummaryInProgress ==
                        false,
                    replacement: const LinearProgressIndicator(),
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: progressController.taskSummaryCountListModel
                              .taskCountList?.length ??
                              0,
                          itemBuilder: (context, index) {
                            TaskCount taskCount = progressController
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
              GetBuilder<ProgressController>(builder: (progressController) {
                return Visibility(
                  visible: progressController.getNewTaskInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: () => progressController.fullPageRefresh(),
                    child: ListView.builder(
                        itemCount:
                        progressController.taskListModel.taskList?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: progressController
                                .taskListModel.taskList![index],
                            onStatusChange: () {
                              progressController.getNewTaskList();
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

