<?php
    require("connection.php");
    $statement = $pdo->prepare("SELECT expenses.expense_title,
    expenses.expense_amount,expenses.expense_date,category.category_name from expenses JOIN 
    category ON expenses.category_id = category.category_id");
    $statement->execute();
    
    $myarray = array();

    while($result = $statement ->fetch()){
        array_push(
            $myarray,array(
                "expense_title"=>$result['expense_title'],
                "expense_amount"=>$result['expense_amount'],
                "expense_date"=>$result['expense_date'],
                "category_name"=>$result['category_name']
            )
        );
    }

    echo json_encode($myarray);

?>