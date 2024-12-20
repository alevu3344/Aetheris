
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE AetherisDB
    CHARACTER SET utf8
    COLLATE utf8_general_ci;

USE AetherisDB;


CREATE TABLE PUBLISHERS (
  `PublisherName` varchar(50) NOT NULL,
  PRIMARY KEY (`PublisherName`)
);

CREATE TABLE CATEGORIES (
  `CategoryName` varchar(50) NOT NULL,
  PRIMARY KEY (`CategoryName`)
);

CREATE TABLE GAMES (
  `Id` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `Publisher` varchar(50) NOT NULL,
  `ReleaseDate` date NOT NULL,
  `Description` text NOT NULL,
  `Image` varchar(50) NOT NULL,
  `Video` varchar(50) NOT NULL,
  `Rating` decimal(10,2) NOT NULL, -- Dato derivato, ma fare la query per calcolarlo è troppo costoso
  `CopiesSold` int(11) NOT NULL, -- Idem
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`Publisher`) REFERENCES PUBLISHERS(`PublisherName`)
);

CREATE TABLE GAME_CATEGORIES (
  `GameId` int(11) NOT NULL,
  `CategoryName` varchar(50) NOT NULL,
  PRIMARY KEY (`GameId`, `CategoryName`),
  FOREIGN KEY (`GameId`) REFERENCES GAMES(`Id`),
  FOREIGN KEY (`CategoryName`) REFERENCES CATEGORIES(`CategoryName`)
);

CREATE TABLE GAME_MEDIA(
  `GameId` int(11) NOT NULL,
  `PosterImageUrl` varchar(50) NOT NULL,
  `TrailerUrl` varchar(50) NOT NULL,
  `Screenshot1` varchar(50) NOT NULL,
  `Screenshot2` varchar(50) NOT NULL,
  `Screenshot3` varchar(50) NOT NULL,
  PRIMARY KEY (`GameId`),
  FOREIGN KEY (`GameId`) REFERENCES GAMES(`Id`)
);

CREATE TABLE DISCOUNTED_GAMES (
  `GameId` int(11) NOT NULL,
  `Percentage` int(11) NOT NULL CHECK (`Percentage` BETWEEN 0 AND 100),
  `StartDate` date NOT NULL,
  `EndDate` date NOT NULL,
  PRIMARY KEY (`GameId`, `StartDate`),
  FOREIGN KEY (`GameId`) REFERENCES GAMES(`Id`),
  CHECK (`StartDate` < `EndDate`)
);

CREATE TABLE USERS (
  `Username` varchar(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Surname` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Balance` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`Username`),
  UNIQUE KEY (`Email`)
);

CREATE TABLE SHOPPING_CARTS(
  `UserId` int(11) NOT NULL references USERS(`Username`),
  `GameId` int(11) NOT NULL references GAMES(`Id`),
  `Quantity` int (11) NOT NULL,
  PRIMARY KEY (`UserId`,`GameId`)
);

CREATE TABLE REVIEWS (
  `Title` varchar(50) NOT NULL,
  `Comment` text NOT NULL,
  `Rating` decimal(10,2) NOT NULL CHECK (`Rating` BETWEEN 0 AND 5),
  `GameID` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  FOREIGN KEY (`GameID`) REFERENCES GAMES(`Id`),
  FOREIGN KEY (`Username`) REFERENCES USERS(`Username`)
);

CREATE TABLE ORDERS (
  `Id` int(11) NOT NULL AUTO_INCREMENT, -- Unique ID for the order
  `UserId` varchar(50) NOT NULL, -- Links to USERS table
  `OrderDate` datetime NOT NULL DEFAULT current_timestamp(), -- When the order was placed
  `TotalCost` decimal(10,2) NOT NULL, -- Total cost of the order
  `Status` enum('Pending', 'Completed', 'Shipped', 'Canceled') NOT NULL DEFAULT 'Pending', -- Order status
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`UserId`) REFERENCES USERS(`Username`) -- Links to USERS table
);

CREATE TABLE ORDER_ITEMS (
  `OrderId` int(11) NOT NULL, -- Links to ORDERS table
  `GameId` int(11) NOT NULL, -- Links to GAMES table
  `Quantity` int(11) NOT NULL, -- Number of copies ordered
  `Price` decimal(10,2) NOT NULL, -- Price at the time of the order (for historical data)
  PRIMARY KEY (`OrderId`, `GameId`), -- Composite key ensures no duplicate game in the same order
  FOREIGN KEY (`OrderId`) REFERENCES ORDERS(`Id`), -- Links to ORDERS table
  FOREIGN KEY (`GameId`) REFERENCES GAMES(`Id`) -- Links to GAMES table
);


-- Insert Categories
INSERT INTO CATEGORIES (CategoryName) VALUES
('Action/Adventure'),
('RPG'),
('First-Person Shooter'),
('Survival'),
('Strategy'),
('Sports/Racing'),
('Indie Games'),
('Platformers'),
('MMORPG'),
('Party/Casual'),
('Horror'),
('Fighting'),
('Multiplayer'),
('Simulation'),
('Single-Player'),
('Offline'),
('Online'),
('Puzzle/Logic');



INSERT INTO PUBLISHERS (PublisherName) VALUES
('Nintendo'),
('Rockstar Games'),
('Sony Interactive Entertainment'),
('Ubisoft'),
('Square Enix'),
('Warner Bros. Interactive Entertainment'),
('505 Games'),
('Activision'),
('Konami'),
('Bethesda Softworks'),
('Techland'),
('Bandai Namco Entertainment'),
('Electronic Arts'),
('CD Projekt Red'),
('Larian Studios'),
('Atlus'),
('miHoYo'),
('Capcom'),
('Blizzard Entertainment'),
('ConcernedApe'),
('Re-Logic'),
('Obsidian Entertainment'),
('ZA/UM'),
('Toby Fox'),
('Team Cherry'),
('Motion Twin'),
('Grinding Gear Games'),
('Xbox Game Studios'),
('Warhorse Studios'),
('Focus Home Interactive'),
('IronOak Games'),
('Sega'),
('Supergiant Games'),
('Stoic Studio'),
('Crate Entertainment'),
('2K Games'),
('Paradox Interactive'),
('Kalypso Media'),
('Wube Software'),
('Ludeon Studios'),
('Frontier Developments'),
('11 bit studios'),
('Bay 12 Games'),
('Rebellion Developments'),
('Shiro Games'),
('EA Sports'),
('2K Sports'),
('San Diego Studio'),
('Criterion Games'),
('Psyonix'),
('Team17'),
('Codemasters'),
('Milestone'),
('KT Racing'),
('Saber Interactive'),
('Crea-ture Studios'),
('Kunos Simulazioni'),
('Maddy Makes Games'),
('Innersloth'),
('Studio MDHR'),
('Moon Studios'),
('Nomada Studio'),
('MegaCrit'),
('Thunder Lotus Games'),
('Nicalis'),
('Andrew Shouldice'),
('Daniel Mullins Games'),
('Playdead'),
('Tarsier Studios'),
('Toys for Bob'),
('Insomniac Games'),
('Retro Studios'),
('HAL Laboratory'),
('Sumo Digital'),
('ZeniMax Online Studios'),
('ArenaNet'),
('Smilegate RPG'),
('Pearl Abyss'),
('Jagex'),
('BioWare'),
('Amazon Games'),
('Sandbox Interactive'),
('Mediatonic'),
('Jackbox Games'),
('Rebuilt Games'),
('Boneloaf'),
('Bloober Team'),
('EA Motive'),
('Red Barrels'),
('Frictional Games'),
('Kinetic Games'),
('Arc System Works'),
('Koei Tecmo'),
('SNK'),
('Valve'),
('Thekla, Inc.'),
('Monstars'),
('Hempuli'),
('No Brakes Games'),
('ustwo games'),
('Infinity Plus 2'),
('Pine Studio'),
('Witch Beam');



