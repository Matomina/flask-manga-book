from flask import Blueprint, render_template, redirect, url_for, abort
from manga.extensions.db import get_db
from .auth import admin_required

bp = Blueprint(
    "admin_contacts",
    __name__,
    url_prefix="/admin/contacts",
    template_folder="templates",
)

# ==============================
# LISTE CONTACTS
# ==============================
@bp.route("/")
@admin_required
def list_contacts():

    db = get_db()

    contacts = db.execute("""
        SELECT contact.*, user.first_name, user.last_name
        FROM contact
        LEFT JOIN user ON contact.user_id = user.id
        ORDER BY contact.created_at DESC
    """).fetchall()

    return render_template(
        "contacts/contacts.html",
        contacts=contacts
    )


# ==============================
# DETAIL CONTACT
# ==============================
@bp.route("/<int:id>")
@admin_required
def detail_contact(id):

    db = get_db()

    contact = db.execute("""
        SELECT contact.*, user.first_name, user.last_name
        FROM contact
        LEFT JOIN user ON contact.user_id = user.id
        WHERE contact.id = ?
    """, (id,)).fetchone()

    if contact is None:
        abort(404)

    return render_template(
        "contacts/contact_detail.html",
        contact=contact
    )


# ==============================
# DELETE CONTACT
# ==============================
@bp.route("/<int:id>/delete", methods=("POST",))
@admin_required
def delete_contact(id):

    db = get_db()

    db.execute("DELETE FROM contact WHERE id = ?", (id,))
    db.commit()

    return redirect(url_for("admin_contacts.list_contacts"))