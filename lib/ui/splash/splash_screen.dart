import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:n8_default_project/data/models/main/lat_lon.dart';
import 'package:n8_default_project/ui/weather_info/weather_info_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LatLong? latLong;

  Future<void> _getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      latLong = LatLong(
        lat: _locationData.latitude!,
        long: _locationData.longitude!,
      );
    });
  }

  _init() async {
    await _getLocation();

    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return WeatherInfoScreen(
          latLong: latLong!,
        );
      }));
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Splash Screen:${latLong?.long}  and ${latLong?.lat}  "),
      ),
    );
  }
}
