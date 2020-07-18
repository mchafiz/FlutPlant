import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'img/kategori/indoor.png',
            image_caption: 'indoor',
          ),
          Category(
            image_location: 'img/kategori/outdoor.png',
            image_caption: 'outdoor',
          ),
          Category(
            image_location: 'img/kategori/pot.png',
            image_caption: 'Aksesoris',
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;
  Category({
    this.image_location,
    this.image_caption,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 130.0,
          child: ListTile(
              title: Image.asset(
                image_location,
                width: 65.0,
                height: 65.0,
              ),
              subtitle: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  image_caption,
                  style: new TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
