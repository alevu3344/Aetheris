import mysql.connector
import random
import datetime

config = {
    'user': 'root',
    'password': '',
    'host': 'localhost', 
    'database': 'AetherisDB'
}


def generate_balance(min_value=0, max_value=10000):
    return round(random.uniform(min_value, max_value), 2)


def generate_random_date(start_year=2022):
    # Generate a random date between January 1, 2022, and today
    start_date = datetime.date(start_year, 1, 1)
    end_date = datetime.date.today()
    
    delta_days = (end_date - start_date).days
    random_days = random.randint(0, delta_days)
    
    random_date = start_date + datetime.timedelta(days=random_days)
    
    # Convert to TIMESTAMP format (YYYY-MM-DD HH:MM:SS)
    return datetime.datetime.combine(random_date, datetime.time.min)


try:
    conn = mysql.connector.connect(**config)
    print("Connessione al database riuscita!")
    
    cursor = conn.cursor()
    cursor.execute("SELECT UserId, Username FROM USERS")  
    users = cursor.fetchall()
    
    for user in users:
        user_id, user_name = user
        
        # Generate a random balance and random last login date
        new_balance = generate_balance()
        random_last_login = generate_random_date()
        
        cursor.execute(
            "UPDATE USERS SET Balance = %s, LastLoginAt = %s WHERE UserId = %s",  
            (new_balance, random_last_login, user_id)
        )
        print(f"Updated user {user_name} with new balance: {new_balance} and LastLoginAt: {random_last_login}")
    
    conn.commit()
    print("All users' balances and LastLoginAt updated successfully!")
except Exception as e:
    print("Error:", e)
finally:
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("Connessione chiusa.")
