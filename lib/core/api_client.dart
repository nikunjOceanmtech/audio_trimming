// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:audio/core/api_constants.dart';
import 'package:audio/core/unathorised_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  ApiClient(this._client);

  dynamic get(String path, {Map<dynamic, dynamic>? params, Map<String, String>? header}) async {
    final response = await _client.get(
      getPath(path, params),
      headers: header ?? ApiConstatnts().headers,
    );
    if (kDebugMode) {
      print("Get call: ${getPath(path, params)}");
    }

    if (response.statusCode == 200) {
      try {
        if (json.decode(response.body)['status'] == 401) {
          throw UnauthorisedException();
        }
      } on UnauthorisedException {
        throw UnauthorisedException();
      }

      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic post(String path, {Map<dynamic, dynamic>? params, Map<String, String>? header}) async {
    final response = await _client.post(
      getPath(path, null),
      body: jsonEncode(params),
      headers: path == '/login'
          ? {'Content-Type': 'application/json', "Accept": 'application/json'}
          : ApiConstatnts().headers,
    );
    if (kDebugMode) {
      print("Post call: ${getPath(path, null)}");
      print("Post call: ${jsonEncode(params)}");
    }
    if (response.statusCode == 200) {
      try {
        if (json.decode(response.body)['status'] == 401) {
          throw UnauthorisedException();
        }
      } on UnauthorisedException {
        throw UnauthorisedException();
      }
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic directPost({required String url, required Map<dynamic, dynamic> params, Map<String, String>? header}) async {
    final response = await _client.post(
      Uri.parse(url),
      body: jsonEncode(params),
      headers: header ?? {'Content-Type': 'application/json', "Accept": 'application/json'},
    );
    if (kDebugMode) {
      print("Direct Post call: $url");
      // print("Direct Post call: ${jsonEncode(params)}");
    }
    if (response.statusCode == 200) {
      try {
        if (json.decode(response.body)['status'] == 401) {
          throw UnauthorisedException();
        }
      } on UnauthorisedException {
        throw UnauthorisedException();
      }
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Uri getPath(String path, Map<dynamic, dynamic>? params) {
    var paramsString = ((params?.isNotEmpty ?? false) && !path.contains("?")) ? '?' : '';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        if (paramsString.contains("=")) {
          paramsString += '&$key=$value';
        } else {
          paramsString += '$key=$value';
        }
      });
    }

    if (kReleaseMode) {
      return Uri.parse('${ApiConstatnts.liveBaseUrl}$path$paramsString');
    }
    return Uri.parse('${ApiConstatnts.baseUrl}$path$paramsString');
  }

  Uri getDirectPath({required String url, Map<dynamic, dynamic>? params}) {
    var paramsString = '?';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        if (paramsString.contains("=")) {
          paramsString += '&$key=$value';
        } else {
          paramsString += '$key=$value';
        }
      });
    }

    if (kReleaseMode) {
      return Uri.parse('$url$paramsString');
    }
    return Uri.parse('$url$paramsString');
  }
}
