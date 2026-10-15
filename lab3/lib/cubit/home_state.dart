import '../models/home_page_data.dart';
import '../models/product.dart';

enum SortOption { none, priceAsc, priceDesc, nameAsc }

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.none:
        return 'Implicit';
      case SortOption.priceAsc:
        return 'Preț crescător';
      case SortOption.priceDesc:
        return 'Preț descrescător';
      case SortOption.nameAsc:
        return 'Nume A-Z';
    }
  }
}

/// Cele 4 stări principale ale ecranului Home, cerute de laborator:
/// Loading, Success (HomeLoaded), Empty, Error.
sealed class HomeState {
  const HomeState();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}

/// Când căutarea/filtrul activ nu găsește niciun produs.
class HomeEmpty extends HomeState {
  final HomePageData homeData;
  final String query;
  final SortOption sort;
  final bool favoritesOnly;
  final Set<String> favoriteIds;

  const HomeEmpty({
    required this.homeData,
    required this.query,
    required this.sort,
    required this.favoritesOnly,
    required this.favoriteIds,
  });
}

/// Starea de succes: datele s-au încărcat cu bine.
/// - când [isSearchMode] e false: se afișează homepage-ul curat (ca în Figma)
/// - când [isSearchMode] e true: se afișează grila filtrată/sortată din [visibleProducts]
class HomeLoaded extends HomeState {
  final HomePageData homeData;
  final List<Product> visibleProducts;
  final bool isSearchMode;
  final String query;
  final SortOption sort;
  final bool favoritesOnly;
  final Set<String> favoriteIds;

  const HomeLoaded({
    required this.homeData,
    required this.visibleProducts,
    required this.isSearchMode,
    required this.query,
    required this.sort,
    required this.favoritesOnly,
    required this.favoriteIds,
  });
}