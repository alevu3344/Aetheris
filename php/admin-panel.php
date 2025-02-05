<?php
require_once("bootstrap.php");


$category = $_GET["category"] ?? $_GET["category"] ?? "Horror";



$templateParams["categorie"] = $dbh->getCategories();

$templateParams["giochi"] = $dbh->getGamesByCategory($category, null, true);

$templateParams["publishers"] = $dbh->getPublishers();




$templateParams["titolo"] = "Aetheris - Admin Panel";

if(isset($_GET["game_id"])) {
    $game_id = $_GET["game_id"];
    $templateParams["giochi"] = $dbh->getGameById($game_id, true);
}

$templateParams["nome"] = "admin-content.php";

$publisherList = $templateParams["publishers"];
$publisherJson = json_encode($publisherList);

// Make sure to encode the JSON string for use in the URL
$publisherJsonEscaped = urlencode($publisherJson);

$categorieList = $templateParams["categorie"];
$categorieJson = json_encode($categorieList);

// Make sure to encode the JSON string for use in the URL
$categorieJsonEscaped = urlencode($categorieJson);


$templateParams["scripts"]= ["../js/admin-panel.js?publishers=" . $publisherJsonEscaped . "&categories=" . $categorieJsonEscaped ];

if(!empty($_SESSION["Username"]) && $_SESSION["isAdmin"]) {
    require("template/base.php");
}
else {
    header("Location: login.php");
    exit;
}

?>