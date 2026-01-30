from flask import (
    Blueprint, redirect, render_template, request
)

from manga.db import get_db

bp = Blueprint('orders', __name__)


# Création d'une route / orders qui liste toutes les commandes
@bp.route('/')
def orders():
    db = get_db()
    orders = db.execute('SELECT * FROM orders').fetchall()
    return render_template('orders/orders.html', orders=orders)

# Création d'une route /orders/<id> qui met le détail d'une commande
# Note: int est typé en integer
@bp.route('/<int:id>')
def detail_orders(id):
    # Connexion à la DB
    db = get_db()
    # Récupération de l'utilisateur dont l'id correspond
    # Remarque ! on transmet jamais l'id directement, on utilise le système des ? pour éviter 
    # l'injection SQL. 
    detail_order = db.execute(
        'SELECT id, total_amount, order_date, status'
        ' FROM orders'
        ' WHERE id=?',
        (id,)
    ).fetchone()
    # Transmission du detail_order sous le nouveau nom "detail_order" au template
    return render_template('orders/detail_order.html', detail_order=detail_order)
