import 'package:flutter/material.dart';

class BestFoodWidget extends StatefulWidget {
  @override
  _BestFoodWidgetState createState() => _BestFoodWidgetState();
}

class _BestFoodWidgetState extends State<BestFoodWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          BestFoodTitle(),
          Expanded(
            child: BestFoodList(),
          )
        ],
      ),
    );
  }
}

class BestFoodTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "En İyiler",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class BestFoodTiles extends StatelessWidget {
  final String imageUrl;

  const BestFoodTiles({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/images/' + imageUrl + ".jpeg",
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 1,
              margin: EdgeInsets.all(5),
            ),
          ),
        ],
      ),
    );
  }
}

class BestFoodList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        BestFoodTiles(
          imageUrl: "ic_best_food_8",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_9",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_10",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_5",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_1",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_2",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_3",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_4",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_5",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_6",
        ),
        BestFoodTiles(
          imageUrl: "ic_best_food_7",
        ),
      ],
    );
  }
}
