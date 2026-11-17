import 'feed.dart';

// ENTITĂȚI (Domain) pentru ecranul produsului.

class ColorOption {
  final String id;
  final String name;
  final String value; // cod hex, ex. "#E9C5AC"
  const ColorOption({required this.id, required this.name, required this.value});
}

class RatingBreakdown {
  final int stars;
  final int percentage;
  const RatingBreakdown({required this.stars, required this.percentage});
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
}

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
  final List<ColorOption> availableColors;
  final String selectedColor;
  final List<String> availableSizes;
  final String selectedSize;
  final Map<String, bool> sizeAvailability;
  final List<RatingBreakdown> ratingBreakdown;
  final List<Review> reviews;
  final List<ProductSummary> similarProducts;
  final bool isFavorite;
  final bool canAddToCart;
  final String addToCartLabel;

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
    required this.isFavorite,
    required this.canAddToCart,
    required this.addToCartLabel,
  });
}
