from flask import Blueprint, redirect, render_template, request, url_for
from werkzeug.security import generate_password_hash
from manga.db import get_db

bp = Blueprint('users', __name__, url_prefix='/users')

# Liste des users
@bp.route('/')
def users():
    db = get_db()
    users = db.execute('SELECT * FROM user').fetchall()
    return render_template('users/users.html', users=users)


# Détail d'un user
@bp.route('/<int:id>')
def detail_user(id):
    db = get_db()

    user = db.execute(
        '''
        SELECT id, first_name, last_name, email, phone, address, role
        FROM user
        WHERE id = ?
        ''',
        (id,)
    ).fetchone()

    return render_template('users/detail_user.html', user=user)


# =========================
# CREATE
# =========================
@bp.route('/create', methods=("GET", "POST"))
def user_create():
    if request.method == "GET":
        return render_template("users/user_create.html")

    if request.method == "POST":
        first_name = request.form['prenom_utilisateur']
        last_name = request.form['nom_utilisateur']
        email = request.form['email_utilisateur']
        password = request.form['password_utilisateur']
        role = request.form['role_utilisateur']

        db = get_db()

        db.execute(
            """
            INSERT INTO user (first_name, last_name, email, password, role)
            VALUES (?, ?, ?, ?, ?)
            """,
            (
                first_name,
                last_name,
                email,
                generate_password_hash(password),
                role
            ),
        )
        db.commit()

        return redirect(url_for("users.users"))


# =========================
# UPDATE
# =========================
@bp.route('/<int:id>/update', methods=("GET", "POST"))
def user_update(id):
    db = get_db()

    user = db.execute(
        """
        SELECT id, first_name, last_name, email, role
        FROM user
        WHERE id = ?
        """,
        (id,),
    ).fetchone()

    if request.method == "GET":
        return render_template("users/user_update.html", user=user)

    if request.method == "POST":
        first_name = request.form['prenom_utilisateur']
        last_name = request.form['nom_utilisateur']
        email = request.form['email_utilisateur']
        role = request.form['role_utilisateur']

        db.execute(
            """
            UPDATE user
            SET first_name = ?, last_name = ?, email = ?, role = ?
            WHERE id = ?
            """,
            (first_name, last_name, email, role, id),
        )
        db.commit()

        return redirect(url_for("users.users"))


# =========================
# DELETE
# =========================
@bp.route('/<int:id>/delete')
def user_delete(id):
    db = get_db()

    db.execute(
        "DELETE FROM user WHERE id = ?",
        (id,),
    )
    db.commit()

    return redirect(url_for("users.users"))
    