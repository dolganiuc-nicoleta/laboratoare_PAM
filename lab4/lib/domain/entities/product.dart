// ENTITATE (Domain): obiectul "pur" din aplicație.
// Nu știe nimic despre JSON, HTTP sau Flutter.
class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String? brand;
  final String thumbnail;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.brand,
    required this.thumbnail,
    required this.images,
  });
}
