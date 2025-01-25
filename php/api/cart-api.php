<?php
require_once '../bootstrap.php';


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

if(isset($_POST["Action"]) && $_POST["Action"] == "add") {

    if(isset($_POST['GameId']) && isset($_POST['Quantity']) && isset($_POST['Platform'])) {
        $game_id = $_POST['GameId'];
        $user_id = $_SESSION["UserID"];
        $quantity = $_POST['Quantity'];
        $platform = $_POST['Platform'];

        

        $game = $dbh->getGameById($game_id);
        $user = $dbh->getUser($user_id);
        $balance = $user['Balance'];

       
        $dbh->addToCart($game_id, $user_id, $quantity, $platform);
        $result = [
            'success' => true,
            'message' => 'Game added to cart successfully'
        ];
        
       
    }
    else {
        $result = [
            'success' => true,
            'message' => 'Invalid request'
        ];
    }
}
else if(isset($_POST["Action"]) && $_POST["Action"] == "remove") {
    if(isset($_POST['GameId'])) {
        $game_id = $_POST['GameId'];
        $user_id = $_SESSION["UserID"];
        $platform = $_POST['Platform'];
        $quantity = $_POST["Quantity"];
        //pass -1 as quantity to remove all the games from the cart
        if($quantity == -1) {
            $dbh->removeFromCart($game_id, $user_id, $platform);
        $result = [
            'success' => true,
            'message' => 'Game removed from cart successfully'
        ];
        }
        else {
            $dbh->modifyGameInCart($game_id, $user_id, -$quantity, $platform);
            $result = [
                'success' => true,
                'message' => 'Quantity modified successfully'
            ];
        }
        
        
    
    }
    else {
        $result = [
            'success' => true,
            'message' => 'Invalid request'
        ];
    }
}
else {
    $result = [
        'success' => true,
        'message' => 'Invalid request'
    ];
}

if(isset($_GET['action']) && $_GET['action'] == 'checkout') {
    $user_id = $_SESSION["UserID"];
    $dbh->checkout($user_id);
    $result = [
        'success' => true,
        'message' => 'Checkout successful'
    ];
}
        
   




header('Content-Type: application/json');
echo json_encode($result);





?>