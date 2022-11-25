import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app08/Providers/weather_provider.dart';
import 'package:weather_app08/Utils/constants.dart';
import 'package:weather_app08/Utils/weather_preference.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const String routeName = 'settingsPage';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isTempUnitSwitchedOn = false;
  bool is24HourFormat = false;
  bool isDefaultCity = false;

  @override
  void initState() {
    getBool(tempUnitKey).then((value) {
      setState(() {
        isTempUnitSwitchedOn=value;
      });
    });
    getBool(timeFormatKey).then((value) {
      setState(() {
        is24HourFormat=value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
              value: isTempUnitSwitchedOn,
              onChanged: (value) async{
                setState(() {
                  isTempUnitSwitchedOn = value;
                });
                await setBool(tempUnitKey, value);
                Provider.of<WeatherProvider>(context,listen: false).setTempUnit(value);
              },
            title: const Text('Show temperature in fahrenheit',),
            subtitle: const Text('Default is Celsius'),
            activeColor: themeColor,
          ),
          SwitchListTile(
              value: is24HourFormat,
              onChanged: (value) async{
                setState(() {
                  is24HourFormat = value;
                });
                await setBool(timeFormatKey,value);
                Provider.of<WeatherProvider>(context,listen: false).setTimePattern(value);
              },
            title: const Text('Show time in 24 hour format.',),
            subtitle: const Text('Default is 12 hour.'),
            activeColor: themeColor,
          ),
          SwitchListTile(
              value: isDefaultCity,
              onChanged: (value) {
                setState(() {
                  isDefaultCity = value;
                });
              },
            title: const Text('Set Current city as Default.',),
            subtitle: const Text('Your location will no longer be detected. Data will be shown on default city location.'),
            activeColor: themeColor,
          ),

        ],
      ),
    );
  }
}
