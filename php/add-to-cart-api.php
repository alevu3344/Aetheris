<?php
require_once 'bootstrap.php';


//se $_SESSION["Username"] è vuoto, restuisce errore
if(empty($_SESSION["Username"])) {
    $result = [
        'success' => false,
        'message' => 'Login to add a game to your cart'
    ];
    header('Content-Type: application/json');
    echo json_encode($result);
    exit;
}


if(isset($_POST['GameId']) && isset($_POST['Quantity']) && isset($_POST['Platform'])) {
    $game_id = $_POST['GameId'];
    $user_id = $_SESSION["UserID"];
    $quantity = $_POST['Quantity'];
    $platform = $_POST['Platform'];

    

    $game = $dbh->getGameById($game_id);
    $user = $dbh->getUser($user_id);
    $balance = $user['Balance'];

    if($game && $user){
        $dbh->addToCart($game_id, $user_id, $quantity, $platform);
        $result = [
            'success' => true,
            'message' => 'Game added to cart successfully'
        ];
    }
    else {
        $result = [
            'success' => false,
            'message' => 'Game or user not found'
        ];
    }
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