import mysql.connector
import random
from datetime import datetime, timedelta

# Configuration for MySQL connection
config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',  
    'database': 'AetherisDB'
}

# Function to generate random date between now and 30 days in the future
def generate_random_end_date():
    start_date = datetime.now()  # Set StartDate to now
    end_date = start_date + timedelta(days=random.randint(1, 30))  # Random EndDate, between 1 and 30 days after StartDate
    return start_date, end_date

# Function to generate a random discount between 5% and 60%
def generate_random_discount(min_discount=5, max_discount=60):
    return random.randint(min_discount, max_discount)

try:
    conn = mysql.connector.connect(**config)
    print("Connessione al database riuscita!")

    cursor = conn.cursor()

    # Step 1: Select 25% of games
    cursor.execute("SELECT Id FROM GAMES")
    all_games = cursor.fetchall()
    
    # Approximately 25% of all games
    num_discounted_games = len(all_games) // 3
    discounted_game_ids = random.sample([game[0] for game in all_games], num_discounted_games)

    # Step 2: Insert random discounts for each selected game
    for game_id in discounted_game_ids:
        discount_percentage = generate_random_discount()
        start_date, end_date = generate_random_end_date()

        # Insert the discounted game into DISCOUNTED_GAMES table
        cursor.execute(
            """
            INSERT INTO DISCOUNTED_GAMES (GameId, Percentage, StartDate, EndDate)
            VALUES (%s, %s, %s, %s)
            """, 
            (game_id, discount_percentage, start_date.strftime('%Y-%m-%d'), end_date.strftime('%Y-%m-%d'))
        )
        print(f"Game ID {game_id} discounted by {discount_percentage}% from {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}")

    # Commit changes to the database
    conn.commit()
    print("Discounts applied successfully!")

except Exception as e:
    print("Error:", e)
finally:
    # Close the connection
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("Connessione chiusa.")
