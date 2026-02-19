"""
========================================================
USERS – BACK OFFICE
--------------------------------------------------------
Gestion complète des utilisateurs :
✔ Liste
✔ Détail
✔ Création
✔ Modification
✔ Suppression
========================================================
"""

from flask import Blueprint, render_template, request, redirect, url_for, abort
from werkzeug.security import generate_password_hash
from manga.extensions.db import get_db
from manga.auth import admin_required


# ====================================================
# 🔹 Déclaration du Blueprint
# ====================================================
# Toutes les routes commenceront par /users
bp = Blueprint("users", __name__, url_prefix="/users")


# ====================================================
# 🔹 LISTE DES UTILISATEURS
# ====================================================
@bp.route("/")
@admin_required
def list_users():

    db = get_db()

    users = db.execute(
        """
        SELECT id, first_name, last_name, email, role, created_at
        FROM user
        ORDER BY id ASC
        """
    ).fetchall()

    return render_template(
        "users/users.html",
        users=users
    )


# ====================================================
# 🔹 DÉTAIL UTILISATEUR
# ====================================================
@bp.route("/<int:id>")
def detail_user(id):

    db = get_db()

    user = db.execute(
        """
        SELECT id, first_name, last_name, email, phone, address, city, role, created_at
        FROM user
        WHERE id = ?
        """,
        (id,),
    ).fetchone()

    if user is None:
        abort(404)

    return render_template(
        "users/detail_user.html",
        user=user
    )


# ====================================================
# 🔹 CREATE UTILISATEUR
# ====================================================
@bp.route("/create", methods=("GET", "POST"))
def create_user():
    """
    Création d’un nouvel utilisateur.
    """

    if request.method == "GET":
        return render_template("users/user_create.html")

    # Récupération formulaire
    first_name = request.form.get("prenom_utilisateur")
    last_name = request.form.get("nom_utilisateur")
    email = request.form.get("email_utilisateur")
    password = request.form.get("password_utilisateur")
    role = request.form.get("role_utilisateur")

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
            role,
        ),
    )
    db.commit()

    return redirect(url_for("users.list_users"))


# ====================================================
# 🔹 UPDATE UTILISATEUR
# ====================================================
@bp.route("/<int:id>/update", methods=("GET", "POST"))
def update_user(id):
    """
    Modification d’un utilisateur existant.
    """
    db = get_db()

    user = db.execute(
        """
        SELECT id, first_name, last_name, email, role
        FROM user
        WHERE id = ?
        """,
        (id,),
    ).fetchone()

    if user is None:
        abort(404)

    if request.method == "GET":
        return render_template("users/user_update.html", user=user)

    # Récupération formulaire
    first_name = request.form.get("prenom_utilisateur")
    last_name = request.form.get("nom_utilisateur")
    email = request.form.get("email_utilisateur")
    role = request.form.get("role_utilisateur")

    db.execute(
        """
        UPDATE user
        SET first_name = ?, last_name = ?, email = ?, role = ?
        WHERE id = ?
        """,
        (first_name, last_name, email, role, id),
    )
    db.commit()

    return redirect(url_for("users.list_users"))


# ====================================================
# 🔹 DELETE UTILISATEUR
# ====================================================
@bp.route("/<int:id>/delete", methods=("POST",))
def delete_user(id):
    """
    Suppression d’un utilisateur.
    Utilise POST pour éviter les suppressions accidentelles via GET.
    """
    db = get_db()

    user = db.execute(
        "SELECT id FROM user WHERE id = ?",
        (id,),
    ).fetchone()

    if user is None:
        abort(404)

    db.execute(
        "DELETE FROM user WHERE id = ?",
        (id,),
    )
    db.commit()

    return redirect(url_for("users.list_users"))
