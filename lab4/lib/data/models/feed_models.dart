import '../../domain/entities/feed.dart';

// MODELE (Data): extind entitățile și știu JSON <-> obiect.
// fromJson = deserializare (JSON -> Dart), toJson = serializare (Dart -> JSON).

double _toDouble(Object? v) => (v as num).toDouble(); // JSON poate da int sau double

class CategoryItemModel extends CategoryItem {
  const CategoryItemModel({
    required super.id,
    required super.name,
    required super.selected,
    required super.iconUrl,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> j) => CategoryItemModel(
        id: j['id'] as String,
        name: j['name'] as String,
        selected: (j['selected'] ?? false) as bool,
        iconUrl: (j['iconUrl'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'selected': selected, 'iconUrl': iconUrl};
}

class HeroBannerModel extends HeroBanner {
  const HeroBannerModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.action,
    required super.slides,
    required super.activeSlide,
  });

  factory HeroBannerModel.fromJson(Map<String, dynamic> j) => HeroBannerModel(
        id: j['id'] as String,
        title: j['title'] as String,
        imageUrl: j['imageUrl'] as String,
        action: (j['action'] ?? '') as String,
        slides: (j['slides'] ?? 1) as int,
        activeSlide: (j['activeSlide'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'action': action,
        'slides': slides,
        'activeSlide': activeSlide,
      };
}

class ProductSummaryModel extends ProductSummary {
  const ProductSummaryModel({
    required super.id,
    required super.name,
    required super.price,
    required super.currency,
    required super.imageUrl,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> j) => ProductSummaryModel(
        id: j['id'] as String,
        name: j['name'] as String,
        price: _toDouble(j['price']),
        currency: (j['currency'] ?? 'USD') as String,
        imageUrl: j['imageUrl'] as String,
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'price': price, 'currency': currency, 'imageUrl': imageUrl};
}

class NewCollectionModel extends NewCollection {
  const NewCollectionModel({required super.label, required super.title, required super.imageUrl});

  factory NewCollectionModel.fromJson(Map<String, dynamic> j) => NewCollectionModel(
        label: j['label'] as String,
        title: j['title'] as String,
        imageUrl: j['imageUrl'] as String,
      );

  Map<String, dynamic> toJson() => {'label': label, 'title': title, 'imageUrl': imageUrl};
}

class PromoCardModel extends PromoCard {
  const PromoCardModel({
    required super.id,
    required super.label,
    required super.title,
    required super.imageUrl,
  });

  // topCollections au cheia "label", categoryPromos au cheia "category"
  factory PromoCardModel.fromJson(Map<String, dynamic> j) => PromoCardModel(
        id: j['id'] as String,
        label: (j['label'] ?? j['category'] ?? '') as String,
        title: j['title'] as String,
        imageUrl: j['imageUrl'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'label': label, 'title': title, 'imageUrl': imageUrl};
}

class HomeFeedModel extends HomeFeed {
  const HomeFeedModel({
    required super.storeName,
    required super.categories,
    required super.heroBanner,
    required super.featureProducts,
    required super.newCollection,
    required super.recommended,
    required super.topCollections,
    required super.categoryPromos,
  });

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) {
    // dacă serverul împachetează datele în "homePage", le despachetăm
    final j = json['homePage'] is Map<String, dynamic>
        ? json['homePage'] as Map<String, dynamic>
        : json;

    // ajutor: transformă o listă JSON într-o listă de modele
    List<T> list<T>(String key, T Function(Map<String, dynamic>) fromJson) =>
        ((j[key] ?? <dynamic>[]) as List).map((e) => fromJson(e as Map<String, dynamic>)).toList();

    return HomeFeedModel(
      storeName: (j['storeName'] ?? 'GemStore') as String,
      categories: list('categories', CategoryItemModel.fromJson),
      heroBanner: HeroBannerModel.fromJson(j['heroBanner'] as Map<String, dynamic>),
      featureProducts: list('featureProducts', ProductSummaryModel.fromJson),
      newCollection: NewCollectionModel.fromJson(j['newCollection'] as Map<String, dynamic>),
      recommended: list('recommended', ProductSummaryModel.fromJson),
      topCollections: list('topCollections', PromoCardModel.fromJson),
      categoryPromos: list('categoryPromos', PromoCardModel.fromJson),
    );
  }

  // obiectele au fost create de fromJson, deci sunt modele: cast() e sigur
  Map<String, dynamic> toJson() => {
        'storeName': storeName,
        'categories': categories.cast<CategoryItemModel>().map((e) => e.toJson()).toList(),
        'heroBanner': (heroBanner as HeroBannerModel).toJson(),
        'featureProducts': featureProducts.cast<ProductSummaryModel>().map((e) => e.toJson()).toList(),
        'newCollection': (newCollection as NewCollectionModel).toJson(),
        'recommended': recommended.cast<ProductSummaryModel>().map((e) => e.toJson()).toList(),
        'topCollections': topCollections.cast<PromoCardModel>().map((e) => e.toJson()).toList(),
        'categoryPromos': categoryPromos.cast<PromoCardModel>().map((e) => e.toJson()).toList(),
      };
}
