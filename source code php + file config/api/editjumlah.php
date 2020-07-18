<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    #code.....
    $response = array();
    $qty = $_POST['qty'];
    $idProduk = $_POST['idProduk'];

    
        $insert = "UPDATE keranjang SET qty='$qty' WHERE id='$idProduk'";
        if (mysqli_query($con, $insert)){
            $response['value']=1;
            $response['message']="Berhasil Di edit";
            
            echo json_encode($response);
            
        }else {
            $response['value']=0;
            $response['message']='Gagal Di Edit';
            echo json_encode($response); 
    
        }
    }

   


?>