import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/network_caller/network_response.dart';
import 'package:task_manager/ui/controllers/cancel_controller.dart';
import 'package:task_manager/ui/controllers/completed_controller.dart';
import 'package:task_manager/ui/controllers/new_task_controller.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';

import '../../data/models/task.dart';
import '../../data/utility/urls.dart';

enum TaskStatus { New, Progress, Completed, Cancelled }

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.task,
    required this.onStatusChange,
    required this.showProgress,
  });

  final Task task;
  final VoidCallback onStatusChange;
  final Function(bool) showProgress;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  Future<void> updateTaskStatus(String status) async {
    widget.showProgress(true);
    final NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.updateTaskStatus(widget.task.sId ?? '', status));
    if (response.isSuccess) {
      if(widget.task.status == 'New'){
        Get.find<NewTaskController>().fullPageRefresh();
      }else if(widget.task.status == 'Progress'){
        Get.find<ProgressController>().fullPageRefresh();
      }else if(widget.task.status == 'Completed'){
        Get.find<CompletedController>().fullPageRefresh();
      }else if(widget.task.status == 'Cancelled'){
        Get.find<CancelController>().fullPageRefresh();
      }
    }
    widget.showProgress(false);
  }

  Future<void> deleteTaskStatus() async {
    widget.showProgress(true);
    final response = await NetworkCaller()
        .getRequest(Urls.deleteTask(widget.task.sId ?? ''));
    if (response.isSuccess) {
      //widget.onStatusChange();
      if(widget.task.status == 'New'){
        Get.find<NewTaskController>().fullPageRefresh();
      }else if(widget.task.status == 'Progress'){
        Get.find<ProgressController>().fullPageRefresh();
      }else if(widget.task.status == 'Completed'){
        Get.find<CompletedController>().fullPageRefresh();
      }else if(widget.task.status == 'Cancelled'){
        Get.find<CancelController>().fullPageRefresh();
      }
    }
    widget.showProgress(false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(widget.task.description ?? ''),
            Text(widget.task.createdDate ?? ''),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    widget.task.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: widget.task.status == 'New'
                      ? Colors.blue
                      : widget.task.status == 'Progress'
                          ? Colors.orange
                          : widget.task.status == 'Completed'
                              ? Colors.green
                              : widget.task.status == 'Cancelled'
                                  ? Colors.red
                                  : Colors.grey,
                ),
                Wrap(
                  children: [
                    IconButton(
                        onPressed: () {
                          deleteTaskStatus();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    IconButton(
                        onPressed: () {
                          showUpdateStatusModal();
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        )),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void showUpdateStatusModal() {
    List<ListTile> items = TaskStatus.values
        .map((e) => ListTile(
              title: Text(e.name),
              onTap: () {
                updateTaskStatus(e.name);
                Navigator.pop(context);
              },
            ))
        .toList();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Status'),
            content: Column(mainAxisSize: MainAxisSize.min, children: items),
            actions: [
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      )),
                  // TextButton(onPressed: (){}, child: const Text('Update'))
                ],
              )
            ],
          );
        });
  }
}
