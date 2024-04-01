import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'dart:convert';

import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';

// Class to interact with user API, all the functions to call an API must
// be defined here
class APIService {
  // Get all the needed environment variables
  final String baseUrl = dotenv.env["USER_APP_API_URL"]!;
  final String env = dotenv.env['ENV']!;
  final String restaurantsNearMeEndpoint = dotenv.env['RESTAURANTS_NEAR_ME']!;
  final String userLatitudeQueryName = dotenv.env["USER_LATITUDE_QUERY_NAME"]!;
  final String userLongitudeQueryName =
      dotenv.env["USER_LONGITUDE_QUERY_NAME"]!;
  final String rangeQueryName = dotenv.env['RANGE_QUERY_NAME']!;
  final String protocol = dotenv.env['HTTP_PROTOCOL']!;

  Uri getUrl({
    Map<String, dynamic>? queryParameters,
    String? path,
  }) {
    // Parse the base URL into its components
    final baseUrlParsed = Uri.parse(dotenv.env["USER_APP_API_URL"]!);

    // Construct the URL with passed query parameters
    // and path
    final url = Uri(
      scheme: protocol,
      host: baseUrlParsed.host,
      port: baseUrlParsed.port,
      path: path,
      queryParameters: queryParameters,
    );

    return url;
  }

  String decodeError(Response response) {
    // Decode the response body
    final resJson = json.decode(response.body);
    // Extract the message property from the response body,
    // assing default error message if no "message" property
    // present in the response body
    final String errorMessage =
        resJson['message'] ?? "Sorry, but unknown error occured";

    return errorMessage;
  }

  Future<RestaurantsNearYouState> loadRestaurantsNearYou(
      LocationData? locationData) async {
    // Define query parameters and path
    // where request will be sent
    Map<String, dynamic> queryParameters = {};
    final String path = restaurantsNearMeEndpoint;

    // TODO: add checking for range set by user here
    // if (userSettingRange) {
    //   queryParameters.addEntries(
    //     {
    //       rangeQueryName: userSettingRange.toString(),
    //     }.entries,
    //   );
    // }

    // Check if location passed
    // append query parameters if location is passed
    // from the user
    if (locationData != null) {
      queryParameters.addEntries(
        {
          userLatitudeQueryName: locationData.latitude.toString(),
          userLongitudeQueryName: locationData.longitude.toString(),
        }.entries,
      );
    }

    // Generate final URL where request will be sent
    final url = getUrl(queryParameters: queryParameters, path: path);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final resJson = json.decode(res.body);
        final List<dynamic> jsonData = resJson['data'];

        List<RestaurantNearYou> data = jsonData
            .map((restaurantJson) => RestaurantNearYou.fromJson(restaurantJson))
            .toList();

        // Return the state of user closest restaurants
        // with the actual restaurants data
        return RestaurantsNearYouState(data: data);
      } else {
        // Decode an error if response code is not 200
        final errorMessage = decodeError(res);
        // Return the state of user closest restaurants
        // with an error message and no restaurants data
        return RestaurantsNearYouState(errorMessage: errorMessage);
      }
    } catch (e) {
      // Return the state of user closest restaurants
      // with an error message and no restaurants data
      return const RestaurantsNearYouState(
          errorMessage: "Failed to fetch restaurants");
    }
  }

  Future loadRestaurantById(String id) async {}
}
