import 'package:flutter/material.dart';

class Petunjuk extends StatefulWidget {
  @override
  _PetunjukState createState() => _PetunjukState();
}

class _PetunjukState extends State<Petunjuk> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.green,
          title: new Text("Petunjuk Penggunaan"),
        ),
        body: Container(
           child: new SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text('Pada saat ingin melakukan pembelian produk tanaman hias ataupun aksesoris tanaman, pelanggan dapat memilih sesuai kategori yang ada pada menu utama halaman. untuk membeli tanaman berikut adalah tata cara pembelian : ',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),textAlign: TextAlign.justify,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(
                      "1. Pilihlah produk yang akan di beli, produk tertera pada masing-masing kategori produk." ,
                      style: new TextStyle(
                        fontSize: 16.0, color: Colors.black,
                      ), textAlign: TextAlign.justify,
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(
                      "2. Tekan gambar produk yang akan dibeli, sehingga akan menampilkan tampilan detail produk." ,
                      style: new TextStyle(
                        fontSize: 16.0, color: Colors.black,
                      ), textAlign: TextAlign.justify,
                    ),
                  ),
                 Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(
                      "3. Pada halaman detail produk terdapat tombol 'buy now' untuk memasukan langsung produk ke dalam keranjang."+
                      " lalu terdapat tombol yang memiliki icon keranjang plus yang digunakan untuk menambahkan produk ke dalam keranjang sementara"+
                      " , terdapat tombol favorite untuk menambah daftar produk yang disukai. terdapat tombol keranjang berwarna hijau yang digunakan untuk pergi ke halaman keranjang dan terdapat deskripsi produk. " ,
                      style: new TextStyle(
                        fontSize: 16.0, color: Colors.black,
                      ), textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(
                      "4. Jika produk berhasil di masukan ke dalam keranjang, anda dapat mengubah jumlah produk yang ingin dibeli dengan cara tekan tombol berwarna merah disamping angka jumlah."+
                      " dan anda bisa menghapus produk jika ingin membatalkan pembelian. jika produk yang dibeli sudah benar maka tekan tombol check out yang berada pada posisi bawah." ,
                      style: new TextStyle(
                        fontSize: 16.0, color: Colors.black,
                      ), textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(
                      "5. Pada halaman Check out terdapat dua list yaitu list data penerima dan list tanaman yang akan dibeli. pada halaman ini anda diwajibkan untuk mengisi satu data penerima saja, untuk mengisi data penerima, tekan icon plus. jika data penerima belum diisi atau lebih dari dua, maka tidak bisa melanjutkan ke proses selanjutnya."+
                      "jika sudah mengisi data penerima tekan tombol payment di bagian bawah." ,
                      style: new TextStyle(
                        fontSize: 16.0, color: Colors.black,
                      ), textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(
                      "6. pada halaman payment anda harus memilih metode pembayaran, terdapat metode pembayaran transfer bank manual dan terdapat metode pembayaran cash on delivey, jika anda memilih metode pembayaran transfer bank manual." +
                      " maka anda akan beralih ke halaman transfer bank manual untuk mengirim foto bukti pembayaran, jika memilih metode pembayaran cash on delivery maka anda akan dialihkan ke halaman pembelian tanaman untuk melihat informasi apakah telah di verifikasi oleh admin atau belum"+
                      " untuk transfer bank manual, jika anda telah mengirim foto bukti pembayaran maka akan dialihkan ke halaman pembelian tanaman untuk melihat informasi apakah pemesanan telah diverifikasi atau belum.",
                      style: new TextStyle(
                        fontSize: 16.0, color: Colors.black,
                      ), textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(
                      "7. Pada halaman pembelian tanaman jika pemesanan produk telah diverifikasi oleh admin, maka admin akan segera mengirim ke alamat yang tertera pada data penerima. jika telah diverifikasi tampilan pembelian tanaman akan berubah yang dimana perubahan tersebut menampilkan informasi pemesanan produk." ,
                      style: new TextStyle(
                        fontSize: 16.0, color: Colors.black,
                      ), textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
        )
        );
        // body: Container(
        //   child: Column(
        //     children: <Widget>[
        //       Padding(
        //         padding: const EdgeInsets.all(16.0),
        //         child: Text(
        //           'Pada saat ingin melakukan pembelian tanaman hias, pelanggan dapat memilih sesuai kategori yang ada pada menu utama halaman. untuk membeli tanaman berikut adalah tata cara pembelian : ',
        //           textAlign: TextAlign.justify,
        //         ),
        //       ),
           
        //     ],
        //   ),

        // ));
  }
}
