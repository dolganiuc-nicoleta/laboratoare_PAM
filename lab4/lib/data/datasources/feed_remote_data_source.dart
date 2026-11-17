import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/exceptions.dart';
import '../models/feed_models.dart';
import '../models/product_detail_model.dart';

// DATA SOURCE: singurul loc care vorbește cu serverul prin HTTP.
class FeedRemoteDataSource {
  // Clientul HTTP e primit din exterior (injectat), ca să poată fi înlocuit la teste.
  final http.Client client;
  const FeedRemoteDataSource(this.client);

  static const _host = 'test-api-jlbn.onrender.com';
  // v1 = varianta GemStore (v2, v3, v4 sunt alte aplicații)
  static const _base = '/lab2026/v1';

  // GET /lab2026/v1/feed
  Future<HomeFeedModel> fetchFeed() async {
    final json = await _getJson('$_base/feed');
    return _parse(() => HomeFeedModel.fromJson(json));
  }

  // GET /lab2026/v1/feed/details
  // (API-ul nu primește id: întoarce mereu același produs)
  Future<ProductDetailModel> fetchDetails() async {
    final json = await _getJson('$_base/feed/details');
    return _parse(() => ProductDetailModel.fromJson(json));
  }

  // Rulează parsarea și transformă erorile de format în ParsingException
  T _parse<T>(T Function() parser) {
    try {
      return parser();
    } on FormatException {
      throw const ParsingException();
    } on TypeError {
      // un câmp lipsește sau are alt tip decât ne așteptăm
      throw const ParsingException();
    }
  }

  // Cerere GET comună: tratează timeout, lipsă net și coduri HTTP != 200
  Future<Map<String, dynamic>> _getJson(String path) async {
    final http.Response response;
    try {
      // 60 s: serverul gratuit de pe Render poate "adormi" și are nevoie de timp să pornească
      response = await client
          .get(Uri.https(_host, path), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 60));
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }
    if (response.statusCode != 200) {
      throw ServerException(response.statusCode);
    }
    try {
      // utf8.decode: diacriticele/caracterele speciale rămân corecte
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } on FormatException {
      throw const ParsingException();
    } on TypeError {
      throw const ParsingException();
    }
  }
}
