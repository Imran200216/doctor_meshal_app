import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_skeleton_rectangle.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Good Morning
          KSkeletonRectangle(width: 80, radius: 3, height: 20),

          const SizedBox(height: 5),

          // User Name
          KSkeletonRectangle(width: 100, radius: 3, height: 20),

          const SizedBox(height: 30),

          // Peri Operative Score
          KSkeletonRectangle(width: 120, radius: 3, height: 20),

          const SizedBox(height: 20),

          // Peri Operative Card
          KSkeletonRectangle(width: double.maxFinite, radius: 12, height: 100),

          const SizedBox(height: 15),

          // Pre Operative Card
          KSkeletonRectangle(width: double.maxFinite, radius: 12, height: 100),

          const SizedBox(height: 15),

          // Post Operative Card
          KSkeletonRectangle(width: double.maxFinite, radius: 12, height: 100),

          const SizedBox(height: 30),

          // Patient Corner
          KSkeletonRectangle(width: 80, radius: 3, height: 20),

          const SizedBox(height: 20),

          isTablet
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 20,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1.6,
                  ),
                  itemBuilder: (context, index) {
                    return KSkeletonRectangle(
                      width: double.maxFinite,
                      radius: 12,
                      height: 120,
                    );
                  },
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 20,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    return KSkeletonRectangle(
                      width: double.maxFinite,
                      radius: 12,
                      height: 140,
                    );
                  },
                ),
        ],
      ),
    );
  }
}
