<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    #code.....
    $response = array();
    $idUsers = $_POST['idUsers'];
    $idProduk = $_POST['idProduk'];
    $harga  = $_POST['harga'];

   

        $insert = "INSERT INTO verifykeranjang VALUE(NULL, '$idUsers','$idProduk','1','$harga',NOW())";
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