<?php

require "../config/connect.php";

$response = array();
$idUsers = $_GET['idUsers'];


$sql = mysqli_query($con, "SELECT a.*, (a.qty*a.harga) as total , b.namaProduk, b.kategori, b.image FROM keranjang a left join produk b on a.idProduk = b.id WHERE a.idUsers = '$idUsers'");
while ($a = mysqli_fetch_array($sql)){
    $b['id']= $a['id'];
    $b['idUsers']= $a['idUsers'];
	$b['idProduk']= $a['idProduk'];
    $b['qty']= $a['qty'];
    $b['harga']= $a['harga'];
	$b['kategori']= $a['kategori'];
    $b['createdDate']= $a['createdDate'];
	$b['total']= $a['total'];
    $b['namaProduk']= $a['namaProduk'];
    $b['image']=$a['image'];
 
    
    array_push($response, $b);
}

echo json_encode($response);

?>