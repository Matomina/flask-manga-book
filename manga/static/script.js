// ======================================================
// ============ OUTILS GÉNÉRIQUES =======================
// ======================================================

// Fonction utilitaire : ajoute des écouteurs si l’élément existe
function onEvent(element, event, callback) {
    if (element) {
        element.addEventListener(event, callback);
    }
}

// Fonction générique de scroll horizontal
function initScroll(wrapperSelector, containerSelector) {
    document.querySelectorAll(wrapperSelector).forEach((wrapper) => {
        const container = wrapper.querySelector(containerSelector);
        const btnLeft = wrapper.querySelector(".scroll-btn.left");
        const btnRight = wrapper.querySelector(".scroll-btn.right");

        if (container) {
            onEvent(btnLeft, "click", () =>
                container.scrollBy({ left: -300, behavior: "smooth" })
            );
            onEvent(btnRight, "click", () =>
                container.scrollBy({ left: 300, behavior: "smooth" })
            );
        }
    });
}

// ======================================================
// ============ SCROLL HORIZONTAL =======================
// ======================================================

// Scroll pour card-lists (catalogue, profil, etc.)
initScroll(".scroll-container", ".card-list");
initScroll(".scroll-wrapper", ".scroll-list");
initScroll(".planning-grid-wrapper", ".planning-grid");
initScroll(".no-fixed-day-wrapper", ".card-row");


// ======================================================
// ============ MENU BURGER =============================
// ======================================================

document.addEventListener("DOMContentLoaded", () => {
    const burgerIcon = document.getElementById("burger-icon");
    const mobileNav = document.querySelector(".mobile-nav");

    if (!burgerIcon || !mobileNav) return;

    // Ouvrir / fermer le menu
    onEvent(burgerIcon, "click", () => {
        burgerIcon.classList.toggle("open");
        mobileNav.classList.toggle("active");
        document.body.style.overflow = mobileNav.classList.contains("active")
            ? "hidden"
            : "";
    });

    // Fermer au clic sur un lien
    mobileNav.querySelectorAll("a").forEach((link) => {
        onEvent(link, "click", () => {
            burgerIcon.classList.remove("open");
            mobileNav.classList.remove("active");
            document.body.style.overflow = "";
        });
    });

    // Fermer au clic extérieur
    document.addEventListener("click", (event) => {
        if (
            !burgerIcon.contains(event.target) &&
            !mobileNav.contains(event.target) &&
            mobileNav.classList.contains("active")
        ) {
            burgerIcon.classList.remove("open");
            mobileNav.classList.remove("active");
            document.body.style.overflow = "";
        }
    });
});



// ======================================================
// =============== BOUTON HAUT DE PAGE ==================
// ======================================================

document.addEventListener("DOMContentLoaded", () => {
    const scrollTopBtn = document.getElementById("scrollTopBtn");
    if (!scrollTopBtn) return;

    // Afficher / cacher le bouton selon la position du scroll
    window.addEventListener("scroll", () => {
        if (window.scrollY > 300) { // après 300px de scroll
            scrollTopBtn.classList.add("active");
        } else {
            scrollTopBtn.classList.remove("active");
        }
    });

    // Action du bouton : remonter en haut
    scrollTopBtn.addEventListener("click", () => {
        window.scrollTo({ top: 0, behavior: "smooth" });
    });
});


// =====================================================
// =================== FORMULAIRE =====================
// =====================================================

document.addEventListener("DOMContentLoaded", () => {
    // Sélectionne tous les boutons des deux onglets
    const tabButtons = document.querySelectorAll(".tab-btn-inscription, .tab-btn-connexion");
    const formBoxes = document.querySelectorAll(".form-box");

    tabButtons.forEach(button => {
        button.addEventListener("click", () => {
            // Supprime la classe "active" sur tous les onglets et formulaires
            tabButtons.forEach(btn => btn.classList.remove("active"));
            formBoxes.forEach(form => form.classList.remove("active"));

            // Ajoute la classe "active" sur le bon onglet et le bon formulaire
            button.classList.add("active");
            const target = button.getAttribute("data-tab");
            document.getElementById(`form-${target}`).classList.add("active");
        });
    });
});




// =====================================================
// =================== PANIER GLOBAL ===================
// =====================================================

// =====================================================
// ================ PANIER GLOBAL SYNC =================
// =====================================================

// --- Chargement du panier depuis localStorage ---
let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];

// --- Sauvegarde du panier ---
function saveCart() {
    localStorage.setItem("cartItems", JSON.stringify(cartItems));

    // 🔁 On synchronise visuellement tous les affichages
    renderCart("cartContent");
    renderCart("cartPageContent");
    updateCartCount();
}

// ======================================================
// =================== COMPTEUR ========================
// ======================================================

function updateCartCount() {
    const count = cartItems.reduce((sum, i) => sum + i.quantity, 0);
    const countEl = document.getElementById("floatingCartCount");
    if (countEl) {
        countEl.textContent = count;
        countEl.style.display = count > 0 ? "flex" : "none";
    }
}

