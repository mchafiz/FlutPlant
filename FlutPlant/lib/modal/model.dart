class Posts {
  final String id;
  final String namaProduk;
  final String qty;
  final String harga;
  final String kategori;
  final String deskripsi;
  final String createdDate;
  final String idUsers;
  final String image;
  final String nama;
  Posts({this.id, this.namaProduk, this.qty, this.harga, this.kategori, this.deskripsi, this.createdDate, this.idUsers, this.image,this.nama});

  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
       id: json['id'],
       namaProduk: json['namaProduk'],
       qty: json['qty'],
       harga: json['harga'],
       kategori: json['kategori'],
       deskripsi: json['deskripsi'],
       createdDate: json['createdDate'],
       idUsers: json['idUsers'],
       image: json['image'],
       nama: json['nama'],
    );
  }
}
