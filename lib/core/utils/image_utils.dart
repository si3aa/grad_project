import 'dart:io';
import 'package:flutter/material.dart';

String buildImageUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  const String baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/';
  if (path.startsWith('http')) return path;
  if (path.startsWith('/')) {
    return baseUrl + path.substring(1);
  }
  return baseUrl + path;
}

ImageProvider? getAppImageProvider({File? file, String? url}) {
  if (file != null) {
    return FileImage(file);
  }
  if (url != null && url.isNotEmpty) {
    if (url.startsWith('http')) {
      return NetworkImage(url);
    } else if (url.startsWith('/')) {
      return NetworkImage(buildImageUrl(url));
    }
  }
  return null;
} 