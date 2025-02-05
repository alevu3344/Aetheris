<?php
require_once("bootstrap.php");


$gameid = $_GET["id"];


$templateParams["gioco"] = $dbh->getGameById($gameid)[0];

//il titolo della pagina è composto da "Aetheris - {GameName}"
$templateParams["titolo"] = "Aetheris - " . $templateParams["gioco"]["Name"];

$templateParams["nome"] = "game_content.php";
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["recensioni"] = $dbh->getReviewsByGame($gameid);

$templateParams["platforms"] = $dbh->getSupportedPlatforms($gameid);



$templateParams["requirements"] = $dbh->getGameRequirements($gameid);

$templateParams["game-categories"] = $dbh->getGameCategories($gameid);

$templateParams["similar-games"] = $dbh->getSimilarGames($gameid, 4);



if(isset($_GET["admin"]) && $_GET["admin"] == "true" && isset($_GET["id"])) {
    //redirect to admin panel
    header("Location: admin-panel.php?game_id=" . $_GET["id"]);
    exit;
}

$templateParams["scripts"] = ["../js/game.js?gameData=" . urlencode(json_encode([
    "game" => $templateParams["gioco"],
    "platforms" => $templateParams["platforms"]
])), "../js/similar-games.js?id=" . $gameid];



require("template/base.php");
?>