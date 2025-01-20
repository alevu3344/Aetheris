<?php
require_once("bootstrap.php");


$_GET["id"] = 1;

$templateParams["gioco"] = $dbh->getGameById($_GET["id"]);
//il titolo della pagina è composto da "Aetheris - {GameName}"
$templateParams["titolo"] = "Aetheris - " . $templateParams["gioco"]["Name"];

$templateParams["nome"] = "game_content.php";
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["recensioni"] = $dbh->getReviewsByGame($_GET["id"]);




require("template/base.php");
?>