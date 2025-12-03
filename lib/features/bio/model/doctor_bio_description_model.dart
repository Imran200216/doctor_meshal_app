class DoctorBioDescriptionModel {
  final List<DoctorBioDescription> descriptionsDoctorBio;
  final DoctorInfo doctorInfo;

  DoctorBioDescriptionModel({
    required this.descriptionsDoctorBio,
    required this.doctorInfo,
  });

  factory DoctorBioDescriptionModel.fromJson(Map<String, dynamic> json) {
    // Remove the ['data'] access since we're already at view_doctor_bio_data level
    return DoctorBioDescriptionModel(
      descriptionsDoctorBio: (json['descriptions_doctor_bio'] as List)
          .map((e) => DoctorBioDescription.fromJson(e))
          .toList(),
      doctorInfo: DoctorInfo.fromJson(json['doctor_id']),
    );
  }
}

class DoctorBioDescription {
  final String id;
  final String bioDescription;

  DoctorBioDescription({required this.id, required this.bioDescription});

  factory DoctorBioDescription.fromJson(Map<String, dynamic> json) {
    return DoctorBioDescription(
      id: json['id'],
      bioDescription: json['bio_description'],
    );
  }
}

class DoctorInfo {
  final String id;
  final String firstName;
  final String profileImage;
  final String specialization;

  DoctorInfo({
    required this.id,
    required this.firstName,
    required this.profileImage,
    required this.specialization,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      id: json['id'],
      firstName: json['first_name'],
      profileImage: json['profile_image'],
      specialization: json['specialization'],
    );
  }
}
