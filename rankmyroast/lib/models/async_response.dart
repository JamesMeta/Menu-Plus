class AsyncResponse {
  final bool success;
  final bool? error;
  final String? errorMessage;

  AsyncResponse({required this.success, this.error, this.errorMessage});
}
