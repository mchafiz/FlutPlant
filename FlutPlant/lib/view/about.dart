import 'package:flutter/material.dart';

class aboutPage extends StatefulWidget {
  aboutPage({Key key}) : super(key: key);

  @override
  _aboutPageState createState() => new _aboutPageState();
}

class _aboutPageState extends State<aboutPage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.green,
          title: new Text("About"),
        ),
        body: new Container(
          height: 800,

            child: Align(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, ),
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('img/hafiz.jpg'),
                          )
                      )
                      ),
                  SizedBox(height: 20,),
               
                  new Text("Muhammad Chaerul Hafiz",style: TextStyle(color: Colors.blue),
                      textScaleFactor: 1.5),
                        new Text("54416758",style: TextStyle(color: Colors.blue),
                      textScaleFactor: 1.5),
                      new Text("Universitas Gunadarma",style: TextStyle(color: Colors.blue),
                      textScaleFactor: 1.5),
                     
                      SizedBox(height: 20.0,),
                      new Text("Contact me ", textScaleFactor: 1.5, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                      new Text("mchaerulhafiz@gmail.com",style: TextStyle(color: Colors.blue),
                      textScaleFactor: 1.5),
                      Divider(height: 150,color: Colors.transparent,),
                      new Text("Version 1.0", style: TextStyle(color: Colors.red),
                      textScaleFactor: 1.5),
                      

                ],
              ),
            ))
    )
    ;
  }
}