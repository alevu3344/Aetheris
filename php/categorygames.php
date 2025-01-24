<?php
require_once("bootstrap.php");

$templateParams["action"] = $_GET["action"] ?? "tendenza";
$category = $_GET["category"] ?? "Action/Adventure";

if($templateParams["action"] == "tendenza"){
    $templateParams["giochi"] = $dbh->getMostSoldGamesByCategory(10, $category);
    $templateParams["titolo"] = "Aetheris - Tendenza";
}
else if($templateParams["action"] == "nuoveuscite"){
    $templateParams["giochi"] = $dbh->getNewGamesByCategory(10, $category);
    $templateParams["titolo"] = "Aetheris - Nuove Uscite";
}
else if($templateParams["action"] == "migliori"){
    $templateParams["giochi"] = $dbh->getMostRatedGamesbyCategory(10, $category);
    $templateParams["titolo"] = "Aetheris - Migliori";
}
else if($templateParams["action"] == "offerte"){
    $templateParams["giochi"] = $dbh->getDiscountedGamesByCategory(10, $category);
    $templateParams["titolo"] = "Aetheris - Offerte";
}


$templateParams["categorie"] = $dbh->getCategories();



$templateParams["category"] = $category;

$templateParams["titolo"] = "Aetheris - ".$category;

$templateParams["nome"] = "categorygames_content.php";




require("template/base.php");
?>