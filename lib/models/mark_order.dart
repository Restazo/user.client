class MarkTableOrders {
  const MarkTableOrders({required this.message});

  final String message;

  factory MarkTableOrders.fromJson(Map<String, dynamic> json) {
    return MarkTableOrders(
      message: json['message']!,
    );
  }
}
