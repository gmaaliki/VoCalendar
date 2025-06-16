import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../models/tasks.model.dart';

class CalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<Task>> tasksByDate;
  final Function(DateTime, DateTime) onDaySelected;
  final List<Task> Function(DateTime) getTasksForDay;

  const CalendarView({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.tasksByDate,
    required this.onDaySelected,
    required this.getTasksForDay,
  });

  static final DateTime _calendarFirstDay = DateTime.utc(2000, 1, 1);
  static final DateTime _calendarLastDay = DateTime.utc(2100, 12, 31);

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Task>(
      locale: 'en_US',
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 20.0.sp,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          size: 30.0.sp,
          color: Colors.white,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          size: 30.0.sp,
          color: Colors.white,
        ),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: const Color(0xFFBDF152).withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: const TextStyle(color: Colors.redAccent),
        outsideTextStyle: const TextStyle(color: Colors.grey),
      ),
      focusedDay: focusedDay,
      firstDay: _calendarFirstDay,
      lastDay: _calendarLastDay,
      selectedDayPredicate:
          (day) => selectedDay != null && isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      eventLoader: getTasksForDay,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              bottom: 1,
              child: Container(
                width: 7.w,
                height: 7.h,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
