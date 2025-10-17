import 'package:flutter_test/flutter_test.dart';
import 'package:ai_response_selector/src/models/selection_result.dart';
import 'package:ai_response_selector/src/models/select_option.dart';
import 'package:ai_response_selector/src/models/ai_response.dart';

void main() {
  group('SelectionResult', () {
    late List<SelectOption> selectedOptions;
    late List<AIResponse> aiResponses;
    late DateTime submittedAt;
    late SelectionResult selectionResult;

    setUp(() {
      selectedOptions = [
        SelectOption(
          text: 'Option 1',
          id: 'option_1',
          aiResponseId: 'response_1',
          isSelected: true,
        ),
        SelectOption(
          text: 'Option 2',
          id: 'option_2',
          aiResponseId: 'response_1',
          isSelected: true,
        ),
      ];

      aiResponses = [
        AIResponse(
          id: 'response_1',
          question: 'Test question',
          responseText: 'Test response',
          timestamp: DateTime(2024, 1, 1),
        ),
      ];

      submittedAt = DateTime(2024, 1, 1, 12, 0, 0);

      selectionResult = SelectionResult(
        selectedOptions: selectedOptions,
        aiResponses: aiResponses,
        submittedAt: submittedAt,
        totalOptions: 5,
        selectedCount: 2,
        metadata: {'key': 'value'},
      );
    });

    test('should create SelectionResult with all properties', () {
      expect(selectionResult.selectedOptions, selectedOptions);
      expect(selectionResult.aiResponses, aiResponses);
      expect(selectionResult.submittedAt, submittedAt);
      expect(selectionResult.totalOptions, 5);
      expect(selectionResult.selectedCount, 2);
      expect(selectionResult.metadata, {'key': 'value'});
    });

    test('should calculate selection percentage correctly', () {
      expect(selectionResult.selectionPercentage, 40.0); // 2/5 * 100
    });

    test('should return 0% when totalOptions is 0', () {
      final result =
          selectionResult.copyWith(totalOptions: 0, selectedCount: 0);
      expect(result.selectionPercentage, 0.0);
    });

    test('should get selected texts', () {
      final texts = selectionResult.selectedTexts;
      expect(texts, ['Option 1', 'Option 2']);
    });

    test('should get selected IDs', () {
      final ids = selectionResult.selectedIds;
      expect(ids, ['option_1', 'option_2']);
    });

    test('should check if has selections', () {
      expect(selectionResult.hasSelections, true);

      final emptyResult = SelectionResult(
        selectedOptions: [],
        aiResponses: aiResponses,
        submittedAt: submittedAt,
        totalOptions: 5,
        selectedCount: 0,
      );
      expect(emptyResult.hasSelections, false);
    });

    test('should generate summary', () {
      final summary = selectionResult.summary;
      expect(summary, 'Selected 2 out of 5 options (40.0%)');
    });

    test('should create SelectionResult from JSON', () {
      final json = {
        'selectedOptions': [
          {
            'text': 'Option 1',
            'id': 'option_1',
            'aiResponseId': 'response_1',
            'isSelected': true,
          }
        ],
        'aiResponses': [
          {
            'id': 'response_1',
            'question': 'Test question',
            'responseText': 'Test response',
            'timestamp': '2024-01-01T00:00:00.000Z',
          }
        ],
        'submittedAt': '2024-01-01T12:00:00.000Z',
        'totalOptions': 5,
        'selectedCount': 1,
        'metadata': {'key': 'value'},
      };

      final result = SelectionResult.fromJson(json);

      expect(result.selectedOptions.length, 1);
      expect(result.aiResponses.length, 1);
      expect(result.submittedAt, submittedAt);
      expect(result.totalOptions, 5);
      expect(result.selectedCount, 1);
      expect(result.metadata, {'key': 'value'});
    });

    test('should convert SelectionResult to JSON', () {
      final json = selectionResult.toJson();

      expect(json['selectedOptions'], isA<List>());
      expect(json['aiResponses'], isA<List>());
      expect(json['submittedAt'], '2024-01-01T12:00:00.000Z');
      expect(json['totalOptions'], 5);
      expect(json['selectedCount'], 2);
      expect(json['metadata'], {'key': 'value'});
    });

    test('should support equality comparison', () {
      final sameResult = SelectionResult(
        selectedOptions: selectedOptions,
        aiResponses: aiResponses,
        submittedAt: submittedAt,
        totalOptions: 5,
        selectedCount: 2,
        metadata: {'key': 'value'},
      );

      final differentResult = SelectionResult(
        selectedOptions: selectedOptions,
        aiResponses: aiResponses,
        submittedAt: submittedAt,
        totalOptions: 10,
        selectedCount: 2,
        metadata: {'key': 'value'},
      );

      expect(selectionResult, equals(sameResult));
      expect(selectionResult, isNot(equals(differentResult)));
    });

    test('should have consistent hashCode', () {
      final sameResult = SelectionResult(
        selectedOptions: selectedOptions,
        aiResponses: aiResponses,
        submittedAt: submittedAt,
        totalOptions: 5,
        selectedCount: 2,
        metadata: {'key': 'value'},
      );

      expect(selectionResult.hashCode, equals(sameResult.hashCode));
    });

    test('should have meaningful toString', () {
      final string = selectionResult.toString();
      expect(string, contains('2'));
      expect(string, contains('5'));
      expect(string, contains('2024-01-01 12:00:00'));
    });

    test('should handle null metadata', () {
      final resultWithoutMetadata = SelectionResult(
        selectedOptions: selectedOptions,
        aiResponses: aiResponses,
        submittedAt: submittedAt,
        totalOptions: 5,
        selectedCount: 2,
      );

      expect(resultWithoutMetadata.metadata, isNull);
    });

    test('should handle empty selections', () {
      final emptyResult = SelectionResult(
        selectedOptions: [],
        aiResponses: aiResponses,
        submittedAt: submittedAt,
        totalOptions: 5,
        selectedCount: 0,
      );

      expect(emptyResult.selectedTexts, isEmpty);
      expect(emptyResult.selectedIds, isEmpty);
      expect(emptyResult.hasSelections, false);
      expect(emptyResult.selectionPercentage, 0.0);
      expect(emptyResult.summary, 'Selected 0 out of 5 options (0.0%)');
    });
  });
}
