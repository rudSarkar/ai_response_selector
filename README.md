# AI Response Selector

A Flutter package for converting AI responses to multiple select options with easy integration and comprehensive state management.

## Features

- 🎯 **Convert AI responses to selectable options** - Automatically parse AI responses into individual selectable options
- ✅ **Multiple selection support** - Users can select multiple options from AI responses
- 📊 **Real-time state management** - Track selections with reactive streams
- 🎨 **Customizable themes** - Built-in light and dark themes with full customization support
- 📱 **Easy integration** - Simple widget that integrates seamlessly with existing Flutter apps
- 🔧 **Flexible configuration** - Customize behavior, appearance, and callbacks
- 📈 **Performance optimized** - Efficient rendering and state management
- 🧪 **Well tested** - Comprehensive unit and integration tests

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ai_response_selector: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:ai_response_selector/ai_response_selector.dart';

// Create AI responses
final aiResponses = [
  AIResponse(
    id: 'response_1',
    question: 'What are the benefits of exercise?',
    responseText: '''Regular exercise provides numerous health benefits:
• Improves cardiovascular health
• Strengthens muscles and bones
• Boosts mental health and mood
• Helps with weight management
• Reduces risk of chronic diseases''',
    timestamp: DateTime.now(),
  ),
];

// Use the widget
AIResponseSelectorWidget(
  aiResponses: aiResponses,
  onSubmitted: (result) {
    print('Selected ${result.selectedCount} options');
    // Handle submission
  },
)
```

## Usage

### Basic Usage

```dart
AIResponseSelectorWidget(
  aiResponses: yourAIResponses,
  onSubmitted: (SelectionResult result) {
    // Handle the submitted selections
    print('Selected options: ${result.selectedTexts}');
  },
)
```

### Advanced Configuration

```dart
AIResponseSelectorWidget(
  aiResponses: aiResponses,
  onSubmitted: (result) => handleSubmission(result),
  onSelectionChanged: (selectedOptions) {
    // Called whenever selection changes
    updateUI(selectedOptions);
  },
  theme: AIResponseSelectorTheme.darkTheme(),
  showSubmitButton: true,
  submitButtonText: 'Submit My Choices',
  showSelectionCount: true,
  allowMultipleSelections: true,
)
```

### Custom Option Builder

```dart
AIResponseSelectorWidget(
  aiResponses: aiResponses,
  optionBuilder: (option, isSelected, onTap) {
    return Card(
      color: isSelected ? Colors.blue[100] : Colors.white,
      child: ListTile(
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
        title: Text(option.text),
        onTap: onTap,
      ),
    );
  },
)
```

## API Reference

### AIResponseSelectorWidget

The main widget for displaying AI responses as selectable options.

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `aiResponses` | `List<AIResponse>` | Required | List of AI responses to convert to options |
| `onSubmitted` | `Function(SelectionResult)?` | `null` | Callback when selections are submitted |
| `onSelectionChanged` | `Function(List<SelectOption>)?` | `null` | Callback when selection state changes |
| `theme` | `AIResponseSelectorTheme?` | `defaultTheme()` | Custom theme configuration |
| `showSubmitButton` | `bool` | `true` | Whether to show submit button |
| `submitButtonText` | `String` | `'Submit Selections'` | Text for submit button |
| `allowMultipleSelections` | `bool` | `true` | Whether to allow multiple selections |
| `showSelectionCount` | `bool` | `true` | Whether to show selection count |
| `optionBuilder` | `Widget Function(SelectOption, bool, VoidCallback)?` | `null` | Custom option builder |

### AIResponse

Represents an AI response that can be converted to selectable options.

```dart
AIResponse(
  id: 'unique_id',
  question: 'The question that prompted this response',
  responseText: 'The AI response text with multiple options',
  timestamp: DateTime.now(),
  metadata: {'key': 'value'}, // Optional
)
```

### SelectOption

Represents a selectable option derived from an AI response.

```dart
SelectOption(
  text: 'Option text',
  id: 'unique_option_id',
  aiResponseId: 'parent_response_id',
  isSelected: false,
  confidence: 0.95, // Optional confidence score
  metadata: {'key': 'value'}, // Optional
)
```

### SelectionResult

Contains the result of user selections.

```dart
SelectionResult(
  selectedOptions: [...], // List of selected options
  aiResponses: [...], // Original AI responses
  submittedAt: DateTime.now(),
  totalOptions: 10,
  selectedCount: 3,
  metadata: {'key': 'value'}, // Optional
)
```

### SelectionController

For advanced usage, you can use the controller directly:

```dart
final controller = SelectionController();

