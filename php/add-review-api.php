<?php
require_once 'bootstrap.php';


//se $_SESSION["Username"] è vuoto, restuisce errore
if(empty($_SESSION["Username"])) {
    $result = [
        'success' => false,
        'message' => 'Login to add a review'
    ];
    header('Content-Type: application/json');
    echo json_encode($result);
    exit;
}


if(isset($_POST['GameId']) && isset($_POST['Title']) && isset($_POST['Comment']) && isset($_POST['Rating'])) {
    $game_id = $_POST['GameId'];
    $user_id = $_SESSION["UserID"];
    $title = $_POST['Title'];
    $comment = $_POST['Comment'];
    $rating = $_POST['Rating'];

    
    $dbh->addReviewToGame($game_id, $user_id, $title, $comment, $rating);

    $result = [
        'success' => true,
        'message' => 'Review added successfully'
    ];
}
else {
    $result = [
        'success' => true,
        'message' => 'Invalid request'
    ];
}
        
   




header('Content-Type: application/json');
echo json_encode($result);





?>