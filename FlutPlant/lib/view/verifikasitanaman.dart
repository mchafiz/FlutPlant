import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/KonfirmasiKeranjangModel.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VerifikasitanamanAdmin extends StatefulWidget {
  @override
  _VerifikasitanamanAdminState createState() => _VerifikasitanamanAdminState();
}

class _VerifikasitanamanAdminState extends State<VerifikasitanamanAdmin> {
  final money1 = NumberFormat("#,##0", "en_US");

  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
    _lihatDatadua();
  }

  var loading = false;
  final list1 = new List<KonfirmasiKeranjangModel>();
  final list2 = new List<KonfirmasiKeranjangModel>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    setState(() {
      loading = true;
    });
    list1.clear();
    final response = await http.get(BaseUrl.lihatkonfirmasikeranjangadmincod);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final ab = new KonfirmasiKeranjangModel(
        api['id'],
        api['namaProduk'],
        api['qty'],
        api['harga'],
        api['createdDate'],
        api['total'],
        api['kategori'],
        api['favorite'],
        api['deskripsi'],
        api['idUsers'],
        api['idProduk'],
        api['nama'],
        api['image'],
      );
      list1.add(ab);
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  
  Future<void> _lihatDatadua() async {
    setState(() {
      loading = true;
    });
    list2.clear();
    final response = await http.get(BaseUrl.lihatkonfirmasikeranjangadmintf);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final ab = new KonfirmasiKeranjangModel(
        api['id'],
        api['namaProduk'],
        api['qty'],
        api['harga'],
        api['createdDate'],
        api['total'],
        api['kategori'],
        api['favorite'],
        api['deskripsi'],
        api['idUsers'],
        api['idProduk'],
        api['nama'],
        api['image'],
      );
      list2.add(ab);
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
  final headerList = new  ListView.builder(
                          itemCount: list1.length,
                          itemBuilder: (context, i) {
                            final x = list1[i];
                              return Card(
                      child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(
                                      "ID Costumer :",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.idUsers,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0)),
                                  ),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text("ID Pesanan Tanaman :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.id,
                                        style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text("Nama Tanaman :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.namaProduk,
                                        style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text("Jumlah Tanaman :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.qty,
                                        style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text("Kategori Tanaman :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.deskripsi,
                                        style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                            ],
                          )));
                          });
    
    final body = new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Container(
        height: 550,
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new Text(
                          'Tanaman order via cod',
                          style: new TextStyle(color: Colors.black),
                        )),
                  ),
                  new Container(height: 150.0, child: headerList),
                  SizedBox(height: 25.0),
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new Text(
                          'Tanaman order via transfer',
                          style: new TextStyle(color: Colors.black),
                        )),
                  ),
                  new Expanded(
                      child: ListView.builder(
                          itemCount: list2.length,
                          itemBuilder: (context, i) {
                            final x = list2[i];
                             return Card(
                      child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(
                                      "ID Costumer :",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.idUsers,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0)),
                                  ),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text("ID Pesanan Tanaman :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.id,
                                        style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text("Nama Tanaman :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.namaProduk,
                                        style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text("Jumlah Tanaman :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.qty,
                                        style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                              new Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text("Kategori Tanaman :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: new Text(x.deskripsi,
                                        style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                            ],
                          )));
                          }))
                ],
              ),
            ),
          ],
        ),
      ),
   
    );

    return new Container(
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: new Stack(
        children: <Widget>[
          body,
        ],
      ),
    );

  }
}
