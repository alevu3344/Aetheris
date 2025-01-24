<?php
    require_once("bootstrap.php");
    
    $query = isset($_GET['q']) ? $_GET['q'] : "";
    $result = $dbh->getSearchedGames($query,5);
    header("Content-Type: application/json");
    echo json_encode($result);

?>