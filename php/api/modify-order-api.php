<?php

require_once '../bootstrap.php';

$result["Error"] = "Error modifying order";
$result["Success"] = false;

if(isset($_POST["OrderId"]) && isset($_POST["Status"])) {
    $OrderId = $_POST["OrderId"];
    $Status = $_POST["Status"];

    $result["Error"] = "You aren't admin";

    if(isUserLoggedIn() && $_SESSION["isAdmin"]) {
        $result["Error"] = "Error modifying order with id $OrderId to Status $Status";

        if($dbh->modifyOrderStatus($OrderId, $Status)) {
            $result["Success"] = true;
            $result["Error"] = "";
        }
    }
}

header('Content-Type: application/json');
echo json_encode($result);