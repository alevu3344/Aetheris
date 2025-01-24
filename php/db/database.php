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
                DG.Percentage AS Discount
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
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getTopRatedGames($lim)
    {
        $query = "
            SELECT 
                G.Id, 
                G.Name, 
                G.Price, 
                AVG(R.Rating) AS AvgRating
            FROM 
                GAMES G
            LEFT JOIN 
                REVIEWS R ON G.Id = R.GameId
            GROUP BY 
                G.Id
            ORDER BY 
                AvgRating DESC
            LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $lim);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
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
                IFNULL(DG.Percentage, 0) AS Discount
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

    public function getDiscountedRelevantGames($num){
        $query = "SELECT G.*, DG.Percentage AS Discount FROM GAMES G INNER JOIN DISCOUNTED_GAMES DG ON G.Id = DG.GameId WHERE CURDATE() BETWEEN DG.StartDate AND DG.EndDate ORDER BY G.ReleaseDate DESC LIMIT ?";
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

    //i guess
    public function getSimilarGames($gameId, $lim)
    {
        $query = "
            SELECT 
                G.*, 
                DG.Percentage AS Discount
            FROM 
                GAMES G
            INNER JOIN 
                GAME_CATEGORIES GC ON G.Id = GC.GameId
            INNER JOIN 
                GAME_CATEGORIES GC2 ON GC.CategoryName = GC2.CategoryName
            LEFT JOIN 
                DISCOUNTED_GAMES DG ON G.Id = DG.GameId
                AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
            WHERE 
                GC2.GameId = ?
            AND 
                G.Id != ?
            ORDER BY 
                RAND()
            LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("iii", $gameId, $gameId, $lim);
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

    //get the most rated games by joining the GAMES and REVIEWS tables and computing the average rating for each game, algo join with discount in order to get the discount
    public function getMostRatedGames($lim)
    {
        $query = "
            SELECT 
                G.Id, 
                G.Name, 
                G.Price, 
                AVG(R.Rating) AS AvgRating, 
                IFNULL(DG.Percentage, 0) AS Discount
            FROM 
                GAMES G
            LEFT JOIN 
                REVIEWS R ON G.Id = R.GameId
            LEFT JOIN 
                DISCOUNTED_GAMES DG ON G.Id = DG.GameId
                AND CURRENT_DATE BETWEEN DG.StartDate AND DG.EndDate
            GROUP BY 
                G.Id
            ORDER BY 
                AvgRating DESC
            LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $lim);
        $stmt->execute();
        $result = $stmt->get_result();
        return $this->addSupportedPlatforms($result->fetch_all(MYSQLI_ASSOC));
    }

    public function getMostSoldGames($lim)
    {
        $query = "
            SELECT 
                G.Id, 
                G.Name, 
                G.Price, 
                AVG(R.Rating) AS AvgRating, 
                IFNULL(DG.Percentage, 0) AS Discount
            FROM 
                GAMES G
            LEFT JOIN 
                REVIEWS R ON G.Id = R.GameId
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


    public function getCategories()
    {
        $query = "SELECT * FROM CATEGORIES";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    //get all the reviews for a game, ordered by date
    public function getReviewsByGame($id)
    {

        $stmt = $this->db->prepare("
        SELECT REVIEWS.*, USERS.Username, USERS.UserID, AVATARS.Avatar
        FROM REVIEWS
        JOIN 
        USERS ON REVIEWS.UserID = USERS.UserID
        JOIN 
        AVATARS ON USERS.AvatarId = AVATARS.Id
        WHERE 
        REVIEWS.GameID = ?;
        ");
        $stmt->bind_param("i", $id);
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
