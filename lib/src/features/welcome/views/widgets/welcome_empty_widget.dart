import 'package:flutter/material.dart';

class WelcomeEmptyWidget extends StatelessWidget {
  final VoidCallback onNewDocument;

  const WelcomeEmptyWidget({super.key, required this.onNewDocument});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No recent documents',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Create a new document to get started.'),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onNewDocument,
            icon: const Icon(Icons.add),
            label: const Text('New Document'),
          ),
        ],
      ),
    );
  }
}
