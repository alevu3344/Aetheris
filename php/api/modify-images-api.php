<?php
require_once '../bootstrap.php';

header('Content-Type: application/json');

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['error' => 'Method Not Allowed']);
    exit;
}

// Define upload directories
$uploadDirCover = "../../media/covers/";
$uploadDirScreenshots = "../../media/screenshots/";

// Retrieve the GameId from POST data
if (!isset($_POST['GameId'])) {
    http_response_code(400);
    echo json_encode(['error' => 'GameId not provided']);
    exit;
}
$gameId = $_POST['GameId'];

$response = [];

// Process the cover image if available
if (isset($_FILES['cover']) && $_FILES['cover']['error'] === UPLOAD_ERR_OK) {
    $coverFile = $_FILES['cover'];
    $coverTmpPath = $coverFile['tmp_name'];
    // Save the cover as "$gameId.jpg"
    $coverFileName = $gameId . '.jpg';
    $coverDestPath = $uploadDirCover . $coverFileName;
    
    if (move_uploaded_file($coverTmpPath, $coverDestPath)) {
        $response['cover'] = [
            'status' => 'success',
            'filename' => $coverFileName,
            'message' => 'Cover uploaded successfully.'
        ];
    } else {
        $response['cover'] = [
            'status' => 'error',
            'message' => 'Failed to move cover image.'
        ];
    }
} else {
    $response['cover'] = [
        'status' => 'not_provided',
        'message' => 'No cover image was uploaded.'
    ];
}

// Process screenshots: they are indexed as "screenshot_0", "screenshot_1", etc.
$screenshots = [];

foreach ($_FILES as $key => $file) {
    // Check for keys that start with "screenshot_"
    if (strpos($key, 'screenshot_') === 0 && $file['error'] === UPLOAD_ERR_OK) {
        $tmpPath = $file['tmp_name'];
        //extract the frame number from the key
        $frame = (int)substr($key, strlen('screenshot_'));
        // Save as "$gameId_frame_1.jpg", "$gameId_frame_2.jpg", etc.
        $newFileName = $gameId . '_frame_' . $frame . '.jpg';
        $destPath = $uploadDirScreenshots . $newFileName;
        
        if (move_uploaded_file($tmpPath, $destPath)) {
            $screenshots[$key] = [
                'status' => 'success',
                'filename' => $newFileName,
                'message' => 'Uploaded successfully.'
            ];
        } else {
            $screenshots[$key] = [
                'status' => 'error',
                'message' => 'Failed to move uploaded file.'
            ];
        }
        $frame++;
    }
}

// Add screenshots info to the response
$response['screenshots'] = $screenshots;

// Return the JSON response
echo json_encode($response);
?>