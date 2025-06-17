import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/view/pages/ai-voice/date_form_field.dart';
import 'package:flutterapi/view/pages/ai-voice/date_time_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutterapi/viewmodels/schedule_viewmodel.dart';
import 'package:flutterapi/models/schedule_model.dart';

void showAddScheduleDialog(BuildContext context, String userId) {
  final eventNameController = TextEditingController();
  final startTimeController = DateTimeController();
  final endTimeController = DateTimeController();
  final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Add Event"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: eventNameController,
            decoration: const InputDecoration(labelText: 'Event Name'),
          ),
          DateTimePickerFormField(
              controller: startTimeController,
              label:  "Start Time"
          ),
          DateTimePickerFormField(
              controller: endTimeController,
              label:  "End Time"
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Add"),
          onPressed: () {
            final eventName = eventNameController.text.trim();
            final startVal = startTimeController.selectedDateTime;
            final endVal = endTimeController.selectedDateTime;

            if (eventName.isEmpty) {
              Flushbar(
                message: "Event name must not be empty",
                backgroundColor: Colors.red,
                margin: EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(12),
                duration: Duration(seconds: 2),
                flushbarPosition: FlushbarPosition.BOTTOM,
              ).show(context);
              return;
            }

            if (startVal == null || endVal == null) {
              Flushbar(
                message: "Please select both start and end time",
                backgroundColor: Colors.red,
                margin: EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(12),
                duration: Duration(seconds: 2),
                flushbarPosition: FlushbarPosition.BOTTOM,
              ).show(context);
              return;
            }

            final start = startTimeController.requireTimestamp("Start Time").toDate();
            final end = endTimeController.requireTimestamp("End Time").toDate();
            if (start.isAfter(end) || start.isAtSameMomentAs(end)) {
              Flushbar(
                message: "Start time must be before end time",
                backgroundColor: Colors.red,
                margin: EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(12),
                duration: Duration(seconds: 2),
                flushbarPosition: FlushbarPosition.BOTTOM,
              ).show(context);
              return;
            }

            final newSchedule = Schedule(
              id: '',
              eventName: eventNameController.text,
              startTime: startTimeController.requireTimestamp("Start Time"),
              endTime: endTimeController.requireTimestamp("End Time"),
              userId: userId,
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.now(),
            );
            viewModel.addSchedule(newSchedule);
            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}