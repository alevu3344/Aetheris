<?php
    require_once("bootstrap.php");
    $templateParams["titolo"] = "Aetheris - Notifications";
    $templateParams["nome"] = "user-notifications.php";
    $templateParams["notifications"] = $dbh->getNotifications($_SESSION["UserID"]);
    require("template/base.php");
?>