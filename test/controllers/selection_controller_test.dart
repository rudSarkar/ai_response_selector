import 'package:flutter_test/flutter_test.dart';
import 'package:ai_response_selector/src/controllers/selection_controller.dart';
import 'package:ai_response_selector/src/models/ai_response.dart';
import 'package:ai_response_selector/src/models/select_option.dart';
import 'package:ai_response_selector/src/models/selection_result.dart';

void main() {
  group('SelectionController', () {
    late SelectionController controller;
    late List<AIResponse> testResponses;

    setUp(() {
      controller = SelectionController();
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

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with AI responses', () {
      controller.initializeWithAIResponses(testResponses);

      expect(controller.totalOptions, greaterThan(0));
      expect(controller.selectedCount, 0);
      expect(controller.hasSelections, false);
    });

    test('should generate options from AI responses', () {
      controller.initializeWithAIResponses(testResponses);

      final options = controller.options;
      expect(options, isNotEmpty);
      expect(options.every((option) => option.text.isNotEmpty), true);
      expect(options.every((option) => option.aiResponseId.isNotEmpty), true);
    });

    test('should toggle selection', () {
      controller.initializeWithAIResponses(testResponses);
      final firstOption = controller.options.first;

      expect(controller.selections[firstOption.id], isNull);

      controller.toggleSelection(firstOption.id);
      expect(controller.selections[firstOption.id], true);

      controller.toggleSelection(firstOption.id);
      expect(controller.selections[firstOption.id], false);
    });

    test('should set selection state', () {
      controller.initializeWithAIResponses(testResponses);
      final firstOption = controller.options.first;

      controller.setSelection(firstOption.id, true);
      expect(controller.selections[firstOption.id], true);

      controller.setSelection(firstOption.id, false);
      expect(controller.selections[firstOption.id], false);
    });

    test('should select all options', () {
      controller.initializeWithAIResponses(testResponses);

      controller.selectAll();
      expect(controller.selectedCount, controller.totalOptions);
      expect(controller.hasSelections, true);
    });

    test('should deselect all options', () {
      controller.initializeWithAIResponses(testResponses);

      controller.selectAll();
      expect(controller.hasSelections, true);

      controller.deselectAll();
      expect(controller.selectedCount, 0);
      expect(controller.hasSelections, false);
    });

    test('should get selected options', () {
      controller.initializeWithAIResponses(testResponses);
      final firstOption = controller.options.first;

      controller.setSelection(firstOption.id, true);
      final selectedOptions = controller.getSelectedOptions();

      expect(selectedOptions.length, 1);
      expect(selectedOptions.first.id, firstOption.id);
    });

    test('should submit selections and create result', () {
      controller.initializeWithAIResponses(testResponses);
      final firstOption = controller.options.first;

      controller.setSelection(firstOption.id, true);
      final result = controller.submitSelections();

      expect(result, isA<SelectionResult>());
      expect(result.selectedCount, 1);
      expect(result.totalOptions, controller.totalOptions);
      expect(result.selectedOptions.length, 1);
      expect(result.selectedOptions.first.id, firstOption.id);
    });

    test('should add single AI response', () {
      controller.initializeWithAIResponses([testResponses.first]);
      final initialCount = controller.totalOptions;

      final newResponse = AIResponse(
        id: 'response_3',
        question: 'New question',
        responseText: 'New response with options:\n• Option A\n• Option B',
        timestamp: DateTime.now(),
      );

      controller.addAIResponse(newResponse);
      expect(controller.totalOptions, greaterThan(initialCount));
    });

    test('should remove AI response by ID', () {
      controller.initializeWithAIResponses(testResponses);
      final initialCount = controller.totalOptions;

      controller.removeAIResponse('response_1');
      expect(controller.totalOptions, lessThan(initialCount));
    });

    test('should clear all data', () {
      controller.initializeWithAIResponses(testResponses);
      controller.selectAll();

      expect(controller.hasSelections, true);

      controller.clear();
      expect(controller.totalOptions, 0);
      expect(controller.selectedCount, 0);
      expect(controller.hasSelections, false);
    });

    test('should emit options stream updates', () async {
      final stream = controller.optionsStream;
      controller.initializeWithAIResponses(testResponses);

      final options = await stream.first;

      expect(options, isNotEmpty);
      expect(options, isA<List<SelectOption>>());
    });

    test('should emit selections stream updates', () async {
      controller.initializeWithAIResponses(testResponses);
      final firstOption = controller.options.first;

      final stream = controller.selectionsStream;
      controller.setSelection(firstOption.id, true);

      final selections = await stream.first;
      expect(selections[firstOption.id], true);
    });

    test('should emit result stream updates', () async {
      controller.initializeWithAIResponses(testResponses);
      final firstOption = controller.options.first;

      final stream = controller.resultStream;
      controller.setSelection(firstOption.id, true);
      controller.submitSelections();

      final result = await stream.first;
      expect(result, isA<SelectionResult>());
      expect(result!.selectedCount, 1);
    });

    test('should handle empty AI responses', () {
      controller.initializeWithAIResponses([]);

      expect(controller.totalOptions, 0);
      expect(controller.selectedCount, 0);
      expect(controller.hasSelections, false);
    });

    test('should handle AI response with empty text', () {
      final emptyResponse = AIResponse(
        id: 'empty_response',
        question: 'Empty question',
        responseText: '',
        timestamp: DateTime.now(),
      );

      controller.initializeWithAIResponses([emptyResponse]);
      expect(controller.totalOptions, 0);
    });

    test('should handle AI response with single line', () {
      final singleLineResponse = AIResponse(
        id: 'single_line',
        question: 'Single line question',
        responseText: 'Single option',
        timestamp: DateTime.now(),
      );

      controller.initializeWithAIResponses([singleLineResponse]);
      expect(controller.totalOptions, 1);
      expect(controller.options.first.text, 'Single option');
    });

    test('should preserve selection state when adding responses', () {
      controller.initializeWithAIResponses([testResponses.first]);
      final firstOption = controller.options.first;
      controller.setSelection(firstOption.id, true);

      final newResponse = AIResponse(
        id: 'response_3',
        question: 'New question',
        responseText: 'New response with options:\n• Option A\n• Option B',
        timestamp: DateTime.now(),
      );

      controller.addAIResponse(newResponse);
      expect(controller.selections[firstOption.id], true);
    });

    test('should handle submission with metadata', () {
      controller.initializeWithAIResponses(testResponses);
      final firstOption = controller.options.first;
      controller.setSelection(firstOption.id, true);

      final metadata = {'source': 'test', 'version': '1.0'};
      final result = controller.submitSelections(metadata: metadata);

      expect(result.metadata, metadata);
    });
  });
}
