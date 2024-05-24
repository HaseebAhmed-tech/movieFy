import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviely/controller/bottom_nav_provider.dart';
import 'package:moviely/controller/watch_list_provider.dart';
import 'package:moviely/model/details.dart';
import 'package:moviely/model/movie.dart';
import 'package:moviely/views/bottom_navigation_view.dart';
import 'package:provider/provider.dart';

class MockBottomNavigationProvider extends Mock
    implements BottomNavigationProvider {}

class MockWatchListProvider extends Mock implements WatchListProvider {}

void main() {
  late MockBottomNavigationProvider mockBottomNavigationProvider;
  late MockWatchListProvider mockWatchListProvider;

  setUp(() {
    mockBottomNavigationProvider = MockBottomNavigationProvider();
    mockWatchListProvider = MockWatchListProvider();
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationProvider>.value(
            value: mockBottomNavigationProvider),
        ChangeNotifierProvider<WatchListProvider>.value(
            value: mockWatchListProvider),
      ],
      child: MaterialApp(
        home: const BottomNavigationView(),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              settings = const RouteSettings(
                arguments: {
                  'movies': <Movie>[],
                  'details': <Details>[],
                },
              );
              return const BottomNavigationView();
            },
          );
        },
      ),
    );
  }

  testWidgets('BottomNavigationView displays and interacts correctly',
      (WidgetTester tester) async {
    when(mockBottomNavigationProvider.currentIndex).thenReturn(0);
    when(mockWatchListProvider.setWatchListWithHive()).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify that the BottomNavigationBar is displayed
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify that the BottomNavigationBarItems are displayed
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Watch Later'), findsOneWidget);

    // Interact with the BottomNavigationBar
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // Verify that the setIndex method is called when tapping on a BottomNavigationBarItem
    verify(mockBottomNavigationProvider.setIndex(1)).called(1);

    await tester.tap(find.text('Watch Later'));
    await tester.pumpAndSettle();

    verify(mockBottomNavigationProvider.setIndex(2)).called(1);
  });
}
