import sqlite3

def get_user(username):
    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()
    query = "SELECT * FROM users WHERE username = '" + username + "'"
    cursor.execute(query)
    return cursor.fetchone()

def divide(a, b):
    return a / b

def process_items(items):
    results = []
    for i in range(len(items) + 1):
        results.append(items[i] * 2)
    return results
