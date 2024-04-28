class OrderId {
  const OrderId({required this.orderId});

  final String orderId;

  factory OrderId.fromJson(Map<String, dynamic> json) {
    return OrderId(
      orderId: json['orderId']!,
    );
  }
}
