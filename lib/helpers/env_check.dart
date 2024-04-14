import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void checkEnv() {
  const requiredEnvVars = [
    'ENV',
    'HTTP_PROTOCOL',
    'USER_APP_API_URL',
    'RESTAURANTS_ENDPOINTS_ROOT',
    'USER_LATITUDE_QUERY_NAME',
    'USER_LONGITUDE_QUERY_NAME',
    'RANGE_QUERY_NAME',
    'NEW_DEVICE_ID_ENDPOINT',
    'USER_SEARCH_RANGE_KEY_NAME',
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
