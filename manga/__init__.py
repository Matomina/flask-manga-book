"""
========================================================
MANGABOOK – APPLICATION FACTORY
--------------------------------------------------------
Point d’entrée principal de l’application Flask.

Responsabilités :
✔ Créer l’application Flask
✔ Charger la configuration
✔ Initialiser les extensions (base de données)
✔ Enregistrer les blueprints
✔ Déclarer les filtres Jinja
========================================================
"""

import os
import locale
from datetime import datetime
from flask import Flask, app


def create_app(test_config=None):
    """
    Application Factory Pattern.
    Permet de créer une instance configurable de l’application.
    """

    # ====================================================
    # 1️⃣ Création de l'application Flask
    # ====================================================
    app = Flask(__name__, instance_relative_config=True)

    # ====================================================
    # 2️⃣ Configuration principale
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
    # 3️⃣ Création du dossier instance si nécessaire
    # ====================================================
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # ====================================================
    # 4️⃣ Initialisation des extensions
    # ====================================================
    from .extensions import db
    db.init_app(app)

    # ====================================================
    # 5️⃣ Filtre Jinja – Format date française
    # ====================================================
    @app.template_filter("format_datetime_fr")
    def format_datetime_fr(value):
        """
        Convertit une date SQLite en format français.
        Exemple :
        2026-02-19 15:42:18
        -> 19 février 2026 à 15h42
        """
        if not value:
            return ""

        dt = datetime.strptime(value, "%Y-%m-%d %H:%M:%S")

        # Tentative locale française
        try:
            locale.setlocale(locale.LC_TIME, "fr_FR.UTF-8")
        except:
            try:
                locale.setlocale(locale.LC_TIME, "French_France")
            except:
                pass

        return dt.strftime("%d %B %Y à %Hh%M")

    # ====================================================
    # 6️⃣ Enregistrement des Blueprints
    # ====================================================
    
    # 🔹 Admin (dashboard)
    from .admin.admin import bp as admin_bp
    app.register_blueprint(admin_bp)

    # 🔹 Front-office (homepage)
    from .public.routes import bp as public_bp
    app.register_blueprint(public_bp)

    # 🔹 Catalogue articles
    from . import articles
    app.register_blueprint(articles.bp)

    # 🔹 Gestion utilisateurs (CRUD)
    from . import users
    app.register_blueprint(users.bp)

    # 🔹 Gestion commandes
    from . import orders
    app.register_blueprint(orders.bp)

    # 🔹 Authentification
    from . import auth
    app.register_blueprint(auth.bp)

    # ====================================================
    # 7️⃣ Route racine explicite (optionnelle)
    # ====================================================
    app.add_url_rule("/", endpoint="index")

    # ====================================================
    # 8️⃣ Retour de l'application
    # ====================================================
    return app
