import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restazo_user_mobile/models/api_result_states/waiter_session_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/waiter_log_out_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/device_id_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/waiter_log_in_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/waiter_log_in_confirmation_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/menu_item_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/restaurant_overview_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/restaurants_near_you_state.dart';
import 'package:restazo_user_mobile/models/menu_item.dart';
import 'package:restazo_user_mobile/models/device_id.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/models/restaurant_overview.dart';

// URL related variables
final String baseUrl = dotenv.env["USER_APP_API_URL"]!;
final String env = dotenv.env['ENV']!;
final String restaurantsEndpointsRoot =
    dotenv.env['RESTAURANTS_ENDPOINTS_ROOT']!;
final String userLatitudeQueryName = dotenv.env["USER_LATITUDE_QUERY_NAME"]!;
final String userLongitudeQueryName = dotenv.env["USER_LONGITUDE_QUERY_NAME"]!;
final String rangeQueryName = dotenv.env['RANGE_QUERY_NAME']!;
final String protocol = dotenv.env['HTTP_PROTOCOL']!;
final String searchRangeKeyName = dotenv.env['USER_SEARCH_RANGE_KEY_NAME']!;
final String newdDeviceIdEndpoint = dotenv.env['NEW_DEVICE_ID_ENDPOINT']!;
final String menuEndpoint = dotenv.env['MENU_ENDPOINT']!;
final String waiterEndpoint = dotenv.env['WAITER_ENDPOINT']!;
final String logInEndpoint = dotenv.env['LOG_IN_ENDPOINT']!;
final String confirmEndpoint = dotenv.env['CONFIRM_ENDPOINT']!;
final String logOutEndpoint = dotenv.env['LOG_OUT_ENDPOINT']!;
final String renewEndpoint = dotenv.env['RENEW_ENDPOINT']!;

// Storage variables
final String accessTokenKeyName = dotenv.env['ACCESS_TOKEN_KEY_NAME']!;

// Class to interact with user API, all the functions to call an API must
// be defined here
class APIService {
  // Get all the needed environment variables

  Future<DeviceIdState> getDeviceId() async {
    final url = getUrl(path: newdDeviceIdEndpoint);

    try {
      final res = await http.get(url);

      if (res.statusCode == 201) {
        final resJson = json.decode(res.body);
        final Map<String, dynamic> jsonData = resJson['data'];
        final deviceId = DeviceId.fromJson(jsonData);

        return DeviceIdState(data: deviceId, errorMessage: null);
      } else {
        final errorMessage = _decodeError(res);

        return DeviceIdState(data: null, errorMessage: errorMessage);
      }
    } catch (e) {
      return const DeviceIdState(
        data: null,
        errorMessage: 'Failed to fetch device id',
      );
    }
  }

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

  Future<MenuItemState> loadMenuItemById(
      String restaurantId, String itemId) async {
    final path = '$restaurantsEndpointsRoot/$restaurantId$menuEndpoint/$itemId';

    final url = getUrl(path: path);

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final resJson = json.decode(res.body);
        final dynamic menuItemDataJson = resJson['data'];

        final menuItemData = MenuItem.fromJson(menuItemDataJson);

        return MenuItemState(data: menuItemData, errorMessage: null);
      } else {
        final errorMessage = _decodeError(res);

        return MenuItemState(data: null, errorMessage: errorMessage);
      }
    } catch (e) {
      return const MenuItemState(
          data: null, errorMessage: 'Failed to fetch menu item data');
    }
  }

  Future<WaiterLogInState> logInWaiter(String email, String pin) async {
    final path = '$waiterEndpoint$logInEndpoint';
    final Object body = json.encode({'email': email, 'pin': pin});
    final Map<String, String> headers = {'Content-type': 'application/json'};

    final url = getUrl(path: path);

    try {
      final res = await http.post(url, body: body, headers: headers);

      if (res.statusCode == 200) {
        final resJson = json.decode(res.body);
        final String message = resJson["message"];

        return WaiterLogInState(data: message, errorMessage: null);
      } else {
        final errorMessage = _decodeError(res);

        return WaiterLogInState(data: null, errorMessage: errorMessage);
      }
    } catch (e) {
      return const WaiterLogInState(
          data: null, errorMessage: 'Failed to log you in');
    }
  }

  Future<WaiterLogInConfirmationState> confirmLogInWaiter(
      String email, String pin) async {
    final path = '$waiterEndpoint$confirmEndpoint';
    final Object body = json.encode({'email': email, 'pin': pin});
    final Map<String, String> headers = {'Content-type': 'application/json'};

    final url = getUrl(path: path);

    try {
      final res = await http.post(url, body: body, headers: headers);

      if (res.statusCode == 200) {
        if (res.headers['authorization'] == null) {
          return const WaiterLogInConfirmationState(
              data: null, errorMessage: "Bad response from the server");
        }

        final accessToken = res.headers['authorization']!.split(' ')[1];

        const storage = FlutterSecureStorage();
        await storage.write(
          key: accessTokenKeyName,
          value: accessToken,
        );

        return WaiterLogInConfirmationState(
            data: accessToken, errorMessage: null);
      } else {
        final errorMessage = _decodeError(res);

        return WaiterLogInConfirmationState(
            data: null, errorMessage: errorMessage);
      }
    } catch (e) {
      return const WaiterLogInConfirmationState(
          data: null, errorMessage: 'Failed to confirm your logging in');
    }
  }

  Future<WaiterLogOutState> logOutWaiter(String accessToken) async {
    final path = '$waiterEndpoint$logOutEndpoint';
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': "Bearer $accessToken",
    };

    final url = getUrl(path: path);

    try {
      final res = await http.post(url, headers: headers);

      if (res.statusCode == 200) {
        final resJson = json.decode(res.body);
        final String message = resJson['message'];

        return WaiterLogOutState(data: message, errorMessage: null);
      } else {
        final errorMessage = _decodeError(res);

        return WaiterLogOutState(data: null, errorMessage: errorMessage);
      }
    } catch (e) {
      return const WaiterLogOutState(
          data: null, errorMessage: 'Failed to log you out');
    }
  }

  Future<WaiterSessionState> renewWaiterSession(String accessToken) async {
    final path = '$waiterEndpoint$renewEndpoint';
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': "Bearer $accessToken",
    };

    final url = getUrl(path: path);

    try {
      final res = await http.post(url, headers: headers);

      if (res.statusCode == 200) {
        if (res.headers['authorization'] == null) {
          return const WaiterSessionState(
            data: null,
            errorMessage: "Bad response from the server",
            sessionMessage: null,
          );
        }

        final accessToken = res.headers['authorization']!.split(' ')[1];

        const storage = FlutterSecureStorage();
        await storage.write(
          key: accessTokenKeyName,
          value: accessToken,
        );

        return WaiterSessionState(
          data: accessToken,
          errorMessage: null,
          sessionMessage: null,
        );
      } else if (res.statusCode >= 400 && res.statusCode < 500) {
        final resJson = json.decode(res.body);
        final String sessionMessage = resJson['message'];

        return WaiterSessionState(
          data: null,
          errorMessage: null,
          sessionMessage: sessionMessage,
        );
      } else {
        final errorMessage = _decodeError(res);

        return WaiterSessionState(
          data: null,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      return const WaiterSessionState(
        data: null,
        errorMessage: 'Failed renew your session',
        sessionMessage: null,
      );
    }
  }
}
