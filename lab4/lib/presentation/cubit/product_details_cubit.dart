import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_by_id.dart';

sealed class DetailsState {
  const DetailsState();
}

class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

class DetailsError extends DetailsState {
  final String message;
  const DetailsError(this.message);
}

class DetailsLoaded extends DetailsState {
  final Product product;
  const DetailsLoaded(this.product);
}

// Cubit separat pentru ecranul de detalii: fiecare ecran are propria stare.
class ProductDetailsCubit extends Cubit<DetailsState> {
  final GetProductById getProductById;
  ProductDetailsCubit(this.getProductById) : super(const DetailsLoading());

  Future<void> load(int id) async {
    emit(const DetailsLoading());
    final result = await getProductById(id);
    switch (result) {
      case Ok<Product>(:final value):
        emit(DetailsLoaded(value));
      case Err<Product>(:final failure):
        emit(DetailsError(failure.message));
    }
  }
}
