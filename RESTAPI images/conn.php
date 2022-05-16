<?php
    $connect =new mysqli("localhost","root","","my_store");

    if($connect)
    {
        echo "Connection Succed";
    }else{
        echo "Connection Failed";
    }
?>