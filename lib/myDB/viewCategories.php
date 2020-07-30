<?php
    require("connection.php");
    $statement = $pdo->prepare("SELECT * from category");
    $statement->execute();
    
    $myarray = array();

    while($result = $statement ->fetch()){
        array_push(
            $myarray,array(
                "category_id"=>$result['category_id'],
                "category_name"=>$result['category_name']
            )
        );
    }

    echo json_encode($myarray);

?>