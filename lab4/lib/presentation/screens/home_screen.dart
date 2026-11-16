import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/products_cubit.dart';
import '../widgets/product_card.dart';
import '../widgets/state_views.dart';
import 'product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// StatefulWidget doar pentru TextEditingController (trebuie creat și distrus - dispose).
// Datele produselor NU sunt aici, ci în ProductsCubit.
class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  // (slug-ul trimis la API, textul afișat)
  static const _categories = <(String?, String)>[
    (null, 'All'),
    ('womens-dresses', 'Dresses'),
    ('tops', 'Tops'),
    ('mens-shirts', 'Men shirts'),
    ('womens-bags', 'Bags'),
    ('womens-shoes', 'Shoes'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.read = ia cubit-ul din BlocProvider (fără să asculte schimbările)
    final cubit = context.read<ProductsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('GemStore'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Caută produse...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: cubit.search, // la Enter -> cubit.search -> cerere HTTP
            ),
          ),
          BlocBuilder<ProductsCubit, ProductsState>(
            buildWhen: (_, __) => true,
            builder: (context, _) => SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final (slug, label) = _categories[i];
                  return ChoiceChip(
                    label: Text(label),
                    selected: cubit.category == slug,
                    onSelected: (_) {
                      _searchController.clear();
                      cubit.selectCategory(slug);
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            // BlocBuilder se reconstruiește la fiecare emit() din cubit.
            // switch pe starea sealed => câte un widget pentru fiecare stare.
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                return switch (state) {
                  ProductsLoading() => const LoadingView(),
                  ProductsError(:final message) =>
                    ErrorView(message: message, onRetry: cubit.load),
                  ProductsEmpty() => const EmptyView(),
                  ProductsLoaded(:final products) => GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      itemCount: products.length,
                      itemBuilder: (_, i) => ProductCard(
                        product: products[i],
                        // Navigator.push = deschide ecranul de detalii peste cel curent.
                        // Creăm un cubit nou pentru ecranul de detalii și îl pornim cu load(id).
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => ProductDetailsCubit(
                                GetProductById(context.read<ProductRepository>()),
                              )..load(products[i].id),
                              child: const ProductScreen(),
                            ),
                          ),
                        ),
                      ),
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
