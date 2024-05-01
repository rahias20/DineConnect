import 'package:dine_connect/models/report.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Report Class Tests', () {
    // Test case for constructor initialization
    test('Report Constructor Test', () {
      // Initialize a Report instance with sample data
      final report = Report(
        reportingUserId: 'user123',
        reportedUserId: 'user456',
        reportReason: 'Inappropriate behavior',
        reportTime: DateTime.now(),
        isReviewed: true,
      );

      // Assertions to verify that the attributes are initialized correctly
      expect(report.reportingUserId, 'user123');
      expect(report.reportedUserId, 'user456');
      expect(report.reportReason, 'Inappropriate behavior');
      expect(report.isReviewed, true);
    });

    // Test case for toMap() method
    test('toMap() Method Test', () {
      // Initialize a Report instance with sample data
      final report = Report(
        reportingUserId: 'user123',
        reportedUserId: 'user456',
        reportReason: 'Inappropriate behavior',
        reportTime: DateTime.now(),
        isReviewed: true,
      );

      // Expected Map output based on the initialized attributes
      final expectedMap = {
        'reportingUserId': 'user123',
        'reportedUserId': 'user456',
        'reportReason': 'Inappropriate behavior',
        'reportTime': report.reportTime, // DateTime object
        'isReviewed': true,
      };

      // Call the toMap() method and compare the output with the expected Map
      expect(report.toMap(), expectedMap);
    });
  });
}
