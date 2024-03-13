import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dine_connect/pages/register_page.dart';
import 'package:mockito/mockito.dart';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:dine_connect/components/my_button.dart';
import 'package:dine_connect/components/my_text_form_field.dart';


// Mock class for AuthService
class MockAuthService extends Mock implements AuthService {}
class MockUserCredential extends Mock implements UserCredential {}


void main() {
  group('RegisterPage Tests', () {
    late AuthService mockAuthService;

    setUp(() async {
      mockAuthService = MockAuthService();
    });

    testWidgets('RegisterPage widgets are present', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage(onTap: () {})));

      // check for email, password and confirm password fields and register button
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('confirmPasswordField')), findsOneWidget);
      expect(find.widgetWithText(MyButton, 'Register'), findsOneWidget);
    });

    testWidgets('Displays error messages for invalid input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage(onTap: () {})));

      // Enter invalid email address.
      await tester.enterText(find.byType(MyTextFormField).at(0), 'not_valid_email');
      // Enter password that is too short.
      await tester.enterText(find.byKey(const Key('passwordField')), 'short');
      // Enter non-matching confirmation password.
      await tester.enterText(find.byKey(const Key('confirmPasswordField')), 'notmatching');

      // Attempt to register.
      await tester.tap(find.widgetWithText(MyButton, 'Register'));
      await tester.pump(); // Rebuild the widget with the new text.

      // Check for email validation error message
      expect(find.text('Invalid email'), findsOneWidget);
      // Check for password length validation error message
      expect(find.text('Password must be at least 8 characters long'), findsAny);
      // Check for password match validation error message
      expect(find.text('Passwords do not match'), findsOneWidget);

    });

  });
}
