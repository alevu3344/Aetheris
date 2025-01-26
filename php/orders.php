<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Orders";

$templateParams["nome"] = "order_page.php";

if(!empty($_SESSION["Username"])) {
    $templateParams["orders"] = $dbh->getOrdersForUser($_SESSION["UserID"]);
    require("template/base.php");
}
else {
    header("Location: login.php");
    exit;
}

?>