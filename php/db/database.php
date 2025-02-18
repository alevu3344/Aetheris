<?php

class DatabaseHelper
{
    private $db;

    public function __construct($servername, $Username, $password, $dbname, $port)
    {
        $this->db = new mysqli($servername, $Username, $password, $dbname, $port);
        mysqli_set_charset($this->db, 'utf8mb4');
        if ($this->db->connect_error) {
            die("Connessione fallita al db: " . $this->db->connect_error);
        }
    }

    public function notifyAdmin($type, $message)
    {
        $query = "SELECT UserID FROM USERS WHERE Role = 'Admin'";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        $rows = $result->fetch_all(MYSQLI_ASSOC);

        foreach ($rows as $row) {
            $this->notifyUser($type, $message, $row["UserID"]);
        }
    }

    //this is used when:
    //(1) GAME is deleted, 
    //(2) Game stock for platform is changed to exceed the quantity in the shopping cart
    public function notifyUsersWithGameInCart($type, $message, $gameId, $platform = null, $newQuantity = null)
    {
        // Start building the query with the basic conditions
        $query = "SELECT UserId FROM SHOPPING_CARTS WHERE GameId = ?";

        // Add conditions for platform and newQuantity if provided
        if ($platform !== null) {
            $query .= " AND Platform = ?";
        }
        if ($newQuantity !== null) {
            $query .= " AND Quantity > ?";
        }

        // Prepare the statement
        $stmt = $this->db->prepare($query);

        // Prepare the types string
        $types = "i";  // gameId is an integer

        // Prepare the parameters array
        $params = [$gameId];

        // Bind additional parameters based on platform and newQuantity
        if ($platform !== null) {
            $types .= "s";  // platform is a string
            $params[] = $platform;
        }
        if ($newQuantity !== null) {
            $types .= "i";  // newQuantity is an integer
            $params[] = $newQuantity;
        }

        // Bind all parameters dynamically
        $stmt->bind_param($types, ...$params);

        // Execute the statement and fetch results
        $stmt->execute();
        $result = $stmt->get_result();
        $rows = $result->fetch_all(MYSQLI_ASSOC);

        // Notify users
        foreach ($rows as $row) {
            $this->notifyUser($type, $message, $row["UserId"]);
        }
    }



    public function addDiscountToGame($gameId, $discount, $startDate, $endDate)
    {

        //TODO:NOTIFICATION

        //first remove previous discounts
        $this->removeDiscountFromGame($gameId);


        $query = "INSERT INTO DISCOUNTED_GAMES (GameId, Percentage, StartDate, EndDate) VALUES (?, ?, ?, ?)";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iiss", $gameId, $discount, $startDate, $endDate);
        $stmt->execute();

        $this->notifyAllUsers("discount_added", "A new discount has been added to " . $this->getGameById($gameId)[0]["Name"] . ". Check it out!");
    }

    public function removeDiscountFromGame($gameId)
    {
        $query = "DELETE FROM DISCOUNTED_GAMES WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        return $stmt->execute();
    }





    public function notifyAllUsers($type, $message)
    {
        $query = "SELECT UserID FROM USERS";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        $rows = $result->fetch_all(MYSQLI_ASSOC);

        foreach ($rows as $row) {
            if (!$this->isAdmin($row["UserID"])) {
                $this->notifyUser($type, $message, $row["UserID"]);
            }
        }
    }

