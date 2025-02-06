<?php
require_once("bootstrap.php");
$templateParams["titolo"] = "Aetheris - Notifications";
$templateParams["nome"] = "user-notifications.php";

$templateParams["scripts"] = ["../js/notifications.js"];
if (isset($_SESSION["UserID"])) {
    $templateParams["notifications"] = $dbh->getNotifications($_SESSION["UserID"]);
}
require("template/base.php");
