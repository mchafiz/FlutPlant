import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:mysqlshop/view/editproduk.dart';
import 'package:mysqlshop/view/tambahProduk.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final money = NumberFormat("#,##0", "en_US");

  var loading = false;
  final list = new List<ProductModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

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
          api['deskripsi'],
          api['favorite'],
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
          loading = false;
        });
      }
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
                  "Are you sure want to delete this product?",
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
        await http.post(BaseUrl.deleteProduk, body: {"idProduk": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[300],
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TambahProduk(_lihatData)));
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(
                          'https://flutplantshop.000webhostapp.com/upload/' + x.image,
                          width: 100.0,
                          height: 180.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                x.namaProduk,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text("Stock :" + x.qty),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text("Harga :" +
                                    money.format(int.parse(x.harga))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text("Kategori :" + x.kategori),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child:
                                    Text("Tanggal Penambahan:" + x.createdDate),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditProduk(x, _lihatData)));
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogDelete(x.id);
                          },
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
