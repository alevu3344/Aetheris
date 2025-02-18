<?php

require_once '../bootstrap.php';


// Ensure the user is logged in and has admin privileges
if (empty($_SESSION["Username"])) {
    $result = ['success' => false, 'message' => 'not_logged'];
} elseif (!$_SESSION["isAdmin"]) {
    $result = ['success' => false, 'message' => 'not_admin'];
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate required POST parameters
    $requiredFields = ['GameName', 'GameDescription', 'GamePrice', 'GamePublisher', 'GameReleaseDate', 'GameTrailer', 'categories', 'platforms'];
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
    $categories = $_POST["categories"];
    $platforms = [];

    foreach ($_POST["platforms"] as $platform) {
        if (!empty($_POST["quantity"][$platform])) {
            $platforms[$platform] = (int) $_POST["quantity"][$platform];
        }
    }

    // Check if PC is selected and fetch minimum requirements
    $pcRequirements = null;
    if (array_key_exists("PC", $platforms)) {
        $pcRequirements = [
            "ram" => !empty($_POST["pc_requirements"]["ram"]) ? (int) $_POST["pc_requirements"]["ram"] : null,
            "gpu" => !empty($_POST["pc_requirements"]["gpu"]) ? trim($_POST["pc_requirements"]["gpu"]) : null,
            "ssd" => !empty($_POST["pc_requirements"]["ssd"]) ? (int) $_POST["pc_requirements"]["ssd"] : null,
            "os" => !empty($_POST["pc_requirements"]["os"]) ? trim($_POST["pc_requirements"]["os"]) : null,
            "cpu" => !empty($_POST["pc_requirements"]["cpu"]) ? trim($_POST["pc_requirements"]["cpu"]) : null,
        ];
    }




    // Handle file upload
    // Handle file upload
    if (
        isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK &&
        isset($_FILES['screenshots']) && count($_FILES['screenshots']['name']) == 4
    ) {
        $fileTmpPathCover = $_FILES['image']['tmp_name'];
        $fileNameCover = $_FILES['image']['name'];
        $fileExtension = strtolower(pathinfo($fileNameCover, PATHINFO_EXTENSION));

        // Allowed file extensions
        $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
        if (!in_array($fileExtension, $allowedExtensions)) {
            $result = ['success' => false, 'message' => 'invalid_image_extension'];
        } else {
            // Add game to the database
            $gameId = $dbh->addGame($name, $description, $price, $publisher, $releaseDate, $trailer, $categories, $platforms, $pcRequirements);
            if ($gameId) {
                // Generate upload paths
                $uploadDirCover = "../../media/covers/";
                $uploadDirScreenshots = "../../media/screenshots/";



                $newFileNameCover = $gameId . '.' . $fileExtension;
                $uploadFilePathCover = $uploadDirCover . $newFileNameCover;

                // Move cover image
                if (move_uploaded_file($fileTmpPathCover, $uploadFilePathCover)) {
                    // Process and save screenshots
                    $screenshotSuccess = true;
                    for ($i = 0; $i < 4; $i++) {
                        $tmpScreenshotPath = $_FILES['screenshots']['tmp_name'][$i];
                        $screenshotExtension = strtolower(pathinfo($_FILES['screenshots']['name'][$i], PATHINFO_EXTENSION));

                        if (!in_array($screenshotExtension, $allowedExtensions)) {
                            $screenshotSuccess = false;
                            break;
                        }

                        $newScreenshotName = "{$gameId}_frame_" . ($i + 1) . "." . $screenshotExtension;
                        $screenshotUploadPath = $uploadDirScreenshots . $newScreenshotName;

                        if (!move_uploaded_file($tmpScreenshotPath, $screenshotUploadPath)) {
                            $screenshotSuccess = false;
                            break;
                        }
                    }

                    if ($screenshotSuccess) {
                        $result = ['success' => true, 'message' => 'game_added'];
                    } else {
                        $result = ['success' => false, 'message' => 'screenshot_upload_error'];
                    }
                } else {
                    $result = ['success' => false, 'message' => 'upload_error'];
                }
            } else {
                $result = ['success' => false, 'message' => 'game_add_error'];
            }
        }
    } else {
        $result = ['success' => false, 'message' => 'no_image_uploaded_or_wrong_screenshot_count'];
    }
} else {
    $result = ['success' => false, 'message' => 'invalid_request'];
}


header('Content-Type: application/json');
echo json_encode($result);
