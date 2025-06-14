import 'package:flutter/material.dart';

import 'date_time_controller.dart';

class DateTimePickerFormField extends StatefulWidget {
  final DateTimeController controller;
  final String label;

  const DateTimePickerFormField({
    super.key,
    required this.controller,
    this.label = "Select Date & Time",
  });

  @override
  State<DateTimePickerFormField> createState() => _DateTimePickerFormFieldState();
}

class _DateTimePickerFormFieldState extends State<DateTimePickerFormField> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateText);
    _updateText();
  }

  void _updateText() {
    final dateTime = widget.controller.selectedDateTime;
    if (dateTime != null) {
      _textController.text = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
          "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else {
      _textController.text = '';
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateText);
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.controller.selectedDateTime ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: widget.controller.selectedDateTime != null
          ? TimeOfDay.fromDateTime(widget.controller.selectedDateTime!)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    widget.controller.selectedDateTime = fullDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: _pickDateTime,
    );
  }
}
