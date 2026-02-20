document.addEventListener("DOMContentLoaded", () => {

    // ==============================
    // Confirmation suppression
    // ==============================

    document.querySelectorAll(".btn-delete").forEach(button => {
        button.addEventListener("click", (e) => {
            const confirmed = confirm("Êtes-vous sûr de vouloir supprimer cet élément ?");
            if (!confirmed) {
                e.preventDefault();
            }
        });
    });


    // ==============================
    // Auto hide des alertes flash
    // ==============================

    const alerts = document.querySelectorAll(".alert");
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.classList.add("fade");
            alert.classList.remove("show");
        }, 4000);
    });


});