class AsyncResponse {
  final bool success;
  final bool? localError;
  final String? errorMessage;

  AsyncResponse({required this.success, this.localError, this.errorMessage});
}
