class FirebaseResponse<T> {
  final T? data;
  final String? message;
  final num? status;
  const FirebaseResponse({
    this.data,
    this.message,
    this.status,
  });
}
