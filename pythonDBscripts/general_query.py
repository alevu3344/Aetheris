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

    cursor = conn.cursor()
    cursor.execute("SELECT Id, Name FROM GAMES")  # Fetch user data including password and salt
    games = cursor.fetchall()
    
    #output all the names to file
    with open("output.txt", "w") as file:
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
