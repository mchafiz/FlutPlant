import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysqlshop/modal/alamatmodel.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/modal/produkModel.dart';
import 'package:http/http.dart' as http;

class EditAlamat extends StatefulWidget {
  final AlamatModel model;
  final VoidCallback reload;

  EditAlamat(this.model, this.reload);

  @override
  _EditAlamatState createState() => _EditAlamatState();
}

class _EditAlamatState extends State<EditAlamat> {
  final _key = GlobalKey<FormState>();
  String namaPenerima, alamat, kotkec, pos, nohp;

  TextEditingController txtNamap, txtAlamat, txtkotkec, txtPos, txtnohp;

  setup() {
    txtNamap = TextEditingController(text: widget.model.namaPenerima);
    txtAlamat = TextEditingController(text: widget.model.alamat);
    txtkotkec = TextEditingController(text: widget.model.kotkec);
    txtPos = TextEditingController(text: widget.model.pos);
    txtnohp = TextEditingController(text: widget.model.nomorhp);
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    final response = await http.post(BaseUrl.editalamat, body: {
      "namaPenerima": namaPenerima,
      "alamat": alamat,
      "kotkec": kotkec,
      "pos": pos,
      "nomorhp": nohp,
      "idUsers": widget.model.id
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
      appBar: AppBar(backgroundColor: Colors.green[300],),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtNamap,
              onSaved: (e) => namaPenerima = e,
              decoration: InputDecoration(labelText: 'Nama Penerima'),
            ),
            TextFormField(
              controller: txtAlamat,
              onSaved: (e) => alamat = e,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextFormField(
              controller: txtkotkec,
              onSaved: (e) => kotkec = e,
              decoration: InputDecoration(labelText: 'Kota atau Kecamatan'),
            ),
            TextFormField(
              controller: txtPos,
              onSaved: (e) => pos = e,
              decoration: InputDecoration(labelText: 'Kode Pos'),
            ),
            TextFormField(
              controller: txtnohp,
              onSaved: (e) => nohp = e,
              decoration: InputDecoration(labelText: 'No HandPhone'),
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
