<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Orders";

$templateParams["nome"] = "order_page.php";

$templateParams["scripts"] = ["../js/orders.js"];

$orderId = $_GET["orderId"] ?? null;

$templateParams["scripts"] = ["../js/orders.js"];

if (isset($orderId)) {
    $templateParams["orders"] = $dbh->getOrderById($orderId);
    require("template/base.php");
} else {

    if (!empty($_SESSION["Username"])) {

        if ($_SESSION["isAdmin"]) {
            // Define available statuses

            $templateParams["orders"] = $dbh->getAvailableOrders();
        } else {
            $templateParams["orders"] = $dbh->getOrdersForUser($_SESSION["UserID"]);
        }
        require("template/base.php");
    } else {
        header("Location: login.php");
        exit;
    }
}
