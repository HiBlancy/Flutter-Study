import 'package:flutter/material.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({Key? key}) : super(key: key);

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  // preguntas y respuestas a corde de la app y traducidas a los 3 idiomas
  final List<FAQItem> faqs = [
     FAQItem(
      question: 'Question',
      answer: 'Answer',
    ),
    FAQItem(
      question: 'What is DueGlow?',
      answer: 'DueGlow is a task management app designed to help you stay organized and productive.',
    ),
    FAQItem(
      question: 'How do I create a new task?',
      answer: 'Tap the "+" button on the home screen and fill in the task details.',
    ),
    FAQItem(
      question: 'Can I set reminders for my tasks?',
      answer: 'Yes, you can set reminders when creating or editing a task.',
    ),
    FAQItem(
      question: 'How do I delete a task?',
      answer: 'Swipe left on the task and tap the delete button, or long-press and select delete.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return FAQTile(faqItem: faqs[index]);
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class FAQTile extends StatefulWidget {
  final FAQItem faqItem;

  const FAQTile({Key? key, required this.faqItem}) : super(key: key);

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(
          widget.faqItem.question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.faqItem.answer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
