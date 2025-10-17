/// Represents an AI response that can be converted to selectable options
class AIResponse {
  /// The original AI response text
  final String responseText;

  /// The question that prompted this response
  final String question;

  /// Unique identifier for this response
  final String id;

  /// Timestamp when the response was generated
  final DateTime timestamp;

  /// Additional metadata for the response
  final Map<String, dynamic>? metadata;

  const AIResponse({
    required this.responseText,
    required this.question,
    required this.id,
    required this.timestamp,
    this.metadata,
  });

  /// Create AIResponse from JSON
  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      responseText: json['responseText'] as String,
      question: json['question'] as String,
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert AIResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'responseText': responseText,
      'question': question,
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a copy of this AIResponse with updated fields
  AIResponse copyWith({
    String? responseText,
    String? question,
    String? id,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return AIResponse(
      responseText: responseText ?? this.responseText,
      question: question ?? this.question,
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AIResponse &&
        other.responseText == responseText &&
        other.question == question &&
        other.id == id &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return responseText.hashCode ^
        question.hashCode ^
        id.hashCode ^
        timestamp.hashCode;
  }

  @override
  String toString() {
    return 'AIResponse(id: $id, question: $question, responseText: $responseText)';
  }
}
