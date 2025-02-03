<?php
require_once '../bootstrap.php';



if(isset($_GET['start']) && isset($_GET['end']) && isset($_GET['category']) && isset($_GET['action'])) {
    $startRange = $_GET['start'];
    $endRange = $_GET['end'];
    $category = $_GET['category'];
    $action = $_GET['action'];

    //switch case for different actions (tendenza, nuoveuscite, migliori, offerte)
    switch($action) {
        case 'tendenza':
            $games = $dbh->getMostSoldGamesByCategory($category, $startRange, $endRange);
            break;
        case 'nuoveuscite':
            $games = $dbh->getNewGamesByCategory($category, $startRange, $endRange);
            break;
        case 'migliori':
            $games = $dbh->getMostRatedGamesByCategory($category, $startRange, $endRange);
            break;
        case 'offerte':
            $games = $dbh->getDiscountedGamesByCategory($category, $startRange, $endRange);
            break;
        default:
            $games = null;
            break;
    }
    
} 

header('Content-Type: application/json');
echo json_encode($games);

?>