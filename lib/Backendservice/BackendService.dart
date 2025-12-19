import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

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

  static Future<Map<String, dynamic>> function(
    Map<String, dynamic> data,
    String url,
    String method,
  ) async {
    print("━━━━━━━━━━ API REQUEST ━━━━━━━━━━");
    print("METHOD : $method");
    print("URL    : $url");
    print("IP     : ${Uri.parse(url).host}");
    print("BODY   : ${jsonEncode(data)}");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    final response = await Dio().request(
      url,
      data: data,
      options: Options(
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dynamic jsonData = response.data;

    if (jsonData is String) {
      // This handles unexpected raw JSON string responses
      try {
        jsonData = json.decode(jsonData);
      } catch (e) {
        throw Exception("Invalid JSON response");
      }
    }

    if (jsonData is Map<String, dynamic>) {
      return jsonData;
    } else {
      throw Exception("Unexpected response format");
    }
  }
}
