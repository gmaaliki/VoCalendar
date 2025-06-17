import 'package:flutter/material.dart';
import 'package:flutterapi/models/label.dart';
import 'package:flutterapi/models/tasks.model.dart';
import 'task_list_item.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final Map<String, Label> labelsById;
  final List<Label> allLabels;
  final Color Function(String) colorFromHex;
  final VoidCallback onTaskModified;
  final VoidCallback onLabelModified;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.labelsById,
    required this.allLabels,
    required this.colorFromHex,
    required this.onTaskModified,
    required this.onLabelModified,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks for this day',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListItem(
          task: task,
          labelsById: labelsById,
          allLabels: allLabels,
          colorFromHex: colorFromHex,
          onTaskModified: onTaskModified,
          onLabelModified: onLabelModified,
        );
      },
    );
  }
}
