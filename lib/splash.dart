import 'package:flutter/material.dart';
import 'package:phantomsolutions/home_page.dart';
import 'package:phantomsolutions/services/location_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> initalizeSetup() async {
    var controller = LocationController();
    return Future.wait([
      controller.initializeHive(),
      controller.downloadLocations(),
    ]).then((value) => controller.storeLocations());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initalizeSetup(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          return const Home();
        }
        if (snapshot.hasError) {
          return SelectableText(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
