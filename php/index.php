<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Home";

$templateParams["nome"] = "home_content.php";
$templateParams["giochi-in-offerta"] = $dbh->getDiscountedGames(5);
$templateParams["giochi-in-evidenza"] = $dbh->getRelevantGames(10);
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["offerte-di-lancio"] = $dbh->getLaunchOffers(3);
$templateParams["giochi-amati"]= $dbh->getMostRatedGames(5);
$templateParams["giochi-acquistati"]= $dbh->getMostSoldGames(5);
$templateParams["giochi-ultimi-usciti"]= $dbh->getRelevantGames(5);

require("template/base.php");
?>