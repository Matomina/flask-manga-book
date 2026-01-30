DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS orders_articles;
DROP TABLE IF EXISTS home;
DROP TABLE IF EXISTS mangas;
DROP TABLE IF EXISTS contact;

CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  email VARCHAR(50) NOT NULL UNIQUE,  
  password VARCHAR(250) NOT NULL,
  phone VARCHAR(15) NOT NULL UNIQUE,
  address VARCHAR(50) NOT NULL,
  city VARCHAR(30) NOT NULL,
  role VARCHAR(10) NOT NULL CHECK (role IN ('user', 'admin'))
);

INSERT INTO user (first_name, last_name, email, password, phone, address, city, role) VALUES 
('Mato', 'NGUAYILA', 'matomina.nguayila@gmail.com', 'Orly94', '07-54-69-32-58', '1 rue du clos dion', 'Montereau-Fault-Yonne', 'admin'),
('Cynthia', 'DAUVERNE', 'cynthia.dauverne@gmail.com', 'Monterau77', '07-55-69-32-58', '1 rue du clos dion', 'Montereau-Fault-Yonne', 'user'),
('Hakim', 'BOUDERE', 'hakim.boudere@gmail.com', 'Paris75', '07-56-69-32-58', '1 rue de la paix', 'Paris', 'user'),
('Billal', 'ZEBIR', 'billal.zerbir@gmail.com', 'Pantin93', '07-57-69-32-58', '1 rue de courcelle', 'Pantin', 'user'),
('Zeyna', 'SIDIBE', 'zeyna.sidibe@gmail.com', 'Cachan94', '07-58-69-32-58', '1 rue pasteur', 'Cachan', 'user'),
('Alfred', 'Macdy', 'alfred.macdy@gmail.com', 'Evry91', '07-59-69-32-58', '1 allée de la brume', 'Evry', 'user'),
('Moussa', 'DIOP', 'moussa.diop@gmail.com', 'Coulommier77', '07-60-69-32-58', '1 rue des champs', 'Coulommiers', 'user');

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  users_id INTEGER NOT NULL,
  total_amount FLOAT,  
  order_date DATE NOT NULL,
  status VARCHAR(15) NOT NULL CHECK (status IN ('en attente', 'payée', 'expédiée','livrée', 'annulée')),

  FOREIGN KEY (users_id) REFERENCES user(id)
);

INSERT INTO orders (users_id, total_amount, order_date, status) VALUES 
(2, 356, '2025-05-10', 'en attente'),
(2, 250, '2025-05-11', 'payée'),
(3, 425, '2025-05-12', 'expédiée'),
(4, 99, '2025-05-13', 'livrée'),
(5, 199, '2025-05-14', 'annulée');

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE articles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(30) NOT NULL,
  genres VARCHAR(15) NOT NULL CHECK (genres IN ('manga', 'figurine', 'textile','vaiselle', 'goodies')),
  volume INTEGER,
  expected_date DATE,  
  price FLOAT NOT NULL
);

INSERT INTO articles (name, genres, volume, expected_date, price) VALUES 
('One piece', 'manga', 15, '2025-05-15', 15.50),
('Naruto', 'manga', 64, '2025-05-20', 15.50),
('Lampe Kakashi', 'goodies', NULL, '2025-05-25', 150);

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE orders_articles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  orders_id INTEGER NOT NULL,
  articles_id INTEGER NOT NULL,
  
  FOREIGN KEY (orders_id) REFERENCES orders(id),
  FOREIGN KEY (articles_id) REFERENCES articles(id)
);

INSERT INTO orders_articles( orders_id, articles_id) VALUES
(1, 2),
(3, 3),
(4, 2),
(5, 1);

/* ======================================================================================= */
/* ======================================================================================= */

/* Base : products (mangas + goodies) */

CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author TEXT,
    price REAL NOT NULL,
    image TEXT,
    category TEXT CHECK (category IN ('Historiques', 'Classiques', 'Pépites', 'Goodies')),
    description TEXT
);

/* Tous les items présents dans mon HTML */

INSERT INTO products (title, author, price, image, category) VALUES
('Black Clover - Tome 1', NULL, 7.90, 'Black-Clover-Tome.jpeg', 'Historiques'),
('Demon Slayer Vol. 1', NULL, 12.00, 'Demon-Slayer-Tome.jpeg', 'Historiques'),
('One Piece - Tome 1', NULL, 7.90, 'One-Piece-Tome.jpeg', 'Historiques'),
('Naruto Shippuden - Tome 1', NULL, 7.90, 'Naruto-Shippuden.jpeg', 'Historiques'),
('Dandadan - Tome 1', NULL, 7.90, 'Dandadan-Tome.jpeg', 'Historiques'),
('Solo Leveling - Tome 1', NULL, 8.50, 'Solo-Leveling-Tome.jpeg', 'Historiques'),
('Jujutsu Kaisen - Tome 1', NULL, 7.90, 'Jujutsu-Kaisen-Tome.jpeg', 'Historiques'),
('Death Note - Tome 1', NULL, 6.90, 'Death-Note-Tome.jpeg', 'Historiques'),
('Edens Zero - Tome 1', NULL, 7.90, 'Edens-Zero-Tome.jpeg', 'Historiques'),
('One Punch Man - Tome 1', NULL, 7.90, 'One-Punch-Man-Tome.jpeg', 'Historiques'),
('Sakamoto Days - Tome 1', NULL, 7.90, 'Sakamoto-Days-Tome.jpeg', 'Historiques'),
('Full Metal Alchemist - Tome 1', NULL, 7.90, 'Full-Metal-Tome.jpeg', 'Historiques'),

