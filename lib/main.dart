import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:billet_faveur/screens/login_screen.dart';
import 'package:billet_faveur/navigations/root_screen.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized() ;
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billet de faveur',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0, 
            backgroundColor: primaryColor,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: secondColor,
          iconColor: primaryColor,
          prefixIconColor: primaryColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none
          )
        )

      ),
      debugShowCheckedModeBanner: false,
      home:  AnimatedSplashScreen(
            splash: Center(
              child:Container(
                width: 330,
                height: 330,
                child: Image.asset('assets/images/lg_white.png')),
            ), 
            backgroundColor: primaryColor,
            duration: 4000,
            splashIconSize: 330,
            splashTransition: SplashTransition.fadeTransition,
            nextScreen: sharedPref.getString("matUser") == null ? const LoginPage() : const RootScreen(),
            ),
      routes:{
        "login" :(context) => const LoginPage(),
        "home" :(context) => const RootScreen(),
      } ,
    );
  }
}

//Lottie.asset('assets/json/loading.json', repeat: true,reverse: true,fit:BoxFit.cover),

