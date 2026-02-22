// ======================================================
// ============ OUTILS GÉNÉRIQUES =======================
// ======================================================

/*
  Fonction utilitaire générique
  Objectif :
  - Ajouter un écouteur d’événement uniquement si l’élément existe
  - Éviter les erreurs JavaScript de type "cannot read property addEventListener of null"
*/
function onEvent(element, event, callback) {
  if (element) {
    element.addEventListener(event, callback);
  }
}

/*
  Fonction générique de scroll horizontal
  Utilisée pour :
  - carrousels
  - listes de cartes
  - grilles scrollables

  wrapperSelector  : conteneur global
  containerSelector: élément qui défile horizontalement
*/
function initScroll(wrapperSelector, containerSelector) {
  document.querySelectorAll(wrapperSelector).forEach((wrapper) => {
    const container = wrapper.querySelector(containerSelector);
    const btnLeft = wrapper.querySelector(".scroll-btn.left");
    const btnRight = wrapper.querySelector(".scroll-btn.right");

    // Si le conteneur n’existe pas, on ne fait rien
    if (!container) return;

    // Scroll vers la gauche
    onEvent(btnLeft, "click", () => {
      container.scrollBy({ left: -300, behavior: "smooth" });
    });

    // Scroll vers la droite
    onEvent(btnRight, "click", () => {
      container.scrollBy({ left: 300, behavior: "smooth" });
    });
  });
}

// ======================================================
// ============ SCROLL HORIZONTAL =======================
// ======================================================

// Initialisation des différents scrolls du site
initScroll(".scroll-container", ".card-list");
initScroll(".scroll-wrapper", ".scroll-list");
initScroll(".planning-grid-wrapper", ".planning-grid");
initScroll(".no-fixed-day-wrapper", ".card-row");

// ======================================================
// ============ MENU BURGER MOBILE =====================
// ======================================================

document.addEventListener("DOMContentLoaded", () => {
  const burgerMenu = document.querySelector(".burger-menu");
  const burgerIcon = document.getElementById("burger-icon");
  const mobileNav = document.querySelector(".mobile-nav");

  if (!burgerMenu || !burgerIcon || !mobileNav) return;

  burgerMenu.addEventListener("click", () => {
    burgerIcon.classList.toggle("open");
    mobileNav.classList.toggle("active");
    document.querySelector(".site-header")?.classList.toggle("menu-open");

    document.body.classList.toggle(
      "no-scroll",
      mobileNav.classList.contains("active")
    );
  });

  mobileNav.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      burgerIcon.classList.remove("open");
      mobileNav.classList.remove("active");
      document.body.classList.remove("no-scroll");
    });
  });

  document.addEventListener("click", (event) => {
    if (
      !burgerMenu.contains(event.target) &&
      !mobileNav.contains(event.target) &&
      mobileNav.classList.contains("active")
    ) {
      burgerIcon.classList.remove("open");
      mobileNav.classList.remove("active");
      document.body.classList.remove("no-scroll");
    }
  });
});


// ======================================================
// =============== BOUTON "HAUT DE PAGE" ================
// ======================================================

document.addEventListener("DOMContentLoaded", () => {
  const scrollTopBtn = document.getElementById("scrollTopBtn");
  if (!scrollTopBtn) return;

  /*
    Affiche le bouton uniquement
    lorsque l’utilisateur a scrollé suffisamment
  */
  window.addEventListener("scroll", () => {
    scrollTopBtn.classList.toggle("active", window.scrollY > 300);
  });

  /*
    Scroll fluide vers le haut de la page
  */
  scrollTopBtn.addEventListener("click", () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  });
});

// =====================================================
// =================== FORMULAIRES =====================
// =====================================================

