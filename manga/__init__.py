import os
from flask import Flask, render_template, request, redirect

from manga.db import get_db

def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE=os.path.join(app.instance_path, 'manga.sqlite'),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass
    
    from . import db
    db.init_app(app)

    @app.route('/home')
    def manga():
        mangas = db.execute("SELECT * ...").fetchall()
       
        return render_template("home.html", mangas=mangas)

    from . import auth
    app.register_blueprint(auth.bp)

    from . import blog
    app.register_blueprint(blog.bp)

    from . import utilisateurs
    app.register_blueprint(utilisateurs.bp, url_prefix='/utilisateurs')

    from . import books
    app.register_blueprint(books.bp, url_prefix='/books')

    from . import orders
    app.register_blueprint(orders.bp, url_prefix='/orders')

    app.add_url_rule('/', endpoint='index')

    return app