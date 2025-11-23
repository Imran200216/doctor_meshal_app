part of 'profile_image_cubit.dart';

class ProfileImageState extends Equatable {
  final File? pickedImage;
  final String base64Image;

  const ProfileImageState({
    required this.pickedImage,
    required this.base64Image,
  });

  factory ProfileImageState.initial() {
    return const ProfileImageState(
      pickedImage: null,
      base64Image: "",
    );
  }

  ProfileImageState copyWith({
    File? pickedImage,
    String? base64Image,
  }) {
    return ProfileImageState(
      pickedImage: pickedImage ?? this.pickedImage,
      base64Image: base64Image ?? this.base64Image,
    );
  }

  @override
  List<Object?> get props => [pickedImage, base64Image];
}
