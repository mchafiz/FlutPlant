import 'dart:io';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mysqlshop/costum/currency.dart';
import 'package:mysqlshop/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class TambahProduk extends StatefulWidget {
  final VoidCallback reload;
  TambahProduk(this.reload);
  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  String namaProduk, qty, harga, kategori, idUsers, deskripsi;
  final _key = new GlobalKey<FormState>();
  File _imageFile;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  _pilihKamera() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1920.0,
      maxWidth: 1080.0,
    );
    setState(() {
      _imageFile = image;
    });
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.product);
      var request = http.MultipartRequest("POST", uri);
      request.fields['namaProduk'] = namaProduk;
      request.fields['qty'] = qty;
      request.fields['harga'] = harga.replaceAll(",", '');
      request.fields['kategori'] = kategori;
      request.fields['deskripsi'] = deskripsi;
      request.fields['idUsers'] = idUsers;

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
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
    var placeholder = Container(
        width: double.infinity,
        height: 150.0,
        child: Image.asset('./img/kamera.png'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              'Tekan gambar dibawah untuk membuka kamera',
              textAlign: TextAlign.center,
            ),
            Container(
              width: double.infinity,
              height: 100.0,
              child: InkWell(
                onTap: () {
                  _pilihKamera();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(_imageFile, fit: BoxFit.fill),
              ),
            ),
            MaterialButton(
              color: Colors.green[300],
              onPressed: () {
                _pilihGallery();
              },
              child: Text("Upload Image With Gallery"),
            ),
            TextFormField(
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            TextFormField(
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Stock'),
            ),
            TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            TextFormField(
              onSaved: (e) => kategori = e,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            Container(
              child: new ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 300.0,
                ),
                child: new Scrollbar(
                  child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: new TextFormField(
                      onSaved: (e) => deskripsi = e,
                      decoration: InputDecoration(labelText: 'Deskripsi '),
                      maxLines: null,
                    ),
                  ),
                ),
              ),
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
      ),
    );
  }
}
