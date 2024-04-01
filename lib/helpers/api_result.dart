// This class is used for receiving and
// passing API responses to UI
class APIServiceResult<T> {
  const APIServiceResult({this.errorMessage, this.data});

  final T? data;
  final String? errorMessage;

  bool get isSuccess => data != null;
}
