import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/buktimodel.dart';
import 'package:mysqlshop/modal/keranjangModel.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:http/http.dart' as http;
import 'package:mysqlshop/view/about.dart';
import 'package:mysqlshop/view/detailProduk.dart';
import 'package:mysqlshop/siram_icons.dart';
import 'package:mysqlshop/my_flutter_app_icons.dart';
import 'package:mysqlshop/view/keranjang.dart';
import 'package:mysqlshop/view/petunjuk.dart';
import 'package:mysqlshop/view/search.dart';
import 'package:mysqlshop/view/tabBarPembelian.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysqlshop/view/favorite.dart';
import '../pohon_icons.dart';

class MenuUsers extends StatefulWidget {
  final VoidCallback signOut;

  MenuUsers(this.signOut);
  @override
  _MenuUsersState createState() => _MenuUsersState();
}

class _MenuUsersState extends State<MenuUsers> {
  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
      username = preferences.getString("username");
      nama = preferences.getString("nama");
    });
    _lihatData();
  }

  var loading = false;
  var image;
  String username, nama;
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

      setState(() {
        username = ab.username;
        nama = ab.nama;
      });
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          centerTitle: true,
          title: Text('PLANTSHOP'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  MyFlutterApp.trees,
                  size: 30, //45 untuk yang dibawah 5 inch
                ),
                text: "Indoor",
              ),
              Tab(
                icon: Icon(
                  Pohon.pohon,
                  size: 30,
                ),
                text: "Outdoor",
              ),
              Tab(
                icon: Icon(
                  Siram.siram,
                  size: 30,
                ),
                text: "Aksesoris",
              ),
            ],
          ),
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail: Text(username ?? ''),
                accountName: Text(nama ?? ''),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                ),
                decoration: new BoxDecoration(
                  color: Colors.green[300],
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text('Home Page'),
                    leading: Icon(
                      Icons.home,
                      color: Colors.green[600],
                      size: 30,
                    ),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new Keranjang()));
                  },
                  child: ListTile(
                    title: Text('Keranjang Pembelian'),
                    leading: Icon(Icons.shopping_cart,
                        color: Colors.green[600], size: 30),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new TabbarPembelian()));
                  },
                  child: ListTile(
                    title: Text('Pembelian Tanaman'),
                    leading:
                        Icon(Icons.check, color: Colors.green[600], size: 30),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new Favorite()));
                  },
                  child: ListTile(
                    title: Text('Favourites'),
                    leading: Icon(Icons.favorite,
                        color: Colors.green[600], size: 30),
                  )),
              Divider(),
              Divider(),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new Petunjuk()));
                  },
                  child: ListTile(
                    title: Text('Petunjuk Penggunaan aplikasi'),
                    leading: Icon(Icons.info, color: Colors.grey, size: 30),
                  )),
              InkWell(
                  onTap: () {
                    setState(() {
                      widget.signOut();
                      Navigator.pop(context);
                    });
                  },
                  child: ListTile(
                    title: Text('Log Out'),
                    leading: Icon(Icons.remove_circle_outline,
                        color: Colors.red, size: 30),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new aboutPage()));
                  },
                  child: ListTile(
                    title: Text('About'),
                    leading: Icon(Icons.help, color: Colors.blue, size: 30),
                  )),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductListIndoor(),
            ProductListOutdoor(),
            ProductListAksesoris(),
          ],
        ),
      ),
    );
  }
}

class ProductListOutdoor extends StatefulWidget {
  @override
  _ProductListOutdoorState createState() => _ProductListOutdoorState();
}

class _ProductListOutdoorState extends State<ProductListOutdoor> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final money = NumberFormat("#,##0", "en_US");

  String idUsers, nama, username;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        idUsers = preferences.getString("id");
      });
    }

    _lihatData();
  }

  var loading = false;
  final list = new List<ProductModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    final response = await http.get(BaseUrl.lihatProdukOutdoor);
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
          _jumlahKeranjang();
          loading = false;
        });
      }
    }
  }

  tambahKeranjang(String idProduk, String harga) async {
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
    setState(() {
      loading = true;
    });
    ex.clear();
    final response = await http.get(BaseUrl.jumlahKeranjang + idUsers);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new KeranjangModel(api['jumlah'], api['totalharga']);
      ex.add(exp);
      if(mounted){
         setState(() {

        jumlah = exp.jumlah;
      });
      }
     
    });
    if(mounted){
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
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailProduk(x)));
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Hero(
                            tag: x.id,
                            child: Image.network(
                              'https://flutplantshop.000webhostapp.com/upload/' +
                                  x.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          x.namaProduk,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Rp. " + money.format(int.parse(x.harga)),
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ));
  }
}

class ProductListIndoor extends StatefulWidget {
  @override
  _ProductListIndoorState createState() => _ProductListIndoorState();
}

class _ProductListIndoorState extends State<ProductListIndoor> {
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

  var loading = false;
  final list = new List<ProductModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatProdukIndoor);
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
          _jumlahKeranjang();
          loading = false;
        });
      }
    }
  }

  tambahKeranjang(String idProduk, String harga) async {
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
    setState(() {
      loading = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      key: _refresh,
      onRefresh: _lihatData,
      child: Container(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailProduk(x)));
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.network(
                              'https://flutplantshop.000webhostapp.com/upload/' +
                                  x.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            x.namaProduk,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Rp. " + money.format(int.parse(x.harga)),
                            style: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ));
              },
            );
          },
        ),
      ),
    ));
  }
}

class ProductListAksesoris extends StatefulWidget {
  @override
  _ProductListAksesorisState createState() => _ProductListAksesorisState();
}

class _ProductListAksesorisState extends State<ProductListAksesoris> {
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

  var loading = false;
  final list = new List<ProductModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
      _jumlahKeranjang();
    });
    final response = await http.get(BaseUrl.lihatProdukAksesoris);
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
          _jumlahKeranjang();
          _totalHarga();
          loading = false;
        });
      }
    }
  }

  tambahKeranjang(String idProduk, String harga) async {
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
      _totalHarga();
    } else {
      print(pesan);
    }
  }

  String jumlah = "0";
  final ex = List<KeranjangModel>();
  _jumlahKeranjang() async {
    setState(() {
      loading = true;
    });
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

  String totalharga = "0";
  final exx = List<KeranjangModel>();
  _totalHarga() async {
    setState(() {
      loading = true;
    });
    exx.clear();
    final response = await http.get(BaseUrl.totalharga + idUsers);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new KeranjangModel(api['jumlah'], api['totalharga']);
      exx.add(exp);
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
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailProduk(x)));
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Hero(
                            tag: x.id,
                            child: Image.network(
                              'https://flutplantshop.000webhostapp.com/upload/' +
                                  x.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          x.namaProduk,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Rp. " + money.format(int.parse(x.harga)),
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ));
  }
}
