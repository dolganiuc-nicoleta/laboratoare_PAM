import '../../core/result.dart';
import '../entities/product_detail.dart';
import '../repositories/feed_repository.dart';

class GetProductDetails {
  final FeedRepository repository;
  const GetProductDetails(this.repository);

  Future<Result<ProductDetail>> call(String productId) => repository.getProductDetails(productId);
}
