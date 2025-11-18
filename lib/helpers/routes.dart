import 'package:flutter/material.dart' show WidgetBuilder;
import 'package:uniconnect/screens/splash.dart';
import 'package:uniconnect/screens/test_nav.dart';

final routes = <String, WidgetBuilder>{
  "/": (_) => TestNav(),
  "/splash": (_) => SplashScreen(),
};
