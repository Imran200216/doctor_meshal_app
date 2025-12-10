class ViewPatientSubmittedFormDetailsModel {
  final String createdAtTime;
  final String formNo;
  final List<FormSection> formSection;
  final String formSerialNo;
  final String formStatus;
  final String formType;
  final String id;
  final String patientStatusForm;
  final String status;
  final String title;
  final String totalPoints;
  final UserName userId;
  final DoctorName doctorId;

  ViewPatientSubmittedFormDetailsModel({
    required this.createdAtTime,
    required this.formNo,
    required this.formSection,
    required this.formSerialNo,
    required this.formStatus,
    required this.formType,
    required this.id,
    required this.patientStatusForm,
    required this.status,
    required this.title,
    required this.totalPoints,
    required this.userId,
    required this.doctorId,
  });

  factory ViewPatientSubmittedFormDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ViewPatientSubmittedFormDetailsModel(
      createdAtTime: json['createdAt_time'] ?? '',
      formNo: json['form_no'] ?? '',
      formSection: (json['form_section'] as List? ?? [])
          .map((e) => FormSection.fromJson(e))
          .toList(),
      formSerialNo: json['form_serial_no'] ?? '',
      formStatus: json['form_status'] ?? '',
      formType: json['form_type'] ?? '',
      id: json['id'] ?? '',
      patientStatusForm: json['patient_status_form'] ?? '',
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      totalPoints: json['total_points'] ?? '',
      userId: UserName.fromJson(json['user_id'] ?? {}),
      doctorId: DoctorName.fromJson(json['doctor_id'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt_time': createdAtTime,
      'form_no': formNo,
      'form_section': formSection.map((e) => e.toJson()).toList(),
      'form_serial_no': formSerialNo,
      'form_status': formStatus,
      'form_type': formType,
      'id': id,
      'patient_status_form': patientStatusForm,
      'status': status,
      'title': title,
      'total_points': totalPoints,
      'user_id': userId.toJson(),
      'doctor_id': doctorId.toJson(),
    };
  }
}

class FormSection {
  final int formIndexNo;
  final List<FormOption> formOption;
  final String id;
  final String sectionTitle;
  final String chooseType;

  FormSection({
    required this.formIndexNo,
    required this.formOption,
    required this.id,
    required this.sectionTitle,
    required this.chooseType,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) {
    return FormSection(
      formIndexNo: json['form_index_no'] ?? 0,
      formOption: (json['form_option'] as List? ?? [])
          .map((e) => FormOption.fromJson(e))
          .toList(),
      id: json['id'] ?? '',
      sectionTitle: json['section_title'] ?? '',
      chooseType: json['choose_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_index_no': formIndexNo,
      'form_option': formOption.map((e) => e.toJson()).toList(),
      'id': id,
      'section_title': sectionTitle,
      'choose_type': chooseType,
    };
  }
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
      answerStatus: json['answer_status'] ?? false,
      optionName: json['option_name'] ?? '',
      points: json['points'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer_status': answerStatus,
      'option_name': optionName,
      'points': points,
    };
  }
}

class UserName {
  final String firstName;
  final String lastName;

  UserName({required this.firstName, required this.lastName});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'first_name': firstName, 'last_name': lastName};
  }
}

class DoctorName {
  final String id;
  final String firstName;
  final String lastName;

  DoctorName({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory DoctorName.fromJson(Map<String, dynamic> json) {
    return DoctorName(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'first_name': firstName, 'last_name': lastName};
  }
}
