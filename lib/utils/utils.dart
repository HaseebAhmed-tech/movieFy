import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:moviely/model/movie.dart';
import 'package:moviely/views/home/home_view.dart';
import 'package:moviely/views/home/search_view.dart';
import 'package:moviely/views/home/watch_list_view.dart';

import '../model/details.dart';

class Utils {
  static String capitalize(String input) {
    return input
        .split(" ")
        .map((str) => str[0].toUpperCase() + str.substring(1))
        .join(" ");
  }

  static String roundStringDouble(String value, {int decimalPlaces = 2}) {
    // Parse the string to a double
    double doubleValue = double.tryParse(value) ?? 0.0;

    // Round the double to the desired number of decimal places
    double roundedValue =
        double.parse(doubleValue.toStringAsFixed(decimalPlaces));

    // Convert the rounded double back to a string
    return roundedValue.toString();
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void flushBarErrorMessage(BuildContext context, String message) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        backgroundColor: Colors.red,
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context),
    );
  }

  static int getIndex(dynamic list, String id, int targetValue) {
    return list.indexWhere((map) => map[id] == targetValue);
  }

  static List<Widget> generateViewsList(
      List<Movie> homeArguments, List<Details?>? homeDetails) {
    return <Widget>[
      HomeView(movies: homeArguments, details: homeDetails),
      SearchView(movies: homeArguments),
      WatchListView(
        details: homeDetails,
      )
    ];
  }

  static Details? getDetailsFormMovies(
      Movie movie, List<Details?>? detailsList) {
    try {
      return detailsList?.firstWhere((element) {
        return element!.id == movie.id;
      });
    } catch (e) {
      return null;
    }
  }

  static void fieldFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus();
  }

  // Example list of maps (replace with your actual data)

  static sortOnPopularity(List<Movie> arr, int left, int right) {
    if (left < right) {
      int mid = (left + right) ~/ 2;
      sortOnPopularity(arr, left, mid);
      sortOnPopularity(arr, mid + 1, right);
      merge(arr, left, mid, right);
    }
  }

  static merge(List<Movie> arr, int left, int mid, int right) {
    List<Movie> temp = [];
    int i = left;
    int j = mid + 1;

    while (i <= mid && j <= right) {
      if (arr[i].popularity <= arr[j].popularity) {
        temp.add(arr[i]);
        i++;
      } else {
        temp.add(arr[j]);
        j++;
      }
    }

    while (i <= mid) {
      temp.add(arr[i]);
      i++;
    }

    while (j <= right) {
      temp.add(arr[j]);
      j++;
    }

    for (int k = left; k <= right; k++) {
      arr[k] = temp[k - left];
    }
    temp.clear();
  }

  static Future<bool> checkInternetConnectivity() async {
    return await InternetConnection().hasInternetAccess;
  }
}
