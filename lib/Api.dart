import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = 'https://expensetracker.twileloop.com';

  static Future<void> get(String endpoint, Function onSuccess, Function onFailure) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      _handleResponse(response, onSuccess, onFailure);
    } catch (error) {
      onFailure(error.toString());
    }
  }

  static Future<void> post(String endpoint, Map<String, dynamic> data, Function onSuccess, Function onFailure) async {
    try {
      print('Making POST request to: $baseUrl$endpoint');
      print('Request body: ${jsonEncode(data)}');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      _handleResponse(response, onSuccess, onFailure);
    } catch (error) {
      onFailure(error.toString());
    }
  }

  static Future<void> put(String endpoint, Map<String, dynamic> data, Function onSuccess, Function onFailure) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      _handleResponse(response, onSuccess, onFailure);
    } catch (error) {
      onFailure(error.toString());
    }
  }

  static Future<void> patch(String endpoint, Map<String, dynamic> data, Function onSuccess, Function onFailure) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      _handleResponse(response, onSuccess, onFailure);
    } catch (error) {
      onFailure(error.toString());
    }
  }

  static Future<void> delete(String endpoint, Function onSuccess, Function onFailure) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
      _handleResponse(response, onSuccess, onFailure);
    } catch (error) {
      onFailure(error.toString());
    }
  }

  static void _handleResponse(http.Response response, Function onSuccess, Function onFailure) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      onSuccess(jsonDecode(response.body));
    } else {
      onFailure('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
