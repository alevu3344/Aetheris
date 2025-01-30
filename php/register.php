<?php
require_once("bootstrap.php");

$templateParams["titolo"] = "Aetheris - Register";

$templateParams["nome"] = "registration-form.php";

$templateParams["Avatars"] = $dbh->getAvatars();


require("template/base.php");
?>