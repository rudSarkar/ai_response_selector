import 'package:flutter/material.dart';
import '../models/ai_response.dart';
import '../models/select_option.dart';
import '../models/selection_result.dart';
import '../controllers/selection_controller.dart';

/// Main widget for displaying AI responses as selectable options
class AIResponseSelectorWidget extends StatefulWidget {
  /// List of AI responses to convert to selectable options
  final List<AIResponse> aiResponses;

  /// Callback when selections are submitted
  final Function(SelectionResult)? onSubmitted;

  /// Callback when selection state changes
  final Function(List<SelectOption>)? onSelectionChanged;

  /// Custom theme for the widget
  final AIResponseSelectorTheme? theme;

  /// Whether to show submit button
  final bool showSubmitButton;

  /// Text for submit button
  final String submitButtonText;

  /// Whether to allow multiple selections
  final bool allowMultipleSelections;

  /// Whether to show selection count
  final bool showSelectionCount;

  /// Custom option builder
  final Widget Function(SelectOption, bool, VoidCallback)? optionBuilder;

  const AIResponseSelectorWidget({
    super.key,
    required this.aiResponses,
    this.onSubmitted,
    this.onSelectionChanged,
    this.theme,
    this.showSubmitButton = true,
    this.submitButtonText = 'Submit Selections',
    this.allowMultipleSelections = true,
    this.showSelectionCount = true,
    this.optionBuilder,
  });

  @override
  State<AIResponseSelectorWidget> createState() =>
      _AIResponseSelectorWidgetState();
}

class _AIResponseSelectorWidgetState extends State<AIResponseSelectorWidget> {
  late SelectionController _controller;
  List<SelectOption> _currentOptions = [];
  Map<String, bool> _currentSelections = {};

  @override
  void initState() {
    super.initState();
    _controller = SelectionController();
    _initializeController();
  }

