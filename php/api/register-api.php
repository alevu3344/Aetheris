<?php
require_once '../bootstrap.php';


$result["Errore"] = "";
$result["Success"] = false;


if(isset($_POST["Username"]) && isset($_POST["Email"]) 
&& isset($_POST["Password"]) && isset($_POST["FirstName"]) 
&& isset($_POST["LastName"]) && isset($_POST["PhoneNumber"]) 
&& isset($_POST["Address"]) && isset($_POST["City"]) 
&& isset($_POST["DateOfBirth"]) && isset($_POST["AvatarId"])){
    $Userdata = array(
        "Username" => $_POST["Username"],
        "Email" => $_POST["Email"],
        "Password" => $_POST["Password"],
        "FirstName" => $_POST["FirstName"],
        "LastName" => $_POST["LastName"],
        "PhoneNumber" => $_POST["PhoneNumber"],
        "Address" => $_POST["Address"],
        "City" => $_POST["City"],
        "DateOfBirth" => $_POST["DateOfBirth"],
        "AvatarId" => $_POST["AvatarId"]
    );
    $register_result = $dbh->registerNewUser($Userdata);
    if(!$register_result){
        //Login fallito
        if($Userdata["Username" == "admin"]){
            $result["isAdmin"] = true;
        }
        $result["Errore"] = "Username e/o Email già in uso";
    }
    else {
        $result["Success"] = true;
    }
}

if($result["Errore"] === "" && $result["Success"] === false){
    $result["Errore"] = "Internal error";
} 
else {
    //call to login-api.php
    $login_result = $dbh->login($_POST["Username"], $_POST["Password"]);
    if(isUserLoggedIn()){
        $result["LoggedIn"] = true;
        $result["Username"] = $_SESSION["Username"];
        $result["UserID"] = $_SESSION["UserID"];
        $result["isAdmin"] = $_SESSION["isAdmin"];
    }
}

header('Content-Type: application/json');
echo json_encode($result);





?>