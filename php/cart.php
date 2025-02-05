<?php
require_once("bootstrap.php");



$templateParams["titolo"] = "Aetheris - Your Cart";

$templateParams["nome"] = "shoppingcart_items.php";

$templateParams["scripts"] = ["../js/cart.js"];



$templateParams["elementi-carrello"] = $dbh->getShoppingCart($_SESSION["UserID"]);



require("template/base.php");
?>