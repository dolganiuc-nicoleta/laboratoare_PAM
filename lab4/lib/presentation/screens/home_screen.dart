import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entities/feed.dart';
import '../cubit/home_cubit.dart';
import '../navigation.dart';
import '../widgets/banner_card.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/state_views.dart';

// Ecranul principal: același design ca în Lab 2, dar datele vin din API.
// Ecranul doar desenează starea primită de la HomeCubit.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Titlul din AppBar vine din API când e disponibil
        final title = state is HomeLoaded ? state.feed.storeName : 'GemStore';
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F5F3),
            elevation: 0,
            leading: const Icon(Icons.menu, color: Colors.black),
            title: Text(title,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.notifications_none, color: Colors.black),
              ),
            ],
          ),
          // switch pe starea sealed: câte un widget pentru fiecare stare
          body: switch (state) {
            HomeLoading() => const LoadingView(),
            HomeError(:final message) =>
              ErrorView(message: message, onRetry: context.read<HomeCubit>().load),
            HomeLoaded(:final feed) => _HomeContent(feed: feed),
          },
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeFeed feed;
  const _HomeContent({required this.feed});

  @override
  Widget build(BuildContext context) {
    final hero = feed.heroBanner;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _categoryRow(feed.categories),
        const SizedBox(height: 16),

        // Hero banner: titlu + buton + puncte de slider
        BannerCard(
          imageUrl: hero.imageUrl,
          height: 188,
          title: hero.title,
          titleSize: 22,
          bottom: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(hero.action, style: const TextStyle(fontSize: 12)),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  hero.slides,
                  (i) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == hero.activeSlide ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const SectionHeader('Feature Products'),
        const SizedBox(height: 12),
        SizedBox(
          height: 232,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: feed.featureProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => ProductCard(
              product: feed.featureProducts[i],
              onTap: () => openProduct(context, feed.featureProducts[i].id),
            ),
          ),
        ),
        const SizedBox(height: 24),

        BannerCard(
          imageUrl: feed.newCollection.imageUrl,
          height: 168,
          label: feed.newCollection.label,
          title: feed.newCollection.title,
          titleSize: 22,
        ),
        const SizedBox(height: 24),

        const SectionHeader('Recommended'),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: feed.recommended.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => RecommendedCard(
              product: feed.recommended[i],
              onTap: () => openProduct(context, feed.recommended[i].id),
            ),
          ),
        ),
        const SizedBox(height: 24),

        const SectionHeader('Top Collection'),
        const SizedBox(height: 12),
        // cardurile sunt unul sub altul, pe toată lățimea
        for (final c in feed.topCollections) ...[
          BannerCard(imageUrl: c.imageUrl, height: 150, label: c.label, title: c.title),
          const SizedBox(height: 16),
        ],

        // cele 2 carduri de jos, unul lângă altul
        Row(
          children: [
            for (var i = 0; i < feed.categoryPromos.length; i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 0 ? 12 : 0),
                  child: BannerCard(
                    imageUrl: feed.categoryPromos[i].imageUrl,
                    height: 190,
                    label: feed.categoryPromos[i].label,
                    title: feed.categoryPromos[i].title,
                    titleSize: 16,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Rândul cu categorii: iconița e SVG din rețea (SvgPicture.network)
  Widget _categoryRow(List<CategoryItem> categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final c in categories)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                  child: SvgPicture.network(
                    c.iconUrl,
                    width: 26,
                    height: 26,
                    placeholderBuilder: (_) => const SizedBox(width: 26, height: 26),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                c.name,
                style: TextStyle(
                  fontSize: 12,
                  color: c.selected ? Colors.black : Colors.grey,
                  fontWeight: c.selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
