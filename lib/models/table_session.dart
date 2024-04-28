class TableSession {
  const TableSession({
    required this.restaurantId,
    required this.restaurantLogo,
    required this.restaurantName,
    required this.tableAccessToken,
  });

  final String? tableAccessToken;
  final String restaurantName;
  final String? restaurantLogo;
  final String restaurantId;

  factory TableSession.fromJson(
    Map<String, dynamic> tableSessionJson,
    Map<String, String> tableSessionJsonHeaders,
  ) {
    return TableSession(
      tableAccessToken: tableSessionJsonHeaders['authorization'] != null
          ? tableSessionJsonHeaders['authorization']!.split(' ')[1]
          : tableSessionJsonHeaders['authorization'],
      restaurantId: tableSessionJson['restaurantId'],
      restaurantLogo: tableSessionJson['restaurantLogo'],
      restaurantName: tableSessionJson['restaurantName'],
    );
  }
}
