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

from flask import Blueprint, render_template, abort, session, redirect, url_for, request, jsonify
from manga.models.article_model import get_all_articles
from manga.extensions.db import get_db
from datetime import datetime


# ====================================================
# 🔹 Déclaration du Blueprint Public
# ====================================================
bp = Blueprint(
    "public",
    __name__,
    template_folder="templates"
)


# ====================================================
# 🔹 Utilitaire : Récupération favoris utilisateur
# ====================================================
def get_user_favorites():

    if "user_id" not in session:
        return []

    db = get_db()

    rows = db.execute("""
        SELECT article_id
        FROM favorites
        WHERE user_id = ?
    """, (session["user_id"],)).fetchall()

    return [str(row["article_id"]) for row in rows]


# ====================================================
# 🔹 Injection globale des favoris dans Jinja
# ====================================================
@bp.app_context_processor
def inject_favorites():

    favorites = get_user_favorites()

    return dict(
        favorites=favorites,
        favorites_count=len(favorites)
    )


# ====================================================
# 🔹 Route : Page d'accueil
# ====================================================
@bp.route("/")
def home():

    db = get_db()

    articles = [dict(a) for a in get_all_articles()]

    # ====================================================
    # 📜 HISTORIQUES
    # ====================================================

    historiques = []

    if "user_id" in session:

        historiques_db = db.execute("""
            SELECT articles.*
            FROM history
            JOIN articles ON history.article_id = articles.id
            WHERE history.user_id = ?
            ORDER BY history.viewed_at DESC
            LIMIT 10
        """, (session["user_id"],)).fetchall()

        historiques = [dict(a) for a in historiques_db]

    # ====================================================
    # ⭐ CLASSIQUES
    # ====================================================

    classiques = [
        a for a in articles
        if a["genres"] == "manga"
        and a["price"] <= 7.50
    ][:10]

    # ====================================================
    # 💎 PÉPITES
    # ====================================================

    pepites = [
        a for a in articles
        if a["genres"] == "manga"
        and a["price"] > 8
    ][:10]

    # ====================================================
    # 🎁 GOODIES
    # ====================================================

    goodies = [
        a for a in articles
        if a["genres"] == "goodies"
    ][:10]


    return render_template(
        "index.html",
        historiques=historiques,
        classiques=classiques,
        pepites=pepites,
        goodies=goodies,
    )


# ====================================================
# 🔹 Route : Catalogue
# ====================================================
from flask import session

@bp.route("/catalogue")
def catalogue():
    db = get_db()

    mangas = db.execute(
        "SELECT * FROM articles WHERE genres = ?",
        ("manga",)
    ).fetchall()


    return render_template(
        "catalogue.html",
        mangas=mangas,
    )


# ====================================================
# 🔹 Route : Fiche produit (Détail Article Public)
# ====================================================
@bp.route("/article/<int:article_id>")
def article_detail(article_id):

    db = get_db()

    # ----------------------------------------
    # 🔍 Récupération article + description
    # ----------------------------------------
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

    # ----------------------------------------
    # 📜 Ajout historique si utilisateur connecté
    # ----------------------------------------
    if "user_id" in session:

        db.execute("""
            INSERT INTO history (user_id, article_id)
            VALUES (?, ?)
            ON CONFLICT(user_id, article_id)
            DO UPDATE SET viewed_at = CURRENT_TIMESTAMP
        """, (session["user_id"], article_id))

        db.commit()

    # ----------------------------------------
    # Rendu template
    # ----------------------------------------
    return render_template(
        "article_detail.html",
        article=article
    )


# ====================================================
# 🔹 Route : Toggle Favoris ❤️
# ====================================================
@bp.route("/toggle-favorite/<int:article_id>", methods=["POST"])
def toggle_favorite(article_id):

    if "user_id" not in session:
        return jsonify({
            "status": "unauthorized",
            "redirect": url_for("public.profil", show="register")
        }), 401

    db = get_db()
    favorite = db.execute("""
        SELECT 1 FROM favorites
        WHERE user_id = ? AND article_id = ?
    """, (session["user_id"], article_id)).fetchone()

    if favorite:
        db.execute("""
            DELETE FROM favorites
            WHERE user_id = ? AND article_id = ?
        """, (session["user_id"], article_id))
        db.commit()
        return jsonify({"status": "removed"})

    db.execute("""
        INSERT INTO favorites (user_id, article_id)
        VALUES (?, ?)
    """, (session["user_id"], article_id))
    db.commit()
    return jsonify({"status": "added"})
    

