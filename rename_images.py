import os
import re
import sqlite3
import unicodedata
from pathlib import Path

# ==============================
# CONFIG ADAPTÉE À TON PROJET
# ==============================
DB_PATH = "instance/manga.sqlite"
IMAGE_FOLDER = "manga/static/image"

# ==============================
# FONCTION SLUG PROPRE
# ==============================
def slugify(text):
    # Supprimer accents
    text = unicodedata.normalize("NFD", text)
    text = text.encode("ascii", "ignore").decode("utf-8")

    text = text.lower()
    text = text.replace("'", "")

    # espaces → _
    text = re.sub(r"\s+", "_", text)

    # garder lettres, chiffres, underscore
    text = re.sub(r"[^a-z0-9_]", "", text)

    # supprimer doubles _
    text = re.sub(r"_+", "_", text)

    return text.strip("_")


# ==============================
# SCRIPT PRINCIPAL
# ==============================
conn = sqlite3.connect(DB_PATH)
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

articles = cursor.execute("SELECT id, name, image FROM articles").fetchall()

for article in articles:
    old_image = article["image"]

    # récupérer juste le nom du fichier
    old_filename = Path(old_image).name
    old_path = Path(IMAGE_FOLDER) / old_filename

    if not old_path.exists():
        print(f"Image introuvable : {old_path}")
        continue

    extension = old_path.suffix.lower()
    base_slug = slugify(article["name"])

    new_filename = f"{base_slug}{extension}"
    new_path = Path(IMAGE_FOLDER) / new_filename

    # éviter conflits
    counter = 1
    while new_path.exists():
        new_filename = f"{base_slug}_{counter}{extension}"
        new_path = Path(IMAGE_FOLDER) / new_filename
        counter += 1

    os.rename(old_path, new_path)

    # IMPORTANT : mettre à jour chemin BDD
    new_db_path = f"image/{new_filename}"

    cursor.execute(
        "UPDATE articles SET image = ? WHERE id = ?",
        (new_db_path, article["id"])
    )

    print(f"{old_filename} → {new_filename}")

conn.commit()
conn.close()

print("\nRenommage terminé correctement.")