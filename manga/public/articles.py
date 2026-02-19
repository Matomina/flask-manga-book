from flask import Blueprint, render_template
from manga.extensions.db import get_db

bp = Blueprint(
    "articles",
    __name__,
    url_prefix="/articles",
    template_folder="templates"
)


# =========================================
# LISTE ARTICLES (PUBLIC)
# =========================================
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


# =========================================
# DETAIL ARTICLE (PUBLIC)
# =========================================
@bp.route("/<int:id>")
def detail_article(id):

    db = get_db()

    article = db.execute(
        "SELECT * FROM articles WHERE id = ?",
        (id,),
    ).fetchone()

    return render_template(
        "articles/detail_article.html",
        article=article
    )
