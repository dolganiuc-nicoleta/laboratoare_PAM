// Failure = eroare "pe înțelesul aplicației". UI-ul vede doar astea,
// niciodată excepții brute de la HTTP sau JSON.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Nu s-a putut contacta serverul. Verifică internetul și reîncearcă (serverul gratuit poate porni lent).']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Serverul a răspuns cu o eroare.']);
}

class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Datele primite au un format neașteptat.']);
}
