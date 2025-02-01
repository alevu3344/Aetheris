<?php

require_once '../bootstrap.php';



if (isset($_POST["Platform"]) && isset($_POST["GameId"]) && isset($_POST["Action"])) {

    $platform = $_POST["Platform"];
    $gameId = $_POST["GameId"];
    $action = $_POST["Action"];

    $result =  $dbh->modifyPlatformsOfGame($platform, $gameId, $action);
} else {
    $result = ["success" => false, "message" => "missing_params"];
}

header('Content-Type: application/json');
echo json_encode($result);
