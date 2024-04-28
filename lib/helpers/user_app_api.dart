import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:restazo_user_mobile/helpers/get_current_location.dart';
import 'package:restazo_user_mobile/models/api_result_states/call_waiter_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/order_id_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/table_session_state.dart';
import 'package:restazo_user_mobile/models/call_waiter.dart';
import 'package:restazo_user_mobile/models/order_id.dart';
import 'package:restazo_user_mobile/models/order_menu_item.dart';
import 'package:restazo_user_mobile/models/table_session.dart';
import 'package:restazo_user_mobile/screens/table_actions/table_actions.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restazo_user_mobile/models/waiter_session.dart';
import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/models/api_result_states/waiter_session_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/waiter_log_out_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/device_id_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/waiter_log_in_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/menu_item_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/restaurant_overview_state.dart';
import 'package:restazo_user_mobile/models/api_result_states/restaurants_near_you_state.dart';
import 'package:restazo_user_mobile/models/menu_item.dart';
import 'package:restazo_user_mobile/models/device_id.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/models/restaurant_overview.dart';

// Class to interact with user API, all the functions to call an API must
// be defined here

class APIService {
  // Get all the needed environment variables

  Future<DeviceIdState> getDeviceId() async {
    final url = getUrl(path: "/$newdDeviceIdEndpoint");

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
    final baseUrlParsed = Uri.parse(userAppApiUrl);

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
    final url =
        getUrl(queryParameters: queryParameters, path: "/$restaurantsEndpoint");

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
      path: "/$restaurantsEndpoint/$id",
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
          data: restaurantOverviewData,
          errorMessage: null,
          initialRestaurantData: null,
        );
      } else {
        // Decode an error if response code is not 200
        final errorMessage = _decodeError(res);

        // Return the state of restaurant menu
        // with an error message and no menu data
        return RestaurantOverviewState(
          data: null,
          errorMessage: errorMessage,
          initialRestaurantData: null,
        );
      }
    } catch (e) {
      // Return the state of restaurant menu
      // with an error message and no menu data
      return const RestaurantOverviewState(
        data: null,
        errorMessage: 'Failed to fetch restaurant info',
        initialRestaurantData: null,
      );
    }
  }

  Future<MenuItemState> loadMenuItemById(
      String restaurantId, String itemId) async {
    final path = '/$restaurantsEndpoint/$restaurantId/$menuEndpoint/$itemId';

    final url = getUrl(path: path);

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final resJson = json.decode(res.body);
        final Map<String, dynamic> menuItemDataJson = resJson['data'];

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
    final path = '/$waiterEndpoint/$logInEndpoint';
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

  Future<WaiterSessionState> confirmLogInWaiter(
      String email, String pin) async {
    final path = '/$waiterEndpoint/$confirmEndpoint';
    final Object body = json.encode({'email': email, 'pin': pin});
    final Map<String, String> headers = {'Content-type': 'application/json'};

    final url = getUrl(path: path);

    try {
      final res = await http.post(url, body: body, headers: headers);

      if (res.statusCode == 200) {
        if (res.headers['authorization'] == null) {
          return const WaiterSessionState(
            data: null,
            errorMessage: "Bad response from the server",
            sessionMessage: null,
          );
        }
        final resJson = json.decode(res.body);
        final Map<String, dynamic> data = resJson['data'];

        final waiterSessionData = WaiterSession.fromJson(data, res.headers);

        return WaiterSessionState(
          data: waiterSessionData,
          errorMessage: null,
          sessionMessage: null,
        );
      } else {
        final errorMessage = _decodeError(res);

        return WaiterSessionState(
          data: null,
          errorMessage: errorMessage,
          sessionMessage: null,
        );
      }
    } catch (e) {
      return const WaiterSessionState(
        data: null,
        errorMessage: 'Failed to confirm your logging in',
        sessionMessage: null,
      );
    }
  }

  Future<WaiterLogOutState> logOutWaiter(String accessToken) async {
    final path = '/$waiterEndpoint/$logOutEndpoint';
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

  Future<WaiterSessionState> getWaiterSession(String accessToken) async {
    final path = '/$waiterEndpoint/$sessionEndpoint';
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': "Bearer $accessToken",
    };

    final url = getUrl(path: path);

    try {
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        if (res.headers['authorization'] == null) {
          return const WaiterSessionState(
            data: null,
            errorMessage: "Bad response from the server",
            sessionMessage: null,
          );
        }
        final resJson = json.decode(res.body);
        final Map<String, dynamic> data = resJson['data'];

        final waiterSessionData = WaiterSession.fromJson(data, res.headers);

        return WaiterSessionState(
          data: waiterSessionData,
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
          sessionMessage: null,
        );
      }
    } catch (e) {
      return const WaiterSessionState(
        data: null,
        errorMessage: 'Failed get your session',
        sessionMessage: null,
      );
    }
  }

  Future<TableSessionState> startTableSession(String tableHash) async {
    final LocationData? userLocation = await getCurrentLocation();

    if (userLocation == null) {
      return const TableSessionState(
        data: null,
        errorMessage:
            "In order to start table session you need to enable location permissions",
        sessionMessage: null,
      );
    }

    const FlutterSecureStorage storage = FlutterSecureStorage();

    final deviceId = await storage.read(key: deviceIdKeyName);

    if (deviceId == null) {
      return const TableSessionState(
        data: null,
        errorMessage: Strings.checkInternetConnectionMessage,
        sessionMessage: null,
      );
    }

    final path = '/$tableEndpoint-$sessionEndpoint/$startEndpoint';
    final Map<String, String> headers = {'Content-type': 'application/json'};
    final Object body = {
      "deviceId": deviceId,
      "tableHash": tableHash,
      "userCoords": {
        "latitude": userLocation.latitude,
        "longitude": userLocation.longitude
      }
    };

    final url = getUrl(path: path);

    try {
      final res =
          await http.post(url, headers: headers, body: json.encode(body));

      if (res.statusCode == 200) {
        if (res.headers['authorization'] == null) {
          return const TableSessionState(
            data: null,
            errorMessage: "Bad response from the server",
            sessionMessage: null,
          );
        }
        final resJson = json.decode(res.body);
        final Map<String, dynamic> data = resJson['data'];

        final waiterSessionData = TableSession.fromJson(data, res.headers);

        return TableSessionState(
          data: waiterSessionData,
          errorMessage: null,
          sessionMessage: null,
        );
      } else {
        final errorMessage = _decodeError(res);

        return TableSessionState(
          data: null,
          errorMessage: errorMessage,
          sessionMessage: null,
        );
      }
    } catch (e) {
      return const TableSessionState(
        data: null,
        errorMessage: 'Failed to start your table session',
        sessionMessage: null,
      );
    }
  }

  Future<TableSessionState> getTableSession() async {
    final LocationData? userLocation = await getCurrentLocation();

    if (userLocation == null) {
      return const TableSessionState(
        data: null,
        errorMessage:
            "In order to have table session you need to enable location permissions",
        sessionMessage: null,
      );
    }

    const storage = FlutterSecureStorage();
    final tableSessionAccessToken =
        await storage.read(key: tableSessionAccessTokenKeyName);

    if (tableSessionAccessToken == null) {
      return const TableSessionState(
        data: null,
        errorMessage: "No session found",
        sessionMessage: null,
      );
    }

    final path = '/$tableEndpoint-$sessionEndpoint';
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $tableSessionAccessToken'
    };
    final Object body = {
      "userCoords": {
        "latitude": userLocation.latitude,
        "longitude": userLocation.longitude
      }
    };

    final url = getUrl(path: path);

    try {
      final res =
          await http.post(url, headers: headers, body: json.encode(body));

      if (res.statusCode == 200) {
        final resJson = json.decode(res.body);
        final Map<String, dynamic> data = resJson['data'];

        final waiterSessionData = TableSession.fromJson(data, res.headers);

        return TableSessionState(
          data: waiterSessionData,
          errorMessage: null,
          sessionMessage: null,
        );
      } else {
        final errorMessage = _decodeError(res);

        return TableSessionState(
          data: null,
          errorMessage: errorMessage,
          sessionMessage: null,
        );
      }
    } catch (e) {
      return const TableSessionState(
        data: null,
        errorMessage: 'Failed to start your table session',
        sessionMessage: null,
      );
    }
  }

  Future<CallWaiterState> callWaiter(CallType callType) async {
    final LocationData? userLocation = await getCurrentLocation();

    if (userLocation == null) {
      return const CallWaiterState(
        data: null,
        errorMessage:
            "In order to have table session you need to enable location permissions",
      );
    }

    const storage = FlutterSecureStorage();
    final tableSessionAccessToken =
        await storage.read(key: tableSessionAccessTokenKeyName);

    if (tableSessionAccessToken == null) {
      return const CallWaiterState(
        data: null,
        errorMessage: "No session found",
      );
    }

    final path = '/$tableEndpoint-$sessionEndpoint/$callWaiterEndpoint';
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $tableSessionAccessToken'
    };
    final Object body = {
      "userCoords": {
        "latitude": userLocation.latitude,
        "longitude": userLocation.longitude
      },
      "requestType": callType.name,
    };

    final url = getUrl(path: path);

    try {
      final res =
          await http.post(url, headers: headers, body: json.encode(body));

      if (res.statusCode == 200) {
        final resJson = json.decode(res.body);

        final message = CallWaiter.fromJson(resJson);

        return CallWaiterState(
          data: message,
          errorMessage: null,
        );
      } else {
        final errorMessage = _decodeError(res);

        return CallWaiterState(
          data: null,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      return const CallWaiterState(
        data: null,
        errorMessage: 'Failed to request waiter',
      );
    }
  }

  Future<OrderIdState> placeAnOrder(List<OrderProcessingMenuItem> items) async {
    final LocationData? userLocation = await getCurrentLocation();

    if (userLocation == null) {
      return const OrderIdState(
        data: null,
        errorMessage:
            "In order to have table session you need to enable location permissions",
      );
    }
    const storage = FlutterSecureStorage();
    final [tableSessionAccessToken, deviceId] = await Future.wait([
      storage.read(key: tableSessionAccessTokenKeyName),
      storage.read(key: deviceIdKeyName)
    ]);

    if (tableSessionAccessToken == null || deviceId == null) {
      return const OrderIdState(
        data: null,
        errorMessage: "No session found",
      );
    }

    final path = '/$tableEndpoint-$sessionEndpoint/$orderEndpoint';
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $tableSessionAccessToken'
    };
    final Object body = {
      "deviceId": deviceId,
      "userCoords": {
        "latitude": userLocation.latitude,
        "longitude": userLocation.longitude
      },
      "orderItems": items.map((menuItem) {
        return {
          "id": menuItem.itemId,
          "name": menuItem.itemName,
          "quantity": menuItem.itemAmount,
        };
      }).toList(),
    };

    final url = getUrl(path: path);

    try {
      final res =
          await http.post(url, headers: headers, body: json.encode(body));

      if (res.statusCode == 200) {
        final resJson = json.decode(res.body);
        final Map<String, dynamic> data = resJson['data'];

        final message = OrderId.fromJson(data);

        return OrderIdState(
          data: message,
          errorMessage: null,
        );
      } else {
        final errorMessage = _decodeError(res);

        return OrderIdState(
          data: null,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      return const OrderIdState(
        data: null,
        errorMessage: 'Failed to place your waiter',
      );
    }
  }
}
