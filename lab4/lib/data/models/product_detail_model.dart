import '../../domain/entities/product_detail.dart';
import 'feed_models.dart';

double _toDouble(Object? v) => (v as num).toDouble();

class ColorOptionModel extends ColorOption {
  const ColorOptionModel({required super.id, required super.name, required super.value});

  factory ColorOptionModel.fromJson(Map<String, dynamic> j) => ColorOptionModel(
        id: j['id'] as String,
        name: j['name'] as String,
        value: j['value'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'value': value};
}

class RatingBreakdownModel extends RatingBreakdown {
  const RatingBreakdownModel({required super.stars, required super.percentage});

  factory RatingBreakdownModel.fromJson(Map<String, dynamic> j) => RatingBreakdownModel(
        stars: j['stars'] as int,
        percentage: j['percentage'] as int,
      );

  Map<String, dynamic> toJson() => {'stars': stars, 'percentage': percentage};
}

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.author,
    required super.avatarUrl,
    required super.rating,
    required super.createdAtLabel,
    required super.text,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> j) => ReviewModel(
        id: j['id'] as String,
        author: j['author'] as String,
        avatarUrl: (j['avatarUrl'] ?? '') as String,
        rating: _toDouble(j['rating']),
        createdAtLabel: (j['createdAtLabel'] ?? '') as String,
        text: (j['text'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'avatarUrl': avatarUrl,
        'rating': rating,
        'createdAtLabel': createdAtLabel,
        'text': text,
      };
}

class ProductDetailModel extends ProductDetail {
  const ProductDetailModel({
    required super.id,
    required super.name,
    required super.price,
    required super.currency,
    required super.mainImageUrl,
    required super.galleryImageUrls,
    required super.rating,
    required super.ratingCount,
    required super.reviewCount,
    required super.description,
    required super.availableColors,
    required super.selectedColor,
    required super.availableSizes,
    required super.selectedSize,
    required super.sizeAvailability,
    required super.ratingBreakdown,
    required super.reviews,
    required super.similarProducts,
    required super.isFavorite,
    required super.canAddToCart,
    required super.addToCartLabel,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    // serverul poate trimite produsul direct, în "product" sau în "productPage.product"
    Map<String, dynamic> j = json;
    if (j['productPage'] is Map<String, dynamic>) j = j['productPage'] as Map<String, dynamic>;
    if (j['product'] is Map<String, dynamic>) j = j['product'] as Map<String, dynamic>;

    List<T> list<T>(String key, T Function(Map<String, dynamic>) fromJson) =>
        ((j[key] ?? <dynamic>[]) as List).map((e) => fromJson(e as Map<String, dynamic>)).toList();

    final actions = (j['actions'] ?? <String, dynamic>{}) as Map<String, dynamic>;

    return ProductDetailModel(
      id: j['id'] as String,
      name: j['name'] as String,
      price: _toDouble(j['price']),
      currency: (j['currency'] ?? 'USD') as String,
      mainImageUrl: j['mainImageUrl'] as String,
      galleryImageUrls: ((j['galleryImageUrls'] ?? <dynamic>[]) as List).map((e) => e as String).toList(),
      rating: _toDouble(j['rating'] ?? 0),
      ratingCount: (j['ratingCount'] ?? 0) as int,
      reviewCount: (j['reviewCount'] ?? 0) as int,
      description: (j['description'] ?? '') as String,
      availableColors: list('availableColors', ColorOptionModel.fromJson),
      selectedColor: (j['selectedColor'] ?? '') as String,
      availableSizes: ((j['availableSizes'] ?? <dynamic>[]) as List).map((e) => e as String).toList(),
      selectedSize: (j['selectedSize'] ?? '') as String,
      sizeAvailability: ((j['sizeAvailability'] ?? <String, dynamic>{}) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as bool)),
      ratingBreakdown: list('ratingBreakdown', RatingBreakdownModel.fromJson),
      reviews: list('reviews', ReviewModel.fromJson),
      similarProducts: list('similarProducts', ProductSummaryModel.fromJson),
      isFavorite: (actions['isFavorite'] ?? false) as bool,
      canAddToCart: (actions['canAddToCart'] ?? true) as bool,
      addToCartLabel: (actions['addToCartLabel'] ?? 'Add To Cart') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'currency': currency,
        'mainImageUrl': mainImageUrl,
        'galleryImageUrls': galleryImageUrls,
        'rating': rating,
        'ratingCount': ratingCount,
        'reviewCount': reviewCount,
        'description': description,
        'availableColors': availableColors.cast<ColorOptionModel>().map((e) => e.toJson()).toList(),
        'selectedColor': selectedColor,
        'availableSizes': availableSizes,
        'selectedSize': selectedSize,
        'sizeAvailability': sizeAvailability,
        'ratingBreakdown': ratingBreakdown.cast<RatingBreakdownModel>().map((e) => e.toJson()).toList(),
        'reviews': reviews.cast<ReviewModel>().map((e) => e.toJson()).toList(),
        'similarProducts': similarProducts.cast<ProductSummaryModel>().map((e) => e.toJson()).toList(),
        'actions': {
          'isFavorite': isFavorite,
          'canAddToCart': canAddToCart,
          'addToCartLabel': addToCartLabel,
        },
      };
}
