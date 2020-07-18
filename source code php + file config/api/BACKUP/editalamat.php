<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    #code.....
    $response = array();
    $namaPenerima = $_POST['namaPenerima'];
    $alamat = $_POST['alamat'];
    $kotkec = $_POST['kotkec'];
	$pos = $_POST['pos'];
	$nomorhp = $_POST['nomorhp'];
    $idUsers = $_POST['idUsers'];

    
        $insert = "UPDATE alamatuser SET namaPenerima = '$namaPenerima', alamat='$alamat', kotkec='$kotkec', pos='$pos', nomorhp = '$nomorhp' WHERE id='$idUsers'";
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