<?php
require_once("bootstrap.php");


$templateParams["titolo"] = "Aetheris - ".$_GET["category"];

$templateParams["nome"] = "categorygames_content.php";
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["giochi"] = $dbh->getGamesByCategory($_GET["category"], 10);



require("template/base.php");
?>