import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedColor = 0;
  int selectedSize = 2;
  final colors = [Colors.brown.shade200, Colors.black, Colors.pink.shade200];
  final sizes = ['S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              _productHeroImage(widget.product),
              Positioned(
                top: 48,
                left: 16,
                child: _circleIconButton(Icons.arrow_back, () => Navigator.pop(context)),
              ),
              Positioned(
                top: 48,
                right: 16,
                child: _circleIconButton(Icons.favorite_border, () {}),
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
                    Text(widget.product.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('\$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ...List.generate(5, (i) => const Icon(Icons.star, size: 16, color: Colors.amber)),
                    const SizedBox(width: 6),
                    const Text('4.9', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(colors.length, (i) {
                    final isSelected = i == selectedColor;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = i),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colors[i],
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(sizes.length, (i) {
                    final isSelected = i == selectedSize;
                    return GestureDetector(
                      onTap: () => setState(() => selectedSize = i),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(sizes[i],
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                _expandableSection(
                  title: 'Description',
                  child: const Text(
                    'Comfortable sportswear set made from breathable fabric, perfect for '
                        'workouts or a relaxed everyday look. Machine washable.',
                    style: TextStyle(color: Colors.grey, height: 1.4),
                  ),
                ),
                _expandableSection(
                  title: 'Reviews',
                  child: _reviewsSection(),
                ),
                const SizedBox(height: 24),
                _sectionHeader('Similar Products'),
                const SizedBox(height: 12),
                _similarProductsRow(context),
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              label: const Text('Add To Cart', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
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

  Widget _reviewsSection() {
    final breakdown = [0.8, 0.6, 0.3, 0.1, 0.05]; // 5-star down to 1-star bars
    final reviews = [
      {'name': 'Jennifer Rose', 'text': 'Great fit and very comfortable, exactly as pictured.'},
      {'name': 'Kelly Wilson', 'text': 'Good quality fabric, runs slightly small so size up.'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('4.9', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: List.generate(5, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: breakdown[i],
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.amber,
                        minHeight: 6,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...reviews.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/images/avatar_reviewer.png')),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(children: List.generate(5, (i) => const Icon(Icons.star, size: 12, color: Colors.amber))),
                    const SizedBox(height: 4),
                    Text(r['text']!, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget _productHeroImage(Product product) {
    if (product.isAsset) {
      return Image.asset(product.imageUrl, height: 380, width: double.infinity, fit: BoxFit.cover);
    }
    return Image.network(product.imageUrl, height: 380, width: double.infinity, fit: BoxFit.cover);
  }

  Widget _similarProductsRow(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: similarProducts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final p = similarProducts[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductScreen(product: p)),
            ),
            child: SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: p.isAsset
                        ? Image.asset(p.imageUrl, height: 140, width: 120, fit: BoxFit.cover)
                        : Image.network(p.imageUrl, height: 140, width: 120, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 6),
                  Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                  Text('\$${p.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}