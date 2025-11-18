import 'package:flutter/material.dart';
import 'package:uniconnect/helpers/routes.dart';

void main() {
  runApp(const UniConnect());
}

class UniConnect extends StatelessWidget {
  const UniConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniConnect',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      initialRoute: "/",
      routes: routes,
    );
  }
}
