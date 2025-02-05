<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Home";

$templateParams["nome"] = "home_content.php";
$templateParams["giochi-in-offerta"] = $dbh->getDiscountedGames(5);
$templateParams["giochi-in-evidenza"] = $dbh->getRelevantGames(10);
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["offerte-di-lancio"] = $dbh->getDiscountedRelevantGames(3);
$templateParams["giochi-amati"]= $dbh->getMostRatedGames(5);
$templateParams["giochi-acquistati"]= $dbh->getMostSoldGames(5);

$templateParams["scripts"] = ["../js/front-page-game.js", "../js/most-sold-loved-games.js", "../js/launch-offers.js"];

require("template/base.php");
?>