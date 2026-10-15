import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../models/product.dart';
import '../models/product_detail.dart';
import '../widgets/product_card.dart';

/// Pagina de detalii produs.
///
/// Doar produsul "p003" (Sportwear Set) are date complete în JSON
/// (productPage.product). Pentru restul produselor (care vin doar din
/// featureProducts/recommended), afișăm un fallback simplu cu ce avem:
/// imagine, nume, preț și butonul de favorit.
class ProductScreen extends StatelessWidget {
  final Product product;

  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final detail = cubit.detailFor(product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: detail != null
            ? _FullDetailView(detail: detail)
            : _BasicDetailView(product: product),
      ),
    );
  }
}

/// Varianta completă, folosită doar pentru produsul cu detalii în JSON.
class _FullDetailView extends StatelessWidget {
  final ProductDetail detail;

  const _FullDetailView({required this.detail});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final isFav = cubit.isFavorite(detail.id);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.black54,
              ),
              onPressed: () => cubit.toggleFavorite(detail.id),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            detail.mainImageUrl,
            width: double.infinity,
            height: 320,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: double.infinity,
              height: 320,
              color: const Color(0xFFF1EFED),
              child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                detail.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              detail.priceLabel,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 4),
            Text('${detail.rating} (${detail.ratingCount} ratings · ${detail.reviewCount} reviews)',
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Culoare', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: detail.availableColors.map((c) {
            final isSelected = c.id == detail.selectedColor;
            final color = Color(int.parse(c.value.replaceFirst('#', '0xFF')));
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Mărime', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: detail.availableSizes.map((s) {
            final isSelected = s == detail.selectedSize;
            final available = detail.sizeAvailability[s] ?? true;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 40,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : const Color(0xFFF1EFED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    color: !available
                        ? Colors.grey
                        : (isSelected ? Colors.white : Colors.black),
                    decoration: !available ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Descriere', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(detail.description, style: const TextStyle(color: Colors.black87, height: 1.4)),
        const SizedBox(height: 20),
        if (detail.similarProducts.isNotEmpty) ...[
          const Text('Produse similare', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 232,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: detail.similarProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final p = detail.similarProducts[i];
                return ProductCard(
                  product: p,
                  isFavorite: cubit.isFavorite(p.id),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductScreen(product: p)),
                  ),
                  onToggleFavorite: () => cubit.toggleFavorite(p.id),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: detail.actions.canAddToCart ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(detail.actions.addToCartLabel),
          ),
        ),
      ],
    );
  }
}

/// Fallback simplu, pentru produsele fără detalii complete în JSON.
class _BasicDetailView extends StatelessWidget {
  final Product product;

  const _BasicDetailView({required this.product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final isFav = cubit.isFavorite(product.id);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.black54,
              ),
              onPressed: () => cubit.toggleFavorite(product.id),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            product.imageUrl,
            width: double.infinity,
            height: 320,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: double.infinity,
              height: 320,
              color: const Color(0xFFF1EFED),
              child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(product.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Text(product.priceLabel,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Pentru acest produs nu există încă descriere/recenzii detaliate în datele JSON.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Add To Cart'),
          ),
        ),
      ],
    );
  }
}