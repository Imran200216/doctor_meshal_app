class OperativeForm {
  final String id;
  final String title;
  final bool formEnableStatus;

  OperativeForm({
    required this.id,
    required this.title,
    required this.formEnableStatus,
  });

  // Factory constructor for parsing from JSON
  factory OperativeForm.fromJson(Map<String, dynamic> json) {
    return OperativeForm(
      id: json['id'] as String,
      title: json['title'] as String,
      formEnableStatus: json['form_enable_status'] as bool,
    );
  }

  // Convert back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'form_enable_status': formEnableStatus,
    };
  }
}