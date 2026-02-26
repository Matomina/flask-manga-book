/* ======================================================
   MANGABOOK – MAIN SCRIPT
   Architecture :
   - Outils
   - UI
   - Panier
   - Favoris
   - Initialisation unique
====================================================== */


/* ======================================================
   OUTILS GÉNÉRIQUES
====================================================== */

function onEvent(element, event, callback) {
  if (element) element.addEventListener(event, callback);
}

function initScroll(wrapperSelector, containerSelector) {
  document.querySelectorAll(wrapperSelector).forEach(wrapper => {
    const container = wrapper.querySelector(containerSelector);
    const btnLeft = wrapper.querySelector(".scroll-btn.left");
    const btnRight = wrapper.querySelector(".scroll-btn.right");
    if (!container) return;

    onEvent(btnLeft, "click", () =>
      container.scrollBy({ left: -300, behavior: "smooth" })
    );

    onEvent(btnRight, "click", () =>
      container.scrollBy({ left: 300, behavior: "smooth" })
    );
  });
}


/* ======================================================
   MENU BURGER
====================================================== */

function initBurgerMenu() {
  const burgerMenu = document.querySelector(".burger-menu");
  const burgerIcon = document.getElementById("burger-icon");
  const mobileNav = document.querySelector(".mobile-nav");
  if (!burgerMenu || !burgerIcon || !mobileNav) return;

  burgerMenu.addEventListener("click", () => {
    burgerIcon.classList.toggle("open");
    mobileNav.classList.toggle("active");
    document.body.classList.toggle("no-scroll");
  });

  mobileNav.querySelectorAll("a").forEach(link => {
    link.addEventListener("click", () => {
      burgerIcon.classList.remove("open");
      mobileNav.classList.remove("active");
      document.body.classList.remove("no-scroll");
    });
  });
}


/* ======================================================
   SCROLL TOP
====================================================== */

function initScrollTop() {
  const btn = document.getElementById("scrollTopBtn");
  if (!btn) return;

  window.addEventListener("scroll", () => {
    btn.classList.toggle("active", window.scrollY > 300);
  });

  btn.addEventListener("click", () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  });
}


/* ======================================================
   FORMULAIRES (ONGLETS + HASH)
====================================================== */

function initForms() {
  const tabButtons = document.querySelectorAll(
    ".tab-btn-inscription, .tab-btn-connexion"
  );
  const formBoxes = document.querySelectorAll(".form-box");
  if (!tabButtons.length || !formBoxes.length) return;

  function activateTab(name) {
    tabButtons.forEach(btn => btn.classList.remove("active"));
    formBoxes.forEach(box => box.classList.remove("active"));

    document.querySelector(`.tab-btn-${name}`)?.classList.add("active");
    const target = document.getElementById(`form-${name}`);
    target?.classList.add("active");
    return target;
  }

  tabButtons.forEach(btn => {
    btn.addEventListener("click", () => {
      activateTab(btn.dataset.tab);
    });
  });

  const params = new URLSearchParams(window.location.search);
  const tabParam = params.get("tab");
  const hash = window.location.hash;

  let tabToActivate = null;

  if (tabParam === "connexion" || tabParam === "inscription") {
    tabToActivate = tabParam;
  }

  if (hash === "#form-inscription") {
    tabToActivate = "inscription";
  }

  if (tabToActivate) {
    activateTab(tabToActivate);
    document.getElementById("auth-section")
      ?.scrollIntoView({ behavior: "smooth", block: "start" });
  }
}


/* ======================================================
   PANIER
====================================================== */

let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];

function saveCart() {
  localStorage.setItem("cartItems", JSON.stringify(cartItems));
  renderCart("cartContent");
  renderCart("cartPageContent");
  updateCartCount();
}

function updateCartCount() {
  const count = cartItems.reduce((sum, item) => sum + item.quantity, 0);
  const badge = document.getElementById("floatingCartCount");
  if (!badge) return;
  badge.textContent = count;
  badge.style.display = count > 0 ? "flex" : "none";
}

function addToCart(name, price, img, btn = null) {
  const existing = cartItems.find(i => i.name === name);
  if (existing) existing.quantity++;
  else cartItems.push({ name, price, quantity: 1, img });

  saveCart();

  if (btn) {
    const original = btn.textContent;
    btn.textContent = "Ajouté";
    setTimeout(() => (btn.textContent = original), 1500);
  }
}

