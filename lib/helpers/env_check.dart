import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void checkEnv() {
  const requiredEnvVars = [
    'ENV',
    'HTTP_PROTOCOL',
    'USER_APP_API_URL',
    'RESTAURANTS_ENDPOINT',
    'USER_LATITUDE_QUERY_NAME',
    'USER_LONGITUDE_QUERY_NAME',
    'RANGE_QUERY_NAME',
    'NEW_DEVICE_ID_ENDPOINT',
    'USER_SEARCH_RANGE_KEY_NAME',
    'MENU_ENDPOINT',
    'WAITER_ENDPOINT',
    'LOG_IN_ENDPOINT',
    'CONFIRM_ENDPOINT',
    'LOG_OUT_ENDPOINT',
    'ACCESS_TOKEN_KEY_NAME',
    'SESSION_ENDPOINT',
    'USER_WEB_APP_URL',
    'RESTAURANT_ID_PARAM_NAME',
    'MENU_ITEM_ID_PARAM_NAME',
    'DEVICE_ID_KEY_NAME',
    'WAITER_NAME_KEY_NAME',
    'WAITER_EMAIL_KEY_NAME',
    'INTERACTED_KEY_NAME',
    'TABLE_HASH_PARAM_NAME',
    'TABLE_ENDPOINT',
  ];

  // Check for missing environment variables
  var missingEnvVars =
      requiredEnvVars.where((varName) => dotenv.env[varName] == null).toList();

  // If there are missing environment variables, terminate the program
  if (missingEnvVars.isNotEmpty) {
    print(
        'Error: Missing required environment variables: ${missingEnvVars.join(', ')}');
    exit(1); // Exit with a non-zero exit code to indicate an error
  }
}
