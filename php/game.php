<?php
require_once("bootstrap.php");


$gameid = $_GET["id"];

$templateParams["gioco"] = $dbh->getGameById($gameid);
//il titolo della pagina è composto da "Aetheris - {GameName}"
$templateParams["titolo"] = "Aetheris - " . $templateParams["gioco"]["Name"];

$templateParams["nome"] = "game_content.php";
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["recensioni"] = $dbh->getReviewsByGame($gameid);

$templateParams["platforms"] = $dbh->getSupportedPlatforms($gameid);

$templateParams["requirements"] = $dbh->getGameRequirements($gameid);

$templateParams["game-categories"] = $dbh->getGameCategories($gameid);

$templateParams["similar-games"] = $dbh->getSimilarGames($gameid, 4);




require("template/base.php");
?>