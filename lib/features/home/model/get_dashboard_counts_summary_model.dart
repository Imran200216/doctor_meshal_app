class GetDashboardCountsSummaryModel {
  final DashboardCountsSummary? summary;

  GetDashboardCountsSummaryModel({this.summary});

  factory GetDashboardCountsSummaryModel.fromJson(Map<String, dynamic> json) {
    return GetDashboardCountsSummaryModel(
      summary: json['get_dashboard_counts_summary'] != null
          ? DashboardCountsSummary.fromJson(
              json['get_dashboard_counts_summary'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'get_dashboard_counts_summary': summary?.toJson()};
  }
}

class DashboardCountsSummary {
  final StatusCount? postOperative;
  final StatusCount? preOperative;
  final String? totalEducationArticles;
  final String? totalPatient;

  DashboardCountsSummary({
    this.postOperative,
    this.preOperative,
    this.totalEducationArticles,
    this.totalPatient,
  });

  factory DashboardCountsSummary.fromJson(Map<String, dynamic> json) {
    return DashboardCountsSummary(
      postOperative: json['post_operative_submited'] is Map
          ? StatusCount.fromJson(json['post_operative_submited'])
          : null,
      preOperative: json['pre_operative_submited'] is Map
          ? StatusCount.fromJson(json['pre_operative_submited'])
          : null,
      totalEducationArticles: json['total_education_articles']?.toString(),
      totalPatient: json['total_patient']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_operative_submited': postOperative?.toJson(),
      'pre_operative_submited': preOperative?.toJson(),
      'total_education_articles': totalEducationArticles,
      'total_patient': totalPatient,
    };
  }
}

class StatusCount {
  final int? pending;
  final int? completed;
  final int? rejected;

  StatusCount({this.pending, this.completed, this.rejected});

  factory StatusCount.fromJson(Map<String, dynamic> json) {
    return StatusCount(
      pending: json['Pending'],
      completed: json['Completed'],
      rejected: json['Rejected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'Pending': pending, 'Completed': completed, 'Rejected': rejected};
  }
}
