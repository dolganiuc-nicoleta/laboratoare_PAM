import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/exceptions.dart';
import '../models/product_model.dart';

// DATA SOURCE: singurul loc care vorbește cu serverul prin HTTP.
class ProductRemoteDataSource {
  // Clientul HTTP e primit din exterior (injectat): la teste poate fi înlocuit cu unul fals.
  final http.Client client;
  const ProductRemoteDataSource(this.client);

  static const _host = 'dummyjson.com';

  // Categoriile de modă din DummyJSON (restul API-ului are mobilă, mâncare etc.)
  static const fashionCategories = [
    'womens-dresses',
    'tops',
    'mens-shirts',
    'womens-bags',
    'womens-shoes',
  ];

  // GET /products/search?q= | /products/category/{slug} | toate categoriile de modă
  Future<List<ProductModel>> fetchProducts({String? category, String query = ''}) async {
    // 1) Căutare: cerem la server, apoi păstrăm doar produsele de modă
    if (query.trim().isNotEmpty) {
      final found = await _fetchList(
        Uri.https(_host, '/products/search', {'q': query.trim(), 'limit': '50'}),
      );
      return found.where((p) => fashionCategories.contains(p.category)).toList();
    }
    // 2) O singură categorie aleasă
    if (category != null) {
      return _fetchList(
        Uri.https(_host, '/products/category/$category', {'limit': '30'}),
      );
    }
    // 3) "All": 5 cereri în paralel (Future.wait), apoi unim rezultatele
    final lists = await Future.wait(
      fashionCategories.map(
            (c) => _fetchList(Uri.https(_host, '/products/category/$c', {'limit': '10'})),
      ),
    );
    return lists.expand((l) => l).toList();
  }

  // Cerere GET + transformare JSON -> listă de ProductModel
  Future<List<ProductModel>> _fetchList(Uri uri) async {
    final body = await _get(uri); // await = așteptăm răspunsul fără să blocăm UI-ul
    try {
      // jsonDecode: text JSON -> Map<String, dynamic>
      // apoi fiecare element din lista 'products' devine un ProductModel
      final json = jsonDecode(body) as Map<String, dynamic>;
      return (json['products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      // FormatException = JSON invalid; TypeError = un câmp are alt tip decât ne așteptăm
    } on FormatException {
      throw const ParsingException();
    } on TypeError {
      throw const ParsingException();
    }
  }

  // GET /products/{id}
  Future<ProductModel> fetchProduct(int id) async {
    final body = await _get(Uri.https(_host, '/products/$id'));
    try {
      return ProductModel.fromJson(jsonDecode(body) as Map<String, dynamic>);
    } on FormatException {
      throw const ParsingException();
    } on TypeError {
      throw const ParsingException();
    }
  }

  // cerere GET comună: tratează timeout, lipsă net, coduri HTTP != 200
  Future<String> _get(Uri uri) async {
    final http.Response response;
    try {
      // .timeout: dacă serverul nu răspunde în 10 secunde, aruncă TimeoutException
      response = await client.get(uri).timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }
    // 200 = OK. Orice altceva (404, 500...) este o eroare de server.
    if (response.statusCode != 200) {
      throw ServerException(response.statusCode);
    }
    // decodăm explicit UTF-8, ca diacriticele/caracterele speciale să fie corecte
    return utf8.decode(response.bodyBytes);
  }
}