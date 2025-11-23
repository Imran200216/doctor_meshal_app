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
      postOperative: json['post_operative_submited'] != null
          ? StatusCount.fromJson(json['post_operative_submited'])
          : null,
      preOperative: json['pre_operative_submited'] != null
          ? StatusCount.fromJson(json['pre_operative_submited'])
          : null,
      totalEducationArticles: json['total_education_articles'],
      totalPatient: json['total_patient'],
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
  final int? submitted;
  final int? resubmitted;
  final int? reviewed;
  final int? approved;
  final int? rejected;

  StatusCount({
    this.submitted,
    this.resubmitted,
    this.reviewed,
    this.approved,
    this.rejected,
  });

  factory StatusCount.fromJson(Map<String, dynamic> json) {
    return StatusCount(
      submitted: json['SUBMITTED'],
      resubmitted: json['RESUBMITTED'],
      reviewed: json['REVIEWED'],
      approved: json['APPROVED'],
      rejected: json['REJECTED'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SUBMITTED': submitted,
      'RESUBMITTED': resubmitted,
      'REVIEWED': reviewed,
      'APPROVED': approved,
      'REJECTED': rejected,
    };
  }
}
