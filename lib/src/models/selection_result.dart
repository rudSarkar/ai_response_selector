import 'select_option.dart';
import 'ai_response.dart';

/// Represents the result of user selections from AI responses
class SelectionResult {
  /// List of all selected options
  final List<SelectOption> selectedOptions;

  /// List of all AI responses that were processed
  final List<AIResponse> aiResponses;

  /// Timestamp when the selection was submitted
  final DateTime submittedAt;

  /// Total number of options that were available
  final int totalOptions;

  /// Number of options that were selected
  final int selectedCount;

  /// Additional metadata for the selection result
  final Map<String, dynamic>? metadata;

  const SelectionResult({
    required this.selectedOptions,
    required this.aiResponses,
    required this.submittedAt,
    required this.totalOptions,
    required this.selectedCount,
    this.metadata,
  });

  /// Create SelectionResult from JSON
  factory SelectionResult.fromJson(Map<String, dynamic> json) {
    return SelectionResult(
      selectedOptions: (json['selectedOptions'] as List)
          .map((e) => SelectOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiResponses: (json['aiResponses'] as List)
          .map((e) => AIResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      totalOptions: json['totalOptions'] as int,
      selectedCount: json['selectedCount'] as int,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert SelectionResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'selectedOptions': selectedOptions.map((e) => e.toJson()).toList(),
      'aiResponses': aiResponses.map((e) => e.toJson()).toList(),
      'submittedAt': submittedAt.toIso8601String(),
      'totalOptions': totalOptions,
      'selectedCount': selectedCount,
      'metadata': metadata,
    };
  }

  /// Get the selection percentage
  double get selectionPercentage {
    if (totalOptions == 0) return 0.0;
    return (selectedCount / totalOptions) * 100;
  }

  /// Get all selected option texts as a list
  List<String> get selectedTexts {
    return selectedOptions.map((option) => option.text).toList();
  }

  /// Get all selected option IDs as a list
  List<String> get selectedIds {
    return selectedOptions.map((option) => option.id).toList();
  }

  /// Check if any options were selected
  bool get hasSelections => selectedCount > 0;

  /// Get a summary of the selection result
  String get summary {
    return 'Selected $selectedCount out of $totalOptions options (${selectionPercentage.toStringAsFixed(1)}%)';
  }

  /// Create a copy of this SelectionResult with updated fields
  SelectionResult copyWith({
    List<SelectOption>? selectedOptions,
    List<AIResponse>? aiResponses,
    DateTime? submittedAt,
    int? totalOptions,
    int? selectedCount,
    Map<String, dynamic>? metadata,
  }) {
    return SelectionResult(
      selectedOptions: selectedOptions ?? this.selectedOptions,
      aiResponses: aiResponses ?? this.aiResponses,
      submittedAt: submittedAt ?? this.submittedAt,
      totalOptions: totalOptions ?? this.totalOptions,
      selectedCount: selectedCount ?? this.selectedCount,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectionResult &&
        other.selectedCount == selectedCount &&
        other.totalOptions == totalOptions &&
        other.submittedAt == submittedAt;
  }

  @override
  int get hashCode {
    return selectedCount.hashCode ^
        totalOptions.hashCode ^
        submittedAt.hashCode;
  }

  @override
  String toString() {
    return 'SelectionResult(selectedCount: $selectedCount, totalOptions: $totalOptions, submittedAt: $submittedAt)';
  }
}
