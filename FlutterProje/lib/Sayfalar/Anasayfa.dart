import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proje/Sayfalar/Hesap.dart';
import 'package:proje/Sayfalar/Kartlar.dart';
import 'package:proje/Sayfalar/YemekSepet.dart';
import 'package:proje/Sayfalar/Kategori.dart';
import 'package:proje/Sayfalar/Eniyiler.dart';
import 'package:proje/Sayfalar/YemekSayfasi.dart';
import 'package:proje/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            children: <Widget>[
              _customAppBar(),
              Kategori(),
              YemekSayfasi(),
              BestFoodWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AltMenuWidget(),
    );
  }
}

Widget _customAppBar() {
  return Container(
    padding: EdgeInsets.only(left: 10, top: 3, bottom: 0),
    child: Row(
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: "Merhaba,\n",
              style: TextStyle(
                color: (Colors.black),
              ),
              children: [
                TextSpan(
                  text: "$kullaniciAdi $kullaniciSoyadi",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
              ]),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xfff5d5bf).withOpacity(.3),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Yemek ya da restoran arayınız.",
                    ),
                  ),
                ),
                Icon(Icons.search, size: 16),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Bildirim(),
        )
      ],
    ),
  );
}

class Bildirim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.deepOrange,
              ),
              onPressed: () {
                print("Bildirim işlemleri yapılacak");
              })
        ],
      ),
    );
  }
}

class AltMenuWidget extends StatefulWidget {
  @override
  _AltMenuWidgetState createState() => _AltMenuWidgetState();
}

void navigateToScreens(context, gidilicekSayfa) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => gidilicekSayfa,
    ),
  );
}

class _AltMenuWidgetState extends State<AltMenuWidget> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    Widget gidileceksayfa;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;

        if (index == 0)
          gidileceksayfa = HomePage();
        else if (index == 1)
          gidileceksayfa = Sepet();
        else if (index == 2)
          gidileceksayfa = KartSayfasi();
        else if (index == 3) gidileceksayfa = EditProfilePage();

        navigateToScreens(context, gidileceksayfa);
      });
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business_center_outlined),
          label: 'Sepet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: 'Kart',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user),
          label: 'Hesap',
        ),
      ],
      unselectedItemColor: Color(0xFF2c2b2b),
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.deepOrange[400],
      onTap: _onItemTapped,
    );
  }
}

class Kategori extends StatefulWidget {
  @override
  _KategoriState createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Kategori').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data.docs.map((veri) {
                  return TopMenuTiles(
                    name: veri.data()["ad"],
                    imageUrl: veri.data()["gorsel"],
                    kategoriID: veri.id,
                  );
                }).toList());
          }),
    );
  }
}

class TopMenuTiles extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String kategoriID;

  TopMenuTiles({
    Key key,
    @required this.name,
    @required this.imageUrl,
    @required this.kategoriID,
  }) : super(key: key);

  @override
  _TopMenuTilesState createState() => _TopMenuTilesState();
}

class _TopMenuTilesState extends State<TopMenuTiles> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => KategorilerSayfasi(
                      kategorim: widget.kategoriID,
                    )));
      },
      child: Column(
        children: <Widget>[
          Container(
            clipBehavior: Clip.none,
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 25.0,
                offset: Offset(0.0, 1.0),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Image.asset(
                    'assets/images/' + widget.imageUrl + ".png",
                    width: 24,
                    height: 24,
                  )),
                )),
          ),
          Text(
            widget.name,
            style: TextStyle(
                color: Color(0xFF6e6e71),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
