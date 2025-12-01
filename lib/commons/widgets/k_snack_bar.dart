import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:delightful_toast/delight_toast.dart';

class KSnackBar {
  // SUCCESS SNACKBAR
  static void success(BuildContext context, String message) {
    DelightToastBar(
      position: DelightSnackbarPosition.bottom,
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 2),
      builder: (context) => Directionality(
        textDirection: TextDirection.ltr, // 👈 APPLY HERE
        child: ToastCard(
          color: Colors.green,
          leading: const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 26,
          ),
          title: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ).show(context);
  }

  // ERROR SNACKBAR
  static void error(BuildContext context, String message) {
    DelightToastBar(
      position: DelightSnackbarPosition.bottom,
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 2),
      builder: (context) => Directionality(
        textDirection: TextDirection.ltr,
        child: ToastCard(
          color: Colors.red,
          leading: const Icon(Icons.error, color: Colors.white, size: 26),
          title: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ).show(context);
  }
}
