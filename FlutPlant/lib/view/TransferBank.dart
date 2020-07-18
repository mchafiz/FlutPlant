import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/KonfirmasiKeranjangModel.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/keranjangModel.dart';
import 'package:http/http.dart' as http;
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:mysqlshop/view/tabBarPembelian.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class TransferBank extends StatefulWidget {
  final VoidCallback reload;
  TransferBank(this.reload);

  @override
  _TransferBankState createState() => _TransferBankState();
}

class _TransferBankState extends State<TransferBank> {
  String idUsers;

  final list = new List<ProductModel>();
  final list1 = new List<KonfirmasiKeranjangModel>();
  final money1 = NumberFormat("#,##0", "en_US");
  var totalharga = "0";
  final ex = List<KeranjangModel>();
  File _imageFile;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });

    _lihatDataKonfirmasi();
  }

  _pilihKamera() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1920.0,
      maxWidth: 1080.0,
    );
    setState(() {
      _imageFile = image;
    });
  }

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  tambahverifybarang1() async {
    final response = await http.post(BaseUrl.productVerifytf, body: {
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

  submit() async {
    try {
      var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.bukti);
      var request = http.MultipartRequest("POST", uri);
      request.fields['idUsers'] = idUsers;
      request.files.add(http.MultipartFile("image", stream, length, filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          _delete(idUsers);
          widget.reload();
          tambahverifybarang1();
          Navigator.pop(context);
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

  var loading = false;
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
    final headerList = new Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 25.0,
                ),
                Column(children: <Widget>[
                  Image.asset('img/bca.png', width: 100.0, height: 100.0),
                ]),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(
                        height: 35,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '372 178 5066',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('a/n FlutPlant', style: TextStyle(fontSize: 10.0),),//AWALNYA GA ADA FONTSIZE
              ],
            )
          ],
        ));
    final tip = new Container(
        margin: EdgeInsets.all(5.0),
        child: Card(
            child: Container(
                child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // three line description
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'TRANSAKSI MANUAL VIA BANK BCA',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ))));
    var placeholder = Container(
        width: double.infinity,
        height: 50.0,
        child: Image.asset('./img/kamera.png'));
    final body = new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Pembayaran'),
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
                  new Container(height: 55.0, child: tip),
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.fromLTRB(8, 10, 0, 0),
                        child: new Text(
                          'Transfer ke Nomor Rekening',
                          style: new TextStyle(color: Colors.black),
                        )),
                  ),
                  new Container(height: 140.0, child: headerList),
                  Divider(height: 10),
                  new Align(
                    alignment: Alignment.center,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new Text(
                          'Jumlah yang harus dibayar',
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                  ),
                  new Align(
                      alignment: Alignment.center,
                      child: new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: Text(
                          money1.format(int.parse(totalharga)),
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      )),
                  new Align(
                    alignment: Alignment.center,
                    child: new Padding(
                      padding: new EdgeInsets.all(4.0),
                      child: Text('Upload Bukti Pembayaran'),
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  Container(
                    width: double.infinity,
                    height: 98.0, //100
                    child: InkWell(
                      onTap: () {
                        _pilihKamera();
                      },
                      child: _imageFile == null
                          ? placeholder
                          : Image.file(_imageFile, fit: BoxFit.fill),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      _pilihGallery();
                    },
                    child: Text("Upload Image With Gallery"),
                  ),
                  MaterialButton(
                    color: Colors.green[300],
                    onPressed: () {
                      setState(() {
                       submit(); 
                      });
                    },
                    child: Text('Kirim'),
                  )
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
