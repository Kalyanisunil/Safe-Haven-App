import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safehaven/geofencing_service.dart';
import 'package:safehaven/home_screen.dart';
import 'package:safehaven/onboarding_screen.dart';
import 'package:safehaven/profile.dart';
// import 'package:safehaven/sendsms.dart';
import 'package:safehaven/splashscreen.dart';
import 'login_screen.dart';
import 'package:telephony_sms/telephony_sms.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

const apiKey = 'AIzaSyByojKqbGVzEnpRnU-nmvnfh6KFmbAGiaw';

void main() async {
  var tel = TelephonySMS();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tel.requestPermission();
  Gemini.init(apiKey: apiKey);
  GeofenceService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/Login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => UserProfilePage()
      },
    );
  }
}

//APP LOGO SYMBOLIZES:
//Safety and Empowerment: The woman represents strength and care, symbolizing a safe and nurturing space for our users.
// Purity and Positivity: The lotus flower, a symbol of purity, signifies the app’s intention to create an environment free from negativity.
// Growth and Transformation: Just as the lotus grows and blooms even in muddy waters, our app  symbolizes overcoming challenges and finding peace.
