import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class APIService {
  final String baseUrl = dotenv.env["USER_APP_API_URL"]!;
  final String env = dotenv.env['ENV']!;
  final String restaurantsNearMeEndpoint = dotenv.env['RESTAURANTS_NEAR_ME']!;
  final String userLatitudeQueryName = dotenv.env["USER_LATITUDE_QUERY_NAME"]!;
  final String userLongitudeQueryName =
      dotenv.env["USER_LONGITUDE_QUERY_NAME"]!;
  final String rangeQueryName = dotenv.env['RANGE_QUERY_NAME']!;

  String getProtocol() {
    return env == 'prod' ? 'https' : 'http';
  }

  Future<List<RestaurantNearYou>> loadRestaurantsNearYou() async {
    final baseUrlParsed = Uri.parse(dotenv.env["USER_APP_API_URL"]!);
    final protocol = getProtocol();

    final url = Uri(
        scheme: protocol,
        host: baseUrlParsed.host,
        port: baseUrlParsed.port,
        path: restaurantsNearMeEndpoint,
        queryParameters: {
          userLatitudeQueryName: '65.012093',
          userLongitudeQueryName: '25.465076',
          rangeQueryName: '300',
        });

    try {
      final res = await http.get(url);
      final resJson = json.decode(res.body);
      final List<dynamic> jsonData = resJson['data'];

      List<RestaurantNearYou> data = jsonData
          .map((restaurantJson) => RestaurantNearYou.fromJson(restaurantJson))
          .toList();

      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

// Future<List<RestaurantNearYou>>