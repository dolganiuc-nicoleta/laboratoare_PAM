import 'package:flutter/material.dart';

import '../../domain/entities/feed.dart';
import 'net_image.dart';

// Card vertical (poză sus, nume și preț jos): Feature Products și Similar Products.
class ProductCard extends StatelessWidget {
  final ProductSummary product;
  final VoidCallback onTap;
  final double width;
  final double imageHeight;
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width = 122,
    this.imageHeight = 172,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: NetImage(product.imageUrl, width: width, height: imageHeight),
            ),
            const SizedBox(height: 6),
            Text(product.name,
                maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// Card orizontal (poză mică + nume/preț alături): secțiunea Recommended.
class RecommendedCard extends StatelessWidget {
  final ProductSummary product;
  final VoidCallback onTap;
  const RecommendedCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: NetImage(product.imageUrl, width: 56, height: 56),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(product.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
