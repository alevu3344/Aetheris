<?php
require_once '../bootstrap.php';


//se $_SESSION["Username"] è vuoto, restuisce errore
if(empty($_SESSION["Username"])) {
    $result = [
        'success' => false,
        'message' => 'not_logged'
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

    if($game && $user) {
        $total = $game['Price'] * $quantity;
        if((!empty($game["Discount"]))){
            $total = $total - ($total * $game["Discount"] / 100);
        }

        if($balance >= $total) {
            $newBalance = $balance - $total;
            $dbh->buyGame($game_id, $user_id, $quantity, $total, $platform);
            $result = [
                'success' => true,
                'message' => 'bought'
            ];
        } else {
            $result = [
                'success' => false,
                'message' => 'nofunds'
            ];
        }
    } else {
        $result = [
            'success' => false,
            'message' => 'internal_error'
        ];
    }
} else {
    $result = [
        'success' => true,
        'message' => 'invalid_request'
    ];
}


header('Content-Type: application/json');
echo json_encode($result);

?>