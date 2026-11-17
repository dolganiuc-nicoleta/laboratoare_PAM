import '../../core/result.dart';
import '../entities/feed.dart';
import '../entities/product_detail.dart';

// CONTRACT: Domain spune CE trebuie făcut, Data decide CUM (HTTP, cache etc.).
abstract class FeedRepository {
  Future<Result<HomeFeed>> getHomeFeed();
  Future<Result<ProductDetail>> getProductDetails(String productId);
}
