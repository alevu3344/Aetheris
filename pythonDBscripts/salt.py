import mysql.connector
import os

config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'database': 'AetherisDB'
}


def generate_salt(length=16):
    return os.urandom(length) 

try:
    conn = mysql.connector.connect(**config)
    print("Connessione al database riuscita!")

    cursor = conn.cursor()
    cursor.execute("SELECT UserId, Username FROM USERS") 
    users = cursor.fetchall()
    
    for user in users:
        user_id, user_name = user

        # Generate a new salt for each user
        salt = generate_salt()
        
    
        cursor.execute(
            "UPDATE USERS SET Salt = %s WHERE UserId = %s", 
            (salt.hex(), user_id) 
        )
        print(f"Updated user {user_name} with new salt.")

    conn.commit()
    print("All users' salts updated successfully!")
except Exception as e:
    print("Error:", e)
finally:
 
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("Connessione chiusa.")
