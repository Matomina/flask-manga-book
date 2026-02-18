"""
========================================================
ARTICLE MODEL
--------------------------------------------------------
Couche d’accès aux données pour les produits (articles).
========================================================
"""

from manga.extensions.db import get_db


def get_all_articles():
    """
    Récupère tous les articles.
    """
    db = get_db()
    return db.execute(
        "SELECT * FROM articles"
    ).fetchall()


def get_article_by_id(article_id):
    """
    Récupère un article par son ID.
    """
    db = get_db()
    return db.execute(
        "SELECT * FROM articles WHERE id = ?",
        (article_id,)
    ).fetchone()
