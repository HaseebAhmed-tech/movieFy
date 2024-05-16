import 'package:flutter/material.dart';
import 'package:moviely/data/network/base_api_service.dart';
import 'package:moviely/data/network/network_api_service.dart';

class TMDBRepository {
  final BaseApiService _apiService = NetworkApiService();

  TMDBRepository();

  Future<Map<String, dynamic>> getUpcomingMovies(String path) async {
    try {
      final response = await _apiService.getUpcomingMovies(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMoviesGenres(String path) async {
    try {
      final response = await _apiService.getUpcomingMovies(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getMovieDetails(String path) async {
    try {
      final response = await _apiService.getMovieDetails(path);
      debugPrint('Result $response');
      return response;
    } catch (e) {
      return null;
    }
  }
}
