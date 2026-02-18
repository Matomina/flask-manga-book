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
========================================================
"""

import os
from flask import Flask


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
        SECRET_KEY='dev',  # ⚠️ À sécuriser en production
        DATABASE=os.path.join(app.instance_path, 'manga.sqlite'),
    )

    # Configuration alternative (tests ou config locale)
    if test_config is None:
        app.config.from_pyfile('config.py', silent=True)
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

    #=====================================================
    # 5️⃣ Enregistrement des Blueprints
    # ====================================================

    # 🔹 Front-office (page d'accueil)
    from .public.routes import bp as public_bp
    app.register_blueprint(public_bp)

    # 🔹 Catalogue Articles
    from . import articles
    app.register_blueprint(articles.bp)

    # 🔹 Authentification
    from . import auth
    app.register_blueprint(auth.bp)


    # ----------------------------------------------------
    # 🔹 Modules temporairement désactivés (refactor)
    # ----------------------------------------------------
    # from . import blog
    # app.register_blueprint(blog.bp)

    # from . import users
    # app.register_blueprint(users.bp, url_prefix='/utilisateurs')

    # from . import books
    # app.register_blueprint(books.bp, url_prefix='/books')

    # from . import orders
    # app.register_blueprint(orders.bp, url_prefix='/orders')

    # from . import articles
    # app.register_blueprint(articles.bp)

    # ====================================================
    # 6️⃣ Route racine
    # ====================================================
    app.add_url_rule('/', endpoint='index')

    # ====================================================
    # 7️⃣ Retour de l'application
    # ====================================================
    return app
