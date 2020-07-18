import 'package:flutter/material.dart';
import 'package:mysqlshop/view/verifikasi.dart';
import 'package:mysqlshop/view/verifikasicod.dart';

class TabbarPembelian extends StatefulWidget {
  @override
  _TabbarPembelianState createState() => _TabbarPembelianState();
}

class _TabbarPembelianState extends State<TabbarPembelian> {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          centerTitle: true,
          title: Text('Pembelian Tanaman'),
        ),
        body: TabBarView(
          children: <Widget>[VerifikasiPage(), Verifikasicod()],
        ),
        bottomNavigationBar: TabBar(
          labelStyle: TextStyle(fontSize: 15.0),
          labelColor: Colors.green[300],
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(style: BorderStyle.none)),
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.picture_in_picture_alt),
              text: "Pembelian Transfer",
            ),
            Tab(
              icon: Icon(Icons.picture_in_picture_alt),
              text: "Pembelian Cash",
            ),
          ],
        ),
      ),
    );
  }
}
