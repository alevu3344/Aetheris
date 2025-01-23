<?php
require_once("bootstrap.php");


$gameId = 3;

$templateParams["gioco"] = $dbh->getGameById($gameId);

$templateParams["nome"] = "popup.php";


require("template/base.php");
?>