// ENTITĂȚI (Domain) pentru pagina principală. Clase simple, fără JSON/HTTP/Flutter.

class CategoryItem {
  final String id;
  final String name;
  final bool selected;
  final String iconUrl;
  const CategoryItem({required this.id, required this.name, required this.selected, required this.iconUrl});
}

class HeroBanner {
  final String id;
  final String title;
  final String imageUrl;
  final String action;
  final int slides;
  final int activeSlide;
  const HeroBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.action,
    required this.slides,
    required this.activeSlide,
  });
}

// Produs "scurt", ca în liste (Feature, Recommended, Similar)
class ProductSummary {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String imageUrl;
  const ProductSummary({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,
  });
}

class NewCollection {
  final String label;
  final String title;
  final String imageUrl;
  const NewCollection({required this.label, required this.title, required this.imageUrl});
}

// Card promoțional: Top Collection (label + title) și Category Promos (category + title)
class PromoCard {
  final String id;
  final String label;
  final String title;
  final String imageUrl;
  const PromoCard({required this.id, required this.label, required this.title, required this.imageUrl});
}

class HomeFeed {
  final String storeName;
  final List<CategoryItem> categories;
  final HeroBanner heroBanner;
  final List<ProductSummary> featureProducts;
  final NewCollection newCollection;
  final List<ProductSummary> recommended;
  final List<PromoCard> topCollections;
  final List<PromoCard> categoryPromos;
  const HomeFeed({
    required this.storeName,
    required this.categories,
    required this.heroBanner,
    required this.featureProducts,
    required this.newCollection,
    required this.recommended,
    required this.topCollections,
    required this.categoryPromos,
  });
}
