"""
========================================================
MANGABOOK – PUBLIC ROUTES (FRONT OFFICE)
--------------------------------------------------------
Module responsable des routes accessibles aux visiteurs.

Responsabilités :
✔ Affichage page d’accueil
✔ Catalogue complet
✔ Fiche produit dynamique
✔ Aucune logique SQL directe (MVC respecté)
========================================================
"""

from flask import Blueprint, render_template, abort
from manga.models.article_model import get_all_articles


# ====================================================
# 🔹 Déclaration du Blueprint Public
# ----------------------------------------------------
# template_folder="templates"
# Permet à Flask d'utiliser :
# manga/public/templates/
# ====================================================
bp = Blueprint(
    "public",
    __name__,
    template_folder="templates"
)


# ====================================================
# 🔹 Route : Page d'accueil
# ====================================================
@bp.route("/")
def home():
    articles = get_all_articles()
    articles = [dict(a) for a in articles]

    # 🔹 HISTORIQUES = 10 derniers mangas ajoutés
    historiques = sorted(
        [a for a in articles if a["genres"] == "manga"],
        key=lambda x: x["created_at"],
        reverse=True
    )[:10]

    # 🔹 CLASSIQUES
    classiques = [
        a for a in articles
        if a["genres"] == "manga" and a["price"] <= 7.50
    ][:10]

    # 🔹 PÉPITES
    pepites = [
        a for a in articles
        if a["genres"] == "manga" and a["price"] > 8
    ][:10]

    # 🔹 GOODIES
    goodies = [
        a for a in articles
        if a["genres"] == "goodies"
    ][:10]

    return render_template(
        "index.html",
        historiques=historiques,
        classiques=classiques,
        pepites=pepites,
        goodies=goodies
    )


# ====================================================
# 🔹 Route : Catalogue
# ====================================================
@bp.route("/catalogue")
def catalogue():
    articles = get_all_articles()
    articles = [dict(a) for a in articles]

    return render_template(
        "catalogue.html",
        articles=articles
    )


# ====================================================
# 🔹 Route : Fiche produit
# ====================================================
@bp.route("/article/<int:article_id>")
def article_detail(article_id):
    articles = get_all_articles()
    articles = [dict(a) for a in articles]

    article = next((a for a in articles if a["id"] == article_id), None)

    if article is None:
        abort(404)

    return render_template(
        "article_detail.html",
        article=article
    )

# ====================================================
# 🔹 Route : Planning
# ====================================================
@bp.route("/planning")
def planning():
    return render_template("planning.html")


# ====================================================
# 🔹 Route : Profil
# ====================================================
@bp.route("/profil")
def profil():
    return render_template("profil.html")


# ====================================================
# 🔹 Route : Forum
# ====================================================
@bp.route("/forum")
def forum():
    return render_template("forum.html")


# ====================================================
# 🔹 Route : Goodies
# ====================================================
@bp.route("/goodies")
def goodies_page():
    return render_template("goodies.html")


# ====================================================
# 🔹 Route : Panier
# ====================================================
@bp.route("/panier")
def panier():
    return render_template("panier.html")


# ====================================================
# 🔹 Route : Aide
# ====================================================
@bp.route("/aide")
def aide():
    return render_template("aide.html")