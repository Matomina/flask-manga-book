"""
========================================================
ORDERS – BACK OFFICE
--------------------------------------------------------
Gestion complète des commandes :
✔ Liste
✔ Détail
✔ Création
✔ Modification
✔ Suppression
========================================================
"""

from flask import Blueprint, render_template, request, redirect, url_for, abort
from manga.extensions.db import get_db
from manga.auth import admin_required


# ====================================================
# 🔹 Déclaration du Blueprint
# ====================================================
bp = Blueprint("orders", __name__, url_prefix="/orders")


# ====================================================
# 🔹 LISTE DES COMMANDES
# ====================================================
@bp.route("/")
@admin_required
def list_orders():

    """
    Liste des commandes avec nom du client.
    """
    db = get_db()

    orders = db.execute(
        """
        SELECT
            orders.id,
            orders.total_amount,
            orders.status,
            orders.created_at,
            user.first_name,
            user.last_name
        FROM orders
        JOIN user ON orders.user_id = user.id
        ORDER BY orders.id ASC
        """
    ).fetchall()

    return render_template(
        "orders/orders.html",
        orders=orders
    )


# ====================================================
# 🔹 DÉTAIL COMMANDE
# ====================================================
@bp.route("/<int:id>")
def detail_order(id):
    db = get_db()

    order = db.execute(
        """
        SELECT
            orders.id,
            orders.total_amount,
            orders.status,
            orders.created_at,
            user.first_name,
            user.last_name
        FROM orders
        JOIN user ON orders.user_id = user.id
        WHERE orders.id = ?
        """,
        (id,)
    ).fetchone()

    if order is None:
        abort(404)

    articles = db.execute(
        """
        SELECT
            articles.name,
            orders_articles.quantity,
            orders_articles.unit_price
        FROM orders_articles
        JOIN articles ON orders_articles.article_id = articles.id
        WHERE orders_articles.order_id = ?
        """,
        (id,)
    ).fetchall()

    return render_template(
        "orders/detail_order.html",
        order=order,
        articles=articles
    )


# ====================================================
# 🔹 CREATE
# ====================================================
@bp.route("/create", methods=("GET", "POST"))
def create_order():
    """
    Création d'une nouvelle commande.
    """

    if request.method == "POST":
        user_id = request.form["user_id"]
        total_amount = request.form["total_amount"]
        status = request.form["status"]

        db = get_db()

        db.execute(
            """
            INSERT INTO orders (user_id, total_amount, status)
            VALUES (?, ?, ?)
            """,
            (user_id, total_amount, status),
        )
        db.commit()

        return redirect(url_for("orders.list_orders"))

    return render_template("orders/order_create.html")


# ====================================================
# 🔹 UPDATE
# ====================================================
@bp.route("/<int:id>/update", methods=("GET", "POST"))
def update_order(id):
    """
    Modification d'une commande existante.
    """
    db = get_db()

    order = db.execute(
        "SELECT * FROM orders WHERE id = ?",
        (id,),
    ).fetchone()

    if order is None:
        abort(404)

    if request.method == "POST":
        user_id = request.form["user_id"]
        total_amount = request.form["total_amount"]
        status = request.form["status"]

        db.execute(
            """
            UPDATE orders
            SET user_id = ?, total_amount = ?, status = ?
            WHERE id = ?
            """,
            (user_id, total_amount, status, id),
        )
        db.commit()

        return redirect(url_for("orders.list_orders"))

    return render_template(
        "orders/update_order.html",
        order=order
    )


# ====================================================
# 🔹 DELETE
# ====================================================
@bp.route("/<int:id>/delete", methods=("POST",))
def delete_order(id):
    """
    Suppression d'une commande.
    """
    db = get_db()

    order = db.execute(
        "SELECT id FROM orders WHERE id = ?",
        (id,),
    ).fetchone()

    if order is None:
        abort(404)

    db.execute(
        "DELETE FROM orders WHERE id = ?",
        (id,),
    )
    db.commit()

    return redirect(url_for("orders.list_orders"))
