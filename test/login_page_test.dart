import 'package:dine_connect/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dine_connect/pages/login_page.dart'; // Update with the correct path
import 'package:dine_connect/services/authentication/auth_service.dart';

// Mock class for AuthService
class MockAuthService extends Mock implements AuthService {}

void main() {
  // Define the tests here

  testWidgets('LoginPage widgets are present', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage(onTap: () {})));

    // Check for email and password fields and login button
    expect(find.byKey(Key('emailField')), findsOneWidget);
    expect(find.byKey(Key('passwordField')), findsOneWidget);
    expect(find.widgetWithText(MyButton, 'Login'), findsOneWidget);
  });


  testWidgets('Displays error message for invalid email and password', (WidgetTester tester) async {
    // Setup the test environment.
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(1080, 1920)), // Make sure this size fits all your widgets
        child: LoginPage(onTap: () {}),
      ),
    ));

    // Enter an invalid email address.
    await tester.enterText(find.byKey(const Key('emailField')), 'not_valid');
    await tester.pumpAndSettle(); // Wait for the UI to show the error message.

    // Enter an empty password.
    await tester.enterText(find.byKey(const Key('passwordField')), '');
    await tester.pumpAndSettle(); // Wait for the UI to show the error message.


    final Finder loginButtonFinder = find.widgetWithText(GestureDetector, 'Login');
    await tester.ensureVisible(loginButtonFinder);
    await tester.pumpAndSettle(); // Wait for any animations to complete
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle(); // Allow time for the onTap event to be processed


    // Check for the expected error messages.
    expect(find.text('Invalid email'), findsOneWidget); // Confirm the invalid email message is shown.
    expect(find.text('Please enter a password'), findsOneWidget); // Confirm the password message is shown.
  });



}
