import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class UrlScheme {
  UrlScheme();

  static void email(String email) async {
    await launch("mailto:$email");
  }

  static void navigate(double latitude, double longitude) {
    //waze
    canLaunch("waze://");
    launch("waze://?ll=$latitude,$longitude&navigate=yes");
    //gmaps
    canLaunch("comgooglemaps://");
    launch(
        "comgooglemaps://?saddr=$latitude,$longitude&directionsmode=driving");
  }

  static void makePhoneCall(String phoneNumber) async {
    String uri = "tel:$phoneNumber";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  /// Returns a URL that can be launched on the current platform
  /// to open a maps application showing the result of a search query.
  static String createQueryUrl(String query) {
    var uri;

    if (Platform.isAndroid) {
      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      uri = Uri.https('maps.apple.com', '/', {'q': query});
    } else {
      uri = Uri.https(
          'www.google.com', '/maps/search', {'api': '1', 'query': query});
    }

    return uri.toString();
  }

  /// Returns a URL that can be launched on the current platform
  /// to open a maps application showing coordinates ([latitude] and [longitude]).
  static String createCoordinatesUrl(double latitude, double longitude,
      [String? label]) {
    var uri;

    if (Platform.isAndroid) {
      var query = '$latitude,$longitude';

      query += '($label)';

      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      var params = {'ll': '$latitude,$longitude'};

      params['q'] = label!;

      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      uri = Uri.https('www.google.com', '/maps/search',
          {'api': '1', 'query': '$latitude,$longitude'});
    }

    return uri.toString();
  }

  /// Launches the maps application for this platform.
  /// The maps application will show the result of the provided search [query].
  /// Returns a Future that resolves to true if the maps application
  /// was launched successfully, false otherwise.
  static Future<bool> launchQuery(String query) {
    return launch(createQueryUrl(query));
  }

  /// Launches the maps application for this platform.
  /// The maps application will show the specified coordinates.
  /// Returns a Future that resolves to true if the maps application
  /// was launched successfully, false otherwise.
  static Future<bool> launchCoordinates(double latitude, double longitude,
      [String? label]) {
    return launch(createCoordinatesUrl(latitude, longitude, label));
  }
}
