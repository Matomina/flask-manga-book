"""
========================================================
MANGABOOK – AUTHENTICATION MODULE
--------------------------------------------------------
Gestion :
- Inscription utilisateur
- Connexion (user + admin)
- Déconnexion
- Chargement utilisateur global
- Décorateurs login_required / admin_required
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
# Blueprint Auth
# ====================================================
bp = Blueprint(
    "auth",
    __name__,
    url_prefix="/auth",
    template_folder="templates",
)


# ====================================================
# REGISTER
# ====================================================
@bp.route("/register", methods=("GET", "POST"))
def register():

    if request.method == "POST":

        first_name = request.form.get("first_name", "").strip()
        last_name = request.form.get("last_name", "").strip()
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "").strip()
        phone = request.form.get("phone", "").strip()
        address = request.form.get("address", "").strip()
        city = request.form.get("city", "").strip()

        error = None
        db = get_db()

        # =============================
        # VALIDATIONS
        # =============================

        if not first_name:
            error = "First name is required."

        elif not last_name:
            error = "Last name is required."

        elif not email:
            error = "Email is required."

        elif not password:
            error = "Password is required."

        elif len(password) < 6:
            error = "Password must be at least 6 characters."

        elif db.execute(
            "SELECT id FROM user WHERE email = ?",
            (email,)
        ).fetchone() is not None:
            error = "This email is already registered."

        elif phone and db.execute(
            "SELECT id FROM user WHERE phone = ?",
            (phone,)
        ).fetchone() is not None:
            error = "This phone number is already used."

        # =============================
        # INSERTION
        # =============================
        if error is None:

            hashed_password = generate_password_hash(password)

            db.execute(
                """
                INSERT INTO user (
                    first_name,
                    last_name,
                    email,
                    password,
                    phone,
                    address,
                    city,
                    role
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    first_name,
                    last_name,
                    email,
                    hashed_password,
                    phone if phone else None,
                    address if address else None,
                    city if city else None,
                    "user",
                ),
            )

            db.commit()

            user = db.execute(
                "SELECT * FROM user WHERE email = ?",
                (email,)
            ).fetchone()

            session.clear()
            session["user_id"] = user["id"]

            return redirect(url_for("public.profil"))

        flash(error)

    return render_template("auth/register.html")


# ====================================================
# LOGIN
# ====================================================
@bp.route("/login", methods=("GET", "POST"))
def login():

    next_page = request.args.get("next")

    if request.method == "POST":

        email = request.form.get("email")
        password = request.form.get("password")

        db = get_db()
        error = None

        # Recherche utilisateur
        user = db.execute(
            "SELECT * FROM user WHERE email = ?",
            (email,),
        ).fetchone()

        # Vérifications
        if user is None:
            error = "Incorrect email."
        elif not check_password_hash(user["password"], password):
            error = "Incorrect password."

        # Connexion réussie
        if error is None:

            session.clear()
            session["user_id"] = user["id"]

            # Redirection sécurisée vers page demandée
            if next_page and next_page.startswith("/"):
                return redirect(next_page)

            # Redirection selon rôle
            if user["role"] == "admin":
                return redirect(url_for("admin.dashboard"))

            return redirect(url_for("public.profil"))

        flash(error)

    return render_template("auth/login.html")


# ====================================================
# LOAD USER (global g.user)
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
# LOGOUT
# ====================================================
@bp.route("/logout")
def logout():

    session.clear()
    return redirect(url_for("public.home"))


# ====================================================
# DECORATOR – LOGIN REQUIRED
# ====================================================
def login_required(view):

    @functools.wraps(view)
    def wrapped_view(**kwargs):

        if g.user is None:
            return redirect(
                url_for("auth.login", next=request.path)
            )

        return view(**kwargs)

    return wrapped_view


# ====================================================
# DECORATOR – ADMIN REQUIRED
# ====================================================
def admin_required(view):

    @functools.wraps(view)
    def wrapped_view(**kwargs):

        if g.user is None:
            return redirect(
                url_for("auth.login", next=request.path)
            )

        if g.user["role"] != "admin":
            return redirect(url_for("public.home"))

        return view(**kwargs)

    return wrapped_view