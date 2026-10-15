class Product {
  final String name;
  final double price;
  final String imageUrl; // asset path ("assets/images/...") sau URL de rețea

  const Product({required this.name, required this.price, required this.imageUrl});

  bool get isAsset => imageUrl.startsWith('assets/');
}

const List<Product> featuredProducts = [
  Product(
    name: 'Turtleneck Sweater',
    price: 39.99,
    imageUrl: 'assets/images/product_sweater.png',
  ),
  Product(
    name: 'Long Sleeve Dress',
    price: 45.00,
    imageUrl: 'assets/images/product_dress.png',
  ),
  Product(
    // confirmat din layer-ele Figma: "feature 3" = image 84 + textul "Sportwear Set" / "$50.00"
    name: 'Sportwear Set',
    price: 50.00,
    imageUrl: 'assets/images/product_loungeset.png',
  ),
  // TODO: "feature 4" (rochia maro, image 86) - nu am inca numele/pretul din Figma,
  // am pus provizoriu. Trimite-mi textul din Frame-ul de langa feature 4 cand il gasesti.
  Product(
    name: 'Wrap Midi Dress',
    price: 52.00,
    imageUrl: 'assets/images/product_wrapdress.png',
  ),
];

const List<Product> recommendedProducts = [
  Product(
    name: 'White Fashion Hoodie',
    price: 29.00,
    imageUrl: 'assets/images/product_hoodie.png',
  ),
  Product(
    name: 'Cotton T-Shirt',
    price: 30.00,
    imageUrl: 'assets/images/product_cotton.png',
  ),
];

// acum toate 3 au poze reale exportate din Figma, nu mai sunt de pe internet
const List<Product> similarProducts = [
  Product(
    name: 'Crop Hoodie',
    price: 45.00,
    imageUrl: 'assets/images/similar_hoodie.png',
  ),
  Product(
    name: 'Zip Up Jacket',
    price: 39.99,
    imageUrl: 'assets/images/similar_jacket.png',
  ),
  Product(
    name: 'Crop Tee',
    price: 32.99,
    imageUrl: 'assets/images/similar_crop.png',
  ),
];