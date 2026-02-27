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
('Sekai Saisoku no Isekai Ryokouki','manga',NULL,'image/sekai_saisoku_no_isekai_ryokouki.jpg',7.80,'Lundi'),
('Ordeal','manga',NULL,'image/ordeal.jpg',7.80,'Lundi'),
('Blue Box','manga',NULL,'image/blue_box.jpg',7.80,'Lundi'),
('Nyaight of the Living Cat','manga',NULL,'image/nyaight_of_the_living_cat.jpg',7.80,'Lundi'),
('Juvenile Detention Center','manga',NULL,'image/juvenile_detention_center.jpg',7.80,'Lundi'),
('Maybe Meant','manga',NULL,'image/maybe_meant.jpg',7.80,'Lundi'),
('Tonikaku Kuwai','manga',NULL,'image/tonikaku_kuwai.jpeg',7.80,'Lundi'),
('To Your Eternity','manga',NULL,'image/to_your_eternity.jpeg',7.80,'Lundi'),
('Yano Kun no','manga',NULL,'image/yano_kun_no.jpg',7.80,'Mardi'),
('Return to Player','manga',NULL,'image/return_to_player.jpg',7.80,'Mardi'),
('Manager Kim','manga',NULL,'image/manager_kim.jpg',7.80,'Mardi'),
('Hero Without a Class','manga',NULL,'image/hero_without_a_class.jpg',7.80,'Mardi'),
('Let''s Play','manga',NULL,'image/lets_play.jpg''s play tome 1.jpg',7.80,'Mardi'),
('Afterlife Inn Cooking','manga',NULL,'image/afterlife_inn_cooking.jpg',7.80,'Mardi'),
('Rent a Girl','manga',NULL,'image/rent_a_girl.jpg',7.80,'Mardi'),
('A Couple of Cuckoos','manga',NULL,'image/a_couple_of_cuckoos.jpg',7.80,'Mardi'),
('99 Reinforced Wood Stick','manga',NULL,'image/99_reinforced_wood_stick.jpeg',7.80,'Mercredi'),
('Baek','manga',NULL,'image/baek.jpeg',7.80,'Mercredi'),
('Surviving the Game As','manga',NULL,'image/surviving_the_game_as.jpeg',7.80,'Mercredi'),
('The Druid of Seoul Station','manga',NULL,'image/the_druid_of_seoul_station.jpeg',7.80,'Mercredi'),
('The Mafia Nanny','manga',NULL,'image/the_mafia_nanny.jpeg',7.80,'Mercredi'),
('Umamusume Cinderella Gray','manga',NULL,'image/umamusume_cinderella_gray.jpeg',7.80,'Mercredi'),
('Blue Orchestra','manga',NULL,'image/blue_orchestra.jpeg',7.80,'Mercredi'),
('Hero Ticket','manga',NULL,'image/hero_ticket.jpeg',7.80,'Mercredi'),
('Dr. Stone','manga',NULL,'image/dr_stone.jpeg',7.90,'Jeudi'),
('Futari Solo Camp','manga',NULL,'image/futari_solo_camp.jpeg',7.80,'Jeudi'),
('Past the Monster Meat','manga',NULL,'image/past_the_monster_meat.jpeg',7.80,'Jeudi'),
('The Rising of the Shield Hero','manga',NULL,'image/the_rising_of_the_shield_hero.jpeg',7.90,'Jeudi'),
('I Was Reincarnated as the 7th Prince','manga',NULL,'image/i_was_reincarnated_as_the_7th_prince.jpeg',7.80,'Jeudi'),
('Reborn as a Vending Machine','manga',NULL,'image/reborn_as_a_vending_machine.jpeg',7.80,'Jeudi'),
('Dreaming Freedom','manga',NULL,'image/dreaming_freedom.jpeg',7.80,'Jeudi'),
('Dragon Raja','manga',NULL,'image/dragon_raja.jpeg',7.90,'Vendredi'),
('Cat''s Eyes 2025','manga',NULL,'image/cats_eyes_2025.jpeg''s eyes 2025 tome 1.jpeg',7.80,'Vendredi'),
('Watari Kun no XX ga Houkai Sunzen','manga',NULL,'image/watari_kun_no_xx_ga_houkai_sunzen.jpeg',7.90,'Vendredi'),
('Tsubasa Chronicle','manga',NULL,'image/tsubasa_chronicle.jpeg',7.90,'Vendredi'),
('May I Ask for One Final Thing','manga',NULL,'image/may_i_ask_for_one_final_thing.jpeg',7.80,'Vendredi'),
('One Piece','manga',NULL,'image/one_piece.jpeg',7.90,'Vendredi'),
('Study Group','manga',NULL,'image/study_group.jpeg',7.80,'Vendredi'),
('Lord of Mysteries','manga',NULL,'image/lord_of_mysteries.jpeg',7.90,'Samedi'),
('Détective Conan','manga',NULL,'image/detective_conan.jpeg',7.90,'Samedi'),
('A Wild Last Boss Appeared','manga',NULL,'image/a_wild_last_boss_appeared.jpeg',7.80,'Samedi'),
('Silent Witch','manga',NULL,'image/silent_witch.jpeg',7.80,'Samedi'),
('Kingdom','manga',NULL,'image/kingdom.jpeg',7.90,'Samedi'),
('My Hero Academia','manga',NULL,'image/my_hero_academia.jpeg',7.90,'Samedi'),
('Spy x Family','manga',NULL,'image/spy_x_family.jpeg',7.90,'Samedi'),
('Let This Grieving Soul Retire','manga',NULL,'image/let_this_grieving_soul_retire.jpeg',7.80,'Samedi'),
('Witch Watch','manga',NULL,'image/witch_watch.jpeg',7.90,'Dimanche'),
('My Dress Up Darling','manga',NULL,'image/my_dress_up_darling.jpeg',7.90,'Dimanche'),
('Rascal Does Not Dream of Bunny Girl Senpai','manga',NULL,'image/rascal_does_not_dream_of_bunny_girl_senpai.jpeg',8.50,'Dimanche'),
('Gachiakuta','manga',NULL,'image/gachiakuta.jpeg',7.80,'Dimanche'),
('Be a Princess Someday','manga',NULL,'image/be_a_princess_someday.jpeg',7.90,'Dimanche'),
('Kikaijikake no Marie','manga',NULL,'image/kikaijikake_no_marie.jpeg',7.80,'Dimanche'),
('Alma Chan wa Kazoku ni Naritai','manga',NULL,'image/alma_chan_wa_kazoku_ni_naritai.jpeg',7.90,'Dimanche'),
('Dad is a Hero, Mom is a Spring, I''m a','manga',NULL,'image/dad_is_a_hero_mom_is_a_spring_im_a.jpeg''m a tome 1.jpeg',7.80,'Dimanche'),
('Chain Saw','manga',NULL,'image/chain_saw.jpg',7.90,'Sans jour fixe'),
('Fairy Tail 100 Years Quest','manga',NULL,'image/fairy_tail_100_years_quest.jpg',7.90,'Sans jour fixe'),
('Four Knights of the Apocalypse','manga',NULL,'image/four_knights_of_the_apocalypse.jpg',8.50,'Sans jour fixe'),
('Blue Lock','manga',NULL,'image/blue_lock.jpg',7.90,'Sans jour fixe'),
('Embers','manga',NULL,'image/embers.jpg',7.80,'Sans jour fixe'),
('I''m the Max Level Newbie','manga',NULL,'image/im_the_max_level_newbie.jpg''m the max level newbie tome 1.jpg',8.00,'Sans jour fixe'),
('Infinite Mage','manga',NULL,'image/infinite_mage.jpg',7.90,'Sans jour fixe'),
('Itchi the Witch','manga',NULL,'image/itchi_the_witch.jpg',7.50,'Sans jour fixe'),
('Kaoru Hana wa Rin to Saku','manga',NULL,'image/kaoru_hana_wa_rin_to_saku.jpg',7.90,'Sans jour fixe'),
('Lecteur Omniscient','manga',NULL,'image/lecteur_omniscient.jpg',8.00,'Sans jour fixe'),
('Nano Machine','manga',NULL,'image/nano_machine.jpg',7.80,'Sans jour fixe'),
('Nebula''s Civilation','manga',NULL,'image/nebulas_civilation.jpg''s civilation tome 1.jpg',8.00,'Sans jour fixe'),
('Pick Me Up','manga',NULL,'image/pick_me_up.jpg',7.90,'Sans jour fixe'),
('Player','manga',NULL,'image/player.jpg',7.90,'Sans jour fixe'),
('Player Who Returned 10000 Year Later','manga',NULL,'image/player_who_returned_10000_year_later.jpg',8.50,'Sans jour fixe'),
('Reality Quest','manga',NULL,'image/reality_quest.jpg',7.90,'Sans jour fixe'),
('Solo Leveling','manga',NULL,'image/solo_leveling.jpeg',8.50,'Sans jour fixe'),
('Wind Breaker','manga',NULL,'image/wind_breaker.jpg',7.80,'Sans jour fixe'),
('The Beginning After the End','manga',NULL,'image/the_beginning_after_the_end.jpg',8.50,'Sans jour fixe'),
('Tougen Anki','manga',NULL,'image/tougen_anki.jpg',7.90,'Sans jour fixe'),
('Shangri-La Frontier','manga',NULL,'image/shangrila_frontier.jpeg',8.00,'Sans jour fixe'),
('Dragon Ball','manga',NULL,'image/dragon_ball.jpeg',6.90,NULL),
('Dragon Ball Z','manga',NULL,'image/dragon_ball_z.jpeg',7.10,NULL),
('Naruto','manga',NULL,'image/naruto.jpeg',7.50,NULL),
('Naruto Shippuden','manga',NULL,'image/naruto_shippuden.jpeg',7.90,NULL),
('Bleach','manga',NULL,'image/bleach.jpeg',7.30,NULL),
('Pokémon','manga',NULL,'image/pokemon.jpeg',6.50,NULL),
('Ranma ½','manga',NULL,'image/ranma.jpeg',7.40,NULL),
('Yu-Gi-Oh','manga',NULL,'image/yugioh.jpeg',7.00,NULL),
('Great Teacher Onizuka','manga',NULL,'image/great_teacher_onizuka.jpeg',8.20,NULL),
('Death Note','manga',NULL,'image/death_note.jpeg',6.90,NULL),
('Hajime No Ippo','manga',NULL,'image/hajime_no_ippo.jpeg',8.90,NULL),
('Ken le Survivant','manga',NULL,'image/ken_le_survivant.jpeg',8.50,NULL),
('Gundam Wing','manga',NULL,'image/gundam_wing.jpeg',8.00,NULL),
('Full Metal Alchemist','manga',NULL,'image/full_metal_alchemist.jpeg',8.00,NULL),
('Fairy Tail','manga',NULL,'image/fairy_tail.jpeg',7.50,NULL),
('One Punch Man','manga',NULL,'image/one_punch_man.jpeg',8.50,NULL),
('Afro Samouraï','manga',NULL,'image/Afro-Samourai-Tome.jpeg',9.10,NULL),
('Hunter-X-Hunter','manga',NULL,'image/hunterxhunter.jpeg',7.80,NULL),
('Moi Quand Je Me Reincarne En Slime','manga',NULL,'image/moi_quand_je_me_reincarne_en_slime.jpeg',7.80,NULL),
('Nicky Larson','manga',NULL,'image/nicky_larson.jpeg',7.80,NULL),
('Saint Seya Les Chevaliers Du Zodiaque','manga',NULL,'image/saint_seya_les_chevaliers_du_zodiaque.jpeg',7.80,NULL),
('Sailor-Moon','manga',NULL,'image/sailormoon.jpeg',7.80,NULL),
('Pop Naruto - Edition limitée','figurine',NULL,'image/pop_naruto_edition_limitee.jpeg',29.90,NULL),
('Figurine Itachi + Peluche Kuruma','figurine',NULL,'image/figurine_itachi_peluche_kuruma.jpeg',52.50,NULL),
('Figurine Jiraya','figurine',NULL,'image/figurine_jiraya.jpeg',25.90,NULL),
('Figurine Naruto Mode Emite','figurine',NULL,'image/figurine_naruto_mode_emite.jpeg',35.90,NULL),
('Jeu de société Naruto','goodies','naruto','image/jeu_de_societe_naruto.jpeg',56.50,NULL),
('Katana Konoha','goodies','naruto','image/katana_konoha.jpeg',74.90,NULL),
('Sac Naruto','goodies','naruto','image/sac_naruto.jpeg',34.90,NULL),
('Porte clé Pop Naruto','goodies','naruto','image/porte_cle_pop_naruto.jpeg',14.90,NULL),
('Mug Naruto Equipe 7','goodies','naruto','image/mug_naruto_equipe_7.jpeg',9.90,NULL),
('Bandeau Sasuke','goodies','naruto','image/bandeau_sasuke.jpeg',44.90,NULL),
('Kunai Naruto','goodies','naruto','image/kunai_naruto.jpeg',54.90,NULL),
('Figurine Satoru Gojo','figurine',NULL,'image/figurine_satoru_gojo.jpeg',17.80,NULL),
('Lampe Satoru Gojo','goodies','jujutsu_kaisen','image/lampe_satoru_gojo.jpeg',27.80,NULL),
('Mug Itadori','goodies','jujutsu_kaisen','image/mug_itadori.jpg',9.80,NULL),
('Sac à Dos Jujutsu Kaisen','goodies','jujutsu_kaisen','image/sac_a_dos_jujutsu_kaisen.jpeg',47.80,NULL),
('Lots Bagues Jujutsu Kaisen','goodies','jujutsu_kaisen','image/lots_bagues_jujutsu_kaisen.jpeg',37.80,NULL),
('Mug Satoru Gojo','goodies','jujutsu_kaisen','image/mug_satoru_gojo.jpeg',18.80,NULL),
('Figurine Pop Sukuna','figurine',NULL,'image/figurine_pop_sukuna.jpeg',27.80,NULL),
('Figurine Pop Megumi','figurine',NULL,'image/figurine_pop_megumi.jpeg',27.80,NULL),
('Bateau Thousant Sunny','goodies','one_piece','image/bateau_thousant_sunny.jpeg',87.80,NULL),
('Coffre au Trésor One Piece','goodies','one_piece','image/coffre_au_tresor_one_piece.jpeg',97.80,NULL),
('Verre One Piece','goodies','one_piece','image/verre_one_piece.jpeg',7.80,NULL),
('Fruits des Demons','goodies','one_piece','image/fruits_des_demons.jpeg',47.80,NULL),
('Peluche Fruit du Démon','goodies','one_piece','image/peluche_fruit_du_demon.jpeg',29.80,NULL),
('Chapeau Luffy','goodies','one_piece','image/chapeau_luffy.jpeg',54.80,NULL),
('Support Portable Luffy Gear 5','goodies','one_piece','image/support_portable_luffy_gear_5.jpeg',25.80,NULL),
('Coque Portable One Piece','goodies','one_piece','image/coque_portable_one_piece.jpeg',17.80,NULL),
('Sac à Dos One Piece','goodies','one_piece','image/sac_a_dos_one_piece.jpeg',45.80,NULL),
('Lots Mugs One Piece','goodies','one_piece','image/lots_mugs_one_piece.jpeg',77.80,NULL),
('Lampe Luffy Gear 5','goodies','one_piece','image/lampe_luffy_gear_5.jpeg',44.80,NULL),
('Bague One Piece','goodies','one_piece','image/bague_one_piece.jpeg',25.80,NULL),
('Porte Feuille One Piece','goodies','one_piece','image/porte_feuille_one_piece.jpeg',45.80,NULL),
('Manette PS5 One Piece','goodies','one_piece','image/manette_ps5_one_piece.jpeg',125.80,NULL),
('Figurine Led Luffy Gear 5','figurine',NULL,'image/figurine_led_luffy_gear_5.jpeg',67.80,NULL),
('Figurine Pop Luffy','figurine',NULL,'image/figurine_pop_luffy.jpeg',27.80,NULL),
('Figurine Ace','figurine',NULL,'image/figurine_ace.jpeg',27.80,NULL),
('Figurine Jinbe','figurine',NULL,'image/figurine_jinbe.jpeg',37.80,NULL),
('Figurine Ener','figurine',NULL,'image/figurine_ener.jpeg',37.80,NULL),
('Figurine Pop Kaido','figurine',NULL,'image/figurine_pop_kaido.jpeg',27.80,NULL),
('Figurine Luffy Gear 5','figurine',NULL,'image/figurine_luffy_gear_5.jpeg',39.80,NULL),
('Figurine Mihawk','figurine',NULL,'image/figurine_mihawk.jpeg',39.80,NULL),
('Figurine Pop Zoro','figurine',NULL,'image/figurine_pop_zoro.jpeg',27.80,NULL),
('Figurine Barbe Noir','figurine',NULL,'image/figurine_barbe_noir.jpeg',37.80,NULL),
('Lots Portes Clés Demon Slayer','goodies','demon_slayer','image/lots_portes_cles_demon_slayer.jpeg',27.80,NULL),
('Katana Tanjiro','goodies','demon_slayer','image/katana_tanjiro.jpg',107.80,NULL),
('Coffret 15 Piece Demon Slayer','goodies','demon_slayer','image/coffret_15_piece_demon_slayer.jpeg',79.80,NULL),
('Coffret Demon Slayer','goodies','demon_slayer','image/coffret_demon_slayer.jpeg',59.80,NULL),
('Figurine Tanjiro','figurine',NULL,'image/figurine_tanjiro.jpeg',37.90,NULL),
('Figurine Pop Tanjiro Nezuko','figurine',NULL,'image/figurine_pop_tanjiro_nezuko.jpeg',39.80,NULL),
('Figurine Nezuko','figurine',NULL,'image/figurine_nezuko.jpeg',29.90,NULL),
('Figurine Inosuke','figurine',NULL,'image/figurine_inosuke.jpeg',29.80,NULL),
('Figurine Sabito','figurine',NULL,'image/figurine_sabito.jpeg',29.80,NULL),
('Figurine Tengen','figurine',NULL,'image/figurine_tengen.jpeg',29.80,NULL),
('Figurine Tomyoka','figurine',NULL,'image/figurine_tomyoka.jpeg',29.80,NULL),
('Figurine Muichiro','figurine',NULL,'image/figurine_muichiro.jpeg',29.80,NULL),
('Figurine Sanemi','figurine',NULL,'image/figurine_sanemi.jpeg',29.80,NULL),
('Figurine Kanroji','figurine',NULL,'image/figurine_kanroji.jpg',29.80,NULL),
('Figurine Zenitsu','figurine',NULL,'image/figurine_zenitsu.jpeg',29.80,NULL),
('Figurine Pop Goku Ultra Instinct','figurine',NULL,'image/figurine_pop_goku_ultra_instinct.jpg',27.90,NULL),
('Figurine Pop M Vegeta','figurine',NULL,'image/figurine_pop_m_vegeta.jpg',27.90,NULL),
('Figurine Gogeta SS4','figurine',NULL,'image/figurine_gogeta_ss4.jpg',37.80,NULL),
('Figurine Broly Fullpower','figurine',NULL,'image/figurine_broly_fullpower.jpg',37.90,NULL),
('Figurine Trunks SS','figurine',NULL,'image/figurine_trunks_ss.jpg',39.90,NULL),
('Figurine Freezer','figurine',NULL,'image/figurine_freezer.jpg',7.80,NULL),
('Figurine Son Goku SS3','figurine',NULL,'image/figurine_son_goku_ss3.jpg',39.90,NULL),
('Figurine Goku UI Vs Jiren','figurine',NULL,'image/figurine_goku_ui_vs_jiren.jpg',67.80,NULL),
('Figurine Majin Buu','figurine',NULL,'image/figurine_majin_buu.jpg',37.80,NULL),
('Figurine Goten Trunks Fusion','figurine',NULL,'image/figurine_goten_trunks_fusion.jpg',49.80,NULL),
('Figurine Gotenks SS Ghost','figurine',NULL,'image/figurine_gotenks_ss_ghost.jpg',39.80,NULL),
('Figurine Gotenks SS3','figurine',NULL,'image/figurine_gotenks_ss3.jpg',47.80,NULL),
('Figurine Son Goku SSG','figurine',NULL,'image/figurine_son_goku_ssg.jpg',47.80,NULL),
('Figurine Son Goku SSB','figurine',NULL,'image/figurine_son_goku_ssb.jpg',47.80,NULL),
('Figurine Vegeta SSB','figurine',NULL,'image/figurine_vegeta_ssb.jpg',47.80,NULL),
('Figurine Baby Vegeta SS2','figurine',NULL,'image/figurine_baby_vegeta_ss2.jpg',47.80,NULL),
('Figurine Vegeto SS','figurine',NULL,'image/figurine_vegeto_ss.jpg',59.80,NULL),
('Figurine Gogeta SS','figurine',NULL,'image/figurine_gogeta_ss.jpg',47.80,NULL),
('Figurine Broly SS2','figurine',NULL,'image/figurine_broly_ss2.jpg',47.80,NULL),
('Figurine Metal Cooler','figurine',NULL,'image/figurine_metal_cooler.jpg',43.80,NULL),
('Figurine Black Goku','figurine',NULL,'image/figurine_black_goku.jpg',47.80,NULL),
('Figurine Beerus','figurine',NULL,'image/figurine_beerus.jpg',47.80,NULL),
('Figurine Gohan Enfant SS2 Vs Cell','figurine',NULL,'image/Figurine Gohan Enfant SS2 Vs Cell.jpg',67.80,NULL),
('Figurine Gogeta Vs Janemba','figurine',NULL,'image/Figurine Gogeta Janemba.jpg',67.80,NULL),
('Tapis de Bureau Dragon Ball Super','goodies','dragon_ball','image/tapis_de_bureau_dragon_ball_super.jpg',25.80,NULL),
('Sac Dragon Ball Super','goodies','dragon_ball','image/sac_dragon_ball_super.jpg',18.80,NULL),
('Sac de Sport Dragon Ball Z','goodies','dragon_ball','image/sac_de_sport_dragon_ball_z.jpg',35.80,NULL),
('Sac à Dos Goku','goodies','dragon_ball','image/sac_a_dos_goku.jpg',29.80,NULL),
('Puzzle 1000 Pieces Dragon Ball Z','goodies','dragon_ball','image/puzzle_1000_pieces_dragon_ball_z.jpg',55.80,NULL),
('Jeu de 54 Cartes Dragon Ball Z','goodies','dragon_ball','image/jeu_de_54_cartes_dragon_ball_z.jpg',25.80,NULL),
('Uno Dragon Ball Z','goodies','dragon_ball','image/uno_dragon_ball_z.jpg',45.80,NULL),
('Jeu de 7 Familles Dragon Ball Z','goodies','dragon_ball','image/jeu_de_7_familles_dragon_ball_z.jpg',25.80,NULL),
('Boite à Musique Tapion','goodies','dragon_ball','image/boite_a_musique_tapion.jpg',59.80,NULL),
('Coffret 7 Boules de Cristal Dragon Ball Z','goodies','dragon_ball','image/coffret_7_boules_de_cristal_dragon_ball_z.jpg',75.80,NULL),
('Boule de Cristal 2 Etoiles Dragon Ball Z','goodies','dragon_ball','image/boule_de_cristal_2_etoiles_dragon_ball_z.jpg',21.80,NULL),
('Mug Thermique Gohan vs Cell','vaisselle',NULL,'image/mug_thermique_gohan_vs_cell.jpg',25.80,NULL),
('Mug Broly SS2','vaisselle',NULL,'image/mug_broly_ss2.jpg',21.80,NULL),
('Mug Goku','vaisselle',NULL,'image/mug_goku.jpg',21.80,NULL),
('Mug Hit','vaisselle',NULL,'image/mug_hit.jpg',21.80,NULL),
('Boite à Cookies Kamehouse Dragon Ball Z','goodies','dragon_ball','image/boite_a_cookies_kamehouse_dragon_ball_z.jpg',75.80,NULL),
('Porte Cle Goku SSB','goodies','dragon_ball','image/porte_cle_goku_ssb.jpg',11.80,NULL),
('Porte Cle Pop Goku SS4','goodies','dragon_ball','image/porte_cle_pop_goku_ss4.jpg',15.80,NULL),
('Porte Cle Radar Dragon Ball Z','goodies','dragon_ball','image/porte_cle_radar_dragon_ball_z.jpg',11.80,NULL),
('Peluche Nuage Magique Dragon Ball Z','goodies','dragon_ball','image/peluche_nuage_magique_dragon_ball_z.jpg',33.80,NULL),
('Lots Figurines Dragon Ball Z','goodies','dragon_ball','image/lots_figurines_dragon_ball_z.jpg',55.80,NULL),
('Bol Chapeau Luffy','vaisselle',NULL,'image/bol_chapeau_luffy.jpg',37.90,NULL),
('Mug One Piece','vaisselle',NULL,'image/mug_one_piece.jpg',35.90,NULL),
('Tasse et Bol One Piece','vaisselle',NULL,'image/tasse_et_bol_one_piece.jpg',45.50,NULL),
('Bol Drapeau One Piece','vaisselle',NULL,'image/bol_drapeau_one_piece.jpg',35.80,NULL),
('Assiette One Piece','vaisselle',NULL,'image/assiette_one_piece.jpg',220.90,NULL),
('Mug Thermique One Piece Wanted','vaisselle',NULL,'image/mug_thermique_one_piece_wanted.jpg',38.80,NULL),
('Mug Luffy Gear 5 Attaque','vaisselle',NULL,'image/mug_luffy_gear_5_attaque.jpg',27.90,NULL),
('Mug Monkey D Luffy','vaisselle',NULL,'image/mug_monkey_d_luffy.jpg',27.80,NULL),
('Mug Luffy Zoro Chopper','vaisselle',NULL,'image/mug_luffy_zoro_chopper.jpg',27.80,NULL),
('Mug Chopper','vaisselle',NULL,'image/mug_chopper.jpg',27.80,NULL),
('Mug Garp','vaisselle',NULL,'image/mug_garp.jpg',27.80,NULL),
('Mug Barbe Noir','vaisselle',NULL,'image/mug_barbe_noir.jpg',27.80,NULL),
('Mug Trafalgar Law','vaisselle',NULL,'image/mug_trafalgar_law.jpg',27.80,NULL),
('Bol Konoha','vaisselle',NULL,'image/bol_konoha.jpg',32.80,NULL),
('Bol Akatsuki','vaisselle',NULL,'image/bol_akatsuki.jpg',32.80,NULL),
('Verre Akatsuki','vaisselle',NULL,'image/verre_akatsuki.jpg',35.80,NULL),
('Verre Uchiha','vaisselle',NULL,'image/verre_uchiha.jpg',35.80,NULL),
('Mug Thermique Sasuke Uchiha','vaisselle',NULL,'image/mug_thermique_sasuke_uchiha.jpg',38.80,NULL),
('Mug Naruto Kakashi','vaisselle',NULL,'image/mug_naruto_kakashi.jpeg',27.80,NULL),
('Mug Kunai Konoha','vaisselle',NULL,'image/mug_kunai_konoha.jpg',32.80,NULL),
('Mug Sceau Naruto','vaisselle',NULL,'image/mug_sceau_naruto.jpg',27.80,NULL),
('Boite Repas Dragon Ball Z','vaisselle',NULL,'image/boite_repas_dragon_ball_z.jpg',58.80,NULL),
('Verre Vegeta','vaisselle',NULL,'image/verre_vegeta.jpg',35.80,NULL),
('Assiette Dragon Ball Z','vaisselle',NULL,'image/assiette_dragon_ball_z.jpg',42.80,NULL),
('Assiette Son Goku','vaisselle',NULL,'image/assiette_son_goku.jpg',42.80,NULL),
('Mug Dragon Ball Z','vaisselle',NULL,'image/mug_dragon_ball_z.jpg',27.80,NULL),
('Kit Anniversaire Demon Slayer','vaisselle',NULL,'image/kit_anniversaire_demon_slayer.jpg',127.80,NULL),
('Bol Tanjiro','vaisselle',NULL,'image/bol_tanjiro.png',32.80,NULL),
('Verre Demon Slayer','vaisselle',NULL,'image/verre_demon_slayer.jpg',35.80,NULL),
('Verre Itadori Sukuna','vaisselle',NULL,'image/verre_itadori_sukuna.jpg',35.80,NULL),
('Mug Doigt Sukuna','vaisselle',NULL,'image/Mug Doigt Sukuna.jpg',32.80,NULL),
('Mug Nezuko Demon','vaisselle',NULL,'image/mug_nezuko_demon.jpg',27.80,NULL),
('Mug Tanjiro Zenitsu','vaisselle',NULL,'image/mug_tanjiro_zenitsu.jpg',27.80,NULL),
('Mug Mitsuri Kanroji','vaisselle',NULL,'image/mug_mitsuri_kanroji.jpg',27.80,NULL),
('Mug Nezuko','vaisselle',NULL,'image/mug_nezuko.jpg',27.80,NULL),
('Mug Tanjiro','vaisselle',NULL,'image/mug_tanjiro.jpg',27.80,NULL),
('Mug Tomyoka','vaisselle',NULL,'image/mug_tomyoka.jpg',27.80,NULL),
('Bol Pokemon','vaisselle',NULL,'image/bol_pokemon.jpg',32.80,NULL),
('Mug Pikachu','vaisselle',NULL,'image/mug_pikachu.jpg',27.80,NULL),
('Bol Death Note','vaisselle',NULL,'image/bol_death_note.jpg',32.80,NULL),
('Mug L','vaisselle',NULL,'image/mug_l.jpg',27.80,NULL),
('Verre Tokyo Ghoul','vaisselle',NULL,'image/verre_tokyo_ghoul.jpg',35.80,NULL),
('Mug Tokyo Ghoul','vaisselle',NULL,'image/mug_tokyo_ghoul.jpg',27.80,NULL),
('Tasse et Bol My Hero Academia','vaisselle',NULL,'image/tasse_et_bol_my_hero_academia.jpg',45.80,NULL),
('Mug Saitama','vaisselle',NULL,'image/mug_saitama.jpg',27.80,NULL),
('Mug Dandadan','vaisselle',NULL,'image/mug_dandadan.jpg',27.80,NULL),
('Mug Assasination Classroom','vaisselle',NULL,'image/mug_assasination_classroom.jpg',27.80,NULL),
('Mug Spy Family','vaisselle',NULL,'image/mug_spy_family.jpg',27.80,NULL),
('Mug Sailor Moon','vaisselle',NULL,'image/mug_sailor_moon.jpg',27.80,NULL),
('Veste Luffy','textiles',NULL,'image/veste_luffy.jpg',147.90,NULL),
('Veste One Piece','textiles',NULL,'image/veste_one_piece.jpg',147.90,NULL),
('Jogging One Piece','textiles',NULL,'image/jogging_one_piece.jpg',228.50,NULL),
('Sweat Ace','textiles',NULL,'image/sweat_ace.jpg',87.80,NULL),
('Sweat Luffy Gear 5','textiles',NULL,'image/sweat_luffy_gear_5.jpg',77.80,NULL),
('Sweat One Piece','textiles',NULL,'image/sweat_one_piece.jpg',77.80,NULL),
('Tee Shirt Luffy','textiles',NULL,'image/tee_shirt_luffy.jpg',48.00,NULL),
('Pyjama Luffy','textiles',NULL,'image/pyjama_luffy.jpg',78.00,NULL),
('Tenue Luffy','textiles',NULL,'image/tenue_luffy.jpg',47.50,NULL),
('Costume Luffy','textiles',NULL,'image/costume_luffy.jpg',67.90,NULL),
('Costume Nami','textiles',NULL,'image/costume_nami.jpg',67.90,NULL),
('Costume Sanji','textiles',NULL,'image/costume_sanji.jpg',67.90,NULL),
('Costume Trafalgar Law','textiles',NULL,'image/costume_trafalgar_law.jpg',97.80,NULL),
('Parure Luffy Gear 5','textiles',NULL,'image/parure_luffy_gear_5.jpg',258.00,NULL),
('Parure Zoro','textiles',NULL,'image/parure_zoro.jpg',248.00,NULL),
('Parure One Piece','textiles',NULL,'image/parure_one_piece.jpg',238.00,NULL),
('Doudoune Akatsuki','textiles',NULL,'image/doudoune_akatsuki.jpg',78.50,NULL),
('Jogging Naruto','textiles',NULL,'image/jogging_naruto.jpg',158.50,NULL),
('Sweat Naruto','textiles',NULL,'image/sweat_naruto.jpg',68.50,NULL),
('Tee Shirt Sasuke','textiles',NULL,'image/tee_shirt_sasuke.jpg',48.50,NULL),
('Pyjama Kurama','textiles',NULL,'image/pyjama_kurama.jpg',58.50,NULL),
('Costume Naruto','textiles',NULL,'image/costume_naruto.jpg',55.50,NULL),
('Costume Itachi','textiles',NULL,'image/costume_itachi.jpg',55.50,NULL),
('Parure Naruto','textiles',NULL,'image/parure_naruto.jpg',258.50,NULL),
('Parure Akatsuki','textiles',NULL,'image/parure_akatsuki.jpg',278.50,NULL),
('Parure Sasuke','textiles',NULL,'image/parure_sasuke.jpg',258.50,NULL),
('Veste Black Goku','textiles',NULL,'image/veste_black_goku.jpg',77.90,NULL),
('Jogging Dragon Ball Z','textiles',NULL,'image/jogging_dragon_ball_z.jpg',127.90,NULL),
('Sweat San Goku Ultra Instinct','textiles',NULL,'image/sweat_san_goku_ultra_instinct.jpg',68.50,NULL),
('Tee Shirt Gogeta SSB','textiles',NULL,'image/tee_shirt_gogeta_ssb.jpg',47.90,NULL),
('Pyjama San Goku','textiles',NULL,'image/pyjama_san_goku.jpg',55.90,NULL),
('Costume San Goku','textiles',NULL,'image/costume_san_goku.jpg',50.50,NULL),
('Costume Videl','textiles',NULL,'image/costume_videl.jpg',52.80,NULL),
('Parure San Goku Ultra Instinct','textiles',NULL,'image/parure_san_goku_ultra_instinct.jpg',248.50,NULL),
('Parure Black Goku','textiles',NULL,'image/parure_black_goku.jpg',238.50,NULL),
('Parure San Goku SS4 Vegeta SS4','textiles',NULL,'image/parure_san_goku_ss4_vegeta_ss4.jpg',258.50,NULL),
('Veste Zenitsu','textiles',NULL,'image/veste_zenitsu.jpg''tsu.jpg',75.50,NULL),
('Jogging Nezuko','textiles',NULL,'image/jogging_nezuko.jpg',158.50,NULL),
('Sweat Tanjiro','textiles',NULL,'image/sweat_tanjiro.jpg',65.50,NULL),
('Tee Shirt Inosuke','textiles',NULL,'image/tee_shirt_inosuke.jpg',48.50,NULL),
('Pyjama Zenitsu','textiles',NULL,'image/pyjama_zenitsu.jpg''tsu.jpg',55.50,NULL),
('Costume Zenitsu','textiles',NULL,'image/costume_zenitsu.jpg''tsu.jpg',50.50,NULL),
('Costume Nezuko','textiles',NULL,'image/costume_nezuko.jpg',60.50,NULL),
('Parure Demon Slayer','textiles',NULL,'image/parure_demon_slayer.jpg',258.50,NULL),
('Parure Tanjiro Nezuko','textiles',NULL,'image/parure_tanjiro_nezuko.jpg',268.50,NULL),
('Parure Nezuko','textiles',NULL,'image/parure_nezuko.jpg',278.50,NULL),
('Veste One Punch Man','textiles',NULL,'image/veste_one_punch_man.jpg',75.50,NULL),
('Jogging Saitama','textiles',NULL,'image/jogging_saitama.jpg',158.50,NULL),
('Sweat Genos','textiles',NULL,'image/sweat_genos.jpg',65.50,NULL),
('Tee Shirt Garou','textiles',NULL,'image/tee_shirt_garou.jpg',48.50,NULL),
('Pyjama Saitama','textiles',NULL,'image/pyjama_saitama.jpg',55.50,NULL),
('Costume Saitama','textiles',NULL,'image/costume_saitama.jpg',50.50,NULL),
('Costume Tatsumaki','textiles',NULL,'image/costume_tatsumaki.jpg',60.50,NULL),
('Parure One Punch Man','textiles',NULL,'image/parure_one_punch_man.jpg',258.50,NULL),
('Parure Saitama','textiles',NULL,'image/parure_saitama.jpg',268.50,NULL),
('Parure Genos','textiles',NULL,'image/parure_genos.jpg',278.50,NULL),
('Veste Solo Leveling','textiles',NULL,'image/veste_solo_leveling.jpg',75.50,NULL),
('Jogging Solo Leveling','textiles',NULL,'image/jogging_solo_leveling.jpg',158.50,NULL),
('Sweat Sung Jin Hoo','textiles',NULL,'image/sweat_sung_jin_hoo.jpg',65.50,NULL),
('Tee Shirt Sung Jin Hoo','textiles',NULL,'image/tee_shirt_sung_jin_hoo.jpg',48.50,NULL),
('Pyjama Solo Leveling','textiles',NULL,'image/pyjama_solo_leveling.jpg',55.50,NULL),
('Costume Sung Jin Hoo','textiles',NULL,'image/costume_sung_jin_hoo.jpg',50.50,NULL),
('Costume Cha Hae In','textiles',NULL,'image/costume_cha_hae_in.jpg',60.50,NULL),
('Parure Sung Jin Hoo','textiles',NULL,'image/parure_sung_jin_hoo.jpg',258.50,NULL),
('Parure Solo Leveling','textiles',NULL,'image/parure_solo_leveling.jpg',268.50,NULL),
('Parure Sung Jin Hoo Black','textiles',NULL,'image/parure_sung_jin_hoo_black.jpg',278.50,NULL);

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