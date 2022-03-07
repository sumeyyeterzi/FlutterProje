import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proje/Sayfalar/YemekSayfasi.dart';
import 'package:proje/Sayfalar/YemekSepet.dart';
import 'package:proje/main.dart';

//* Sepete Veri ekleme yeri
Future<void> sepeteEkle(String yemekID) async {
  var ref = FirebaseFirestore.instance
      .collection('Sepet')
      .where("KullaniciID", isEqualTo: kullaniciID)
      .where("YemekID", isEqualTo: yemekID);

  ref.get().then((value) {
    if (value.docs.length == 0) {
      FirebaseFirestore.instance
          .collection('Sepet')
          .add({
            'KullaniciID': kullaniciID,
            'YemekID': yemekID,
            'Adet': 1,
          })
          .then((value) => print("Yemek eklendi"))
          .catchError((error) => print("Yemek eklenemedi"));
    } else {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Sepet")
            .doc(element.id)
            .update({'Adet': element["Adet"] + 1})
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      });
    }
  });
}

Future<void> sepetAdetDegistir(String yemekID, int sayi) async {
  FirebaseFirestore.instance
      .collection('Sepet')
      .where("KullaniciID", isEqualTo: kullaniciID)
      .where("YemekID", isEqualTo: yemekID)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      if (element["Adet"] == 1 && sayi == -1) {
        FirebaseFirestore.instance
            .collection("Sepet")
            .doc(element.id)
            .delete()
            .then((value) => print("silme başarılı kocum"))
            .catchError((error) => print("silemedik kral : $error"));
      } else {
        FirebaseFirestore.instance
            .collection("Sepet")
            .doc(element.id)
            .update({'Adet': element["Adet"] + sayi})
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    });
  });
}

Future<void> sepettenSil(String yemekID) async {
  FirebaseFirestore.instance
      .collection('Sepet')
      .where("KullaniciID", isEqualTo: kullaniciID)
      .where("YemekID", isEqualTo: yemekID)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("Sepet")
          .doc(element.id)
          .delete()
          .then((value) => print("Silme başarılı"))
          .catchError((error) => print("silinemedi  : $error"));
    });
  });
}

//* Sepeteki veri göster
Widget sepetiGoster() {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Sepet')
          .where("KullaniciID", isEqualTo: kullaniciID)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: snapshot.data.docs.map((veri) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Yemek')
                    .doc(veri["YemekID"])
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data.data();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CartItem(
                        productName: data['ad'],
                        productPrice:
                            data['fiyat'] + " X " + veri["Adet"].toString(),
                        productImage: data["gorsel"],
                        yemekID: veri["YemekID"],
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }).toList());
      });
}

Widget kategoriler() {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Yemek')
          .where("populer", isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data.docs.map((veri) {
              return Yemek(
                name: veri.data()["ad"],
                imageUrl: veri.data()["gorsel"],
                numberOfRating: veri.data()["oylayan"],
                price: veri.data()["fiyat"],
                rating: veri.data()["puan"],
                slug: veri.data()["ad"],
                yemekUID: veri.id,
              );
            }).toList());
      });
}
