import '../../core/exceptions.dart';
import '../../core/failures.dart';
import '../../core/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

// IMPLEMENTAREA contractului din Domain. Cheamă data source-ul și
// transformă excepțiile în Failure-uri.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  const ProductRepositoryImpl(this.remote);

  @override
  Future<Result<List<Product>>> getProducts({String? category, String query = ''}) {
    return _guard(() => remote.fetchProducts(category: category, query: query));
  }

  @override
  Future<Result<Product>> getProductById(int id) {
    return _guard(() => remote.fetchProduct(id));
  }

  // Funcție generică: execută o acțiune și prinde excepțiile într-un singur loc.
  // Astfel nu repetăm try/catch în fiecare metodă.
  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Ok(await action()); // succes -> Ok(valoare)
    // Mai jos: excepție tehnică (Data) -> Failure cu mesaj pentru utilizator (Domain)
    } on NetworkException {
      return Err(const NetworkFailure());
    } on ServerException catch (e) {
      return Err(ServerFailure('Eroare server (cod ${e.statusCode}).'));
    } on ParsingException {
      return Err(const ParsingFailure());
    }
  }
}
