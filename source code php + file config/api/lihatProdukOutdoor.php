<?php

require "../config/connect.php";

$response = array();



$sql = mysqli_query($con, "SELECT a.*, b.nama FROM produk a left join users b on a.idUsers = b.id WHERE kategori = 'tanaman outdoor'");
while ($a = mysqli_fetch_array($sql)){
    $b['id']= $a['id'];
    $b['namaProduk']= $a['namaProduk'];
    $b['qty']= $a['qty'];
    $b['harga']= $a['harga'];
	$b['kategori']= $a['kategori'];
	$b['deskripsi']= $a['deskripsi'];
    $b['createdDate']= $a['createdDate'];
    $b['idUsers']= $a['idUsers'];
	$b['nama']= $a['nama'];
    $b['image']=$a['image'];
    
    
    array_push($response, $b);
}

echo json_encode($response);

?>