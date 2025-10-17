import 'package:flutter/material.dart';
import 'package:ai_response_selector/ai_response_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Response Selector Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  List<AIResponse> _aiResponses = [];
  SelectionResult? _lastResult;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    setState(() {
      _aiResponses = [
        AIResponse(
          id: 'response_1',
          question: 'What are the benefits of exercise?',
          responseText: '''Regular exercise provides numerous health benefits:
• Improves cardiovascular health
• Strengthens muscles and bones
• Boosts mental health and mood
• Helps with weight management
• Reduces risk of chronic diseases''',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        AIResponse(
          id: 'response_2',
          question: 'What are the best programming languages to learn?',
          responseText: '''Here are some popular programming languages:
• Python - Great for beginners and data science
• JavaScript - Essential for web development
• Java - Widely used in enterprise applications
• C++ - Powerful for system programming
• Go - Excellent for cloud-native applications''',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        AIResponse(
          id: 'response_3',
          question: 'What are healthy breakfast options?',
          responseText: '''Healthy breakfast ideas include:
• Oatmeal with fruits and nuts
• Greek yogurt with berries
• Whole grain toast with avocado
• Smoothie with spinach and banana
• Scrambled eggs with vegetables''',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
      ];
    });
  }

  void _addNewResponse() {
    final newResponse = AIResponse(
      id: 'response_${_aiResponses.length + 1}',
      question: 'Sample Question ${_aiResponses.length + 1}',
      responseText: '''This is a sample AI response with multiple options:
• Option A: First choice
• Option B: Second choice
• Option C: Third choice
• Option D: Fourth choice''',
      timestamp: DateTime.now(),
    );

    setState(() {
      _aiResponses.add(newResponse);
    });
  }

  void _clearResponses() {
    setState(() {
      _aiResponses.clear();
      _lastResult = null;
    });
  }

  void _onSubmitted(SelectionResult result) {
    setState(() {
      _lastResult = result;
    });

    // Show result dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selection Submitted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Selected ${result.selectedCount} out of ${result.totalOptions} options'),
            const SizedBox(height: 16),
            const Text('Selected Options:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...result.selectedOptions.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• ${option.text}'),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Response Selector Example'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Control buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _addNewResponse,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Response'),
                ),
                ElevatedButton.icon(
                  onPressed: _loadSampleData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Load Sample'),
                ),
                ElevatedButton.icon(
                  onPressed: _clearResponses,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear All'),
                ),
              ],
            ),
          ),

          // AI Response Selector
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: _aiResponses.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No AI responses available',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add some responses to see the selector in action',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : AIResponseSelectorWidget(
                      aiResponses: _aiResponses,
                      onSubmitted: _onSubmitted,
                      onSelectionChanged: (selectedOptions) {
                        // Optional: Handle selection changes
                        print('Selected ${selectedOptions.length} options');
                      },
                      theme: _isDarkMode
                          ? AIResponseSelectorTheme.darkTheme()
                          : AIResponseSelectorTheme.defaultTheme(),
                      showSubmitButton: true,
                      showSelectionCount: true,
                      submitButtonText: 'Submit My Selections',
                    ),
            ),
          ),

          // Last result display
          if (_lastResult != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Last Submission: ${_lastResult!.summary}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Submitted at: ${_lastResult!.submittedAt.toString().substring(0, 19)}',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
