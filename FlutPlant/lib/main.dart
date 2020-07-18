import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysqlshop/modal/api.dart';
import 'package:mysqlshop/view/menuUser.dart';
import 'package:mysqlshop/view/product.dart';
import 'package:mysqlshop/view/splash.dart';
import 'package:mysqlshop/view/verifikasialamat.dart';
import 'package:mysqlshop/view/verifikasicodadmin.dart';
import 'package:mysqlshop/view/verifikasitanaman.dart';
import 'package:mysqlshop/view/verifikasitransferadmin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modal/api.dart';
import 'my_flutter_app_icons.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    theme: ThemeData(),
    debugShowCheckedModeBanner: false,
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn, signInUsers }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;

  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  void _showDialogsukses() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Login Sukses",
            textAlign: TextAlign.center,
          ),
          content: new Text("login sebagai Pembeli berhasil"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogFailed() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Login Failed",
            textAlign: TextAlign.center,
          ),
          content: new Text(
              "Password atau Username anda salah, silahkan periksa kembali"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialoglogout() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Logout Sukses",
            textAlign: TextAlign.center,
          ),
          content: new Text("Terima Kasih Telah Menggunakan Layanan ini"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  var _autovalidate = true;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String namaAPI = data['nama'];
    String id = data['id'];
    String level = data['level'];
    if (value == 1) {
      //Control flow pengecekan Level
      if (level == "1") {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          _showDialog();
          savePref(value, usernameAPI, namaAPI, id, level);
        });
      } else {
        setState(() {
          _loginStatus = LoginStatus.signInUsers;
          _showDialogsukses();
          savePref(value, usernameAPI, namaAPI, id, level);
        });
      }
      print(pesan);
    } else {
      _showDialogFailed();
      print(pesan);
    }
  }

  savePref(
      int value, String username, String nama, String id, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.setString("level", level);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("level");

      _loginStatus = value == "1"
          ? LoginStatus.signIn
          : value == "2" ? LoginStatus.signInUsers : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("level", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
      _showDialoglogout();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Login Sukses",
            textAlign: TextAlign.center,
          ),
          content: new Text("login sebagai admin telah berhasil"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Stack(children: <Widget>[
            Image.asset(
              'img/tanaman.jpg',
              fit: BoxFit.cover,
              width: 1000,
              height: 1000,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 70, 5, 5),
                    child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: Icon(
                            MyFlutterApp.trees,
                            color: Colors.grey,
                            size: 50.0,
                          ),
                        ),
                  ),
                  Text(
                    'Happy Shop Plant With FlutPlant',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 240, 10, 10),
              child: Form(
                autovalidate: _autovalidate,
                key: _key,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty ||
                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(e)) {
                          return 'Please enter a valid email';
                        }
                      },
                      onSaved: (e) => username = e,
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(fontSize: 17.0, color: Colors.green[300]),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Username",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: TextFormField(
                        obscureText: _secureText,
                        validator: (e) {
                          if (e.length < 8) {
                            return "Minimal password 8 character";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (e) => password = e,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontSize: 17.0, color: Colors.green[300]),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Password",
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(
                              _secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.green[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.green.shade500,
                        elevation: 0.0,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            check();
                          },
                          child: Text("Login"),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Register()));
                      },
                      child: Text(
                        "Create a new account, in here",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green[300]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
      case LoginStatus.signInUsers:
        return MenuUsers(signOut);
        break;
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, password, nama;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register Berhasil",
            textAlign: TextAlign.center,
          ),
          content: new Text(
              "Silahkan Login dengan username dan password yang telah dibuat"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  var validate = true;
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    } else {
      setState(() {
        validate = true;
      });
    }
  }

  save() async {
    final response = await http.post(BaseUrl.register,
        body: {"nama": nama, "username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _showDialog();
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'img/tanaman.jpg',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
            Container(
              alignment: Alignment.topCenter,
              child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 70, 5, 5),
                      child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50.0,
                            child: Icon(
                              MyFlutterApp.trees,
                              color: Colors.grey,
                              size: 50.0,
                            ),
                          ),
                    ),
            ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 200, 10, 10),
              child: Form(
                autovalidate: validate,
                key: _key,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please insert fullname";
                          }
                        },
                        onSaved: (e) => nama = e,
                        decoration: InputDecoration(
                          labelText: "Nama Lengkap",
                          errorStyle: TextStyle(
                              fontSize: 17.0, color: Colors.green[300]),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please insert username";
                          }
                        },
                        onSaved: (e) => username = e,
                        decoration: InputDecoration(
                          labelText: "Username",
                          errorStyle: TextStyle(
                              fontSize: 17.0, color: Colors.green[300]),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: _secureText,
                        validator: (e) {
                          if (e.length < 8) {
                            return "Minimal password 8 character";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (e) => password = e,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontSize: 17.0, color: Colors.green[300]),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Password",
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(
                              _secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.green[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.green.shade500,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            check();
                          },
                          child: Text("Register"),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", nama = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
    });
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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          centerTitle: true,
          title: Text('Halaman Admin'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            VerifikasiAdmintransfer(),
            VerifikasiCodAdmin(),
            Product(),
            VerifikasiAlamat(),
            VerifikasitanamanAdmin(),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelStyle: TextStyle(fontSize: 5.0),
          labelColor: Colors.green[300],
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(style: BorderStyle.none)),
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.picture_in_picture_alt,
              ),
              text: "Bukti Transfer",
            ),
            Tab(
              icon: Icon(Icons.picture_in_picture),
              text: "Transaksi Cod",
            ),
            Tab(
              icon: Icon(Icons.view_quilt),
              text: "Tanaman Product",
            ),
            Tab(
              icon: Icon(Icons.home),
              text: "Alamat Costumer",
            ),
            Tab(
              icon: Icon(Icons.open_in_browser),
              text: "Tanaman Order",
            ),
          ],
        ),
      ),
    );
  }
}
