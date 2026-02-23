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

from flask import Blueprint, render_template, abort, session, redirect, url_for
from manga.models.article_model import get_all_articles
from manga.extensions.db import get_db


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
    return dict(favorites=get_user_favorites())


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
        return {"error": "Non autorisé"}, 401

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
        return {"status": "removed"}

    else:
        db.execute("""
            INSERT INTO favorites (user_id, article_id)
            VALUES (?, ?)
        """, (session["user_id"], article_id))
        db.commit()
        return {"status": "added"}
    

# ====================================================
# 🔹 Route : Planning
# ====================================================
@bp.route('/planning')
def planning():

    planning_data = [

        # ================= LUNDI =================
        {
            "name": "Lundi",
            "mangas": [
                {"title": "Sekai Saisoku no Isekai Ryokouki", "price": "7.80", "image": "Image/sekai saisoku no isekai ryokouki chapter 1.jpg"},
                {"title": "Ordeal", "price": "7.80", "image": "Image/ordeal tome.jpg"},
                {"title": "Blue Box", "price": "7.80", "image": "Image/blue box tome 1.jpg"},
                {"title": "Nyaight of the Living Cat", "price": "7.80", "image": "Image/nyaight of the living cat tome 1.jpg"},
                {"title": "Juvenile Detention Center", "price": "7.80", "image": "Image/juvenile detention center tome 1.jpg"},
                {"title": "Maybe Meant", "price": "7.80", "image": "Image/maybe meant tome 1.jpg"},
                {"title": "Tonikaku Kuwai", "price": "7.80", "image": "Image/tonikaku kuwai tome 1.jpeg"},
                {"title": "To Your Eternity", "price": "7.80", "image": "Image/to your eternity tome 1.jpeg"},
            ]
        },

        # ================= MARDI =================
        {
            "name": "Mardi",
            "mangas": [
                {"title": "Yano Kun no", "price": "7.80", "image": "Image/yano kun no tome 1.jpg"},
                {"title": "Return to Player", "price": "7.80", "image": "Image/return to player tome 1.jpg"},
                {"title": "Manager Kim", "price": "7.80", "image": "Image/manager kim tome 1.jpg"},
                {"title": "Hero Without a Class", "price": "7.80", "image": "Image/hero without a class tome 1.jpg"},
                {"title": "Let's Play", "price": "7.80", "image": "Image/let's play tome 1.jpg"},
                {"title": "Afterlife Inn Cooking", "price": "7.80", "image": "Image/afterlife inn cooking tome 1.jpg"},
                {"title": "Rent a Girl", "price": "7.80", "image": "Image/rent a girl tome 1.jpg"},
                {"title": "A Couple of Cuckoos", "price": "7.80", "image": "Image/a couple of cuckoos tome 1.jpg"},
            ]
        },

        # ================= MERCREDI =================
        {
            "name": "Mercredi",
            "mangas": [
                {"title": "99 Reinforced Wood Stick", "price": "7.80", "image": "Image/99 reinforced wood stick tome 1.jpeg"},
                {"title": "Baek", "price": "7.80", "image": "Image/baek tome 1.jpeg"},
                {"title": "Surviving the Game As", "price": "7.80", "image": "Image/Surviving the game as tome 1.jpeg"},
                {"title": "The Druid of Seoul Station", "price": "7.80", "image": "Image/the druid of seoul station tome 1.jpeg"},
                {"title": "The Mafia Nanny", "price": "7.80", "image": "Image/the mafia nanny tome 1.jpeg"},
                {"title": "Umamusume Cinderella Gray", "price": "7.80", "image": "Image/umamusume cinderella gray tome 1.jpeg"},
                {"title": "Blue Orchestra", "price": "7.80", "image": "Image/blue orchestra tome 1.jpeg"},
                {"title": "Hero Ticket", "price": "7.80", "image": "Image/hero ticket tome 1.jpeg"},
            ]
        },

        # ================= JEUDI =================
        {
            "name": "Jeudi",
            "mangas": [
                {"title": "Dr. Stone", "price": "7.90", "image": "Image/Dr-Stone-Tome.jpeg"},
                {"title": "Futari Solo Camp", "price": "7.80", "image": "Image/futari solo camp tome 1.jpeg"},
                {"title": "Past the Monster Meat", "price": "7.80", "image": "Image/past the monster meat tome 1.jpeg"},
                {"title": "The Rising of the Shield Hero", "price": "7.90", "image": "Image/the rising of the shield hero tome 1.jpeg"},
                {"title": "I Was Reincarnated as the 7th Prince", "price": "7.80", "image": "Image/i was reincarnated as the 7th prince tome 1.jpeg"},
                {"title": "Reborn as a Vending Machine", "price": "7.80", "image": "Image/reborn as a vending machine tome 1.jpeg"},
                {"title": "Dreaming Freedom", "price": "7.80", "image": "Image/dreaming freedom tome 1.jpeg"},
            ]
        },

        # ================= VENDREDI =================
        {
            "name": "Vendredi",
            "mangas": [
                {"title": "Dragon Raja", "price": "7.90", "image": "Image/dragon raja tome 1.jpeg"},
                {"title": "Cat's Eyes 2025", "price": "7.80", "image": "Image/cat's eyes 2025 tome 1.jpeg"},
                {"title": "Tougen Anki", "price": "7.80", "image": "Image/tougen anki tome 1.jpeg"},
                {"title": "Watari Kun no XX ga Houkai Sunzen", "price": "7.90", "image": "Image/watari kun no xx ga houkai sunzen tome 1.jpeg"},
                {"title": "Tsubasa Chronicle", "price": "7.90", "image": "Image/tsubasa chronicle tsubasa tome 1.jpeg"},
                {"title": "May I Ask for One Final Thing", "price": "7.80", "image": "Image/may i ask for one final thing tome 1.jpeg"},
                {"title": "One Piece", "price": "7.90", "image": "Image/One-Piece-Tome.jpeg"},
                {"title": "Study Group", "price": "7.80", "image": "Image/study group tome 1.jpeg"},
            ]
        },

        # ================= SAMEDI =================
        {
            "name": "Samedi",
            "mangas": [
                {"title": "Lord of Mysteries", "price": "7.90", "image": "Image/lord of mysteries tome 1.jpeg"},
                {"title": "Détective Conan", "price": "7.90", "image": "Image/Détective-Conan-Tome.jpeg"},
                {"title": "A Wild Last Boss Appeared", "price": "7.80", "image": "Image/a wild last boos appeard tome 1.jpeg"},
                {"title": "Silent Witch", "price": "7.80", "image": "Image/silent witch tome 1.jpeg"},
                {"title": "Kingdom", "price": "7.90", "image": "Image/kingdom tome 1.jpeg"},
                {"title": "My Hero Academia", "price": "7.90", "image": "Image/My-Hero-Academia-Tome.jpeg"},
                {"title": "Spy x Family", "price": "7.90", "image": "Image/spy x family tome 1.jpeg"},
                {"title": "Let This Grieving Soul Retire", "price": "7.80", "image": "Image/let this grieving soul retire tome 1.jpeg"},
            ]
        },

        # ================= DIMANCHE =================
        {
            "name": "Dimanche",
            "mangas": [
                {"title": "Witch Watch", "price": "7.90", "image": "Image/witch watch tome 1.jpeg"},
                {"title": "My Dress Up Darling", "price": "7.90", "image": "Image/my dress up darling tome 1.jpeg"},
                {"title": "Rascal Does Not Dream of Bunny Girl Senpai", "price": "8.50", "image": "Image/rascal does not dream of bunny girl senpai tome 1.jpeg"},
                {"title": "Gachiakuta", "price": "7.80", "image": "Image/Gachiakuta-Tome.jpeg"},
                {"title": "Be a Princess Someday", "price": "7.90", "image": "Image/be a princess someday tome 1.jpeg"},
                {"title": "Kikaijikake no Marie", "price": "7.80", "image": "Image/kikaijikake no marie tome 1.jpeg"},
                {"title": "Alma Chan wa Kazoku ni Naritai", "price": "7.90", "image": "Image/alma chan wa kazoku ni naritai tome 1.jpeg"},
                {"title": "Dad is a Hero, Mom is a Spring, I'm a", "price": "7.80", "image": "Image/dad is a hero mom is a spring i'm a tome 1.jpeg"},
            ]
        },

        # ================= SANS JOURS FIXES =================
        {
            "name": "Œuvres en cours sans jours fixes",
            "mangas": [
                {"title": "Chain Saw", "price": "7.90", "image": "Image/Chain-Saw-Tome.jpg"},
                {"title": "Fairy Tail 100 Years Quest", "price": "7.90", "image": "Image/fairy tail 100 years quest tome 1.jpg"},
                {"title": "Four Knights of the Apocalypse", "price": "8.50", "image": "Image/four knights of the apocalypse tome 1.jpg"},
                {"title": "Blue Lock", "price": "7.90", "image": "Image/Blue Lock.jpg"},
                {"title": "Embers", "price": "7.80", "image": "Image/embers tome 1.jpg"},
                {"title": "I'm the Max Level Newbie", "price": "8.00", "image": "Image/i'm the max level newbie tome 1.jpg"},
                {"title": "Infinite Mage", "price": "7.90", "image": "Image/infinite mage tome 1.jpg"},
                {"title": "Itchi the Witch", "price": "7.50", "image": "Image/itchi the witch tome 1.jpg"},
                {"title": "Kaoru Hana wa Rin to Saku", "price": "7.90", "image": "Image/kaoru hana wa rin to saku tome 1.jpg"},
                {"title": "Lecteur Omniscient", "price": "8.00", "image": "Image/lecteur omniscient tome 1.jpg"},
                {"title": "Moi Slime", "price": "7.90", "image": "Image/Moi-Slime-Tome.jpeg"},
                {"title": "Nano Machine", "price": "7.80", "image": "Image/nano machine tome 1.jpg"},
                {"title": "Nebula's Civilation", "price": "8.00", "image": "Image/nebula's civilation tome 1.jpg"},
                {"title": "Pick Me Up", "price": "7.90", "image": "Image/Pick Me Up tome.jpg"},
                {"title": "Player", "price": "7.90", "image": "Image/Player tome.jpg"},
                {"title": "Player Who Returned 10000 Year Later", "price": "8.50", "image": "Image/player who returned 10000 year later tome 1.jpg"},
                {"title": "Reality Quest", "price": "7.90", "image": "Image/reality quest tome 1.jpg"},
                {"title": "Spy x Family", "price": "7.90", "image": "Image/spy x family tome 1.jpg"},
                {"title": "Solo Leveling", "price": "8.50", "image": "Image/Solo-Leveling-Tome.jpeg"},
                {"title": "Wind Breaker", "price": "7.80", "image": "Image/wind breaker tome 1.jpg"},
                {"title": "The Beginning After the End", "price": "8.50", "image": "Image/the beginning after the end tome 1.jpg"},
                {"title": "Tougen Anki", "price": "7.90", "image": "Image/tougen anki tome 1.jpg"},
                {"title": "Shangri-La Frontier", "price": "8.00", "image": "Image/Shangri-La-Frontier.jpeg"},
            ]
        },

    ]

    return render_template("planning.html", planning=planning_data)


# ====================================================
# 🔹 Route : Profil utilisateur
# ====================================================
@bp.route("/profil")
def profil():

    if "user_id" not in session:
        return redirect(url_for("auth.login"))

    db = get_db()

    # ====================================================
    # 📜 HISTORIQUE
    # ====================================================
    historiques = db.execute("""
        SELECT articles.*, history.viewed_at
        FROM history
        JOIN articles ON history.article_id = articles.id
        WHERE history.user_id = ?
        ORDER BY history.viewed_at DESC
        LIMIT 12
    """, (session["user_id"],)).fetchall()

    historiques = [dict(a) for a in historiques]

    # ====================================================
    # ❤️ FAVORIS
    # ====================================================
    favoris = db.execute("""
        SELECT articles.*, favorites.created_at
        FROM favorites
        JOIN articles ON favorites.article_id = articles.id
        WHERE favorites.user_id = ?
        ORDER BY favorites.created_at DESC
    """, (session["user_id"],)).fetchall()

    favoris = [dict(a) for a in favoris]

    # ====================================================
    # RENDU TEMPLATE
    # ====================================================
    return render_template(
        "profil.html",
        historiques=historiques,
        favoris=favoris
    )


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