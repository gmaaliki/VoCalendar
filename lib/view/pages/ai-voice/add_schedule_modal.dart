import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/schedule_model.dart';
import '../../../viewmodels/schedule_viewmodel.dart';
import 'date_form_field.dart';
import 'date_time_controller.dart';

Future<void> showAddScheduleModal(BuildContext context, String userId) async {
  final eventNameController = TextEditingController();
  final startTimeController = DateTimeController();
  final endTimeController = DateTimeController();
  final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFF2B2B2B),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                    child: Text('Create Event',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBDF152),
                        )),
                  ),
                  const SizedBox(height: 16),
                  Text("Event Name", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: eventNameController,
                    cursorColor: Colors.grey,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'ex: Meet with friends',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 4.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text("Start Time", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  DateTimePickerFormField(controller: startTimeController, label: "Start Time"),
                  const SizedBox(height: 24),

                  Text("End Time", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  DateTimePickerFormField(controller: endTimeController, label: "End Time"),
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
                        Navigator.of(context).pop();
                      },
                      child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
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
