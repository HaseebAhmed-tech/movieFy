import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviely/controller/bottom_nav_provider.dart';
import 'package:moviely/controller/searched_list_provider.dart';
import 'package:moviely/controller/tab_bar_provider.dart';
import 'package:moviely/controller/tmdb_controller.dart';
import 'package:moviely/model/movie.dart';
import 'package:moviely/resources/widgets/text_form_field.dart';
import 'package:moviely/views/details.view.dart';
import 'package:moviely/views/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

class MockTMDBController extends Mock implements TMDBController {}

void main() {
  group('HomeView Widget Tests', () {
    late MockTMDBController mockTMDBController;
    late List<Movie> movies;

    setUp(() {
      mockTMDBController = MockTMDBController();
      movies = [
        const Movie(
          id: "1",
          title: 'Movie 1',
          imageUrl: 'https://example.com/image1.jpg',
          releaseDate: '2020-18-4',
          rating: '25',
          popularity: 10,
        ),
        const Movie(
            id: "2",
            title: 'Movie 2',
            imageUrl: 'https://example.com/image2.jpg',
            releaseDate: '2024-21-18',
            popularity: 15,
            rating: '20'),
        // Add more mock movies as needed
      ];
    });

    Widget createWidgetUnderTest() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
          ChangeNotifierProvider(create: (_) => SearchedListProvider()),
          ChangeNotifierProvider(create: (_) => TabBarProvider()),
          Provider<TMDBController>(create: (_) => mockTMDBController),
        ],
        child: MaterialApp(
          home: HomeView(movies: movies),
        ),
      );
    }

    testWidgets('HomeView renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('What do you want to watch?'), findsOneWidget);
      expect(find.byType(MyTextFormField), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNWidgets(movies.length));
    });

    testWidgets('Search functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final searchField = find.byType(MyTextFormField);
      await tester.enterText(searchField, 'Movie 1');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      final searchResults = Provider.of<SearchedListProvider>(
              tester.element(find.byType(HomeView)),
              listen: false)
          .searched;
      expect(searchResults, isNotEmpty);
      expect(searchResults.first?.title, 'Movie 1');
    });

    testWidgets('Navigates to DetailsView on movie tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final movieItem = find.byType(InkWell).first;
      await tester.tap(movieItem);
      await tester.pumpAndSettle();

      expect(find.byType(DetailsView), findsOneWidget);
    });

    testWidgets('RefreshIndicator works', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(RefreshIndicator), findsOneWidget);

      await tester.drag(find.byType(HomeView), const Offset(0, 300));
      await tester.pumpAndSettle();

      verify(mockTMDBController
              .getUpcomingMovies(tester.element(find.byType(HomeView))))
          .called(1);
    });
  });
}
