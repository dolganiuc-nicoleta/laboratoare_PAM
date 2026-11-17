import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/usecases/get_product_details.dart';

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
  final ProductDetail product;
  const DetailsLoaded(this.product);
}

// Cubit separat pentru ecranul produsului: fiecare ecran are propria stare.
class ProductDetailsCubit extends Cubit<DetailsState> {
  final GetProductDetails getProductDetails;
  final String productId;
  ProductDetailsCubit(this.getProductDetails, this.productId) : super(const DetailsLoading());

  Future<void> load() async {
    emit(const DetailsLoading());
    final result = await getProductDetails(productId);
    switch (result) {
      case Ok<ProductDetail>(:final value):
        emit(DetailsLoaded(value));
      case Err<ProductDetail>(:final failure):
        emit(DetailsError(failure.message));
    }
  }
}
