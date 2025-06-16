import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../models/label.dart';
import '../../../../services/database/label_service.dart';

Future<String?> showCreateOrEditLabelModal(
  BuildContext context, {
  Label? label,
  required Color Function(String) colorFromHex,
}) async {
  final isEditing = label != null;
  final nameController = TextEditingController(text: label?.name ?? '');
  Color pickerColor = isEditing ? colorFromHex(label.color) : Colors.blue;

  return await showDialog<String?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          isEditing ? 'Edit Label' : 'Create Label',
          style: const TextStyle(
            color: Color(0xFFBDF152),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Label Name',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),
              ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                pickerAreaHeightPercent: 0.8,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFBDF152)),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBDF152),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.black)),
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              final colorString =
                  '#${pickerColor.value.toRadixString(16).substring(2)}';

              if (isEditing) {
                final updatedLabel = label.copyWith(
                  name: nameController.text,
                  color: colorString,
                );
                await LabelService().updateLabel(updatedLabel);
                Navigator.of(context).pop(null);
              } else {
                final newLabel = Label(
                  id: '',
                  name: nameController.text,
                  color: colorString,
                  userId: user.uid,
                );
                final docRef = await LabelService().addLabel(newLabel);
                Navigator.of(context).pop(docRef.id);
              }
            },
          ),
        ],
      );
    },
  );
}
