<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Orders";

$templateParams["nome"] = "order_page.php";

if(!empty($_SESSION["Username"])) {

    if($_SESSION["isAdmin"]) {
        // Define available statuses

    $templateParams["orders"] = $dbh->getAvailableOrders();

    $availableStatuses = ["Canceled", "Pending", "Shipped", "Completed"];

    // Add the availableStatuses array to each order
    foreach ($templateParams["orders"] as &$order) {
        $currentStatus = $order["Status"];
        $order["availableStatuses"] = array_filter($availableStatuses, function($status) use ($currentStatus) {
            return $status !== $currentStatus;
        });
    }
    unset($order); // Unset reference after modifying the array
        
    }
    else{
    $templateParams["orders"] = $dbh->getOrdersForUser($_SESSION["UserID"]);
    }
    require("template/base.php");
}
else {
    header("Location: login.php");
    exit;
}

?>