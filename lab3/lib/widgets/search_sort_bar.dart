import 'package:flutter/material.dart';
import '../cubit/home_state.dart';

/// Bara de căutare + sortare + filtru "doar favorite", pusă direct pe homepage.
/// Când oricare dintre ele e activ(ă), Home trece în "mod căutare" și arată
/// o grilă cu produsele filtrate, în loc de secțiunile curate din Figma.
class SearchSortBar extends StatelessWidget {
  final String query;
  final SortOption sort;
  final bool favoritesOnly;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<SortOption> onSortChanged;
  final VoidCallback onToggleFavoritesOnly;

  const SearchSortBar({
    super.key,
    required this.query,
    required this.sort,
    required this.favoritesOnly,
    required this.onQueryChanged,
    required this.onSortChanged,
    required this.onToggleFavoritesOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Caută un produs...',
            prefixIcon: const Icon(Icons.search, size: 20),
            filled: true,
            fillColor: const Color(0xFFF1EFED),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<SortOption>(
                initialValue: sort,
                isDense: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF1EFED),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: SortOption.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.label, style: const TextStyle(fontSize: 13))))
                    .toList(),
                onChanged: (v) {
                  if (v != null) onSortChanged(v);
                },
              ),
            ),
            const SizedBox(width: 10),
            FilterChip(
              label: const Text('Favorite'),
              selected: favoritesOnly,
              avatar: Icon(
                favoritesOnly ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: favoritesOnly ? Colors.red : Colors.black54,
              ),
              onSelected: (_) => onToggleFavoritesOnly(),
            ),
          ],
        ),
      ],
    );
  }
}