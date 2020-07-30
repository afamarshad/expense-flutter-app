<?php
    include("connection.php");
    $expenseTitle = $_GET['title'];
    $expenseAmount = $_GET['amount'];
    $date = $_GET['date'];
    $category = $_GET['category'];

    $statement = $pdo->prepare("SELECT category_id from category WHERE category_name=:catname");
    $statement->execute([
        'catname' => strval($category)
    ]);
    $categoryID = $statement->fetch();
    
    echo $categoryID;

    // $query = $pdo->prepare("INSERT INTO expense (`expense_title`,`expense_amount`,`expense_date`,`category_id`) VALUES (:title,:amount,:dat,:catid)");
    // $query->execute([
    //     'title' => strval($expenseTitle),
    //     'amount' => doubleval($expenseAmount),
    //     'dat' => ($date),
    //     'catid' => intval($categoryID)
    //     ]);
    // if ($pdo->lastInsertId()) {
    //     echo "<script>alert('Item Added!');</script>";
    // }
    // else{
    //     echo "<script>alert('Unable to add Item!');</script>";
    // }
?>