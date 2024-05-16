abstract class BaseApiService {
  Future<Map<String, dynamic>> getUpcomingMovies(
    String path,
  );
  Future<Map<String, dynamic>> getMoviesGnere(
    String path,
  );
  Future<Map<String, dynamic>?> getMovieDetails(
    String path,
  );
}
