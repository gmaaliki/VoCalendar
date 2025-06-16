import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../models/tasks.model.dart';
import '../../../../services/database/tasks_service.dart';

void showCreateOrEditTaskModal(
  BuildContext context, {
  Task? task,
  required VoidCallback onTaskModified,
}) {
  final isEditing = task != null;
  final titleController = TextEditingController(text: task?.title ?? '');
  final descController = TextEditingController(text: task?.description ?? '');
  DateTime? dueDate = task?.dueDate.toDate();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      isEditing ? 'Edit Task' : 'Create Task',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBDF152),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title TextField
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description TextField
                  TextField(
                    controller: descController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  // Due Date Picker
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dueDate == null
                              ? 'No due date selected'
                              : 'Due: ${dueDate!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFBDF152),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dueDate ?? DateTime.now(),
                            firstDate: DateTime.utc(2000, 1, 1),
                            lastDate: DateTime.utc(2100, 12, 31),
                          );
                          if (picked != null) {
                            setModalState(() {
                              dueDate = picked;
                            });
                          }
                        },
                        child: const Text('Pick Due Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Save/Create Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBDF152),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (titleController.text.isEmpty ||
                            descController.text.isEmpty ||
                            dueDate == null) {
                          return;
                        }

                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        if (isEditing) {
                          final updatedTask = task.copyWith(
                            title: titleController.text,
                            description: descController.text,
                            dueDate: Timestamp.fromDate(dueDate!),
                          );
                          await TasksService().updateTask(updatedTask);
                        } else {
                          final newTask = Task(
                            id: '',
                            title: titleController.text,
                            description: descController.text,
                            completed: false,
                            createdAt: Timestamp.now(),
                            dueDate: Timestamp.fromDate(dueDate!),
                            userId: user.uid,
                          );
                          await TasksService().addTask(newTask);
                        }
                        Navigator.of(context).pop();
                        onTaskModified();
                      },
                      child: Text(
                        isEditing ? 'Save' : 'Create',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
