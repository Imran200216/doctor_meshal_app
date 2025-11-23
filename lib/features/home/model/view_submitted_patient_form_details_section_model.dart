class ViewSubmittedPatientFormDetailsSectionModel {
  final String id;
  final List<FormSection> formSection;
  final String createdAtTime;
  final String formStatus;
  final String formSerialNo;
  final String title;
  final String totalPoints;
  final String formType;
  final String updatedAt;
  final UserModel user;

  ViewSubmittedPatientFormDetailsSectionModel({
    required this.id,
    required this.formSection,
    required this.createdAtTime,
    required this.formStatus,
    required this.formSerialNo,
    required this.title,
    required this.totalPoints,
    required this.formType,
    required this.updatedAt,
    required this.user,
  });

  factory ViewSubmittedPatientFormDetailsSectionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json["data"]["view_submited_patient_form_detail_section__"];

    return ViewSubmittedPatientFormDetailsSectionModel(
      id: data["id"],
      formSection: (data["form_section"] as List)
          .map((e) => FormSection.fromJson(e))
          .toList(),
      createdAtTime: data["createdAt_time"],
      formStatus: data["form_status"],
      formSerialNo: data["form_serial_no"],
      title: data["title"],
      totalPoints: data["total_points"],
      formType: data["form_type"],
      updatedAt: data["updatedAt"],
      user: UserModel.fromJson(data["user_id"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "form_section": formSection.map((e) => e.toJson()).toList(),
    "createdAt_time": createdAtTime,
    "form_status": formStatus,
    "form_serial_no": formSerialNo,
    "title": title,
    "total_points": totalPoints,
    "form_type": formType,
    "updatedAt": updatedAt,
    "user_id": user.toJson(),
  };
}

class FormSection {
  final String id;
  final String sectionTitle;
  final List<FormOption> formOption;
  final int formIndexNo;

  FormSection({
    required this.id,
    required this.sectionTitle,
    required this.formOption,
    required this.formIndexNo,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) {
    return FormSection(
      id: json["id"],
      sectionTitle: json["section_title"],
      formOption: (json["form_option"] as List)
          .map((e) => FormOption.fromJson(e))
          .toList(),
      formIndexNo: json["form_index_no"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_title": sectionTitle,
    "form_option": formOption.map((e) => e.toJson()).toList(),
    "form_index_no": formIndexNo,
  };
}

class FormOption {
  final bool answerStatus;
  final String optionName;
  final String points;

  FormOption({
    required this.answerStatus,
    required this.optionName,
    required this.points,
  });

  factory FormOption.fromJson(Map<String, dynamic> json) {
    return FormOption(
      answerStatus: json["answer_status"],
      optionName: json["option_name"],
      points: json["points"],
    );
  }

  Map<String, dynamic> toJson() => {
    "answer_status": answerStatus,
    "option_name": optionName,
    "points": points,
  };
}

class UserModel {
  final String id;
  final String lastName;
  final String firstName;

  UserModel({
    required this.id,
    required this.lastName,
    required this.firstName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      lastName: json["last_name"],
      firstName: json["first_name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "last_name": lastName,
    "first_name": firstName,
  };
}
