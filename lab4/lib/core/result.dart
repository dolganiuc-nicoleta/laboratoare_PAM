import 'failures.dart';

// Rezultatul unei operații: ori Ok(valoare), ori Err(failure).
// Astfel nu aruncăm excepții prin straturi, ci returnăm explicit rezultatul.
sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}
