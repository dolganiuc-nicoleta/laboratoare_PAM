import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

// ---------- STĂRI ----------
sealed class ProductsState {
  const ProductsState();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsEmpty extends ProductsState {
  const ProductsEmpty();
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  const ProductsLoaded(this.products);
}

// ---------- CUBIT ----------
class ProductsCubit extends Cubit<ProductsState> {
  final GetProducts getProducts;
  // Starea inițială este Loading, fiindcă imediat se face prima cerere.
  ProductsCubit(this.getProducts) : super(const ProductsLoading());

  // Filtrele curente sunt ținute în cubit (nu în UI).
  String? _category; // null = toate
  String _query = '';

  String? get category => _category;

  Future<void> load() async {
    emit(const ProductsLoading()); // UI-ul afișează spinner
    final result = await getProducts(category: _category, query: _query);
    // Result e sealed: compilatorul ne obligă să tratăm și Ok, și Err.
    switch (result) {
      case Ok<List<Product>>(:final value):
        emit(value.isEmpty ? const ProductsEmpty() : ProductsLoaded(value));
      case Err<List<Product>>(:final failure):
        emit(ProductsError(failure.message)); // UI-ul afișează mesajul + buton Reîncearcă
    }
  }

  void selectCategory(String? slug) {
    _category = slug;
    _query = ''; // categoria și căutarea se exclud reciproc
    load();
  }

  void search(String text) {
    _query = text;
    _category = null;
    load();
  }
}
