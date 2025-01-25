<?php
    require_once("../bootstrap.php");
    if (!empty($_GET['id'])) {
        $similar_games = $dbh->getSimilarGames($_GET['id'],20);
    } else {
        $result["Error"] = "Errore";
        $result["Success"] = false;
    }

    header('Content-Type: application/json');
    echo json_encode($similar_games);
?>