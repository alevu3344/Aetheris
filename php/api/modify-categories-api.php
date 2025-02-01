<?php

require_once '../bootstrap.php';



if (isset($_POST["Category"]) && isset($_POST["GameId"]) && isset($_POST["Action"])) {

    $category = $_POST["Category"];
    $gameId = $_POST["GameId"];
    $action = $_POST["Action"];

    $result =  $dbh->modifyCategoriesOfGame($category, $gameId, $action);
} else {
    $result = ["success" => false, "message" => "missing_params"];
}

header('Content-Type: application/json');
echo json_encode($result);
