"""
========================================================
ADMIN – USERS MANAGEMENT
--------------------------------------------------------
Gestion complète des utilisateurs (Back-office)

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
from .auth import admin_required


# ====================================================
# 🔹 Blueprint Users (Admin Module)
# ====================================================
bp = Blueprint(
    "users",
    __name__,
    url_prefix="/admin/users",
    template_folder="templates",
)


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
@admin_required
def detail_user(id):
    db = get_db()

    user = db.execute(
        """
        SELECT id, first_name, last_name, email, phone,
               address, city, role, created_at
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
@admin_required
def create_user():

    if request.method == "GET":
        return render_template("users/user_create.html")

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
@admin_required
def update_user(id):

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
        return render_template(
            "users/user_update.html",
            user=user
        )

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
@admin_required
def delete_user(id):

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
