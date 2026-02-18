import sqlite3
from werkzeug.security import generate_password_hash

DATABASE = "../instance/manga.sqlite"  # adapte si besoin

def rehash_passwords():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    db = conn.cursor()

    users = db.execute("SELECT id, password FROM user").fetchall()

    for user in users:
        user_id = user["id"]
        password = user["password"]

        # Si déjà hashé, on ignore
        if password.startswith("pbkdf2:"):
            continue

        hashed_password = generate_password_hash(password)

        db.execute(
            "UPDATE user SET password = ? WHERE id = ?",
            (hashed_password, user_id),
        )

        print(f"User {user_id} password rehashed.")

    conn.commit()
    conn.close()
    print("✅ All passwords updated successfully.")

if __name__ == "__main__":
    rehash_passwords()
