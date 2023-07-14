import 'package:flutter/material.dart';
import 'package:n8_default_project/data/models/main/lat_lon.dart';
import 'package:n8_default_project/data/models/main/weather_main_model.dart';
import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:n8_default_project/data/network/api_provider.dart';
import 'package:n8_default_project/ui/hourly_daily/hourly_daily_screen.dart';

class MainWeatherInfoScreen extends StatefulWidget {
  const MainWeatherInfoScreen({Key? key, required this.latLong}) : super(key: key);

  final LatLong latLong;

  @override
  State<MainWeatherInfoScreen> createState() => _MainWeatherInfoScreenState();
}

class _MainWeatherInfoScreenState extends State<MainWeatherInfoScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Info screen"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HourlyDailyScreen();
                }));
              },
              icon: const Icon(Icons.next_plan))
        ],
      ),
      body: FutureBuilder<UniversalData>(
        future: ApiProvider.getMainWeatherDataByLatLong(
          lat: widget.latLong.lat,
          long: widget.latLong.long,
        ),
        builder: (BuildContext context, AsyncSnapshot<UniversalData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.error.isEmpty) {
              WeatherMainModel weatherMainModel =
                  snapshot.data!.data as WeatherMainModel;
              return Center(
                child: Text(weatherMainModel.name),
              );
            }
            return Center(
              child: Text(snapshot.data!.error),
            );
          }

          return Center(
            child: Text(snapshot.error.toString()),
          );
        },
      ),
    );
  }
}
