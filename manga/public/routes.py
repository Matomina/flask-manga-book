"""
========================================================
MANGABOOK – PUBLIC ROUTES (FRONT OFFICE)
--------------------------------------------------------
Module responsable des routes accessibles aux visiteurs.

Responsabilités :
✔ Affichage de la page d’accueil
✔ Affichage du catalogue
✔ Affichage des fiches produits
✔ Aucune logique SQL directe (séparation MVC)
========================================================
"""

from flask import Blueprint, render_template
from manga.models.article_model import get_all_articles

# ====================================================
# 🔹 Déclaration du Blueprint Public
# ====================================================
bp = Blueprint("public", __name__)


# ====================================================
# 🔹 Route : Page d'accueil
# ====================================================
@bp.route("/")
def articles():
    articles = get_all_articles()
    return render_template("articles/articles.html", articles=articles)

