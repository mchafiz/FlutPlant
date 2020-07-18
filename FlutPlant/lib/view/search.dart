import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/model.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:mysqlshop/view/detailProduk.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List<Posts> _list = [];
  // List<Posts> _search = [];
  final _search = new List<ProductModel>();
  final list = new List<ProductModel>();
  var loading = false;

  Future<void> _lihatData() async {
    list.clear();
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
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

  // Future<Null> fetchData() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   _list.clear();
  //   final response = await http
  //       .get("https://flutplantshop.000webhostapp.com/api/lihatProduk.php");
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     if (mounted) {
  //       setState(() {
  //         for (Map i in data) {
  //           _list.add(Posts.formJson(i));
  //           loading = false;
  //         }
  //       });
  //     }
  //   }
  // }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    list.forEach((f) {
      if (f.namaProduk.contains(text) || f.id.toString().contains(text))
        _search.add(f);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData();
    _lihatData();
  }

  Icon actionIcon = new Icon(Icons.close);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        centerTitle: true,
        title: new TextField(
          controller: controller,
          onChanged: onSearch,
          style: new TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
              
              hintText: "Search...",
              hintStyle: new TextStyle(color: Colors.white)),
        ),
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              Navigator.pop(context);
              controller.clear();
              onSearch('');
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: _search.length != 0 || controller.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: _search.length,
                            itemBuilder: (context, i) {
                              final b = _search[i];
                              return InkWell(
                                onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailProduk(b)));},
                                 child: Card(
                                  child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            b.namaProduk,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(b.deskripsi),
                                          Text("Stok :"+b.qty),
                                        ],
                                      )),
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              final a = list[i];
                              return InkWell(
                                onTap: (){},
                                                              child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Text(
                                        //   a.deskripsi,
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 18.0),
                                        // ),
                                      ],
                                    )),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
