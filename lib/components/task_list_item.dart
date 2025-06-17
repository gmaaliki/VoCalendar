import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/components/assign_label_modal.dart';
import 'package:flutterapi/components/task_modal.dart';
import '../../../../models/label.dart';
import '../../../../models/tasks.model.dart';
import '../../../../services/database/tasks_service.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Map<String, Label> labelsById;
  final List<Label> allLabels;
  final Color Function(String) colorFromHex;
  final VoidCallback onTaskModified;
  final VoidCallback onLabelModified;

  const TaskListItem({
    super.key,
    required this.task,
    required this.labelsById,
    required this.allLabels,
    required this.colorFromHex,
    required this.onTaskModified,
    required this.onLabelModified,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (val) {
            final updatedTask = task.copyWith(completed: val ?? false);
            TasksService().updateTask(updatedTask);
            onTaskModified();
          },
          activeColor: const Color(0xFFBDF152),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration:
                task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
            decorationColor: Colors.black, // Warna garis coretan
            decorationThickness: 4,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
                decoration:
                    task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                decorationColor: Colors.black, // Warna garis coretan
                decorationThickness: 4,
              ),
            ),
            const SizedBox(height: 8),
            if (task.labelIds.isNotEmpty)
              Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                children:
                    task.labelIds.map((labelId) {
                      final label = labelsById[labelId];
                      if (label == null) {
                        return const SizedBox.shrink();
                      }
                      return Chip(
                        label: Text(
                          label.name,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            decoration:
                                task.completed
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                            decorationColor:
                                Colors.black, // Warna garis coretan
                            decorationThickness: 4,
                          ),
                        ),
                        backgroundColor: colorFromHex(label.color),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1.0),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 1.h,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'label') {
              showLabelAssignmentModal(
                context: context,
                task: task,
                allLabels: allLabels,
                colorFromHex: colorFromHex,
                onTaskModified: onTaskModified,
                onLabelModified: onLabelModified,
              );
            } else if (value == 'edit') {
              showCreateOrEditTaskModal(
                context,
                task: task,
                onTaskModified: onTaskModified,
              );
            } else if (value == 'delete') {
              TasksService().deleteTask(task.id);
              onTaskModified();
            }
          },
          icon: const Icon(Icons.more_vert, color: Colors.white70),
          color: Colors.grey[850],
          itemBuilder:
              (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'label',
                  child: Row(
                    children: [
                      const Icon(Icons.label_outline, color: Colors.white70),
                      SizedBox(width: 10.w),
                      const Text(
                        'Label',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, color: Colors.yellow[700]),
                      SizedBox(width: 10.w),
                      const Text('Edit', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline, color: Colors.redAccent),
                      SizedBox(width: 10.w),
                      const Text(
                        'Delete',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ],
        ),
      ),
    );
  }
}
