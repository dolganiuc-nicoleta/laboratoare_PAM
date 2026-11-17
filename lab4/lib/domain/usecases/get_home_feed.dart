import '../../core/result.dart';
import '../entities/feed.dart';
import '../repositories/feed_repository.dart';

// USE CASE: o singură acțiune de business, apelabilă ca funcție: getHomeFeed()
class GetHomeFeed {
  final FeedRepository repository;
  const GetHomeFeed(this.repository);

  Future<Result<HomeFeed>> call() => repository.getHomeFeed();
}
