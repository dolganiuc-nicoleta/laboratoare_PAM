// Excepții aruncate de stratul Data (data source). Repository-ul le
// transformă în Failure.
class ServerException implements Exception {
  final int statusCode;
  const ServerException(this.statusCode);
}

class NetworkException implements Exception {
  const NetworkException();
}

class ParsingException implements Exception {
  const ParsingException();
}
