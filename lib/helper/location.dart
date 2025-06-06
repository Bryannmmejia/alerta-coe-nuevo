import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position?> fetchLocation(BuildContext context) async {
  var permissionResult = await Permission.locationWhenInUse.status;

  if (permissionResult == PermissionStatus.denied) {
    permissionResult = await Permission.locationWhenInUse.request();
  }

  if (permissionResult == PermissionStatus.restricted ||
      permissionResult == PermissionStatus.permanentlyDenied) {
    _showLocationDeniedDialog(context);
    return null;
  }

  if (permissionResult == PermissionStatus.granted ||
      permissionResult == PermissionStatus.limited) {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      return position;
    } catch (e) {
      debugPrint("Error getting location: $e");
      return null;
    }
  }

  return null;
}

void _showLocationDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Location is disabled :(',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Enable!'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue[900],
              elevation: 1,
            ),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
