import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviely/controller/searched_list_provider.dart';
import 'package:moviely/controller/tmdb_controller.dart';
import 'package:moviely/model/movie.dart';
import 'package:moviely/resources/widgets/minor_detail_cover.dart';
import 'package:moviely/resources/widgets/text_form_field.dart';
import 'package:moviely/views/home/search_view.dart';
import 'package:provider/provider.dart';

// Mock classes
class MockTMDBController extends Mock implements TMDBController {}

class MockSearchedListProvider extends Mock implements SearchedListProvider {}

void main() {
  late MockTMDBController mockTMDBController;
  late MockSearchedListProvider mockSearchedListProvider;
  late List<Movie> mockMovies;

  setUp(() {
    mockTMDBController = MockTMDBController();
    mockSearchedListProvider = MockSearchedListProvider();
    mockMovies = [
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

    // Setting up the mock behavior
    when(mockSearchedListProvider.searchQuery).thenReturn('');
    when(mockSearchedListProvider.searched).thenReturn(mockMovies);
    when(mockTMDBController.getMovieDetails(any, any))
        .thenAnswer((_) async => null);
  });

  Widget createSearchView() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TMDBController>.value(value: mockTMDBController),
        ChangeNotifierProvider<SearchedListProvider>.value(
            value: mockSearchedListProvider),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SearchView(movies: mockMovies),
        ),
      ),
    );
  }

  testWidgets('SearchView displays movies and handles search input',
      (WidgetTester tester) async {
    await tester.pumpWidget(createSearchView());

    // Verify initial state
    expect(find.byType(MyTextFormField), findsOneWidget);
    expect(find.byType(MinorDetailCover), findsNWidgets(mockMovies.length));

    // Enter search text
    await tester.enterText(find.byType(MyTextFormField), 'Movie 1');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Verify search result
    verify(mockSearchedListProvider.setSearchQuery('Movie 1', [])).called(1);

    // Updating mock behavior for new search query
    when(mockSearchedListProvider.searched).thenReturn([mockMovies.first]);
    mockSearchedListProvider.setSearchQuery('Movie 1', [mockMovies.first]);
    await tester.pump();

    // Verify filtered search result
    expect(find.byType(MinorDetailCover), findsOneWidget);
    expect(find.text('Movie 1'), findsOneWidget);
  });
}
