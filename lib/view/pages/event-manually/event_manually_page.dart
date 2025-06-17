import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/tasks.model.dart';
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

  static final DateTime _calendarFirstDay = DateTime.utc(2000, 1, 1);
  static final DateTime _calendarLastDay = DateTime.utc(2100, 12, 31);

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _fetchTasks();
  }

  void _fetchTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    TasksService().getTasksForUser(user.uid).listen(
      (tasks) {
        final map = <DateTime, List<Task>>{};
        for (final task in tasks) {
          try {
            final ts = task.dueDate;
            final date = ts.toDate();
            final normalized = DateTime(date.year, date.month, date.day);
            map.putIfAbsent(normalized, () => []).add(task);
          } catch (e) {
            debugPrint('Error parsing dueDate for task \\${task.id}: $e');
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

  List<Task> _getTasksForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _tasksByDate.entries
        .where((entry) => entry.key.year == date.year && entry.key.month == date.month && entry.key.day == date.day)
        .expand((entry) => entry.value)
        .toList();
  }

  CalendarBuilders<Task> calendarBuilders = CalendarBuilders(
    markerBuilder: (context, date, events) {
      if (events.isNotEmpty) {
        return Positioned(
          bottom: 1,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );

  void _showCreateTaskModal(BuildContext context) {
    final _titleController = TextEditingController();
    final _descController = TextEditingController();
    DateTime? _dueDate;
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Create Task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBDF152),
                        )),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dueDate == null
                              ? 'No due date selected'
                              : 'Due: \\${_dueDate!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFBDF152),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate ?? DateTime.now(),
                            firstDate: _calendarFirstDay,
                            lastDate: _calendarLastDay,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: Color(0xFFBDF152),
                                    onPrimary: Colors.black,
                                    surface: Colors.grey[900]!,
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: Colors.black,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setModalState(() {
                              _dueDate = picked;
                            });
                          }
                        },
                        child: const Text('Pick Due Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBDF152),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (_titleController.text.isEmpty || _descController.text.isEmpty || _dueDate == null) return;
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;
                        final task = Task(
                          id: '',
                          title: _titleController.text,
                          description: _descController.text,
                          completed: false,
                          createdAt: Timestamp.now(),
                          dueDate: Timestamp.fromDate(_dueDate!),
                          userId: user.uid,
                        );
                        await TasksService().addTask(task);
                        Navigator.of(context).pop();
                        _fetchTasks();
                      },
                      child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditTaskModal(BuildContext context, Task task) {
    final _titleController = TextEditingController(text: task.title);
    final _descController = TextEditingController(text: task.description);
    DateTime _dueDate = task.dueDate.toDate();
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Edit Task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBDF152),
                        )),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),

                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Due: \\${_dueDate.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFBDF152),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate,
                            firstDate: _calendarFirstDay,
                            lastDate: _calendarLastDay,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: Color(0xFFBDF152),
                                    onPrimary: Colors.black,
                                    surface: Colors.grey[900]!,
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: Colors.black,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setModalState(() {
                              _dueDate = picked;
                            });
                          }
                        },
                        child: const Text('Pick Due Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBDF152),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (_titleController.text.isEmpty || _descController.text.isEmpty) return;
                        final updated = Task(
                          id: task.id,
                          title: _titleController.text,
                          description: _descController.text,
                          completed: task.completed,
                          createdAt: task.createdAt,
                          dueDate: Timestamp.fromDate(_dueDate),
                          userId: task.userId,
                        );
                        await TasksService().updateTask(updated);
                        Navigator.of(context).pop();
                        _fetchTasks();
                      },
                      child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TableCalendar(
                locale: 'en_US',
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFBDF152).withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.redAccent),
                  outsideTextStyle: TextStyle(color: Colors.grey),
                ),
                focusedDay: _focusedDay,
                firstDay: _calendarFirstDay,
                lastDay: _calendarLastDay,
                selectedDayPredicate: (day) => _selectedDay != null && isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: _getTasksForDay,
                calendarBuilders: calendarBuilders,
              ),
              const SizedBox(height: 20),
              if (_selectedDay != null)
                Expanded(
                  child: _getTasksForDay(_selectedDay!).isEmpty
                      ? const Center(child: Text('No tasks for this day', style: TextStyle(color: Colors.white70)))
                      : ListView.builder(
                          itemCount: _getTasksForDay(_selectedDay!).length,
                          itemBuilder: (context, index) {
                            final task = _getTasksForDay(_selectedDay!)[index];
                            return Card(
                              color: Colors.white.withOpacity(0.1),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(task.title, style: const TextStyle(color: Colors.white)),
                                subtitle: Text(task.description, style: const TextStyle(color: Colors.white70)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.yellow[700]),
                                      onPressed: () => _showEditTaskModal(context, task),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await TasksService().deleteTask(task.id);
                                        _fetchTasks();
                                      },
                                    ),
                                    Checkbox(
                                      value: task.completed,
                                      onChanged: (val) async {
                                        final updated = task.copyWith(completed: val ?? false);
                                        await TasksService().updateTask(updated);
                                        // Force refresh after update
                                        _fetchTasks();
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateTaskModal(context),
          backgroundColor: const Color(0xFFBDF152),
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
