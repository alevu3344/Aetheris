<?php

require_once("utils/functions.php");
require_once("db/database.php");

$db_host = getenv('DB_HOST') ?: "localhost";
$db_user = getenv('DB_USER') ?: "root";
$db_pass = getenv('DB_PASS') ?: "";
$db_name = getenv('DB_NAME') ?: "AetherisDB";

$dbh = new DatabaseHelper($db_host, $db_user, $db_pass, $db_name, 3306);
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