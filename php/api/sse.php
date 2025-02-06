<?php
require_once '../bootstrap.php';

header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');
header('Connection: keep-alive');

if (!isset($_GET['orderId'])) {
    echo "data: {\"error\": \"No order ID provided\"}\n\n";
    flush();
    exit;
}

$orderId = $_GET['orderId'];

while (true) {
    // Fetch the latest order status from the database
    $order = $dbh->getOrderById($orderId);

    if (!$order) {
        echo "data: {\"error\": \"Order not found\"}\n\n";
        flush();
        break;
    }

    // Prepare the response JSON
    $statusData = [
        "orderId" => $orderId,
        "status" => $order[0]["Status"],
        "updatedAt" => date("j/n/Y H:i:s", strtotime($order[0]["OrderDate"])) // Format date
    ];

    echo "data: " . json_encode($statusData) . "\n\n";
    flush();

    // Stop updating if order is "Delivered"
    if ($order[0]["Status"] === "Delivered") {
        break;
    }

    sleep(2); // Check for updates every 5 seconds
}
?>
