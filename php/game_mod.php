<?php
require_once("bootstrap.php");

$gameId = $_GET["game"];

$templateParams["gioco"] = $dbh->getGameById($gameId);

$templateParams["titolo"] = "Aetheris - Modify Game";

$templateParams["nome"] = "game_form.php";

$templateParams["categorie"] = $dbh->getCategories();

$templateParams["publishers"] = $dbh->getPublishers();

$templateParams["piattaforme"] = ["PC", "Xbox", "PlayStation","Nintendo_Switch"];

$templateParams["scripts"] = ["../js/modify-game.js"];

require("template/base.php");
?>