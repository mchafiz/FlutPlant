<?php

require "../config/connect.php";

$response = array();
$idUsers = $_GET['idUsers'];


$sql = mysqli_query($con, "SELECT a.*, b.nama FROM alamatuser a left join users b on a.idUsers = b.id WHERE a.idUsers= '$idUsers'");
while ($a = mysqli_fetch_array($sql)){
    $b['id']= $a['id'];
    $b['namaPenerima']= $a['namaPenerima'];
    $b['alamat']= $a['alamat'];
    $b['kotkec']= $a['kotkec'];
    $b['pos']= $a['pos'];
    $b['nomorhp']= $a['nomorhp'];
    
    array_push($response, $b);
}

echo json_encode($response);

?>