document.addEventListener("DOMContentLoaded", () => {
  // Boutons des onglets (connexion / inscription)
  const tabButtons = document.querySelectorAll(
    ".tab-btn-inscription, .tab-btn-connexion"
  );

  // Conteneurs des formulaires
  const formBoxes = document.querySelectorAll(".form-box");

  /*
    Gestion du système d’onglets :
    - Un seul onglet actif à la fois
    - Un seul formulaire visible à la fois
  */
  tabButtons.forEach((button) => {
    button.addEventListener("click", () => {
      tabButtons.forEach((btn) => btn.classList.remove("active"));
      formBoxes.forEach((form) => form.classList.remove("active"));

      button.classList.add("active");

      const target = button.getAttribute("data-tab");
      document.getElementById(`form-${target}`).classList.add("active");
    });
  });
});

// =====================================================
// =================== PANIER GLOBAL ===================
// =====================================================

/*
  Chargement initial du panier
  - localStorage → persistance des données
  - fallback tableau vide si aucune donnée
*/
let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];

/*
  Sauvegarde du panier
  + synchronisation de tous les affichages
*/
function saveCart() {
  localStorage.setItem("cartItems", JSON.stringify(cartItems));
  renderCart("cartContent");
  renderCart("cartPageContent");
  updateCartCount();
}

// ======================================================
// =================== COMPTEUR PANIER =================
// ======================================================

function updateCartCount() {
  // Calcul du nombre total d’articles
  const count = cartItems.reduce((sum, item) => sum + item.quantity, 0);
  const countEl = document.getElementById("floatingCartCount");

  if (!countEl) return;

  countEl.textContent = count;
  countEl.style.display = count > 0 ? "flex" : "none";
}

// ======================================================
// =================== AJOUT AU PANIER =================
// ======================================================

function addToCart(name, price, img, btn = null) {
  const existingItem = cartItems.find((item) => item.name === name);

  if (existingItem) {
    existingItem.quantity++;
  } else {
    cartItems.push({ name, price, quantity: 1, img });
  }

  saveCart();

  /*    Feedback visuel utilisateur
    → confirmation immédiate de l’action */
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
// =================== GESTION QUANTITÉS ===============
// ======================================================

function updateQuantity(name, change) {
  const item = cartItems.find((item) => item.name === name);
  if (!item) return;

  item.quantity = Math.max(0, item.quantity + change);

  // Suppression de l’article si quantité = 0
  if (item.quantity === 0) {
    cartItems = cartItems.filter((item) => item.name !== name);
  }

  saveCart();
}

function setQuantity(name, value) {
  const item = cartItems.find((item) => item.name === name);
  if (!item) return;

  item.quantity = Math.max(1, parseInt(value) || 1);
  saveCart();
}

// ======================================================
// =================== AFFICHAGE PANIER ================
// ======================================================

function renderCart(containerId = "cartContent") {
  const container = document.getElementById(containerId);
  if (!container) return;

  // Cas panier vide
  if (cartItems.length === 0) {
    container.innerHTML = `
      <div class="empty-cart">
        <div class="empty-cart-icon">📚</div>
        <p>Votre panier est vide</p>
        <p style="font-size:14px;margin-top:8px;">Découvrez nos mangas !</p>
      </div>`;
    return;
  }

  // Calculs financiers
  const subtotal = cartItems.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  const deliveryFee = subtotal > 35 ? 0 : 4.99;
  const total = subtotal + deliveryFee;

  // Génération HTML dynamique
  container.innerHTML = `
    ${cartItems.map(item => `
      <div class="cart-item">
        <img src="${item.img}" alt="${item.name}">
        <div>
          <strong>${item.name}</strong>
          <div>
            <button onclick="updateQuantity('${item.name}', -1)">−</button>
            <input type="number" value="${item.quantity}" min="1"
              onchange="setQuantity('${item.name}', this.value)">
            <button onclick="updateQuantity('${item.name}', 1)">+</button>
          </div>
        </div>
        <span>${(item.price * item.quantity).toFixed(2)}€</span>
      </div>
    `).join("")}

    <div class="total">
      <p>Sous-total : ${subtotal.toFixed(2)}€</p>
      <p>Livraison : ${deliveryFee ? deliveryFee + "€" : "Gratuit"}</p>
      <p><strong>Total : ${total.toFixed(2)}€</strong></p>
    </div>
  `;
}

// ======================================================
// =================== POPUP PANIER ====================
// ======================================================

function openCartPopup() {
  document.body.classList.add("no-scroll");
  document.getElementById("cartPopup")?.classList.add("active");
  document.getElementById("cartOverlay")?.classList.add("active");
  renderCart("cartContent");
}

function closeCartPopup() {
  document.body.classList.remove("no-scroll");
  document.getElementById("cartPopup")?.classList.remove("active");
  document.getElementById("cartOverlay")?.classList.remove("active");
}

// ======================================================
// =================== COMMANDE ========================
// ======================================================

function quickCheckout() {
  alert("Merci pour votre commande !");
  cartItems = [];
  saveCart();
  closeCartPopup();
}

// ======================================================
// =================== INITIALISATION ==================
// ======================================================

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".add-to-cart-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      addToCart(
        btn.dataset.title,
        parseFloat(btn.dataset.price),
        btn.dataset.img,
        btn
      );
    });
  });

  renderCart("cartContent");
  renderCart("cartPageContent");
  updateCartCount();
});

