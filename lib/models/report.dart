class Report {
  final String reportingUserId;
  final String reportedUserId;
  final String reportReason;
  final DateTime reportTime;
  final bool isReviewed;

  Report({
    required this.reportingUserId,
    required this.reportedUserId,
    required this.reportReason,
    required this.reportTime,
    this.isReviewed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'reportingUserId': reportingUserId,
      'reportedUserId': reportedUserId,
      'reportReason': reportReason,
      'reportTime': reportTime,
      'isReviewed': isReviewed
    };
  }
}
