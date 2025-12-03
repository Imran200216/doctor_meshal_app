class FeedbackModel {
  final String id;
  final String feedBack;
  final String createdAt;
  final PatientModel patient;

  FeedbackModel({
    required this.id,
    required this.feedBack,
    required this.createdAt,
    required this.patient,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json["id"] ?? "",
      feedBack: json["feed_back"] ?? "",
      createdAt: json["createdAt"] ?? "",
      patient: PatientModel.fromJson(json["patient_id"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "feed_back": feedBack,
      "createdAt": createdAt,
      "patient_id": patient.toJson(),
    };
  }
}

class PatientModel {
  final String id;
  final String firstName;
  final String lastName;
  final String profileImage;

  PatientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json["id"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      profileImage: json["profile_image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "profile_image": profileImage,
    };
  }
}
