<?php
require_once("bootstrap.php");


$_GET["OrderID"] = 1;

$user = $dbh->getUser($_SESSION["UserID"]);

$templateParams["Ordine"] = $dbh->getOrdersForUser($_SESSION["UserID"]);
$templateParams["nome"] = "null_rightnow.php";





require("template/base.php");
?>