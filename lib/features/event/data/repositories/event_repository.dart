import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import '../models/event_model.dart';
import 'package:Herfa/exceptions.dart';
import '../models/return_event.dart';

class EventRepository {
  final Dio _dio;
  final AuthSharedPrefLocalDataSource _authDataSource;
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  EventRepository({
    required Dio dio,
    required AuthSharedPrefLocalDataSource authDataSource,
  })  : _dio = dio,
        _authDataSource = authDataSource;

  Future<String> uploadImage(File imageFile) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) {
        throw UnauthorizedException('No authentication token found.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      String fileName = imageFile.path.split('/').last;

      print('Attempting image upload with file: $fileName');
      print('File size: ${await imageFile.length()} bytes');

      // Try multiple possible upload endpoints
      List<String> uploadEndpoints = [
        '$_baseUrl/upload',
        '$_baseUrl/events/upload',
        '$_baseUrl/media/upload',
        '$_baseUrl/files/upload',
      ];

      DioException? lastException;

      for (String endpoint in uploadEndpoints) {
        try {
          print('Trying upload endpoint: $endpoint');

          // Create fresh FormData for each attempt to avoid "already finalized" error
          FormData freshFormData = FormData.fromMap({
            "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
          });

          final response = await _dio.post(endpoint, data: freshFormData);
          print('Upload successful with endpoint: $endpoint');
          print('Upload response: ${response.data}');

          // Handle different possible response structures
          if (response.data is Map<String, dynamic>) {
            final responseMap = response.data as Map<String, dynamic>;

            // Try different possible field names for the image URL
            if (responseMap.containsKey('imageUrl')) {
              return responseMap['imageUrl'] as String;
            } else if (responseMap.containsKey('url')) {
              return responseMap['url'] as String;
            } else if (responseMap.containsKey('media')) {
              return responseMap['media'] as String;
            } else if (responseMap.containsKey('data') && responseMap['data'] is Map) {
              final dataMap = responseMap['data'] as Map<String, dynamic>;
              if (dataMap.containsKey('url')) {
                return dataMap['url'] as String;
              } else if (dataMap.containsKey('imageUrl')) {
                return dataMap['imageUrl'] as String;
              }
            }
          }

          // If we get here, the response structure is unexpected
          throw Exception('Upload successful but response format is unexpected: ${response.data}');

        } on DioException catch (e) {
          print('Upload failed for endpoint $endpoint:');
          print('  Status code: ${e.response?.statusCode}');
          print('  Response data: ${e.response?.data}');
          lastException = e;

          // If it's not a 403/404, don't try other endpoints
          if (e.response?.statusCode != 403 && e.response?.statusCode != 404) {
            break;
          }
          continue;
        }
      }

      // If all endpoints failed, throw the last exception
      if (lastException != null) {
        print('All upload endpoints failed. Last error:');
        print('  Status code: ${lastException.response?.statusCode}');
        print('  Response data: ${lastException.response?.data}');

        if (lastException.response?.statusCode == 401) {
          throw UnauthorizedException('Unauthorized: Invalid or expired token.');
        } else if (lastException.response?.statusCode == 403) {
          throw Exception('Failed to upload image: Access forbidden. Please check your permissions.');
        } else if (lastException.response?.statusCode == 413) {
          throw Exception('Failed to upload image: File too large.');
        } else {
          throw Exception('Failed to upload image: ${lastException.message ?? 'Unknown error'}');
        }
      }

      throw Exception('Failed to upload image: All upload endpoints failed');

    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      print('General exception during image upload: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<List<Data>> getEvents() async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) {
        throw UnauthorizedException('No authentication token found.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      print('Making request to: $_baseUrl/events');
      final response = await _dio.get('$_baseUrl/events');

      print('Response status code: ${response.statusCode}');
      print('Response data type: ${response.data.runtimeType}');
      print('Response data: ${response.data}');

      // Handle different possible response structures
      if (response.data == null) {
        throw Exception('Failed to load events: API returned null response.');
      }

      List<dynamic> eventJson;

      // Check if response.data is directly a List
      if (response.data is List<dynamic>) {
        eventJson = response.data as List<dynamic>;
        print('Response is directly a list with ${eventJson.length} items');
      }
      // Check if response.data is a Map with a 'data' key
      else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        print('Response is a map with keys: ${responseMap.keys.toList()}');

        if (responseMap.containsKey('data') && responseMap['data'] is List<dynamic>) {
          eventJson = responseMap['data'] as List<dynamic>;
          print('Found data array with ${eventJson.length} items');
        } else if (responseMap.containsKey('events') && responseMap['events'] is List<dynamic>) {
          eventJson = responseMap['events'] as List<dynamic>;
          print('Found events array with ${eventJson.length} items');
        } else {
          throw Exception(
              "Failed to load events: Invalid API response format. Expected 'data' or 'events' array but got keys: ${responseMap.keys.toList()}");
        }
      } else {
        throw Exception(
            "Failed to load events: Unexpected response format. Expected List or Map but got ${response.data.runtimeType}");
      }

      // Parse each event with error handling
      List<Data> events = [];
      for (int i = 0; i < eventJson.length; i++) {
        try {
          final eventData = eventJson[i];
          if (eventData is Map<String, dynamic>) {
            events.add(Data.fromJson(eventData));
          } else {
            print('Warning: Event at index $i is not a valid Map: $eventData');
          }
        } catch (e) {
          print('Error parsing event at index $i: $e');
          print('Event data: ${eventJson[i]}');
          // Continue with other events instead of failing completely
        }
      }

      print('Successfully parsed ${events.length} events');
      return events;

    } on DioException catch (e) {
      print('DioException in getEvents:');
      print('  Status code: ${e.response?.statusCode}');
      print('  Response data: ${e.response?.data}');
      print('  Error type: ${e.type}');
      print('  Error message: ${e.message}');

      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid or expired token.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Failed to load events: Events endpoint not found (404).');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Failed to load events: Server error (500). Please try again later.');
      } else {
        throw Exception('Failed to load events: ${e.message ?? 'Network error'}');
      }
    } catch (e) {
      print('General exception in getEvents: $e');
      throw Exception('Failed to load events: $e');
    }
  }

  Future<Data> createEvent(EventModel event, File imageFile) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) {
        throw UnauthorizedException('No authentication token found.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      print('Starting event creation process...');

      String? imageUrl;

      // Try to upload image first
      try {
        print('1. Attempting to upload image...');
        imageUrl = await uploadImage(imageFile);
        print('2. Image uploaded successfully: $imageUrl');
      } catch (e) {
        print('Image upload failed: $e');
        print('Proceeding with event creation using multipart form...');

        // Fallback: Create event with image in multipart form
        return await _createEventWithMultipartForm(event, imageFile, token);
      }

      // Create event with uploaded image URL
      final eventWithImageUrl = event.copyWith(imageUrl: imageUrl);
      final eventData = eventWithImageUrl.toJson();

      print('3. Creating event with data: $eventData');

      final response = await _dio.post('$_baseUrl/events', data: eventData);

      print('4. Event creation response status: ${response.statusCode}');
      print('5. Event creation response data: ${response.data}');

      return _parseEventResponse(response);

    } on UnauthorizedException {
      rethrow;
    } on DioException catch (e) {
      print('DioException during event creation:');
      print('  Status code: ${e.response?.statusCode}');
      print('  Response data: ${e.response?.data}');
      print('  Error type: ${e.type}');
      print('  Error message: ${e.message}');

      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid or expired token.');
      } else if (e.response?.statusCode == 400) {
        String errorMessage = 'Invalid event data';
        if (e.response?.data is Map<String, dynamic>) {
          final responseMap = e.response!.data as Map<String, dynamic>;
          if (responseMap.containsKey('message')) {
            errorMessage = responseMap['message'];
          } else if (responseMap.containsKey('error')) {
            errorMessage = responseMap['error'];
          }
        }
        throw Exception('Failed to create event: $errorMessage');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Failed to create event: Validation error. Please check your input data.');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Failed to create event: Server error. Please try again later.');
      } else {
        throw Exception('Failed to create event: ${e.message ?? 'Network error'}');
      }
    } catch (e) {
      print('General exception during event creation: $e');
      throw Exception('Failed to create event: $e');
    }
  }

  // Helper method to create event with multipart form (includes image)
  Future<Data> _createEventWithMultipartForm(EventModel event, File imageFile, String token) async {
    try {
      print('Creating event with multipart form...');

      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'name': event.title,
        'description': event.description,
        'startTime': event.startDate.toIso8601String(),
        'endTime': event.endDate.toIso8601String(),
        'price': event.price.toString(),
        'file': await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      print('Multipart form data prepared');
      final response = await _dio.post('$_baseUrl/events', data: formData);

      print('Multipart event creation response status: ${response.statusCode}');
      print('Multipart event creation response data: ${response.data}');

      return _parseEventResponse(response);

    } catch (e) {
      print('Multipart form creation failed: $e');
      rethrow;
    }
  }

  // Helper method to parse event creation response
  Data _parseEventResponse(Response response) {
    // Handle different possible response structures
    if (response.data == null) {
      throw Exception('Failed to create event: API returned null response.');
    }

    if (response.data is Map<String, dynamic>) {
      final responseMap = response.data as Map<String, dynamic>;

      // Check for success field
      if (responseMap.containsKey('success') && responseMap['success'] == false) {
        final message = responseMap['message'] ?? 'Unknown error';
        throw Exception('Failed to create event: $message');
      }

      // Try to find the event data in the response
      if (responseMap.containsKey('data') && responseMap['data'] is Map<String, dynamic>) {
        return Data.fromJson(responseMap['data'] as Map<String, dynamic>);
      } else if (responseMap.containsKey('event') && responseMap['event'] is Map<String, dynamic>) {
        return Data.fromJson(responseMap['event'] as Map<String, dynamic>);
      } else {
        // If the response itself is the event data
        try {
          return Data.fromJson(responseMap);
        } catch (e) {
          print('Failed to parse response as event data: $e');
          throw Exception('Failed to create event: Unexpected response format');
        }
      }
    } else {
      throw Exception('Failed to create event: Unexpected response format - expected Map but got ${response.data.runtimeType}');
    }
  }

  Future<Data> updateEvent(EventModel event) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) {
        throw UnauthorizedException('No authentication token found.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response =
          await _dio.put('$_baseUrl/events/${event.id}', data: event.toJson());
      return Data.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid or expired token.');
      } else {
        throw Exception('Failed to update event: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) {
        throw UnauthorizedException('No authentication token found.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      await _dio.delete('$_baseUrl/events/$eventId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid or expired token.');
      } else {
        throw Exception('Failed to delete event: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
