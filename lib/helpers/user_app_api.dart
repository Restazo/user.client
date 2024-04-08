import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/models/restaurant_overview.dart';
import 'package:restazo_user_mobile/providers/restaurant_ovreview_provoder.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';

final String baseUrl = dotenv.env["USER_APP_API_URL"]!;
final String env = dotenv.env['ENV']!;
final String restaurantsEndpointsRoot =
    dotenv.env['RESTAURANTS_ENDPOINTS_ROOT']!;
final String userLatitudeQueryName = dotenv.env["USER_LATITUDE_QUERY_NAME"]!;
final String userLongitudeQueryName = dotenv.env["USER_LONGITUDE_QUERY_NAME"]!;
final String rangeQueryName = dotenv.env['RANGE_QUERY_NAME']!;
final String protocol = dotenv.env['HTTP_PROTOCOL']!;
final String searchRangeKeyName = dotenv.env['USER_SEARCH_RANGE_KEY_NAME']!;

// Class to interact with user API, all the functions to call an API must
// be defined here
class APIService {
  // Get all the needed environment variables

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

  String _decodeError(Response response) {
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
    final String path = restaurantsEndpointsRoot;
    final preferences = await SharedPreferences.getInstance();

    final String? userRange = preferences.getString(searchRangeKeyName);

    if (userRange != null) {
      queryParameters.addEntries(
        {
          rangeQueryName: userRange,
        }.entries,
      );
    }

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

        final List<RestaurantNearYou> data = jsonData
            .map((restaurantJson) => RestaurantNearYou.fromJson(restaurantJson))
            .toList();

        // Return the state of user closest restaurants
        // with the actual restaurants data
        return RestaurantsNearYouState(data: data, errorMessage: null);
      } else {
        // Decode an error if response code is not 200
        final errorMessage = _decodeError(res);
        // Return the state of user closest restaurants
        // with an error message and no restaurants data
        return RestaurantsNearYouState(data: [], errorMessage: errorMessage);
      }
    } catch (e) {
      // Return the state of user closest restaurants
      // with an error message and no restaurants data
      return const RestaurantsNearYouState(
          data: [], errorMessage: "Failed to fetch restaurants");
    }
  }

  Future<RestaurantOverviewState> loadRestaurantOverviewById(
      String id, LocationData? currentLocation) async {
    Map<String, dynamic> queryParameters = {};

    if (currentLocation != null) {
      queryParameters.addEntries(
        {
          userLatitudeQueryName: currentLocation.latitude.toString(),
          userLongitudeQueryName: currentLocation.longitude.toString(),
        }.entries,
      );
    }

    final url = getUrl(
      path: "$restaurantsEndpointsRoot/$id",
      queryParameters: queryParameters,
    );

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        // Decode the response body
        final resJson = json.decode(res.body);
        final dynamic restaurantOverviewDataJson =
            resJson['data']['restaurant'];

        final restaurantOverviewData =
            RestaurantOverview.fromJson(restaurantOverviewDataJson);
        // Return the state of restaurant menu
        // with menu data
        return RestaurantOverviewState(
            data: restaurantOverviewData, errorMessage: null);
      } else {
        // Decode an error if response code is not 200
        final errorMessage = _decodeError(res);

        // Return the state of restaurant menu
        // with an error message and no menu data
        return RestaurantOverviewState(data: null, errorMessage: errorMessage);
      }
    } catch (e) {
      // Return the state of restaurant menu
      // with an error message and no menu data
      return const RestaurantOverviewState(
          data: null, errorMessage: 'Failed to fetch restaurant info');
    }
  }
}
