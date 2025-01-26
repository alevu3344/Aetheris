<?php
require_once("bootstrap.php");


$category = $_GET["category"] ?? $_GET["category"] ?? "Horror";

$templateParams["categorie"] = $dbh->getCategories();

$templateParams["giochi"] = $dbh->getGamesByCategory($category, 10);


$templateParams["titolo"] = "Aetheris - Admin Panel";

$templateParams["nome"] = "admin-content.php";

if(!empty($_SESSION["Username"]) && $_SESSION["isAdmin"]) {
    require("template/base.php");
}
else {
    header("Location: login.php");
    exit;
}

?>