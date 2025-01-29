<?php

require_once '../bootstrap.php';

if(isset($_POST["categories"])){
    $categories = $_POST["categories"];
    header('Content-Type: application/json');
    echo json_encode($categories);
    exit;
    
}

// Ensure the user is logged in and has admin privileges
if (empty($_SESSION["Username"])) {
    $result = ['success' => false, 'message' => 'not_logged'];
} elseif (!$_SESSION["isAdmin"]) {
    $result = ['success' => false, 'message' => 'not_admin'];
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate required POST parameters
    $requiredFields = ['GameName', 'GameDescription', 'GamePrice', 'GamePublisher', 'GameReleaseDate', 'GameTrailer'];
    foreach ($requiredFields as $field) {
        if (empty($_POST[$field])) {
            $result = ['success' => false, 'message' => 'missing_' . strtolower($field)];
            header('Content-Type: application/json');
            echo json_encode($result);
            exit;
        }
    }

    // Assign POST parameters
    $name = $_POST["GameName"];
    $description = $_POST["GameDescription"];
    $price = (float) $_POST["GamePrice"];
    $publisher = $_POST["GamePublisher"];
    $releaseDate = $_POST["GameReleaseDate"];
    $trailer = $_POST["GameTrailer"];

    // Handle file upload
    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        $fileTmpPath = $_FILES['image']['tmp_name'];
        $fileName = $_FILES['image']['name'];
        $fileExtension = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

        // Allowed file extensions
        $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
        if (!in_array($fileExtension, $allowedExtensions)) {
            $result = ['success' => false, 'message' => 'invalid_image_extension'];
        } else {
            // Add game to the database
            $gameId = $dbh->addGame($name, $description, $price, $publisher, $releaseDate, $trailer);
            if ($gameId) {
                // Generate upload path
                $uploadDir = GAME_COVERS . 'covers/';
                if (!is_dir($uploadDir)) {
                    mkdir($uploadDir, 0777, true);
                }
                $newFileName = $gameId . '.' . $fileExtension;
                $uploadFilePath = $uploadDir . $newFileName;

                // Move the uploaded file
                if (move_uploaded_file($fileTmpPath, $uploadFilePath)) {
                    $result = ['success' => true, 'message' => 'game_added'];
                } else {
                    $result = ['success' => false, 'message' => 'upload_error'];
                }
            } else {
                $result = ['success' => false, 'message' => 'game_add_error'];
            }
        }
    } else {
        $result = ['success' => false, 'message' => 'no_image_uploaded'];
    }
} else {
    $result = ['success' => false, 'message' => 'invalid_request'];
}


header('Content-Type: application/json');
echo json_encode($result);
?>