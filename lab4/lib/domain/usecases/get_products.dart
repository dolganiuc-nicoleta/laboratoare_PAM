import '../../core/result.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

// USE CASE: o singură acțiune de business. Se apelează ca o funcție: getProducts(...)
class GetProducts {
  final ProductRepository repository;
  const GetProducts(this.repository);

  // 'call' permite apelul direct: getProducts(category: ...) fără .call()
  Future<Result<List<Product>>> call({String? category, String query = ''}) =>
      repository.getProducts(category: category, query: query);
}
