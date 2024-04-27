class CallWaiter {
  const CallWaiter({required this.message});

  final String message;

  factory CallWaiter.fromJson(Map<String, dynamic> json) {
    return CallWaiter(
      message: json['message']!,
    );
  }
}
