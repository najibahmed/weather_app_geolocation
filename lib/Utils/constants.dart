 import 'dart:ui';
import 'package:flutter/material.dart';

const String weatherApiKey ='147df95ac5624a2756742c7028fc7942';
 const String metric = 'metric';
 const String imperial = 'imperial';
 const String celsius = 'C';
 const String fahrenheit = 'F';
 const String degree = '\u00B0';
 const String iconPrefix = 'https://openweathermap.org/img/wn/';
 const String iconSuffix = '@2x.png';
 const Color themeColor = Color(0xff594DB5);
 const String timePattern12 = 'hh:mm a';
 const String timePattern24 = 'HH:mm';


 const txtTempBig80 = TextStyle(
  fontSize: 80,
  color: Colors.white,
 );
 const txtTempSmall18 = TextStyle(
  fontSize: 18,
  color: Colors.white,
 );
 const txtAddress24 = TextStyle(
  fontSize: 24,
  color: Colors.white,
  letterSpacing: 1.5
 );
 const txtNormal16 = TextStyle(
  fontSize: 16,
  color: Colors.white,
 );
 const txtNormalWhite54 = TextStyle(
  fontSize: 16,
  color: Colors.white54,
 );

 const cities =[
  'Athens',
  'Barishal',
  'Bangalore',
  'Berlin',
  'Capetown',
  'Dhaka',
  'Doha',
  'Dublin',
  'Dubai',
  'Faridpur',
  'Gopalgonj',
  'Hobigonj',
  'Istanbul',
  'Jakarta',
  'Jamalpur',
  'Keranigonj',
  'Kualalampur',
  'London',
  'Milan',
  'Moscow',
  'New York',
  'Oslo',
  'Paris',
  'Riadh',
  'Rome',
  'Sydney',
  'Tongi',
  "Rajshahi",
  'Chittagong',
  "Khulna",
  "Mymensingh",
  "Rajshahi",
  "Rangpur",
  "Sylhet",
  "Banaripara",
  "Charfassion",
 ];