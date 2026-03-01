"""
========================================================
ADMIN – DASHBOARD
--------------------------------------------------------
Back-office principal de l'application MangaBook.
========================================================
"""

from flask import Blueprint, render_template
from manga.extensions.db import get_db
from .auth import admin_required


bp = Blueprint(
    "admin",
    __name__,
    url_prefix="/admin",
    template_folder="templates",
)


@bp.route("/")
@admin_required
def dashboard():

    db = get_db()

    stats = {
        "total_users": db.execute(
            "SELECT COUNT(*) FROM user"
        ).fetchone()[0],

        "total_orders": db.execute(
            "SELECT COUNT(*) FROM orders"
        ).fetchone()[0],

        "total_articles": db.execute(
            "SELECT COUNT(*) FROM articles"
        ).fetchone()[0],

        "total_messages": db.execute(
            "SELECT COUNT(*) FROM contact"
        ).fetchone()[0],

        "total_forum_messages": db.execute(
            "SELECT COUNT(*) FROM topics"
        ).fetchone()[0],
    }

    return render_template(
        "admin/dashboard.html",
        stats=stats
    )