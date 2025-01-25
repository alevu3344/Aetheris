<?php
require_once '../bootstrap.php';



if(isset($_GET['start']) && isset($_GET['end']) && isset($_GET['id'])) {
    $startRange = $_GET['start'];
    $endRange = $_GET['end'];
    $category = $_GET['id'];

    $reviews = $dbh->getReviewsByGame($category, $startRange, $endRange);
}
  

    

header('Content-Type: application/json');
echo json_encode($reviews);

?>