import 'package:flutter_dotenv/flutter_dotenv.dart';

// Application essentials
final env = dotenv.env['ENV']!;

// URLs and its essential parts
final protocol = dotenv.env['HTTP_PROTOCOL']!;
final userAppApiUrl = dotenv.env['USER_APP_API_URL']!;
final userWebAppUrl = dotenv.env['USER_WEB_APP_URL']!;

// URL path names
final restaurantsEndpoint = dotenv.env['RESTAURANTS_ENDPOINT']!;
final newdDeviceIdEndpoint = dotenv.env['NEW_DEVICE_ID_ENDPOINT']!;
final menuEndpoint = dotenv.env['MENU_ENDPOINT']!;
final waiterEndpoint = dotenv.env['WAITER_ENDPOINT']!;
final logInEndpoint = dotenv.env['LOG_IN_ENDPOINT']!;
final confirmEndpoint = dotenv.env['CONFIRM_ENDPOINT']!;
final logOutEndpoint = dotenv.env['LOG_OUT_ENDPOINT']!;
final sessionEndpoint = dotenv.env['SESSION_ENDPOINT']!;

// URL query names
final rangeQueryName = dotenv.env['RANGE_QUERY_NAME']!;
final userLongitudeQueryName = dotenv.env['USER_LONGITUDE_QUERY_NAME']!;
final userLatitudeQueryName = dotenv.env['USER_LATITUDE_QUERY_NAME']!;

// URL parameter names
final restaurantIdParamName = dotenv.env['RESTAURANT_ID_PARAM_NAME']!;
final itemIdParamName = dotenv.env['MENU_ITEM_ID_PARAM_NAME']!;

// Storage and preferences variables
final searchRangeKeyName = dotenv.env['USER_SEARCH_RANGE_KEY_NAME']!;
final accessTokenKeyName = dotenv.env['ACCESS_TOKEN_KEY_NAME']!;
final deviceIdKeyName = dotenv.env['DEVICE_ID_KEY_NAME']!;
final waiterNameKeyName = dotenv.env['WAITER_NAME_KEY_NAME']!;
final waiterEmailKeyName = dotenv.env['WAITER_EMAIL_KEY_NAME']!;
