"""
========================================================
MANGABOOK – ARTICLES ROUTES
--------------------------------------------------------
Gestion des articles :

FRONT-OFFICE :
✔ Liste des articles
✔ Détail d’un article

BACK-OFFICE :
✔ Création
✔ Modification
✔ Suppression
========================================================
"""

from flask import Blueprint, render_template, request, redirect, url_for
from manga.extensions.db import get_db

bp = Blueprint("articles", __name__, url_prefix="/articles")


# ====================================================
# 🔹 LISTE DES ARTICLES (PUBLIC)
# ====================================================
@bp.route("/")
def list_articles():
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
# 🔹 DÉTAIL ARTICLE (PUBLIC)
# ====================================================
@bp.route("/<int:id>")
def detail_article(id):
    db = get_db()

    article = db.execute(
        """
        SELECT *
        FROM articles
        WHERE id = ?
        """,
        (id,),
    ).fetchone()

    return render_template(
        "articles/detail_article.html",
        article=article
    )


# ====================================================
# 🔹 CREATE ARTICLE (ADMIN)
# ====================================================
@bp.route("/create", methods=("GET", "POST"))
def create_article():

    if request.method == "GET":
        return render_template("articles/article_create.html")

    name = request.form["name"]
    genres = request.form["genres"]
    image = request.form["image"]
    price = request.form["price"]
    stock = request.form["stock"]

    db = get_db()

    db.execute(
        """
        INSERT INTO articles (name, genres, image, price, stock)
        VALUES (?, ?, ?, ?, ?)
        """,
        (name, genres, image, price, stock),
    )
    db.commit()

    return redirect(url_for("articles.list_articles"))


# ====================================================
# 🔹 UPDATE ARTICLE (ADMIN)
# ====================================================
@bp.route("/<int:id>/update", methods=("GET", "POST"))
def update_article(id):

    db = get_db()

    article = db.execute(
        "SELECT * FROM articles WHERE id = ?",
        (id,),
    ).fetchone()

    if request.method == "GET":
        return render_template(
            "articles/article_update.html",
            article=article
        )

    name = request.form["name"]
    genres = request.form["genres"]
    image = request.form["image"]
    price = request.form["price"]
    stock = request.form["stock"]

    db.execute(
        """
        UPDATE articles
        SET name = ?, genres = ?, image = ?, price = ?, stock = ?
        WHERE id = ?
        """,
        (name, genres, image, price, stock, id),
    )
    db.commit()

    return redirect(url_for("articles.detail_article", id=id))


# ====================================================
# 🔹 DELETE ARTICLE (ADMIN)
# ====================================================
@bp.route("/<int:id>/delete", methods=("POST",))
def delete_article(id):

    db = get_db()

    db.execute(
        "DELETE FROM articles WHERE id = ?",
        (id,),
    )
    db.commit()

    return redirect(url_for("articles.list_articles"))
