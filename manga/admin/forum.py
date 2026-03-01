"""
========================================================
ADMIN – FORUM MANAGEMENT
--------------------------------------------------------
Module de gestion des sujets du forum côté administration.

Fonctionnalités :
- Consultation des sujets
- Consultation du détail
- Réponse administrateur
- Suppression d’un sujet
- Accès restreint aux administrateurs
========================================================
"""

from flask import Blueprint, render_template, redirect, url_for, request, session
from manga.extensions.db import get_db
from .auth import admin_required


# ====================================================
# BLUEPRINT ADMIN FORUM
# ====================================================
bp = Blueprint(
    "admin_forum",
    __name__,
    url_prefix="/admin/forum",
    template_folder="templates",
)


# ====================================================
# LISTE DES SUJETS
# ====================================================
@bp.route("/")
@admin_required
def list_messages():

    db = get_db()

    messages = db.execute("""
        SELECT
            topics.id,
            topics.title,
            topics.created_at,
            user.first_name,
            user.last_name
        FROM topics
        LEFT JOIN user ON topics.user_id = user.id
        ORDER BY topics.created_at DESC
    """).fetchall()

    return render_template(
        "forum/messages.html",
        messages=messages
    )


# ====================================================
# DETAIL D’UN SUJET
# ====================================================
@bp.route("/<int:id>")
@admin_required
def message_detail(id):

    db = get_db()

    # Sujet principal
    topic = db.execute("""
        SELECT
            topics.id,
            topics.title,
            topics.message,
            topics.created_at,
            user.first_name,
            user.last_name
        FROM topics
        LEFT JOIN user ON topics.user_id = user.id
        WHERE topics.id = ?
    """, (id,)).fetchone()

    if topic is None:
        return redirect(url_for("admin_forum.list_messages"))

    # Réponses associées
    replies = db.execute("""
        SELECT
            replies.id,
            replies.message,
            replies.created_at,
            user.first_name,
            user.last_name
        FROM replies
        LEFT JOIN user ON replies.user_id = user.id
        WHERE replies.topic_id = ?
        ORDER BY replies.created_at ASC
    """, (id,)).fetchall()

    return render_template(
        "forum/message_detail.html",
        topic=topic,
        replies=replies
    )


# ====================================================
# AJOUT D’UNE REPONSE (ADMIN)
# ====================================================
@bp.route("/<int:id>/reply", methods=["POST"])
@admin_required
def add_reply(id):

    message = request.form.get("message")

    if not message:
        return redirect(url_for("admin_forum.message_detail", id=id))

    db = get_db()

    db.execute("""
        INSERT INTO replies (topic_id, user_id, message)
        VALUES (?, ?, ?)
    """, (id, session["user_id"], message))

    db.commit()

    return redirect(url_for("admin_forum.message_detail", id=id))


# ====================================================
# SUPPRESSION D’UN SUJET
# ====================================================
@bp.route("/delete/<int:id>", methods=["POST"])
@admin_required
def delete_message(id):

    db = get_db()

    db.execute(
        "DELETE FROM topics WHERE id = ?",
        (id,)
    )

    db.commit()

    return redirect(url_for("admin_forum.list_messages"))