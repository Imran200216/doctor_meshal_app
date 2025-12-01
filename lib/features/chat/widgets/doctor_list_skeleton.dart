import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';


class DoctorListSkeleton extends StatelessWidget {
  const DoctorListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Search Doctor
          KSkeletonTextFormField(),

          // Doctor List
          ListView.separated(
            shrinkWrap: true,
            itemCount: 20,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return SizedBox(height: 12);
            },
            itemBuilder: (context, index) {
              return KSkeletonRectangle(
                height: 50,
                width: double.maxFinite,
                radius: 10,
              );
            },
          ),
        ],
      ),
    );
  }
}
