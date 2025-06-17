// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showTopSnackbar({
  required BuildContext context,
  required String title,
  required String message,
  required ContentType contentType,
  required Color shadowColor,
}) {
  final messenger = ScaffoldMessenger.of(context); // Ambil dulu referensinya

  final materialBanner = MaterialBanner(
    elevation: 5,
    backgroundColor: Colors.transparent,
    forceActionsBelow: true,
    shadowColor: shadowColor,
    minActionBarHeight: 8.h,
    onVisible:
        () => Future.delayed(const Duration(seconds: 2), () {
          messenger.hideCurrentMaterialBanner();
        }),
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
      inMaterialBanner: true,
    ),
    actions: const [SizedBox.shrink()],
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(materialBanner);
}
