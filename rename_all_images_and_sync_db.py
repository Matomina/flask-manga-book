import os
import re
import sqlite3
import unicodedata
from pathlib import Path

DB_PATH = Path("instance/manga.sqlite")
IMG_DIR = Path("manga/static/image")

def slugify(text: str) -> str:
    # Supprimer accents
    text = unicodedata.normalize("NFD", text)
    text = text.encode("ascii", "ignore").decode("utf-8")

    # Minuscule
    text = text.lower()

    # Supprimer apostrophes
    text = text.replace("'", "")

    # Remplacer espaces ET tirets par underscore
    text = re.sub(r"[\s\-]+", "_", text)

    # Supprimer tout sauf lettres, chiffres et underscore
    text = re.sub(r"[^a-z0-9_]", "", text)

    # Supprimer underscores multiples
    text = re.sub(r"_+", "_", text)

    return text.strip("_")


# -------------------------
# Renommer tous les fichiers
# -------------------------
rename_map = {}

for file in IMG_DIR.iterdir():
    if not file.is_file():
        continue

    ext = file.suffix.lower()
    base = slugify(file.stem)
    new_name = base + ext
    new_path = IMG_DIR / new_name

    # Gestion collision
    counter = 1
    while new_path.exists() and new_path != file:
        new_name = f"{base}_{counter}{ext}"
        new_path = IMG_DIR / new_name
        counter += 1

    if new_path != file:
        os.rename(file, new_path)
        print(f"{file.name} -> {new_name}")

    rename_map[file.name] = new_name


# -------------------------
# Mise à jour BDD
# -------------------------
conn = sqlite3.connect(DB_PATH)
conn.row_factory = sqlite3.Row
cur = conn.cursor()

rows = cur.execute("SELECT id, image FROM articles").fetchall()

for row in rows:
    old_filename = Path(row["image"]).name

    if old_filename in rename_map:
        new_filename = rename_map[old_filename]
        new_db_value = f"image/{new_filename}"

        cur.execute(
            "UPDATE articles SET image=? WHERE id=?",
            (new_db_value, row["id"])
        )

conn.commit()
conn.close()

print("✅ Renommage complet + BDD synchronisée.")