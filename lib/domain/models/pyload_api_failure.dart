/// The only error an `IPyLoadApiRepository` method fails with
///
/// Show [message] to the user.
sealed class PyLoadApiFailure implements Exception {
  const PyLoadApiFailure();

  /// User-facing description of this failure
  String get message => switch (this) {
    PyLoadApiUnauthorized() =>
      'Authentication failed. Please check your API key.',
    PyLoadApiTimeout() => 'The server did not respond in time.',
    PyLoadApiUnreachable() =>
      'Could not connect to the server. Please check the address and your '
          'network connection.',
    PyLoadApiServerError(:final statusCode) =>
      'The server reported an error (HTTP $statusCode).',
    PyLoadApiBadResponse() => 'The server sent an unexpected response.',
  };

  @override
  String toString() => message;
}

/// The API key was rejected
class PyLoadApiUnauthorized extends PyLoadApiFailure {
  const PyLoadApiUnauthorized();
}

/// The server did not answer within the request timeout
class PyLoadApiTimeout extends PyLoadApiFailure {
  const PyLoadApiTimeout();
}

/// No connection could be established (network, DNS, TLS)
class PyLoadApiUnreachable extends PyLoadApiFailure {
  const PyLoadApiUnreachable();
}

/// The server answered with an error status
class PyLoadApiServerError extends PyLoadApiFailure {
  final int statusCode;

  const PyLoadApiServerError(this.statusCode);
}

/// The server answered, but the body is missing or cannot be read
class PyLoadApiBadResponse extends PyLoadApiFailure {
  const PyLoadApiBadResponse();
}
