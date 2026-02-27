import os
import re

# =========================================================
# CONFIGURATION
# =========================================================

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

SCHEMA_PATH = os.path.join(BASE_DIR, "manga", "schema.sql")
IMAGE_FOLDER = os.path.join(BASE_DIR, "manga", "static", "image")

# =========================================================
# 1️⃣ Extraire les images du schema.sql
# =========================================================

with open(SCHEMA_PATH, "r", encoding="utf-8") as f:
    content = f.read()

# On récupère toutes les valeurs du type 'Image/nom.jpg'
pattern = r"'Image/([^']+\.(?:jpg|jpeg|png|webp|gif))'"
schema_images = set(re.findall(pattern, content, re.IGNORECASE))

print(f"\nImages trouvées dans schema.sql : {len(schema_images)}")

# =========================================================
# 2️⃣ Images réellement présentes dans le dossier
# =========================================================

disk_images = {
    f for f in os.listdir(IMAGE_FOLDER)
    if f.lower().endswith((".png", ".jpg", ".jpeg", ".webp", ".gif"))
}

print(f"Images présentes dans le dossier : {len(disk_images)}")

# =========================================================
# 3️⃣ Comparaisons
# =========================================================

print("\n--- Images dans le dossier MAIS PAS dans schema.sql ---")
unused_on_disk = disk_images - schema_images

if unused_on_disk:
    for img in sorted(unused_on_disk):
        print(img)
else:
    print("Aucune.")

print("\n--- Images dans schema.sql MAIS PAS dans le dossier ---")
missing_on_disk = schema_images - disk_images

if missing_on_disk:
    for img in sorted(missing_on_disk):
        print(img)
else:
    print("Aucune.")