import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../models/home_page_data.dart';
import '../models/product.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/search_sort_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/state_views.dart';
import 'product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            return switch (state) {
              HomeLoading() => const LoadingView(),
              HomeError(:final message) => ErrorView(
                message: message,
                onRetry: cubit.loadHome,
              ),
              HomeEmpty(:final homeData, :final query, :final sort, :final favoritesOnly) =>
                  _HomeBody(
                    storeName: homeData.storeName,
                    query: query,
                    sort: sort,
                    favoritesOnly: favoritesOnly,
                    content: EmptyView(query: query),
                  ),
              HomeLoaded(:final homeData, :final isSearchMode) when !isSearchMode =>
                  _HomeBody(
                    storeName: homeData.storeName,
                    query: state.query,
                    sort: state.sort,
                    favoritesOnly: state.favoritesOnly,
                    content: _CuratedHome(homeData: homeData, state: state),
                  ),
              HomeLoaded(:final homeData, :final visibleProducts) => _HomeBody(
                storeName: homeData.storeName,
                query: state.query,
                sort: state.sort,
                favoritesOnly: state.favoritesOnly,
                content: _SearchGrid(products: visibleProducts, state: state),
              ),
            };
          },
        ),
      ),
    );
  }
}

/// Scheletul comun: titlu magazin + bara de căutare/sortare/favorite (mereu
/// vizibilă pe homepage, conform alegerii "direct pe homepage"), apoi
/// conținutul care diferă în funcție de stare.
class _HomeBody extends StatelessWidget {
  final String storeName;
  final String query;
  final SortOption sort;
  final bool favoritesOnly;
  final Widget content;

  const _HomeBody({
    required this.storeName,
    required this.query,
    required this.sort,
    required this.favoritesOnly,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            storeName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SearchSortBar(
            query: query,
            sort: sort,
            favoritesOnly: favoritesOnly,
            onQueryChanged: cubit.search,
            onSortChanged: cubit.setSort,
            onToggleFavoritesOnly: cubit.toggleFavoritesOnly,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: content),
      ],
    );
  }
}

/// Homepage-ul curat, cu secțiunile din Figma (categorii, banner, feature
/// products, recomandări, colecții). Afișat doar când nu e activ niciun
/// filtru/căutare/sortare.
class _CuratedHome extends StatelessWidget {
  final HomePageData homeData;
  final HomeLoaded state;

  const _CuratedHome({required this.homeData, required this.state});

  void _openProduct(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SizedBox(height: 4),
        SizedBox(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: homeData.categories
                .map((c) => CategoryChip(category: c))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                homeData.heroBanner.imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 180,
                  color: const Color(0xFFF1EFED),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  homeData.heroBanner.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(title: 'Feature Products'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 232,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: homeData.featureProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final product = homeData.featureProducts[i];
              return ProductCard(
                product: product,
                isFavorite: cubit.isFavorite(product.id),
                onTap: () => _openProduct(context, product),
                onToggleFavorite: () => cubit.toggleFavorite(product.id),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                homeData.newCollection.imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 150,
                  color: const Color(0xFFF1EFED),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(homeData.newCollection.label,
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(homeData.newCollection.title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(title: 'Recommended'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: homeData.recommended.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final product = homeData.recommended[i];
              return RecommendedCard(
                product: product,
                isFavorite: cubit.isFavorite(product.id),
                onTap: () => _openProduct(context, product),
                onToggleFavorite: () => cubit.toggleFavorite(product.id),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        ...homeData.topCollections.map(
              (c) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.network(
                    c.imageUrl,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 140,
                      color: const Color(0xFFF1EFED),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(c.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: homeData.categoryPromos.map((p) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.network(
                          p.imageUrl,
                          width: double.infinity,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: double.infinity,
                            height: 110,
                            color: const Color(0xFFF1EFED),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          bottom: 8,
                          child: Text(
                            p.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Grila de produse filtrate/sortate, afișată când bara de căutare e activă.
class _SearchGrid extends StatelessWidget {
  final List<Product> products;
  final HomeLoaded state;

  const _SearchGrid({required this.products, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 122 / 210,
      ),
      itemBuilder: (context, i) {
        final product = products[i];
        return ProductCard(
          product: product,
          width: double.infinity,
          isFavorite: cubit.isFavorite(product.id),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductScreen(product: product)),
          ),
          onToggleFavorite: () => cubit.toggleFavorite(product.id),
        );
      },
    );
  }
}