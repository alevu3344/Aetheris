<?php

require_once '../bootstrap.php';
// check_game_name.php
header('Content-Type: application/json');

// Get the game name from the POST request
$data = json_decode(file_get_contents('php://input'), true);
$gameName = $data['gameName'] ?? '';

// Check if the game name is provided
if (empty($gameName)) {
    echo json_encode(['isUnique' => false]);
    exit;
}

// Check if the game name is unique
$isUnique = $dbh->isGameNameUnique($gameName);

echo json_encode(['isUnique' => $isUnique]);


?>
