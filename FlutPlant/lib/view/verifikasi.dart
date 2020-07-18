import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/KonfirmasiKeranjangModel.dart';
import 'package:mysqlshop/modal/alamatmodel.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/buktimodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VerifikasiPage extends StatefulWidget {
  @override
  _VerifikasiPageState createState() => _VerifikasiPageState();
}

class _VerifikasiPageState extends State<VerifikasiPage> {
  final money1 = NumberFormat("#,##0", "en_US");
  final list1 = new List<AlamatModel>();
  final list2 = new List<KonfirmasiKeranjangModel>();
  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
    _lihatDataAlamat();
    _lihatDataKonfirmasi();
  }

  _delete(String idUsers) async {
    final response =
        await http.post(BaseUrl.deleteverifyproduk, body: {"idUsers": idUsers});
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
      var uri = Uri.parse(BaseUrl.productVerifytf);
      var request = http.MultipartRequest("POST", uri);

      request.fields['idUsers'] = idUsers;

      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          _delete(idUsers);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  _deletebukti(String id) async {
    final response =
        await http.post(BaseUrl.deletebukti, body: {"idUsers": id});
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

  var loading = false;
  String status = '';
  final list = new List<BuktiModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(BaseUrl.lihatbukti + idUsers);
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
      if (mounted) {
        setState(() {
          status = ab.status;
        });
      }
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _lihatDataAlamat() async {
    list1.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatAlamat + idUsers);
    if (response.contentLength == 2) {
    } else {
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
        list1.add(aa);
      });
      if(mounted){
        setState(() {
        loading = false;
      });
      }      
    }
  }

  Future<void> _lihatDataKonfirmasi() async {
    setState(() {
      loading = true;
    });
    list2.clear();
    final response = await http.get(BaseUrl.lihatKonfirmasiKeranjang + idUsers);
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
                  if (status == "nonverifikasi") {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          child: InkWell(
                        onTap: () {
                          print(status);
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text("ID Pembayaran: " + x.id),
                          ),
                          leading: new Image.network(
                            'https://flutplantshop.000webhostapp.com/verify/' + x.image,
                            fit: BoxFit.contain,
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  children: <Widget>[
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text("Tanggal kirim:",style: TextStyle(fontSize: 10.0),),//awalnya g aada fontsize
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text(
                                            x.createdDate,
                                            style:
                                                TextStyle(color: Colors.orange,fontSize: 10.0),//awalnya ga ada fontsize 
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text("Status :"),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: new Text(
                                                "Belum Terverifikasi")),
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text("Type Pembayaran :"),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: new Text(x.type)),
                                      ],
                                    ),
                                    Divider(height: 20, color: Colors.white),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    );
                  } else {
                    final alamatlist = new ListView.builder(
                      itemCount: list1.length,
                      itemBuilder: (context, i) {
                        final x = list1[i];
                        return Column(
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: new Text("Nama Penerima :"),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                x.namaPenerima,
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                            new Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: new Text("Alamat Penerima:"),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: new Text(
                                x.alamat,
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                            new Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: new Text("Kota dan kecamatan :"),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                x.kotkec,
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                            new Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: new Text("Kode Pos :"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: new Text(x.pos,
                                      style: TextStyle(color: Colors.orange)),
                                ),
                              ],
                            ),
                            new Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: new Text("No Handphone penerima :"),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                x.nomorhp,
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    final tip = new ListView.builder(
                      itemCount: list2.length,
                      itemBuilder: (context, i) {
                        final x = list2[i];
                        return Container(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              children: <Widget>[
                                // three line description
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                x.namaProduk + " ",
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                x.qty + " ",
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black38),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                x.deskripsi,
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black38),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ));
                      },
                    );
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text("ID Pembayaran: " + x.id),
                          ),
                          leading: new Image.network(
                            'https://flutplantshop.000webhostapp.com/verify/' + x.image,
                            fit: BoxFit.contain,
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  children: <Widget>[
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text("Tanggal kirim:"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text(
                                            x.createdDate,
                                            //     money.format(int.parse(x.harga)),
                                            style:
                                                TextStyle(color: Colors.orange, fontSize:10.0),
                                                
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text("Status :"),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: new Text(
                                              "Sudah Terverifikasi",
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            )),
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: new Text(
                                          "Jika Transaksii dilakukan lewat jam 3 sore, maka pengiriman akan dikirim besok",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    Divider(
                                      height: 25,
                                      color: Colors.green[300],
                                    ),
                                    new Container(
                                        height: 170.0, child: alamatlist),
                                    Divider(height: 5, color: Colors.white),
                                    Text("List Tanaman Yang di antar :"),
                                    new Container(height: 80.0, child: tip),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              40, 20, 3, 3),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: OutlineButton(
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                                child: const Text(
                                                    'Sudah Diterima'),
                                                textColor: Colors.green,
                                                onPressed: () {
                                                  submit();
                                                  _deletebukti(x.id);
                                                },
                                                shape: new OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
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
