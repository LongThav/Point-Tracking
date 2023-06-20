import 'dart:convert' as json;
import 'dart:io';

import 'api_exceptions.dart';
import 'package:http/http.dart' as http;

class NetworkApiService {
  Future<http.Response> getApiResponse(String url, {Map<String, String>? headers}) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      return response;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  Future<http.Response> postApiResponse(String url, Object data, {Map<String, String>? headers}) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        body: data,
        headers: headers,
      );
      return response;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  Future<http.Response> putApiResponse(String url, Object data, {Map<String, String>? headers}) async {
    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        body: data,
        headers: headers,
      );
      return response;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  Future deleteApiResponse(String url, Object data, {Map<String, String>? headers}) async {
    try {
      final http.Response response = await http.delete(Uri.parse(url), body: data, headers: headers);
      return response;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = json.jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException('Error occurred while communicating with server with status code ${response.statusCode.toString()}``');
    }
  }
}
