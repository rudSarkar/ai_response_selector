import 'package:flutter_test/flutter_test.dart';
import 'package:ai_response_selector/src/models/select_option.dart';

void main() {
  group('SelectOption', () {
    late SelectOption selectOption;

    setUp(() {
      selectOption = SelectOption(
        text: 'Test option',
        id: 'option_id',
        aiResponseId: 'response_id',
        isSelected: false,
        metadata: {'key': 'value'},
        confidence: 0.95,
      );
    });

    test('should create SelectOption with all properties', () {
      expect(selectOption.text, 'Test option');
      expect(selectOption.id, 'option_id');
      expect(selectOption.aiResponseId, 'response_id');
      expect(selectOption.isSelected, false);
      expect(selectOption.metadata, {'key': 'value'});
      expect(selectOption.confidence, 0.95);
    });

    test('should create SelectOption with default values', () {
      final defaultOption = SelectOption(
        text: 'Test option',
        id: 'option_id',
        aiResponseId: 'response_id',
      );

      expect(defaultOption.isSelected, false);
      expect(defaultOption.metadata, isNull);
      expect(defaultOption.confidence, isNull);
    });

    test('should create SelectOption from JSON', () {
      final json = {
        'text': 'Test option',
        'id': 'option_id',
        'aiResponseId': 'response_id',
        'isSelected': false,
        'metadata': {'key': 'value'},
        'confidence': 0.95,
      };

      final result = SelectOption.fromJson(json);

      expect(result.text, 'Test option');
      expect(result.id, 'option_id');
      expect(result.aiResponseId, 'response_id');
      expect(result.isSelected, false);
      expect(result.metadata, {'key': 'value'});
      expect(result.confidence, 0.95);
    });

    test('should convert SelectOption to JSON', () {
      final json = selectOption.toJson();

      expect(json['text'], 'Test option');
      expect(json['id'], 'option_id');
      expect(json['aiResponseId'], 'response_id');
      expect(json['isSelected'], false);
      expect(json['metadata'], {'key': 'value'});
      expect(json['confidence'], 0.95);
    });

    test('should create copy with updated fields', () {
      final updated = selectOption.copyWith(
        text: 'Updated option',
        isSelected: true,
        confidence: 0.99,
      );

      expect(updated.text, 'Updated option');
      expect(updated.id, 'option_id');
      expect(updated.aiResponseId, 'response_id');
      expect(updated.isSelected, true);
      expect(updated.metadata, {'key': 'value'});
      expect(updated.confidence, 0.99);
    });

    test('should support equality comparison', () {
      final sameOption = SelectOption(
        text: 'Test option',
        id: 'option_id',
        aiResponseId: 'response_id',
        isSelected: false,
        metadata: {'key': 'value'},
        confidence: 0.95,
      );

      final differentOption = SelectOption(
        text: 'Different option',
        id: 'option_id',
        aiResponseId: 'response_id',
        isSelected: false,
        metadata: {'key': 'value'},
        confidence: 0.95,
      );

      expect(selectOption, equals(sameOption));
      expect(selectOption, isNot(equals(differentOption)));
    });

    test('should have consistent hashCode', () {
      final sameOption = SelectOption(
        text: 'Test option',
        id: 'option_id',
        aiResponseId: 'response_id',
        isSelected: false,
        metadata: {'key': 'value'},
        confidence: 0.95,
      );

      expect(selectOption.hashCode, equals(sameOption.hashCode));
    });

    test('should have meaningful toString', () {
      final string = selectOption.toString();
      expect(string, contains('option_id'));
      expect(string, contains('Test option'));
      expect(string, contains('false'));
    });

    test('should handle null metadata and confidence', () {
      final optionWithoutOptional = SelectOption(
        text: 'Test option',
        id: 'option_id',
        aiResponseId: 'response_id',
      );

      expect(optionWithoutOptional.metadata, isNull);
      expect(optionWithoutOptional.confidence, isNull);
    });

    test('should handle JSON without optional fields', () {
      final json = {
        'text': 'Test option',
        'id': 'option_id',
        'aiResponseId': 'response_id',
        'isSelected': false,
      };

      final result = SelectOption.fromJson(json);
      expect(result.metadata, isNull);
      expect(result.confidence, isNull);
    });

    test('should handle JSON with null optional fields', () {
      final json = {
        'text': 'Test option',
        'id': 'option_id',
        'aiResponseId': 'response_id',
        'isSelected': false,
        'metadata': null,
        'confidence': null,
      };

      final result = SelectOption.fromJson(json);
      expect(result.metadata, isNull);
      expect(result.confidence, isNull);
    });
  });
}
