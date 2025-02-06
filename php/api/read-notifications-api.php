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


if(isset($_POST['Id'])) {
    $notification_id = $_POST['Id'];

    
    $dbh -> markNotificationAsRead($notification_id);

    $result = [
        'success' => true,
        'message' => 'read'
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