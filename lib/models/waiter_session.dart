class WaiterSession {
  const WaiterSession(
      {required this.accessToken, required this.email, required this.name});

  final String email;
  final String accessToken;
  final String name;

  factory WaiterSession.fromJson(
    Map<String, dynamic> waiterSessionJsonBody,
    Map<String, String> waiterSessionJsonHeaders,
  ) {
    return WaiterSession(
      accessToken: waiterSessionJsonHeaders['authorization']!.split(' ')[1],
      email: waiterSessionJsonBody['email']!,
      name: waiterSessionJsonBody['name']!,
    );
  }
}