// Initialize with AI responses
controller.initializeWithAIResponses(aiResponses);

// Listen to changes
controller.optionsStream.listen((options) {
  // Handle options changes
});

controller.selectionsStream.listen((selections) {
  // Handle selection changes
});

// Toggle selection
controller.toggleSelection('option_id');

// Submit selections
final result = controller.submitSelections();

// Clean up
controller.dispose();
```

## Theming

### Built-in Themes

```dart
// Light theme (default)
AIResponseSelectorTheme.defaultTheme()

// Dark theme
AIResponseSelectorTheme.darkTheme()
```

### Custom Theme

```dart
AIResponseSelectorTheme(
  backgroundColor: Colors.white,
  headerBackgroundColor: Colors.grey[100]!,
  optionColor: Colors.white,
  selectedOptionColor: Colors.blue[50]!,
  optionBorderColor: Colors.grey[300]!,
  selectedBorderColor: Colors.blue,
  iconColor: Colors.grey[600]!,
  selectedIconColor: Colors.blue,
  submitButtonColor: Colors.blue,
  submitButtonTextColor: Colors.white,
  headerTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  optionTextStyle: TextStyle(fontSize: 16),
  selectedTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  submitButtonTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  borderRadius: 12,
  optionBorderRadius: 8,
  submitButtonBorderRadius: 8,
  borderWidth: 1,
  iconSize: 24,
)
```

## Examples

### Example 1: Basic Usage

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AIResponseSelectorWidget(
      aiResponses: [
        AIResponse(
          id: '1',
          question: 'What are your favorite colors?',
          responseText: '''Here are some popular colors:
• Red - Bold and energetic
• Blue - Calm and trustworthy
• Green - Natural and peaceful
• Yellow - Happy and optimistic''',
          timestamp: DateTime.now(),
        ),
      ],
      onSubmitted: (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected ${result.selectedCount} options')),
        );
      },
    );
  }
}
```

### Example 2: With Custom Theme

```dart
AIResponseSelectorWidget(
  aiResponses: aiResponses,
  theme: AIResponseSelectorTheme(
    backgroundColor: Colors.grey[900]!,
    optionColor: Colors.grey[800]!,
    selectedOptionColor: Colors.blue[900]!,
    optionBorderColor: Colors.grey[600]!,
    selectedBorderColor: Colors.blue[400]!,
    iconColor: Colors.grey[400]!,
    selectedIconColor: Colors.blue[400]!,
    submitButtonColor: Colors.blue[600]!,
    submitButtonTextColor: Colors.white,
    headerTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    optionTextStyle: TextStyle(fontSize: 16, color: Colors.white),
    selectedTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    submitButtonTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    borderRadius: 12,
    optionBorderRadius: 8,
    submitButtonBorderRadius: 8,
    borderWidth: 1,
    iconSize: 24,
  ),
  onSubmitted: (result) => handleSubmission(result),
)
```

### Example 3: Using Controller Directly

```dart
class AdvancedExample extends StatefulWidget {
  @override
  _AdvancedExampleState createState() => _AdvancedExampleState();
}

class _AdvancedExampleState extends State<AdvancedExample> {
  late SelectionController _controller;
  List<SelectOption> _options = [];
  Map<String, bool> _selections = {};

  @override
  void initState() {
    super.initState();
    _controller = SelectionController();
    _setupController();
  }

  void _setupController() {
    _controller.optionsStream.listen((options) {
      setState(() => _options = options);
    });

    _controller.selectionsStream.listen((selections) {
      setState(() => _selections = selections);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom UI for options
        Expanded(
          child: ListView.builder(
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final option = _options[index];
              final isSelected = _selections[option.id] ?? false;
              
              return CheckboxListTile(
                title: Text(option.text),
                value: isSelected,
                onChanged: (value) => _controller.setSelection(option.id, value ?? false),
              );
            },
          ),
        ),
        
        // Custom submit button
        ElevatedButton(
          onPressed: _controller.hasSelections ? _submit : null,
          child: Text('Submit (${_controller.selectedCount})'),
        ),
      ],
    );
  }

  void _submit() {
    final result = _controller.submitSelections();
    // Handle result
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## Testing

The package includes comprehensive tests:

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## Performance Considerations

- The widget efficiently renders only visible options using ListView.builder
- State management uses streams for reactive updates
- Memory usage is optimized with proper disposal of controllers
- Large lists of options are handled efficiently

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### 1.0.0
- Initial release
- Basic AI response to selectable options conversion
- Multiple selection support
- Customizable themes
- Comprehensive documentation and examples
- Unit and integration tests
