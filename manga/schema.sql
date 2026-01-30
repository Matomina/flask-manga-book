DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS orders_articles;
DROP TABLE IF EXISTS contact;

CREATE TABLE user (
  id INT PRIMARY KEY AUTOINCREMENT,
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
  id INT PRIMARY KEY AUTOINCREMENT,
  users_id INT NOT NULL,
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
  id INT PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(30) NOT NULL,
  genres VARCHAR(15) NOT NULL CHECK (genres IN ('manga', 'figurine', 'textile','vaiselle', 'goodies')),
  volume INT,
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
  id INT PRIMARY KEY AUTOINCREMENT,
  orders_id INT NOT NULL,
  articles_id INT NOT NULL,
  
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

CREATE TABLE contact (
  id INT PRIMARY KEY AUTOINCREMENT,
  users_id INT NOT NULL,
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
