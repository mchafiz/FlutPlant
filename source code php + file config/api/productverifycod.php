<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    #code.....
    $response = array();
    $idUsers = $_POST['idUsers'];

        $insert = "INSERT INTO verifykeranjangcod (idUsers, idProduk,qty,harga,createdDate) SELECT idUsers, idProduk, qty,harga,createdDate FROM keranjang WHERE idUsers = '$idUsers'";
        if (mysqli_query($con, $insert)){
            $response['value']=1;
            $response['message']="Berhasil DITAMBAHKAN";
            
            echo json_encode($response);
            
        }else {
            $response['value']=0;
            $response['message']='Gagal DITAMBAHKAN';
            echo json_encode($response); 
    
        }
    }

   


?>