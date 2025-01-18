<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Home";

$templateParams["nome"] = "home_content.php";
$templateParams["giochi-in-offerta"] = $dbh->getDiscountedGames();
$templateParams["giochi-in-evidenza"] = $dbh->getRelevantGames(5);

require("template/base.php");
?>