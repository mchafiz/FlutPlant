<?php

require "../config/connect.php";

$response = array();

$sql = mysqli_query($con, "SELECT a.*, b.namaProduk, b.kategori, b.image FROM verifykeranjangcod a left join produk b on a.idProduk = b.id");
while ($a = mysqli_fetch_array($sql)){
    $b['id']= $a['id'];
    $b['idUsers']= $a['idUsers'];
	$b['idProduk']= $a['idProduk'];
    $b['qty']= $a['qty'];
    $b['harga']= $a['harga'];
	$b['kategori']= $a['kategori'];
    $b['createdDate']= $a['createdDate'];
    $b['namaProduk']= $a['namaProduk'];
    $b['image']=$a['image'];
 
    array_push($response, $b);
}

echo json_encode($response);

?>