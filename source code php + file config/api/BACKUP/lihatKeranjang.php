<?php

require "../config/connect.php";


$response = array();
$idUsers = $_GET['idUsers'];

$sql = mysqli_query($con, "SELECT count(*) jumlah FROM `keranjang` WHERE idUsers = '$idUsers'");
while ($a = mysqli_fetch_array($sql)){
    $b['jumlah']= $a['jumlah'];
  
    
    array_push($response, $b);
}

echo json_encode($response);

?>