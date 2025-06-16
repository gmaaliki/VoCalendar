import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/label.dart';
import '../../../../models/tasks.model.dart';
import '../../../../services/database/label_service.dart';
import '../../../../services/database/tasks_service.dart';
import 'label_modal.dart';

void showLabelAssignmentModal({
  required BuildContext context,
  required Task task,
  required List<Label> allLabels, // Ini adalah data awal
  required Color Function(String) colorFromHex,
  required VoidCallback onTaskModified,
  required VoidCallback onLabelModified,
}) {
  List<String> selectedLabelIds = List<String>.from(task.labelIds);
  // CHANGE 1: Buat variabel state lokal untuk menampung daftar label
  List<Label> currentLabels = List<Label>.from(allLabels);
  final user = FirebaseAuth.instance.currentUser;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          // Fungsi untuk memuat ulang data di dalam modal
          Future<void> refreshLabels() async {
            if (user == null) return;
            // Ambil data terbaru dari Firestore
            final newLabels =
                await LabelService().getLabelsForUser(user.uid).first;
            setModalState(() {
              // Ganti data lama dengan data baru
              currentLabels = newLabels;
            });
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Text(
                    "Assign Labels to '${task.title}'",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Divider(color: Colors.grey.shade800, height: 1.h),
                Expanded(
                  child: ListView(
                    children: [
                      ...currentLabels.map((label) {
                        return ListTile(
                          onTap: () {
                            setModalState(() {
                              if (selectedLabelIds.contains(label.id)) {
                                selectedLabelIds.remove(label.id);
                              } else {
                                selectedLabelIds.add(label.id);
                              }
                            });
                          },
                          leading: Checkbox(
                            value: selectedLabelIds.contains(label.id),
                            onChanged: (bool? value) {
                              setModalState(() {
                                if (value == true) {
                                  selectedLabelIds.add(label.id);
                                } else {
                                  selectedLabelIds.remove(label.id);
                                }
                              });
                            },
                            activeColor: colorFromHex(label.color),
                          ),
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: colorFromHex(label.color),
                                radius: 8.r,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                label.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey[400],
                                  size: 20.sp,
                                ),
                                onPressed: () async {
                                  await showCreateOrEditLabelModal(
                                    context,
                                    label: label,
                                    colorFromHex: colorFromHex,
                                  );
                                  onLabelModified();
                                  await refreshLabels();
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent.withOpacity(0.8),
                                  size: 20.sp,
                                ),
                                onPressed: () async {
                                  await LabelService().deleteLabel(label.id);
                                  onLabelModified();
                                  await refreshLabels();

                                  if (selectedLabelIds.contains(label.id)) {
                                    setModalState(() {
                                      selectedLabelIds.remove(label.id);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      Divider(
                        color: Colors.grey.shade800,
                        height: 1.h,
                        indent: 16.w,
                        endIndent: 16.w,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.add,
                          color: Color(0xFFBDF152),
                        ),
                        title: const Text(
                          'Create & Assign New Label',
                          style: TextStyle(color: Color(0xFFBDF152)),
                        ),
                        onTap: () async {
                          final newLabelId = await showCreateOrEditLabelModal(
                            context,
                            colorFromHex: colorFromHex,
                          );
                          if (newLabelId != null) {
                            // CHANGE 5: Panggil refreshLabels dan tambahkan ID baru
                            onLabelModified();
                            await refreshLabels();
                            setModalState(() {
                              selectedLabelIds.add(newLabelId);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBDF152),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final updatedTask = task.copyWith(
                          labelIds: selectedLabelIds,
                        );
                        await TasksService().updateTask(updatedTask);
                        Navigator.of(context).pop();
                        onTaskModified();
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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
