import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_response_selector/src/widgets/ai_response_selector_widget.dart';
import 'package:ai_response_selector/src/models/ai_response.dart';
import 'package:ai_response_selector/src/models/selection_result.dart';

void main() {
  group('AIResponseSelectorWidget', () {
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
        AIResponse(
          id: 'response_2',
          question: 'What are healthy foods?',
          responseText: '''Here are some healthy food options:
• Fruits and vegetables
• Whole grains
• Lean proteins''',
          timestamp: DateTime.now(),
        ),
      ];
    });

    testWidgets('should display AI responses as selectable options',
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

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Check if options are displayed (they might be in a scrollable list)
      expect(find.text('Improves cardiovascular health'), findsWidgets);
      expect(find.text('Strengthens muscles and bones'), findsWidgets);
      expect(find.text('Fruits and vegetables'), findsWidgets);
      expect(find.text('Whole grains'), findsWidgets);
    });

    testWidgets('should show selection count', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
              showSelectionCount: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if selection count is displayed
      expect(find.text('Select Options'), findsOneWidget);
      expect(find.textContaining('/'), findsOneWidget);
    });

    testWidgets('should toggle selection when option is tapped',
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

      // Find and tap the first option
      final firstOption = find.text('Improves cardiovascular health');
      expect(firstOption, findsOneWidget);

      await tester.tap(firstOption);
      await tester.pumpAndSettle();

      // Check if selection count updated
      expect(find.text('1/'), findsOneWidget);
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

    testWidgets('should call onSubmitted when submit button is pressed',
        (WidgetTester tester) async {
      SelectionResult? submittedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
              onSubmitted: (result) {
                submittedResult = result;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Select an option first
      await tester.tap(find.text('Improves cardiovascular health'));
      await tester.pumpAndSettle();

      // Tap submit button
      await tester.tap(find.text('Submit Selections'));
      await tester.pumpAndSettle();

      expect(submittedResult, isNotNull);
      expect(submittedResult!.selectedCount, 1);
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

    testWidgets('should select all options when Select All is tapped',
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

      // Tap Select All
      await tester.tap(find.text('Select All'));
      await tester.pumpAndSettle();

      // Check if all options are selected (count should be total options)
      final totalOptions = testResponses
          .expand((response) => response.responseText
              .split('\n')
              .where((line) => line.trim().isNotEmpty))
          .length;
      expect(find.text('$totalOptions/'), findsOneWidget);
    });

    testWidgets('should clear all selections when Clear All is tapped',
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

      // Select all first
      await tester.tap(find.text('Select All'));
      await tester.pumpAndSettle();

      // Then clear all
      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      // Check if no options are selected
      expect(find.text('0/'), findsOneWidget);
    });

    testWidgets('should use custom theme', (WidgetTester tester) async {
      final customTheme = AIResponseSelectorTheme(
        backgroundColor: Colors.red,
        headerBackgroundColor: Colors.blue,
        footerBackgroundColor: Colors.green,
        optionColor: Colors.yellow,
        selectedOptionColor: Colors.purple,
        optionBorderColor: Colors.orange,
        selectedBorderColor: Colors.pink,
        iconColor: Colors.brown,
        selectedIconColor: Colors.cyan,
        confidenceBackgroundColor: Colors.indigo,
        submitButtonColor: Colors.teal,
        submitButtonTextColor: Colors.white,
        headerTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        countTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
        optionTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        selectedTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        confidenceTextStyle: const TextStyle(fontSize: 12, color: Colors.green),
        submitButtonTextStyle:
            const TextStyle(fontSize: 16, color: Colors.white),
        actionButtonTextStyle:
            const TextStyle(fontSize: 14, color: Colors.blue),
        emptyStateTextStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        borderRadius: 20,
        optionBorderRadius: 10,
        submitButtonBorderRadius: 10,
        borderWidth: 2,
        iconSize: 30,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
              theme: customTheme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.text('Select Options'), findsOneWidget);
    });

    testWidgets('should use dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
              theme: AIResponseSelectorTheme.darkTheme(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.text('Select Options'), findsOneWidget);
    });

    testWidgets('should call onSelectionChanged when selection changes',
        (WidgetTester tester) async {
      List<dynamic>? changedSelections;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: testResponses,
              onSelectionChanged: (selections) {
                changedSelections = selections;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Select an option
      await tester.tap(find.text('Improves cardiovascular health'));
      await tester.pumpAndSettle();

      expect(changedSelections, isNotNull);
      expect(changedSelections!.length, 1);
    });
  });
}
