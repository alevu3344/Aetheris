<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Home";

$templateParams["nome"] = "home_content.php";
$templateParams["giochi-in-offerta"] = $dbh->getDiscountedGames(5);
$templateParams["giochi-in-evidenza"] = $dbh->getRelevantGames(5);
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["offerte-di-lancio"] = $dbh->getLaunchOffers(3);
$templateParams["giochi-amati"]= $dbh->getMostRatedGames(5);

require("template/base.php");
?>