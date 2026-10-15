import 'home_page_data.dart';
import 'product_detail.dart';

/// Rădăcina JSON-ului: { "homePage": {...}, "productPage": { "product": {...} } }
class AppData {
  final HomePageData homePage;
  final ProductDetail productPageProduct;

  const AppData({required this.homePage, required this.productPageProduct});

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      homePage: HomePageData.fromJson(json['homePage'] as Map<String, dynamic>),
      productPageProduct: ProductDetail.fromJson(
        (json['productPage'] as Map<String, dynamic>)['product'] as Map<String, dynamic>,
      ),
    );
  }
}