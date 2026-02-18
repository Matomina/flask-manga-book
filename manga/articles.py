from flask import Blueprint, render_template
from manga.db import get_db

bp = Blueprint('articles', __name__, url_prefix='/articles')


# Liste des articles
@bp.route('/')
def articles():
    db = get_db()
    articles = db.execute(
        'SELECT * FROM articles ORDER BY created_at DESC'
    ).fetchall()

    return render_template('articles/articles.html', articles=articles)


# Détail d’un article
@bp.route('/<int:id>')
def detail_article(id):
    db = get_db()

    article = db.execute(
        'SELECT * FROM articles WHERE id = ?',
        (id,)
    ).fetchone()

    return render_template('articles/detail_article.html', article=article)
