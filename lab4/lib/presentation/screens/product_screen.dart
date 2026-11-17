import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_detail.dart';
import '../cubit/product_details_cubit.dart';
import '../navigation.dart';
import '../widgets/net_image.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/state_views.dart';

// Ecranul produsului: același design ca în Lab 2, datele vin din GET /feed/details.
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, DetailsState>(
      builder: (context, state) {
        return switch (state) {
          DetailsLoading() => Scaffold(appBar: AppBar(), body: const LoadingView()),
          DetailsError(:final message) => Scaffold(
              appBar: AppBar(),
              body: ErrorView(message: message, onRetry: context.read<ProductDetailsCubit>().load),
            ),
          DetailsLoaded(:final product) => _ProductContent(product: product),
        };
      },
    );
  }
}

// StatefulWidget doar pentru alegerile locale ale utilizatorului (culoare, mărime).
class _ProductContent extends StatefulWidget {
  final ProductDetail product;
  const _ProductContent({required this.product});

  @override
  State<_ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<_ProductContent> {
  late String _selectedColor = widget.product.selectedColor; // valoarea inițială vine din API
  late String _selectedSize = widget.product.selectedSize;

  // "#E9C5AC" -> Color
  Color _hex(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              NetImage(p.mainImageUrl, height: 380, width: double.infinity),
              Positioned(
                top: 48,
                left: 16,
                child: _circleIconButton(Icons.arrow_back, () => Navigator.pop(context)),
              ),
              Positioned(
                top: 48,
                right: 16,
                child: _circleIconButton(
                  p.isFavorite ? Icons.favorite : Icons.favorite_border,
                  () {},
                  color: p.isFavorite ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(p.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Text('\$${p.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ..._stars(p.rating, 16),
                    const SizedBox(width: 6),
                    Text('${p.rating} (${p.ratingCount})',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final c in p.availableColors)
                      GestureDetector(
                        onTap: () => setState(() => _selectedColor = c.id),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _hex(c.value),
                            shape: BoxShape.circle,
                            border: c.id == _selectedColor
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final s in p.availableSizes) _sizeChip(p, s),
                  ],
                ),
                const SizedBox(height: 12),
                _expandableSection(
                  title: 'Description',
                  child: Text(p.description,
                      style: const TextStyle(color: Colors.grey, height: 1.4)),
                ),
                _expandableSection(title: 'Reviews', child: _reviewsSection(p)),
                const SizedBox(height: 24),
                const SectionHeader('Similar Products', showAll: false),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: p.similarProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => ProductCard(
                      product: p.similarProducts[i],
                      width: 120,
                      imageHeight: 140,
                      onTap: () => openProduct(context, p.similarProducts[i].id),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              // butonul e activ doar dacă API-ul spune canAddToCart = true
              onPressed: p.canAddToCart
                  ? () => ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Added to cart')))
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              label: Text(p.addToCartLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  // Mărime: cele indisponibile (sizeAvailability = false) sunt gri și nu se pot alege
  Widget _sizeChip(ProductDetail p, String size) {
    final available = p.sizeAvailability[size] ?? true;
    final selected = size == _selectedSize;
    return GestureDetector(
      onTap: available ? () => setState(() => _selectedSize = size) : null,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: selected ? Colors.white : (available ? Colors.black : Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  // 5 stele: pline după rating (ex. 4.9 -> 5 pline)
  List<Widget> _stars(double rating, double size) {
    return List.generate(
      5,
      (i) => Icon(
        i < rating.round() ? Icons.star : Icons.star_border,
        size: size,
        color: Colors.amber,
      ),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onTap, {Color color = Colors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: color),
      ),
    );
  }

  Widget _expandableSection({required String title, required Widget child}) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      children: [Padding(padding: const EdgeInsets.only(bottom: 12), child: child)],
    );
  }

  Widget _reviewsSection(ProductDetail p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${p.rating}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  // câte o bară pentru fiecare treaptă de stele (percentage/100 = 0..1)
                  for (final b in p.ratingBreakdown)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: b.percentage / 100,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.amber,
                          minHeight: 6,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('${p.reviewCount} reviews', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 12),
        for (final r in p.reviews)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(child: NetImage(r.avatarUrl, width: 36, height: 36)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(r.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text(r.createdAtLabel,
                              style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Row(children: _stars(r.rating, 12)),
                      const SizedBox(height: 4),
                      Text(r.text, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
