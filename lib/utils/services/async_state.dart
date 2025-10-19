// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

/// -----------------
/// AsyncState (sealed-like with when/map)
/// -----------------
class AsyncState<T> {
  final T? data;
  final Object? error;
  final bool isLoading;
  const AsyncState._({this.data, this.error, required this.isLoading});

  factory AsyncState.loading() => AsyncState._(isLoading: true);
  factory AsyncState.data(T value) =>
      AsyncState._(data: value, isLoading: false);
  factory AsyncState.error(Object err) =>
      AsyncState._(error: err, isLoading: false);

  bool get hasData => data != null && !isLoading && error == null;
  bool get hasError => error != null;

  /// Whether the state is currently loading
  bool get isLoadingState => isLoading;

  /// Whether the state has data (not loading and no error)
  bool get isDataState => hasData;

  /// Whether the state has an error
  bool get isErrorState => hasError;

  R when<R>({
    required R Function() loading,
    required R Function(T value) data,
    required R Function(Object error) error,
  }) {
    if (isLoading) return loading();
    if (this.error != null) return error(this.error!);
    return data(this.data as T);
  }

  R? map<R>({
    R Function()? loading,
    R Function(T value)? data,
    R Function(Object error)? error,
  }) {
    if (isLoading) return loading?.call();
    if (this.error != null) return error?.call(this.error!);
    return data?.call(this.data as T);
  }
}
