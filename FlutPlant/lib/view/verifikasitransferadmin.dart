import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/buktimodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VerifikasiAdmintransfer extends StatefulWidget {
  @override
  _VerifikasiAdmintransferState createState() =>
      _VerifikasiAdmintransferState();
}

class _VerifikasiAdmintransferState extends State<VerifikasiAdmintransfer> {
  final money1 = NumberFormat("#,##0", "en_US");

  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatDataBukti();
  }

  _update(String id) async {
    final response =
        await http.post(BaseUrl.updateverifikasi, body: {"idUsers": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _lihatDataBukti();
        print(pesan);
      });
    } else {
      print(pesan);
    }
  }

  var loading = false;
  final list = new List<BuktiModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatDataBukti() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(BaseUrl.lihatbuktiadmin);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final ab = new BuktiModel(
        api['id'],
        api['image'],
        api['createdDate'],
        api['status'],
        api['idUsers'],
        api['username'],
        api['nama'],
        api['type'],
      );
      list.add(ab);
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  String typee = "";

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
        onRefresh: _lihatDataBukti,
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
                              Image.network(
                                'https://flutplantshop.000webhostapp.com/verify/' + x.image,
                                fit: BoxFit.cover,
                                height: 300,
                                width: 300,
                              ),
                              ListTile(
                                title: Align(
                                    alignment: Alignment.center,
                                    child: Text("ID Pembayaran: " + x.id)),
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
                                                child: new Text(
                                                    "Tanggal kirim bukti:"),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: new Text(
                                                  x.createdDate,

                                                  //     money.format(int.parse(x.harga)),

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
                                                child: new Text(
                                                    "Status Pembayaran:"),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: new Text(x.status)),
                                            ],
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: new Text(
                                                    "Type Pembayaran:"),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: new Text(x.type)),
                                            ],
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: new Text("id Costumer:"),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: new Text(x.idUsers)),
                                            ],
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child:
                                                    new Text("Nama Costumer:"),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: new Text(x.nama)),
                                            ],
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: new Text(
                                                    'Verifikasi Pembayaran'),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: new IconButton(
                                                    icon: Icon(
                                                      Icons.verified_user,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                     setState(() {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              child: ListView(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16.0),
                                                                shrinkWrap:
                                                                    true,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Apakah and yakin untuk verifikasi foto bukti pembayaran?",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        10.0,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: <
                                                                        Widget>[
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text("No")),
                                                                      SizedBox(
                                                                        width:
                                                                            16.0,
                                                                      ),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            _update(x.id);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text("Yes")),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    });
                                                    }),
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
