import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data,
      };
}

Future<Map<String, dynamic>> addProduct({
  required String name,
  required String description,
  required String price,
  required File imageFile,
}) async {
  var uri =
      Uri.parse('https://zygotic-marys-herfa-c2dd67a8.koyeb.app/products');
  var request = http.MultipartRequest('POST', uri);

  // Add string fields
  request.fields['name'] = name;
  request.fields['description'] = description;
  request.fields['price'] = price;
  // Add image file
  request.files.add(
    await http.MultipartFile.fromPath(
      'image', // The key expected by your API
      imageFile.path,
      filename: basename(imageFile.path),
    ),
  );

  // Send request
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  // Return the response body as a Map
  return jsonDecode(response.body);
}

void main() async {
  File imageFile =
      File('path/to/your/image.jpg'); // Replace with actual image path
  var response = await addProduct(
    name: 'Product Name',
    description: 'Product Description',
    price: '100',
    imageFile: imageFile,
  );

  print('API Response: $response');
}
