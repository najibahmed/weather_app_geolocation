import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app08/Pages/setting_page.dart';
import 'package:weather_app08/Utils/constants.dart';
import 'package:weather_app08/Utils/helper_functions.dart';
import 'package:weather_app08/Utils/weather_preference.dart';
import '../CustomWidgets/weather_condition.dart';
import '../Providers/weather_provider.dart';



class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WeatherProvider weatherProvider;
  bool calledOnce = true;
  @override
  void didChangeDependencies() {
    if (calledOnce) {
      weatherProvider = Provider.of<WeatherProvider>(context);
      _getData();
    }
    calledOnce = false;
    super.didChangeDependencies();
  }

  void _getData() async{
   final position = await _determinePosition();
    weatherProvider.setNewLocation(position.latitude, position.longitude);
    final tempFormatStatus = await getBool(tempUnitKey);
    final timeFormatStatus = await getBool(timeFormatKey);
    weatherProvider.setTempUnit(tempFormatStatus);
    weatherProvider.setTimePattern(timeFormatStatus);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){

          },
              icon: Icon(Icons.my_location_outlined,
              color: themeColor,)),
          IconButton(onPressed: (){
            showSearch(
                context: context,
                delegate: _CitySearchDeleget(),
            ).then((city){
              if(city != null && city.isNotEmpty){
                weatherProvider.convertAddressToLatLng(city);
              }
            });
          },
              icon: Icon(Icons.search,color: themeColor,)),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, SettingsPage.routeName);
          },
              icon: Icon(Icons.settings,color: themeColor,)),
          SizedBox(width: 10)
        ],
      ),
      body: weatherProvider.hasDataResponse? ListView(
        children: [
          _currentWeatherSection(),
          _foreCastWeatherSection()
        ],
      )
      :
      const Center(child: CircularProgressIndicator(),),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Widget _currentWeatherSection() {
    final current = weatherProvider.currentWeatherResponse;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [
                      Color(0xff594DB5),
                      Color(0xff928ACE),
                      Color(0xff594DB5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                ),
                borderRadius: BorderRadius.circular(40)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                 Text(
                   getFormattedDate(current!.dt!,pattern:'dd MMM yyyy' ),
                  style: txtNormalWhite54,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined,color:Colors.white,),
                    Text('${current.name},${current.sys!.country}',
                    style: txtAddress24
                      ),
                  ],
                ),
                GlowText('${current.main!.temp!.round()}$degree${weatherProvider.tempUnitSymbol}',
                style: TextStyle(
                  fontSize: 90,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
                ),
                Image.network('$iconPrefix${current.weather![0].icon}$iconSuffix',
                height: 80,
                width: 80,
                ),
                Text(
                  current.weather![0].description!,
                  style: txtNormalWhite54,
                ),
                Text('Feels Like ${current.main!.temp!.round()}$degree${weatherProvider.tempUnitSymbol}',
                  style: txtTempSmall18,),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Wrap(
                      children: [
                        Text('Sunrise ${getFormattedDate(current.sys!.sunrise!,pattern: weatherProvider.timePattern)}   ',
                        style: txtNormalWhite54
                          ,),
                        Text('Sunset ${getFormattedDate(current.sys!.sunset!,pattern: weatherProvider.timePattern)}',
                        style: txtNormalWhite54
                          ,)
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 122,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WeatherDetails(
                imageName: "carbon_humidity",
                value: "${current.main!.humidity}%",
                level: "Humidity",
              ),
              WeatherDetails(
                imageName: "tabler_wind",
                value: "${current.wind!.speed} m/s",
                level: "Wind",
              ),
              WeatherDetails(
                imageName: "ion_speedometer",
                value: "${current.main!.pressure} hPa",
                level: "Air Pressure",
              ),
              WeatherDetails(
                imageName: "ic_round-visibility",
                value: "${current.visibility} meter",
                level: "Visibility",
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    "Next 5 Days",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _foreCastWeatherSection() {
    final foreCastList= weatherProvider.forecastWeatherResponse!.list!;
    return Padding(
      padding: const EdgeInsets.only(top:20.0,bottom: 20),
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: foreCastList.length,
            itemBuilder: (context, index) {
            final item = foreCastList[index];
            return Container(
              width: 110,
              height: 150,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xff594DB5),
                        Color(0xff928ACE),
                        Color(0xff594DB5)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                  ),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                     Text(
                         getFormattedDate(item.dt!,pattern: 'EEE ${weatherProvider.timePattern}',),
                       style: txtNormal16,
                     ),
                  Image.network('$iconPrefix${item.weather![0].icon}$iconSuffix'),
                  Text('${item.main!.tempMax!.round()}/${item.main!.tempMin!.round()}$degree${weatherProvider.tempUnitSymbol}',
                  style: txtNormal16,
                  ),
                  Text(
                    item.weather![0].description!,
                    style: txtNormal16,
                  )
                ],
              ),
            );
            }),
      ),
    );
  }
}

class _CitySearchDeleget extends SearchDelegate<String>{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query = '';
      },

          icon: Icon(Icons.clear,color: themeColor))
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
   return IconButton(onPressed: (){
      close(context, '');
   },
       icon: Icon(Icons.arrow_back,color: themeColor));
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      tileColor: Colors.purple.shade50,
      onTap: (){
        close(context, query);
      },title: Text(query),
      leading: const Icon(Icons.search,color: themeColor,),
    );
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty ? cities
        : cities.where((city) => city.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
        itemCount:filteredList.length ,
        itemBuilder: (context, index) {
          final item = filteredList[index];
          return  ListTile(
            tileColor: Colors.purple.shade50,
            onTap: (){
              query = item;
              close(context, query);
            },title: Text(item),
          );

        },
    );
  }

}