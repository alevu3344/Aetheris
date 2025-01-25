<?php

class DatabaseHelper
{
    private $db;

    public function __construct($servername, $Username, $password, $dbname, $port)
    {
        $this->db = new mysqli($servername, $Username, $password, $dbname, $port);
        if ($this->db->connect_error) {
            die("Connessione fallita al db: " . $this->db->connect_error);
        }
    }

    public function getOrdersForUser($UserID)
    {
        $query = "
        SELECT * 
        FROM 
            ORDERS 
        WHERE 
            UserID = ?
        ";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $UserID);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getOrderDetails($OrderID)
    {
        // Define the SQL query with the necessary joins
        $query = "
            SELECT 
            O.*,
            U.UserID AS UserID, 
            G.Name AS GameName,
            G.Id AS GameID,
            OI.*
            FROM 
                ORDERS O
            INNER JOIN 
                USERS U ON O.UserId = U.UserID -- Correct join column
            INNER JOIN 
                ORDER_ITEMS OI ON O.Id = OI.OrderId
            INNER JOIN 
                GAMES G ON OI.GameId = G.Id
            WHERE O.Id = ?;
        ";

        // Prepare the statement
        $stmt = $this->db->prepare($query);

        // Bind the OrderID parameter
        $stmt->bind_param('i', $OrderID);

        // Execute the query
        $stmt->execute();

        $result = $stmt->get_result();

        // Fetch all results
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

    public function getGamesByCategory($category, $lim)
    {
        $query = "
            SELECT 
                G.Id, 
                G.Name, 
                G.Price, 
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
                AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
            WHERE 
                C.CategoryName = ?
            ORDER BY G.Price DESC
            LIMIT ?
                ";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("si", $category, $lim);
        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC));
    }

    // this function returns a list of tuples (GameId, GameName, Quantity, OriginalPrice, Discount (0% if not discounted))
    public function getShoppingCart($userId)
    {
        $query = "
            SELECT 
                G.Id, 
                G.Name, 
                SC.Quantity, 
                G.Price, 
                IFNULL(DG.Percentage, 0) AS Discount
            FROM 
                SHOPPING_CART SC
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
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getGameById($id)
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
            WHERE 
                G.Id = ?
        ";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        // Fetch the game data (including discount if available and valid)
        return $result->fetch_assoc();
    }

    public function buyGame($gameId, $userId, $quantity, $total, $platform)
    {
        // Insert into ORDERS table
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

    public function removeFromCart($gameId, $userId, $quantity, $platform)
    {
        $query = "DELETE FROM SHOPPING_CART WHERE GameId = ? AND UserId = ? AND Quantity = ? AND Platform = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iiis", $gameId, $userId, $quantity, $platform);
        $stmt->execute();
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
        $query = "SELECT * FROM GAMES ORDER BY ReleaseDate DESC LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $num);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
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
                SP.Platform
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
        $query = "SELECT GamesWithCondition.* FROM ( SELECT G.* FROM GAMES AS G WHERE G.Name LIKE CONCAT(?, '%') UNION SELECT G.* FROM GAMES AS G WHERE G.Name LIKE CONCAT('%',?, '%') AND G.Name NOT LIKE CONCAT(?, '%') ) AS GamesWithCondition LEFT JOIN `DISCOUNTED_GAMES` AS DG ON GamesWithCondition.Id = DG.GameID AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate LIMIT ?";

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
