import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_details_cubit.dart';
import '../widgets/state_views.dart';

// Ecran detalii: face o a doua cerere HTTP (GET /products/{id}).
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalii produs')),
      // Ecranul nu știe de HTTP: doar desenează starea primită de la cubit.
      body: BlocBuilder<ProductDetailsCubit, DetailsState>(
        builder: (context, state) {
          return switch (state) {
            DetailsLoading() => const LoadingView(),
            DetailsError(:final message) => ErrorView(
                message: message,
                onRetry: () => Navigator.pop(context),
              ),
            DetailsLoaded(:final product) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 320,
                      color: const Color(0xFFF1EFED),
                      child: Image.network(
                        product.images.isNotEmpty ? product.images.first : product.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(product.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  if (product.brand != null)
                    Text(product.brand!, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber),
                      Text(product.rating.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(product.description),
                ],
              ),
          };
        },
      ),
    );
  }
}
