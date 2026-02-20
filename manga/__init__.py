"""
========================================================
MANGABOOK – APPLICATION FACTORY
--------------------------------------------------------
Initialisation principale de l'application Flask.

Responsabilités :
✔ Création de l'application
✔ Chargement configuration
✔ Initialisation extensions
✔ Enregistrement blueprints
✔ Déclaration filtres Jinja
========================================================
"""

import os
import locale
from datetime import datetime
from flask import Flask


def create_app(test_config=None):

    # ====================================================
    # 1️⃣ Création application
    # ====================================================
    app = Flask(__name__, instance_relative_config=True)

    # ====================================================
    # 2️⃣ Configuration
    # ====================================================
    app.config.from_mapping(
        SECRET_KEY="dev",  # ⚠️ À sécuriser en production
        DATABASE=os.path.join(app.instance_path, "manga.sqlite"),
    )

    if test_config is None:
        app.config.from_pyfile("config.py", silent=True)
    else:
        app.config.from_mapping(test_config)

    # ====================================================
    # 3️⃣ Instance folder
    # ====================================================
    os.makedirs(app.instance_path, exist_ok=True)

    # ====================================================
    # 4️⃣ Extensions
    # ====================================================
    from .extensions import db
    db.init_app(app)

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
        except:
            pass

        return dt.strftime("%d %B %Y à %Hh%M")

    # ====================================================
    # 6️⃣ ENREGISTREMENT DES BLUEPRINTS
    # ====================================================

    # 🔹 PUBLIC
    from .public.routes import bp as public_bp
    app.register_blueprint(public_bp)

    # 🔹 ADMIN – Dashboard
    from .admin.admin import bp as admin_bp
    app.register_blueprint(admin_bp)

    # 🔹 ADMIN – Modules
    from .admin.users import bp as users_bp
    app.register_blueprint(users_bp)

    from .admin.orders import bp as orders_bp
    app.register_blueprint(orders_bp)

    from .admin.articles import bp as articles_bp
    app.register_blueprint(articles_bp)

    from .admin.auth import bp as auth_bp
    app.register_blueprint(auth_bp)

    from .admin import contacts
    app.register_blueprint(contacts.bp)
    
    # ====================================================
    # 7️⃣ Retour application
    # ====================================================
    return app
