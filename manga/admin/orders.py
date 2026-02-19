"""
========================================================
ADMIN – ORDERS MANAGEMENT
--------------------------------------------------------
Gestion complète des commandes (Back-office)

✔ Liste
✔ Détail
✔ Création
✔ Modification
✔ Suppression
========================================================
"""

from flask import Blueprint, render_template, request, redirect, url_for, abort
from manga.extensions.db import get_db
from .auth import admin_required



# ====================================================
# 🔹 Blueprint Orders (Admin Module)
# ====================================================
bp = Blueprint(
    "admin_orders",
    __name__,
    url_prefix="/admin/orders",
    template_folder="templates",
)


# ====================================================
# 🔹 LISTE DES COMMANDES
# ====================================================
@bp.route("/")
@admin_required
def list_orders():

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
@admin_required
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
# 🔹 CREATE ORDER
# ====================================================
@bp.route("/create", methods=("GET", "POST"))
@admin_required
def create_order():

    if request.method == "GET":
        return render_template("orders/order_create.html")

    user_id = request.form.get("user_id")
    total_amount = request.form.get("total_amount")
    status = request.form.get("status")

    db = get_db()

    db.execute(
        """
        INSERT INTO orders (user_id, total_amount, status)
        VALUES (?, ?, ?)
        """,
        (user_id, total_amount, status),
    )
    db.commit()

    return redirect(url_for("admin_orders.list_orders"))


# ====================================================
# 🔹 UPDATE ORDER
# ====================================================
@bp.route("/<int:id>/update", methods=("GET", "POST"))
@admin_required
def update_order(id):

    db = get_db()

    order = db.execute(
        "SELECT * FROM orders WHERE id = ?",
        (id,),
    ).fetchone()

    if order is None:
        abort(404)

    if request.method == "GET":
        return render_template(
            "orders/order_update.html",
            order=order
        )

    user_id = request.form.get("user_id")
    total_amount = request.form.get("total_amount")
    status = request.form.get("status")

    db.execute(
        """
        UPDATE orders
        SET user_id = ?, total_amount = ?, status = ?
        WHERE id = ?
        """,
        (user_id, total_amount, status, id),
    )
    db.commit()

    return redirect(url_for("admin_orders.list_orders"))


# ====================================================
# 🔹 DELETE ORDER
# ====================================================
@bp.route("/<int:id>/delete", methods=("POST",))
@admin_required
def delete_order(id):

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

    return redirect(url_for("admin_orders.list_orders"))
