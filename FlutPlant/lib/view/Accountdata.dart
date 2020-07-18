import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/view/Pengiriman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountData extends StatefulWidget {
  @override
  _AccountDataState createState() => _AccountDataState();
}

class _AccountDataState extends State<AccountData> {
  String namaPenerima, alamat, kotkec, pos, nomorhp, idUsers;
  final _key = new GlobalKey<FormState>();
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  submit() async {
    try {
      var uri = Uri.parse(BaseUrl.alamat);
      var request = http.MultipartRequest("POST", uri);
      request.fields['namaPenerima'] = namaPenerima;
      request.fields['alamat'] = alamat;
      request.fields['kotkec'] = kotkec;
      request.fields['pos'] = pos;
      request.fields['nomorhp'] = nomorhp;
      request.fields['idUsers'] = idUsers;
      var response = await request.send();
      if (response.statusCode > 2) {
        print("berhasiil");
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Pengiriman()));
        });
      } else {
        print("tidak berhasil");
      }
    } catch (e) {
      debugPrint('error $e');
    }
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
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
      appBar: AppBar(
        title: Text('Tambah Data Penerima'),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),
      body: Form(
        key: _key,
        child: ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                TextFormField(
                  onSaved: (e) => namaPenerima = e,
                  decoration: InputDecoration(labelText: 'Nama Penerima'),
                ),
                TextFormField(
                  onSaved: (e) => alamat = e,
                  decoration: InputDecoration(labelText: 'Alamat'),
                ),
                TextFormField(
                  onSaved: (e) => kotkec = e,
                  decoration: InputDecoration(labelText: 'Kota atau Kecamatan'),
                ),
                TextFormField(
                  onSaved: (e) => pos = e,
                  decoration: InputDecoration(labelText: 'Kode Pos'),
                ),
                TextFormField(
                  onSaved: (e) => nomorhp = e,
                  decoration:
                      InputDecoration(labelText: 'Nomor Telepon Penerima'),
                ),
                MaterialButton(
                  color: Colors.green[300],
                  onPressed: () {
                    check();
                  },
                  child: Text('Simpan'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
