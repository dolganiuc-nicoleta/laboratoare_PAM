import '../../core/result.dart';
import '../entities/product.dart';

// CONTRACT (interfață abstractă). Domain spune CE trebuie făcut,
// Data (ProductRepositoryImpl) decide CUM.
abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({String? category, String query = ''});
  Future<Result<Product>> getProductById(int id);
}
