import 'package:flutter/material.dart';
import 'package:uniconnect/helpers/routes.dart';

class TestNav extends StatelessWidget {
  const TestNav({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Navigation Menu")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            // disgusting stuff
            for (var route in routes.keys)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(route),
                  ElevatedButton(
                    onPressed: () async {
                      // ignore: avoid_print
                      print("going to $route");
                      await Navigator.pushNamed(
                        context,
                        route
                      );
                    },
                    child: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