# ====================================================
# 🔹 Route : Planning (dynamique via BDD)
# ====================================================
@bp.route("/planning")
def planning():

    db = get_db()

    days = [
        "Lundi",
        "Mardi",
        "Mercredi",
        "Jeudi",
        "Vendredi",
        "Samedi",
        "Dimanche",
        "Sans jour fixe"
    ]

    planning_data = []

    for day in days:
        mangas = db.execute("""
            SELECT *
            FROM articles
            WHERE genres = 'manga'
            AND release_day = ?
            ORDER BY name ASC
        """, (day,)).fetchall()

        planning_data.append({
            "name": day,
            "mangas": [dict(m) for m in mangas]
        })

    return render_template(
        "planning.html",
        planning=planning_data
    )


# ====================================================
# 🔹 Route : Profil utilisateur
# ====================================================
@bp.route("/profil")
def profil():

    db = get_db()

    historiques = []
    favoris = []

    if "user_id" in session:

        historiques_db = db.execute("""
            SELECT articles.*, history.viewed_at
            FROM history
            JOIN articles ON history.article_id = articles.id
            WHERE history.user_id = ?
            ORDER BY history.viewed_at DESC
            LIMIT 12
        """, (session["user_id"],)).fetchall()

        historiques = [dict(a) for a in historiques_db]

        favoris_db = db.execute("""
            SELECT articles.*, favorites.created_at
            FROM favorites
            JOIN articles ON favorites.article_id = articles.id
            WHERE favorites.user_id = ?
            ORDER BY favorites.created_at DESC
        """, (session["user_id"],)).fetchall()

        favoris = [dict(a) for a in favoris_db]

    return render_template(
        "profil.html",
        historiques=historiques,
        favoris=favoris
    )


# ====================================================
# 🔹 Route : Forum
# ====================================================
@bp.route("/forum", methods=["GET", "POST"])
def forum_home():
    db = get_db()

    if request.method == "POST":

        user_id = session.get("user_id")

        if not user_id:
            return redirect(url_for("auth.login"))

        title = request.form["title"]
        message = request.form["message"]

        db.execute(
            """
            INSERT INTO topics (user_id, title, message)
            VALUES (?, ?, ?)
            """,
            (user_id, title, message)
        )
        db.commit()

        return redirect(url_for("public.forum_home"))

    topics = db.execute("""
        SELECT topics.*, user.first_name
        FROM topics
        JOIN user ON topics.user_id = user.id
        ORDER BY topics.created_at DESC
    """).fetchall()

    return render_template("forum.html", topics=topics)


# ====================================================
# 🔹 Route : Goodies
# ====================================================
@bp.route("/goodies")
def goodies():
    db = get_db()

    # Ordre forcé des univers
    universe_order = [
        "naruto",
        "jujutsu_kaisen",
        "one_piece",
        "demon_slayer",
        "dragon_ball",
    ]

    universes = {}

    for u in universe_order:
        articles = db.execute(
            """
            SELECT *
            FROM articles
            WHERE universe = ?
              AND genres = 'goodies'
            """,
            (u,),
        ).fetchall()

        # On ajoute seulement si l'univers contient des articles
        if articles:
            universes[u] = articles

    # Sections globales du bas
    figurines = db.execute(
        """
        SELECT *
        FROM articles
        WHERE genres = 'figurine'
        ORDER BY id DESC
        """
    ).fetchall()

    textiles = db.execute(
        """
        SELECT *
        FROM articles
        WHERE genres = 'textiles'
        ORDER BY id DESC
        """
    ).fetchall()

    vaisselle = db.execute(
        """
        SELECT *
        FROM articles
        WHERE genres = 'vaisselle'
        ORDER BY id DESC
        """
    ).fetchall()

    return render_template(
        "goodies.html",
        universes=universes,
        universe_order=universe_order,
        figurines=figurines,
        textiles=textiles,
        vaisselle=vaisselle,
    )


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


# ====================================================
# 🔹 Route : Recherche Globale
# ====================================================
@bp.route("/search")
def search():

    query = request.args.get("q", "").strip()

    if not query:
        return redirect(url_for("public.home"))

    db = get_db()

    results = db.execute("""
        SELECT *
        FROM articles
        WHERE LOWER(name) LIKE LOWER(?)
           OR LOWER(genres) LIKE LOWER(?)
        ORDER BY
            CASE
                WHEN LOWER(name) = LOWER(?) THEN 0
                ELSE 1
            END,
            name ASC
    """, (f"%{query}%", f"%{query}%", query)).fetchall()

    results = [dict(r) for r in results]

    if not results:
        return render_template(
            "search_results.html",
            results=[],
            query=query
        )

    # Si correspondance exacte en premier → redirection
    if results and results[0]["name"].lower() == query.lower():
        return redirect(
            url_for("public.article_detail",
                    article_id=results[0]["id"])
        )

    # Si un seul résultat
    if len(results) == 1:
        return redirect(
            url_for("public.article_detail",
                    article_id=results[0]["id"])
        )

    return render_template(
        "search_results.html",
        results=results,
        query=query
    )   