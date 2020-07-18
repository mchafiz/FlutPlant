import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:mysqlshop/view/detailProduk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final money = NumberFormat("#,##0", "en_US");

  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
  }

  _delete(String id) async {
    final response =
        await http.post(BaseUrl.deletefavorite, body: {"idProduk": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  var loading = false;
  final list = new List<ProductModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatFavoritedata);
    if (response.contentLength == 2) {
    } else {
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
      });
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  int _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Colors.green[300],
        title: Text(
          'My Favorite Plant',
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
                        child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new DetailProduk(x)));
                      },
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
                                              money.format(int.parse(x.harga)),
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
                                        child: new Text("Kategori:"),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: new Text(x.deskripsi)),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: new IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _delete(x.id);
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
                    )),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
