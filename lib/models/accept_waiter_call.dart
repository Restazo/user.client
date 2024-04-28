class AcceptWaiterCall {
  const AcceptWaiterCall({required this.message});

  final String message;

  factory AcceptWaiterCall.fromJson(Map<String, dynamic> json) {
    return AcceptWaiterCall(
      message: json['message']!,
    );
  }
}
