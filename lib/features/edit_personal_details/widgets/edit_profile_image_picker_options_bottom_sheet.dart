import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_bottom_sheet_top_thumb.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/view_model/cubit/profile_image/profile_image_cubit.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class EditProfileImagePickerOptionsBottomSheet extends StatelessWidget {
  const EditProfileImagePickerOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 20, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bottom Sheet Top Thumb
          const KBottomSheetTopThumb(),

          const SizedBox(height: 30),

          ListTile(
            leading: Icon(Icons.camera),
            title: Text(appLoc.takePhoto),
            titleTextStyle: TextStyle(
              fontFamily: "OpenSans",
              color: AppColorConstants.titleColor,
              fontSize: isMobile
                  ? 16
                  : isTablet
                  ? 18
                  : 20,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              // Close Dialog
              GoRouter.of(context).pop();

              // Take Camera
              context.read<ProfileImageCubit>().pickImage(ImageSource.camera);
            },
          ),

          ListTile(
            leading: Icon(Icons.photo),
            title: Text(appLoc.chooseFromGallery),
            titleTextStyle: TextStyle(
              fontFamily: "OpenSans",
              color: AppColorConstants.titleColor,
              fontSize: isMobile
                  ? 16
                  : isTablet
                  ? 18
                  : 20,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              // Close Dialog
              GoRouter.of(context).pop();

              // Pick Gallery
              context.read<ProfileImageCubit>().pickImage(ImageSource.gallery);
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
