import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/KonfirmasiKeranjangModel.dart';
import 'package:mysqlshop/modal/alamatmodel.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/keranjangModel.dart';
import 'package:http/http.dart' as http;
import 'package:mysqlshop/view/Accountdata.dart';
import 'package:mysqlshop/view/editalamat.dart';
import 'package:mysqlshop/view/pembayaran.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Pengiriman extends StatefulWidget {
  @override
  _PengirimanState createState() => _PengirimanState();
}

class _PengirimanState extends State<Pengiriman> {
  bool checkboxValueA = true;
  bool checkboxValueB = false;
  bool checkboxValueC = false;
  final list = new List<AlamatModel>();
  final list1 = new List<KonfirmasiKeranjangModel>();
  final money1 = NumberFormat("#,##0", "en_US");
  String idUsers;
  var totalharga = "0";
  final ex = List<KeranjangModel>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
    _lihatDataKonfirmasi();
  }

  void _showDialogKosong() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Peringatan",
            textAlign: TextAlign.center,
          ),
          content: new Text(
              "Mohon Maaf anda harus mengisi data penerima terlebih dahulu "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Oke"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccountData()));
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogLebih() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Peringatan",
            textAlign: TextAlign.center,
          ),
          content: new Text(
              "Mohon Maaf, data penerima tidak bisa lebih dari satu, silahkan hapus salah satu data penerima, terima kasih "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  totalHarga() async {
    setState(() {
      loading = true;
    });
    ex.clear();
    final response = await http.get(BaseUrl.totalharga + idUsers);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new KeranjangModel(api['jumlah'], api['totalharga']);
      ex.add(exp);
      if (mounted) {
        setState(() {
          totalharga = exp.totalharga;
        });
      }
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Are you sure want to delete this Address?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id);
                          Navigator.pop(context);
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response =
        await http.post(BaseUrl.deletealamat, body: {"idUsers": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _lihatData();
        print(pesan);
      });
    } else {
      print(pesan);
    }
  }

  int itemId = 2;
  var loading = false;
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatAlamat + idUsers);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final aa = new AlamatModel(
        api['id'],
        api['namaPenerima'],
        api['alamat'],
        api['kotkec'],
        api['pos'],
        api['nomorhp'],
        api['idUsers'],
        api['nama'],
      );
      list.add(aa);
    });
    setState(() {
      loading = false;
    });
  }

  Future<void> _lihatDataKonfirmasi() async {
    list1.clear();
    setState(() {
      loading = true;
      totalHarga();
    });
    final response = await http.get(BaseUrl.lihatKeranjangdata + idUsers);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final aa = new KonfirmasiKeranjangModel(
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
      list1.add(aa);
    });
    if(mounted){
setState(() {
      loading = false;
      totalHarga();
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
    final headerList = new ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        final x = list[i];
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      x.namaPenerima,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(x.alamat),
                    Text(x.kotkec),
                    Text(x.pos),
                    Text(x.nomorhp),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditAlamat(x, _lihatData)));
                },
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  dialogDelete(x.id);
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
    );
    final tip = new Container(
        margin: EdgeInsets.all(5.0),
        child: Card(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // three line description
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Delivery',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.blue,
                                      ),
                                      onPressed: null)
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Payment',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.black38,
                                      ),
                                      onPressed: null)
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                ))));

    final body = new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Check Out'),
        elevation: 0.0,
        backgroundColor: Colors.green[300],
      ),
      backgroundColor: Colors.transparent,
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(height: 100.0, child: tip),
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new Text(
                          'Data Penerima',
                          style: new TextStyle(color: Colors.black),
                        )),
                  ),
                  new Align(
                    alignment: Alignment.centerRight,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountData()));
                          },
                          icon: Icon(Icons.add),
                        )),
                  ),
                  new Container(height: 150.0, child: headerList),
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new Text(
                          'Tanaman Yang di Beli',
                          style: new TextStyle(color: Colors.black),
                        )),
                  ),
                  new Expanded(
                      child: ListView.builder(
                          itemCount: list1.length,
                          itemBuilder: (context, i) {
                            final x = list1[i];
                            return SafeArea(
                                child: Column(
                              children: <Widget>[
                                Divider(height: 15.0),
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(x.namaProduk,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold)),
                                      Text(x.qty,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold)),
                                      Text(x.harga,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                          }))
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          alignment: Alignment.bottomLeft,
          height: 50.0,
          child: Card(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(icon: Icon(Icons.info), onPressed: null),
                Text(
                  'Total :',
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  money1.format(int.parse(totalharga)),
                  style: TextStyle(fontSize: 17.0, color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: OutlineButton(
                        borderSide: BorderSide(color: Colors.green),
                        child: const Text('Payment'),
                        textColor: Colors.green,
                        onPressed: () {
                          if (list.isEmpty) {
                            print('harus isi alamat');
                            _showDialogKosong();
                          } else if (list.length > 1) {
                            print('alamat harus 1');
                            _showDialogLebih();
                          } else if (list.isNotEmpty) {
                            print('silahkan payment');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Payment(_lihatDataKonfirmasi)));
                          }
                        },
                        shape: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                ),
              ],
            ),
          )),
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
