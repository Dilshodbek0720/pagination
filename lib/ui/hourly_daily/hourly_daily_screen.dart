import 'package:flutter/material.dart';
import 'package:n8_default_project/data/models/detail/one_call_data.dart';
import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:n8_default_project/data/network/api_provider.dart';

class HourlyDailyScreen extends StatefulWidget {
  const HourlyDailyScreen({Key? key}) : super(key: key);

  @override
  State<HourlyDailyScreen> createState() => _HourlyDailyScreenState();
}

class _HourlyDailyScreenState extends State<HourlyDailyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hourly Daily screen"),
      ),
      body: FutureBuilder<UniversalData>(
        future: ApiProvider.getWeatherOneCallData(
          lat: 41.93467,
          long: 69.535645,
        ),
        builder: (BuildContext context, AsyncSnapshot<UniversalData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.error.isEmpty) {
              OneCallData oneCallData = snapshot.data!.data as OneCallData;
              return Center(
                child: Text(oneCallData.timezone),
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
