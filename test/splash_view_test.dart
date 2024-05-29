import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviely/controller/tmdb_controller.dart';
import 'package:moviely/model/details.dart';
import 'package:moviely/model/movie.dart';
import 'package:moviely/utils/utils.dart';
import 'package:moviely/views/splash_view.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Adjust the import according to your project structure

class MockTMDBController extends Mock implements TMDBController {}

class MockBox<T> extends Mock implements Box<T> {}

class MockUtils extends Mock implements Utils {}

void main() {
  late MockTMDBController mockTMDBController;

  setUp(() {
    mockTMDBController = MockTMDBController();

    when(Utils.checkInternetConnectivity()).thenAnswer((_) async => true);
  });

  Widget createSplashView() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TMDBController>.value(value: mockTMDBController),
      ],
      child: const MaterialApp(
        home: SplashView(),
      ),
    );
  }

  testWidgets(
      'SplashView shows splash image and calls getUpcomingMovies on internet connection',
      (WidgetTester tester) async {
    await tester.pumpWidget(createSplashView());

    // Verify the splash image is shown
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);

    // Verify getUpcomingMovies is called
    verify(mockTMDBController
            .getUpcomingMovies(tester.element(find.byType(SplashView))))
        .called(1);
  });

  testWidgets('SplashView reads from Hive when no internet connection',
      (WidgetTester tester) async {
    // Set up Utils to return false for internet connectivity
    when(Utils.checkInternetConnectivity()).thenAnswer((_) async => false);

    await tester.pumpWidget(createSplashView());

    // Verify Hive boxes are opened and getDataFromHive is called
    await tester.pump(); // Allow async tasks to complete
    verify(Hive.openBox<Movie>('movies')).called(1);
    verify(Hive.openBox<Details>('details')).called(1);
    verify(mockTMDBController.getDataFromHive).called(1);
  });
}
