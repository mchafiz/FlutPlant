import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysqlshop/modal/alamatmodel.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:http/http.dart' as http;

class EditJumlah extends StatefulWidget {
  final ProductModel model;
  final VoidCallback reload;

  EditJumlah(this.model, this.reload);

  @override
  _EditJumlahState createState() => _EditJumlahState();
}

class _EditJumlahState extends State<EditJumlah> {
  final _key = GlobalKey<FormState>();
  String qty;

  TextEditingController txtQty;

  setup() {
    txtQty = TextEditingController(text: widget.model.qty);
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    final response = await http.post(BaseUrl.editjumlah,
        body: {"qty": qty, "idProduk": widget.model.id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      if(mounted){
        setState(() {
        widget.reload();
        Navigator.pop(context);
      });
      }
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green[300],),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtQty,
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Jumlah '),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
