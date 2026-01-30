from flask import (
    Blueprint, redirect, render_template, request
)

from manga.db import get_db

bp = Blueprint('books', __name__)


# Création d'une route /books qui liste tous les books
@bp.route('/')
def books():
    # Connexion à la DB
    db = get_db()
    # Récupération de tous les livres depuis la DB dans la variable books
    books = db.execute(
        'SELECT id, name, author_name'
        ' FROM books'
    ).fetchall()
    # Transmission de books sous le nouveau nom "livres" au template books.html
    return render_template('books/books.html', livres=books)

# Création d'une route /books/<id> qui met le détail d'un livre
# Note: int est typé en integer
@bp.route('/<int:id>')
def book_detail(id):
    # Connexion à la DB
    db = get_db()
    # Récupération du livre dont l'id correspond
    # Remarque ! on transmet jamais l'id directement, on utilise le système des ? pour éviter 
    # l'injection SQL. 
    book = db.execute(
        'SELECT id, name, author_name'
        ' FROM books'
        ' WHERE id=?',
        (id,)
    ).fetchone()
    # Transmission du book sous le nouveau nom "livre" au template
    return render_template('books/book_detail.html', livre=book)

# Plusieurs actions avec une seul route books
@bp.route('/create', methods=("GET", "POST"))
def book_create():
    if request.method == "GET":
        return render_template("books/book_create.html")
    
    elif request.method == 'POST':
        name = request.form['nom']
        author_name = request.form['nom_auteur']
        db = get_db()
        db.execute(
            "INSERT INTO books (name, author_name) VALUES (?, ?)",
            (name, author_name),
        )
        db.commit()
        return redirect("/books")

    return "Error"

# Modifier mon template existant
@bp.route('/<int:id>/update', methods=("GET", "POST"))
def book_update(id):
    # Connexion à la DB
    db = get_db()

    book = db.execute(
        'SELECT id, name, author_name'
        ' FROM books'
        ' WHERE id=?',
        (id,)
    ).fetchone()
    if request.method == "GET":
        return render_template("books/book_update.html", book=book)
    
    elif request.method == 'POST':
        name = request.form['nom']
        author_name = request.form['nom_auteur']
        db = get_db()
        db.execute(
            "UPDATE  books SET name = ?, author_name= ?"
            "WHERE id=?",
            (name, author_name, id),
        )
        db.commit()
        return redirect("/books")

    return "Error"

# Effacer dans ma bd
@bp.route('/books/<int:id>/delete')
def book_delete(id):
    # Connexion à la DB
    db = get_db()

    db.execute(
        'DELETE FROM books'
        ' WHERE id=?',
        (id,)
    )
    db.commit()
    return redirect("/books")