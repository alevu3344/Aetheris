<?php

require_once 'bootstrap.php';

$result["Error"] = "Error even before checking if logged in";

if(isUserLoggedIn()){
    session_destroy();
    $result["Success"] = "Logout successful";
}
else{
    $result["Error"] = "Logout called without being logged in!!!!";

}

header('Content-Type: application/json');
echo json_encode($result);