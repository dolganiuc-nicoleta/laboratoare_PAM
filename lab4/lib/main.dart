import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_products.dart';
import 'presentation/cubit/products_cubit.dart';
import 'presentation/screens/home_screen.dart';

// Punctul de intrare al aplicației: runApp pornește arborele de widgeturi.
void main() => runApp(const GemStoreLab4App());

class GemStoreLab4App extends StatelessWidget {
  const GemStoreLab4App({super.key});

  @override
  Widget build(BuildContext context) {
    // "Compoziția" dependențelor, de jos în sus:
    // http.Client -> DataSource -> Repository -> UseCase -> Cubit
    // RepositoryProvider = pune repository-ul la dispoziția întregii aplicații
    // (se citește mai jos cu context.read<ProductRepository>()).
    // Tipul este INTERFAȚA (ProductRepository), implementarea e ProductRepositoryImpl:
    // putem schimba oricând sursa de date fără să atingem restul codului.
    return RepositoryProvider<ProductRepository>(
      create: (_) => ProductRepositoryImpl(ProductRemoteDataSource(http.Client())),
      // BlocProvider = creează ProductsCubit și îl oferă ecranelor de sub el.
      // ..load() (cascade) apelează load() imediat după creare => prima cerere HTTP.
      child: BlocProvider(
        create: (ctx) =>
            ProductsCubit(GetProducts(ctx.read<ProductRepository>()))..load(),
        child: MaterialApp(
          title: 'GemStore — Lab 4',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF7F5F3),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
