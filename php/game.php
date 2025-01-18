<?php
require_once("bootstrap.php");


$templateParams["gioco"] = $dbh->getGameById($_GET["id"]);
//il titolo della pagina è composto da "Aetheris - {GameName}"
$templateParams["titolo"] = "Aetheris - " . $templateParams["gioco"]["Name"];

$templateParams["nome"] = "game_content.php";
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["recensioni"] = $dbh->getReviewsByGame($_GET["id"]);

//TODO: aggiungere le piattaforme supportate dal gioco



require("template/base.php");
?>