import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proje/Sayfalar/Anasayfa.dart';
import 'package:proje/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserCredential user;

// ! Giriş Fonksiyonu AUTH

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(
              context, "Giriş Başarısız", "Girdiğiniz email geçersiz.", false),
        );
      } else if (e.code == "wrong-password") {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context,
              "Giriş Başarısız", "Şifre yanlış. Tekrar deneyin", false),
        );
      }

      print('Failed with error code: ${e.code}');
      print(e.message);
    }

    if (user != null) {
      //* Sürekli giriş yapmayı engellemek adına uid telefonun hafızasına kaydediyorum
      SharedPreferences veri = await SharedPreferences.getInstance();
      veri.setString("kulllaniciID", user.user.uid);
      await _firestore
          .collection('Kullanici')
          .doc(user.user.uid)
          .get()
          .then((value) {
        veri.setString("kulllaniciAd", value.data()["ad"]);
        veri.setString("kulllaniciSoyad", value.data()["soyad"]);
        veri.setString("kulllaniciEmail", value.data()["email"]);
        kullaniciAdi = value.data()["ad"];
        kullaniciSoyadi = value.data()["soyad"];
        kullaniciEmail = value.data()["email"];
        kullaniciID = user.user.uid;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context, "Giriş başarılı", "Ana Menüye gitmek için kapatın", true),
      );
    }
  }

// ! Kayit Fonksiyonu AUTH
  Future<void> kayitOlustur(String ad, String soyad, String email,
      String password, BuildContext context) async {
    try {
      //*Authentication veri ekleme
      user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //*Cloud Firestore veri ekleme
      await _firestore
          .collection("Kullanici")
          .doc(user.user.uid)
          .set({'ad': ad, 'soyad': soyad, 'email': email});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(
              context, "Kayıt Başarısız", "Şifreniz Güçsüz", false),
        );
      } else if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(
              context, "Kayıt Başarısız", "Bu email kullanılmaktadır", false),
        );
      }
    } catch (e) {
      print(e);
    }
    if (user != null) {
      //* Sürekli giriş yapmayı engellemek adına uid telefonun hafızasına kaydediyorum
      SharedPreferences veri = await SharedPreferences.getInstance();
      veri.setString("kulllaniciID", user.user.uid);
      veri.setString("kulllaniciAd", ad);
      veri.setString("kulllaniciSoyad", soyad);
      veri.setString("kulllaniciEmail", email);

      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context, "Kayıt başarılı", "Ana Menüye gitmek için kapatın", true),
      );
    }
  }
}

Widget _buildPopupDialog(
    BuildContext context, String baslik, String mesaj, bool yonlendirme) {
  return new AlertDialog(
    title: Text(baslik),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(mesaj),
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          if (yonlendirme) {
            return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else
            Navigator.of(context).pop();
        },
        child: const Text('Kapat'),
      ),
    ],
  );
}