-- Classiques
('Dragon Ball - Tome 1', NULL, 6.90, 'Dragon-Ball-Tome.jpeg', 'Classiques'),
('Dragon Ball Z - Tome 1', NULL, 7.10, 'Dragon-Ball-Z-Tome.jpeg', 'Classiques'),
('One Piece - Tome 1', NULL, 6.90, 'One-Piece-Tome.jpeg', 'Classiques'),
('Naruto - Tome 1', NULL, 7.50, 'Naruto-Tome.jpeg', 'Classiques'),
('Naruto Shippuden - Tome 1', NULL, 7.90, 'Naruto-Shippuden.jpeg', 'Classiques'),
('Bleach - Tome 1', NULL, 7.30, 'Bleach-Tome.jpeg', 'Classiques'),
('Pokémon - Tome 1', NULL, 6.50, 'Pokemon-Tome.jpeg', 'Classiques'),
('Sailor Moon - Tome 1', NULL, 8.00, 'Sailor-Moon-Tome.jpeg', 'Classiques'),
('Ranma ½ - Tome 1', NULL, 7.40, 'Ranma-1-2-Tome.jpeg', 'Classiques'),
('Détective Conan - Tome 1', NULL, 7.60, 'Détective-Conan-Tome.jpeg', 'Classiques'),
('Yu-Gi-Oh - Tome 1', NULL, 7.00, 'Yu-Gi-Oh-Tome.jpeg', 'Classiques'),
('Great Teacher Onizuka - Tome 1', NULL, 8.20, 'Great-Teacger-Onizuka-Tome.jpeg', 'Classiques'),

-- Pépites
('Hajime No Ippo - Tome 1', NULL, 8.90, 'Hajime-No-Ippo-Tome.jpeg', 'Pépites'),
('Saint Seiya - Tome 1', NULL, 7.20, 'Saint-Seya-Tome.jpeg', 'Pépites'),
('Ken le Survivant - Tome 1', NULL, 8.50, 'Ken-Le-Survivant-Tome.jpeg', 'Pépites'),
('City Hunter - Tome 1', NULL, 7.60, 'City-Hunter-Tome.jpeg', 'Pépites'),
('Gundam Wing - Tome 1', NULL, 8.00, 'Gundam-Wing-Tome.jpeg', 'Pépites'),
('Fairy Tail - Tome 1', NULL, 7.50, 'Fairy-Tail-Tome.jpeg', 'Pépites'),
('Afro Samouraï - Tome 1', NULL, 9.10, 'Afro-Samourai-Tome.jpeg', 'Pépites'),
('99 Renforced Wooden Stick', NULL, 10.00, '99-Renforced-Wooden-Stick.jpeg', 'Pépites'),
('Moi Slime - Tome 1', NULL, 7.80, 'Moi-Slime-Tome.jpeg', 'Pépites'),

-- Goodies (images et items visibles dans ta section Goodies)
('Figurine Aokiji', NULL, 25.00, 'Gif-figurine-Aokiji.gif', 'Goodies'),
('Mug Dragon Ball Z', NULL, 12.00, 'Gif-Mug-Bdz.webp', 'Goodies'),
('Lot de figurine', NULL, 180.00, 'Gif-Figurine.webp', 'Goodies'),
('Mug Sasuke', NULL, 12.50, 'Gif-Mug-Sasuke.webp', 'Goodies'),
('Figurine Alma Feri', NULL, 20.00, 'Gif-Figurine2.gif', 'Goodies'),
('Mug Yu-Gi-Oh', NULL, 14.00, 'Mug-YuGiOh-thermo-actif.gif', 'Goodies'),
('Figurine Terrece', NULL, 22.00, 'Gif-Figurine-3.webp', 'Goodies'),
('Produit Naruto (banner)', NULL, 0.00, 'Produit-Naruto.jpeg', 'Goodies'),
('Produit Jujutsu-Kaisen (banner)', NULL, 0.00, 'Produit-Jujutsu-Kaisen.jpeg', 'Goodies'),
('Produit One Piece (banner)', NULL, 0.00, 'Produit-One-Piece.jpeg', 'Goodies'),
('Produit Demon Slayer (banner)', NULL, 0.00, 'Produit-Demon-Slayer.jpeg', 'Goodies'),
('Produit DBZ (banner)', NULL, 0.00, 'Produit-DBZ.jpeg', 'Goodies');


/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE contact (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  users_id INTEGER NOT NULL,
  sujet VARCHAR(20) NOT NULL,  
  message TEXT NOT NULL,
  message_date DATE NOT NULL,
  status VARCHAR(15) NOT NULL CHECK (status IN ('en attente', 'lu', 'repondu')),

  FOREIGN KEY (users_id) REFERENCES user(id)
);

INSERT INTO contact (users_id, sujet, message, message_date, status) VALUES 
(2, 'Commande', 'Je n''ai toujours pas reçu ma commande', '2025-05-10', 'repondu'),
(3, 'Commande', 'Ma commande est détérioré. Que faire', '2025-05-10', 'repondu'),
(4, 'Commande', 'Trés satisfait arrivé rapidement', '2025-05-10', 'lu'),
(5, 'Commande', 'Super j''ai reçu ma commande', '2025-05-10', 'lu'),
(6, 'Commande', 'Trés bon site merci', '2025-05-10', 'en attente'),
(7, 'Commande', 'Je n''ai toujours pas reçu ma commande', '2025-05-10', 'en attente');

/* ======================================================================================= */
/* ======================================================================================= */
