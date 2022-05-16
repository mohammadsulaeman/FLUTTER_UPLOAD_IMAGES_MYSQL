<?php
    include 'conn.php';

    $image = $_FILES['image']['name'];

    $title = $_POST['title'];
    $imagePath = "uploads/".$image;

    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

    $connect->query("INSERT INTO tb_images (title,image) VALUES ('".$title."','".$image."')")

?>