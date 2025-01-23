<?php
    require_once("bootstrap.php");
    $discounted_relevant_games = $dbh->getDiscountedRelevantGames(30);

    header('Content-Type: application/json');
    echo json_encode($discounted_relevant_games);
?>