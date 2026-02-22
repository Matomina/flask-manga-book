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
from flask import Flask


# ========================================================
# 🔹 APPLICATION FACTORY
# ========================================================
def create_app(test_config=None):

    # ====================================================
    # 1️⃣ Création de l'application
    # ====================================================
    app = Flask(__name__, instance_relative_config=True)

    # ====================================================
    # 2️⃣ Configuration
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
    # 3️⃣ Création dossier instance
    # ====================================================
    os.makedirs(app.instance_path, exist_ok=True)

    # ====================================================
    # 4️⃣ Extensions
    # ====================================================
    from .extensions import db
    db.init_app(app)

    # ====================================================
    # 🔹 Injection utilisateur global (Navbar dynamique)
    # ====================================================
    from flask import session
    from .extensions.db import get_db

    @app.context_processor
    def inject_user():

        user = None

        if "user_id" in session:
            db = get_db()
            user = db.execute(
                "SELECT id, first_name, role FROM user WHERE id = ?",
                (session["user_id"],)
            ).fetchone()

        return dict(current_user=user)

    # ====================================================
    # 5️⃣ Filtre Jinja
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
    # 6️⃣ Enregistrement des Blueprints
    # ====================================================

    # 🔹 PUBLIC
    from .public.routes import bp as public_bp
    app.register_blueprint(public_bp)

    # 🔹 ADMIN
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

    # ====================================================
    # 7️⃣ Gestion erreurs globale
    # ====================================================
    @app.errorhandler(404)
    def page_not_found(e):
        return "Page non trouvée", 404

    return app