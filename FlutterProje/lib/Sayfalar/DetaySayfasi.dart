import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proje/animation/ScaleRoute.dart';
import 'package:proje/Sayfalar/YemekSepet.dart';
import 'package:proje/veritabani/veriler.dart';

class DetaySayfasi extends StatefulWidget {
  final String secilenYemek;

  const DetaySayfasi({Key key, this.secilenYemek}) : super(key: key);
  @override
  _DetaySayfasiState createState() => _DetaySayfasiState();
}

class _DetaySayfasiState extends State<DetaySayfasi> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFFFAFAFA),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.deepOrange,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            brightness: Brightness.light,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.business_center,
                    color: Colors.deepOrange,
                  ),
                  onPressed: () {
                    Navigator.push(context, ScaleRoute(page: Sepet()));
                  })
            ],
          ),
          body: SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Yemek')
                  .doc(widget.secilenYemek)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return Detay(
                    name: data['ad'],
                    imageUrl: data["gorsel"],
                    price: data["fiyat"],
                    numberOfRating: data["oylayan"],
                    rating: data["puan"],
                    detayaciklamasi: data["detay"],
                    incelemeler: data["inceleme"],
                    restaurant: data["restaurant"],
                    id: widget.secilenYemek,
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ));
  }
}

class Detay extends StatelessWidget {
  final String price;
  final String numberOfRating;
  final String rating;
  final String name;
  final String imageUrl;
  final String restaurant;
  final String detayaciklamasi;
  final String incelemeler;
  final String id;

  const Detay(
      {Key key,
      this.price,
      this.numberOfRating,
      this.rating,
      this.name,
      this.imageUrl,
      this.restaurant,
      this.detayaciklamasi,
      this.incelemeler,
      this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.asset(
              'assets/images/' + imageUrl + ".png",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            elevation: 1,
            margin: EdgeInsets.all(5),
          ),
          FoodTitleWidget(
              productName: name,
              productPrice: price + '\ ₺',
              productHost: restaurant),
          SizedBox(
            height: 15,
          ),
          SepeteEkle(
            sepeticin: id,
          ),
          SizedBox(
            height: 15,
          ),
          PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              labelColor: Colors.deepOrange,
              indicatorColor: Colors.deepOrange,
              unselectedLabelColor: Colors.deepOrange,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  text: 'Yemek Detayları',
                ),
                Tab(
                  text: 'Yemek Malzemeleri',
                ),
              ], // list of tabs
            ),
          ),
          Container(
            height: 150,
            child: TabBarView(
              children: [
                Container(
                  color: Colors.white24,
                  child: Container(
                    child: Text(
                      detayaciklamasi,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          height: 1.50),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white24,
                  child: Container(
                    child: Text(
                      incelemeler,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          height: 1.50),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ), // class name
              ],
            ),
          ),
          BilgiEkrani(),
        ],
      ),
    );
  }
}

class FoodTitleWidget extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productHost;

  FoodTitleWidget({
    Key key,
    @required this.productName,
    @required this.productPrice,
    @required this.productHost,
  }) : super(key: key);

  @override
  _FoodTitleWidgetState createState() => _FoodTitleWidgetState();
}

class _FoodTitleWidgetState extends State<FoodTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.productName,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              widget.productPrice,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Text(
              "restoran",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFa9a9a9),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              widget.productHost,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1f1f1f),
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}

class BilgiEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                Icons.timeline_outlined,
                color: Color(0xFF404aff),
                size: 35,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "12:00-3.00",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFa9a9a9),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_bike,
                color: Color(0xFF23c58a),
                size: 35,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "3.5 km",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFa9a9a9),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.map_rounded,
                color: Color(0xFFff0654),
                size: 35,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Harita",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFa9a9a9),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.bike_scooter,
                color: Color(0xFFe95959),
                size: 35,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Teslimat",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFa9a9a9),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SepeteEkle extends StatefulWidget {
  final String sepeticin;

  const SepeteEkle({Key key, this.sepeticin}) : super(key: key);

  @override
  _SepeteEkleState createState() => _SepeteEkleState();
}

class _SepeteEkleState extends State<SepeteEkle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              sepeteEkle(widget.sepeticin);
            },
            child: Container(
              width: 200.0,
              height: 45.0,
              decoration: new BoxDecoration(
                color: Colors.deepOrange,
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  'Sepete Ekle',
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
