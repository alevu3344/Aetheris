<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Home";

$templateParams["nome"] = "home_content.php";
$templateParams["giochi-in-offerta"] = $dbh->getDiscountedGames();
$templateParams["giochi-in-evidenza"] = $dbh->getRelevantGames(5);
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["offerte-di-lancio"] = $dbh->getLaunchOffers(3);
$templateParams["giochi-amati"]= $dbh->getMostRatedGames(3);


foreach ($templateParams["giochi-amati"] as $game): 
    echo json_encode($game["Id"]);
    foreach ($game["Platforms"] as $platform): 
        echo json_encode($platform["Platform"]);
    endforeach;

endforeach;


require("template/base.php");
?>