import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proje/animation/ScaleRoute.dart';
import 'package:proje/Sayfalar/DetaySayfasi.dart';

class KategorilerSayfasi extends StatefulWidget {
  final String kategorim;

  const KategorilerSayfasi({Key key, this.kategorim}) : super(key: key);

  @override
  _KategorilerSayfasiState createState() => _KategorilerSayfasiState();
}

class _KategorilerSayfasiState extends State<KategorilerSayfasi> {
  kategoriCek() {
    return FirebaseFirestore.instance
        .collection('Yemek')
        .where("kategori", isEqualTo: widget.kategorim)
        .snapshots();
  }

  String kategoriAdi = " ";
  kategoriAdiCek() {
    FirebaseFirestore.instance
        .collection('Kategori')
        .doc(widget.kategorim)
        .get()
        .then((DocumentSnapshot veri) {
      print(veri.data()["ad"]);
      setState(() {
        kategoriAdi = veri.data()["ad"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    kategoriAdiCek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          kategoriAdi,
          style: TextStyle(color: Colors.deepOrange, fontSize: 25),
        ),
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
      body: StreamBuilder(
          stream: kategoriCek(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.count(
                crossAxisCount: 2,
                children: snapshot.data.docs.map((veri) {
                  
                  return Item(
                    name: veri.data()["ad"],
                    imageUrl: veri.data()["gorsel"],
                    price: veri.data()["fiyat"],
                    numberOfRating: veri.data()["oylayan"],
                    rating: veri.data()["puan"],
                    yemekUID: veri.id,
                  );
                }).toList());
          }),
    );
  }
}

class Item extends StatelessWidget {
  final String price;
  final String numberOfRating;
  final String rating;
  final String name;
  final String imageUrl;
  final String yemekUID;

  const Item(
      {Key key,
      this.price,
      this.numberOfRating,
      this.rating,
      this.name,
      this.imageUrl,
      this.yemekUID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            ScaleRoute(
                page: DetaySayfasi(
              secilenYemek: yemekUID,
            )));
      },
      child: Column(
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
              child: Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Container(
                    width: 170,
                    height: 210,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                alignment: Alignment.topRight,
                                width: double.infinity,
                                padding: EdgeInsets.only(right: 5, top: 5),
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white70,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFfae3e2),
                                          blurRadius: 25.0,
                                          offset: Offset(0.0, 0.75),
                                        ),
                                      ]),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Color(0xFFfb3132),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Center(
                                  child: Image.asset(
                                'assets/images/' + imageUrl + ".png",
                                width: 130,
                                height: 130,
                              )),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(left: 5, top: 5),
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.only(right: 5),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white70,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFfae3e2),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                                child: Icon(
                                  Icons.near_me,
                                  color: Color(0xFFfb3132),
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(rating,
                                      style: TextStyle(
                                          color: Color(0xFF6e6e71),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 3, left: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFF9b9b9c),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                    numberOfRating,
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  EdgeInsets.only(left: 5, top: 5, right: 5),
                              child: Text(
                                price + '\ ₺',
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
