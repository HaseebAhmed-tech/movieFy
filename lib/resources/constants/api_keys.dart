import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String apiKey = dotenv.env['API_KEY'] ?? 'API_KEY not found';
  static String apiReadAccessToken =
      dotenv.env['API_READ_ACCESS_TOKEN'] ?? 'API_READ_ACCESS_TOKEN not found';
}
