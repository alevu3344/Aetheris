<?php

require_once("../bootstrap.php");



// Ensure the user is logged in and has admin privileges
if (empty($_SESSION["Username"])) {
    $result = ['success' => false, 'message' => 'not_logged'];
} elseif (!$_SESSION["isAdmin"]) {
    $result = ['success' => false, 'message' => 'not_admin'];
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $requiredFields = ["GameId", "Field", "Value"];

    foreach ($requiredFields as $field) {
        if (!isset($_POST[$field])) {
            $result = ['success' => false, 'message' => 'missing_field: ' . $field];
            header('Content-Type: application/json');
            echo json_encode($result);
            exit;
        }
    }



    $gameId = $_POST["GameId"];
    $field = $_POST["Field"];
    $value = $_POST["Value"];

    



    //debug
    $result = ['success' => true, 'message' => 'gameId: ' . $gameId . ' field: ' . $field . ' value: ' . $value];

    //$success = $dbh->modifyGame($gameId, $field, $value);
}
header("Content-type: application/json");
echo json_encode($result);
?>