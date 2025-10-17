import 'package:flutter_test/flutter_test.dart';
import 'package:ai_response_selector/src/models/ai_response.dart';

void main() {
  group('AIResponse', () {
    late AIResponse aiResponse;
    late DateTime testTimestamp;

    setUp(() {
      testTimestamp = DateTime(2024, 1, 1, 12, 0, 0);
      aiResponse = AIResponse(
        id: 'test_id',
        question: 'Test question',
        responseText: 'Test response',
        timestamp: testTimestamp,
        metadata: {'key': 'value'},
      );
    });

    test('should create AIResponse with all properties', () {
      expect(aiResponse.id, 'test_id');
      expect(aiResponse.question, 'Test question');
      expect(aiResponse.responseText, 'Test response');
      expect(aiResponse.timestamp, testTimestamp);
      expect(aiResponse.metadata, {'key': 'value'});
    });

    test('should create AIResponse from JSON', () {
      final json = {
        'id': 'test_id',
        'question': 'Test question',
        'responseText': 'Test response',
        'timestamp': '2024-01-01T12:00:00.000Z',
        'metadata': {'key': 'value'},
      };

      final result = AIResponse.fromJson(json);

      expect(result.id, 'test_id');
      expect(result.question, 'Test question');
      expect(result.responseText, 'Test response');
      expect(result.timestamp, testTimestamp);
      expect(result.metadata, {'key': 'value'});
    });

    test('should convert AIResponse to JSON', () {
      final json = aiResponse.toJson();

      expect(json['id'], 'test_id');
      expect(json['question'], 'Test question');
      expect(json['responseText'], 'Test response');
      expect(json['timestamp'], '2024-01-01T12:00:00.000Z');
      expect(json['metadata'], {'key': 'value'});
    });

    test('should create copy with updated fields', () {
      final updated = aiResponse.copyWith(
        responseText: 'Updated response',
        metadata: {'newKey': 'newValue'},
      );

      expect(updated.id, 'test_id');
      expect(updated.question, 'Test question');
      expect(updated.responseText, 'Updated response');
      expect(updated.timestamp, testTimestamp);
      expect(updated.metadata, {'newKey': 'newValue'});
    });

    test('should support equality comparison', () {
      final sameResponse = AIResponse(
        id: 'test_id',
        question: 'Test question',
        responseText: 'Test response',
        timestamp: testTimestamp,
        metadata: {'key': 'value'},
      );

      final differentResponse = AIResponse(
        id: 'different_id',
        question: 'Test question',
        responseText: 'Test response',
        timestamp: testTimestamp,
        metadata: {'key': 'value'},
      );

      expect(aiResponse, equals(sameResponse));
      expect(aiResponse, isNot(equals(differentResponse)));
    });

    test('should have consistent hashCode', () {
      final sameResponse = AIResponse(
        id: 'test_id',
        question: 'Test question',
        responseText: 'Test response',
        timestamp: testTimestamp,
        metadata: {'key': 'value'},
      );

      expect(aiResponse.hashCode, equals(sameResponse.hashCode));
    });

    test('should have meaningful toString', () {
      final string = aiResponse.toString();
      expect(string, contains('test_id'));
      expect(string, contains('Test question'));
      expect(string, contains('Test response'));
    });

    test('should handle null metadata', () {
      final responseWithoutMetadata = AIResponse(
        id: 'test_id',
        question: 'Test question',
        responseText: 'Test response',
        timestamp: testTimestamp,
      );

      expect(responseWithoutMetadata.metadata, isNull);
    });

    test('should handle JSON without metadata', () {
      final json = {
        'id': 'test_id',
        'question': 'Test question',
        'responseText': 'Test response',
        'timestamp': '2024-01-01T12:00:00.000Z',
      };

      final result = AIResponse.fromJson(json);
      expect(result.metadata, isNull);
    });
  });
}
