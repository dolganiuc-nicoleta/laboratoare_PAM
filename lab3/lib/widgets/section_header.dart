import 'package:flutter/material.dart';

/// Titlu de secțiune + "Show all", folosit la Feature Products, Recommended etc.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onShowAll;

  const SectionHeader({super.key, required this.title, this.onShowAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onShowAll,
          child: const Text('Show all', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}