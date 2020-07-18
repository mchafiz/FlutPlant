import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/KonfirmasiKeranjangModel.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/keranjangModel.dart';
import 'package:mysqlshop/view/TransferBank.dart';
import 'package:mysqlshop/view/tabBarPembelian.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  final VoidCallback reload;
  Payment(this.reload);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final list1 = new List<KonfirmasiKeranjangModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final money1 = NumberFormat("#,##0", "en_US");
  var totalharga = "0";
  final ex = List<KeranjangModel>();

  String idUsers;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatDataKonfirmasi();
  }

  var loading = false;
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

  _delete(String idUsers) async {
    final response =
        await http.post(BaseUrl.refreshkeranjang, body: {"idUsers": idUsers});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      if (mounted) {
        setState(() {
          print(pesan);
        });
      }
    } else {
      print(pesan);
    }
  }

  Future<void> _lihatDataKonfirmasi() async {
    list1.clear();
    setState(() {
      loading = true;
      totalHarga();
    });
    final response = await http.get(BaseUrl.lihatKonfirmasiKeranjang);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final aa = new KonfirmasiKeranjangModel(
          api['id'],
          api['namaProduk'],
          api['qty'],
          api['harga'],
          api['createdDate'],
          api['createdDate'],
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
      setState(() {
        loading = false;
        totalHarga();
      });
    }
  }

  tambahverifybarang() async {
    final response = await http.post(BaseUrl.productVerifycod, body: {
      "idUsers": idUsers,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
    } else {
      print(pesan);
    }
  }

  submit() async {
    try {
      var uri = Uri.parse(BaseUrl.cod);
      var request = http.MultipartRequest("POST", uri);
      request.fields['idUsers'] = idUsers;
      var response = await request.send();
  if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          tambahverifybarang();
          _delete(idUsers);
          widget.reload();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new TabbarPembelian(),
          ));

          _showDialogsukses();
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  void _showDialogsukses() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Terima Kasih",
            textAlign: TextAlign.center,
          ),
          content: new Text(
              "anda telah mengirim bukti transfer, silahkan tunggu untuk verifikasi pembayaran"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  IconData _backIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  int _radioValue = 0;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  String toolbarname = 'Payment';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final double height = MediaQuery.of(context).size.height;

    AppBar appBar = AppBar(
      leading: IconButton(
        icon: Icon(_backIcon()),
        alignment: Alignment.centerLeft,
        tooltip: 'Back',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(toolbarname),
      centerTitle: true,
      backgroundColor: Colors.green[300],
      actions: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Container(
            height: 150.0,
            width: 30.0,
            child: new GestureDetector(
            ),
          ),
        )
      ],
    );

    return new Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: new Column(
        children: <Widget>[
          Container(
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
                                              color: Colors.black38),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.play_circle_outline,
                                              color: Colors.black38,
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
                                              color: Colors.black),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                            ),
                                            onPressed: null)
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      )))),
          _verticalDivider(),
          Container(
            height: 65,
          ),
          new Container(
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: new Text(
              'Payment Method',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
          _verticalDivider(),
          new Container(
              height: 170.0,
              margin: EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      _verticalD(),
                      Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Transfer Bank Manual (BANK BCA)",
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 10.0, color: Colors.black)),
                              Radio<int>(
                                  value: 0,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange),
                            ],
                          )),
                      Divider(),
                      _verticalD(),
                      Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Cash on Delivery",
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 10.0, color: Colors.black)),
                              Radio<int>(
                                  value: 1,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange),
                            ],
                          )),
                      Divider(),
                    ],
                  )),
                ),
              )),
          Divider(height: 116, color: Colors.white), // 5 inch 120 6 inch 154 5.2 inch 116
          Container(
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
                            child: const Text('Bayar'),
                            textColor: Colors.green,
                            onPressed: () {
                              if (_radioValue == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TransferBank(_lihatDataKonfirmasi)));
                              } else {
                                submit();
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
        ],
      ),
    );
  }
  _verticalDivider() => Container(
        padding: EdgeInsets.all(2.0),
      );
  _verticalD() => Container(
        margin: EdgeInsets.only(left: 5.0),
      );
}