// ======================================================
// ========== SYNCHRONISATION MULTI-ONGLETS =============
// ======================================================

window.addEventListener("storage", () => {
  cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
  renderCart("cartContent");
  renderCart("cartPageContent");
  updateCartCount();
});


// ======================================================
// =================== FAQ INTERACTIVE ==================
// ======================================================

document.addEventListener("DOMContentLoaded", () => {
  const questions = document.querySelectorAll(".faq-question");

  // Sécurité : si aucune FAQ sur la page, on ne fait rien
  if (!questions.length) return;

  questions.forEach((question) => {
    question.addEventListener("click", () => {
      const answer = question.nextElementSibling;

      // Vérification de sécurité
      if (!answer || !answer.classList.contains("faq-answer")) return;

      // Toggle de la classe active
      answer.classList.toggle("active");
    });
  });
});


// ======================================================
// ============ VALIDATION EMAIL (FORMULAIRES) ==========
// ======================================================

function checkEmails(formId, emailId, confirmEmailId, errorId) {
  const form = document.getElementById(formId);
  const email = document.getElementById(emailId);
  const confirmEmail = document.getElementById(confirmEmailId);
  const error = document.getElementById(errorId);

  // Sécurité : si un élément manque, on arrête
  if (!form || !email || !confirmEmail || !error) {
    console.warn("Éléments manquants pour la validation email :", formId);
    return;
  }

  // Vérification lors de la soumission du formulaire
  form.addEventListener("submit", function (e) {
    if (email.value.trim() !== confirmEmail.value.trim()) {
      e.preventDefault(); // bloque l'envoi
      error.textContent = "Les adresses email ne correspondent pas.";
      error.style.display = "block";
      confirmEmail.classList.add("error");
    } else {
      error.textContent = "";
      error.style.display = "none";
      confirmEmail.classList.remove("error");
    }
  });

  // Vérification en temps réel
  confirmEmail.addEventListener("input", function () {
    if (email.value.trim() === confirmEmail.value.trim()) {
      error.textContent = "";
      error.style.display = "none";
      confirmEmail.classList.remove("error");
    }
  });
}

// ======================================================
// =========== GESTION DROPDOWN-TOGGLE ==================
// ======================================================

document.addEventListener("DOMContentLoaded", () => {

  const dropdowns = document.querySelectorAll(".dropdown");

  dropdowns.forEach(dropdown => {

    const toggle = dropdown.querySelector(".dropdown-toggle");

    if (!toggle) return;

    toggle.addEventListener("click", (e) => {
      e.stopPropagation();
      dropdown.classList.toggle("active");
    });

  });

  document.addEventListener("click", () => {
    dropdowns.forEach(d => d.classList.remove("active"));
  });

});

// ======================================================
// ============ APPELS DE LA FONCTION ===================
// ======================================================

checkEmails("connexionForm", "email", "confirmEmail", "emailError");
checkEmails("contact-form", "email2", "confirmEmail2", "emailError2");

