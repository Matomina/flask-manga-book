"""
========================================================
MANGABOOK – APPLICATION FACTORY
--------------------------------------------------------
Initialisation principale de l'application Flask.

Architecture :
✔ Public séparé
✔ Admin séparé
✔ Templates isolés par Blueprint
✔ Extensions centralisées
========================================================
"""

import os
import locale
from datetime import datetime
from flask import Flask, app


# ========================================================
# 🔹 APPLICATION FACTORY
# ========================================================
def create_app(test_config=None):

    # ====================================================
    # Création de l'application
    # ====================================================
    app = Flask(__name__, instance_relative_config=True)

    # ====================================================
    # Configuration
    # ====================================================
    app.config.from_mapping(
        SECRET_KEY=os.environ.get("SECRET_KEY", "dev"),
        DATABASE=os.path.join(app.instance_path, "manga.sqlite"),
    )

    if test_config is None:
        app.config.from_pyfile("config.py", silent=True)
    else:
        app.config.from_mapping(test_config)

    # ====================================================
    # Création dossier instance
    # ====================================================
    os.makedirs(app.instance_path, exist_ok=True)

    # ====================================================
    # Extensions
    # ====================================================
    from .extensions import db
    db.init_app(app)

    # ====================================================
    # Injection utilisateur global (Navbar dynamique)
    # ====================================================
    from flask import session
    from .extensions.db import get_db

    @app.context_processor
    def inject_user():

        user = None
        favorites_ids = []

        if "user_id" in session:
            db = get_db()

            user = db.execute(
                "SELECT id, first_name, role FROM user WHERE id = ?",
                (session["user_id"],)
            ).fetchone()

            favorites = db.execute("""
                SELECT article_id FROM favorites
                WHERE user_id = ?
            """, (session["user_id"],)).fetchall()

            favorites_ids = [f["article_id"] for f in favorites]

        return dict(
            current_user=user,
            favorites_ids=favorites_ids
        )

    # ====================================================
    # Filtre Jinja
    # ====================================================
    @app.template_filter("format_datetime_fr")
    def format_datetime_fr(value):
        if not value:
            return ""

        dt = datetime.strptime(value, "%Y-%m-%d %H:%M:%S")

        try:
            locale.setlocale(locale.LC_TIME, "fr_FR.UTF-8")
        except locale.Error:
            pass

        return dt.strftime("%d %B %Y à %Hh%M")

    # ====================================================
    # Enregistrement des Blueprints
    # ====================================================

    # PUBLIC général
    from .public.routes import bp as public_bp
    app.register_blueprint(public_bp)

    # PUBLIC articles
    from .public.articles import bp as articles_public_bp
    app.register_blueprint(articles_public_bp)

    # ADMIN
    from .admin.admin import bp as admin_bp
    app.register_blueprint(admin_bp)

    from .admin.users import bp as users_bp
    app.register_blueprint(users_bp)

    from .admin.orders import bp as orders_bp
    app.register_blueprint(orders_bp)

    from .admin.articles import bp as articles_bp
    app.register_blueprint(articles_bp)

    from .admin.auth import bp as auth_bp
    app.register_blueprint(auth_bp)

    from .admin.contacts import bp as contacts_bp
    app.register_blueprint(contacts_bp)

    from .admin.forum import bp as admin_forum_bp
    app.register_blueprint(admin_forum_bp)

    # ====================================================
    # Gestion erreurs globale
    # ====================================================
    @app.errorhandler(404)
    def page_not_found(e):
        return "Page non trouvée", 404

    return app