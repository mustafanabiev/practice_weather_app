import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/views/additional_information.dart';
import 'package:weather_app/views/current_weather.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherApiClient client = WeatherApiClient();
  Weather? data;
  String? textInput = 'Osh';

  Future<void> getData() async {
    data = await client.getCurrentWeather("$textInput");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf9f9f9),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
            color: Colors.black,
          ),
          elevation: 0.0,
          backgroundColor: Color(0xFFf9f9f9),
          centerTitle: true,
          title: const Text(
            'Weather App',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentWeather(Icons.wb_sunny_rounded, '${data!.temp}',
                          '${data!.cityName}'),
                      const SizedBox(
                        height: 60.0,
                      ),
                      const Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xdd212121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      additionalInformation(
                          '${data!.wind}',
                          '${data!.humidity}',
                          '${data!.pressure}',
                          '${data!.feels_like}'),
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            ),
            Container(
              width: 300.0,
              child: TextField(
                onSubmitted: (text) {
                  setState(() {
                    textInput = text;
                  });
                  text = '';
                  print('Кийирилген сан: $text');
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Шаардын атын кийириниз ...',
                ),
              ),
            )
          ],
        ));
  }
}
