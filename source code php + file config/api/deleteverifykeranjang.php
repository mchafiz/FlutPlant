<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    #code.....
    $response = array();
    $idUsers = $_POST['idUsers'];
		
    
        $insert = "DELETE FROM verifykeranjang WHERE idUsers='$idUsers'";
        if (mysqli_query($con, $insert)){
            $response['value']=1;
            $response['message']="Berhasil Di hapus";
            
            echo json_encode($response);
            
        }else {
            $response['value']=0;
            $response['message']='Gagal Di Hapus';
            echo json_encode($response); 
    
        }
    }

   


?>