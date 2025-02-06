<?php
require_once '../bootstrap.php';


//se $_SESSION["Username"] è vuoto, restuisce errore
if(empty($_SESSION["Username"])) {
    $result = [
        'success' => false,
        'message' => 'not_logged'
    ];
    header('Content-Type: application/json');
    echo json_encode($result);
    exit;
}


if(isset($_POST['OrderId'])) {
    $orderId = $_POST['OrderId'];

    
    $nextStatus = $dbh -> advanceOrder($orderId);

    $result = [
        'success' => true,
        'message' => $nextStatus
    ];
}
else {
    $result = [
        'success' => true,
        'message' => 'post_not_set'
    ];
}
        

header('Content-Type: application/json');
echo json_encode($result);





?>