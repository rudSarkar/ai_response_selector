/// Represents a selectable option derived from an AI response
class SelectOption {
  /// The text content of this option
  final String text;

  /// Unique identifier for this option
  final String id;

  /// The AI response this option was derived from
  final String aiResponseId;

  /// Whether this option is currently selected
  final bool isSelected;

  /// Additional metadata for this option
  final Map<String, dynamic>? metadata;

  /// The confidence score of this option (0.0 to 1.0)
  final double? confidence;

  const SelectOption({
    required this.text,
    required this.id,
    required this.aiResponseId,
    this.isSelected = false,
    this.metadata,
    this.confidence,
  });

  /// Create SelectOption from JSON
  factory SelectOption.fromJson(Map<String, dynamic> json) {
    return SelectOption(
      text: json['text'] as String,
      id: json['id'] as String,
      aiResponseId: json['aiResponseId'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      confidence: (json['confidence'] as num?)?.toDouble(),
    );
  }

  /// Convert SelectOption to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'id': id,
      'aiResponseId': aiResponseId,
      'isSelected': isSelected,
      'metadata': metadata,
      'confidence': confidence,
    };
  }

  /// Create a copy of this SelectOption with updated fields
  SelectOption copyWith({
    String? text,
    String? id,
    String? aiResponseId,
    bool? isSelected,
    Map<String, dynamic>? metadata,
    double? confidence,
  }) {
    return SelectOption(
      text: text ?? this.text,
      id: id ?? this.id,
      aiResponseId: aiResponseId ?? this.aiResponseId,
      isSelected: isSelected ?? this.isSelected,
      metadata: metadata ?? this.metadata,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectOption &&
        other.text == text &&
        other.id == id &&
        other.aiResponseId == aiResponseId &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        id.hashCode ^
        aiResponseId.hashCode ^
        isSelected.hashCode;
  }

  @override
  String toString() {
    return 'SelectOption(id: $id, text: $text, isSelected: $isSelected)';
  }
}
