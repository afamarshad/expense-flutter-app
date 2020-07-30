<?php
    include("connection.php");
    $catname = $_GET['catyname'];
    $query = $pdo->prepare("INSERT INTO category (`category_name`) VALUES (:catname)");
    $query->execute([
        'catname' => strval($catname)
        ]);
    if ($pdo->lastInsertId()) {
        echo "<script>alert('Item Added!');</script>";
    }
    else{
        echo "<script>alert('Unable to add Item!');</script>";
    }
?>