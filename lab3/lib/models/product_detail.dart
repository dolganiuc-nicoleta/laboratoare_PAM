import 'product.dart';

class ProductColor {
  final String id;
  final String name;
  final String value; // cod culoare hex, ex "#000000"

  const ProductColor({required this.id, required this.name, required this.value});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: json['id'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }
}

class RatingBreakdownItem {
  final int stars;
  final int percentage;

  const RatingBreakdownItem({required this.stars, required this.percentage});

  factory RatingBreakdownItem.fromJson(Map<String, dynamic> json) {
    return RatingBreakdownItem(
      stars: json['stars'] as int,
      percentage: json['percentage'] as int,
    );
  }
}

class Review {
  final String id;
  final String author;
  final String avatarUrl;
  final double rating;
  final String createdAtLabel;
  final String text;

  const Review({
    required this.id,
    required this.author,
    required this.avatarUrl,
    required this.rating,
    required this.createdAtLabel,
    required this.text,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      author: json['author'] as String,
      avatarUrl: json['avatarUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      createdAtLabel: json['createdAtLabel'] as String,
      text: json['text'] as String,
    );
  }
}

class ProductActions {
  final bool isFavorite;
  final bool canAddToCart;
  final String addToCartLabel;

  const ProductActions({
    required this.isFavorite,
    required this.canAddToCart,
    required this.addToCartLabel,
  });

  factory ProductActions.fromJson(Map<String, dynamic> json) {
    return ProductActions(
      isFavorite: json['isFavorite'] as bool? ?? false,
      canAddToCart: json['canAddToCart'] as bool? ?? true,
      addToCartLabel: json['addToCartLabel'] as String? ?? 'Add To Cart',
    );
  }
}

/// Detaliile complete pentru un produs (așa cum apar pe pagina de produs).
/// În JSON există momentan un singur produs cu detalii complete (p003).
class ProductDetail {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String mainImageUrl;
  final List<String> galleryImageUrls;
  final double rating;
  final int ratingCount;
  final int reviewCount;
  final String description;
  final List<ProductColor> availableColors;
  final String selectedColor;
  final List<String> availableSizes;
  final String selectedSize;
  final Map<String, bool> sizeAvailability;
  final List<RatingBreakdownItem> ratingBreakdown;
  final List<Review> reviews;
  final List<Product> similarProducts;
  final ProductActions actions;

  const ProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.mainImageUrl,
    required this.galleryImageUrls,
    required this.rating,
    required this.ratingCount,
    required this.reviewCount,
    required this.description,
    required this.availableColors,
    required this.selectedColor,
    required this.availableSizes,
    required this.selectedSize,
    required this.sizeAvailability,
    required this.ratingBreakdown,
    required this.reviews,
    required this.similarProducts,
    required this.actions,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      mainImageUrl: json['mainImageUrl'] as String,
      galleryImageUrls: (json['galleryImageUrls'] as List).cast<String>(),
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['ratingCount'] as int,
      reviewCount: json['reviewCount'] as int,
      description: json['description'] as String,
      availableColors: (json['availableColors'] as List)
          .map((e) => ProductColor.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedColor: json['selectedColor'] as String,
      availableSizes: (json['availableSizes'] as List).cast<String>(),
      selectedSize: json['selectedSize'] as String,
      sizeAvailability: (json['sizeAvailability'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as bool)),
      ratingBreakdown: (json['ratingBreakdown'] as List)
          .map((e) => RatingBreakdownItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      similarProducts: (json['similarProducts'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      actions: ProductActions.fromJson(json['actions'] as Map<String, dynamic>),
    );
  }

  String get priceLabel => '\$${price.toStringAsFixed(2)}';
}