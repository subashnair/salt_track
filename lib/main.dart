// @dart=2.9
import 'package:flutter/material.dart';
import 'package:salt_track/pages/home.dart';
import 'package:salt_track/pages/login.dart';
import 'package:salt_track/pages/track_trace.dart';
//import 'package:world_time/pages/tracker.dart';

void main()=> runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context)=> LoginScreen(),
    '/home': (context)=> Home(),
    '/login': (context)=> LoginScreen(),
    '/tracker': (context)=> Tracker()
  },
));
