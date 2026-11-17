import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repositories/feed_repository.dart';
import '../domain/usecases/get_product_details.dart';
import 'cubit/product_details_cubit.dart';
import 'screens/product_screen.dart';

// Deschide ecranul produsului: îi creează cubit-ul propriu și pornește cererea HTTP.
// Folosit și din HomeScreen, și din "Similar Products".
void openProduct(BuildContext context, String productId) {
  final repository = context.read<FeedRepository>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => ProductDetailsCubit(GetProductDetails(repository), productId)..load(),
        child: const ProductScreen(),
      ),
    ),
  );
}
