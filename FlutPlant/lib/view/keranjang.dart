import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/keranjangModel.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:mysqlshop/view/Pengiriman.dart';
import 'package:mysqlshop/view/editjumlah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Keranjang extends StatefulWidget {
  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  final money = NumberFormat("#,##0", "en_US");
  var totalharga = "0";
  final ex = List<KeranjangModel>();

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final money1 = NumberFormat("#,##0", "en_US");

  String idUsers, idProduk, harga, qty;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
  }

  _delete(String id) async {
    final response =
        await http.post(BaseUrl.deleteProdukKeranjang, body: {"idProduk": id});
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

  _deletee(String idUsers) async {
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

  var loading = false;
  final list = new List<ProductModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    setState(() {
      loading = true;
      totalHarga();
    });
    list.clear();
    final response = await http.get(BaseUrl.lihatKeranjangdata + idUsers);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final ab = new ProductModel(
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
      list.add(ab);
      if (mounted) {
        setState(() {
          idProduk = ab.idProduk;
          harga = ab.harga;
          qty = ab.qty;
        });
      }
    });
    if (mounted) {
      setState(() {
        totalHarga();
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
      appBar: new AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Colors.green[300],
        title: Text(
          'Keranjang Pembelian',
        ),
      ),
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
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(x.namaProduk),
                        ),
                        leading: new Image.network(
                          'https://flutplantshop.000webhostapp.com/upload/' + x.image,
                          width: 80.0,
                          height: 200.0,
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
                                        child: new Text("Harga :"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: new Text(
                                          "Rp. " +
                                              money.format(
                                                  int.parse(x.favorite)),
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: new Text("Jumlah :"),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text(x.qty)),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            1, 1, 1, 1),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditJumlah(
                                                            x, _lihatData)));
                                          },
                                          icon: Icon(
                                            Icons.edit_attributes,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: new Text("Kategori:"),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text(x.deskripsi)),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text(
                                            "Catatan:",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: new Text(
                                          "Perhatikan Jumlah Stock \nyang tertera di halaman \ndetail produk sebelum \nMengisi jumlah tanaman \natau produk yang dibeli",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: new Text('Delete Item'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: new IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _delete(x.id);
                                              _deletee(idUsers);
                                            }),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
          alignment: Alignment.bottomCenter,
          height: 50.0,
          child: Card(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total :',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  money1.format(int.parse(totalharga)),
                  style: TextStyle(fontSize: 15.0, color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: OutlineButton(
                        borderSide: BorderSide(color: Colors.green),
                        child: const Text('Check Out'),
                        textColor: Colors.green,
                        onPressed: () {
                          if (totalharga == "0") {
                            print("tak bisa la");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Pengiriman()));
                          }
                        },
                        shape: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
