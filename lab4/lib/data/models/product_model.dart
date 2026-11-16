import '../../domain/entities/product.dart';

// MODEL (Data): știe să se citească din JSON (deserializare)
// și să se scrie în JSON (serializare). Extinde entitatea din Domain.
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.rating,
    required super.brand,
    required super.thumbnail,
    required super.images,
  });

  // JSON (Map) -> obiect Dart
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: (json['description'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      price: (json['price'] as num).toDouble(), // poate veni int sau double
      rating: ((json['rating'] ?? 0) as num).toDouble(),
      brand: json['brand'] as String?, // unele produse nu au brand
      thumbnail: (json['thumbnail'] ?? '') as String,
      images: ((json['images'] ?? <dynamic>[]) as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  // obiect Dart -> JSON (Map), ex. pentru trimis/salvat
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'rating': rating,
        'brand': brand,
        'thumbnail': thumbnail,
        'images': images,
      };
}
