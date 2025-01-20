<?php
require_once("bootstrap.php");

//il titolo della pagina è composto da "Aetheris - " e il nome della categoria
$_GET["nome-categoria"] = "Action/Adventure";

$templateParams["titolo"] = "Aetheris - ".$_GET["nome-categoria"];

$templateParams["nome"] = "categorygames_content.php";
$templateParams["categorie"] = $dbh->getCategories();
$templateParams["giochi"] = $dbh->getGamesByCategory($_GET["nome-categoria"], 10);



require("template/base.php");
?>