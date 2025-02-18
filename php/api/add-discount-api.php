<?php
require_once '../bootstrap.php';


//se $_SESSION["Username"] è vuoto, restuisce errore
if (empty($_SESSION["Username"])) {
    $result = [
        'success' => false,
        'message' => 'not_logged'
    ];
    header('Content-Type: application/json');
    echo json_encode($result);
    exit;
}

if (isset($_POST["Action"]) && $_POST["Action"] == "add") {
    if (isset($_POST['GameId']) && isset($_POST['Discount']) && isset($_POST['StartDate']) && isset($_POST['EndDate'])) {

        $game_id = $_POST['GameId'];
        $discount = $_POST['Discount'];
        $start_date = $_POST['StartDate'];
        $end_date = $_POST['EndDate'];

        //validate the date formats
        $start_date = date('Y-m-d', strtotime($start_date));
        $end_date = date('Y-m-d', strtotime($end_date));



        $dbh->addDiscountToGame($game_id, $discount, $start_date, $end_date);

        $result = [
            'success' => true,
            'message' => 'discount_added'
        ];
    } else {
        $result = [
            'success' => true,
            'message' => 'missing_params'
        ];
    }
}
else if(isset($_POST["Action"]) && $_POST["Action"] == "remove") {
    if (isset($_POST['GameId'])) {
        $game_id = $_POST['GameId'];

        $dbh->removeDiscountFromGame($game_id);

        $result = [
            'success' => true,
            'message' => 'discount_removed'
        ];
    } else {
        $result = [
            'success' => true,
            'message' => 'missing_params'
        ];
    }
}
else {
    $result = [
        'success' => false,
        'message' => 'invalid_action'
    ];
}

header('Content-Type: application/json');
echo json_encode($result);
