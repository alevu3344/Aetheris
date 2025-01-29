<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - New Game";

$templateParams["nome"] = "game_form.php";

$templateParams["categorie"] = $dbh->getCategories();

$templateParams["piattaforme"] = ["PC", "Xbox", "PlayStation","Nintendo Switch"];

require("template/base.php");
?>