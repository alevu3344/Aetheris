<?php
require_once '../bootstrap.php';

$reviews = array();

if(isset($_GET['start']) && isset($_GET['end']) && isset($_GET['id'])) {
    $startRange = $_GET['start'];
    $endRange = $_GET['end'];
    $gameId= $_GET['id'];

    $reviews = $dbh->getReviewsByGame($gameId, $startRange, $endRange);
}



    
header('Content-Type: application/json');


echo json_encode($reviews);

?>