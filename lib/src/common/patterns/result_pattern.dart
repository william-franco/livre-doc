sealed class Result<S, E extends Exception> {
  const Result();

  T fold<T>({
    required T Function(S value) onSuccess,
    required T Function(E error) onError,
  }) {
    switch (this) {
      case Success(value: final v):
        return onSuccess(v);
      case Error(error: final e):
        return onError(e);
    }
  }
}

final class Success<S, E extends Exception> extends Result<S, E> {
  final S value;

  const Success({required this.value});
}

final class Error<S, E extends Exception> extends Result<S, E> {
  final E error;

  const Error({required this.error});
}
