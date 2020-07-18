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
 

        $insert = "INSERT INTO alamatuser VALUE(NULL, '$namaPenerima','$alamat','$kotkec','$pos','$nomorhp','$idUsers')";
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