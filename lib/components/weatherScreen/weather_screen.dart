import 'package:cs492_weather_app/models/weather_forecast.dart';
import '../../models/user_location.dart';
import 'package:flutter/material.dart';
import '../location/location.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WeatherScreen extends StatefulWidget {
  final Function getLocation;
  final Function getForecasts;
  final Function getForecastsHourly;
  final Function setLocation;

  const WeatherScreen(
      {super.key,
      required this.getLocation,
      required this.getForecasts,
      required this.getForecastsHourly,
      required this.setLocation});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return (widget.getLocation() != null && widget.getForecasts().isNotEmpty
        ? ForecastWidget(
            context: context,
            location: widget.getLocation(),
            forecasts: widget.getForecastsHourly())
        : LocationWidget(widget: widget));
  }
}

class ForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> forecasts;
  final BuildContext context;

  const ForecastWidget(
      {super.key,
      required this.context,
      required this.location,
      required this.forecasts});

@override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      LocationTextWidget(location: location),
      CarouselSlider(
        items: [Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TemperatureWidget(forecasts: forecasts),
                DescriptionWidget(forecasts: forecasts),
              ],
            ),
          ),
        ),FutureForecastWidget(forecasts: forecasts)],
        options: CarouselOptions(
          height: 600
        ),
            ),
    ],
  );
}

        
    
  
}


class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    Map<String, String> forecastImages = {
    'Sunny': 'assets/images/sunny.png',
    'Rain': 'assets/images/rain.png',
    'Snow': 'assets/images/snow.png',
    'Cloudy': 'assets/images/cloudy.png',
    'Unknown': 'assets/images/unknown.png',
  };

  String shortForecast = forecasts.elementAt(0).shortForecast;

    String imagePath = forecastImages.entries.firstWhere(
    (entry) => shortForecast.toLowerCase().contains(entry.key.toLowerCase()),
    orElse: () => MapEntry('Unknown', 'assets/images/unknown.png'),
  ).value;

    return SizedBox(
      height: 200,
      width: 500,
      child: Image.asset(
          imagePath
            ),
    );
  }
}

class TemperatureWidget extends StatelessWidget {
  const TemperatureWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

@override
Widget build(BuildContext context) {
  return Center(
    child: FractionallySizedBox(
      widthFactor: 0.75,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Center(
          child: Text(
            '${forecasts.elementAt(0).temperature}+',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'hand',
            ),
          ),
        ),
      ),
    ),
  );
}
}

class LocationTextWidget extends StatelessWidget {
  const LocationTextWidget({
    super.key,
    required this.location,
  });

  final UserLocation location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: 500,
        child: FittedBox(
                  fit: BoxFit.cover,
          child: Center(
            child: Text("${location.city}, ${location.state}, ${location.zip}",
                            style: TextStyle(
                fontFamily: 'hand',
              )
            ),
          ),
        ),
      ),
    );
  }
}

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.widget,
  });

  final WeatherScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Requires a location to begin"),
          ),
          Location(
              setLocation: widget.setLocation,
              getLocation: widget.getLocation),
        ],
      ),
    );
  }
}

class FutureForecastWidget extends StatelessWidget {
  const FutureForecastWidget({
    Key? key,
    required this.forecasts,
  }) : super(key: key);

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Next 4 hours",
          style: TextStyle(
            fontFamily: 'hand',
            fontSize: 18, // Adjust the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Column(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _getImagePath(forecasts[index].shortForecast),
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${forecasts[index].temperature}+',
                    style: TextStyle(
                      fontFamily: 'hand',
                      fontSize: 64,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getImagePath(String shortForecast) {
    Map<String, String> forecastImages = {
      'Sunny': 'assets/images/sunny.png',
      'Rain': 'assets/images/rain.png',
      'Snow': 'assets/images/snow.png',
      'Cloudy': 'assets/images/cloudy.png',
      'Unknown': 'assets/images/unknown.png',
    };

    return forecastImages.entries.firstWhere(
      (entry) => shortForecast.toLowerCase().contains(entry.key.toLowerCase()),
      orElse: () => MapEntry('Unknown', 'assets/images/unknown.png'),
    ).value;
  }
}