// ======================================================
// =================== AJOUT AU PANIER =================
// ======================================================

function addToCart(name, price, img, btn = null) {
    const existing = cartItems.find(i => i.name === name);
    if (existing) existing.quantity++;
    else cartItems.push({ name, price, quantity: 1, img });

    saveCart();

    // Effet visuel du bouton
    if (btn) {
        const originalText = btn.textContent;
        btn.textContent = "✅ Ajouté !";
        btn.style.background = "#28a745";
        setTimeout(() => {
            btn.textContent = originalText;
            btn.style.background = "";
        }, 1500);
    }
}

// ======================================================
// =================== MODIFICATION ====================
// ======================================================

function updateQuantity(name, change) {
    const item = cartItems.find(i => i.name === name);
    if (item) {
        item.quantity = Math.max(0, item.quantity + change);
        if (item.quantity === 0)
            cartItems = cartItems.filter(i => i.name !== name);
        saveCart();
    }
}

function setQuantity(name, value) {
    const item = cartItems.find(i => i.name === name);
    if (item) {
        item.quantity = Math.max(1, parseInt(value) || 1);
        saveCart();
    }
}

// ======================================================
// =================== RENDU DU PANIER =================
// ======================================================

function renderCart(containerId = "cartContent") {
    const container = document.getElementById(containerId);
    if (!container) return;

    if (cartItems.length === 0) {
        container.innerHTML = `
      <div class="empty-cart">
        <div class="empty-cart-icon">📚</div>
        <p>Votre panier est vide</p>
        <p style="font-size: 14px; margin-top: 8px;">Découvrez nos mangas !</p>
      </div>`;
        return;
    }

    const subtotal = cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0);
    const deliveryFee = subtotal > 35 ? 0 : 4.99;
    const total = subtotal + deliveryFee;

    container.innerHTML = `
    ${cartItems.map(item => `
      <div class="cart-item">
        <img src="${item.img}" alt="${item.name}" class="cart-img">
        <div class="item-details">
          <div class="item-name">${item.name}</div>
          <div class="quantity-controls">
            <button class="qty-btn" onclick="updateQuantity('${item.name}', -1)">−</button>
            <input type="number" class="qty-input" value="${item.quantity}" min="1"
                   onchange="setQuantity('${item.name}', this.value)">
            <button class="qty-btn" onclick="updateQuantity('${item.name}', 1)">+</button>
          </div>
        </div>
        <div class="item-price">${(item.price * item.quantity).toFixed(2)}€</div>
      </div>
    `).join('')}
    <div class="total-section">
      <div class="total-line"><span>Sous-total :</span><span>${subtotal.toFixed(2)}€</span></div>
      <div class="total-line"><span>Livraison :</span><span>${deliveryFee > 0 ? deliveryFee.toFixed(2) + "€" : "Gratuit"}</span></div>
      <div class="total-line final"><span>Total :</span><span>${total.toFixed(2)}€</span></div>
    </div>
  `;
}

// ======================================================
// =================== POPUP ===========================
// ======================================================

function openCartPopup() {
    document.body.style.overflow = "hidden";
    document.getElementById("cartPopup")?.classList.add("active");
    document.getElementById("cartOverlay")?.classList.add("active");
    renderCart("cartContent");
}

function closeCartPopup() {
    document.body.style.overflow = "";
    document.getElementById("cartPopup")?.classList.remove("active");
    document.getElementById("cartOverlay")?.classList.remove("active");
}

// ======================================================
// =================== COMMANDER ========================
// ======================================================

function quickCheckout() {
    alert("Merci pour votre commande !");
    cartItems = [];
    saveCart();
    closeCartPopup();
}

// ======================================================
// =================== INITIALISATION ===================
// ======================================================

document.addEventListener("DOMContentLoaded", () => {
    // Boutons "Ajouter au panier"
    document.querySelectorAll(".add-to-cart-btn").forEach(btn => {
        btn.addEventListener("click", () => {
            const name = btn.dataset.title;
            const price = parseFloat(btn.dataset.price);
            const img = btn.dataset.img;
            addToCart(name, price, img, btn);
        });
    });

    // Affichage initial
    renderCart("cartContent");
    renderCart("cartPageContent");
    updateCartCount();
});

// ======================================================
// ✅ SYNCHRONISATION ENTRE ONGLET ET PAGES ==============
// ======================================================

// 🔁 Si une autre page modifie localStorage → mise à jour auto
window.addEventListener("storage", () => {
    cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
    renderCart("cartContent");
    renderCart("cartPageContent");
    updateCartCount();
});







// ✅ J’applique sur les deux formulaires
checkEmails("connexionForm", "email", "confirmEmail", "emailError");
checkEmails("contact-form", "email2", "confirmEmail2", "emailError2");

