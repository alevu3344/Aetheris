<?php

require_once '../bootstrap.php';


// Ensure the user is logged in and has admin privileges
if (empty($_SESSION["Username"])) {
    $result = ['success' => false, 'message' => 'not_logged'];
} elseif (!$_SESSION["isAdmin"]) {
    $result = ['success' => false, 'message' => 'not_admin'];
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if(!isset($_POST["GameId"])){
        $result = ['success' => false, 'message' => 'missing_id'];
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    }

    // Assign POST parameters
    $gameId = $_POST["GameId"];

    // Delete game from the database
    $success = $dbh->deleteGame($gameId);
    if ($success) {
        $result = ['success' => true];
        //delete its cover image and its 4 screenshots
        $cover = "../../media/covers/" . $gameId . ".jpg";
        $screenshots = ["../../media/screenshots/" . $gameId . "frame" . "_1.jpg", 
                        "../../media/screenshots/" . $gameId . "frame" . "_2.jpg",
                        "../../media/screenshots/" . $gameId . "frame" . "_3.jpg", 
                        "../../media/screenshots/" . $gameId . "frame" . "_4.jpg"];
        // Delete cover image if it exists
        if (file_exists($cover)) {
            unlink($cover);
        }

        // Delete screenshots if they exist
        foreach ($screenshots as $screenshot) {
            if (file_exists($screenshot)) {
                unlink($screenshot);
            }
        }
        
    } else {
        $result = ['success' => false, 'message' => 'delete_failed'];
    }
} else {
    $result = ['success' => false, 'message' => 'invalid_request'];
}



header('Content-Type: application/json');
echo json_encode($result);
