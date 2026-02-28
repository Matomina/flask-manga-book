from flask import Blueprint, render_template, abort, session
from manga.extensions.db import get_db

bp = Blueprint(
    "articles",
    __name__,
    url_prefix="/articles",
    template_folder="templates"
)


# ====================================================
# Liste des articles (public)
# ====================================================
@bp.route("/")
def list_articles():

    db = get_db()

    articles = db.execute("""
        SELECT *
        FROM articles
        ORDER BY created_at DESC
    """).fetchall()

    # Conversion en dictionnaires pour exploitation Jinja
    articles = [dict(a) for a in articles]

    # Aucun traitement sur le champ image
    # La base contient déjà : image/nom_fichier.ext

    return render_template(
        "articles/articles.html",
        articles=articles
    )


# ====================================================
# Fiche produit (détail article public)
# ====================================================
@bp.route("/article/<int:article_id>")
def article_detail(article_id):

    db = get_db()

    article = db.execute("""
        SELECT articles.*, detail_articles_public.description
        FROM articles
        LEFT JOIN detail_articles_public
            ON articles.id = detail_articles_public.article_id
        WHERE articles.id = ?
    """, (article_id,)).fetchone()

    if article is None:
        abort(404)

    article = dict(article)

    # Enregistrement dans l’historique si utilisateur connecté
    if "user_id" in session:
        db.execute("""
            INSERT INTO history (user_id, article_id)
            VALUES (?, ?)
            ON CONFLICT(user_id, article_id)
            DO UPDATE SET viewed_at = CURRENT_TIMESTAMP
        """, (session["user_id"], article_id))
        db.commit()

    return render_template(
        "article_detail.html",
        article=article
    )