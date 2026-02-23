PRAGMA foreign_keys = ON;

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

INSERT INTO articles (name, genres, image, price, release_day) VALUES
('Sekai Saisoku no Isekai Ryokouki','manga','Image/sekai saisoku no isekai ryokouki chapter 1.jpg',7.80,'Lundi'),
('Ordeal','manga','Image/ordeal tome.jpg',7.80,'Lundi'),
('Blue Box','manga','Image/blue box tome 1.jpg',7.80,'Lundi'),
('Nyaight of the Living Cat','manga','Image/nyaight of the living cat tome 1.jpg',7.80,'Lundi'),
('Juvenile Detention Center','manga','Image/juvenile detention center tome 1.jpg',7.80,'Lundi'),
('Maybe Meant','manga','Image/maybe meant tome 1.jpg',7.80,'Lundi'),
('Tonikaku Kuwai','manga','Image/tonikaku kuwai tome 1.jpeg',7.80,'Lundi'),
('To Your Eternity','manga','Image/to your eternity tome 1.jpeg',7.80,'Lundi'),
('Yano Kun no','manga','Image/yano kun no tome 1.jpg',7.80,'Mardi'),
('Return to Player','manga','Image/return to player tome 1.jpg',7.80,'Mardi'),
('Manager Kim','manga','Image/manager kim tome 1.jpg',7.80,'Mardi'),
('Hero Without a Class','manga','Image/hero without a class tome 1.jpg',7.80,'Mardi'),
('Let''s Play','manga','Image/let''s play tome 1.jpg',7.80,'Mardi'),
('Afterlife Inn Cooking','manga','Image/afterlife inn cooking tome 1.jpg',7.80,'Mardi'),
('Rent a Girl','manga','Image/rent a girl tome 1.jpg',7.80,'Mardi'),
('A Couple of Cuckoos','manga','Image/a couple of cuckoos tome 1.jpg',7.80,'Mardi'),
('99 Reinforced Wood Stick','manga','Image/99 reinforced wood stick tome 1.jpeg',7.80,'Mercredi'),
('Baek','manga','Image/baek tome 1.jpeg',7.80,'Mercredi'),
('Surviving the Game As','manga','Image/Surviving the game as tome 1.jpeg',7.80,'Mercredi'),
('The Druid of Seoul Station','manga','Image/the druid of seoul station tome 1.jpeg',7.80,'Mercredi'),
('The Mafia Nanny','manga','Image/the mafia nanny tome 1.jpeg',7.80,'Mercredi'),
('Umamusume Cinderella Gray','manga','Image/umamusume cinderella gray tome 1.jpeg',7.80,'Mercredi'),
('Blue Orchestra','manga','Image/blue orchestra tome 1.jpeg',7.80,'Mercredi'),
('Hero Ticket','manga','Image/hero ticket tome 1.jpeg',7.80,'Mercredi'),
('Dr. Stone','manga','Image/Dr-Stone-Tome.jpeg',7.90,'Jeudi'),
('Futari Solo Camp','manga','Image/futari solo camp tome 1.jpeg',7.80,'Jeudi'),
('Past the Monster Meat','manga','Image/past the monster meat tome 1.jpeg',7.80,'Jeudi'),
('The Rising of the Shield Hero','manga','Image/the rising of the shield hero tome 1.jpeg',7.90,'Jeudi'),
('I Was Reincarnated as the 7th Prince','manga','Image/i was reincarnated as the 7th prince tome 1.jpeg',7.80,'Jeudi'),
('Reborn as a Vending Machine','manga','Image/reborn as a vending machine tome 1.jpeg',7.80,'Jeudi'),
('Dreaming Freedom','manga','Image/dreaming freedom tome 1.jpeg',7.80,'Jeudi'),
('Dragon Raja','manga','Image/dragon raja tome 1.jpeg',7.90,'Vendredi'),
('Cat''s Eyes 2025','manga','Image/cat''s eyes 2025 tome 1.jpeg',7.80,'Vendredi'),
('Watari Kun no XX ga Houkai Sunzen','manga','Image/watari kun no xx ga houkai sunzen tome 1.jpeg',7.90,'Vendredi'),
('Tsubasa Chronicle','manga','Image/tsubasa chronicle tsubasa tome 1.jpeg',7.90,'Vendredi'),
('May I Ask for One Final Thing','manga','Image/may i ask for one final thing tome 1.jpeg',7.80,'Vendredi'),
('One Piece','manga','Image/One-Piece-Tome.jpeg',7.90,'Vendredi'),
('Study Group','manga','Image/study group tome 1.jpeg',7.80,'Vendredi'),
('Lord of Mysteries','manga','Image/lord of mysteries tome 1.jpeg',7.90,'Samedi'),
('Détective Conan','manga','Image/Détective-Conan-Tome.jpeg',7.90,'Samedi'),
('A Wild Last Boss Appeared','manga','Image/a wild last boos appeard tome 1.jpeg',7.80,'Samedi'),
('Silent Witch','manga','Image/silent witch tome 1.jpeg',7.80,'Samedi'),
('Kingdom','manga','Image/kingdom tome 1.jpeg',7.90,'Samedi'),
('My Hero Academia','manga','Image/My-Hero-Academia-Tome.jpeg',7.90,'Samedi'),
('Spy x Family','manga','Image/spy x family tome 1.jpeg',7.90,'Samedi'),
('Let This Grieving Soul Retire','manga','Image/let this grieving soul retire tome 1.jpeg',7.80,'Samedi'),
('Witch Watch','manga','Image/witch watch tome 1.jpeg',7.90,'Dimanche'),
('My Dress Up Darling','manga','Image/my dress up darling tome 1.jpeg',7.90,'Dimanche'),
('Rascal Does Not Dream of Bunny Girl Senpai','manga','Image/rascal does not dream of bunny girl senpai tome 1.jpeg',8.50,'Dimanche'),
('Gachiakuta','manga','Image/Gachiakuta-Tome.jpeg',7.80,'Dimanche'),
('Be a Princess Someday','manga','Image/be a princess someday tome 1.jpeg',7.90,'Dimanche'),
('Kikaijikake no Marie','manga','Image/kikaijikake no marie tome 1.jpeg',7.80,'Dimanche'),
('Alma Chan wa Kazoku ni Naritai','manga','Image/alma chan wa kazoku ni naritai tome 1.jpeg',7.90,'Dimanche'),
('Dad is a Hero, Mom is a Spring, I''m a','manga','Image/dad is a hero mom is a spring i''m a tome 1.jpeg',7.80,'Dimanche'),
('Chain Saw','manga','Image/Chain-Saw-Tome.jpg',7.90,'Sans jour fixe'),
('Fairy Tail 100 Years Quest','manga','Image/fairy tail 100 years quest tome 1.jpg',7.90,'Sans jour fixe'),
('Four Knights of the Apocalypse','manga','Image/four knights of the apocalypse tome 1.jpg',8.50,'Sans jour fixe'),
('Blue Lock','manga','Image/Blue Lock.jpg',7.90,'Sans jour fixe'),
('Embers','manga','Image/embers tome 1.jpg',7.80,'Sans jour fixe'),
('I''m the Max Level Newbie','manga','Image/i''m the max level newbie tome 1.jpg',8.00,'Sans jour fixe'),
('Infinite Mage','manga','Image/infinite mage tome 1.jpg',7.90,'Sans jour fixe'),
('Itchi the Witch','manga','Image/itchi the witch tome 1.jpg',7.50,'Sans jour fixe'),
('Kaoru Hana wa Rin to Saku','manga','Image/kaoru hana wa rin to saku tome 1.jpg',7.90,'Sans jour fixe'),
('Lecteur Omniscient','manga','Image/lecteur omniscient tome 1.jpg',8.00,'Sans jour fixe'),
('Nano Machine','manga','Image/nano machine tome 1.jpg',7.80,'Sans jour fixe'),
('Nebula''s Civilation','manga','Image/nebula''s civilation tome 1.jpg',8.00,'Sans jour fixe'),
('Pick Me Up','manga','Image/Pick Me Up tome.jpg',7.90,'Sans jour fixe'),
('Player','manga','Image/Player tome.jpg',7.90,'Sans jour fixe'),
('Player Who Returned 10000 Year Later','manga','Image/player who returned 10000 year later tome 1.jpg',8.50,'Sans jour fixe'),
('Reality Quest','manga','Image/reality quest tome 1.jpg',7.90,'Sans jour fixe'),
('Solo Leveling','manga','Image/Solo-Leveling-Tome.jpeg',8.50,'Sans jour fixe'),
('Wind Breaker','manga','Image/wind breaker tome 1.jpg',7.80,'Sans jour fixe'),
('The Beginning After the End','manga','Image/the beginning after the end tome 1.jpg',8.50,'Sans jour fixe'),
('Tougen Anki','manga','Image/tougen anki tome 1.jpg',7.90,'Sans jour fixe'),
('Shangri-La Frontier','manga','Image/Shangri-La-Frontier.jpeg',8.00,'Sans jour fixe'),
('Dragon Ball','manga','image/Dragon-Ball-Tome.jpeg',6.90,NULL),
('Dragon Ball Z','manga','image/Dragon-Ball-Z-Tome.jpeg',7.10,NULL),
('Naruto','manga','image/Naruto-Tome.jpeg',7.50,NULL),
('Naruto Shippuden','manga','image/Naruto-Shippuden.jpeg',7.90,NULL),
('Bleach','manga','image/Bleach-Tome.jpeg',7.30,NULL),
('Pokémon','manga','image/Pokemon-Tome.jpeg',6.50,NULL),
('Ranma ½','manga','image/Ranma-1-2-Tome.jpeg',7.40,NULL),
('Yu-Gi-Oh','manga','image/Yu-Gi-Oh-Tome.jpeg',7.00,NULL),
('Great Teacher Onizuka','manga','image/Great-Teacger-Onizuka-Tome.jpeg',8.20,NULL),
('Death Note','manga','image/Death-Note-Tome.jpeg',6.90,NULL),
('Hajime No Ippo','manga','image/Hajime-No-Ippo-Tome.jpeg',8.90,NULL),
('Ken le Survivant','manga','image/Ken-Le-Survivant-Tome.jpeg',8.50,NULL),
('Gundam Wing','manga','image/Gundam-Wing-Tome.jpeg',8.00,NULL),
('Full Metal Alchemist','manga','image/Full-Metal-Tome.jpeg',8.00,NULL),
('Fairy Tail','manga','image/Fairy-Tail-Tome.jpeg',7.50,NULL),
('One Punch Man','manga','image/One-Punch-Man-Tome.jpeg',8.50,NULL),
('Afro Samouraï','manga','image/Afro-Samourai-Tome.jpeg',9.10,NULL),
('99 Renforced Wooden Stick','manga','image/99-Renforced-Wooden-Stick.jpeg',10.00,NULL),
('Hunter-X-Hunter','manga','image/Hunter-X-Hunter-Tome.jpeg',7.80,NULL),
('Moi Quand Je Me Reincarne En Slime','manga','image/Moi-Slime-Tome.jpeg',7.80,NULL),
('Nicky Larson','manga','image/City-Hunter-Tome.jpeg',7.80,NULL),
('Saint Seya Les Chevaliers Du Zodiaque','manga','image/Saint-Seya-Tome.jpeg',7.80,NULL),
('Sailor-Moon','manga','image/Sailor-Moon-Tome.jpeg',7.80,NULL),
('Pop Naruto - Edition limitée','goodies','image/Pop Naruto.jpeg',29.90,NULL),
('Figurine Itachi + Peluche Kuruma','goodies','image/Figurine Itachi + Peluche Kuruma.jpeg',52.50,NULL),
('Figurine Jiraya','goodies','image/Figurine Jiraya.jpeg',25.90,NULL),
('Figurine Naruto Mode Emite','goodies','image/Figurine Naruto Mode Emite.jpeg',35.90,NULL),
('Mug Naruto Kakashi','goodies','image/Mug Naruto.jpg',9.90,NULL),
('Jeu de société Naruto','goodies','image/Jeu de société Naruto.jpeg',56.50,NULL),
('Katana Konoha','goodies','image/Katana Naruto.jpeg',74.90,NULL),
('Sac Naruto','goodies','image/Sac Naruto.jpeg',34.90,NULL),
('Porte clé Pop Naruto','goodies','image/Porte clé Pop Naruto.jpeg',14.90,NULL),
('Mug Naruto Equipe 7','goodies','image/Mug Naruto Equipe 7.jpeg',9.90,NULL),
('Bandeau Sasuke','goodies','image/Bandeau Naruto.jpeg',44.90,NULL),
('Kunai Naruto','goodies','image/Kunai Naruto.jpeg',54.90,NULL),
('Figurine Satoru Gojo','goodies','image/Figurine Satoru Gojo.jpeg',17.80,NULL),
('Lampe Satoru Gojo','goodies','image/Lampe Satoru Gojo.jpeg',27.80,NULL),
('Mug Itadori','goodies','image/Mug Itadori 1.jpg',9.80,NULL),
('Figurine Pop Sukuna','goodies','image/Figurin Pop Sukuna.jpeg',27.80,NULL),
('Sac à Dos Jujutsu Kaisen','goodies','image/Sac à Dos Jujutsu Kaisen.jpeg',47.80,NULL),
('Lots Bagues Jujutsu Kaisen','goodies','image/Lots Bagues Jujutsu Kaisen.jpeg',37.80,NULL),
('Figurine Pop Megumi','goodies','image/Figurine Pop Megumi.jpeg',27.80,NULL),
('Lots Porte Clé Jujutsu Kaisen','goodies','image/Lots Porte Clé Jujutsu Kaisen.jpeg',17.80,NULL),
('Mug Satoru Gojo','goodies','image/Mug Satoru Gojo.jpeg',18.80,NULL),
('Figurine Led Luffy Gear 5','goodies','image/Figurine Led Luffy Gear 5.jpeg',67.80,NULL),
('Bateau Thousant Sunny','goodies','image/Bateau Thousant Sunny.jpeg',87.80,NULL),
('Coffre au Trésor One Piece','goodies','image/Coffre au Trésor One Piece.jpeg',97.80,NULL),
('Figurine Pop Luffy','goodies','image/Figurine Pop Luffy.jpeg',27.80,NULL),
('Figurine Ace','goodies','image/Figurine Ace.jpeg',27.80,NULL),
('Verre One Piece','goodies','image/Verre One Piece.jpeg',7.80,NULL),
('Figure Jinbe','goodies','image/Figure Jinbe.jpeg',37.80,NULL),
('Figurine Ener','goodies','image/Figurine Ener.jpeg',37.80,NULL),
('Fruits des Demons','goodies','image/Fruits des Demons.jpeg',47.80,NULL),
('Figurine Pop Kaido','goodies','image/Figurine Pop Kaido.jpeg',27.80,NULL),
('Figurine Luffy Gear 5','goodies','image/Figurine Luffy Gear 5.jpeg',39.80,NULL),
('Figurine Mihawk','goodies','image/Figurine Mihawk.jpeg',39.80,NULL),
('Figurine Pop Zoro','goodies','image/Figurine Pop Zoro.jpeg',27.80,NULL),
('Figurine Barbe Noir','goodies','image/Figurine Barbe Noir.jpeg',37.80,NULL),
('Peluche Fruit du Démon','goodies','image/Peluche Fruit du Demon.jpeg',29.80,NULL),
('Chapeau Luffy','goodies','image/Chapeau Luffy.jpeg',54.80,NULL),
('Support Portable Luffy Gear 5','goodies','image/Support Portable Luffy Gear 5.jpeg',25.80,NULL),
('Coque Portable One Piece','goodies','image/Coque Portable.jpeg',17.80,NULL),
('Sac à Dos One Piece','goodies','image/Sac à Dos One Piece.jpeg',45.80,NULL),
('Lots Mugs One Piece','goodies','image/Lots Mugs One Piece.jpeg',77.80,NULL),
('Lampe Luffy Gear 5','goodies','image/Lampe Luffy Gear 5.jpeg',44.80,NULL),
('Figurine Gear 5 Luffy','goodies','image/Figurine Gear 5 Luffy.jpg',55.80,NULL),
('Figurine Gol D Roger','goodies','image/Figurine Gol D Roger.jpeg',44.80,NULL),
('Bague One Piece','goodies','image/Bague One Piece.jpeg',25.80,NULL),
('Porte Feuille One Piece','goodies','image/Porte Feuille One Piece.jpeg',45.80,NULL),
('Manette PS5 One Piece','goodies','image/Manette PS5 One Piece.jpeg',125.80,NULL),
('Figurine Tanjiro','goodies','image/Figurine Tenjuro.jpeg',37.90,NULL),
('Figurine Pop Tanjiro Nezuko','goodies','image/Figurine Pop Tanjiro Nezuko.jpeg',39.80,NULL),
('Lots Portes Clés Demon Slayer','goodies','image/Lots Porte Clé Demon Slayer.jpeg',27.80,NULL),
('Figurine Nezuko','goodies','image/Figurine Nezuko.jpeg',29.90,NULL),
('Figurine Inosuke','goodies','image/Figurine Inosuke.jpeg',29.80,NULL),
('Katana Tanjiro','goodies','image/Katana Tanjiro.jpg',107.80,NULL),
('Figurine Sabito','goodies','image/Figurine Sabito.jpeg',29.80,NULL),
('Figurine Tengen','goodies','image/Figurine Tengen.jpeg',29.80,NULL),
('Figurine Tomyoka','goodies','image/Figurine Tomyoka.jpeg',29.80,NULL),
('Figurine Muichiro','goodies','image/Figurine Muichiro.jpeg',29.80,NULL),
('Figurine Sanemi','goodies','image/Figurine Sanemi.jpeg',29.80,NULL),
('Figurine Kanroji','goodies','image/Figurine Kanroji.jpg',29.80,NULL),
('Figurine Zenitsu','goodies','image/Figurine Zenitsu.jpeg',29.80,NULL),
('Coffret 15 Piece Demon Slayer','goodies','image/Coffret 15 Piece Demon Slayer.jpeg',79.80,NULL),
('Coffret Demon Slayer','goodies','image/Coffret Demon Slayer.jpeg',59.80,NULL),
('Figurine Pop Nezuko','goodies','image/Figurine Pop Nezuko.jpeg',29.80,NULL),
('Figurine Pop Tanjiro Feu','goodies','image/Figurine Pop Tanjiro Feu.jpeg',29.80,NULL),
('Figurine Pop Kiojuro','goodies','image/Figurine Kiojuro.jpeg',29.80,NULL),
('Figurine Pop Tanjiro','goodies','image/Figurine Pop Tanjiro.jpeg',29.80,NULL),
('Figurine Pop Goku Ultra Instinct','goodies','image/Figurine Pop Goku Ultra.jpg',27.90,NULL),
('Figurine Pop M Vegeta','goodies','image/Figurine Pop M Vegeta.jpg',27.90,NULL),
('Figurine Gogeta SS4','goodies','image/Figurine Gogeta SS4.jpg',37.80,NULL),
('Figurine Broly Fullpower','goodies','image/Figurine Broly Fullpower.jpg',37.90,NULL),
('Figurine Trunks SS','goodies','image/Figurine Trunks SS.jpg',39.90,NULL),
('Figurine Freezer','goodies','image/Figurine Freezer.jpg',7.80,NULL),
('Figurine Son Goku SS3','goodies','image/Figurine Son Goku SS3.jpg',39.90,NULL),
('Figurines Goku UI Vs Jiren','goodies','image/Figurines Goku UI Vs Jiren Match Makers.jpg',67.80,NULL),
('Figurine Majin Buu','goodies','image/Figurine Majin Buu.jpg',37.80,NULL),
('Figurines Goten Trunks Fusion','goodies','image/Figurines Goten Trunks Fusion.jpg',49.80,NULL),
('Figurine Gotenks SS Ghost','goodies','image/Figurine Gotenks SS Ghost.jpg',39.80,NULL),
('Figurine Gotenks SS3','goodies','image/Figurine Gotenks SS3.jpg',47.80,NULL),
('Figurine Son Goku SSG','goodies','image/Figurine Son Goku SSG.jpg',47.80,NULL),
('Figurine Son Goku SSB','goodies','image/Figurine Son Goku SSB.jpg',47.80,NULL),
('Figurine Vegeta SSB','goodies','image/Figurine Vegeta SSB.jpg',47.80,NULL),
('Figurine Baby Vegeta SS2','goodies','image/Figurine Baby Vegeta SS2.jpg',47.80,NULL),
('Figurine Vegeto SS','goodies','image/Figurine Vegeto SS.jpg',59.80,NULL),
('Figurine Gogeta SS','goodies','image/Figurine Gogeta SS.jpg',47.80,NULL),
('Figurine Broly SS2','goodies','image/Figurine Broly SS2.jpg',47.80,NULL),
('Figurine Metal Cooler','goodies','image/Figurine Metal Cooler.jpg',43.80,NULL),
('Figurine Black Goku','goodies','image/Figurine Black Goku.jpg',47.80,NULL),
('Figurine Beerus','goodies','image/Figurine Beerus.jpg',47.80,NULL),
('Figurines Gohan Enfant SS2 Vs Cell','goodies','image/Figurines Gohan Enfant SS2 Vs Cell Match Makers.jpg',67.80,NULL),
('Figurines Gogeta Vs Janemba','goodies','image/Figurines Gogeta Janemba Match Makers.jpg',67.80,NULL),
('Tapis de Bureau Dragon Ball Super','goodies','image/Tapis de Bureau DBS.jpg',25.80,NULL),
('Sac Dragon Ball Super','goodies','image/Sac DBS.jpg',18.80,NULL),
('Sac de Sport Dragon Ball Z','goodies','image/Sac de Sport DBZ.jpg',35.80,NULL),
('Sac à Dos Goku','goodies','image/Sac à Dos Goku.jpg',29.80,NULL),
('Puzzle 1000 Pieces Dragon Ball Z','goodies','image/Puzzle 1000 Pieces DBZ.jpg',55.80,NULL),
('Jeu de 54 Cartes Dragon Ball Z','goodies','image/Jeu de 54 Cartes DBZ.jpg',25.80,NULL),
('Uno Dragon Ball Z','goodies','image/Uno DBZ.jpg',45.80,NULL),
('Jeu de 7 Familles Dragon Ball Z','goodies','image/Jeu de 7 Familles DBZ.jpg',25.80,NULL),
('Boite à Musique Tapion','goodies','image/Boite à Musique Tapion DBZ.jpg',59.80,NULL),
('Coffret 7 Boules de Cristal Dragon Ball Z','goodies','image/Coffret 7 Boules de Cristal DBZ.jpg',75.80,NULL),
('Boule de Cristal 2 Etoiles Dragon Ball Z','goodies','image/Boule De Cristal DBZ.jpg',21.80,NULL),
('Mug Thermique Gohan vs Cell','goodies','image/Mug Thermique Gohan Vs Cell.jpg',25.80,NULL),
('Mug Broly SS2','goodies','image/Mug Broly SS2.jpg',21.80,NULL),
('Mug Goku','goodies','image/Mug Goku.jpg',21.80,NULL),
('Mug Hit','goodies','image/Mug Hit.jpg',21.80,NULL),
('Boite à Cookies Kamehouse Dragon Ball Z','goodies','image/Boite à Cookies Kamehouse DBZ.jpg',75.80,NULL),
('Porte Cle Goku SSB','goodies','image/Porte Cle Goku SSB.jpg',11.80,NULL),
('Porte Cle Pop Goku SS4','goodies','image/Porte Cle Pop Goku SS4.jpg',15.80,NULL),
('Porte Cle Radar Dragon Ball Z','goodies','image/Porte Cle Radar DBZ.jpg',11.80,NULL),
('Peluche Nuage Magique Dragon Ball Z','goodies','image/Peluche Nuage Magique DBZ.jpg',33.80,NULL),
('Lots Figurines Dragon Ball Z','goodies','image/Lots Figurines DBZ.jpg',55.80,NULL),
('Bol Chapeau Luffy','vaisselle','image/Bol Chapeau Luffy.jpg',37.90,NULL),
('Mug One Piece','vaisselle','image/Mug One piece.jpg',35.90,NULL),
('Tasse et Bol One Piece','vaisselle','image/Tasse et Bol One Piece.jpg',45.50,NULL),
('Bol Drapeau One Piece','vaisselle','image/Bol Drapeau One Piece.jpg',35.80,NULL),
('Assiette One Piece','vaisselle','image/Assiette One Piece.jpg',220.90,NULL),
('Mug Thermique One Piece Wanted','vaisselle','image/Mug Thermique One Piece Wanted.jpg',38.80,NULL),
('Mug Luffy Gear 5 Attaque','vaisselle','image/Mug Luffy Gear 5 Attaque.jpg',27.90,NULL),
('Mug Monkey D Luffy','vaisselle','image/Mug Monkey D Luffy.jpg',27.80,NULL),
('Mug Luffy Zoro Chopper','vaisselle','image/Mug Luffy Zoro Chopper.jpg',27.80,NULL),
('Mug Chopper','vaisselle','image/Mug Chopper.jpg',27.80,NULL),
('Mug Garp','vaisselle','image/Mug Garp.jpg',27.80,NULL),
('Mug Barbe Noir','vaisselle','image/Mug Barbe Noir.jpg',27.80,NULL),
('Mug Trafalgar Law','vaisselle','image/Mug Trafalgar Law.jpg',27.80,NULL),
('Bol Konoha','vaisselle','image/Bol Konoha.jpg',32.80,NULL),
('Bol Akatsuki','vaisselle','image/Bol Akatsuki.jpg',32.80,NULL),
('Verre Akatsuki','vaisselle','image/Verre Akatsuki.jpg',35.80,NULL),
('Verre Uchiha','vaisselle','image/Verre Uchiha.jpg',35.80,NULL),
('Mug Thermique Sasuke Uchiha','vaisselle','image/Mug Thermique Sasuke.jpg',38.80,NULL),
('Mug Naruto Kakashi','vaisselle','image/Mug Naruto.jpeg',27.80,NULL),
('Mug Kunai Konoha','vaisselle','image/Mug Kunai Konoha.jpg',32.80,NULL),
('Mug Sceau Naruto','vaisselle','image/Mug Sceau Naruto.jpg',27.80,NULL),
('Boite Repas Dragon Ball Z','vaisselle','image/Boite Alimentaire Dragon Ball Z.jpg',58.80,NULL),
('Verre Vegeta','vaisselle','image/Verre Vegeta.jpg',35.80,NULL),
('Assiette Dragon Ball Z','vaisselle','image/Assiette Dragon Ball Z.jpg',42.80,NULL),
('Assiette Son Goku','vaisselle','image/Assiette Son Goku.jpg',42.80,NULL),
('Mug Dragon Ball Z','vaisselle','image/Mug Dragon Ball Z.jpg',27.80,NULL),
('Kit Anniversaire Demon Slayer','vaisselle','image/Kit Anniversaire Demon Slayer.jpg',127.80,NULL),
('Bol Tanjiro','vaisselle','image/Bol Tanjiro.png',32.80,NULL),
('Verre Demon Slayer','vaisselle','image/Verre Demon Slayer.jpg',35.80,NULL),
('Verre Itadori Sukuna','vaisselle','image/Verre Itadori Sukuna.jpg',35.80,NULL),
('Mug Doigt Sukuna','vaisselle','image/Mug Doigt Sukuna.jpg',32.80,NULL),
('Mug Nezuko Demon','vaisselle','image/Mug Nezuko Demon.jpg',27.80,NULL),
('Mug Tanjiro Zenitsu','vaisselle','image/Mug Tanjiro Zenitsu.jpg',27.80,NULL),
('Mug Mitsuri Kanroji','vaisselle','image/Mug Mitsuri Kanroji.jpg',27.80,NULL),
('Mug Nezuko','vaisselle','image/Mug Nezuko.jpg',27.80,NULL),
('Mug Tanjiro','vaisselle','image/Mug Tanjiro.jpg',27.80,NULL),
('Mug Tomyoka','vaisselle','image/Mug Tomyoka.jpg',27.80,NULL),
('Bol Pokemon','vaisselle','image/Bol Pokemon.jpg',32.80,NULL),
('Mug Pikachu','vaisselle','image/Mug Pikachu.jpg',27.80,NULL),
('Bol Death Note','vaisselle','image/Bol Death Note.jpg',32.80,NULL),
('Mug L','vaisselle','image/Mug L.jpg',27.80,NULL),
('Verre Tokyo Ghoul','vaisselle','image/Verre Tokyo Ghoul.jpg',35.80,NULL),
('Mug Tokyo Ghoul','vaisselle','image/Mug Tokyo Ghoul.jpg',27.80,NULL),
('Tasse et Bol My Hero Academia','vaisselle','image/Tasse et Bol My Hero Academia.jpg',45.80,NULL),
('Mug Saitama','vaisselle','image/Mug Saitama.jpg',27.80,NULL),
('Mug Dandadan','vaisselle','image/Mug Dandadan.jpg',27.80,NULL),
('Mug Assasination Classroom','vaisselle','image/Mug Assasination Classroom.jpg',27.80,NULL),
('Mug Spy Family','vaisselle','image/Mug Spy Family.jpg',27.80,NULL),
('Mug Sailor Moon','vaisselle','image/Mug Sailor Moon.jpg',27.80,NULL),
('Veste Luffy','textiles','image/Veste Luffy.jpg',147.90,NULL),
('Veste One Piece','textiles','image/Veste Symbole One Piece.jpg',147.90,NULL),
('Jogging One Piece','textiles','image/Jogging One Piece.jpg',228.50,NULL),
('Sweat Ace','textiles','image/Sweat Ace.jpg',87.80,NULL),
('Sweat Luffy Gear 5','textiles','image/Sweat Luffy Gear 5.jpg',77.80,NULL),
('Sweat One Piece','textiles','image/Sweat Symbole One Piece.jpg',77.80,NULL),
('Tee Shirt Luffy','textiles','image/Tee Shirt Logo Luffy.jpg',48.00,NULL),
('Pyjama Luffy','textiles','image/Pyjama Luffy.jpg',78.00,NULL),
('Tenue Luffy','textiles','image/Tenue Luffy.jpg',47.50,NULL),
('Costume Luffy','textiles','image/Costume Luffy.jpg',67.90,NULL),
('Costume Nami','textiles','image/Costume Nami.jpg',67.90,NULL),
('Costume Sanji','textiles','image/Costume Sanji.jpg',67.90,NULL),
('Costume Trafalgar Law','textiles','image/Costume Trafalgar Law.jpg',97.80,NULL),
('Parure Luffy Gear 5','textiles','image/Parure Luffy Gear 5.jpg',258.00,NULL),
('Parure Zoro','textiles','image/Parure Zoro.jpg',248.00,NULL),
('Parure One Piece','textiles','image/Parure One Piece.jpg',238.00,NULL),
('Doudoune Akatsuki','textiles','image/Doudoune Akastsuki.jpg',78.50,NULL),
('Jogging Naruto','textiles','image/Jogging Naruto.jpg',158.50,NULL),
('Sweat Naruto','textiles','image/Sweat Naruto.jpg',68.50,NULL),
('Tee Shirt Sasuke','textiles','image/Tee Shirt Sasuke.jpg',48.50,NULL),
('Pyjama Kurama','textiles','image/Pyjama Kurama.jpg',58.50,NULL),
('Costume Naruto','textiles','image/Costume Naruto.jpg',55.50,NULL),
('Costume Itachi','textiles','image/Costume Itachi.jpg',55.50,NULL),
('Parure Naruto','textiles','image/Parure Naruto.jpg',258.50,NULL),
('Parure Akatsuki','textiles','image/Parure Akatsuki.jpg',278.50,NULL),
('Parure Sasuke','textiles','image/Parure Sasuke.jpg',258.50,NULL),
('Veste Black Goku','textiles','image/Veste Black Goku.jpg',77.90,NULL),
('Jogging Dragon Ball Z','textiles','image/Jogging Dragon Ball Z.jpg',127.90,NULL),
('Sweat San Goku Ultra Instinct','textiles','image/Sweat San Goku Ultra Instinct.jpg',68.50,NULL),
('Tee Shirt Gogeta SSB','textiles','image/Tee Shirt Gogeta SSB.jpg',47.90,NULL),
('Pyjama San Goku','textiles','image/Pyjama San Goku.jpg',55.90,NULL),
('Costume San Goku','textiles','image/Costume San Goku.jpg',50.50,NULL),
('Costume Videl','textiles','image/Costume Videl.jpg',52.80,NULL),
('Parure San Goku Ultra Instinct','textiles','image/Parure San Goku Ultra Instinct.jpg',248.50,NULL),
('Parure Black Goku','textiles','image/Parure Black Goku.jpg',238.50,NULL),
('Parure San Goku SS4 Vegeta SS4','textiles','image/Parure San Goku SS4 Vegeta SS4.jpg',258.50,NULL),
('Veste Zenitsu','textiles','image/Veste Zeni''tsu.jpg',75.50,NULL),
('Jogging Nezuko','textiles','image/Jogging Nezuko.jpg',158.50,NULL),
('Sweat Tanjiro','textiles','image/Sweat Tanjiro.jpg',65.50,NULL),
('Tee Shirt Inosuke','textiles','image/Tee Shirt Inosuke.jpg',48.50,NULL),
('Pyjama Zenitsu','textiles','image/Pyjama Zeni''tsu.jpg',55.50,NULL),
('Costume Zenitsu','textiles','image/Costume Zeni''tsu.jpg',50.50,NULL),
('Costume Nezuko','textiles','image/Costume Nezuko.jpg', 60.50,NULL),
('Parure Demon Slayer','textiles','image/Parure Demon Slayer.jpg', 258.50,NULL),
('Parure Tanjiro Nezuko','textiles','image/Parure Tanjiro Nezuko.jpg', 268.50,NULL),
('Parure Nezuko','textiles','image/Parure Nezuko.jpg', 278.50,NULL),
('Veste One Punch Man','textiles','image/Veste One Punch Man.jpg', 75.50,NULL),
('Jogging Saitama','textiles','image/Jogging Saitama.jpg',158.50,NULL),
('Sweat Genos','textiles','image/Sweat Genos.jpg',65.50,NULL),
('Tee Shirt Garou','textiles','image/Tee Shirt Garou.jpg',48.50,NULL),
('Pyjama Saitama','textiles','image/Pyjama Saitama.jpg',55.50,NULL),
('Costume Saitama','textiles','image/Costume Saitama.jpg',50.50,NULL),
('Costume Tatsumaki','textiles','image/Costume Tatsumaki.jpg',60.50,NULL),
('Parure One Punch Man','textiles','image/Parure One Punch Man.jpg',258.50,NULL),
('Parure Saitama','textiles','image/Parure Saitama.jpg',268.50,NULL),
('Parure Genos','textiles','image/Parure Genos.jpg',278.50,NULL),
('Veste Solo Leveling','textiles','image/Veste Solo Leveling.jpg',75.50,NULL),
('Jogging Solo Leveling','textiles','image/Jogging Solo Leveling.jpg',158.50,NULL),
('Sweat Sung Jin Hoo','textiles','image/Sweat Sung Jin Hoo.jpg',65.50,NULL),
('Tee Shirt Sung Jin Hoo','textiles','image/Tee Shirt Sung Jin Hoo.jpg',48.50,NULL),
('Pyjama Solo Leveling','textiles','image/Pyjama Solo Leveling.jpg',55.50,NULL),
('Costume Sung Jin Hoo','textiles','image/Costume Sung Jin Hoo.jpg',50.50,NULL),
('Costume Cha Hae In','textiles','image/Costume Cha Hae In.jpg',60.50,NULL),
('Parure Sung Jin Hoo','textiles','image/Parure Sung Jin Hoo.jpg',258.50,NULL),
('Parure Solo Leveling','textiles','image/Parure Solo Leveling.jpg',268.50,NULL),
('Parure Sung Jin Hoo Black','textiles','image/Parure Sung Jin Hoo Black.jpg',278.50,NULL);

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

/* ======================================================================================= */
/* ======================================================================================= */
