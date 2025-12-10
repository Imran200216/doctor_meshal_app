class DoctorPeriOperativeFormModel {
  final List<DoctorPeriOperativeForm> forms;

  DoctorPeriOperativeFormModel({required this.forms});

  factory DoctorPeriOperativeFormModel.fromJson(Map<String, dynamic> json) {
    return DoctorPeriOperativeFormModel(
      forms: (json["get_patient_submited_forms_doctor_"] as List)
          .map((e) => DoctorPeriOperativeForm.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "get_patient_submited_forms_doctor_": forms
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class DoctorPeriOperativeForm {
  final String formNo;
  final String formSerialNo;
  final String formStatus;
  final String id;
  final String title;
  final User user;
  final String createdAtTime;

  DoctorPeriOperativeForm({
    required this.formSerialNo,
    required this.formStatus,
    required this.id,
    required this.title,
    required this.user,
    required this.createdAtTime,
    required this.formNo,
  });

  factory DoctorPeriOperativeForm.fromJson(Map<String, dynamic> json) {
    return DoctorPeriOperativeForm(
      formSerialNo: json["form_serial_no"] ?? "",
      formStatus: json["form_status"] ?? "",
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      user: User.fromJson(json["user_id"]),
      createdAtTime: json["createdAt_time"] ?? "",
      formNo: json['form_no'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "form_serial_no": formSerialNo,
      "form_status": formStatus,
      "id": id,
      "title": title,
      "user_id": user.toJson(),
      formNo: formNo,
      "createdAt_time": createdAtTime,
    };
  }
}

class User {
  final String firstName;
  final String lastName;
  final String id;

  User({required this.firstName, required this.lastName, required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      id: json["id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"first_name": firstName, "last_name": lastName, "id": id};
  }
}
