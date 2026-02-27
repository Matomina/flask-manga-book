import sqlite3
import re
from pathlib import Path

DB_PATH = Path("instance/manga.sqlite")
SCHEMA_PATH = Path("manga/schema.sql")
OUT_PATH = Path("manga/schema.updated.sql")

# --- Charger la BDD ---
conn = sqlite3.connect(DB_PATH)
conn.row_factory = sqlite3.Row
cur = conn.cursor()
rows = cur.execute("SELECT name, image FROM articles").fetchall()
conn.close()

name_to_image = {r["name"]: r["image"] for r in rows}

# --- Lire schema ---
schema = SCHEMA_PATH.read_text(encoding="utf-8")

# On cible uniquement le bloc INSERT INTO articles
insert_block_pattern = re.compile(
    r"(INSERT INTO articles\s*\([^;]+?VALUES\s*)(.+?);",
    re.DOTALL | re.IGNORECASE
)

match = insert_block_pattern.search(schema)

if not match:
    raise Exception("Bloc INSERT INTO articles introuvable.")

prefix = match.group(1)
values_block = match.group(2)

# Pattern d'un tuple article
tuple_pattern = re.compile(
    r"\('((?:[^']|'')+)',\s*'[^']+',\s*(?:NULL|'[^']+'),\s*'([^']+)'",
    re.MULTILINE
)

def replace_tuple(m):
    raw_name_sql = m.group(1)              # ex: Let''s Play
    name = raw_name_sql.replace("''", "'") # corrige SQL -> Python
    old_image = m.group(2)

    if name in name_to_image:
        new_image = name_to_image[name]
        return m.group(0).replace(old_image, new_image)

    return m.group(0)

new_values_block = tuple_pattern.sub(replace_tuple, values_block)

new_schema = (
    schema[:match.start(2)]
    + new_values_block
    + schema[match.end(2):]
)

OUT_PATH.write_text(new_schema, encoding="utf-8")

print("✅ schema.updated.sql généré avec images mises à jour.")