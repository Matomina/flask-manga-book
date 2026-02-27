PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS topics;
DROP TABLE IF EXISTS contact;
DROP TABLE IF EXISTS orders_articles;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS history;
DROP TABLE IF EXISTS detail_articles_public;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS user;

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  phone TEXT UNIQUE,
  address TEXT,
  city TEXT,
  role TEXT NOT NULL CHECK (role IN ('user', 'admin')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
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

CREATE TABLE articles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  genres TEXT NOT NULL CHECK (genres IN ('manga', 'figurine', 'textiles','vaisselle', 'goodies')),
  universe TEXT CHECK (
    universe IS NULL OR
    universe IN (
      'naruto',
      'jujutsu_kaisen',
      'one_piece',
      'demon_slayer',
      'dragon_ball'
    )
  ),
  image TEXT NOT NULL,
  price REAL NOT NULL,
  stock INTEGER NOT NULL DEFAULT 10,
  release_day TEXT CHECK (
    release_day IS NULL OR
    release_day IN (
      'Lundi','Mardi','Mercredi','Jeudi',
      'Vendredi','Samedi','Dimanche',
      'Sans jour fixe'
    )
),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO articles (name, genres, universe, image, price, release_day) VALUES
('Sekai Saisoku no Isekai Ryokouki','manga',NULL,'image/sekai saisoku no isekai ryokouki chapter 1.jpg',7.80,'Lundi'),
('Ordeal','manga',NULL,'image/ordeal tome.jpg',7.80,'Lundi'),
('Blue Box','manga',NULL,'image/blue box tome 1.jpg',7.80,'Lundi'),
('Nyaight of the Living Cat','manga',NULL,'image/nyaight of the living cat tome 1.jpg',7.80,'Lundi'),
('Juvenile Detention Center','manga',NULL,'image/juvenile detention center tome 1.jpg',7.80,'Lundi'),
('Maybe Meant','manga',NULL,'image/maybe meant tome 1.jpg',7.80,'Lundi'),
('Tonikaku Kuwai','manga',NULL,'image/tonikaku kuwai tome 1.jpeg',7.80,'Lundi'),
('To Your Eternity','manga',NULL,'image/to your eternity tome 1.jpeg',7.80,'Lundi'),
('Yano Kun no','manga',NULL,'image/yano kun no tome 1.jpg',7.80,'Mardi'),
('Return to Player','manga',NULL,'image/return to player tome 1.jpg',7.80,'Mardi'),
('Manager Kim','manga',NULL,'image/manager kim tome 1.jpg',7.80,'Mardi'),
('Hero Without a Class','manga',NULL,'image/hero without a class tome 1.jpg',7.80,'Mardi'),
('Let''s Play','manga',NULL,'image/let''s play tome 1.jpg',7.80,'Mardi'),
('Afterlife Inn Cooking','manga',NULL,'image/afterlife inn cooking tome 1.jpg',7.80,'Mardi'),
('Rent a Girl','manga',NULL,'image/rent a girl tome 1.jpg',7.80,'Mardi'),
('A Couple of Cuckoos','manga',NULL,'image/a couple of cuckoos tome 1.jpg',7.80,'Mardi'),
('99 Reinforced Wood Stick','manga',NULL,'image/99 reinforced wood stick tome 1.jpeg',7.80,'Mercredi'),
('Baek','manga',NULL,'image/baek tome 1.jpeg',7.80,'Mercredi'),
('Surviving the Game As','manga',NULL,'image/Surviving the game as tome 1.jpeg',7.80,'Mercredi'),
('The Druid of Seoul Station','manga',NULL,'image/the druid of seoul station tome 1.jpeg',7.80,'Mercredi'),
('The Mafia Nanny','manga',NULL,'image/the mafia nanny tome 1.jpeg',7.80,'Mercredi'),
('Umamusume Cinderella Gray','manga',NULL,'image/umamusume cinderella gray tome 1.jpeg',7.80,'Mercredi'),
('Blue Orchestra','manga',NULL,'image/blue orchestra tome 1.jpeg',7.80,'Mercredi'),
('Hero Ticket','manga',NULL,'image/hero ticket tome 1.jpeg',7.80,'Mercredi'),
('Dr. Stone','manga',NULL,'image/Dr-Stone-Tome.jpeg',7.90,'Jeudi'),
('Futari Solo Camp','manga',NULL,'image/futari solo camp tome 1.jpeg',7.80,'Jeudi'),
('Past the Monster Meat','manga',NULL,'image/past the monster meat tome 1.jpeg',7.80,'Jeudi'),
('The Rising of the Shield Hero','manga',NULL,'image/the rising of the shield hero tome 1.jpeg',7.90,'Jeudi'),
('I Was Reincarnated as the 7th Prince','manga',NULL,'image/i was reincarnated as the 7th prince tome 1.jpeg',7.80,'Jeudi'),
('Reborn as a Vending Machine','manga',NULL,'image/reborn as a vending machine tome 1.jpeg',7.80,'Jeudi'),
('Dreaming Freedom','manga',NULL,'image/dreaming freedom tome 1.jpeg',7.80,'Jeudi'),
('Dragon Raja','manga',NULL,'image/dragon raja tome 1.jpeg',7.90,'Vendredi'),
('Cat''s Eyes 2025','manga',NULL,'image/cat''s eyes 2025 tome 1.jpeg',7.80,'Vendredi'),
('Watari Kun no XX ga Houkai Sunzen','manga',NULL,'image/watari kun no xx ga houkai sunzen tome 1.jpeg',7.90,'Vendredi'),
('Tsubasa Chronicle','manga',NULL,'image/tsubasa chronicle tsubasa tome 1.jpeg',7.90,'Vendredi'),
('May I Ask for One Final Thing','manga',NULL,'image/may i ask for one final thing tome 1.jpeg',7.80,'Vendredi'),
('One Piece','manga',NULL,'image/One-Piece-Tome.jpeg',7.90,'Vendredi'),
('Study Group','manga',NULL,'image/study group tome 1.jpeg',7.80,'Vendredi'),
('Lord of Mysteries','manga',NULL,'image/lord of mysteries tome 1.jpeg',7.90,'Samedi'),
('Détective Conan','manga',NULL,'image/Détective-Conan-Tome.jpeg',7.90,'Samedi'),
('A Wild Last Boss Appeared','manga',NULL,'image/a wild last boos appeard tome 1.jpeg',7.80,'Samedi'),
('Silent Witch','manga',NULL,'image/silent witch tome 1.jpeg',7.80,'Samedi'),
('Kingdom','manga',NULL,'image/kingdom tome 1.jpeg',7.90,'Samedi'),
('My Hero Academia','manga',NULL,'image/My-Hero-Academia-Tome.jpeg',7.90,'Samedi'),
('Spy x Family','manga',NULL,'image/spy x family tome 1.jpeg',7.90,'Samedi'),
('Let This Grieving Soul Retire','manga',NULL,'image/let this grieving soul retire tome 1.jpeg',7.80,'Samedi'),
('Witch Watch','manga',NULL,'image/witch watch tome 1.jpeg',7.90,'Dimanche'),
('My Dress Up Darling','manga',NULL,'image/my dress up darling tome 1.jpeg',7.90,'Dimanche'),
('Rascal Does Not Dream of Bunny Girl Senpai','manga',NULL,'image/rascal does not dream of bunny girl senpai tome 1.jpeg',8.50,'Dimanche'),
('Gachiakuta','manga',NULL,'image/Gachiakuta-Tome.jpeg',7.80,'Dimanche'),
('Be a Princess Someday','manga',NULL,'image/be a princess someday tome 1.jpeg',7.90,'Dimanche'),
('Kikaijikake no Marie','manga',NULL,'image/kikaijikake no marie tome 1.jpeg',7.80,'Dimanche'),
('Alma Chan wa Kazoku ni Naritai','manga',NULL,'image/alma chan wa kazoku ni naritai tome 1.jpeg',7.90,'Dimanche'),
('Dad is a Hero, Mom is a Spring, I''m a','manga',NULL,'image/dad is a hero mom is a spring i''m a tome 1.jpeg',7.80,'Dimanche'),
('Chain Saw','manga',NULL,'image/Chain-Saw-Tome.jpg',7.90,'Sans jour fixe'),
('Fairy Tail 100 Years Quest','manga',NULL,'image/fairy tail 100 years quest tome 1.jpg',7.90,'Sans jour fixe'),
('Four Knights of the Apocalypse','manga',NULL,'image/four knights of the apocalypse tome 1.jpg',8.50,'Sans jour fixe'),
('Blue Lock','manga',NULL,'image/Blue Lock.jpg',7.90,'Sans jour fixe'),
('Embers','manga',NULL,'image/embers tome 1.jpg',7.80,'Sans jour fixe'),
('I''m the Max Level Newbie','manga',NULL,'image/i''m the max level newbie tome 1.jpg',8.00,'Sans jour fixe'),
('Infinite Mage','manga',NULL,'image/infinite mage tome 1.jpg',7.90,'Sans jour fixe'),
('Itchi the Witch','manga',NULL,'image/itchi the witch tome 1.jpg',7.50,'Sans jour fixe'),
('Kaoru Hana wa Rin to Saku','manga',NULL,'image/kaoru hana wa rin to saku tome 1.jpg',7.90,'Sans jour fixe'),
('Lecteur Omniscient','manga',NULL,'image/lecteur omniscient tome 1.jpg',8.00,'Sans jour fixe'),
('Nano Machine','manga',NULL,'image/nano machine tome 1.jpg',7.80,'Sans jour fixe'),
('Nebula''s Civilation','manga',NULL,'image/nebula''s civilation tome 1.jpg',8.00,'Sans jour fixe'),
('Pick Me Up','manga',NULL,'image/Pick Me Up tome.jpg',7.90,'Sans jour fixe'),
('Player','manga',NULL,'image/Player tome.jpg',7.90,'Sans jour fixe'),
('Player Who Returned 10000 Year Later','manga',NULL,'image/player who returned 10000 year later tome 1.jpg',8.50,'Sans jour fixe'),
('Reality Quest','manga',NULL,'image/reality quest tome 1.jpg',7.90,'Sans jour fixe'),
('Solo Leveling','manga',NULL,'image/Solo-Leveling-Tome.jpeg',8.50,'Sans jour fixe'),
('Wind Breaker','manga',NULL,'image/wind breaker tome 1.jpg',7.80,'Sans jour fixe'),
('The Beginning After the End','manga',NULL,'image/the beginning after the end tome 1.jpg',8.50,'Sans jour fixe'),
('Tougen Anki','manga',NULL,'image/tougen anki tome 1.jpg',7.90,'Sans jour fixe'),
('Shangri-La Frontier','manga',NULL,'image/Shangri-La-Frontier.jpeg',8.00,'Sans jour fixe'),
('Dragon Ball','manga',NULL,'image/Dragon-Ball-Tome.jpeg',6.90,NULL),
('Dragon Ball Z','manga',NULL,'image/Dragon-Ball-Z-Tome.jpeg',7.10,NULL),
('Naruto','manga',NULL,'image/Naruto-Tome.jpeg',7.50,NULL),
('Naruto Shippuden','manga',NULL,'image/Naruto-Shippuden.jpeg',7.90,NULL),
('Bleach','manga',NULL,'image/Bleach-Tome.jpeg',7.30,NULL),
('Pokémon','manga',NULL,'image/Pokemon-Tome.jpeg',6.50,NULL),
('Ranma ½','manga',NULL,'image/Ranma-1-2-Tome.jpeg',7.40,NULL),
('Yu-Gi-Oh','manga',NULL,'image/Yu-Gi-Oh-Tome.jpeg',7.00,NULL),
('Great Teacher Onizuka','manga',NULL,'image/Great-Teacger-Onizuka-Tome.jpeg',8.20,NULL),
('Death Note','manga',NULL,'image/Death-Note-Tome.jpeg',6.90,NULL),
('Hajime No Ippo','manga',NULL,'image/Hajime-No-Ippo-Tome.jpeg',8.90,NULL),
('Ken le Survivant','manga',NULL,'image/Ken-Le-Survivant-Tome.jpeg',8.50,NULL),
('Gundam Wing','manga',NULL,'image/Gundam-Wing-Tome.jpeg',8.00,NULL),
('Full Metal Alchemist','manga',NULL,'image/Full-Metal-Tome.jpeg',8.00,NULL),
('Fairy Tail','manga',NULL,'image/Fairy-Tail-Tome.jpeg',7.50,NULL),
('One Punch Man','manga',NULL,'image/One-Punch-Man-Tome.jpeg',8.50,NULL),
('Afro Samouraï','manga',NULL,'image/Afro-Samourai-Tome.jpeg',9.10,NULL),
('Hunter-X-Hunter','manga',NULL,'image/Hunter-X-Hunter-Tome.jpeg',7.80,NULL),
('Moi Quand Je Me Reincarne En Slime','manga',NULL,'image/Moi-Slime-Tome.jpeg',7.80,NULL),
('Nicky Larson','manga',NULL,'image/City-Hunter-Tome.jpeg',7.80,NULL),
('Saint Seya Les Chevaliers Du Zodiaque','manga',NULL,'image/Saint-Seya-Tome.jpeg',7.80,NULL),
('Sailor-Moon','manga',NULL,'image/Sailor-Moon-Tome.jpeg',7.80,NULL),
('Pop Naruto - Edition limitée','figurine',NULL,'image/Pop Naruto.jpeg',29.90,NULL),
('Figurine Itachi + Peluche Kuruma','figurine',NULL,'image/Figurine Itachi + Peluche Kuruma.jpeg',52.50,NULL),
('Figurine Jiraya','figurine',NULL,'image/Figurine Jiraya.jpeg',25.90,NULL),
('Figurine Naruto Mode Emite','figurine',NULL,'image/Figurine Naruto Mode Emite.jpeg',35.90,NULL),
('Jeu de société Naruto','goodies','naruto','image/Jeu de société Naruto.jpeg',56.50,NULL),
('Katana Konoha','goodies','naruto','image/Katana Naruto.jpeg',74.90,NULL),
('Sac Naruto','goodies','naruto','image/Sac Naruto.jpeg',34.90,NULL),
('Porte clé Pop Naruto','goodies','naruto','image/Porte clé Pop Naruto.jpeg',14.90,NULL),
('Mug Naruto Equipe 7','goodies','naruto','image/Mug Naruto Equipe 7.jpeg',9.90,NULL),
('Bandeau Sasuke','goodies','naruto','image/Bandeau Naruto.jpeg',44.90,NULL),
('Kunai Naruto','goodies','naruto','image/Kunai Naruto.jpeg',54.90,NULL),
('Figurine Satoru Gojo','figurine',NULL,'image/Figurine Satoru Gojo.jpeg',17.80,NULL),
('Lampe Satoru Gojo','goodies','jujutsu_kaisen','image/Lampe Satoru Gojo.jpeg',27.80,NULL),
('Mug Itadori','goodies','jujutsu_kaisen','image/Mug Itadori 1.jpg',9.80,NULL),
('Sac à Dos Jujutsu Kaisen','goodies','jujutsu_kaisen','image/Sac à Dos Jujutsu Kaisen.jpeg',47.80,NULL),
('Lots Bagues Jujutsu Kaisen','goodies','jujutsu_kaisen','image/Lots Bagues Jujutsu Kaisen.jpeg',37.80,NULL),
('Mug Satoru Gojo','goodies','jujutsu_kaisen','image/Mug Satoru Gojo.jpeg',18.80,NULL),
('Figurine Pop Sukuna','figurine',NULL,'image/Figurin Pop Sukuna.jpeg',27.80,NULL),
('Figurine Pop Megumi','figurine',NULL,'image/Figurine Pop Megumi.jpeg',27.80,NULL),
('Bateau Thousant Sunny','goodies','one_piece','image/Bateau Thousant Sunny.jpeg',87.80,NULL),
('Coffre au Trésor One Piece','goodies','one_piece','image/Coffre au Trésor One Piece.jpeg',97.80,NULL),
('Verre One Piece','goodies','one_piece','image/Verre One Piece.jpeg',7.80,NULL),
('Fruits des Demons','goodies','one_piece','image/Fruits des Demons.jpeg',47.80,NULL),
('Peluche Fruit du Démon','goodies','one_piece','image/Peluche Fruit du Demon.jpeg',29.80,NULL),
('Chapeau Luffy','goodies','one_piece','image/Chapeau Luffy.jpeg',54.80,NULL),
('Support Portable Luffy Gear 5','goodies','one_piece','image/Support Portable Luffy Gear 5.jpeg',25.80,NULL),
('Coque Portable One Piece','goodies','one_piece','image/Coque Portable.jpeg',17.80,NULL),
('Sac à Dos One Piece','goodies','one_piece','image/Sac à Dos One Piece.jpeg',45.80,NULL),
('Lots Mugs One Piece','goodies','one_piece','image/Lots Mugs One Piece.jpeg',77.80,NULL),
('Lampe Luffy Gear 5','goodies','one_piece','image/Lampe Luffy Gear 5.jpeg',44.80,NULL),
('Bague One Piece','goodies','one_piece','image/Bague One Piece.jpeg',25.80,NULL),
('Porte Feuille One Piece','goodies','one_piece','image/Porte Feuille One Piece.jpeg',45.80,NULL),
('Manette PS5 One Piece','goodies','one_piece','image/Manette PS5 One Piece.jpeg',125.80,NULL),
('Figurine Led Luffy Gear 5','figurine',NULL,'image/Figurine Led Luffy Gear 5.jpeg',67.80,NULL),
('Figurine Pop Luffy','figurine',NULL,'image/Figurine Pop Luffy.jpeg',27.80,NULL),
('Figurine Ace','figurine',NULL,'image/Figurine Ace.jpeg',27.80,NULL),
('Figurine Jinbe','figurine',NULL,'image/Figure Jinbe.jpeg',37.80,NULL),
('Figurine Ener','figurine',NULL,'image/Figurine Ener.jpeg',37.80,NULL),
('Figurine Pop Kaido','figurine',NULL,'image/Figurine Pop Kaido.jpeg',27.80,NULL),
('Figurine Luffy Gear 5','figurine',NULL,'image/Figurine Luffy Gear 5.jpeg',39.80,NULL),
('Figurine Mihawk','figurine',NULL,'image/Figurine Mihawk.jpeg',39.80,NULL),
('Figurine Pop Zoro','figurine',NULL,'image/Figurine Pop Zoro.jpeg',27.80,NULL),
('Figurine Barbe Noir','figurine',NULL,'image/Figurine Barbe Noir.jpeg',37.80,NULL),
('Lots Portes Clés Demon Slayer','goodies','demon_slayer','image/Lots Porte Clé Demon Slayer.jpeg',27.80,NULL),
('Katana Tanjiro','goodies','demon_slayer','image/Katana Tanjiro.jpg',107.80,NULL),
('Coffret 15 Piece Demon Slayer','goodies','demon_slayer','image/Coffret 15 Piece Demon Slayer.jpeg',79.80,NULL),
('Coffret Demon Slayer','goodies','demon_slayer','image/Coffret Demon Slayer.jpeg',59.80,NULL),
('Figurine Tanjiro','figurine',NULL,'image/Figurine Tenjuro.jpeg',37.90,NULL),
('Figurine Pop Tanjiro Nezuko','figurine',NULL,'image/Figurine Pop Tanjiro Nezuko.jpeg',39.80,NULL),
('Figurine Nezuko','figurine',NULL,'image/Figurine Nezuko.jpeg',29.90,NULL),
('Figurine Inosuke','figurine',NULL,'image/Figurine Inosuke.jpeg',29.80,NULL),
('Figurine Sabito','figurine',NULL,'image/Figurine Sabito.jpeg',29.80,NULL),
('Figurine Tengen','figurine',NULL,'image/Figurine Tengen.jpeg',29.80,NULL),
('Figurine Tomyoka','figurine',NULL,'image/Figurine Tomyoka.jpeg',29.80,NULL),
('Figurine Muichiro','figurine',NULL,'image/Figurine Muichiro.jpeg',29.80,NULL),
('Figurine Sanemi','figurine',NULL,'image/Figurine Sanemi.jpeg',29.80,NULL),
('Figurine Kanroji','figurine',NULL,'image/Figurine Kanroji.jpg',29.80,NULL),
('Figurine Zenitsu','figurine',NULL,'image/Figurine Zenitsu.jpeg',29.80,NULL),
('Figurine Pop Goku Ultra Instinct','figurine',NULL,'image/Figurine Pop Goku Ultra.jpg',27.90,NULL),
('Figurine Pop M Vegeta','figurine',NULL,'image/Figurine Pop M Vegeta.jpg',27.90,NULL),
('Figurine Gogeta SS4','figurine',NULL,'image/Figurine Gogeta SS4.jpg',37.80,NULL),
('Figurine Broly Fullpower','figurine',NULL,'image/Figurine Broly Fullpower.jpg',37.90,NULL),
('Figurine Trunks SS','figurine',NULL,'image/Figurine Trunks SS.jpg',39.90,NULL),
('Figurine Freezer','figurine',NULL,'image/Figurine Freezer.jpg',7.80,NULL),
('Figurine Son Goku SS3','figurine',NULL,'image/Figurine Son Goku SS3.jpg',39.90,NULL),
('Figurine Goku UI Vs Jiren','figurine',NULL,'image/Figurines Goku UI Vs Jiren Match Makers.jpg',67.80,NULL),
('Figurine Majin Buu','figurine',NULL,'image/Figurine Majin Buu.jpg',37.80,NULL),
('Figurine Goten Trunks Fusion','figurine',NULL,'image/Figurines Goten Trunks Fusion.jpg',49.80,NULL),
('Figurine Gotenks SS Ghost','figurine',NULL,'image/Figurine Gotenks SS Ghost.jpg',39.80,NULL),
('Figurine Gotenks SS3','figurine',NULL,'image/Figurine Gotenks SS3.jpg',47.80,NULL),
('Figurine Son Goku SSG','figurine',NULL,'image/Figurine Son Goku SSG.jpg',47.80,NULL),
('Figurine Son Goku SSB','figurine',NULL,'image/Figurine Son Goku SSB.jpg',47.80,NULL),
('Figurine Vegeta SSB','figurine',NULL,'image/Figurine Vegeta SSB.jpg',47.80,NULL),
('Figurine Baby Vegeta SS2','figurine',NULL,'image/Figurine Baby Vegeta SS2.jpg',47.80,NULL),
('Figurine Vegeto SS','figurine',NULL,'image/Figurine Vegeto SS.jpg',59.80,NULL),
('Figurine Gogeta SS','figurine',NULL,'image/Figurine Gogeta SS.jpg',47.80,NULL),
('Figurine Broly SS2','figurine',NULL,'image/Figurine Broly SS2.jpg',47.80,NULL),
('Figurine Metal Cooler','figurine',NULL,'image/Figurine Metal Cooler.jpg',43.80,NULL),
('Figurine Black Goku','figurine',NULL,'image/Figurine Black Goku.jpg',47.80,NULL),
('Figurine Beerus','figurine',NULL,'image/Figurine Beerus.jpg',47.80,NULL),
('Figurine Gohan Enfant SS2 Vs Cell','figurine',NULL,'image/Figurine Gohan Enfant SS2 Vs Cell.jpg',67.80,NULL),
('Figurine Gogeta Vs Janemba','figurine',NULL,'image/Figurines Gogeta Janemba.jpg',67.80,NULL),
('Tapis de Bureau Dragon Ball Super','goodies','dragon_ball','image/Tapis de Bureau DBS.jpg',25.80,NULL),
('Sac Dragon Ball Super','goodies','dragon_ball','image/Sac DBS.jpg',18.80,NULL),
('Sac de Sport Dragon Ball Z','goodies','dragon_ball','image/Sac de Sport DBZ.jpg',35.80,NULL),
('Sac à Dos Goku','goodies','dragon_ball','image/Sac à Dos Goku.jpg',29.80,NULL),
('Puzzle 1000 Pieces Dragon Ball Z','goodies','dragon_ball','image/Puzzle 1000 Pieces DBZ.jpg',55.80,NULL),
('Jeu de 54 Cartes Dragon Ball Z','goodies','dragon_ball','image/Jeu de 54 Cartes DBZ.jpg',25.80,NULL),
('Uno Dragon Ball Z','goodies','dragon_ball','image/Uno DBZ.jpg',45.80,NULL),
('Jeu de 7 Familles Dragon Ball Z','goodies','dragon_ball','image/Jeu de 7 Familles DBZ.jpg',25.80,NULL),
('Boite à Musique Tapion','goodies','dragon_ball','image/Boite à Musique Tapion DBZ.jpg',59.80,NULL),
('Coffret 7 Boules de Cristal Dragon Ball Z','goodies','dragon_ball','image/Coffret 7 Boules de Cristal DBZ.jpg',75.80,NULL),
('Boule de Cristal 2 Etoiles Dragon Ball Z','goodies','dragon_ball','image/Boule De Cristal DBZ.jpg',21.80,NULL),
('Mug Thermique Gohan vs Cell','vaisselle',NULL,'image/Mug Thermique Gohan Vs Cell.jpg',25.80,NULL),
('Mug Broly SS2','vaisselle',NULL,'image/Mug Broly SS2.jpg',21.80,NULL),
('Mug Goku','vaisselle',NULL,'image/Mug Goku.jpg',21.80,NULL),
('Mug Hit','vaisselle',NULL,'image/Mug Hit.jpg',21.80,NULL),
('Boite à Cookies Kamehouse Dragon Ball Z','goodies','dragon_ball','image/Boite à Cookies Kamehouse DBZ.jpg',75.80,NULL),
('Porte Cle Goku SSB','goodies','dragon_ball','image/Porte Cle Goku SSB.jpg',11.80,NULL),
('Porte Cle Pop Goku SS4','goodies','dragon_ball','image/Porte Cle Pop Goku SS4.jpg',15.80,NULL),
('Porte Cle Radar Dragon Ball Z','goodies','dragon_ball','image/Porte Cle Radar DBZ.jpg',11.80,NULL),
('Peluche Nuage Magique Dragon Ball Z','goodies','dragon_ball','image/Peluche Nuage Magique DBZ.jpg',33.80,NULL),
('Lots Figurines Dragon Ball Z','goodies','dragon_ball','image/Lots Figurines DBZ.jpg',55.80,NULL),
('Bol Chapeau Luffy','vaisselle',NULL,'image/Bol Chapeau Luffy.jpg',37.90,NULL),
('Mug One Piece','vaisselle',NULL,'image/Mug One piece.jpg',35.90,NULL),
('Tasse et Bol One Piece','vaisselle',NULL,'image/Tasse et Bol One Piece.jpg',45.50,NULL),
('Bol Drapeau One Piece','vaisselle',NULL,'image/Bol Drapeau One Piece.jpg',35.80,NULL),
('Assiette One Piece','vaisselle',NULL,'image/Assiette One Piece.jpg',220.90,NULL),
('Mug Thermique One Piece Wanted','vaisselle',NULL,'image/Mug Thermique One Piece Wanted.jpg',38.80,NULL),
('Mug Luffy Gear 5 Attaque','vaisselle',NULL,'image/Mug Luffy Gear 5 Attaque.jpg',27.90,NULL),
('Mug Monkey D Luffy','vaisselle',NULL,'image/Mug Monkey D Luffy.jpg',27.80,NULL),
('Mug Luffy Zoro Chopper','vaisselle',NULL,'image/Mug Luffy Zoro Chopper.jpg',27.80,NULL),
('Mug Chopper','vaisselle',NULL,'image/Mug Chopper.jpg',27.80,NULL),
('Mug Garp','vaisselle',NULL,'image/Mug Garp.jpg',27.80,NULL),
('Mug Barbe Noir','vaisselle',NULL,'image/Mug Barbe Noir.jpg',27.80,NULL),
('Mug Trafalgar Law','vaisselle',NULL,'image/Mug Trafalgar Law.jpg',27.80,NULL),
('Bol Konoha','vaisselle',NULL,'image/Bol Konoha.jpg',32.80,NULL),
('Bol Akatsuki','vaisselle',NULL,'image/Bol Akatsuki.jpg',32.80,NULL),
('Verre Akatsuki','vaisselle',NULL,'image/Verre Akatsuki.jpg',35.80,NULL),
('Verre Uchiha','vaisselle',NULL,'image/Verre Uchiha.jpg',35.80,NULL),
('Mug Thermique Sasuke Uchiha','vaisselle',NULL,'image/Mug Thermique Sasuke.jpg',38.80,NULL),
('Mug Naruto Kakashi','vaisselle',NULL,'image/Mug Naruto.jpeg',27.80,NULL),
('Mug Kunai Konoha','vaisselle',NULL,'image/Mug Kunai Konoha.jpg',32.80,NULL),
('Mug Sceau Naruto','vaisselle',NULL,'image/Mug Sceau Naruto.jpg',27.80,NULL),
('Boite Repas Dragon Ball Z','vaisselle',NULL,'image/Boite Alimentaire Dragon Ball Z.jpg',58.80,NULL),
('Verre Vegeta','vaisselle',NULL,'image/Verre Vegeta.jpg',35.80,NULL),
('Assiette Dragon Ball Z','vaisselle',NULL,'image/Assiette Dragon Ball Z.jpg',42.80,NULL),
('Assiette Son Goku','vaisselle',NULL,'image/Assiette Son Goku.jpg',42.80,NULL),
('Mug Dragon Ball Z','vaisselle',NULL,'image/Mug Dragon Ball Z.jpg',27.80,NULL),
('Kit Anniversaire Demon Slayer','vaisselle',NULL,'image/Kit Anniversaire Demon Slayer.jpg',127.80,NULL),
('Bol Tanjiro','vaisselle',NULL,'image/Bol Tanjiro.png',32.80,NULL),
('Verre Demon Slayer','vaisselle',NULL,'image/Verre Demon Slayer.jpg',35.80,NULL),
('Verre Itadori Sukuna','vaisselle',NULL,'image/Verre Itadori Sukuna.jpg',35.80,NULL),
('Mug Doigt Sukuna','vaisselle',NULL,'image/Mug Doigt Sukuna.jpg',32.80,NULL),
('Mug Nezuko Demon','vaisselle',NULL,'image/Mug Nezuko Demon.jpg',27.80,NULL),
('Mug Tanjiro Zenitsu','vaisselle',NULL,'image/Mug Tanjiro Zenitsu.jpg',27.80,NULL),
('Mug Mitsuri Kanroji','vaisselle',NULL,'image/Mug Mitsuri Kanroji.jpg',27.80,NULL),
('Mug Nezuko','vaisselle',NULL,'image/Mug Nezuko.jpg',27.80,NULL),
('Mug Tanjiro','vaisselle',NULL,'image/Mug Tanjiro.jpg',27.80,NULL),
('Mug Tomyoka','vaisselle',NULL,'image/Mug Tomyoka.jpg',27.80,NULL),
('Bol Pokemon','vaisselle',NULL,'image/Bol Pokemon.jpg',32.80,NULL),
('Mug Pikachu','vaisselle',NULL,'image/Mug Pikachu.jpg',27.80,NULL),
('Bol Death Note','vaisselle',NULL,'image/Bol Death Note.jpg',32.80,NULL),
('Mug L','vaisselle',NULL,'image/Mug L.jpg',27.80,NULL),
('Verre Tokyo Ghoul','vaisselle',NULL,'image/Verre Tokyo Ghoul.jpg',35.80,NULL),
('Mug Tokyo Ghoul','vaisselle',NULL,'image/Mug Tokyo Ghoul.jpg',27.80,NULL),
('Tasse et Bol My Hero Academia','vaisselle',NULL,'image/Tasse et Bol My Hero Academia.jpg',45.80,NULL),
('Mug Saitama','vaisselle',NULL,'image/Mug Saitama.jpg',27.80,NULL),
('Mug Dandadan','vaisselle',NULL,'image/Mug Dandadan.jpg',27.80,NULL),
('Mug Assasination Classroom','vaisselle',NULL,'image/Mug Assasination Classroom.jpg',27.80,NULL),
('Mug Spy Family','vaisselle',NULL,'image/Mug Spy Family.jpg',27.80,NULL),
('Mug Sailor Moon','vaisselle',NULL,'image/Mug Sailor Moon.jpg',27.80,NULL),
('Veste Luffy','textiles',NULL,'image/Veste Luffy.jpg',147.90,NULL),
('Veste One Piece','textiles',NULL,'image/Veste Symbole One Piece.jpg',147.90,NULL),
('Jogging One Piece','textiles',NULL,'image/Jogging One Piece.jpg',228.50,NULL),
('Sweat Ace','textiles',NULL,'image/Sweat Ace.jpg',87.80,NULL),
('Sweat Luffy Gear 5','textiles',NULL,'image/Sweat Luffy Gear 5.jpg',77.80,NULL),
('Sweat One Piece','textiles',NULL,'image/Sweat Symbole One Piece.jpg',77.80,NULL),
('Tee Shirt Luffy','textiles',NULL,'image/Tee Shirt Logo Luffy.jpg',48.00,NULL),
('Pyjama Luffy','textiles',NULL,'image/Pyjama Luffy.jpg',78.00,NULL),
('Tenue Luffy','textiles',NULL,'image/Tenue Luffy.jpg',47.50,NULL),
('Costume Luffy','textiles',NULL,'image/Costume Luffy.jpg',67.90,NULL),
('Costume Nami','textiles',NULL,'image/Costume Nami.jpg',67.90,NULL),
('Costume Sanji','textiles',NULL,'image/Costume Sanji.jpg',67.90,NULL),
('Costume Trafalgar Law','textiles',NULL,'image/Costume Trafalgar Law.jpg',97.80,NULL),
('Parure Luffy Gear 5','textiles',NULL,'image/Parure Luffy Gear 5.jpg',258.00,NULL),
('Parure Zoro','textiles',NULL,'image/Parure Zoro.jpg',248.00,NULL),
('Parure One Piece','textiles',NULL,'image/Parure One Piece.jpg',238.00,NULL),
('Doudoune Akatsuki','textiles',NULL,'image/Doudoune Akastsuki.jpg',78.50,NULL),
('Jogging Naruto','textiles',NULL,'image/Jogging Naruto.jpg',158.50,NULL),
('Sweat Naruto','textiles',NULL,'image/Sweat Naruto.jpg',68.50,NULL),
('Tee Shirt Sasuke','textiles',NULL,'image/Tee Shirt Sasuke.jpg',48.50,NULL),
('Pyjama Kurama','textiles',NULL,'image/Pyjama Kurama.jpg',58.50,NULL),
('Costume Naruto','textiles',NULL,'image/Costume Naruto.jpg',55.50,NULL),
('Costume Itachi','textiles',NULL,'image/Costume Itachi.jpg',55.50,NULL),
('Parure Naruto','textiles',NULL,'image/Parure Naruto.jpg',258.50,NULL),
('Parure Akatsuki','textiles',NULL,'image/Parure Akatsuki.jpg',278.50,NULL),
('Parure Sasuke','textiles',NULL,'image/Parure Sasuke.jpg',258.50,NULL),
('Veste Black Goku','textiles',NULL,'image/Veste Black Goku.jpg',77.90,NULL),
('Jogging Dragon Ball Z','textiles',NULL,'image/Jogging Dragon Ball Z.jpg',127.90,NULL),
('Sweat San Goku Ultra Instinct','textiles',NULL,'image/Sweat San Goku Ultra Instinct.jpg',68.50,NULL),
('Tee Shirt Gogeta SSB','textiles',NULL,'image/Tee Shirt Gogeta SSB.jpg',47.90,NULL),
('Pyjama San Goku','textiles',NULL,'image/Pyjama San Goku.jpg',55.90,NULL),
('Costume San Goku','textiles',NULL,'image/Costume San Goku.jpg',50.50,NULL),
('Costume Videl','textiles',NULL,'image/Costume Videl.jpg',52.80,NULL),
('Parure San Goku Ultra Instinct','textiles',NULL,'image/Parure San Goku Ultra Instinct.jpg',248.50,NULL),
('Parure Black Goku','textiles',NULL,'image/Parure Black Goku.jpg',238.50,NULL),
('Parure San Goku SS4 Vegeta SS4','textiles',NULL,'image/Parure San Goku SS4 Vegeta SS4.jpg',258.50,NULL),
('Veste Zenitsu','textiles',NULL,'image/Veste Zeni''tsu.jpg',75.50,NULL),
('Jogging Nezuko','textiles',NULL,'image/Jogging Nezuko.jpg',158.50,NULL),
('Sweat Tanjiro','textiles',NULL,'image/Sweat Tanjiro.jpg',65.50,NULL),
('Tee Shirt Inosuke','textiles',NULL,'image/Tee Shirt Inosuke.jpg',48.50,NULL),
('Pyjama Zenitsu','textiles',NULL,'image/Pyjama Zeni''tsu.jpg',55.50,NULL),
('Costume Zenitsu','textiles',NULL,'image/Costume Zeni''tsu.jpg',50.50,NULL),
('Costume Nezuko','textiles',NULL,'image/Costume Nezuko.jpg',60.50,NULL),
('Parure Demon Slayer','textiles',NULL,'image/Parure Demon Slayer.jpg',258.50,NULL),
('Parure Tanjiro Nezuko','textiles',NULL,'image/Parure Tanjiro Nezuko.jpg',268.50,NULL),
('Parure Nezuko','textiles',NULL,'image/Parure Nezuko.jpg',278.50,NULL),
('Veste One Punch Man','textiles',NULL,'image/Veste One Punch Man.jpg',75.50,NULL),
('Jogging Saitama','textiles',NULL,'image/Jogging Saitama.jpg',158.50,NULL),
('Sweat Genos','textiles',NULL,'image/Sweat Genos.jpg',65.50,NULL),
('Tee Shirt Garou','textiles',NULL,'image/Tee Shirt Garou.jpg',48.50,NULL),
('Pyjama Saitama','textiles',NULL,'image/Pyjama Saitama.jpg',55.50,NULL),
('Costume Saitama','textiles',NULL,'image/Costume Saitama.jpg',50.50,NULL),
('Costume Tatsumaki','textiles',NULL,'image/Costume Tatsumaki.jpg',60.50,NULL),
('Parure One Punch Man','textiles',NULL,'image/Parure One Punch Man.jpg',258.50,NULL),
('Parure Saitama','textiles',NULL,'image/Parure Saitama.jpg',268.50,NULL),
('Parure Genos','textiles',NULL,'image/Parure Genos.jpg',278.50,NULL),
('Veste Solo Leveling','textiles',NULL,'image/Veste Solo Leveling.jpg',75.50,NULL),
('Jogging Solo Leveling','textiles',NULL,'image/Jogging Solo Leveling.jpg',158.50,NULL),
('Sweat Sung Jin Hoo','textiles',NULL,'image/Sweat Sung Jin Hoo.jpg',65.50,NULL),
('Tee Shirt Sung Jin Hoo','textiles',NULL,'image/Tee Shirt Sung Jin Hoo.jpg',48.50,NULL),
('Pyjama Solo Leveling','textiles',NULL,'image/Pyjama Solo Leveling.jpg',55.50,NULL),
('Costume Sung Jin Hoo','textiles',NULL,'image/Costume Sung Jin Hoo.jpg',50.50,NULL),
('Costume Cha Hae In','textiles',NULL,'image/Costume Cha Hae In.jpg',60.50,NULL),
('Parure Sung Jin Hoo','textiles',NULL,'image/Parure Sung Jin Hoo.jpg',258.50,NULL),
('Parure Solo Leveling','textiles',NULL,'image/Parure Solo Leveling.jpg',268.50,NULL),
('Parure Sung Jin Hoo Black','textiles',NULL,'image/Parure Sung Jin Hoo Black.jpg',278.50,NULL);

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE detail_articles_public (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  article_id INTEGER NOT NULL UNIQUE,
  description TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  article_id INTEGER NOT NULL,
  viewed_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
  FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,

  UNIQUE (user_id, article_id)
);

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE favorites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  article_id INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
  FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,

  UNIQUE (user_id, article_id)
);

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  total_amount REAL NOT NULL DEFAULT 0,
  status TEXT NOT NULL CHECK (
    status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')
  ),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

