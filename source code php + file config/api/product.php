<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    #code.....
    $response = array();
    $namaProduk = $_POST['namaProduk'];
    $qty = $_POST['qty'];
    $harga = $_POST['harga'];
    $kategori = $_POST['kategori'];
	$deskripsi = $_POST['deskripsi'];
    $idUsers = $_POST['idUsers'];

    $image =  date('dmYHis').str_replace(" ","", basename($_FILES['image']['name']));
    $imagepath = "../upload/".$image;
    move_uploaded_file($_FILES['image']['tmp_name'], $imagepath);  

        $insert = "INSERT INTO produk VALUE(NULL, '$namaProduk','$qty','$harga','$kategori','$deskripsi','$image',NOW(),'$idUsers')";
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