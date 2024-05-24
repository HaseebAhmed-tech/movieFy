import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviely/data/network/base_api_service.dart';
import 'package:dio/dio.dart';
import 'package:moviely/resources/constants/api_keys.dart';

import '../../utils/utils.dart';
import '../app_exceptions.dart';

class NetworkApiService extends BaseApiService {
  final Dio _dio = Dio();
  @override
  Future<Map<String, dynamic>> getUpcomingMovies(String path) async {
    dynamic responseJson;
    try {
      debugPrint(
          'Access Token:  ${dotenv.env['MOVIES_BASE_URL'] ?? 'MOVIES_BASE_URL not found'}');
      debugPrint(
          'Access Token: ${dotenv.env['API_READ_ACCESS_TOKEN'] ?? 'API_READ_ACCESS_TOKEN not found'}');
      Options options = Options(
        headers: {'Authorization': 'Bearer ${ApiKeys.apiReadAccessToken}'},
      );
      Response response = await _dio.get(
        path,
        options: options,
      );
      responseJson = returnResponse(response);
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');
    } on (SocketException,) {
      throw FetchDataException('No Internet Connection.');
    }
    return responseJson;
  }

  @override
  Future<Map<String, dynamic>> getMoviesGnere(String path) async {
    dynamic responseJson;
    try {
      Options options = Options(
        headers: {'Authorization': 'Bearer ${ApiKeys.apiReadAccessToken}'},
      );
      Response response = await _dio.get(
        path,
        options: options,
      );
      responseJson = returnResponse(response);
    } on (SocketException,) {
      throw FetchDataException('No Internet Connection.');
    }
    return responseJson;
  }

  @override
  Future<Map<String, dynamic>?> getMovieDetails(String path) async {
    dynamic responseJson;
    try {
      Options options = Options(
        headers: {'Authorization': 'Bearer ${ApiKeys.apiReadAccessToken}'},
      );
      Response response = await _dio.get(
        path,
        options: options,
      );
      responseJson = returnResponse(response);
      debugPrint('Details: $responseJson');
    } on (SocketException,) {
      throw FetchDataException('No Internet Connection.');
    } catch (e) {
      return null;
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return responseJson;
      case 400:
        String errorString = response.data;
        String errorMessage = jsonDecode(errorString)['error'];
        throw BadRequestException(Utils.capitalize(errorMessage));
      case 404:
        throw UnauthorizedException(response.data);
      case 403:
        throw UnauthorizedException(response.data);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
