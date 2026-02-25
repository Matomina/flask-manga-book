"""
========================================================
AUTHENTICATION – ADMIN MODULE
--------------------------------------------------------
Gestion :
✔ Inscription utilisateur
✔ Connexion
✔ Déconnexion
✔ Chargement utilisateur
✔ Décorateurs login_required / admin_required
========================================================
"""

import functools
import sqlite3

from flask import (
    Blueprint, flash, g, redirect,
    render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash
from manga.extensions.db import get_db


# ====================================================
# 🔹 Blueprint Auth
# ====================================================
bp = Blueprint(
    "auth",
    __name__,
    url_prefix="/auth",
    template_folder="templates",
)


# ====================================================
# 🔹 REGISTER
# ====================================================
@bp.route("/register", methods=("GET", "POST"))
def register():

    if request.method == "POST":

        first_name = request.form.get("first_name")
        last_name = request.form.get("last_name")
        email = request.form.get("email")
        password = request.form.get("password")

        db = get_db()
        error = None

        if not first_name:
            error = "First name is required."
        elif not last_name:
            error = "Last name is required."
        elif not email:
            error = "Email is required."
        elif not password:
            error = "Password is required."

        if error is None:
            try:
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
                        "user",
                    ),
                )
                db.commit()
            except sqlite3.IntegrityError:
                error = f"User with email {email} is already registered."
            else:
                return redirect(url_for("auth.login"))

        flash(error)

    return render_template("auth/register.html")


# ====================================================
# LOGIN
# ====================================================
@bp.route("/login", methods=("GET", "POST"))
def login():

    if request.method == "POST":

        # ----------------------------------------------
        # Récupération des données du formulaire
        # ----------------------------------------------
        email = request.form.get("email")
        password = request.form.get("password")

        db = get_db()
        error = None

        # ----------------------------------------------
        # Recherche utilisateur en base
        # ----------------------------------------------
        user = db.execute(
            "SELECT * FROM user WHERE email = ?",
            (email,),
        ).fetchone()

        # ----------------------------------------------
        # Vérifications
        # ----------------------------------------------
        if user is None:
            error = "Incorrect email."
        elif not check_password_hash(user["password"], password):
            error = "Incorrect password."

        # ----------------------------------------------
        # Connexion réussie
        # ----------------------------------------------
        if error is None:

            # Nettoyage session précédente
            session.clear()
            session["user_id"] = user["id"]

            # Récupération éventuelle du paramètre "next"
            # Exemple : /auth/login?next=/profil
            next_page = request.args.get("next")

            # Sécurité : on autorise uniquement les URLs internes
            # (évite les redirections vers des sites externes)
            if next_page and next_page.startswith("/"):
                return redirect(next_page)

            # Redirection selon rôle
            if user["role"] == "admin":
                return redirect(url_for("admin.dashboard"))

            # Redirection par défaut utilisateur
            return redirect(url_for("public.profil"))

        # Si erreur → message flash
        flash(error)

    # Affichage page login (GET)
    return render_template("auth/login.html")


# ====================================================
# 🔹 LOAD USER
# ====================================================
@bp.before_app_request
def load_logged_in_user():

    user_id = session.get("user_id")

    if user_id is None:
        g.user = None
    else:
        g.user = get_db().execute(
            "SELECT * FROM user WHERE id = ?",
            (user_id,),
        ).fetchone()


# ====================================================
# 🔹 LOGOUT
# ====================================================
@bp.route("/logout")
def logout():

    role = g.user["role"] if g.user else None

    session.clear()

    if role == "admin":
        return redirect(url_for("auth.login"))

    return redirect(url_for("public.home"))


# ====================================================
# 🔹 DECORATOR LOGIN REQUIRED
# ====================================================
def login_required(view):

    @functools.wraps(view)
    def wrapped_view(**kwargs):

        if g.user is None:
            return redirect(url_for("auth.login"))

        return view(**kwargs)

    return wrapped_view


# ====================================================
# 🔹 DECORATOR ADMIN REQUIRED
# ====================================================
def admin_required(view):

    @functools.wraps(view)
    def wrapped_view(**kwargs):

        if g.user is None:
            return redirect(url_for("auth.login"))

        if g.user["role"] != "admin":
            return redirect(url_for("public.index"))

        return view(**kwargs)

    return wrapped_view
