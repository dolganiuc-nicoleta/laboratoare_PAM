import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/app_repository.dart';
import '../models/home_page_data.dart';
import '../models/product.dart';
import '../models/product_detail.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppRepository repository;

  HomeCubit(this.repository) : super(const HomeLoading());

  HomePageData? _homeData;
  ProductDetail? _detailedProduct;
  List<Product> _catalog = [];

  String _query = '';
  SortOption _sort = SortOption.none;
  bool _favoritesOnly = false;
  final Set<String> _favoriteIds = {};

  /// Produsul (dacă există) pentru care avem date complete de detaliu în JSON.
  ProductDetail? detailFor(String productId) {
    if (_detailedProduct != null && _detailedProduct!.id == productId) {
      return _detailedProduct;
    }
    return null;
  }

  Future<void> loadHome() async {
    emit(const HomeLoading());
    try {
      final data = await repository.loadAppData();
      _homeData = data.homePage;
      _detailedProduct = data.productPageProduct;
      _catalog = _buildCatalog(data.homePage);

      // păstrăm din JSON produsul care era deja marcat favorit (actions.isFavorite)
      if (_detailedProduct!.actions.isFavorite) {
        _favoriteIds.add(_detailedProduct!.id);
      }

      _emitCurrentState();
    } catch (e) {
      emit(HomeError('Nu am putut încărca datele: $e'));
    }
  }

  List<Product> _buildCatalog(HomePageData h) {
    final byId = <String, Product>{};
    for (final p in h.featureProducts) {
      byId[p.id] = p;
    }
    for (final p in h.recommended) {
      byId[p.id] = p;
    }
    return byId.values.toList();
  }

  bool get _isSearchMode =>
      _query.trim().isNotEmpty || _favoritesOnly || _sort != SortOption.none;

  void search(String query) {
    _query = query;
    _emitCurrentState();
  }

  void setSort(SortOption sort) {
    _sort = sort;
    _emitCurrentState();
  }

  void toggleFavoritesOnly() {
    _favoritesOnly = !_favoritesOnly;
    _emitCurrentState();
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    _emitCurrentState();
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void _emitCurrentState() {
    final home = _homeData;
    if (home == null) return;

    if (!_isSearchMode) {
      emit(HomeLoaded(
        homeData: home,
        visibleProducts: const [],
        isSearchMode: false,
        query: _query,
        sort: _sort,
        favoritesOnly: _favoritesOnly,
        favoriteIds: Set.of(_favoriteIds),
      ));
      return;
    }

    final q = _query.trim().toLowerCase();
    var list = _catalog.where((p) {
      final matchesQuery = q.isEmpty || p.name.toLowerCase().contains(q);
      final matchesFav = !_favoritesOnly || _favoriteIds.contains(p.id);
      return matchesQuery && matchesFav;
    }).toList();

    switch (_sort) {
      case SortOption.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.none:
        break;
    }

    if (list.isEmpty) {
      emit(HomeEmpty(
        homeData: home,
        query: _query,
        sort: _sort,
        favoritesOnly: _favoritesOnly,
        favoriteIds: Set.of(_favoriteIds),
      ));
    } else {
      emit(HomeLoaded(
        homeData: home,
        visibleProducts: list,
        isSearchMode: true,
        query: _query,
        sort: _sort,
        favoritesOnly: _favoritesOnly,
        favoriteIds: Set.of(_favoriteIds),
      ));
    }
  }
}