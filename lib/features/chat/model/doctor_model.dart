class DoctorModel {
  final String id;
  final DoctorUser user;

  DoctorModel({
    required this.id,
    required this.user,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      user: DoctorUser.fromJson(json['user_id'] ?? {}),
    );
  }
}

class DoctorUser {
  final String id;
  final String firstName;
  final String lastName;
  final String profileImage;
  final String specialization;

  DoctorUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.specialization,
  });

  factory DoctorUser.fromJson(Map<String, dynamic> json) {
    return DoctorUser(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      specialization: json['specialization'] ?? '',
    );
  }
}
