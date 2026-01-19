import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class Backendservice {
  static Future<Map<String, dynamic>> UploadFiles(
      Map<String, dynamic> data, String url, String method) async {
    print("Uploading to: $url");

    var request = http.MultipartRequest(method, Uri.parse(url));

    // REQUIRED HEADER
    request.headers.addAll({
      "Accept": "application/json",
    });

    /// FIELDS AND FILES
    for (var entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      // FILE
      if (value is File) {
        if (await value.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              key,
              value.path,
              filename: value.uri.pathSegments.last,
            ),
          );
        }
        continue; // skip adding file to fields
      }

      // LIST → convert to JSON array string
      if (value is List) {
        request.fields[key] = jsonEncode(value);
      } else {
        // STRING / NUMBER
        request.fields[key] = value.toString();
      }
    }

    /// SEND REQUEST
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    /// PARSE JSON
    if (response.body.isNotEmpty) {
      try {
        final jsonData = jsonDecode(response.body);
        return {
          'success': true,
          'data': jsonData,
          'statusCode': response.statusCode,
        };
      } catch (_) {
        return {
          'success': false,
          'message': 'Invalid JSON response',
          'statusCode': response.statusCode,
        };
      }
    }

    return {
      'success': false,
      'message': 'Empty response from server',
      'statusCode': response.statusCode,
    };
  }

  static Future<Map<String, dynamic>> multipartFunction(
      Map<String, dynamic> fields, Map<String, File> files, String url) async {
    try {
      print("📤 MULTIPART REQUEST");
      print("URL: $url");
      print("Uploading multipart to: $url");

      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        "Accept": "application/json",
      });

      print("🔹 HEADERS:");
      request.headers.forEach((k, v) {
        print("  $k: $v");
      });

      // Fields
      print("🔹 FIELDS:");
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
        print("  $key = $value");
      });

      // Files
      print("🔹 FILES:");

      // Add normal fields
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add files
      for (var entry in files.entries) {
        final key = entry.key;
        final file = entry.value;

        if (await file.exists()) {
          String extension = file.path.split('.').last.toLowerCase();

          MediaType mediaType;

          if (extension == 'mp4') {
            mediaType = MediaType('video', 'mp4');
          } else if (extension == 'mov') {
            mediaType = MediaType('video', 'quicktime');
          } else if (extension == 'avi') {
            mediaType = MediaType('video', 'x-msvideo');
          } else if (extension == 'wmv') {
            mediaType = MediaType('video', 'x-ms-wmv');
          } else {
            mediaType = MediaType('application', 'octet-stream');
          }

          print("  $key:");
          print("    path      : ${file.path}");
          print("    mimeType  : ${mediaType.type}/${mediaType.subtype}");
          print(
              "    size (KB) : ${(file.lengthSync() / 1024).toStringAsFixed(2)}");

          request.files.add(
            await http.MultipartFile.fromPath(
              key,
              file.path,
              filename: file.path.split('/').last,
              contentType: mediaType, // ✅ THIS FIXES IT
            ),
          );
        }
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.body.isNotEmpty) {
        try {
          final jsonData = jsonDecode(response.body);

          if (response.statusCode >= 200 && response.statusCode < 300) {
            return {
              'status': true,
              'data': jsonData,
              'statusCode': response.statusCode,
            };
          } else {
            return {
              'status': false,
              'message': jsonData['message'] ?? 'Upload failed',
              'errors': jsonData['errors'],
              'statusCode': response.statusCode,
            };
          }
        } catch (e) {
          return {
            'status': false,
            'message': 'Invalid JSON response',
            'statusCode': response.statusCode,
          };
        }
      }

      return {
        'status': false,
        'message': 'Empty response from server',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      print("Multipart Upload Error: $e");
      return {
        'status': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> function(
      Map<String, dynamic> data, String url, String method) async {
    print("━━━━━━━━━━ API REQUEST ━━━━━━━━━━");
    print("METHOD : $method");
    print("URL    : $url");
    print("IP     : ${Uri.parse(url).host}");
    print("BODY   : ${jsonEncode(data)}");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    try {
      final response = await Dio().request(
        url,
        queryParameters: method.toUpperCase() == 'GET' ? data : null,
        data: method.toUpperCase() != 'GET' ? data : null,
        options: Options(
          method: method,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json', // ensure server returns JSON
          },
        ),
      );

      dynamic jsonData = response.data;

      if (jsonData is String) {
        try {
          jsonData = json.decode(jsonData);
        } catch (e) {
          print("❌ Invalid JSON response: $jsonData");
          return {
            "status": false,
            "message": "Invalid JSON response from server",
            "raw": jsonData,
          };
        }
      }

      if (jsonData is Map<String, dynamic>) {
        return jsonData;
      } else {
        print("❌ Unexpected response format: $jsonData");
        return {
          "status": false,
          "message": "Unexpected response format",
          "raw": jsonData,
        };
      }
    } catch (e) {
      print("❌ API REQUEST ERROR: $e");
      return {
        "status": false,
        "message": e.toString(),
      };
    }
  }
}
