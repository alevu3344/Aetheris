<?php
// Start a session (to use sessions for user login, cart, etc.)
session_start();

// ** Database Configuration **
define('DB_HOST', 'localhost');  // Database host (usually localhost)
define('DB_USER', 'root');       // Database username
define('DB_PASS', '');           // Database password
define('DB_NAME', 'Aetheris');  // Database name

// ** Error Reporting (For development purposes) **
// In production, you should disable error reporting for security reasons.
ini_set('display_errors', 1);
error_reporting(E_ALL);

// ** Database Connection Function **
function getDbConnection() {
    // Try connecting to the database using MySQLi
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    
    // Check for connection errors
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Set the character set to UTF-8 for better compatibility with special characters
    $conn->set_charset('utf8');

    return $conn;
}

// ** Site Configuration **
define('SITE_URL', 'http://localhost/Aetheris');  // Base URL of your site
define('SITE_NAME', 'Aetheris');  // The name of your website (for title, etc.)

// ** Paths (for file uploads, etc.) **
define('UPLOADS_DIR', __DIR__ . '/uploads/');  // Absolute path to the uploads directory
define('PRODUCT_IMAGES_DIR', UPLOADS_DIR . 'product-images/');  // Directory for product images

// ** Security Settings **
define('SESSION_LIFETIME', 3600); // 1 hour session lifetime
?>
