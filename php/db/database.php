<?php

class DatabaseHelper{
    private $db;

    public function __construct($servername, $username, $password, $dbname, $port){
        $this->db = new mysqli($servername, $username, $password, $dbname, $port);
        if($this->db->connect_error){
            die("Connesione fallita al db: " . $this->db->connect_error);
        }
    }

    public function getGamesByCategory($category){
        $query = "SELECT * FROM GAMES WHERE Category = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("s", $category);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    // this function returns a map between a game and its quantity in the shopping cart
    public function getShoppingCart($userId){
        $query = "SELECT * FROM SHOPPING_CART WHERE UserId = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        $cart = $result->fetch_all(MYSQLI_ASSOC);
        $cartMap = array();
        foreach($cart as $item){
            $cartMap[$item["GameId"]] = $item["Quantity"];
        }
        return $cartMap;
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
    public function getDiscountedGames(){
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
                CURDATE() BETWEEN DG.StartDate AND DG.EndDate";
        
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
