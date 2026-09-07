sealed class StatePattern<T> {
  const StatePattern();
}

final class InitialState<T> extends StatePattern<T> {
  const InitialState();
}

final class LoadingState<T> extends StatePattern<T> {
  const LoadingState();
}

final class SuccessState<T> extends StatePattern<T> {
  final T data;

  const SuccessState({required this.data});
}

final class ErrorState<T> extends StatePattern<T> {
  final String message;

  const ErrorState({required this.message});
}
