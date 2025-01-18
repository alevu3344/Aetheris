<?php
require_once("bootstrap.php");



$templateParams["titolo"] = "Aetheris - Your Cart";

$templateParams["nome"] = "shoppingcart_items.php";


//a map between a game and its quantity in the shopping cart
//$templateParams["elementi-carrello"] = $dbh->getShoppingCart($_SESSION["idUtente"]);



require("template/base.php");
?>