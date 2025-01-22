<?php
    require_once("bootstrap.php");
    $relevant_games = $dbh->getRelevantGames(10);

    header('Content-Type: application/json');
    echo json_encode($relevant_games);
?>