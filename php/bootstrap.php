<?php

require_once("utils/functions.php");
require_once("db/database.php");
$dbh = new DatabaseHelper("localhost", "root", "", "AetherisDB", 3306);
//define("GAME_COVERS", "/opt/lampp/htdocs/e-shop/media/covers/");
//define("GAME_IMAGES", "/opt/lampp/htdocs/e-shop/media/screenshots/");




sec_session_start();

$BALANCE = null;
$AVATAR = null;
if(isset($_SESSION["UserID"])){
    $BALANCE = $dbh->getUser($_SESSION["UserID"])["Balance"];
    $AVATAR = $dbh->getUser($_SESSION["UserID"])["Avatar"];
}


?>