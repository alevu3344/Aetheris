import mysql.connector

# Database configuration
config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'database': 'AetherisDB'
}

# Read passwords from the text file
def read_passwords(file_path):
    with open(file_path, 'r') as file:
        # Read passwords, strip any extra spaces or newlines
        passwords = [line.strip() for line in file.readlines()]
    return passwords

try:
    # Connect to the database
    conn = mysql.connector.connect(**config)
    print("Connessione al database riuscita!")

    # Create a cursor for executing queries
    cursor = conn.cursor()

    # Fetch users from the database (make sure the number of users matches the number of passwords)
    cursor.execute("SELECT UserId, Username FROM USERS")
    users = cursor.fetchall()
    
    # Read the passwords from the file
    passwords = read_passwords("passwords.txt")
    
    if len(users) != len(passwords):
        print("Error: The number of users and passwords do not match.")
    else:
        # Loop over the users and assign each password
        for i, (user_id, user_name) in enumerate(users):
            password = passwords[i]
            # Update the DELETEMEClearPassword column for the user
            cursor.execute(
                "UPDATE USERS SET DELETEMEClearPassword = %s WHERE UserId = %s",
                (password, user_id)
            )
            print(f"Updated user {user_name} with a new password.")
        
        # Commit the changes to the database
        conn.commit()
        print("All users' passwords updated successfully!")

except Exception as e:
    print("Error:", e)

finally:
    # Close the connection
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("Connessione chiusa.")
