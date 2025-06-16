import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapi/components/calendar_view.dart';
import 'package:flutterapi/components/task_list_view.dart';
import 'package:flutterapi/components/task_modal.dart';
import 'dart:async';
import '../../../models/label.dart';
import '../../../models/tasks.model.dart';
import '../../../services/database/label_service.dart';
import '../../../services/database/tasks_service.dart';

class EventManuallyPage extends StatefulWidget {
  const EventManuallyPage({super.key});

  @override
  State<EventManuallyPage> createState() => _EventManuallyPageState();
}

class _EventManuallyPageState extends State<EventManuallyPage> {
  Map<DateTime, List<Task>> _tasksByDate = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<String, Label> _labelsById = {};
  List<Label> _allLabels = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _fetchTasks();
    _fetchLabels();
  }

  void _fetchTasks() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    TasksService()
        .getTasksForUser(user.uid)
        .listen(
          (tasks) {
            final map = <DateTime, List<Task>>{};
            for (final task in tasks) {
              try {
                final date = task.dueDate.toDate();
                final normalized = DateTime(date.year, date.month, date.day);
                map.putIfAbsent(normalized, () => []).add(task);
              } catch (e) {
                debugPrint('Error parsing dueDate for task ${task.id}: $e');
              }
            }
            if (mounted) {
              setState(() {
                _tasksByDate = map;
              });
            }
          },
          onError: (error) {
            debugPrint('Firestore stream error: $error');
          },
        );
  }

  Future<void> _fetchLabels() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    LabelService().getLabelsForUser(user.uid).listen((labels) {
      if (mounted) {
        setState(() {
          _allLabels = labels;
          _labelsById = {for (var label in labels) label.id: label};
        });
      }
    });
  }

  List<Task> _getTasksForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _tasksByDate[date] ?? [];
  }

  Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0.r),
          child: Column(
            children: [
              CalendarView(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                tasksByDate: _tasksByDate,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                getTasksForDay: _getTasksForDay,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      () => showCreateOrEditTaskModal(
                        context,
                        onTaskModified: _fetchTasks,
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBDF152),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  icon: const Icon(Icons.add, color: Colors.black),
                  label: const Text(
                    'Create Task',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              if (_selectedDay != null)
                Expanded(
                  child: TaskListView(
                    tasks: _getTasksForDay(_selectedDay!),
                    labelsById: _labelsById,
                    allLabels: _allLabels,
                    colorFromHex: colorFromHex,
                    onTaskModified: _fetchTasks,
                    onLabelModified: _fetchLabels,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
