<?php

require "../config/connect.php";

$response = array();
$idUsers = $_GET['idUsers'];


$sql = mysqli_query($con, "SELECT a.*, b.username, b.nama FROM bukti a left join users b on a.idUsers = b.id WHERE a.idUsers = '$idUsers'");
while ($a = mysqli_fetch_array($sql)){
    $b['id']= $a['id'];
    $b['image'] = $a['image'];	
	$b['createdDate'] = $a['createdDate'];
	$b['status'] = $a['status'];
    $b['idUsers']= $a['idUsers'];
	$b['username'] = $a['username'];
	$b['nama'] = $a['nama'];
	
    array_push($response, $b);
}

echo json_encode($response);

?>