import 'dart:convert';
import 'package:http/http.dart' as http;

class GetInterestedEventRepository {
  final String baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  Future<List<dynamic>> fetchInterestedEvents(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/i'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to load interested events');
    }
  }

  Future<bool> removeInterest(String eventId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$eventId/interest'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> addInterest(String eventId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events/$eventId/interest'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      // Try to return the event object if available
      if (data['event'] != null) return data['event'];
      if (data['data'] != null) return data['data'];
      return null;
    } else {
      return null;
    }
  }
}