INSERT INTO orders (user_id, total_amount, status) VALUES
(2, 356, 'pending'),
(2, 250, 'paid'),
(3, 425, 'shipped'),
(4, 99, 'delivered'),
(5, 199, 'cancelled');

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE orders_articles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id INTEGER NOT NULL,
  article_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price REAL NOT NULL,

  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (article_id) REFERENCES articles(id),

  UNIQUE (order_id, article_id)
);

INSERT INTO orders_articles (order_id, article_id, quantity, unit_price) VALUES
(1, 2, 2, 7.10),
(3, 3, 1, 6.90),
(4, 2, 3, 7.10),
(5, 1, 1, 6.90);

/* ======================================================================================= */
/* ======================================================================================= */

CREATE TABLE contact (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  sujet TEXT NOT NULL,
  message TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending', 'read', 'answered')) DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE SET NULL
);

INSERT INTO contact (user_id, sujet, message, status) VALUES
(2, 'Commande', 'Je n''ai toujours pas reçu ma commande', 'answered'),
(3, 'Commande', 'Ma commande est détériorée. Que faire ?', 'answered'),
(4, 'Commande', 'Très satisfait, arrivé rapidement', 'read'),
(5, 'Commande', 'Super j''ai reçu ma commande', 'read'),
(6, 'Commande', 'Très bon site merci', 'pending'),
(7, 'Commande', 'Je n''ai toujours pas reçu ma commande', 'pending');

/***************************************************************************************/
/***************************************************************************************/

CREATE TABLE topics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

/***************************************************************************************/
/***************************************************************************************/