import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ai_response_selector/ai_response_selector.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AI Response Selector Integration Tests', () {
    testWidgets('Performance test with large number of options',
        (WidgetTester tester) async {
      // Create a large number of AI responses to test performance
      final largeResponses = List.generate(50, (index) {
        return AIResponse(
          id: 'response_$index',
          question: 'Question $index',
          responseText: '''Response $index with multiple options:
• Option A for response $index
• Option B for response $index
• Option C for response $index
• Option D for response $index
• Option E for response $index''',
          timestamp: DateTime.now(),
        );
      });

      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: largeResponses,
              onSubmitted: (result) {
                print('Submitted ${result.selectedCount} options');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      stopwatch.stop();
      print(
          'Widget build time with 250 options: ${stopwatch.elapsedMilliseconds}ms');

      // Verify that all options are rendered
      expect(find.text('Option A for response 0'), findsOneWidget);
      expect(find.text('Option E for response 49'), findsOneWidget);

      // Test scrolling performance
      stopwatch.reset();
      stopwatch.start();

      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pumpAndSettle();

      stopwatch.stop();
      print('Scroll performance: ${stopwatch.elapsedMilliseconds}ms');

      // Test selection performance
      stopwatch.reset();
      stopwatch.start();

      // Select multiple options
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Option A for response $i'));
        await tester.pump();
      }

      stopwatch.stop();
      print(
          'Selection performance (10 selections): ${stopwatch.elapsedMilliseconds}ms');

      // Verify selections
      expect(find.text('10/'), findsOneWidget);
    });

    testWidgets('Memory usage test with rapid operations',
        (WidgetTester tester) async {
      final responses = List.generate(10, (index) {
        return AIResponse(
          id: 'response_$index',
          question: 'Question $index',
          responseText: '''Response $index:
• Option A
• Option B
• Option C''',
          timestamp: DateTime.now(),
        );
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: responses,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Perform rapid selection operations
      for (int i = 0; i < 5; i++) {
        // Select all
        await tester.tap(find.text('Select All'));
        await tester.pump();

        // Clear all
        await tester.tap(find.text('Clear All'));
        await tester.pump();
      }

      // Verify widget still works correctly
      expect(find.text('0/'), findsOneWidget);
    });

    testWidgets('Theme switching performance test',
        (WidgetTester tester) async {
      final responses = [
        AIResponse(
          id: 'response_1',
          question: 'Test question',
          responseText: '''Test response:
• Option A
• Option B
• Option C''',
          timestamp: DateTime.now(),
        ),
      ];

      bool isDarkMode = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDarkMode = !isDarkMode;
                        });
                      },
                      child: Text('Toggle Theme'),
                    ),
                    Expanded(
                      child: AIResponseSelectorWidget(
                        aiResponses: responses,
                        theme: isDarkMode
                            ? AIResponseSelectorTheme.darkTheme()
                            : AIResponseSelectorTheme.defaultTheme(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test theme switching performance
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Toggle Theme'));
        await tester.pumpAndSettle();
      }

      stopwatch.stop();
      print(
          'Theme switching performance (10 switches): ${stopwatch.elapsedMilliseconds}ms');

      // Verify widget still functions
      expect(find.text('Select Options'), findsOneWidget);
    });

    testWidgets('Large response text performance test',
        (WidgetTester tester) async {
      // Create response with very long text
      final longResponse = AIResponse(
        id: 'long_response',
        question: 'Long response test',
        responseText: List.generate(
                100,
                (index) =>
                    '• Very long option text $index that contains a lot of words and should test the performance of rendering long text options')
            .join('\n'),
        timestamp: DateTime.now(),
      );

      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: [longResponse],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      stopwatch.stop();
      print('Long text rendering time: ${stopwatch.elapsedMilliseconds}ms');

      // Verify scrolling works with long text
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Verify selection works
      await tester.tap(find.text(
          '• Very long option text 0 that contains a lot of words and should test the performance of rendering long text options'));
      await tester.pumpAndSettle();

      expect(find.text('1/'), findsOneWidget);
    });

    testWidgets('Rapid add/remove responses performance test',
        (WidgetTester tester) async {
      final responses = [
        AIResponse(
          id: 'response_1',
          question: 'Test question',
          responseText: '''Test response:
• Option A
• Option B''',
          timestamp: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: responses,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test rapid updates (simulating dynamic content)
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 20; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AIResponseSelectorWidget(
                aiResponses: [
                  ...responses,
                  AIResponse(
                    id: 'response_$i',
                    question: 'Question $i',
                    responseText: '''Response $i:
• Option A
• Option B''',
                    timestamp: DateTime.now(),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();
      }

      stopwatch.stop();
      print(
          'Rapid updates performance (20 updates): ${stopwatch.elapsedMilliseconds}ms');

      // Verify widget still works
      expect(find.text('Select Options'), findsOneWidget);
    });

    testWidgets('Submit performance with many selections',
        (WidgetTester tester) async {
      final responses = List.generate(20, (index) {
        return AIResponse(
          id: 'response_$index',
          question: 'Question $index',
          responseText: '''Response $index:
• Option A
• Option B
• Option C
• Option D
• Option E''',
          timestamp: DateTime.now(),
        );
      });

      SelectionResult? submittedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIResponseSelectorWidget(
              aiResponses: responses,
              onSubmitted: (result) {
                submittedResult = result;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Select all options
      await tester.tap(find.text('Select All'));
      await tester.pumpAndSettle();

      // Test submit performance
      final stopwatch = Stopwatch()..start();

      await tester.tap(find.text('Submit Selections'));
      await tester.pumpAndSettle();

      stopwatch.stop();
      print(
          'Submit performance with 100 selections: ${stopwatch.elapsedMilliseconds}ms');

      expect(submittedResult, isNotNull);
      expect(submittedResult!.selectedCount, 100);
    });
  });
}
