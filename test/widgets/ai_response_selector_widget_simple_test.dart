import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_response_selector/src/widgets/ai_response_selector_widget.dart';
import 'package:ai_response_selector/src/models/ai_response.dart';

void main() {
  group('AIResponseSelectorWidget Simple Tests', () {
    late List<AIResponse> testResponses;

    setUp(() {
      testResponses = [
        AIResponse(
          id: 'response_1',
          question: 'What are the benefits of exercise?',
          responseText: '''Regular exercise provides numerous health benefits:
• Improves cardiovascular health
• Strengthens muscles and bones
• Boosts mental health and mood''',
          timestamp: DateTime.now(),
        ),
      ];
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Just verify the widget renders without errors
      expect(find.byType(AIResponseSelectorWidget), findsOneWidget);
    });

    testWidgets('should show empty state when no responses',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: [],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No options available'), findsOneWidget);
    });

    testWidgets('should show submit button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
              showSubmitButton: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Submit Selections'), findsOneWidget);
    });

    testWidgets('should hide submit button when showSubmitButton is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
              showSubmitButton: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Submit Selections'), findsNothing);
    });

    testWidgets('should show custom submit button text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
              submitButtonText: 'Submit My Choices',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Submit My Choices'), findsOneWidget);
    });

    testWidgets('should show Select All and Clear All buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Select All'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
    });
  });
}
