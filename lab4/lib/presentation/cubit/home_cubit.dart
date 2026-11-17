import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import '../../domain/entities/feed.dart';
import '../../domain/usecases/get_home_feed.dart';

// ---------- STĂRI ----------
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

class HomeLoaded extends HomeState {
  final HomeFeed feed;
  const HomeLoaded(this.feed);
}

// ---------- CUBIT ----------
class HomeCubit extends Cubit<HomeState> {
  final GetHomeFeed getHomeFeed;
  HomeCubit(this.getHomeFeed) : super(const HomeLoading());

  Future<void> load() async {
    emit(const HomeLoading()); // UI-ul arată spinner
    final result = await getHomeFeed();
    // Result e sealed: compilatorul ne obligă să tratăm și Ok, și Err
    switch (result) {
      case Ok<HomeFeed>(:final value):
        emit(HomeLoaded(value));
      case Err<HomeFeed>(:final failure):
        emit(HomeError(failure.message)); // UI-ul arată mesaj + „Reîncearcă”
    }
  }
}
