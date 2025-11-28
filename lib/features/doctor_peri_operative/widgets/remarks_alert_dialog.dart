import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

class RemarksAlertDialog extends StatelessWidget {
  final VoidCallback onCancelTap;
  final VoidCallback onSubmitTap;
  final TextEditingController remarksController;
  final String? Function(String?)? validator; // <-- Added validator

  const RemarksAlertDialog({
    super.key,
    required this.onCancelTap,
    required this.onSubmitTap,
    required this.remarksController,
    required this.validator, // <-- Added in constructor
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "Add Remarks",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: TextFormField(
          validator: validator, // <-- Use here
          controller: remarksController,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "Enter remarks...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColorConstants.primaryColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: onCancelTap, child: const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorConstants.primaryColor,
            foregroundColor: AppColorConstants.secondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onSubmitTap,
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
