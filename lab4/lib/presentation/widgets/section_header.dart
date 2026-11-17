import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showAll;
  const SectionHeader(this.title, {super.key, this.showAll = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (showAll) const Text('Show all', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
