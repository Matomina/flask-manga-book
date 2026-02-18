"""
========================================================
MANGABOOK – ADMIN ROUTES (BACK OFFICE)
--------------------------------------------------------
Gestion du catalogue (CRUD mangas).
Accessible uniquement aux administrateurs.
========================================================
"""

from flask import Blueprint, render_template, redirect, url_for, request
from manga.models.article_model import (
    get_all_mangas,
    get_manga_by_id,
)
from manga.extensions.db import get_db


# ====================================================
# 🔹 Déclaration du Blueprint Admin
# ====================================================
bp = Blueprint("admin", __name__, url_prefix="/admin")


# ====================================================
# 🔹 Dashboard Admin
# ====================================================
@bp.route("/")
def dashboard():
    mangas = get_all_mangas()
    return render_template("admin/dashboard.html", mangas=mangas)
