import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/keranjangModel.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:http/http.dart' as http;
import 'package:mysqlshop/view/keranjang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProduk extends StatefulWidget {
  ProductModel model;
  DetailProduk(this.model);
  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  var list = new List<ProductModel>();

  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
  }

  var loading = false;
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatProduk);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new ProductModel(
          api['id'],
          api['namaProduk'],
          api['qty'],
          api['harga'],
          api['kategori'],
          api['favorite'],
          api['deskripsi'],
          api['createdDate'],
          api['total'],
          api['idUsers'],
          api['idProduk'],
          api['nama'],
          api['image'],
        );
        list.add(ab);
      });
      if (mounted) {
        setState(() {
          _jumlahKeranjang();
          loading = false;
        });
      }
    }
  }

  String idProduk, harga;
  tambahKeranjang(String idProduk, harga) async {
    final response = await http.post(BaseUrl.tambahKeranjang, body: {
      "idUsers": idUsers,
      "idProduk": idProduk,
      "harga": harga,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      _jumlahKeranjang();
    } else {
      print(pesan);
    }
  }

  String jumlah = "0";
  final ex = List<KeranjangModel>();
  _jumlahKeranjang() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    ex.clear();
    final response = await http.get(BaseUrl.jumlahKeranjang + idUsers);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new KeranjangModel(api['jumlah'], api['totalharga']);
      ex.add(exp);
      if (mounted) {
        setState(() {
          jumlah = exp.jumlah;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Pemberitahuan",
            textAlign: TextAlign.center,
          ),
          content: new Text(
            "Mohon Maaf untuk menghapus favorite hanya bisa dilakukan di halaman favorite Terima Kasih",
            textAlign: TextAlign.left,
          ),
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

  void _showDialogcart() {
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
            "Tanaman sudah di masukan ke keranjang ",
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Lihat Keranjang"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Keranjang()));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  var isPressed = false;
  var isPressed1 = false;
  var isButtonDisabled = false;
  var isButtonDisabled1 = false;

  String idProduk1, harga1;
  tambahFavorite(String idProduk1, harga1) async {
    final response = await http.post(BaseUrl.favorite, body: {
      "idUsers": idUsers,
      "idProduk": idProduk1,
      "harga": harga1,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      _jumlahKeranjang();
    } else {
      print(pesan);
    }
  }

  favdelete(String idUsers) async {
    final response = await http.post(BaseUrl.deletefavorite, body: {
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

  checkfav() async {
    if (isPressed == false) {
      setState(() {
        tambahFavorite(widget.model.id, widget.model.harga);
        isPressed = true;
        isButtonDisabled = true;
      });
    } else {
      setState(() {
        _showDialog();
      });
    }
  }

  checkTambahKeranjang() async {
    if (isPressed1 == false) {
      setState(() {
        tambahKeranjang(widget.model.id, widget.model.harga);

        isPressed1 = true;
        isButtonDisabled1 = true;
      });
    } else {
      setState(() {
        _showDialogcart();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            backgroundColor: Colors.green[300],
            floating: true,
            pinned: true,
            actions: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new Keranjang(),
                          ));
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.green[300],
                      size: 35,
                    ),
                  ),
                  jumlah == "0"
                      ? Container()
                      : Positioned(
                          right: 0.0,
                          child: Stack(
                            children: <Widget>[
                              Icon(
                                Icons.brightness_1,
                                size: 25.0,
                                color: Colors.red[300],
                              ),
                              Positioned(
                                top: 5.0,
                                right: 8.0,
                                child: Text(
                                  jumlah,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.0),
                                ),
                              )
                            ],
                          ),
                        )
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.model.id,
                child: Image.network(
                  'https://flutplantshop.000webhostapp.com/upload/' + widget.model.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ];
      },
      body: Stack(children: <Widget>[
        Divider(
          color: Colors.green,
          height: 25,
        ),
        ListView(
          children: <Widget>[
            Row(
              //Buy button
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        tambahKeranjang(widget.model.id, widget.model.harga);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Keranjang()));
                      });
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    elevation: 0.2,
                    child: new Text("Buy Now"),
                  ),
                ),
                new IconButton(
                  onPressed: () {
                    checkTambahKeranjang();
                  },
                  icon: Icon(
                    isPressed1 ? Icons.shopping_cart : Icons.add_shopping_cart,
                    color: Colors.red,
                  ),
                ),
                new IconButton(
                    onPressed: () {
                      setState(() {
                        checkfav();
                      });
                    },
                    icon: Icon(
                      isPressed ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ))
              ],
            ),
            Divider(
              color: Colors.green,
              height: 5,
            ),
            new ListTile(
              title: new Text("Produk Detail"),
              subtitle: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  "${widget.model.total}",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Divider(),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text("Nama Tanaman : ${widget.model.namaProduk}",
                      style: TextStyle(color: Colors.grey)),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(''),
                )
              ],
            ),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text("Stock Tanaman/Barang: ${widget.model.qty}",
                      style: TextStyle(color: Colors.grey)),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(''),
                )
              ],
            ),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text("Jenis Tanaman : ${widget.model.deskripsi}",
                      style: TextStyle(color: Colors.grey)),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(''),
                )
              ],
            ),
            Divider(),
          ],
        ),
        Divider(),
      ]),
    ));
  }
}
