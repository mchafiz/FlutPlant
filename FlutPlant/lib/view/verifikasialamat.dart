import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/alamatmodel.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/buktimodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VerifikasiAlamat extends StatefulWidget {
  @override
  _VerifikasiAlamatState createState() => _VerifikasiAlamatState();
}

class _VerifikasiAlamatState extends State<VerifikasiAlamat> {
  final money1 = NumberFormat("#,##0", "en_US");

  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        idUsers = preferences.getString("id");
      });
    }
    _lihatData();
  }

  var loading = false;
  final list = new List<AlamatModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    list.clear();
    final response = await http.get(BaseUrl.lihatAlamatAdmin);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final ab = new AlamatModel(
        api['id'],
        api['namaPenerima'],
        api['alamat'],
        api['kotkec'],
        api['pos'],
        api['nomorhp'],
        api['idUsers'],
        api['nama'],
      );
      list.add(ab);
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
    return Scaffold(
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: _lihatData,
        child: Container(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Align(
                                  alignment: Alignment.center,
                                  child: Text("ID Costumer: " + x.idUsers)),
                              subtitle: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      children: <Widget>[
                                        new Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: new Text("Nama Penerima:"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: new Text(
                                                x.namaPenerima,
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child:
                                                  new Text("Alamat Penerima:"),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text(
                                            x.alamat,
                                            style:
                                                TextStyle(color: Colors.orange),
                                          ),
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: new Text(
                                                  "Kota dan Kecamatan:"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: new Text(
                                                x.kotkec,
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: new Text("Kode Pos:"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: new Text(
                                                x.namaPenerima,
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child:
                                                  new Text("Nomor Handphone:"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: new Text(
                                                x.nomorhp,
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                            height: 20, color: Colors.white),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
          alignment: Alignment.bottomLeft,
          height: 50.0,
          child: Card(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[],
            ),
          )),
    );
  }
}
