<?php

require "../config/connect.php";

$response = array();
$idUsers = $_GET['idUsers'];

$sql = mysqli_query($con, "SELECT harga * jumlah AS totalharga FROM `keranjang` WHERE idUsers = '$idUsers'");
while ($a = mysqli_fetch_array($sql)){
    $b['totalharga']= $a['totalharga'];
    array_push($response, $b);
}

echo json_encode($response);

?>