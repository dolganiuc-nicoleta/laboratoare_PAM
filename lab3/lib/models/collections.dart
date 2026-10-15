// modele mici, grupate într-un singur fișier: secțiunile "New Collection",
// "Top Collection" și "Category Promo" de pe homepage

class NewCollection {
  final String label;
  final String title;
  final String imageUrl;

  const NewCollection({required this.label, required this.title, required this.imageUrl});

  factory NewCollection.fromJson(Map<String, dynamic> json) {
    return NewCollection(
      label: json['label'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class TopCollection {
  final String id;
  final String label;
  final String title;
  final String imageUrl;

  const TopCollection({
    required this.id,
    required this.label,
    required this.title,
    required this.imageUrl,
  });

  factory TopCollection.fromJson(Map<String, dynamic> json) {
    return TopCollection(
      id: json['id'] as String,
      label: json['label'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class CategoryPromo {
  final String id;
  final String category;
  final String title;
  final String imageUrl;

  const CategoryPromo({
    required this.id,
    required this.category,
    required this.title,
    required this.imageUrl,
  });

  factory CategoryPromo.fromJson(Map<String, dynamic> json) {
    return CategoryPromo(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}