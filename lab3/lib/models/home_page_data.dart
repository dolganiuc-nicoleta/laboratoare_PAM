import 'category_item.dart';
import 'collections.dart';
import 'hero_banner.dart';
import 'product.dart';

class HomePageData {
  final String storeName;
  final List<CategoryItem> categories;
  final HeroBanner heroBanner;
  final List<Product> featureProducts;
  final NewCollection newCollection;
  final List<Product> recommended;
  final List<TopCollection> topCollections;
  final List<CategoryPromo> categoryPromos;

  const HomePageData({
    required this.storeName,
    required this.categories,
    required this.heroBanner,
    required this.featureProducts,
    required this.newCollection,
    required this.recommended,
    required this.topCollections,
    required this.categoryPromos,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) {
    return HomePageData(
      storeName: json['storeName'] as String,
      categories: (json['categories'] as List)
          .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      heroBanner: HeroBanner.fromJson(json['heroBanner'] as Map<String, dynamic>),
      featureProducts: (json['featureProducts'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      newCollection: NewCollection.fromJson(json['newCollection'] as Map<String, dynamic>),
      recommended: (json['recommended'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCollections: (json['topCollections'] as List)
          .map((e) => TopCollection.fromJson(e as Map<String, dynamic>))
          .toList(),
      categoryPromos: (json['categoryPromos'] as List)
          .map((e) => CategoryPromo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}