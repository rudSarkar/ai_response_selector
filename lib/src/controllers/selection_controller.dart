import 'dart:async';
import '../models/ai_response.dart';
import '../models/select_option.dart';
import '../models/selection_result.dart';

/// Controller for managing AI response selections
class SelectionController {
  final List<AIResponse> _aiResponses = [];
  final List<SelectOption> _options = [];
  final Map<String, bool> _selections = {};

  final StreamController<List<SelectOption>> _optionsController =
      StreamController<List<SelectOption>>.broadcast();
  final StreamController<Map<String, bool>> _selectionsController =
      StreamController<Map<String, bool>>.broadcast();
  final StreamController<SelectionResult?> _resultController =
      StreamController<SelectionResult?>.broadcast();

  /// Stream of available options
  Stream<List<SelectOption>> get optionsStream => _optionsController.stream;

  /// Stream of current selections
  Stream<Map<String, bool>> get selectionsStream =>
      _selectionsController.stream;

  /// Stream of selection results
  Stream<SelectionResult?> get resultStream => _resultController.stream;

  /// Get current options
  List<SelectOption> get options => List.unmodifiable(_options);

  /// Get current selections
  Map<String, bool> get selections => Map.unmodifiable(_selections);

  /// Get number of selected options
  int get selectedCount =>
      _selections.values.where((selected) => selected).length;

  /// Get total number of options
  int get totalOptions => _options.length;

  /// Check if any options are selected
  bool get hasSelections => selectedCount > 0;

  /// Initialize the controller with AI responses
  void initializeWithAIResponses(List<AIResponse> aiResponses) {
    _aiResponses.clear();
    _aiResponses.addAll(aiResponses);
    _generateOptions();
    _notifyOptionsChanged();
    _notifySelectionsChanged();
  }

  /// Add a single AI response
  void addAIResponse(AIResponse aiResponse) {
    _aiResponses.add(aiResponse);
    _generateOptions();
    _notifyOptionsChanged();
  }

  /// Remove an AI response by ID
  void removeAIResponse(String aiResponseId) {
    _aiResponses.removeWhere((response) => response.id == aiResponseId);
    _options.removeWhere((option) => option.aiResponseId == aiResponseId);
    _selections.removeWhere((key, value) => _options.any(
        (option) => option.id == key && option.aiResponseId == aiResponseId));
    _notifyOptionsChanged();
    _notifySelectionsChanged();
  }

  /// Toggle selection of an option
  void toggleSelection(String optionId) {
    if (_selections.containsKey(optionId)) {
      _selections[optionId] = !_selections[optionId]!;
    } else {
      _selections[optionId] = true;
    }
    _notifySelectionsChanged();
  }

  /// Set selection state of an option
  void setSelection(String optionId, bool isSelected) {
    _selections[optionId] = isSelected;
    _notifySelectionsChanged();
  }

  /// Select all options
  void selectAll() {
    for (final option in _options) {
      _selections[option.id] = true;
    }
    _notifySelectionsChanged();
  }

  /// Deselect all options
  void deselectAll() {
    _selections.clear();
    _notifySelectionsChanged();
  }

  /// Get selected options
  List<SelectOption> getSelectedOptions() {
    return _options.where((option) => _selections[option.id] == true).toList();
  }

  /// Submit selections and create result
  SelectionResult submitSelections({Map<String, dynamic>? metadata}) {
    final selectedOptions = getSelectedOptions();
    final result = SelectionResult(
      selectedOptions: selectedOptions,
      aiResponses: List.unmodifiable(_aiResponses),
      submittedAt: DateTime.now(),
      totalOptions: _options.length,
      selectedCount: selectedOptions.length,
      metadata: metadata,
    );

    _resultController.add(result);
    return result;
  }

  /// Clear all data
  void clear() {
    _aiResponses.clear();
    _options.clear();
    _selections.clear();
    _notifyOptionsChanged();
    _notifySelectionsChanged();
    _resultController.add(null);
  }

  /// Generate selectable options from AI responses
  void _generateOptions() {
    _options.clear();

    for (final aiResponse in _aiResponses) {
      // Split AI response into individual options
      // This is a simple implementation - can be customized based on needs
      final responseLines = aiResponse.responseText
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      for (int i = 0; i < responseLines.length; i++) {
        final line = responseLines[i].trim();
        if (line.isNotEmpty) {
          final option = SelectOption(
            text: line,
            id: '${aiResponse.id}_option_$i',
            aiResponseId: aiResponse.id,
            isSelected: _selections['${aiResponse.id}_option_$i'] ?? false,
          );
          _options.add(option);
        }
      }
    }
  }

  /// Notify listeners that options have changed
  void _notifyOptionsChanged() {
    _optionsController.add(List.unmodifiable(_options));
  }

  /// Notify listeners that selections have changed
  void _notifySelectionsChanged() {
    _selectionsController.add(Map.unmodifiable(_selections));
  }

  /// Dispose of the controller and its streams
  void dispose() {
    _optionsController.close();
    _selectionsController.close();
    _resultController.close();
  }
}
