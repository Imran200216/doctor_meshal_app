import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

class KBottomSheetTopThumb extends StatelessWidget {
  const KBottomSheetTopThumb({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        height: 5,
        width: 50,
        decoration: BoxDecoration(
          color: AppColorConstants.titleColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
