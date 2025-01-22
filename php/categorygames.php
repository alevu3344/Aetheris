<?php
require_once("bootstrap.php");

$templateParams["categorie"] = $dbh->getCategories();

$category = $_GET["category"] ?? $templateParams["categorie"][0]["CategoryName"];

$templateParams["titolo"] = "Aetheris - ".$category;

$templateParams["nome"] = "categorygames_content.php";

$templateParams["giochi"] = $dbh->getGamesByCategory($category, 10);



require("template/base.php");
?>