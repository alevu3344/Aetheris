<?php
require_once 'bootstrap.php'; // load database and any needed functions

if ($argc < 2) {
    exit("Usage: php update_order_status.php [orderId]");
}

$orderId = $argv[1];

// Define the delivery statuses and time intervals (in seconds)
$statuses = ["Pending", "Prepared", "Shipped", "Delivered"];
$interval = 3; // seconds between each update

foreach ($statuses as $status) {
    // Update the order status in the database.
    // You might have a method in your DB handler like updateOrderStatus($orderId, $status)
    $dbh->modifyOrderStatus($orderId, $status);
    
    // Log or echo for debugging (optional)
    error_log("Order {$orderId} updated to status: {$status}");

    // Wait before moving to the next status, except after the last status
    if ($status !== end($statuses)) {
        sleep($interval);
    }
}
