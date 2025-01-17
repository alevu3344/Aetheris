import mysql.connector
import hashlib

config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',  
    'database': 'AetherisDB'
}


# Function to hash a password with salt
def hash_password_with_salt(password, salt):
    # Concatenate password and salt, then hash the result
    combined = password + salt
    return hashlib.sha256(combined.encode()).hexdigest()


try:
    conn = mysql.connector.connect(**config)
    print("Connessione al database riuscita!")

    cursor = conn.cursor()
    cursor.execute("SELECT UserId, Username, DELETEMEClearPassword, Salt FROM USERS")  # Fetch user data including password and salt
    users = cursor.fetchall()
    
    for user in users:
        user_id, user_name, clear_password, salt = user

        # Hash the password with the salt
        hashed_password = hash_password_with_salt(clear_password, salt)
        
        # Update the PasswordHash column with the combined hash of the clear password and the salt
        cursor.execute(
            "UPDATE USERS SET PasswordHash = %s WHERE UserId = %s", 
            (hashed_password, user_id)
        )
        print(f"Updated user {user_name} with hashed password.")

    conn.commit()
    print("All users updated successfully!")
except Exception as e:
    print("Error:", e)
finally:
    # Close the connection
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("Connessione chiusa.")
