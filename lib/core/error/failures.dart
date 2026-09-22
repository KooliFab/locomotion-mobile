abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  String toString() => '$runtimeType: $message (code: $statusCode)';
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.statusCode]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message =
        'Impossible de contacter le serveur LocoMotion. Vérifiez votre connexion.',
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Identifiants invalides ou session expirée.',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erreur de lecture du stockage local.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Une erreur inattendue est survenue.',
  ]);
}
