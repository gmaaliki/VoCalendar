import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventManuallyPage extends StatelessWidget {
  const EventManuallyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Calendar
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
                focusedDay: DateTime.now(),
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
              ),

              // Button to add event

              // List of events
            ],
          ),
        ),
      ),
    );
  }
}
