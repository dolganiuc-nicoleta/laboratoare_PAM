import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/category_item.dart';

/// Iconiță rotundă + etichetă pentru o categorie (Women/Men/Accessories/Beauty).
/// Iconul vine ca URL către un SVG (api.iconify.design), încărcat cu flutter_svg.
class CategoryChip extends StatelessWidget {
  final CategoryItem category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: category.selected ? const Color(0xFF2B2420) : const Color(0xFFF1EFED),
          child: SvgPicture.network(
            category.iconUrl,
            width: 26,
            height: 26,
            placeholderBuilder: (context) => const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          category.name,
          style: TextStyle(
            fontSize: 12,
            color: category.selected ? Colors.black : Colors.grey,
            fontWeight: category.selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}