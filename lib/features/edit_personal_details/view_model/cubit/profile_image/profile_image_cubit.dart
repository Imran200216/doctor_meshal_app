import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'profile_image_state.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  ProfileImageCubit() : super(ProfileImageState.initial());

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image == null) return;

      final file = File(image.path);

      // ✅ COMPRESS IMAGE (quality 40)
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 40,
      );

      if (compressedBytes == null) {
        AppLoggerHelper.logError("Image compression failed");
        return;
      }

      // ✅ Convert to Base64
      final base64String = base64Encode(compressedBytes);

      AppLoggerHelper.logInfo("Compressed Size: ${compressedBytes.length} bytes");
      AppLoggerHelper.logInfo("Base64 Length: ${base64String.length}");

      emit(
        state.copyWith(
          pickedImage: file,
          base64Image: base64String,
        ),
      );
    } catch (e) {
      AppLoggerHelper.logError("Pick image error: $e");
    }
  }

  void clearImage() {
    emit(ProfileImageState.initial());
  }
}
