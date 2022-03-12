import 'package:flutter/material.dart';
import 'package:galla_todo/screens/splashScreen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
void main() => runApp(GetMaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType)
    {
      return MaterialApp(
        title: 'Galla TODO',
        theme: ThemeData(
          fontFamily: 'Prompt',
          primaryColor:Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
      );
    });
  }
}
