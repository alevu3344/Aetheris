import mysql.connector
import hashlib

config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',  
    'database': 'AetherisDB'
}



try:
    conn = mysql.connector.connect(**config)
    print("Connessione al database riuscita!")
    #selezione gli id e i nomi in GAMES che hanno in SUPPORTED_PLATFORMS "PC"
    cursor = conn.cursor()
    cursor.execute("""
                    SELECT G.Id AS GameId, G.Name AS GameName
                    FROM GAMES G
                    JOIN SUPPORTED_PLATFORMS SP ON G.Id = SP.GameId
                    WHERE SP.Platform = 'PC';
                   """
                   )  # Fetch user data including password and salt
    games = cursor.fetchall()
    
    #output all the names to file
    with open("output_pc.txt", "w") as file:
        for game in games:
            game_id, game_name = game
            file.write(f"{game_id}, Name: {game_name}\n")
    

   
    
except Exception as e:
    print("Error:", e)
finally:
    # Close the connection
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("Connessione chiusa.")
