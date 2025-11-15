class SurveyOperativeForm {
  final String title;
  final String id;
  final List<FormSection> formSection;

  SurveyOperativeForm({
    required this.title,
    required this.id,
    required this.formSection,
  });

  factory SurveyOperativeForm.fromJson(Map<String, dynamic> json) {
    return SurveyOperativeForm(
      title: json['title'],
      id: json['id'],
      formSection: (json['form_section'] as List)
          .map((e) => FormSection.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "id": id,
      "form_section": formSection.map((e) => e.toJson()).toList(),
    };
  }
}

class FormSection {
  final int formIndexNo;
  final String chooseType;
  final String id;
  final String sectionTitle;
  final List<FormOption> formOption;

  FormSection({
    required this.formIndexNo,
    required this.chooseType,
    required this.id,
    required this.sectionTitle,
    required this.formOption,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) {
    return FormSection(
      formIndexNo: json['form_index_no'],
      chooseType: json['choose_type'],
      id: json['id'],
      sectionTitle: json['section_title'],
      formOption: (json['form_option'] as List)
          .map((e) => FormOption.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "form_index_no": formIndexNo,
      "choose_type": chooseType,
      "id": id,
      "section_title": sectionTitle,
      "form_option": formOption.map((e) => e.toJson()).toList(),
    };
  }
}

class FormOption {
  final String optionName;
  final String points;

  FormOption({
    required this.optionName,
    required this.points,
  });

  factory FormOption.fromJson(Map<String, dynamic> json) {
    return FormOption(
      optionName: json['option_name'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "option_name": optionName,
      "points": points,
    };
  }
}