  @override
  void didUpdateWidget(AIResponseSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.aiResponses != widget.aiResponses) {
      _initializeController();
    }
  }

  void _initializeController() {
    _controller.initializeWithAIResponses(widget.aiResponses);

    _controller.optionsStream.listen((options) {
      setState(() {
        _currentOptions = options;
      });
    });

    _controller.selectionsStream.listen((selections) {
      setState(() {
        _currentSelections = selections;
      });
      widget.onSelectionChanged?.call(_controller.getSelectedOptions());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? AIResponseSelectorTheme.defaultTheme();

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: theme.border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showSelectionCount) _buildSelectionCount(theme),
          Expanded(
            child: _buildOptionsList(theme),
          ),
          if (widget.showSubmitButton) _buildSubmitButton(theme),
        ],
      ),
    );
  }

  Widget _buildSelectionCount(AIResponseSelectorTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.borderRadius),
          topRight: Radius.circular(theme.borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Options',
            style: theme.headerTextStyle,
          ),
          Text(
            '${_controller.selectedCount}/${_controller.totalOptions}',
            style: theme.countTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList(AIResponseSelectorTheme theme) {
    if (_currentOptions.isEmpty) {
      return Center(
        child: Text(
          'No options available',
          style: theme.emptyStateTextStyle,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _currentOptions.length,
      itemBuilder: (context, index) {
        final option = _currentOptions[index];
        final isSelected = _currentSelections[option.id] ?? false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: widget.optionBuilder?.call(
                option,
                isSelected,
                () => _controller.toggleSelection(option.id),
              ) ??
              _buildDefaultOption(option, isSelected, theme),
        );
      },
    );
  }

  Widget _buildDefaultOption(
      SelectOption option, bool isSelected, AIResponseSelectorTheme theme) {
    return GestureDetector(
      onTap: () => _controller.toggleSelection(option.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? theme.selectedOptionColor : theme.optionColor,
          borderRadius: BorderRadius.circular(theme.optionBorderRadius),
          border: Border.all(
            color: isSelected
                ? theme.selectedBorderColor
                : theme.optionBorderColor,
            width: theme.borderWidth,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? theme.selectedIconColor : theme.iconColor,
              size: theme.iconSize,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.text,
                style: isSelected
                    ? theme.selectedTextStyle
                    : theme.optionTextStyle,
              ),
            ),
            if (option.confidence != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.confidenceBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(option.confidence! * 100).toInt()}%',
                  style: theme.confidenceTextStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AIResponseSelectorTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.footerBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(theme.borderRadius),
          bottomRight: Radius.circular(theme.borderRadius),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _controller.hasSelections ? _submitSelections : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.submitButtonColor,
                foregroundColor: theme.submitButtonTextColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(theme.submitButtonBorderRadius),
                ),
              ),
              child: Text(
                widget.submitButtonText,
                style: theme.submitButtonTextStyle,
              ),
            ),
          ),
          if (_controller.totalOptions > 0) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: _controller.selectAll,
              child: Text(
                'Select All',
                style: theme.actionButtonTextStyle,
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: _controller.deselectAll,
              child: Text(
                'Clear All',
                style: theme.actionButtonTextStyle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _submitSelections() {
    final result = _controller.submitSelections();
    widget.onSubmitted?.call(result);
  }
}

/// Theme configuration for AIResponseSelectorWidget
class AIResponseSelectorTheme {
  final Color backgroundColor;
  final Color headerBackgroundColor;
  final Color footerBackgroundColor;
  final Color optionColor;
  final Color selectedOptionColor;
  final Color optionBorderColor;
  final Color selectedBorderColor;
  final Color iconColor;
  final Color selectedIconColor;
  final Color confidenceBackgroundColor;
  final Color submitButtonColor;
  final Color submitButtonTextColor;
  final TextStyle headerTextStyle;
  final TextStyle countTextStyle;
  final TextStyle optionTextStyle;
  final TextStyle selectedTextStyle;
  final TextStyle confidenceTextStyle;
  final TextStyle submitButtonTextStyle;
  final TextStyle actionButtonTextStyle;
  final TextStyle emptyStateTextStyle;
  final double borderRadius;
  final double optionBorderRadius;
  final double submitButtonBorderRadius;
  final double borderWidth;
  final double iconSize;
  final Border? border;

  const AIResponseSelectorTheme({
    required this.backgroundColor,
    required this.headerBackgroundColor,
    required this.footerBackgroundColor,
    required this.optionColor,
    required this.selectedOptionColor,
    required this.optionBorderColor,
    required this.selectedBorderColor,
    required this.iconColor,
    required this.selectedIconColor,
    required this.confidenceBackgroundColor,
    required this.submitButtonColor,
    required this.submitButtonTextColor,
    required this.headerTextStyle,
    required this.countTextStyle,
    required this.optionTextStyle,
    required this.selectedTextStyle,
    required this.confidenceTextStyle,
    required this.submitButtonTextStyle,
    required this.actionButtonTextStyle,
    required this.emptyStateTextStyle,
    required this.borderRadius,
    required this.optionBorderRadius,
    required this.submitButtonBorderRadius,
    required this.borderWidth,
    required this.iconSize,
    this.border,
  });

  /// Create default theme
  factory AIResponseSelectorTheme.defaultTheme() {
    return AIResponseSelectorTheme(
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.grey[100]!,
      footerBackgroundColor: Colors.grey[50]!,
      optionColor: Colors.white,
      selectedOptionColor: Colors.blue[50]!,
      optionBorderColor: Colors.grey[300]!,
      selectedBorderColor: Colors.blue,
      iconColor: Colors.grey[600]!,
      selectedIconColor: Colors.blue,
      confidenceBackgroundColor: Colors.green[100]!,
      submitButtonColor: Colors.blue,
      submitButtonTextColor: Colors.white,
      headerTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      countTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
      optionTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      selectedTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      confidenceTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.green,
      ),
      submitButtonTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      actionButtonTextStyle: const TextStyle(
        fontSize: 14,
        color: Colors.blue,
      ),
      emptyStateTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      borderRadius: 12,
      optionBorderRadius: 8,
      submitButtonBorderRadius: 8,
      borderWidth: 1,
      iconSize: 24,
    );
  }

  /// Create dark theme
  factory AIResponseSelectorTheme.darkTheme() {
    return AIResponseSelectorTheme(
      backgroundColor: Colors.grey[900]!,
      headerBackgroundColor: Colors.grey[800]!,
      footerBackgroundColor: Colors.grey[850]!,
      optionColor: Colors.grey[800]!,
      selectedOptionColor: Colors.blue[900]!,
      optionBorderColor: Colors.grey[600]!,
      selectedBorderColor: Colors.blue[400]!,
      iconColor: Colors.grey[400]!,
      selectedIconColor: Colors.blue[400]!,
      confidenceBackgroundColor: Colors.green[800]!,
      submitButtonColor: Colors.blue[600]!,
      submitButtonTextColor: Colors.white,
      headerTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      countTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
      optionTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      selectedTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      confidenceTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.green[300]!,
      ),
      submitButtonTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      actionButtonTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.blue[400]!,
      ),
      emptyStateTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      borderRadius: 12,
      optionBorderRadius: 8,
      submitButtonBorderRadius: 8,
      borderWidth: 1,
      iconSize: 24,
    );
  }
}