    public function isAdmin($userID)
    {
        $query = "SELECT * FROM USERS WHERE UserID = ? AND Role = 'Admin'";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $userID);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->num_rows > 0;
    }

    public function notifyUser($type, $message, $userId)
    {
        $query = "INSERT INTO NOTIFICATIONS (Type, Message, UserId) VALUES (?, ?, ?)";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("ssi", $type, $message, $userId);
        $stmt->execute();
    }

    public function markNotificationAsRead($notificationId)
    {
        $query = "UPDATE NOTIFICATIONS SET Status = 'Read' WHERE Id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $notificationId);
        $stmt->execute();
    }

    public function deleteGame($gameId)
    {
        //delete all its reviews from REVIEWS
        //if te game is avaiable for PC (in SUPPORTED_PLATFORMS) delete its row from PC_GAME_REQUIREMENTS

        //delete all its rows from SUPPORTED_PLATFORMS
        //delete all its rows from GAME_CATEGORIES
        //delete all its rows from DISCOUNTED_GAMES
        //delete its row from GAMES

        $game = $this->getGameById($gameId)[0];


        //TODO:NOTIFICATION
        $query = "DELETE FROM REVIEWS WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        if (!$stmt->execute()) {
            return false;
        }

        $query = "DELETE FROM PC_GAME_REQUIREMENTS WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        if (!$stmt->execute()) {
            return false;
        }

        $query = "DELETE FROM SUPPORTED_PLATFORMS WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        if (!$stmt->execute()) {
            return false;
        }


        $query = "DELETE FROM GAME_CATEGORIES WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        if (!$stmt->execute()) {
            return false;
        }


        $query = "DELETE FROM DISCOUNTED_GAMES WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        $stmt->execute();
        if (!$stmt->execute()) {
            return false;
        }

        //delete the game from all shopping carts, and notify the users that had it in the shopping cart
        $message = "The game " . $game["Name"] . " has been deleted, we have removed it from your shopping cart";
        $this->notifyUsersWithGameInCart("game_deleted", $message, $gameId, null, null);
        $query = "DELETE FROM SHOPPING_CARTS WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        if (!$stmt->execute()) {
            return false;
        }

        $query = "DELETE FROM ORDER_ITEMS WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        if (!$stmt->execute()) {
            return false;
        }

        $query = "DELETE FROM GAMES WHERE Id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        if (!$stmt->execute()) {
            return false;
        }

        return true;
    }


    public function modifyGame($gameId, $field, $value)
    {
        $query = null;
        $stmt = null;

        //TODO:NOTIFICATION

        // Handle general game fields
        switch ($field) {
            case "Price":
            case "Publisher":
            case "ReleaseDate":
            case "Trailer":
            case "Rating":
            case "CopiesSold":
            case "Name":
                $query = "UPDATE GAMES SET $field = ? WHERE Id = ?";
                $stmt = $this->db->prepare($query);
                $stmt->bind_param("si", $value, $gameId);
                break;

                // Handle platforms like PC, PlayStation, Xbox, Nintendo Switch
            case "PC":
            case "PlayStation":
            case "Xbox":
            case "Nintendo_Switch":
                $query = "UPDATE SUPPORTED_PLATFORMS SET Stock = ? WHERE GameId = ? AND Platform = ?";

                $stmt = $this->db->prepare($query);
                $stmt->bind_param("iis", $value, $gameId, $field);
                //notify the users that had the (gameId, platform) in the shopping cart with a quantity greater than the new stock
                $this->notifyUsersWithGameInCart("stock_changed", "The stock of the game " . $this->getGameById($gameId)[0]["Name"] . " for the platform " . $field . " has been changed, edit your cart accordingly", $gameId, $field, $value);
                break;

                // Handle discount fields
            case "Discount":
            case "StartDate":
            case "EndDate":
                $field = $field === "Discount" ? "Percentage" : $field;  // Change Discount to Percentage
                $query = "UPDATE DISCOUNTED_GAMES SET $field = ? WHERE GameId = ?";
                $stmt = $this->db->prepare($query);
                $stmt->bind_param("si", $value, $gameId);

                $this->notifyUsersWithGameInCart("discount_changed", "The discount of the game " . $this->getGameById($gameId)[0]["Name"] . " has been changed", $gameId);
                break;

                // Handle game requirements (OS, RAM, CPU, GPU, SSD)
            case "OS":
            case "RAM":
            case "CPU":
            case "GPU":
            case "SSD":
                $query = "UPDATE PC_GAME_REQUIREMENTS SET $field = ? WHERE GameId = ?";
                $stmt = $this->db->prepare($query);
                $stmt->bind_param("si", $value, $gameId);
                break;

            default:
                return ['success' => false, 'message' => 'invalid_field'];
        }

        // Execute the prepared statement
        if ($stmt && $stmt->execute()) {
            return ['success' => true, 'message' => 'field_modified'];
        } else {
            return ['success' => false, 'message' => 'field_not_modified'];
        }
    }

    public function getOrderById($id)
    {
        $query = "
        SELECT 
            O.Id AS OrderId,
            O.OrderDate,
            O.TotalCost,
            O.Status,
            O.UserId,
            OI.GameId,
            G.Name AS GameName,
            G.Price,
            OI.Quantity,
            OI.FinalPrice,
            OI.Platform
        FROM 
            ORDERS O
        JOIN 
            ORDER_ITEMS OI ON O.Id = OI.OrderId
        JOIN 
            GAMES G ON OI.GameId = G.Id
        WHERE 
            O.Id = ?
        ";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        $rows = $result->fetch_all(MYSQLI_ASSOC);

        $orders = [];

        foreach ($rows as $row) {
            $orderId = $row['OrderId'];
            if (!isset($orders[$orderId])) {
                $orders[$orderId] = [
                    'OrderId' => $orderId,
                    'OrderDate' => $row['OrderDate'],
                    'TotalCost' => $row['TotalCost'],
                    'Status' => $row['Status'],
                    'UserId' => $row['UserId'],
                    'OrderItems' => []
                ];
            }

            $orders[$orderId]['OrderItems'][] = [
                'GameId' => $row['GameId'],
                'Name' => $row['GameName'], // Add GameName here
                'Quantity' => $row['Quantity'],
                'FinalPrice' => $row['FinalPrice'],
                'InitialPrice' => $row['Price'],
                'Platform' => $row['Platform'],
                'Discount' => [
                    'Percentage' => ($row["Price"] - $row["FinalPrice"]) / $row["Price"] * 100,
                ]
            ];
        }

        return array_values($orders); // Convert associative array to indexed array
    }


    public function getOrdersForUser($UserID)
    {
        $query = "
        SELECT 
            O.Id AS OrderId,
            O.OrderDate,
            O.TotalCost,
            O.Status,
            OI.GameId,
            G.Name AS GameName,
            G.Price,
            OI.Quantity,
            OI.FinalPrice,
            OI.Platform
        FROM 
            ORDERS O
        JOIN 
            ORDER_ITEMS OI ON O.Id = OI.OrderId
        JOIN 
            GAMES G ON OI.GameId = G.Id
        WHERE 
            O.UserId = ?
        ORDER BY 
            O.OrderDate DESC, O.Id
        ";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $UserID);
        $stmt->execute();
        $result = $stmt->get_result();
        $rows = $result->fetch_all(MYSQLI_ASSOC);

        $orders = [];

        foreach ($rows as $row) {
            $orderId = $row['OrderId'];
            if (!isset($orders[$orderId])) {
                $orders[$orderId] = [
                    'OrderId' => $orderId,
                    'OrderDate' => $row['OrderDate'],
                    'TotalCost' => $row['TotalCost'],
                    'Status' => $row['Status'],
                    'OrderItems' => []
                ];
            }

            $orders[$orderId]['OrderItems'][] = [
                'GameId' => $row['GameId'],
                'Name' => $row['GameName'], // Add GameName here
                'Quantity' => $row['Quantity'],
                'FinalPrice' => $row['FinalPrice'],
                'InitialPrice' => $row['Price'],
                'Platform' => $row['Platform'],
                'Discount' => [
                    'Percentage' => ($row["Price"] - $row["FinalPrice"]) / $row["Price"] * 100,
                ]
            ];
        }

        return array_values($orders); // Convert associative array to indexed array
    }

    public function getAvailableOrders()
    {
        $query = "
        SELECT 
            O.*,
            OI.GameId,
            G.Name AS GameName,
            G.Price,
            OI.Quantity,
            OI.FinalPrice,
            OI.Platform,
            U.Username
        FROM 
            ORDERS O
        JOIN 
            ORDER_ITEMS OI ON O.Id = OI.OrderId
        JOIN 
            GAMES G ON OI.GameId = G.Id
        JOIN 
            USERS U ON O.UserId = U.UserID
        WHERE 
            O.Status != 'Delivered'
        ORDER BY 
            O.OrderDate DESC, O.Id
        ";

        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        $rows = $result->fetch_all(MYSQLI_ASSOC);

        $orders = [];

        foreach ($rows as $row) {
            $orderId = $row['Id'];
            if (!isset($orders[$orderId])) {
                $orders[$orderId] = [
                    'OrderId' => $orderId,
                    'OrderDate' => $row['OrderDate'],
                    'TotalCost' => $row['TotalCost'],
                    'Status' => $row['Status'],
                    'OrderItems' => [],
                    'Username' => $row['Username']
                ];
            }

            $orders[$orderId]['OrderItems'][] = [
                'GameId' => $row['GameId'],
                'Name' => $row['GameName'], // Add GameName here
                'Quantity' => $row['Quantity'],
                'FinalPrice' => $row['FinalPrice'],
                'InitialPrice' => $row['Price'],
                'Platform' => $row['Platform'],
                'Discount' => [
                    'Percentage' => ($row["Price"] - $row["FinalPrice"]) / $row["Price"] * 100,
                ]
            ];
        }

        return array_values($orders); // Convert associative array to indexed array
    }

    public function advanceOrder($orderId)
    {

        $statusProgression = ["Pending", "Prepared", "Shipped", "Delivered"];
        $order = $this->getOrderById($orderId)[0];
        $status = $order["Status"];
        $nextStatus = $statusProgression[array_search($status, $statusProgression) + 1];
        $this->modifyOrderStatus($orderId, $nextStatus);
        return $nextStatus;
    }


    public function modifyOrderStatus($OrderId, $Status)
    {
        //TODO:NOTIFICATION
        $query = "UPDATE ORDERS SET Status = ? WHERE Id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("si", $Status, $OrderId);
        $stmt->execute();

        $this->notifyUser("order_status_changed", "The status of your order #" . $OrderId . " has been changed to " . $Status, $this->getOrderById($OrderId)[0]["UserId"]);
    }

    public function getPlatformQuantity($gameId, $platform)
    {
        $query = "SELECT Stock FROM SUPPORTED_PLATFORMS WHERE GameId = ? AND Platform = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("is", $gameId, $platform);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc()["Stock"];
    }

    public function getPublishers()
    {
        $query = "SELECT * FROM PUBLISHERS";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }



    public function addGamesToOrders($orders)
    {

        foreach ($orders as &$order) {
            $orderId = $order["OrderId"];
            $order["Games"] = $this->addSupportedPlatforms($this->getGamesForOrder($orderId));
        }

        return $orders;
    }

    public function getGamesForOrder($orderId)
    {
        $query = "
        SELECT 
            G.*
        FROM 
            ORDER_ITEMS OI
        JOIN 
            GAMES G ON OI.GameId = G.Id
        WHERE 
            OI.OrderId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $orderId);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }


    public function getAvatars()
    {
        $query = "SELECT * FROM AVATARS";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getGamesByCategory($category, $lim = null, $admin = false)
    {
        $query = "
        SELECT 
            G.*,
            DG.Percentage AS Discount,
            DG.StartDate,
            DG.EndDate
        FROM 
            GAMES G
        INNER JOIN 
            GAME_CATEGORIES GC ON G.Id = GC.GameId
        INNER JOIN 
            CATEGORIES C ON GC.CategoryName = C.CategoryName
        LEFT JOIN 
            DISCOUNTED_GAMES DG ON G.Id = DG.GameId
    ";


        // Modify the join condition based on $admin
        if ($admin) {
            $query .= " AND DG.StartDate >= CURRENT_DATE";
        } else {
            $query .= " AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate";
        }

        $query .= " WHERE C.CategoryName = ? ORDER BY G.ReleaseDate DESC";

        if ($lim !== null) {
            $query .= " LIMIT ?";
        }

        $stmt = $this->db->prepare($query);
        if ($lim !== null) {
            $stmt->bind_param("si", $category, $lim);
        } else {
            $stmt->bind_param("s", $category);
        }
        $stmt->execute();
        $result = $stmt->get_result();

        return $this->addMinimumRequirements($this->addCategories($this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC))));
    }


    public function addMinimumRequirements($games)
    {
        foreach ($games as &$game) {
            $gameId = $game["Id"];
            $game["Requirements"] = $this->getGameRequirements($gameId);
        }

        return $games;
    }

    // this function returns a list of tuples (GameId, GameName, Quantity, OriginalPrice, Discount (0% if not discounted))
    public function getShoppingCart($userId)
    {
        $query = "
            SELECT 
                G.Id, 
                G.Name, 
                SC.Quantity, 
                SC.Platform,
                G.Price, 
                IFNULL(DG.Percentage, 0) AS Discount
            FROM 
                SHOPPING_CARTS SC
            INNER JOIN 
                GAMES G ON SC.GameId = G.Id
            LEFT JOIN 
                DISCOUNTED_GAMES DG ON G.Id = DG.GameId
            WHERE 
                SC.UserId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC));
    }

    public function getGameById($id, $admin = false)
    {
        $query = "
        SELECT 
            G.*,
            IFNULL(DG.Percentage, 0) AS Discount,
            DG.StartDate,
            DG.EndDate
        FROM 
            GAMES G
        LEFT JOIN 
            DISCOUNTED_GAMES DG ON G.Id = DG.GameId
    ";

        // Modify the join condition based on $admin
        if ($admin) {
            $query .= " AND DG.StartDate >= CURRENT_DATE";
        } else {
            $query .= " AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate";
        }

        $query .= " WHERE G.Id = ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        return $this->addMinimumRequirements($this->addCategories($this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC))));
    }


    public function addGame($name, $description, $price, $publisher, $releaseDate, $trailer, $categories, $platforms, $pcRequirements)
    {
        //TODO:NOTIFICATION
        $query = "INSERT INTO GAMES (Name, Description, Price, Publisher, ReleaseDate, Trailer, Rating, CopiesSold) 
                  VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->db->prepare($query);

        if ($stmt === false) {
            error_log("Error preparing query: " . $this->db->error);
            return false;
        }

        $rating = 5;
        $copiesSold = 0;

        // Bind parameters to the query
        $stmt->bind_param('ssdsssii', $name, $description, $price, $publisher, $releaseDate, $trailer, $rating, $copiesSold);

        // Execute the query and check for errors
        if ($stmt->execute()) {
            $gameId = $stmt->insert_id;

            foreach ($categories as $category) {
                $query = "INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES (?, ?)";
                $stmt = $this->db->prepare($query);
                $stmt->bind_param("is", $gameId, $category);
                $stmt->execute();
            }

            foreach ($platforms as $platform => $quantity) {
                if ($quantity > 0) {
                    $query = "INSERT INTO SUPPORTED_PLATFORMS (GameId, Platform, Stock) VALUES (?, ?, ?)";
                    $stmt = $this->db->prepare($query);
                    $stmt->bind_param("isi", $gameId, $platform, $quantity);
                    $stmt->execute();
                }
            }

            //if $pcRequirements is not null, insert the requirements in PC_GAME_REQUIREMENTS
            if ($pcRequirements !== null) {
                $query = "INSERT INTO PC_GAME_REQUIREMENTS (GameId, OS, RAM, CPU, GPU, SSD) VALUES (?, ?, ?, ?, ?, ?)";
                $stmt = $this->db->prepare($query);
                $stmt->bind_param("isissi", $gameId, $pcRequirements["os"], $pcRequirements["ram"], $pcRequirements["cpu"], $pcRequirements["gpu"], $pcRequirements["ssd"]);
                $stmt->execute();
            }

            //notify all users that a new game has been added
            $this->notifyAllUsers("new_game", $this->getGameById($gameId)[0]["Name"] . " has been added to the store!");

            return $gameId;
        } else {
            // Log the error and return false
            error_log("Error executing query: " . $stmt->error);
            return false;
        }
    }

    public function isGameNameUnique($gameName)
    {
        $query = "SELECT * FROM GAMES WHERE Name = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("s", $gameName);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->num_rows == 0;
    }



    public function buyGame($gameId, $userId, $quantity, $total, $platform)
    {
        // Insert into ORDERS table

        //TODO:NOTIFICATION
        $query = "INSERT INTO ORDERS (UserId, TotalCost, OrderDate) VALUES (?, ?, NOW())";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("id", $userId, $total);
        $stmt->execute();

        // Retrieve the generated OrderId
        $orderId = $stmt->insert_id;

        // Insert into ORDER_ITEMS table
        $query = "INSERT INTO ORDER_ITEMS (GameId, Quantity, FinalPrice, OrderId, Platform) VALUES (?, ?, ?, ?, ?)";
        $stmt = $this->db->prepare($query);
        $finalPrice = $total / $quantity; // Assuming the total is divided equally among the items
        $stmt->bind_param("iidis", $gameId, $quantity, $finalPrice, $orderId, $platform);
        $stmt->execute();

        // Update user balance
        $query = "UPDATE USERS SET Balance = Balance - ? WHERE UserID = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("di", $total, $userId);
        $stmt->execute();

        // Update stock
        $query = "UPDATE SUPPORTED_PLATFORMS SET Stock = Stock - ? WHERE GameId = ? AND Platform = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iis", $quantity, $gameId, $platform);
        $stmt->execute();

        //notify the admin of the new order
        $this->notifyAdmin("new_order", "A new order has been placed by " . $this->getUser($userId)["Username"]);


        //notify admin if the stock for the platform is now 0
        $stock = $this->getPlatformQuantity($gameId, $platform);
        if ($stock == 0) {
            $this->notifyAdmin("out_of_stock", "The game " . $this->getGameById($gameId)[0]["Name"] . " is now out of stock for the platform " . $platform);
        }
    }


    public function modifyCategoriesOfGame($category, $gameId, $action)
    {
        $query = null;
        $stmt = null;



        if ($action === "add") {
            $query = "INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES (?, ?)";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("is", $gameId, $category);
        } else if ($action === "remove") {
            $query = "DELETE FROM GAME_CATEGORIES WHERE GameId = ? AND CategoryName = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("is", $gameId, $category);
        }

        if ($stmt->execute()) {
            return ['success' => true, 'message' => 'category_modified', "gameName" => $this->getGameById($gameId)[0]["Name"], "category" => $category];
        } else {
            return ['success' => false, 'message' => 'category_not_modified', "gameName" => $this->getGameById($gameId)[0]["Name"], "category" => $category];
        }
    }


    public function modifyPlatformsOfGame($platform, $gameId, $action)
    {
        $query = null;
        $stmt = null;

        //TODO:NOTIFICATION

        if ($action === "add") {
            $query = "INSERT INTO SUPPORTED_PLATFORMS (GameId, Platform, Stock) VALUES (?, ?, 0)";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("is", $gameId, $platform);
        } else if ($action === "remove") {
            $query = "DELETE FROM SUPPORTED_PLATFORMS WHERE GameId = ? AND Platform = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("is", $gameId, $platform);
        }

        if ($stmt->execute()) {
            // If the platform is PC, modify the PC_GAME_REQUIREMENTS accordingly
            if ($platform === "PC") {
                if ($action === "remove") {
                    $query = "DELETE FROM PC_GAME_REQUIREMENTS WHERE GameId = ?";
                    $stmt = $this->db->prepare($query);
                    $stmt->bind_param("i", $gameId);
                    $stmt->execute();
                } else {
                    $query = "INSERT INTO PC_GAME_REQUIREMENTS (GameId) VALUES (?)";
                    $stmt = $this->db->prepare($query);
                    $stmt->bind_param("i", $gameId);
                    $stmt->execute();
                }
            }

            // When removing a platform, also remove any matching entries from shopping carts
            // and notify the corresponding users.
            if ($action === "remove") {
                // Retrieve affected users before deletion.
                $query = "SELECT UserId FROM SHOPPING_CARTS WHERE GameId = ? AND Platform = ?";
                $stmt = $this->db->prepare($query);
                $stmt->bind_param("is", $gameId, $platform);
                $stmt->execute();
                $result = $stmt->get_result();
                $gameName = $this->getGameById($gameId)[0]["Name"];

                while ($row = $result->fetch_assoc()) {
                    $userId = $row["UserId"];
                    $message = "The game '{$gameName}' is no longer available on {$platform} and has been removed from your shopping cart.";
                    $this->notifyUsersWithGameInCart("platform_removed", $message, $gameId, $platform);
                }

                // Remove the (gameId, platform) from all shopping carts.
                $query = "DELETE FROM SHOPPING_CARTS WHERE GameId = ? AND Platform = ?";
                $stmt = $this->db->prepare($query);
                $stmt->bind_param("is", $gameId, $platform);
                $stmt->execute();
            }

            return [
                'success' => true,
                'message' => 'platform_modified',
                "gameName" => $this->getGameById($gameId)[0]["Name"],
                "platform" => $platform
            ];
        } else {
            return [
                'success' => false,
                'message' => 'platform_not_modified',
                "gameName" => $this->getGameById($gameId)[0]["Name"],
                "platform" => $platform
            ];
        }
    }


    public function addToCart($gameId, $userId, $quantity, $platform)
    {

        //check if the (game,platform) is already in the cart, if it is, update the quantity
        $query = "SELECT * FROM SHOPPING_CARTS WHERE GameId = ? AND UserId = ? AND Platform = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iis", $gameId, $userId, $platform);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $newQuantity = $row["Quantity"] + $quantity;
            $query = "UPDATE SHOPPING_CARTS SET Quantity = ? WHERE GameId = ? AND UserId = ? AND Platform = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("iiis", $newQuantity, $gameId, $userId, $platform);
            $stmt->execute();
            return;
        } else {
            $query = "INSERT INTO SHOPPING_CARTS (GameId, UserId, Quantity, Platform) VALUES (?, ?, ?, ?)";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("iiis", $gameId, $userId, $quantity, $platform);
            $stmt->execute();
        }
    }

    public function removeFromCart($gameId, $userId, $platform)
    {
        $query = "DELETE FROM SHOPPING_CARTS WHERE GameId = ? AND UserId = ? AND Platform = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iis", $gameId, $userId, $platform);
        $stmt->execute();
    }

    public function modifyGameInCart($gameId, $userId, $quantity, $platform)
    {
        $query = "UPDATE SHOPPING_CARTS SET Quantity = Quantity + ? WHERE GameId = ? AND UserId = ? AND Platform = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iiis", $quantity, $gameId, $userId, $platform);
        $stmt->execute();

        //delete the game from the cart if the quantity is 0
        $query = "DELETE FROM SHOPPING_CARTS WHERE Quantity = 0";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
    }

    public function checkout($userId)
    {
        // Check for stock availability for every (game, platform) in the cart
        $query = "
            SELECT 
                SC.GameId, 
                SC.Quantity, 
                SC.Platform, 
                SP.Stock,
                G.Name
            FROM 
                SHOPPING_CARTS SC
            JOIN 
                SUPPORTED_PLATFORMS SP ON SC.GameId = SP.GameId AND SC.Platform = SP.Platform
            JOIN 
                GAMES G ON SC.GameId = G.Id
            WHERE 
                SC.UserId = ?    
        ";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();

        while ($row = $result->fetch_assoc()) {
            if ($row["Quantity"] > $row["Stock"]) {
                return [
                    'success' => false,
                    'message' => 'out_of_stock',
                    'game_name' => $row["Name"],
                    'platform' => $row["Platform"],
                    'available_stock' => $row["Stock"],
                    'requested_quantity' => $row["Quantity"]
                ];
            }
        }

        // Step 1: Calculate the total cost of the shopping cart, applying discounts if applicable
        $query = "
            SELECT 
                SUM(
                    (CASE 
                        WHEN DG.Percentage IS NOT NULL AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate 
                        THEN G.Price * (1 - DG.Percentage / 100) 
                        ELSE G.Price 
                    END) * SC.Quantity
                ) AS Total
            FROM 
                SHOPPING_CARTS SC
            JOIN 
                GAMES G ON SC.GameId = G.Id
            LEFT JOIN 
                DISCOUNTED_GAMES DG ON SC.GameId = DG.GameId
            WHERE 
                SC.UserId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        $total = $result->fetch_assoc()["Total"];

        if (!$total) {
            throw new Exception("Cart is empty or an error occurred.");
        }

        // Check if the user has enough balance
        $query = "SELECT Balance FROM USERS WHERE UserID = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        $balance = $result->fetch_assoc()["Balance"];

        if ($balance < $total) {
            return [
                'success' => false,
                'message' => 'no_funds'
            ];
        }

        // Update user balance
        $query = "UPDATE USERS SET Balance = Balance - ? WHERE UserID = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("di", $total, $userId);
        $stmt->execute();

        // Step 2: Create a new row in the ORDERS table
        $query = "INSERT INTO ORDERS (UserId, OrderDate, TotalCost, Status) 
                  VALUES (?, NOW(), ?, 'Pending')";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("id", $userId, $total);
        $stmt->execute();
        $orderId = $this->db->insert_id; // Get the generated OrderId

        // Step 3: Retrieve items from the shopping cart and insert into ORDER_ITEMS, applying discounts
        $query = "
            SELECT 
                SC.GameId,
                SC.Quantity,
                G.Price,
                SC.Platform,
                (CASE 
                    WHEN DG.Percentage IS NOT NULL AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate 
                    THEN G.Price * (1 - DG.Percentage / 100) 
                    ELSE G.Price 
                END) AS FinalPrice
            FROM 
                SHOPPING_CARTS SC
            JOIN 
                GAMES G ON SC.GameId = G.Id
            LEFT JOIN 
                DISCOUNTED_GAMES DG ON SC.GameId = DG.GameId
            WHERE 
                SC.UserId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $orderItemsResult = $stmt->get_result(); // Renamed variable to avoid conflict

        // If the cart is empty, return an error
        if ($orderItemsResult->num_rows == 0) {
            return [
                'success' => false,
                'message' => 'empty_cart'
            ];
        }

        while ($row = $orderItemsResult->fetch_assoc()) {
            $gameId = $row["GameId"];
            $quantity = $row["Quantity"];
            $price = $row["FinalPrice"];
            $platform = $row["Platform"];

            // Insert into ORDER_ITEMS
            $query = "INSERT INTO ORDER_ITEMS (OrderId, GameId, Platform, Quantity, FinalPrice) 
                      VALUES (?, ?, ?, ?, ?)";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("iisdi", $orderId, $gameId, $platform, $quantity, $price);
            $stmt->execute();

            // Update stock in SUPPORTED_PLATFORMS
            $query = "UPDATE SUPPORTED_PLATFORMS SET Stock = Stock - ? WHERE GameId = ? AND Platform = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("iis", $quantity, $gameId, $platform);
            $stmt->execute();

            // Check if stock reached zero without overriding the outer loop result
            $query = "SELECT Stock FROM SUPPORTED_PLATFORMS WHERE GameId = ? AND Platform = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param("is", $gameId, $platform);
            $stmt->execute();
            $stockResult = $stmt->get_result(); // Use a different variable here
            $stockRow = $stockResult->fetch_assoc();


            //notify the admin of the new order
            $this->notifyAdmin("new_order", "A new order has been placed by " . $this->getUser($userId)["Username"]);

            if ($stockRow["Stock"] == 0) {
                $gameName = $this->getGameById($gameId)[0]["Name"];
                $this->notifyAdmin("out_of_stock", "The game " . $gameName . " is now out of stock for the platform " . $platform);
            }
        }

        // Step 4: Clear the shopping cart
        $query = "DELETE FROM SHOPPING_CARTS WHERE UserId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $userId);
        $stmt->execute();




        return [
            'success' => true,
            'message' => 'checkout_success'
        ];
    }


    public function addReviewToGame($gameId, $userId, $title, $comment, $rating)
    {
        $query = "INSERT INTO REVIEWS (GameId, UserID, Title, Comment, Rating) VALUES (?, ?, ?, ?, ?)";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iissi", $gameId, $userId, $title, $comment, $rating);
        $stmt->execute();
    }




    public function getGameRequirements($id)
    {
        $query = "SELECT * FROM PC_GAME_REQUIREMENTS WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    public function getGameCategories($id)
    {
        $query = "SELECT * FROM GAME_CATEGORIES WHERE GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    //based on the latest published games
    public function getRelevantGames($num)
    {
        $query = "SELECT G.*, DG.Percentage AS Discount FROM GAMES G INNER JOIN DISCOUNTED_GAMES DG ON G.Id = DG.GameId WHERE CURDATE() BETWEEN DG.StartDate AND DG.EndDate ORDER BY G.ReleaseDate DESC LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $num);
        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC));
    }

    public function getDiscountedRelevantGames($num)
    {
        $query = "SELECT G.*, DG.Percentage AS Discount, DG.StartDate, DG.EndDate FROM GAMES G INNER JOIN DISCOUNTED_GAMES DG ON G.Id = DG.GameId WHERE CURDATE() BETWEEN DG.StartDate AND DG.EndDate ORDER BY G.ReleaseDate DESC LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $num);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getDiscountedGames($lim)
    {
        $query = "
            SELECT 
                G.*, 
                DG.Percentage AS Discount,
                DG.StartDate, 
                DG.EndDate
            FROM 
                GAMES G
            INNER JOIN 
                DISCOUNTED_GAMES DG ON G.Id = DG.GameId
            WHERE 
                CURDATE() BETWEEN DG.StartDate AND DG.EndDate
            ORDER BY DG.EndDate DESC
            LIMIT ?
                ";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $lim);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getDiscountedGamesByCategory($category, $start, $end)
    {
        // Parse the range (default to no range if null)
        $limit = null;
        $offset = null;

        if ($start !== null && $end !== null) {
            $offset = $start;
            $limit = $end - $offset + 1;
        }



        $query = "
        SELECT 
            G.*, 
            DG.Percentage AS Discount,
            DG.StartDate, 
            DG.EndDate
        FROM 
            GAMES G
        INNER JOIN 
            DISCOUNTED_GAMES DG ON G.Id = DG.GameId
        INNER JOIN 
            GAME_CATEGORIES GC ON G.Id = GC.GameId
        INNER JOIN 
            CATEGORIES C ON GC.CategoryName = C.CategoryName
        WHERE 
            CURDATE() BETWEEN DG.StartDate AND DG.EndDate
        AND 
            C.CategoryName = ?
        ORDER BY DG.EndDate DESC";

        // Add LIMIT and OFFSET if a range is specified
        if ($limit !== null && $offset !== null) {
            $query .= " LIMIT ? OFFSET ?";
        }

        $stmt = $this->db->prepare($query);

        if ($limit !== null && $offset !== null) {
            // Bind parameters for category, limit, and offset
            $stmt->bind_param("sii", $category, $limit, $offset);
        } else {
            // Bind only the category
            $stmt->bind_param("s", $category);
        }

        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getSupportedPlatforms($gameId)
    {
        $query = "
            SELECT 
                SP.Platform,
                SP.Stock
            FROM 
                SUPPORTED_PLATFORMS SP
            WHERE 
                SP.GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        $stmt->execute();
        $result = $stmt->get_result();
        $var = $result->fetch_all(MYSQLI_ASSOC);

        return $var;
    }

    public function getSimilarGames($gameId, $lim)
    {
        $query = "
        SELECT g.Id, g.Name, g.Price, g.Trailer, g.Rating, DG.Percentage AS Discount
        FROM GAMES g
        INNER JOIN GAME_CATEGORIES gc1 ON g.Id = gc1.GameId
        INNER JOIN GAME_CATEGORIES gc2 ON gc1.CategoryName = gc2.CategoryName
        LEFT JOIN 
            DISCOUNTED_GAMES DG ON g.Id = DG.GameId
            AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
        WHERE gc2.GameId = ? AND g.Id != ?
        GROUP BY g.Id
        ORDER BY COUNT(gc1.CategoryName) DESC, g.Rating DESC
        LIMIT ?
    ";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iii", $gameId, $gameId, $lim);
        $stmt->execute();
        $result = $stmt->get_result();

        $similarGames = [];
        while ($row = $result->fetch_assoc()) {
            $similarGames[] = $row;
        }

        $stmt->close();
        return $similarGames;
    }

    public function getSearchedGames($gameName, $lim)
    {
        $query = "SELECT GamesWithCondition.*, DG.Percentage AS Discount FROM ( SELECT G.* FROM GAMES AS G WHERE G.Name LIKE CONCAT(?, '%') UNION SELECT G.* FROM GAMES AS G WHERE G.Name LIKE CONCAT('%',?, '%') AND G.Name NOT LIKE CONCAT(?, '%') ) AS GamesWithCondition LEFT JOIN `DISCOUNTED_GAMES` AS DG ON GamesWithCondition.Id = DG.GameID AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate LIMIT ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param("sssi", $gameName, $gameName, $gameName, $lim);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function addSupportedPlatforms($games)
    {

        foreach ($games as &$game) {
            $gameId = $game["Id"];
            $game["Platforms"] = $this->getSupportedPlatforms($gameId);
        }

        return $games;
    }


    public function addCategories($games)
    {
        foreach ($games as &$game) {
            $gameId = $game["Id"];
            $game["Categories"] = $this->getCategoriesForGame($gameId);
        }

        return $games;
    }

    public function addNewNotification($userId, $type, $message, $status)
    {
        $query = "INSERT INTO NOTIFICATIONS (UserId, Type, Message, Status) VALUES (?, ?, ?, ?);";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('isss', $userId, $type, $message, $status);
        $stmt->execute();
        return true;
    }

    public function getNotifications($id)
    {
        $query = "
            SELECT *
            FROM 
                NOTIFICATIONS N
            WHERE 
                N.UserId = ?
            ORDER BY 
                N.SentAt DESC
                ";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    //get the most rated games by joining the GAMES and REVIEWS tables and computing the average rating for each game, algo join with discount in order to get the discount
    public function getMostRatedGames($lim)
    {
        $query = "
            SELECT 
                G.*,
                IFNULL(DG.Percentage, 0) AS Discount,
                DG.StartDate,
                DG.EndDate
            FROM 
                GAMES G
            LEFT JOIN 
                DISCOUNTED_GAMES DG ON G.Id = DG.GameId
                AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
            LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $lim);
        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addCategories($this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC)));
    }

    public function getMostRatedGamesByCategory($category, $start, $end)
    {
        // Parse the range (default to no range if null)
        $limit = null;
        $offset = null;

        if ($start !== null && $end !== null) {
            $offset = $start;
            $limit = $end - $offset + 1;
        }

        $query = "
        SELECT 
            G.*,
            IFNULL(DG.Percentage, 0) AS Discount,
            DG.StartDate,
            DG.EndDate
        FROM 
            GAMES G
        INNER JOIN 
            GAME_CATEGORIES GC ON G.Id = GC.GameId
        INNER JOIN 
            CATEGORIES C ON GC.CategoryName = C.CategoryName
        LEFT JOIN 
            DISCOUNTED_GAMES DG ON G.Id = DG.GameId
            AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
        WHERE 
            C.CategoryName = ?
        ORDER BY 
            G.Rating DESC"; // Add ordering by Rating

        // Add LIMIT and OFFSET if a range is specified
        if ($limit !== null && $offset !== null) {
            $query .= " LIMIT ? OFFSET ?";
        }

        $stmt = $this->db->prepare($query);

        if ($limit !== null && $offset !== null) {
            // Bind parameters for category, limit, and offset
            $stmt->bind_param("sii", $category, $limit, $offset);
        } else {
            // Bind only the category
            $stmt->bind_param("s", $category);
        }

        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addCategories($this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC)));
    }

    public function getMostSoldGames($lim)
    {
        $query = "
            SELECT 
                G.Id, 
                G.Name, 
                G.Price, 
                G.Rating,
                IFNULL(DG.Percentage, 0) AS Discount
            FROM 
                GAMES G
            LEFT JOIN 
                DISCOUNTED_GAMES DG ON G.Id = DG.GameId
                AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
            GROUP BY 
                G.Id
            ORDER BY 
                CopiesSold DESC
            LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $lim);
        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC));
    }

    public function getMostSoldGamesByCategory($category, $start, $end)
    {
        // Parse the range (default to no range if null)
        $limit = null;
        $offset = null;

        if ($start !== null && $end !== null) {
            $offset = $start;
            $limit = $end - $offset + 1;
        }

        $query = "
        SELECT 
            G.Id, 
            G.Name, 
            G.Price, 
            G.Rating,
            IFNULL(DG.Percentage, 0) AS Discount
        FROM 
            GAMES G
        INNER JOIN 
            GAME_CATEGORIES GC ON G.Id = GC.GameId
        INNER JOIN 
            CATEGORIES C ON GC.CategoryName = C.CategoryName
        LEFT JOIN 
            DISCOUNTED_GAMES DG ON G.Id = DG.GameId
            AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
        WHERE 
            C.CategoryName = ?
        GROUP BY 
            G.Id
        ORDER BY 
            CopiesSold DESC";

        // Add LIMIT and OFFSET if a range is specified
        if ($limit !== null && $offset !== null) {
            $query .= " LIMIT ? OFFSET ?";
        }

        $stmt = $this->db->prepare($query);

        if ($limit !== null && $offset !== null) {
            // Bind parameters for category, limit, and offset
            $stmt->bind_param("sii", $category, $limit, $offset);
        } else {
            // Bind only the category
            $stmt->bind_param("s", $category);
        }

        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC));
    }


    //retrieved the games the games from the GAMES (ordered by release date) table that have a discount in the DISCOUNTED_GAMES table
    public function getLaunchOffers($lim)
    {
        $query = "
            SELECT 
                G.*, 
                DG.Percentage, 
                DG.StartDate, 
                DG.EndDate
            FROM 
                GAMES G
            INNER JOIN 
                DISCOUNTED_GAMES DG ON G.Id = DG.GameId
            WHERE 
                CURDATE() BETWEEN DG.StartDate AND DG.EndDate
            ORDER BY 
                G.ReleaseDate DESC
            LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $lim);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getNewGamesByCategory($category, $start, $end)
    {
        // Parse the range (default to no range if null)
        $limit = null;
        $offset = null;

        if ($start !== null && $end !== null) {
            $offset = $start;
            $limit = $end - $offset + 1;
        }

        $query = "
        SELECT 
            G.*,
            IFNULL(DG.Percentage, 0) AS Discount,
            DG.StartDate,
            DG.EndDate
        FROM 
            GAMES G
        INNER JOIN 
            GAME_CATEGORIES GC ON G.Id = GC.GameId
        INNER JOIN 
            CATEGORIES C ON GC.CategoryName = C.CategoryName
        LEFT JOIN 
            DISCOUNTED_GAMES DG ON G.Id = DG.GameId
            AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
        WHERE 
            C.CategoryName = ?
        ORDER BY 
            G.ReleaseDate DESC";

        // Add LIMIT and OFFSET if a range is specified
        if ($limit !== null && $offset !== null) {
            $query .= " LIMIT ? OFFSET ?";
        }

        $stmt = $this->db->prepare($query);

        if ($limit !== null && $offset !== null) {
            // Bind parameters for category, limit, and offset
            $stmt->bind_param("sii", $category, $limit, $offset);
        } else {
            // Bind only the category
            $stmt->bind_param("s", $category);
        }

        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addCategories($this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC)));
    }


    public function getCategoriesForGame($gameId)
    {
        $query = "
            SELECT 
                GC.CategoryName
            FROM 
                GAME_CATEGORIES GC
            WHERE 
                GC.GameId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $gameId);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }




    public function getCategories()
    {
        $query = "SELECT * FROM CATEGORIES";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getReviewsByGame($gameId, $start = null, $end = null)
    {
        // Parse the range (default to no range if null)
        $limit = null;
        $offset = null;

        if ($start !== null && $end !== null) {
            $offset = $start;
            $limit = $end - $offset + 1;
        }

        $query = "
        SELECT 
            REVIEWS.*, 
            USERS.Username, 
            USERS.UserID, 
            AVATARS.Avatar
        FROM 
            REVIEWS
        JOIN 
            USERS ON REVIEWS.UserID = USERS.UserID
        JOIN 
            AVATARS ON USERS.AvatarId = AVATARS.Id
        WHERE 
            REVIEWS.GameID = ?
        ORDER BY 
            REVIEWS.CreatedAt DESC";

        // Add LIMIT and OFFSET if a range is specified
        if ($limit !== null && $offset !== null) {
            $query .= " LIMIT ? OFFSET ?";
        }

        $stmt = $this->db->prepare($query);

        if ($limit !== null && $offset !== null) {
            // Bind parameters for gameId, limit, and offset
            $stmt->bind_param("iii", $gameId, $limit, $offset);
        } else {
            // Bind only the gameId
            $stmt->bind_param("i", $gameId);
        }

        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    /*
    function checkbrute($UserID)
    {
        // Recupero il timestamp
        $now = time();
        // Vengono analizzati tutti i tentativi di login a partire dalle ultime due ore.
        $valid_attempts = $now - (2 * 60 * 60);
        if ($stmt = $this->db->prepare("SELECT time FROM LoginAttempts WHERE UserID = ? AND time > '$valid_attempts'")) {
            $stmt->bind_param('i', $UserID);
            // Eseguo la query creata.
            $stmt->execute();
            $stmt->store_result();
            // Verifico l'esistenza di più di 5 tentativi di login falliti.
            if ($stmt->num_rows > 5) {
                return true;
            } else {
                return false;
            }
        }
    }
        */

    public function getUser($UserID)
    {
        $stmt = $this->db->prepare("SELECT * FROM USERS JOIN AVATARS ON USERS.AvatarId = AVATARS.Id WHERE UserID = ?");
        $stmt->bind_param('i', $UserID);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    public function registerNewUser($Userdata)
    {
        //TODO:NOTIFICATION to admin
        $query = "INSERT INTO USERS (Username, Email, PasswordHash, Salt, FirstName, LastName, PhoneNumber, Address, City, DateOfBirth, AvatarId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
        $stmt = $this->db->prepare($query);
        $salt = hash('sha256', uniqid(mt_rand(), true));
        $password = hash('sha256', $Userdata["Password"] . $salt);
        //check for email and username uniqueness
        $verify_unique = $this->db->prepare("SELECT * FROM USERS WHERE Email = ? OR Username = ?");
        $verify_unique->bind_param('ss', $Userdata["Email"], $Userdata["Username"]);
        $verify_unique->execute();
        $verify_result = $verify_unique->get_result();
        if ($verify_result->num_rows > 0) {
            return false;
        }
        $stmt->bind_param('ssssssssssi', $Userdata["Username"], $Userdata["Email"], $password, $salt, $Userdata["FirstName"], $Userdata["LastName"], $Userdata["PhoneNumber"], $Userdata["Address"], $Userdata["City"], $Userdata["DateOfBirth"], $Userdata["AvatarId"]);
        $stmt->execute();

        //if Userdata["Role"] is set to "Admin" the user will be registered as an admin
        if ($Userdata["Username"] == "admin") {
            $query = "UPDATE USERS SET Role = 'Admin' WHERE Username = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param('s', $Userdata["Username"]);
            $stmt->execute();
        }
        return true;
    }

    public function login($Username, $password)
    {
        // Usando statement sql 'prepared' non sarà possibile attuare un attacco di tipo SQL injection.
        if ($stmt = $this->db->prepare("SELECT UserID, Email, PasswordHash, Salt FROM USERS WHERE Username = ? LIMIT 1")) {
            $stmt->bind_param('s', $Username); // esegue il bind del parametro '$email'.
            $stmt->execute(); // esegue la query appena creata.
            $stmt->store_result();
            $UserID = $Email = $db_password =  $salt = "";
            $stmt->bind_result($UserID, $Email, $db_password, $salt); // recupera il risultato della query e lo memorizza nelle relative variabili.
            $stmt->fetch();
            $password = hash('sha256', $password . $salt); // codifica la password usando una chiave univoca.
            if ($stmt->num_rows == 1) { // se l'utente esiste
                // verifichiamo che non sia disabilitato in seguito all'esecuzione di troppi tentativi di accesso errati.
                /*if ($this->checkbrute($UserID, $this->db) == true) {
                    //empy tuple
                    return false;
                    */

                if ($db_password == $password) { // Verifica che la password memorizzata nel database corrisponda alla password fornita dall'utente.
                    // Password corretta!            
                    $user_browser = $_SERVER['HTTP_USER_AGENT']; // Recupero il parametro 'user-agent' relativo all'utente corrente.

                    $UserID = preg_replace("/[^0-9]+/", "", $UserID); // ci proteggiamo da un attacco XSS
                    $_SESSION['UserID'] = $UserID;
                    $Username = preg_replace("/[^a-zA-Z0-9_\-]+/", "", $Username); // ci proteggiamo da un attacco XSS
                    $_SESSION['Username'] = $Username;
                    $_SESSION['Email'] = $Email;
                    $_SESSION['LoginString'] = hash('sha256', $password . $user_browser);
                    $_SESSION['Avatar'] = $this->getUser($UserID)["Avatar"];
                    $_SESSION["isAdmin"] = $this->getUser($UserID)["Role"] == "Admin";
                    // Login eseguito con successo.
                    return true;
                } else {
                    // Password incorretta.
                    // Registriamo il tentativo fallito nel database.
                    $now = time();
                    //$this->db->query("INSERT INTO login_attempts (UserID, time) VALUES ('$UserID', '$now')");
                    return false;
                }
            } else {
                // L'utente inserito non esiste.
                return false;
            }
        }
    }

    function login_check()
    {
        // Verifica che tutte le variabili di sessione siano impostate correttamente
        if (isset($_SESSION['UserID'], $_SESSION['Username'], $_SESSION['LoginString'])) {
            $UserID = $_SESSION['UserID'];
            $LoginString = $_SESSION['LoginString'];
            $Username = $_SESSION['Username'];
            $user_browser = $_SERVER['HTTP_USER_AGENT']; // reperisce la stringa 'user-agent' dell'utente.
            if ($stmt = $this->db->prepare("SELECT password FROM USERS WHERE UserID = ? LIMIT 1")) {
                $stmt->bind_param('i', $UserID); // esegue il bind del parametro '$UserID'.
                $stmt->execute(); // Esegue la query creata.
                $stmt->store_result();


                if ($stmt->num_rows == 1) { // se l'utente esiste
                    $password = ""; // estrae le variabili dal risultato ottenuto.
                    $stmt->bind_result($password); // recupera le variabili dal risultato ottenuto.
                    $stmt->fetch();
                    $login_check = hash('sha256', $password . $user_browser);
                    if ($login_check == $LoginString) {
                        // Login eseguito!!!!
                        return true;
                    } else {
                        //  Login non eseguito
                        return false;
                    }
                } else {
                    // Login non eseguito
                    return false;
                }
            } else {
                // Login non eseguito
                return false;
            }
        } else {
            // Login non eseguito
            return false;
        }
    }

    // Function to increment failed login attempts
    private function incrementFailedLoginAttempts($userID)
    {
        $query = "UPDATE USERS SET LoginAttempts = LoginAttempts + 1 WHERE UserID = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $userID);
        $stmt->execute();
    }

    // Function to reset failed login attempts
    private function resetFailedLoginAttempts($userID)
    {
        $query = "UPDATE USERS SET LoginAttempts = 0 WHERE UserID = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $userID);
        $stmt->execute();
    }

    // Function to update the last login timestamp
    private function updateLastLogin($userID)
    {
        $query = "UPDATE USERS SET LastLoginAt = NOW() WHERE UserID = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $userID);
        $stmt->execute();
    }
}
