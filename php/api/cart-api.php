<?php
require_once '../bootstrap.php';


//se $_SESSION["Username"] è vuoto, restuisce errore
if(empty($_SESSION["Username"])) {
    $result = [
        'success' => false,
        'message' => 'not_logged'
    ];
}
else{

    if(isset($_POST["Action"]) && $_POST["Action"] == "add") {

        if(isset($_POST['GameId']) && isset($_POST['Quantity']) && isset($_POST['Platform'])) {
            $game_id = $_POST['GameId'];
            $user_id = $_SESSION["UserID"];
            $quantity = $_POST['Quantity'];
            $platform = $_POST['Platform'];

            

            $game = $dbh->getGameById($game_id)[0];
            $user = $dbh->getUser($user_id);
            $balance = $user['Balance'];

        
            $dbh->addToCart($game_id, $user_id, $quantity, $platform);
            $result = [
                'success' => true,
                'message' => 'added_to_cart'
            ];
            
        
        }
        else {
            $result = [
                'success' => false,
                'message' => 'invalid_request'
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
                'message' => 'game_removed'
            ];
            }
            else {
                $dbh->modifyGameInCart($game_id, $user_id, -$quantity, $platform);
                $result = [
                    'success' => true,
                    'message' => 'quantity_decreased'
                ];
            }
            
            
        
        }
        else {
            $result = [
                'success' => false,
                'message' => 'gameid_not_set_in_post'
            ];
        }
    }
    else {
        $result = [
            'success' => false,
            'message' => 'invalid_request'
        ];
    }

    if(isset($_GET['action']) && $_GET['action'] == 'checkout') {
        $user_id = $_SESSION["UserID"];
        $result = $dbh->checkout($user_id);
    }
}
   




header('Content-Type: application/json');
echo json_encode($result);





?>