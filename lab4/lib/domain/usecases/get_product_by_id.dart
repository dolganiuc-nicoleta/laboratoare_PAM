import '../../core/result.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductById {
  final ProductRepository repository;
  const GetProductById(this.repository);

  Future<Result<Product>> call(int id) => repository.getProductById(id);
}
