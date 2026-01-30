from flask import (
    Blueprint, redirect, render_template, request
)

from manga.db import get_db

bp = Blueprint('utilisateurs', __name__)


# Création d'une route / utilisateurs qui liste tout les utilisateurs
@bp.route('/')
def users():
    db = get_db()
    utilisateurs = db.execute('SELECT * FROM utilisateurs').fetchall()
    return render_template('utilisateurs/utilisateurs.html', users=utilisateurs)

# Création d'une route /utilisateurs/<id> qui met le détail d'un utilisateur
# Note: int est typé en integer
@bp.route('/<int:id>')
def detail_utilisateurs(id):
    # Connexion à la DB
    db = get_db()
    # Récupération de l'utilisateur dont l'id correspond
    # Remarque ! on transmet jamais l'id directement, on utilise le système des ? pour éviter 
    # l'injection SQL. 
    user = db.execute(
        'SELECT id, first_name, last_name, email, password, phone, address, role'
        ' FROM utilisateurs'
        ' WHERE id=?',
        (id,)
    ).fetchone()
    # Transmission du user sous le nouveau nom "utilisateur" au template
    return render_template('utilisateurs/detail_utilisateur.html', utilisateur=user)

# Plusieurs actions avec une seul route utilisateurs
@bp.route('/create', methods=("GET", "POST"))
def utilisateurs_create():
    if request.method == "GET":
        return render_template("utilisateurs/utilisateurs_create.html")
    
    elif request.method == 'POST':
        last_name = request.form['nom_utilisateur']
        first_name = request.form['prenom_utilisateur']
        email = request.form['email_utilisateur']
        role = request.form['role_utilisateur']
        db = get_db()
        db.execute(
            "INSERT INTO utilisateurs (last_name, first_name, email, role ) "
            "VALUES (?, ?, ?, ?)",
            (last_name, first_name, email, role ),
        )
        db.commit()
        return redirect("/utilisateurs")

    return "Error"

# Modifier mon template existant
@bp.route('/<int:id>/update', methods=("GET", "POST"))
def utilisateurs_update(id):
    # Connexion à la DB
    db = get_db()

    user1 = db.execute(
        'SELECT id, last_name, first_name, email, role'
        ' FROM utilisateurs'
        ' WHERE id=?',
        (id,)
    ).fetchone()
    if request.method == "GET":
        return render_template("utilisateurs/utilisateurs_update.html", user=user1)
    
    elif request.method == 'POST':
        last_name = request.form['nom_utilisateur']
        first_name = request.form['prenom_utilisateur']
        email = request.form['email_utilisateur']
        role = request.form['role_utilisateur']
        db = get_db()
        db.execute(
            "UPDATE  utilisateurs SET last_name = ?, first_name= ?, email= ?, role= ?"
            "WHERE id=?",
            (last_name, first_name, email, role, id),
        )
        db.commit()
        return redirect("/utilisateurs")

    return "Error"

# Effacer dans ma bd
@bp.route('/<int:id>/delete')
def utilisateur_delete(id):
    # Connexion à la DB
    db = get_db()

    db.execute(
        'DELETE FROM utilisateurs'
        ' WHERE id=?',
        (id,)
    )
    db.commit()
    return redirect("/utilisateurs")
    