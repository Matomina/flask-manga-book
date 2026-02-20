from flask import Blueprint, render_template, request, redirect, url_for, abort
from manga.extensions.db import get_db
from .auth import admin_required


bp = Blueprint(
    "admin_articles",
    __name__,
    url_prefix="/admin/articles",
    template_folder="templates",
)


# =========================================
# LISTE ADMIN ARTICLES
# =========================================
@bp.route("/")
@admin_required
def list_articles():

    db = get_db()

    articles = db.execute(
        "SELECT * FROM articles ORDER BY id ASC"
    ).fetchall()

    return render_template(
        "articles/articles.html",
        articles=articles
    )


# =========================================
# DETAIL ARTICLE
# =========================================
@bp.route("/<int:id>")
@admin_required
def detail_article(id):

    db = get_db()

    article = db.execute(
        "SELECT * FROM articles WHERE id = ?",
        (id,),
    ).fetchone()

    if article is None:
        abort(404)

    return render_template(
        "articles/detail_article.html",
        article=article
    )


# =========================================
# CREATE ARTICLE
# =========================================
@bp.route("/create", methods=("GET", "POST"))
@admin_required
def create_article():

    if request.method == "GET":
        return render_template("articles/article_create.html")

    name = request.form.get("name")
    genres = request.form.get("genres")
    image = request.form.get("image")
    price = request.form.get("price")
    stock = request.form.get("stock")

    db = get_db()

    db.execute(
        """
        INSERT INTO articles (name, genres, image, price, stock)
        VALUES (?, ?, ?, ?, ?)
        """,
        (name, genres, image, price, stock),
    )
    db.commit()

    return redirect(url_for("admin_articles.list_articles"))


# =========================================
# UPDATE ARTICLE
# =========================================
@bp.route("/<int:id>/update", methods=("GET", "POST"))
@admin_required
def update_article(id):

    db = get_db()

    article = db.execute(
        "SELECT * FROM articles WHERE id = ?",
        (id,),
    ).fetchone()

    if article is None:
        abort(404)

    if request.method == "GET":
        return render_template(
            "articles/article_update.html",
            article=article
        )

    name = request.form.get("name")
    genres = request.form.get("genres")
    image = request.form.get("image")
    price = request.form.get("price")
    stock = request.form.get("stock")

    db.execute(
        """
        UPDATE articles
        SET name = ?, genres = ?, image = ?, price = ?, stock = ?
        WHERE id = ?
        """,
        (name, genres, image, price, stock, id),
    )
    db.commit()

    return redirect(url_for("admin_articles.list_articles"))


# =========================================
# DELETE ARTICLE
# =========================================
@bp.route("/<int:id>/delete", methods=("POST",))
@admin_required
def delete_article(id):

    db = get_db()

    db.execute(
        "DELETE FROM articles WHERE id = ?",
        (id,),
    )
    db.commit()

    return redirect(url_for("admin_articles.list_articles"))
