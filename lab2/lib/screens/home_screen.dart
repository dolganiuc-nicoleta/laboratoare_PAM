import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F3),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text('GemStore',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _categoryRow(),
          const SizedBox(height: 16),
          _bannerCard(),
          const SizedBox(height: 24),
          _sectionHeader('Feature Products'),
          const SizedBox(height: 12),
          _productRow(context, featuredProducts),
          const SizedBox(height: 24),
          _hangOutBanner(),
          const SizedBox(height: 24),
          _sectionHeader('Recommended'),
          const SizedBox(height: 12),
          _recommendedRow(context, recommendedProducts),
          const SizedBox(height: 24),
          _sectionHeader('Top Collection'),
          const SizedBox(height: 12),
          // in Figma cele 2 carduri sunt pline pe latime, unul sub altul
          _fullAssetBanner('assets/images/banner_slim_beauty.png'),
          const SizedBox(height: 16),
          _fullAssetBanner('assets/images/banner_most_sexy.png'),
          const SizedBox(height: 16),
          _bottomCollectionRow(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _categoryRow() {
    final icons = [
      'assets/images/cat_women.png',
      'assets/images/cat_men.png',
      'assets/images/cat_accessories.png',
      'assets/images/cat_beauty.png',
    ];
    final labels = ['Women', 'Men', 'Accessories', 'Beauty'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(icons.length, (i) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(icons[i], width: 48, height: 48, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(
              labels[i],
              style: TextStyle(
                fontSize: 12,
                color: i == 0 ? Colors.black : Colors.grey,
                fontWeight: i == 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }

  // Banner Autumn Collection - textul e deja inclus in poza exportata din Figma
  Widget _bannerCard() {
    return _fullAssetBanner('assets/images/banner_autumn.png', height: 188);
  }

  Widget _hangOutBanner() {
    return _fullAssetBanner('assets/images/banner_hangout.png', height: 168);
  }

  // widget generic pentru bannerele care au deja textul "copt" in imaginea din Figma
  Widget _fullAssetBanner(String asset, {double height = 150}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(asset, height: height, width: double.infinity, fit: BoxFit.cover),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Text('Show all', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _productRow(BuildContext context, List<Product> products) {
    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _productCard(context, products[i]),
      ),
    );
  }

  Widget _productCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductScreen(product: product)),
      ),
      child: SizedBox(
        width: 122,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _productImage(product, height: 172, width: 122, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13)),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // card orizontal (poza mica + nume/pret langa ea) - asa arata "Recommended" in Figma,
  // diferit de cardurile verticale de la "Feature Products"
  Widget _recommendedRow(BuildContext context, List<Product> products) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _recommendedCard(context, products[i]),
      ),
    );
  }

  Widget _recommendedCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductScreen(product: product)),
      ),
      child: Container(
        width: 190,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _productImage(product, height: 56, width: 56),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13)),
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

  Widget _bottomCollectionRow() {
    final labels = ['The Office Life', 'Elegant Design'];
    final assets = [
      'assets/images/banner_office_life.png',
      'assets/images/banner_elegant.png',
    ];
    return Row(
      children: List.generate(2, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == 0 ? 12 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              // textul (T-Shirts/The Office Life, Dresses/Elegant Design) e deja
              // in imaginea exportata din Figma, nu mai suprapunem text separat
              child: Image.asset(assets[i], height: 190, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
        );
      }),
    );
  }
}

/// Afiseaza fie Image.asset (poza locala din Figma), fie Image.network,
/// in functie de ce contine product.imageUrl.
Widget _productImage(Product product, {required double height, required double width, BoxFit fit = BoxFit.contain}) {
  // fundal gri deschis (ca-n Figma) in spate, pt cazul cand fit:contain lasa spatiu gol
  return Container(
    height: height,
    width: width,
    color: const Color(0xFFF1EFED),
    child: product.isAsset
        ? Image.asset(product.imageUrl, fit: fit)
        : Image.network(product.imageUrl, fit: fit),
  );
}