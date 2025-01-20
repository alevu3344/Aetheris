<?php

class DatabaseHelper{
    private $db;

    public function __construct($servername, $username, $password, $dbname, $port){
        $this->db = new mysqli($servername, $username, $password, $dbname, $port);
        if($this->db->connect_error){
            die("Connessione fallita al db: " . $this->db->connect_error);
        }
    }

    public function getGamesByCategory($category, $lim){
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
    
    // this function returns a list of tuples (GameId, GameName, Quantity, OriginalPrice, Discount (0% if not discounted))
    public function getShoppingCart($userId){
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

    public function getGameById($id){
        $query = "SELECT * FROM GAMES WHERE Id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    //based on the latest published games
    public function getRelevantGames($num){
        $query = "SELECT * FROM GAMES ORDER BY ReleaseDate DESC LIMIT ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $num);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    public function getDiscountedGames($lim){
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
            ORDER BY RAND()
            LIMIT ?
                ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    

    public function getCategories(){
        $query = "SELECT * FROM CATEGORIES";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    //get all the reviews for a game, ordered by date
    public function getReviewsByGame($id){
        $query = "SELECT * FROM REVIEWS WHERE GameId = ? ORDER BY Date DESC";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }
}

?>
