class StatusFormModel {
  final String formSerialNo;
  final String formStatus;
  final String id;
  final String title;

  StatusFormModel({
    required this.formSerialNo,
    required this.formStatus,
    required this.id,
    required this.title,
  });

  factory StatusFormModel.fromJson(Map<String, dynamic> json) {
    return StatusFormModel(
      formSerialNo: json['form_serial_no'] ?? '',
      formStatus: json['form_status'] ?? '',
      id: json['id'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_serial_no': formSerialNo,
      'form_status': formStatus,
      'id': id,
      'title': title,
    };
  }
}
