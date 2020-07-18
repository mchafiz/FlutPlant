import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:http/http.dart' as http;

class EditProduk extends StatefulWidget {
  final ProductModel model;
  final VoidCallback reload;

  EditProduk(this.model, this.reload);

  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _key = GlobalKey<FormState>();
  String namaProduk, qty, harga, kategori, deskripsi;

  TextEditingController txtNamap, txtAlamat, txtkotkec, txtPos, txtnohp;

  setup() {
    txtNamap = TextEditingController(text: widget.model.namaProduk);
    txtAlamat = TextEditingController(text: widget.model.qty);
    txtkotkec = TextEditingController(text: widget.model.harga);
    txtPos = TextEditingController(text: widget.model.kategori);
    txtnohp = TextEditingController(text: widget.model.favorite);
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    final response = await http.post(BaseUrl.editProduk, body: {
      "namaProduk": namaProduk,
      "qty": qty,
      "harga": harga,
      "kategori": kategori,
      "deskripsi": deskripsi,
      "idProduk": widget.model.id
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
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
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtNamap,
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: 'Nama Product'),
            ),
            TextFormField(
              controller: txtAlamat,
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Stock'),
            ),
            TextFormField(
              controller: txtkotkec,
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            TextFormField(
              controller: txtPos,
              onSaved: (e) => kategori = e,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            new Scrollbar(
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: new TextFormField(
                  controller: txtnohp,
                  onSaved: (e) => deskripsi = e,
                  decoration: InputDecoration(labelText: 'Deskripsi Tanaman'),
                  maxLines: null,
                ),
              ),
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
