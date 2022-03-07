import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proje/main.dart';




// ! Veritabani yeni kart eklme islemi
class KartServisi {
  Future<void> kartOlustur(
    String cardNumber,
    String cardHolder,
    String cardExpiration,
  ) async {
    FirebaseFirestore.instance.collection("Kartlar").add({
      'sahibi': kullaniciID,
      'kartNo': cardNumber,
      'tarih': cardExpiration
    });
  }
}

class KartSayfasi extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ödeme Seçenekleri",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: "WorkSansBold",
            color: Colors.deepOrange[400],
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.deepOrange,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _altbaslik(),
                VeritabaniKartCek(),
                _kartEkle(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VeritabaniKartCek extends StatefulWidget {
  @override
  _VeritabaniKartCekState createState() => _VeritabaniKartCekState();
}

class _VeritabaniKartCekState extends State<VeritabaniKartCek> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Kartlar')
            .where("sahibi", isEqualTo: kullaniciID)
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
                return _kartOlustur(
                    color: Colors.redAccent,
                    cardNumber: veri.data()['kartNo'],
                    cardHolder: kullaniciID,
                    cardExpiration: veri.data()['tarih']);
              }).toList());
        });
  }
}

Widget _altbaslik() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      "Nasıl ödemek istersiniz?",
      style: TextStyle(
        fontSize: 21.0,
        fontFamily: "WorkSansBold",
        color: Colors.deepOrange,
      ),
    ),
  );
}

Widget _kartEkle(context) {
  return Container(
    margin: const EdgeInsets.only(top: 24.0),
    alignment: Alignment.center,
    child: FloatingActionButton(
      elevation: 2.0,
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => kartBilgileri(context),
        );
      },
      backgroundColor: Colors.deepOrange,
      mini: false,
      child: Icon(Icons.add),
    ),
  );
}

// ! Yeni kart oluşturmak için kullanılan popup
Widget kartBilgileri(BuildContext context) {
  final TextEditingController _kartno = TextEditingController();
  final TextEditingController _sahip = TextEditingController();
  final TextEditingController _tarih = TextEditingController();
  return AlertDialog(
    title: Text("Kart Oluştur"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _sahip,
          decoration: InputDecoration(hintText: "Adınızı Girin"),
        ),
        TextField(
          controller: _kartno,
          decoration: InputDecoration(hintText: "Kart No"),
        ),
        TextField(
          controller: _tarih,
          decoration: InputDecoration(hintText: "Kart Tarih"),
        ),
      ],
    ),
    actions: [
      TextButton(
        child: Text('Kaydet'),
        onPressed: () async {
          KartServisi().kartOlustur(_kartno.text, _sahip.text, _tarih.text);
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

Widget _kartOlustur({
  @required Color color,
  @required String cardNumber,
  @required String cardHolder,
  @required String cardExpiration,
}) {
  return Card(
    elevation: 4.0,
    color: Colors.deepOrange[400],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.0),
    ),
    child: Container(
      height: 200,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _builderLogosBlock(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "$cardNumber",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontFamily: "WorkSansBold",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailsBlock(
                label: "CARDHOLDER",
                value: cardHolder,
              ),
              _buildDetailsBlock(
                label: "VALID THRU",
                value: cardExpiration,
              )
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildDetailsBlock({@required String label, @required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$label",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          fontFamily: "WorkSansBold",
        ),
      ),
      Text(
        "$value",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: "WorkSansBold",
        ),
      ),
    ],
  );
}

Widget _builderLogosBlock() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset(
        "assets/images/contact_less.png",
        height: 20,
        width: 18,
      ),
      Image.asset(
        "assets/images/mastercard.png",
        height: 50,
        width: 50,
      ),
    ],
  );
}
