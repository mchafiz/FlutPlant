<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    #code.....
    $response = array();
    $idUsers = $_POST['idUsers'];
    $idProduk1 = $_POST['idProduk'];
    $harga1  = $_POST['harga'];

   

        $insert = "INSERT INTO favorite VALUE(NULL, '$idUsers','$idProduk1','1','$harga1',NOW())";
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