INSERT INTO `GAMES` (`Id`, `Name`, `Price`, `Publisher`, `ReleaseDate`, `Description`, `Image`, `Video`, `Rating`, `CopiesSold`) VALUES
(1, 'The Legend of Zelda: Breath of the Wild', 59.99, 'Nintendo', '2017-03-03', 'An open-world adventure game set in the Zelda universe.', 'The_Legend_of_Zelda:_Breath_of_the_Wild.png', 'The_Legend_of_Zelda:_Breath_of_the_Wild.mov', 10.00, 10000000),
(2, 'Red Dead Redemption 2', 59.99, 'Rockstar Games', '2018-10-26', 'A Western-themed open-world action game.', 'Red_Dead_Redemption_2.png', 'Red_Dead_Redemption_2.mov', 9.80, 20000000),
(3, 'God of War (2018)', 49.99, 'Sony Interactive Entertainment', '2018-04-20', 'A brutal and emotional journey in the world of Norse mythology.', 'God_of_War_2018.png', 'God_of_War_2018.mov', 9.70, 15000000),
(4, 'Horizon Zero Dawn', 39.99, 'Sony Interactive Entertainment', '2017-02-28', 'An open-world action RPG with a futuristic setting.', 'Horizon_Zero_Dawn.png', 'Horizon_Zero_Dawn.mov', 9.60, 9000000),
(5, 'Assassin’s Creed Valhalla', 59.99, 'Ubisoft', '2020-11-10', 'A Viking-themed action RPG with open-world exploration.', 'Assassins_Creed_Valhalla.png', 'Assassins_Creed_Valhalla.mov', 9.20, 12000000),
(6, 'Ghost of Tsushima', 59.99, 'Sony Interactive Entertainment', '2020-07-17', 'A samurai action RPG set in feudal Japan.', 'Ghost_of_Tsushima.png', 'Ghost_of_Tsushima.mov', 9.40, 7000000),
(7, 'Tomb Raider (2013)', 19.99, 'Square Enix', '2013-03-05', 'A re-imagining of the classic action-adventure series.', 'Tomb_Raider_2013.png', 'Tomb_Raider_2013.mov', 8.50, 14000000),
(8, 'Uncharted 4: A Thief\'s End', 59.99, 'Sony Interactive Entertainment', '2016-05-10', 'A treasure hunter’s adventure filled with action and puzzle-solving.', 'Uncharted_4_A_Thiefs_End.png', 'Uncharted_4_A_Thiefs_End.mov', 9.70, 16000000),
(9, 'Batman: Arkham Knight', 29.99, 'Warner Bros. Interactive Entertainment', '2015-06-23', 'A superhero action game featuring Batman in Gotham City.', 'Batman_Arkham_Knight.png', 'Batman_Arkham_Knight.mov', 9.10, 9000000),
(10, 'Spider-Man: Miles Morales', 49.99, 'Sony Interactive Entertainment', '2020-11-12', 'The story of Miles Morales as the new Spider-Man.', 'Spider_Man_Miles_Morales.png', 'Spider_Man_Miles_Morales.mov', 9.60, 8000000),
(11, 'The Last of Us Part II', 59.99, 'Sony Interactive Entertainment', '2020-06-19', 'A post-apocalyptic action-adventure with deep narrative elements.', 'The_Last_of_Us_Part_II.png', 'The_Last_of_Us_Part_II.mov', 9.50, 11000000),
(12, 'Control', 39.99, '505 Games', '2019-08-27', 'A surreal third-person action game with supernatural elements.', 'Control.png', 'Control.mov', 9.20, 7000000),
(13, 'Sekiro: Shadows Die Twice', 59.99, 'Activision', '2019-03-22', 'A punishing action RPG set in a war-torn feudal Japan.', 'Sekiro_Shadows_Die_Twice.png', 'Sekiro_Shadows_Die_Twice.mov', 9.80, 4000000),
(14, 'Death Stranding', 59.99, 'Sony Interactive Entertainment', '2019-11-08', 'An open-world action game set in a post-apocalyptic world.', 'Death_Strandling.png', 'Death_Strandling.mov', 9.10, 8000000),
(15, 'Days Gone', 39.99, 'Sony Interactive Entertainment', '2019-04-26', 'An open-world survival action game set in a post-apocalyptic world.', 'Days_Gone.png', 'Days_Gone.mov', 8.80, 6000000),
(16, 'Far Cry 5', 59.99, 'Ubisoft', '2018-03-27', 'An open-world shooter set in a Montana county taken over by a cult.', 'Far_Cry_5.png', 'Far_Cry_5.mov', 8.70, 8000000),
(17, 'Watch Dogs: Legion', 59.99, 'Ubisoft', '2020-10-29', 'A hacker-focused action game set in a dystopian London.', 'Watch_Dogs_Legion.png', 'Watch_Dogs_Legion.mov', 8.40, 5000000),
(18, 'Metal Gear Solid V: The Phantom Pain', 59.99, 'Konami', '2015-09-01', 'An open-world stealth action game with military espionage elements.', 'Metal_Gear_Solid_V.png', 'Metal_Gear_Solid_V.mov', 9.30, 12000000),
(19, 'Dishonored 2', 39.99, 'Bethesda Softworks', '2016-11-11', 'A stealth action game set in a steampunk-inspired world.', 'Dishonored_2.png', 'Dishonored_2.mov', 9.00, 4000000),
(20, 'Dying Light 2', 59.99, 'Techland', '2022-02-04', 'A zombie apocalypse game with parkour-based movement and combat.', 'Dying_Light_2.png', 'Dying_Light_2.mov', 8.70, 6000000),
(23, 'Fallout: New Vegas', 19.99, 'Bethesda Softworks', '2010-10-19', 'A post-apocalyptic open-world RPG in the Fallout series.', 'Fallout_New_Vegas.png', 'Fallout_New_Vegas.mov', 9.80, 12000000),
(24, 'Mass Effect Legendary Edition', 59.99, 'Electronic Arts', '2021-05-14', 'A remastered trilogy of the critically acclaimed Mass Effect series.', 'Mass_Effect_Legendary_Edition.png', 'Mass_Effect_Legendary_Edition.mov', 9.60, 5000000),
(25, 'Cyberpunk 2077', 59.99, 'CD Projekt Red', '2020-12-10', 'An open-world action RPG set in a dystopian cyberpunk future.', 'Cyberpunk_2077.png', 'Cyberpunk_2077.mov', 9.00, 20000000),
(26, 'Witcher 3: Wild Hunt', 39.99, 'CD Projekt Red', '2015-05-19', 'An open-world fantasy RPG set in the Witcher universe.', 'Witcher_3_Wild_Hunt.png', 'Witcher_3_Wild_Hunt.mov', 10.00, 50000000),
(30, 'Persona 5 Royal', 59.99, 'Atlus', '2019-10-31', 'An enhanced edition of Persona 5 with new characters and stories.', 'Persona_5_Royal.png', 'Persona_5_Royal.mov', 9.80, 6000000),
(31, 'Final Fantasy XVI', 69.99, 'Square Enix', '2023-06-22', 'A high fantasy RPG with action-packed combat.', 'Final_Fantasy_XVI.png', 'Final_Fantasy_XVI.mov', 9.50, 5000000),
(32, 'Final Fantasy VII Remake', 59.99, 'Square Enix', '2020-04-10', 'A remake of the classic Final Fantasy VII with modern graphics and gameplay.', 'Final_Fantasy_VII_Remake.png', 'Final_Fantasy_VII_Remake.mov', 9.70, 8000000),
(34, 'Genshin Impact', 0.00, 'miHoYo', '2020-09-28', 'An open-world RPG with gacha mechanics and stunning visuals.', 'Genshin_Impact.png', 'Genshin_Impact.mov', 9.20, 50000000),
(35, 'Monster Hunter: World', 39.99, 'Capcom', '2018-01-26', 'A co-op action RPG where players hunt monsters in diverse ecosystems.', 'Monster_Hunter_World.png', 'Monster_Hunter_World.mov', 9.50, 20000000),
(36, 'Dark Souls III', 59.99, 'Bandai Namco Entertainment', '2016-03-24', 'A challenging action RPG set in a dark fantasy world.', 'Dark_Souls_III.png', 'Dark_Souls_III.mov', 9.60, 10000000),
(37, 'Diablo IV', 69.99, 'Blizzard Entertainment', '2023-06-06', 'The latest installment in the dark fantasy action RPG series.', 'Diablo_IV.png', 'Diablo_IV.mov', 9.10, 10000000),
(38, 'Xenoblade Chronicles 3', 59.99, 'Nintendo', '2022-07-29', 'An open-world RPG with deep storytelling and vast exploration.', 'Xenoblade_Chronicles_3.png', 'Xenoblade_Chronicles_3.mov', 9.40, 4000000),
(39, 'Nier: Automata', 39.99, 'Square Enix', '2017-02-23', 'A thought-provoking action RPG with multiple endings.', 'Nier_Automata.png', 'Nier_Automata.mov', 9.50, 6000000),
(40, 'Octopath Traveler', 59.99, 'Square Enix', '2018-07-13', 'A pixel art JRPG with eight unique protagonists.', 'Octopath_Traveler.png', 'Octopath_Traveler.mov', 9.30, 3000000),
(41, 'Stardew Valley', 14.99, 'ConcernedApe', '2016-02-26', 'A farming and life simulation RPG with pixel art graphics.', 'Stardew_Valley.png', 'Stardew_Valley.mov', 9.60, 20000000),
(42, 'Terraria', 9.99, 'Re-Logic', '2011-05-16', 'A sandbox adventure RPG with exploration and crafting.', 'Terraria.png', 'Terraria.mov', 9.30, 35000000),
(43, 'Elden Ring', 69.99, 'Bandai Namco Entertainment', '2022-02-25', 'An open-world action RPG designed by FromSoftware and George R.R. Martin.', 'Elden_Ring.png', 'Elden_Ring.mov', 9.90, 20000000),
(44, 'The Legend of Zelda: Tears of the Kingdom', 69.99, 'Nintendo', '2023-05-12', 'A direct sequel to Breath of the Wild with new mechanics and exploration.', 'Zelda_Tears_of_the_Kingdom.png', 'Zelda_Tears_of_the_Kingdom.mov', 10.00, 17000000),
(45, 'The Elder Scrolls V: Skyrim', 39.99, 'Bethesda Softworks', '2011-11-11', 'A legendary open-world fantasy RPG with extensive modding support.', 'Skyrim.png', 'Skyrim.mov', 9.70, 30000000),
(46, 'Horizon Forbidden West', 69.99, 'Sony Interactive Entertainment', '2022-02-18', 'A sequel to Horizon Zero Dawn featuring robotic wildlife and exploration.', 'Horizon_Forbidden_West.png', 'Horizon_Forbidden_West.mov', 9.20, 10000000),
(47, 'Fire Emblem: Three Houses', 59.99, 'Nintendo', '2019-07-26', 'A tactical RPG with branching storylines and complex relationships.', 'Fire_Emblem_Three_Houses.png', 'Fire_Emblem_Three_Houses.mov', 9.50, 5000000),
(48, 'Pillars of Eternity II: Deadfire', 49.99, 'Obsidian Entertainment', '2018-05-08', 'A sequel to the critically acclaimed isometric RPG, Pillars of Eternity.', 'Pillars_of_Eternity_II_Deadfire.png', 'Pillars_of_Eternity_II_Deadfire.mov', 9.10, 1000000),
(49, 'Disco Elysium: The Final Cut', 39.99, 'ZA/UM', '2021-03-30', 'A groundbreaking RPG with a focus on narrative and character development.', 'Disco_Elysium_The_Final_Cut.png', 'Disco_Elysium_The_Final_Cut.mov', 9.80, 3000000),
(50, 'Undertale', 14.99, 'Toby Fox', '2015-09-15', 'An indie RPG with unique gameplay and a heartwarming story.', 'Undertale.png', 'Undertale.mov', 9.70, 5000000),
(51, 'Hollow Knight', 14.99, 'Team Cherry', '2017-02-24', 'A metroidvania RPG set in a hauntingly beautiful world.', 'Hollow_Knight.png', 'Hollow_Knight.mov', 9.60, 3000000),
(52, 'Dead Cells', 24.99, 'Motion Twin', '2018-08-07', 'A rogue-lite metroidvania with fast-paced combat.', 'Dead_Cells.png', 'Dead_Cells.mov', 9.40, 5000000),
(53, 'The Outer Worlds', 59.99, 'Obsidian Entertainment', '2019-10-25', 'A satirical sci-fi RPG with branching narratives.', 'The_Outer_Worlds.png', 'The_Outer_Worlds.mov', 8.70, 4000000),
(54, 'Path of Exile', 0.00, 'Grinding Gear Games', '2013-10-23', 'A free-to-play action RPG with a deep skill system.', 'Path_of_Exile.png', 'Path_of_Exile.mov', 9.20, 20000000),
(55, 'Fable Anniversary', 34.99, 'Xbox Game Studios', '2014-02-04', 'A remastered version of the original Fable.', 'Fable_Anniversary.png', 'Fable_Anniversary.mov', 8.50, 3000000),
(56, 'Kingdom Come: Deliverance', 39.99, 'Warhorse Studios', '2018-02-13', 'A realistic medieval RPG with immersive gameplay.', 'Kingdom_Come_Deliverance.png', 'Kingdom_Come_Deliverance.mov', 9.00, 3000000),
(57, 'GreedFall', 49.99, 'Focus Home Interactive', '2019-09-10', 'An action RPG with a unique 17th-century fantasy setting.', 'GreedFall.png', 'GreedFall.mov', 8.40, 2000000),
(58, 'Vampyr', 39.99, 'Focus Home Interactive', '2018-06-05', 'An action RPG about a doctor turned vampire in 1918 London.', 'Vampyr.png', 'Vampyr.mov', 8.20, 1500000),
(59, 'For the King', 19.99, 'IronOak Games', '2018-04-19', 'A turn-based strategy RPG with roguelike elements.', 'For_the_King.png', 'For_the_King.mov', 8.50, 2000000),
(60, 'Yakuza: Like a Dragon', 59.99, 'Sega', '2020-11-10', 'A turn-based RPG reboot of the Yakuza series.', 'Yakuza_Like_a_Dragon.png', 'Yakuza_Like_a_Dragon.mov', 9.00, 3000000),
(61, 'Dragon Age: Inquisition', 39.99, 'Electronic Arts', '2014-11-18', 'A fantasy RPG with vast exploration and engaging character stories.', 'Dragon_Age_Inquisition.png', 'Dragon_Age_Inquisition.mov', 9.10, 6000000),
(62, 'Divinity: Original Sin 2', 44.99, 'Larian Studios', '2017-09-14', 'A critically acclaimed RPG with deep mechanics and co-op gameplay.', 'Divinity_Original_Sin_2.png', 'Divinity_Original_Sin_2.mov', 9.80, 3000000),
(63, 'Baldur\'s Gate III', 59.99, 'Larian Studios', '2023-08-03', 'A continuation of the iconic Baldur\'s Gate series with modern RPG elements.', 'Baldurs_Gate_III.png', 'Baldurs_Gate_III.mov', 9.90, 2000000),
(65, 'Ni no Kuni II: Revenant Kingdom', 59.99, 'Bandai Namco Entertainment', '2018-03-23', 'A visually stunning RPG with a heartfelt story and kingdom-building elements.', 'Ni_no_Kuni_II.png', 'Ni_no_Kuni_II.mov', 8.80, 2000000),
(67, 'Starfield', 69.99, 'Bethesda Softworks', '2024-09-06', 'A space exploration RPG set in an expansive galaxy.', 'Starfield.png', 'Starfield.mov', 9.40, 5000000),
(68, 'The Witcher 2: Assassins of Kings', 19.99, 'CD Projekt Red', '2011-05-17', 'A dark fantasy RPG with political intrigue and impactful choices.', 'The_Witcher_2.png', 'The_Witcher_2.mov', 9.20, 2000000),
(69, 'Final Fantasy XV', 49.99, 'Square Enix', '2016-11-29', 'An action RPG following the journey of Prince Noctis and his friends.', 'Final_Fantasy_XV.png', 'Final_Fantasy_XV.mov', 9.00, 10000000),
(70, 'Chrono Trigger', 14.99, 'Square Enix', '1995-03-11', 'A timeless classic RPG with a legendary story and multiple endings.', 'Chrono_Trigger.png', 'Chrono_Trigger.mov', 9.90, 3000000),
(73, 'Tales of Arise', 59.99, 'Bandai Namco Entertainment', '2021-09-10', 'An action RPG with breathtaking visuals and an emotional story.', 'Tales_of_Arise.png', 'Tales_of_Arise.mov', 9.20, 2000000),
(74, 'Dark Souls II', 39.99, 'Bandai Namco Entertainment', '2014-03-11', 'A challenging RPG with intricate level design and lore.', 'Dark_Souls_II.png', 'Dark_Souls_II.mov', 9.00, 3000000),
(76, 'Dragon Quest XI S: Echoes of an Elusive Age', 39.99, 'Square Enix', '2020-12-04', 'A definitive edition of the classic turn-based RPG.', 'Dragon_Quest_XI_S.png', 'Dragon_Quest_XI_S.mov', 9.50, 6000000),
(77, 'Hades', 24.99, 'Supergiant Games', '2020-09-17', 'A rogue-like dungeon crawler with a rich narrative and addictive gameplay.', 'Hades.png', 'Hades.mov', 9.80, 3000000),
(78, 'The Banner Saga', 19.99, 'Stoic Studio', '2014-01-14', 'A tactical RPG with a rich story set in a Norse-inspired world.', 'The_Banner_Saga.png', 'The_Banner_Saga.mov', 8.90, 2000000),
(79, 'Grim Dawn', 24.99, 'Crate Entertainment', '2016-02-25', 'A dark fantasy action RPG with deep character customization.', 'Grim_Dawn.png', 'Grim_Dawn.mov', 9.00, 1500000),
(81, 'Civilization VI', 59.99, '2K Games', '2016-10-21', 'A turn-based strategy game where players build and expand their civilizations.', 'Civilization_VI.png', 'Civilization_VI.mov', 9.20, 11000000),
(82, 'Age of Empires IV', 59.99, 'Xbox Game Studios', '2021-10-28', 'A real-time strategy game set in historical settings.', 'Age_of_Empires_IV.png', 'Age_of_Empires_IV.mov', 9.00, 2000000),
(83, 'Total War: Warhammer III', 59.99, 'Sega', '2022-02-17', 'A strategy game that blends real-time battles with turn-based empire building.', 'Total_War_Warhammer_III.png', 'Total_War_Warhammer_III.mov', 8.90, 1500000),
(84, 'Stellaris', 39.99, 'Paradox Interactive', '2016-05-09', 'A sci-fi grand strategy game where players explore and conquer galaxies.', 'Stellaris.png', 'Stellaris.mov', 9.30, 3000000),
(85, 'Crusader Kings III', 49.99, 'Paradox Interactive', '2020-09-01', 'A medieval grand strategy game focusing on dynasties and intrigue.', 'Crusader_Kings_III.png', 'Crusader_Kings_III.mov', 9.50, 2000000),
(86, 'XCOM 2', 59.99, '2K Games', '2016-02-05', 'A tactical strategy game where players lead resistance forces against alien invaders.', 'XCOM_2.png', 'XCOM_2.mov', 9.00, 3000000),
(87, 'Anno 1800', 59.99, 'Ubisoft', '2019-04-16', 'A city-building and strategy game set during the industrial revolution.', 'Anno_1800.png', 'Anno_1800.mov', 8.90, 2500000),
(88, 'Company of Heroes 3', 59.99, 'Sega', '2023-02-23', 'A WWII real-time strategy game with dynamic campaigns.', 'Company_of_Heroes_3.png', 'Company_of_Heroes_3.mov', 8.50, 1000000),
(89, 'Tropico 6', 49.99, 'Kalypso Media', '2019-03-29', 'A city-builder where players act as El Presidente of a tropical island nation.', 'Tropico_6.png', 'Tropico_6.mov', 8.70, 2000000),
(90, 'Cities: Skylines', 29.99, 'Paradox Interactive', '2015-03-10', 'A modern city-building simulator with deep mechanics.', 'Cities_Skylines.png', 'Cities_Skylines.mov', 9.40, 12000000),
(91, 'Hearts of Iron IV', 39.99, 'Paradox Interactive', '2016-06-06', 'A grand strategy game set during World War II.', 'Hearts_of_Iron_IV.png', 'Hearts_of_Iron_IV.mov', 9.10, 3000000),
(92, 'Factorio', 30.00, 'Wube Software', '2020-08-14', 'A factory-building and automation game.', 'Factorio.png', 'Factorio.mov', 9.80, 3500000),
(93, 'RimWorld', 34.99, 'Ludeon Studios', '2018-10-17', 'A colony simulator with emergent storytelling and deep mechanics.', 'RimWorld.png', 'RimWorld.mov', 9.60, 3000000),
(94, 'StarCraft II', 39.99, 'Blizzard Entertainment', '2010-07-27', 'A real-time strategy game set in a sci-fi universe.', 'StarCraft_II.png', 'StarCraft_II.mov', 9.50, 6000000),
(95, 'Planet Zoo', 44.99, 'Frontier Developments', '2019-11-05', 'A zoo-building simulator with detailed animal management.', 'Planet_Zoo.png', 'Planet_Zoo.mov', 9.20, 2000000),
(96, 'Frostpunk', 29.99, '11 bit studios', '2018-04-24', 'A city-building survival game in a post-apocalyptic frozen world.', 'Frostpunk.png', 'Frostpunk.mov', 9.10, 2000000),
(97, 'Dwarf Fortress', 39.99, 'Bay 12 Games', '2022-12-06', 'A complex colony management and simulation game.', 'Dwarf_Fortress.png', 'Dwarf_Fortress.mov', 9.50, 1000000),
(98, 'Evil Genius 2', 39.99, 'Rebellion Developments', '2021-03-30', 'A strategy game where players become a supervillain creating their lair.', 'Evil_Genius_2.png', 'Evil_Genius_2.mov', 8.80, 1000000),
(99, 'Victoria 3', 49.99, 'Paradox Interactive', '2022-10-25', 'A grand strategy game focusing on economics and diplomacy.', 'Victoria_3.png', 'Victoria_3.mov', 9.00, 1000000),
(100, 'Northgard', 29.99, 'Shiro Games', '2018-03-07', 'A strategy game based on Norse mythology.', 'Northgard.png', 'Northgard.mov', 8.90, 1500000),
(101, 'FIFA 23', 69.99, 'EA Sports', '2022-09-30', 'The latest iteration of the popular football simulation game.', 'FIFA_23.png', 'FIFA_23.mov', 8.50, 10000000),
(102, 'NBA 2K23', 69.99, '2K Sports', '2022-09-09', 'A basketball simulation game featuring NBA teams and players.', 'NBA_2K23.png', 'NBA_2K23.mov', 8.20, 8000000),
(103, 'Madden NFL 23', 69.99, 'EA Sports', '2022-08-19', 'An American football simulation game based on the NFL.', 'Madden_NFL_23.png', 'Madden_NFL_23.mov', 7.80, 5000000),
(104, 'MLB The Show 23', 69.99, 'San Diego Studio', '2023-03-28', 'A baseball simulation game featuring MLB teams.', 'MLB_The_Show_23.png', 'MLB_The_Show_23.mov', 8.60, 3000000),
(105, 'Forza Horizon 5', 59.99, 'Xbox Game Studios', '2021-11-09', 'An open-world racing game set in a vibrant Mexico.', 'Forza_Horizon_5.png', 'Forza_Horizon_5.mov', 9.50, 15000000),
(106, 'Gran Turismo 7', 69.99, 'Sony Interactive Entertainment', '2022-03-04', 'A realistic racing simulator with stunning visuals.', 'Gran_Turismo_7.png', 'Gran_Turismo_7.mov', 9.00, 5000000),
(107, 'F1 23', 59.99, 'EA Sports', '2023-06-16', 'A racing game based on the Formula 1 World Championship.', 'F1_23.png', 'F1_23.mov', 8.80, 2000000),
(108, 'Need for Speed: Unbound', 69.99, 'Criterion Games', '2022-12-02', 'An arcade-style street racing game.', 'Need_for_Speed_Unbound.png', 'Need_for_Speed_Unbound.mov', 8.30, 3000000),
(109, 'Rocket League', 19.99, 'Psyonix', '2015-07-07', 'A mix of soccer and driving with fast-paced gameplay.', 'Rocket_League.png', 'Rocket_League.mov', 9.20, 20000000),
(110, 'Riders Republic', 59.99, 'Ubisoft', '2021-10-28', 'A multiplayer extreme sports game.', 'Riders_Republic.png', 'Riders_Republic.mov', 8.00, 1000000),
(111, 'Tony Hawk’s Pro Skater 1+2', 39.99, 'Activision', '2020-09-04', 'A remastered collection of the first two Tony Hawk games.', 'Tony_Hawk_Pro_Skater_1_2.png', 'Tony_Hawk_Pro_Skater_1_2.mov', 8.90, 2000000),
(112, 'Golf With Your Friends', 14.99, 'Team17', '2020-05-19', 'A fun multiplayer mini-golf game.', 'Golf_With_Your_Friends.png', 'Golf_With_Your_Friends.mov', 8.30, 1000000),
(113, 'Dirt 5', 59.99, 'Codemasters', '2020-11-06', 'An off-road racing game with arcade-style gameplay.', 'Dirt_5.png', 'Dirt_5.mov', 8.00, 1000000),
(114, 'MotoGP 23', 49.99, 'Milestone', '2023-06-08', 'A motorcycle racing simulator featuring MotoGP riders.', 'MotoGP_23.png', 'MotoGP_23.mov', 7.80, 500000),
(115, 'TrackMania', 29.99, 'Ubisoft', '2020-07-01', 'A fast-paced arcade racing game focused on track building.', 'TrackMania.png', 'TrackMania.mov', 8.40, 2000000),
(116, 'WRC Generations', 59.99, 'KT Racing', '2022-11-03', 'A rally racing game based on the World Rally Championship.', 'WRC_Generations.png', 'WRC_Generations.mov', 8.50, 800000),
(117, 'Pro Evolution Soccer 2023 (eFootball)', 0.00, 'Konami', '2023-09-30', 'A free-to-play football simulation game.', 'eFootball_2023.png', 'eFootball_2023.mov', 7.50, 5000000),
(118, 'SnowRunner', 29.99, 'Saber Interactive', '2020-04-28', 'A simulation game about driving heavy vehicles in extreme conditions.', 'SnowRunner.png', 'SnowRunner.mov', 8.70, 2000000),
(119, 'Session: Skate Sim', 39.99, 'Crea-ture Studios', '2022-09-22', 'A realistic skateboarding simulation game.', 'Session_Skate_Sim.png', 'Session_Skate_Sim.mov', 7.60, 300000),
(120, 'Assetto Corsa', 19.99, 'Kunos Simulazioni', '2014-12-19', 'A highly realistic racing simulator.', 'Assetto_Corsa.png', 'Assetto_Corsa.mov', 9.30, 2000000),
(123, 'Stardew Valley', 14.99, 'ConcernedApe', '2016-02-26', 'A charming farming simulator and role-playing game.', 'Stardew_Valley.png', 'Stardew_Valley.mov', 9.60, 20000000),
(124, 'Celeste', 19.99, 'Maddy Makes Games', '2018-01-25', 'A challenging platformer about climbing a mountain and overcoming personal struggles.', 'Celeste.png', 'Celeste.mov', 9.20, 1000000),
(125, 'Among Us', 4.99, 'Innersloth', '2018-11-16', 'A multiplayer social deduction game.', 'Among_Us.png', 'Among_Us.mov', 8.90, 50000000),
(126, 'Cuphead', 19.99, 'Studio MDHR', '2017-09-29', 'A visually stunning run-and-gun game with a 1930s cartoon art style.', 'Cuphead.png', 'Cuphead.mov', 9.40, 6000000),
(127, 'Ori and the Will of the Wisps', 29.99, 'Moon Studios', '2020-03-11', 'A visually breathtaking platformer with emotional storytelling.', 'Ori_Will_of_the_Wisps.png', 'Ori_Will_of_the_Wisps.mov', 9.50, 3000000),
(129, 'Gris', 16.99, 'Nomada Studio', '2018-12-13', 'A serene and evocative platformer about grief.', 'Gris.png', 'Gris.mov', 9.10, 1000000),
(130, 'Undertale', 9.99, 'Toby Fox', '2015-09-15', 'A role-playing game where your choices matter.', 'Undertale.png', 'Undertale.mov', 9.60, 5000000),
(131, 'Slay the Spire', 24.99, 'MegaCrit', '2019-01-23', 'A deck-building rogue-like game.', 'Slay_the_Spire.png', 'Slay_the_Spire.mov', 9.40, 3000000),
(132, 'Spiritfarer', 29.99, 'Thunder Lotus Games', '2020-08-18', 'A cozy management game about death and saying goodbye.', 'Spiritfarer.png', 'Spiritfarer.mov', 9.00, 1000000),
(133, 'The Binding of Isaac: Rebirth', 14.99, 'Nicalis', '2014-11-04', 'A rogue-like dungeon crawler with dark themes.', 'Binding_of_Isaac_Rebirth.png', 'Binding_of_Isaac_Rebirth.mov', 9.10, 3000000),
(134, 'RimWorld', 34.99, 'Ludeon Studios', '2018-10-17', 'A colony simulation game with emergent storytelling.', 'RimWorld.png', 'RimWorld.mov', 9.40, 2000000),
(136, 'Tunic', 29.99, 'Andrew Shouldice', '2022-03-16', 'A charming action-adventure game inspired by classic Zelda titles.', 'Tunic.png', 'Tunic.mov', 9.00, 500000),
(137, 'Inscryption', 19.99, 'Daniel Mullins Games', '2021-10-19', 'A mind-bending card-based rogue-like game.', 'Inscryption.png', 'Inscryption.mov', 9.30, 1000000),
(138, 'Limbo', 9.99, 'Playdead', '2010-07-21', 'A monochrome puzzle-platformer with a haunting atmosphere.', 'Limbo.png', 'Limbo.mov', 9.00, 5000000),
(139, 'Little Nightmares', 19.99, 'Tarsier Studios', '2017-04-28', 'A dark and eerie puzzle-platformer.', 'Little_Nightmares.png', 'Little_Nightmares.mov', 9.20, 2000000),
(140, 'Inside', 19.99, 'Playdead', '2016-06-29', 'A cinematic platformer with a mysterious narrative.', 'Inside.png', 'Inside.mov', 9.50, 3000000),
(141, 'Super Mario Odyssey', 59.99, 'Nintendo', '2017-10-27', 'Embark on a globe-trotting adventure to rescue Princess Peach in this iconic platformer.', 'Super_Mario_Odyssey.png', 'Super_Mario_Odyssey.mov', 9.80, 24000000),
(142, 'Crash Bandicoot 4: It’s About Time', 39.99, 'Toys for Bob', '2020-10-02', 'A challenging and vibrant continuation of the Crash Bandicoot series.', 'Crash_Bandicoot_4.png', 'Crash_Bandicoot_4.mov', 8.90, 5000000),
(143, 'Spyro Reignited Trilogy', 39.99, 'Toys for Bob', '2018-11-13', 'A remastered collection of the beloved Spyro trilogy with stunning graphics.', 'Spyro_Reignited_Trilogy.png', 'Spyro_Reignited_Trilogy.mov', 9.00, 3000000),
(144, 'Ratchet & Clank: Rift Apart', 69.99, 'Insomniac Games', '2021-06-11', 'A visually spectacular platformer and shooter adventure.', 'Ratchet_and_Clank_Rift_Apart.png', 'Ratchet_and_Clank_Rift_Apart.mov', 9.20, 2000000),
(145, 'Sonic Frontiers', 59.99, 'Sega', '2022-11-08', 'An open-world Sonic adventure with fast-paced gameplay.', 'Sonic_Frontiers.png', 'Sonic_Frontiers.mov', 8.80, 1000000),
(146, 'Donkey Kong Country: Tropical Freeze', 59.99, 'Retro Studios', '2014-02-21', 'A challenging and beautifully designed platformer featuring Donkey Kong.', 'Donkey_Kong_Tropical_Freeze.png', 'Donkey_Kong_Tropical_Freeze.mov', 9.00, 3000000),
(147, 'Ori and the Blind Forest', 19.99, 'Moon Studios', '2015-03-11', 'A visually stunning and emotional platformer.', 'Ori_and_the_Blind_Forest.png', 'Ori_and_the_Blind_Forest.mov', 9.50, 2000000),
(148, 'Rayman Legends', 39.99, 'Ubisoft', '2013-08-29', 'A highly creative and fun platformer with cooperative gameplay.', 'Rayman_Legends.png', 'Rayman_Legends.mov', 9.40, 5000000),
(149, 'Kirby and the Forgotten Land', 59.99, 'HAL Laboratory', '2022-03-25', 'Join Kirby in his first 3D adventure in a mysterious world.', 'Kirby_and_the_Forgotten_Land.png', 'Kirby_and_the_Forgotten_Land.mov', 9.10, 2000000),
(150, 'Sackboy: A Big Adventure', 59.99, 'Sumo Digital', '2020-11-12', 'A charming and family-friendly platformer.', 'Sackboy_A_Big_Adventure.png', 'Sackboy_A_Big_Adventure.mov', 8.70, 1000000),
(151, 'World of Warcraft', 39.99, 'Blizzard Entertainment', '2004-11-23', 'An iconic MMORPG set in the expansive fantasy world of Azeroth.', 'World_of_Warcraft.png', 'World_of_Warcraft.mov', 9.30, 120000000),
(152, 'Final Fantasy XIV', 39.99, 'Square Enix', '2010-09-30', 'A critically acclaimed MMORPG with a rich story and vibrant community.', 'Final_Fantasy_XIV.png', 'Final_Fantasy_XIV.mov', 9.50, 27000000),
(154, 'Guild Wars 2', 0.00, 'ArenaNet', '2012-08-28', 'A dynamic and free-to-play MMORPG with an innovative event system.', 'Guild_Wars_2.png', 'Guild_Wars_2.mov', 8.90, 16000000),
(155, 'Lost Ark', 0.00, 'Smilegate RPG', '2018-12-04', 'A visually stunning MMORPG with action-oriented gameplay.', 'Lost_Ark.png', 'Lost_Ark.mov', 8.50, 20000000),
(156, 'Black Desert Online', 9.99, 'Pearl Abyss', '2015-07-14', 'An immersive MMORPG with incredible graphics and deep gameplay systems.', 'Black_Desert_Online.png', 'Black_Desert_Online.mov', 8.60, 10000000),
(157, 'Runescape', 0.00, 'Jagex', '2001-01-04', 'A long-running MMORPG with an enormous and dedicated player base.', 'Runescape.png', 'Runescape.mov', 8.30, 30000000),
(158, 'Star Wars: The Old Republic', 0.00, 'BioWare', '2011-12-20', 'An MMORPG set in the Star Wars universe with rich storytelling.', 'Star_Wars_The_Old_Republic.png', 'Star_Wars_The_Old_Republic.mov', 8.50, 10000000),
(159, 'New World', 39.99, 'Amazon Games', '2021-09-28', 'An ambitious MMORPG set in a supernatural version of the Americas.', 'New_World.png', 'New_World.mov', 7.80, 5000000),
(160, 'Albion Online', 0.00, 'Sandbox Interactive', '2017-07-17', 'A player-driven MMORPG with a classless combat system and an emphasis on economy.', 'Albion_Online.png', 'Albion_Online.mov', 8.10, 5000000),
(161, 'Mario Kart 8 Deluxe', 59.99, 'Nintendo', '2017-04-28', 'A fun-filled racing game perfect for parties, featuring iconic Nintendo characters.', 'Mario_Kart_8_Deluxe.png', 'Mario_Kart_8_Deluxe.mov', 9.40, 55000000),
(162, 'Super Smash Bros. Ultimate', 59.99, 'Nintendo', '2018-12-07', 'A chaotic and exciting brawler with characters from various franchises.', 'Super_Smash_Bros_Ultimate.png', 'Super_Smash_Bros_Ultimate.mov', 9.50, 33000000),
(163, 'Fall Guys: Ultimate Knockout', 19.99, 'Mediatonic', '2020-08-04', 'A hilarious party game where players compete in chaotic obstacle courses.', 'Fall_Guys.png', 'Fall_Guys.mov', 8.30, 15000000),
(164, 'Jackbox Party Pack 9', 29.99, 'Jackbox Games', '2022-10-20', 'A collection of hilarious party games that are easy to pick up and play.', 'Jackbox_Party_Pack_9.png', 'Jackbox_Party_Pack_9.mov', 8.50, 2000000),
(165, 'Animal Crossing: New Horizons', 59.99, 'Nintendo', '2020-03-20', 'A relaxing life-simulation game where you create your perfect island getaway.', 'Animal_Crossing_New_Horizons.png', 'Animal_Crossing_New_Horizons.mov', 9.60, 42000000),
(166, 'Splatoon 3', 59.99, 'Nintendo', '2022-09-09', 'A colorful and fun multiplayer game centered around ink-splattering battles.', 'Splatoon_3.png', 'Splatoon_3.mov', 9.00, 12000000),
(167, 'Wii Sports', 0.00, 'Nintendo', '2006-11-19', 'An iconic collection of sports games that revolutionized casual gaming.', 'Wii_Sports.png', 'Wii_Sports.mov', 9.20, 82000000),
(168, 'Pummel Party', 14.99, 'Rebuilt Games', '2018-09-20', 'A chaotic and humorous party game with brutal mini-games.', 'Pummel_Party.png', 'Pummel_Party.mov', 8.10, 2000000),
(169, 'Overcooked! 2', 24.99, 'Team17', '2018-08-07', 'A frantic co-op cooking game that challenges players to work together.', 'Overcooked_2.png', 'Overcooked_2.mov', 8.60, 5000000),
(170, 'Gang Beasts', 19.99, 'Boneloaf', '2017-12-12', 'A wacky multiplayer game where gelatinous characters fight in absurd arenas.', 'Gang_Beasts.png', 'Gang_Beasts.mov', 8.00, 3000000),
(171, 'Resident Evil Village', 59.99, 'Capcom', '2021-05-07', 'A survival horror game that follows Ethan Winters as he searches for his kidnapped daughter in a village filled with terrifying creatures.', 'Resident_Evil_Village.png', 'Resident_Evil_Village.mov', 9.30, 12000000),
(172, 'Resident Evil 4 Remake', 59.99, 'Capcom', '2023-03-24', 'A complete remake of the classic horror game, with modern graphics and gameplay while preserving the original experience.', 'Resident_Evil_4_Remake.png', 'Resident_Evil_4_Remake.mov', 9.50, 8000000),
(173, 'Silent Hill 2 Remake', 59.99, 'Bloober Team', '2023-10-30', 'A terrifying remake of the iconic psychological horror game that delves into the eerie town of Silent Hill.', 'Silent_Hill_2_Remake.png', 'Silent_Hill_2_Remake.mov', 9.40, 5000000),
(174, 'Dead Space Remake', 59.99, 'EA Motive', '2023-01-27', 'A remake of the 2008 classic survival horror game, set on a haunted spaceship with a horrifying atmosphere.', 'Dead_Space_Remake.png', 'Dead_Space_Remake.mov', 9.20, 4000000),
(175, 'Outlast II', 29.99, 'Red Barrels', '2017-04-25', 'A first-person psychological horror game that challenges players to survive against terrifying enemies and solve puzzles.', 'Outlast_II.png', 'Outlast_II.mov', 8.70, 5000000),
(176, 'Amnesia: The Dark Descent', 19.99, 'Frictional Games', '2010-09-08', 'A survival horror game that immerses players in a dark, creepy mansion filled with terrifying creatures and puzzles.', 'Amnesia_The_Dark_Descent.png', 'Amnesia_The_Dark_Descent.mov', 9.00, 8000000),
(177, 'Layers of Fear', 19.99, 'Bloober Team', '2016-02-16', 'A psychological horror game where players experience a disturbed artist’s descent into madness.', 'Layers_of_Fear.png', 'Layers_of_Fear.mov', 8.20, 4000000),
(178, 'The Evil Within 2', 39.99, 'Bethesda Softworks', '2017-10-13', 'A survival horror game set in a nightmarish world filled with horrifying enemies and puzzles.', 'The_Evil_Within_2.png', 'The_Evil_Within_2.mov', 8.40, 3000000),
(179, 'Phasmophobia', 13.99, 'Kinetic Games', '2020-09-18', 'A co-op horror game where players must investigate paranormal activity in haunted locations.', 'Phasmophobia.png', 'Phasmophobia.mov', 8.80, 6000000),
(180, 'Little Nightmares II', 29.99, 'Tarsier Studios', '2021-02-11', 'A dark and eerie platformer that follows a young boy and girl as they escape terrifying creatures in a nightmarish world.', 'Little_Nightmares_II.png', 'Little_Nightmares_II.mov', 8.90, 4000000),
(181, 'Mortal Kombat 11', 59.99, 'Warner Bros. Interactive Entertainment', '2019-04-23', 'A brutal fighting game that continues the iconic Mortal Kombat series with new characters and fatalities.', 'Mortal_Kombat_11.png', 'Mortal_Kombat_11.mov', 9.00, 12000000),
(182, 'Street Fighter 6', 59.99, 'Capcom', '2023-06-02', 'A modern entry in the legendary fighting franchise, featuring new mechanics and characters.', 'Street_Fighter_6.png', 'Street_Fighter_6.mov', 9.20, 5000000),
(183, 'Tekken 7', 49.99, 'Bandai Namco Entertainment', '2017-06-02', 'A long-running fighting game series with deep mechanics and a huge roster of characters.', 'Tekken_7.png', 'Tekken_7.mov', 8.80, 8000000),
(184, 'Guilty Gear Strive', 59.99, 'Arc System Works', '2021-06-11', 'A visually stunning and fast-paced fighting game that features a cast of unique characters and deep mechanics.', 'Guilty_Gear_Strive.png', 'Guilty_Gear_Strive.mov', 9.10, 3000000),
(185, 'Dragon Ball FighterZ', 59.99, 'Bandai Namco Entertainment', '2018-01-26', 'A highly regarded fighting game featuring characters from the Dragon Ball universe with fast-paced, visually impressive combat.', 'Dragon_Ball_FighterZ.png', 'Dragon_Ball_FighterZ.mov', 9.00, 7000000),
(186, 'Injustice 2', 59.99, 'Warner Bros. Interactive Entertainment', '2017-05-16', 'A superhero-based fighting game where players battle as characters from the DC Comics universe.', 'Injustice_2.png', 'Injustice_2.mov', 8.70, 6000000),
(187, 'Super Smash Bros. Ultimate', 59.99, 'Nintendo', '2018-12-07', 'A chaotic and exciting brawler with characters from various franchises.', 'Super_Smash_Bros_Ultimate.png', 'Super_Smash_Bros_Ultimate.mov', 9.50, 33000000),
(188, 'Soulcalibur VI', 59.99, 'Bandai Namco Entertainment', '2018-10-19', 'A weapon-based fighting game with a long history and roster of unique characters.', 'Soulcalibur_VI.png', 'Soulcalibur_VI.mov', 8.50, 4000000),
(189, 'Dead or Alive 6', 59.99, 'Koei Tecmo', '2019-03-01', 'A fast-paced fighting game known for its highly detailed graphics and fluid combat mechanics.', 'Dead_or_Alive_6.png', 'Dead_or_Alive_6.mov', 8.30, 3000000),
(190, 'King of Fighters XV', 59.99, 'SNK', '2022-02-17', 'A classic 2D fighting game with a cast of diverse characters and fast-paced gameplay.', 'King_of_Fighters_XV.png', 'King_of_Fighters_XV.mov', 8.60, 2000000),
(191, 'Portal 2', 19.99, 'Valve', '2011-04-18', 'A first-person puzzle game that combines innovative mechanics and dark humor.', 'Portal_2.png', 'Portal_2.mov', 9.50, 11000000),
(192, 'The Witness', 39.99, 'Thekla, Inc.', '2016-01-26', 'A first-person puzzle game that features a vast open world and mind-bending puzzles.', 'The_Witness.png', 'The_Witness.mov', 9.10, 3000000),
(193, 'Tetris Effect: Connected', 39.99, 'Monstars', '2020-11-10', 'A visually stunning version of the classic Tetris game with new modes and effects.', 'Tetris_Effect_Connected.png', 'Tetris_Effect_Connected.mov', 9.00, 2000000),
(194, 'Baba Is You', 14.99, 'Hempuli', '2019-03-13', 'A unique puzzle game where players manipulate the rules of the game to solve challenges.', 'Baba_Is_You.png', 'Baba_Is_You.mov', 9.20, 1500000),
(195, 'Human: Fall Flat', 14.99, 'No Brakes Games', '2016-07-22', 'A physics-based puzzle game that challenges players to solve puzzles with unique mechanics.', 'Human_Fall_Flat.png', 'Human_Fall_Flat.mov', 8.50, 8000000),
(196, 'Monument Valley 2', 4.99, 'ustwo games', '2017-11-06', 'A visually captivating puzzle game where players manipulate the environment to guide characters through an abstract world.', 'Monument_Valley_2.png', 'Monument_Valley_2.mov', 9.30, 7000000),
(197, 'Puzzle Quest 3', 0.00, 'Infinity Plus 2', '2021-10-01', 'A match-3 puzzle game with RPG elements that features story-driven gameplay and strategic battles.', 'Puzzle_Quest_3.png', 'Puzzle_Quest_3.mov', 8.00, 4000000),
(198, 'It Takes Two', 39.99, 'Electronic Arts', '2021-03-26', 'A cooperative puzzle platformer that follows two characters on an emotional journey through imaginative worlds.', 'It_Takes_Two.png', 'It_Takes_Two.mov', 9.40, 6000000),
(199, 'Escape Simulator', 19.99, 'Pine Studio', '2021-10-19', 'A puzzle game that simulates real-life escape rooms where players solve puzzles to escape each room.', 'Escape_Simulator.png', 'Escape_Simulator.mov', 8.60, 2000000),
(200, 'Unpacking', 19.99, 'Witch Beam', '2021-11-02', 'A relaxing puzzle game where players unpack boxes and organize items in various rooms of a new home.', 'Unpacking.png', 'Unpacking.mov', 8.80, 3000000);

INSERT INTO GAMES

COMMIT;