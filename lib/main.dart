import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traveler/book_flight_page.dart';
import 'package:traveler/image_slider.dart';
import 'package:traveler/login-siginup/features/app/splash_screen/splash_screen.dart';
import 'package:traveler/login-siginup/features/user_auth/presentation/pages/login_page.dart';
import 'package:traveler/search_flight_page.dart';
import 'package:traveler/weathet_page/weather_page.dart';

import 'firebase_options.dart';
import 'login-siginup/features/user_auth/presentation/pages/home_page.dart';
import 'login-siginup/features/user_auth/presentation/pages/sign_up_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        'LoginPage()': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/search': (context) => SearchFlightPage(email: '',),
        '/bookfil': (context) => BookFlightPage(email: '',),
        '/weather': (context) => WeatherPage(),
        '/image': (context) => ImageSlider(),

        // '/home': (context) => HomePage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(
        child: LoginPage(),
      ),
    );
  }
}



