import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_skeleton_paragraph.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_skeleton_rectangle.dart';

class EducationArticleViewSkeleton extends StatelessWidget {
  const EducationArticleViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        spacing: 20,
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          // Topics
          KSkeletonRectangle(height: 20, width: 100, radius: 4),

          // Sub Topics
          KSkeletonRectangle(height: 20, width: 130, radius: 4),

          // Articles title
          KSkeletonRectangle(height: 20, width: 80, radius: 4),

          // Article Title Text
          KSkeletonRectangle(height: 20, width: 120, radius: 4),

          // Articles content
          KSkeletonParagraph(lines: 30, radius: 10),
        ],
      ),
    );
  }
}
