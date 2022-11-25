import 'package:flutter/material.dart';

class WeatherDetails extends StatelessWidget {
  final String? imageName;
  final String? value;
  final String? level;
  const WeatherDetails({
    Key? key, this.imageName, this.level, this.value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/$imageName.png"),
        Text(
          "$value",
          style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),
        ),
        Text(
          "$level",
          style: TextStyle(
              color: Color(0xffC8C5F4),
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}