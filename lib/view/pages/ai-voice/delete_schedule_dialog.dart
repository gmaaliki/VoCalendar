import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterapi/viewmodels/schedule_viewmodel.dart';

Future<void> showDeleteConfirmationDialog(
    BuildContext context, String eventName, String scheduleId) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: Text('Are you sure you want to delete "$eventName"?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Consumer<ScheduleViewModel>(
          builder: (context, vm, _) => ElevatedButton(
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              await vm.deleteSchedule(scheduleId);
              Navigator.of(context).pop(); // Close the dialog
              Flushbar(
                message: "Event deleted.",
                backgroundColor: Colors.white,
                messageColor: Colors.black,
                margin: EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(12),
                duration: Duration(seconds: 2),
                flushbarPosition: FlushbarPosition.BOTTOM,
              ).show(context);

            },
          ),
        ),
      ],
    ),
  );
}
