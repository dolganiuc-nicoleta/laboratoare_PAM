import '../../core/exceptions.dart';
import '../../core/failures.dart';
import '../../core/result.dart';
import '../../domain/entities/feed.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_data_source.dart';

// IMPLEMENTAREA contractului din Domain: cheamă data source-ul și
// transformă excepțiile tehnice în Failure-uri.
class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remote;
  const FeedRepositoryImpl(this.remote);

  @override
  Future<Result<HomeFeed>> getHomeFeed() => _guard(remote.fetchFeed);

  @override
  Future<Result<ProductDetail>> getProductDetails(String productId) =>
      _guard(remote.fetchDetails); // endpoint-ul nu folosește id-ul

  // Un singur loc pentru try/catch, ca să nu-l repetăm în fiecare metodă
  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Ok(await action()); // succes -> Ok(valoare)
    } on NetworkException {
      return Err(const NetworkFailure());
    } on ServerException catch (e) {
      return Err(ServerFailure('Eroare server (cod ${e.statusCode}).'));
    } on ParsingException {
      return Err(const ParsingFailure());
    }
  }
}
