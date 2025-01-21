<?php
require_once 'bootstrap.php';

$result["LoggedIn"] = false;

if(isset($_POST["Username"]) && isset($_POST["Password"])){
    $login_result = $dbh->login($_POST["Username"], $_POST["Password"]);
    if(!$login_result){
        //Login fallito
        $result["errorelogin"] = "Username e/o password errati";
    }
    else{
        registerLoggedUser($login_result[0]);
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