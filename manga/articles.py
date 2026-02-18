"""
========================================================
MANGABOOK – ARTICLES ROUTES (FRONT OFFICE)
--------------------------------------------------------
Module responsable de l’affichage des produits.

Responsabilités :
✔ Liste des articles
✔ Détail d’un article
✔ Lecture seule (aucune modification ici)
========================================================
"""

from flask import Blueprint, render_template
from manga.extensions.db import get_db


# ====================================================
# 🔹 Déclaration du Blueprint Articles
# ====================================================
# url_prefix = /articles
# Toutes les routes commenceront par /articles
bp = Blueprint("articles", __name__, url_prefix="/articles")


# ====================================================
# 🔹 Route : Liste des articles
# ====================================================
@bp.route("/")
def list_articles():
    """
    Affiche la liste complète des articles.

    Tri par date de création (plus récents en premier).
    """
    db = get_db()

    articles = db.execute(
        """
        SELECT *
        FROM articles
        ORDER BY created_at DESC
        """
    ).fetchall()

    return render_template(
        "articles/articles.html",
        articles=articles
    )


# ====================================================
# 🔹 Route : Détail d’un article
# ====================================================
@bp.route("/<int:id>")
def detail_article(id):
    """
    Affiche le détail d’un article spécifique.
    """

    db = get_db()

    article = db.execute(
        """
        SELECT *
        FROM articles
        WHERE id = ?
        """,
        (id,)
    ).fetchone()

    return render_template(
        "articles/detail_article.html",
        article=article
    )
