// Attributes of the report, including user IDs,
// the reason for the report, and the time it was reported
class Report {
  final String reportingUserId; // The ID of the user who is making the report
  final String reportedUserId; // The ID of the user being reported
  final String reportReason; // Reason for the report
  final DateTime reportTime; // The time at which the report was made
  final bool
      isReviewed; // Status to check if the report has been reviewed by an admin

  // Constructor for the class, with named parameters and a default value for 'isReviewed'
  Report({
    required this.reportingUserId,
    required this.reportedUserId,
    required this.reportReason,
    required this.reportTime,
    this.isReviewed = false, // Default value set to false
  });

  // Method to convert the report instance into a Map
  // which can be used to store the data in a database
  Map<String, dynamic> toMap() {
    return {
      // Mapping each attribute to a key in the Map
      'reportingUserId': reportingUserId,
      'reportedUserId': reportedUserId,
      'reportReason': reportReason,
      'reportTime': reportTime, // Converting DateTime to a string for storage
      'isReviewed': isReviewed
    };
  }
}
