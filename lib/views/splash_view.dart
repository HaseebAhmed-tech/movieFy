import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moviely/controller/tmdb_controller.dart';
import 'package:moviely/model/details.dart';
import 'package:moviely/model/movie.dart';
import 'package:moviely/utils/utils.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late TMDBController _tmdbController;
  @override
  initState() {
    _tmdbController = Provider.of<TMDBController>(context, listen: false);
    Utils.checkInternetConnectivity().then((value) {
      if (value) {
        debugPrint('Internet Connected');

        _tmdbController.getUpcomingMovies(context);
      } else {
        debugPrint('No Internet');
        Hive.openBox<Movie>('movies').then((movies) {
          Hive.openBox<Details>('details').then((details) {
            _tmdbController.getDataFromHive(movies, context, details);
          });
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // _tmdbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, con) {
          return splashBody(con);
        },
      ),
    );
  }

  Center splashBody(BoxConstraints con) {
    return Center(
      child: Image.asset(
        'assets/images/splash_image.png',
        width: con.maxWidth * 0.45,
        height: con.maxHeight * 0.45,
        fit: BoxFit.contain,
      ),
    );
  }
}
