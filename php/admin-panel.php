<?php
require_once("bootstrap.php");

$_GET["category"] = "Horror";

$category = $_GET["category"];

$templateParams["categorie"] = $dbh->getCategories();

$templateParams["giochi-di-categoria"] = $dbh->getGamesByCategory($category, 10);

$templateParams["giochi"] = $dbh -> getMostRatedGames(10);

$templateParams["titolo"] = "Aetheris - Admin Panel";

$templateParams["nome"] = "admin-content.php";


require("template/base.php");
?>