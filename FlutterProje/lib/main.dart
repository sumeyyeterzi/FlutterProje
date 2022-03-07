import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proje/Sayfalar/Anasayfa.dart';
import 'package:proje/Sayfalar/Giris.dart';
import 'package:shared_preferences/shared_preferences.dart';

String kullaniciID;
String kullaniciAdi;
String kullaniciSoyadi;
String kullaniciEmail;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences veri = await SharedPreferences.getInstance();
  kullaniciID = veri.getString("kulllaniciID");
  kullaniciAdi = veri.getString("kulllaniciAd");
  kullaniciSoyadi = veri.getString("kulllaniciSoyad");
  kullaniciEmail = veri.getString("kulllaniciEmail");
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
              nextScreen: kullaniciID == null ? GirisSayfasi() : HomePage(),
              splashTransition: SplashTransition.rotationTransition,
              backgroundColor: Colors.white,
              splash: Image.asset(
                "assets/images/lg.png",
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
