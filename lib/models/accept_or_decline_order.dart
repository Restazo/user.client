class AcceptOrDeclineOrder {
  const AcceptOrDeclineOrder({required this.message});

  final String message;

  factory AcceptOrDeclineOrder.fromJson(Map<String, dynamic> json) {
    return AcceptOrDeclineOrder(
      message: json['message']!,
    );
  }
}
