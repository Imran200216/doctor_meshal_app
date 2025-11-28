class StatusFormModel {
  final String formSerialNo;
  final String formStatus;
  final String id;
  final String title;
  final String formNo;
  final String formType;
  final String patientStatusForm;
  final String status;

  StatusFormModel({
    required this.formSerialNo,
    required this.formStatus,
    required this.id,
    required this.title,
    required this.formNo,
    required this.formType,
    required this.patientStatusForm,
    required this.status,
  });

  factory StatusFormModel.fromJson(Map<String, dynamic> json) {
    return StatusFormModel(
      formSerialNo: json['form_serial_no'] ?? '',
      formStatus: json['form_status'] ?? '',
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      formNo: json['form_no'] ?? '',
      formType: json['form_type'] ?? '',
      patientStatusForm: json['patient_status_form'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_serial_no': formSerialNo,
      'form_status': formStatus,
      'id': id,
      'title': title,
      'form_no': formNo,
      'form_type': formType,
      'patient_status_form': patientStatusForm,
      'status': status,
    };
  }
}
