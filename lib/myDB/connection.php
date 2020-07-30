<?php

$pdo = new PDO('mysql:host=localhost;dbname=id10370550_expense', 'id10370550_afsah', 'abc123');
if($pdo)
{
    print_r("Connection established!!");
}
else {
    print_r("Unable to establish connection!!");
}

?>