function updateQuantity(name, change) {
  const item = cartItems.find(i => i.name === name);
  if (!item) return;
  item.quantity = Math.max(0, item.quantity + change);
  if (item.quantity === 0)
    cartItems = cartItems.filter(i => i.name !== name);
  saveCart();
}

function renderCart(containerId) {
  const container = document.getElementById(containerId);
  if (!container) return;

  if (!cartItems.length) {
    container.innerHTML = `
      <div class="empty-cart">
        <p>Votre panier est vide</p>
      </div>
    `;
    return;
  }

  const subtotal = cartItems.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  container.innerHTML = `
    ${cartItems.map(item => `
      <div class="cart-item">
        <img src="${item.img}" alt="${item.name}">
        <div class="cart-item-info">
          <strong>${item.name}</strong>
          <div class="cart-qty">
            <button onclick="updateQuantity('${item.name}', -1)">−</button>
            <span>${item.quantity}</span>
            <button onclick="updateQuantity('${item.name}', 1)">+</button>
          </div>
        </div>
        <span class="cart-price">
          ${(item.price * item.quantity).toFixed(2)}€
        </span>
      </div>
    `).join("")}

    <div class="cart-total">
      <strong>Total : ${subtotal.toFixed(2)}€</strong>
    </div>
  `;
}

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


/* ======================================================
   FAVORIS
====================================================== */

function updateFavoriteCounter(change) {
  const badge = document.getElementById("favCountDesktop");
  if (!badge) return;
  let count = parseInt(badge.textContent) || 0;
  count += change;
  if (count > 0) badge.textContent = count;
  else badge.remove();
}

async function toggleFavorite(articleId, button) {
  try {
    const response = await fetch(`/toggle-favorite/${articleId}`, {
      method: "POST",
      headers: { "X-Requested-With": "XMLHttpRequest" }
    });

    if (response.status === 401) {
      window.location.href = "/profil#form-inscription";
      return;
    }

    const data = await response.json();

    if (data.status === "added") {
      button.classList.add("is-favorite");
      updateFavoriteCounter(1);
    }

    if (data.status === "removed") {
      button.classList.remove("is-favorite");
      updateFavoriteCounter(-1);
    }

  } catch (err) {
    console.error("Erreur favoris :", err);
  }
}

function initFavorites() {
  document.querySelectorAll(".favorite-btn").forEach(btn => {
    btn.addEventListener("click", e => {
      e.preventDefault();
      e.stopPropagation();
      toggleFavorite(btn.dataset.articleId, btn);
    });
  });
}


/* ======================================================
   VALIDATION COMMANDE
====================================================== */

function quickCheckout() {

  if (!cartItems.length) {
    alert("Votre panier est vide.");
    return;
  }

  alert("Merci pour votre commande !");

  cartItems = [];
  localStorage.removeItem("cartItems");

  renderCart("cartContent");
  renderCart("cartPageContent");
  updateCartCount();

  closeCartPopup();
}


/* ======================================================
   DROPDOWN UTILISATEUR
====================================================== */

function initDropdowns() {

  const dropdowns = document.querySelectorAll(".dropdown");
  if (!dropdowns.length) return;

  dropdowns.forEach(dropdown => {

    const toggle = dropdown.querySelector(".dropdown-toggle");
    if (!toggle) return;

    toggle.addEventListener("click", (e) => {
      e.stopPropagation();
      dropdown.classList.toggle("active");
    });

  });

  // Ferme les dropdowns si on clique ailleurs
  document.addEventListener("click", () => {
    dropdowns.forEach(d => d.classList.remove("active"));
  });
}


/* ======================================================
   INITIALISATION UNIQUE
====================================================== */

document.addEventListener("DOMContentLoaded", () => {

  initScroll(".scroll-container", ".card-list");
  initScroll(".scroll-wrapper", ".scroll-list");
  initScroll(".planning-grid-wrapper", ".planning-grid");
  initScroll(".no-fixed-day-wrapper", ".card-row");

  initBurgerMenu();
  initScrollTop();
  initForms();
  initFavorites();
  initDropdowns();

  document.querySelectorAll(".add-to-cart-btn").forEach(btn => {
    btn.addEventListener("click", () => {
      addToCart(
        btn.dataset.title,
        parseFloat(btn.dataset.price),
        btn.dataset.img,
        btn
      );
    });
  });

  document.getElementById("floatingCartBtn")
    ?.addEventListener("click", openCartPopup);

  document.getElementById("cartOverlay")
    ?.addEventListener("click", closeCartPopup);

  renderCart("cartContent");
  renderCart("cartPageContent");
  updateCartCount();

});