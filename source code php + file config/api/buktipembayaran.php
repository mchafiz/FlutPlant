<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    #code.....
    $response = array();


    $image =  date('dmYHis').str_replace(" ","", basename($_FILES['image']['name']));
    $imagepath = "../verify/".$image;
    move_uploaded_file($_FILES['image']['tmp_name'], $imagepath);  

        $insert = "INSERT INTO buktipembayarann (createdDate,image) VALUES ('NOW()','".$image."')";
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