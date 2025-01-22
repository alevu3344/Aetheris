<?php
require_once 'bootstrap.php';

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);


$result["LoggedIn"] = false;


if(isset($_POST["Username"]) && isset($_POST["Password"])){
    $login_result = $dbh->login($_POST["Username"], $_POST["Password"]);
    if(!$login_result){
        //Login fallito
        $result["ErroreLogin"] = "Username e/o password errati";
    }
}

if(isUserLoggedIn()){
    $result["LoggedIn"] = true;
    $result["Username"] = $_SESSION["Username"];
    $result["UserID"] = $_SESSION["UserID"];
    $result["Avatar"] = $dbh->getUser($_SESSION["UserID"])["Avatar"];
}

header('Content-Type: application/json');
echo json_encode($result);





?>