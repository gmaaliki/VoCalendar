import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/models/schedule_model.dart';
import 'package:intl/intl.dart';

import 'delete_schedule_dialog.dart';
import 'edit_schedule_modal.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({super.key,
    required this.schedule,
  });

  String formatScheduleTime(Timestamp start, Timestamp end) {
    final startTime = start.toDate();
    final endTime = end.toDate();
    final timeFormat = DateFormat('dd MMM HH:mm');
    return "${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white.withOpacity(0.1),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              schedule.eventName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              formatScheduleTime(schedule.startTime, schedule.endTime),
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white), // "three dots" icon
              onSelected: (String value) async {
                switch (value) {
                  case 'edit':
                    showEditScheduleModal(
                        context,
                        schedule,
                    );
                    break;
                  case 'delete':
                    showDeleteConfirmationDialog(
                      context,
                      schedule.eventName,
                      schedule.id,
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}