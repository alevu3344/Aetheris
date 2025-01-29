<?php

require_once("utils/functions.php");
require_once("db/database.php");
$dbh = new DatabaseHelper("localhost", "root", "", "AetherisDB", 3306);
define("GAME_COVERS", "../media/");
define("GAME_IMAGES", "../media/screenshots/");
sec_session_start();


?>