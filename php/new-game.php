<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - New Game";

$templateParams["nome"] = "game_form.php";

$templateParams["categorie"] = $dbh->getCategories();

$templateParams["publishers"] = $dbh->getPublishers();

$templateParams["piattaforme"] = ["PC", "Xbox", "PlayStation","Nintendo_Switch"];

$templateParams["scripts"] = ["../js/newgame.js"];

require("template/base.php");
?>