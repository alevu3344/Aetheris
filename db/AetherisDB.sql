

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


CREATE TABLE PUBLISHERS (
  `PublisherName` varchar(50) NOT NULL,
  PRIMARY KEY (`PublisherName`)
) ENGINE=InnoDB;



CREATE TABLE CATEGORIES (
  `CategoryName` varchar(50) NOT NULL,
  PRIMARY KEY (`CategoryName`)
) ENGINE=InnoDB;


CREATE TABLE GAMES (
  `Id` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `Publisher` varchar(50) NOT NULL,
  `Category` varchar(50) NOT NULL,
  `ReleaseDate` date NOT NULL,
  `Description` text NOT NULL,
  `Image` varchar(50) NOT NULL,
  `Video` varchar(50) NOT NULL,
  `Rating` decimal(10,2) NOT NULL, -- Dato derivato, ma fare la query per calcolarlo è troppo costoso
  `CopiesSold` int(11) NOT NULL, -- Idem
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`Publisher`) REFERENCES PUBLISHERS(`PublisherName`),
  FOREIGN KEY (`Category`) REFERENCES CATEGORIES(`CategoryName`),
  CHECK (`StartDate` < `EndDate`)
) ENGINE=InnoDB;

CREATE TABLE DISCOUNTED_GAMES (
  `GameId` int(11) NOT NULL,
  `Percentage` int(11) NOT NULL CHECK (`Percentage` BETWEEN 0 AND 100),
  `StartDate` date NOT NULL,
  `EndDate` date NOT NULL,
  PRIMARY KEY (`GameId`, `StartDate`),
  FOREIGN KEY (`GameId`) REFERENCES GAMES(`Id`)
) ENGINE=InnoDB;



CREATE TABLE USERS(
  `Id` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Surname` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE SHOPPING_CARTS(
  `Id` int(11) NOT NULL,
  `UserId` int(11) NOT NULL references USERS(`Id`)
) ENGINE=InnoDB;


CREATE TABLE RECENSIONI (
  `Username` varchar(50) NOT NULL,
  `DataOra` datetime NOT NULL DEFAULT current_timestamp(),
  `GameID` int(11) NOT NULL,
  `Voto` int(11) NOT NULL CHECK (`Voto` BETWEEN 1 AND 5),
  `Commento` text DEFAULT NULL,
  PRIMARY KEY (`Username`, `DataOra`),
  FOREIGN KEY (`GameID`) REFERENCES GAMES(`Id`)
) ENGINE=InnoDB;


CREATE TABLE `UTENTI` (
  `Username` varchar(50) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Cognome` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Ruolo` enum('Amministratore','Cliente') NOT NULL DEFAULT 'Cliente',
  `Balance` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB;


CREATE TABLE ORDERS (
  `Id` int(11) NOT NULL AUTO_INCREMENT, -- Unique ID for the order
  `UserId` int(11) NOT NULL, -- Links to USERS table
  `OrderDate` datetime NOT NULL DEFAULT current_timestamp(), -- When the order was placed
  `TotalCost` decimal(10,2) NOT NULL, -- Total cost of the order
  `Status` enum('Pending', 'Completed', 'Shipped', 'Canceled') NOT NULL DEFAULT 'Pending', -- Order status
  PRIMARY KEY (`Id`),
  FOREIGN KEY (`UserId`) REFERENCES USERS(`Id`) -- Links to USERS table
) ENGINE=InnoDB;

CREATE TABLE ORDER_ITEMS (
  `OrderId` int(11) NOT NULL, -- Links to ORDERS table
  `GameId` int(11) NOT NULL, -- Links to GAMES table
  `Quantity` int(11) NOT NULL, -- Number of copies ordered
  `Price` decimal(10,2) NOT NULL, -- Price at the time of the order (for historical data)
  PRIMARY KEY (`OrderId`, `GameId`), -- Composite key ensures no duplicate game in the same order
  FOREIGN KEY (`OrderId`) REFERENCES ORDERS(`Id`), -- Links to ORDERS table
  FOREIGN KEY (`GameId`) REFERENCES GAMES(`Id`) -- Links to GAMES table
) ENGINE=InnoDB;


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
('Puzzle/Logic');

INSERT INTO PUBLISHERS (PublisherName) VALUES
('Nintendo'),
('Rockstar Games'),
('Sony Interactive Entertainment'),
('Square Enix'),
('Bethesda Softworks'),
('Electronic Arts'),
('Valve'),
('Bandai Namco Entertainment'),
('Ubisoft'),
('Epic Games');

INSERT INTO GAMES (Id, Name, Price, Publisher, Category, ReleaseDate, Description, Image, Video, Rating, CopiesSold) VALUES
(1, 'The Legend of Zelda: Breath of the Wild', 59.99, 'Nintendo', 'Action/Adventure', '2017-03-03', 'An open-world adventure game set in the Zelda universe.', 'The_Legend_of_Zelda:_Breath_of_the_Wild.png', 'The_Legend_of_Zelda:_Breath_of_the_Wild.mov', 10.00, 10000000),
(2, 'Red Dead Redemption 2', 59.99, 'Rockstar Games', 'Action/Adventure', '2018-10-26', 'A Western-themed open-world action game.', 'Red_Dead_Redemption_2.png', 'Red_Dead_Redemption_2.mov', 9.8, 20000000),
(3, 'God of War (2018)', 49.99, 'Sony Interactive Entertainment', 'Action/Adventure', '2018-04-20', 'A brutal and emotional journey in the world of Norse mythology.', 'God_of_War_2018.png', 'God_of_War_2018.mov', 9.7, 15000000),
(4, 'Horizon Zero Dawn', 39.99, 'Sony Interactive Entertainment', 'Action/Adventure', '2017-02-28', 'An open-world action RPG with a futuristic setting.', 'Horizon_Zero_Dawn.png', 'Horizon_Zero_Dawn.mov', 9.6, 9000000),
(5, 'Assassin’s Creed Valhalla', 59.99, 'Ubisoft', 'Action/Adventure', '2020-11-10', 'A Viking-themed action RPG with open-world exploration.', 'Assassins_Creed_Valhalla.png', 'Assassins_Creed_Valhalla.mov', 9.2, 12000000),
(6, 'Ghost of Tsushima', 59.99, 'Sony Interactive Entertainment', 'Action/Adventure', '2020-07-17', 'A samurai action RPG set in feudal Japan.', 'Ghost_of_Tsushima.png', 'Ghost_of_Tsushima.mov', 9.4, 7000000),
(7, 'Tomb Raider (2013)', 19.99, 'Square Enix', 'Action/Adventure', '2013-03-05', 'A re-imagining of the classic action-adventure series.', 'Tomb_Raider_2013.png', 'Tomb_Raider_2013.mov', 8.5, 14000000),
(8, 'Uncharted 4: A Thief\'s End', 59.99, 'Sony Interactive Entertainment', 'Action/Adventure', '2016-05-10', 'A treasure hunter’s adventure filled with action and puzzle-solving.', 'Uncharted_4_A_Thiefs_End.png', 'Uncharted_4_A_Thiefs_End.mov', 9.7, 16000000),
(9, 'Batman: Arkham Knight', 29.99, 'Warner Bros. Interactive Entertainment', 'Action/Adventure', '2015-06-23', 'A superhero action game featuring Batman in Gotham City.', 'Batman_Arkham_Knight.png', 'Batman_Arkham_Knight.mov', 9.1, 9000000),
(10, 'Spider-Man: Miles Morales', 49.99, 'Sony Interactive Entertainment', 'Action/Adventure', '2020-11-12', 'The story of Miles Morales as the new Spider-Man.', 'Spider_Man_Miles_Morales.png', 'Spider_Man_Miles_Morales.mov', 9.6, 8000000),
(11, 'The Last of Us Part II', 59.99, 'Sony Interactive Entertainment', 'Action/Adventure', '2020-06-19', 'A post-apocalyptic action-adventure with deep narrative elements.', 'The_Last_of_Us_Part_II.png', 'The_Last_of_Us_Part_II.mov', 9.5, 11000000),
(12, 'Control', 39.99, '505 Games', 'Action/Adventure', '2019-08-27', 'A surreal third-person action game with supernatural elements.', 'Control.png', 'Control.mov', 9.2, 7000000),
(13, 'Sekiro: Shadows Die Twice', 59.99, 'Activision', 'Action/Adventure', '2019-03-22', 'A punishing action RPG set in a war-torn feudal Japan.', 'Sekiro_Shadows_Die_Twice.png', 'Sekiro_Shadows_Die_Twice.mov', 9.8, 4000000),
(14, 'Death Stranding', 59.99, 'Sony Interactive Entertainment', 'Action/Adventure', '2019-11-08', 'An open-world action game set in a post-apocalyptic world.', 'Death_Strandling.png', 'Death_Strandling.mov', 9.1, 8000000),
(15, 'Days Gone', 39.99, 'Sony Interactive Entertainment', 'Action/Adventure', '2019-04-26', 'An open-world survival action game set in a post-apocalyptic world.', 'Days_Gone.png', 'Days_Gone.mov', 8.8, 6000000),
(16, 'Far Cry 5', 59.99, 'Ubisoft', 'Action/Adventure', '2018-03-27', 'An open-world shooter set in a Montana county taken over by a cult.', 'Far_Cry_5.png', 'Far_Cry_5.mov', 8.7, 8000000),
(17, 'Watch Dogs: Legion', 59.99, 'Ubisoft', 'Action/Adventure', '2020-10-29', 'A hacker-focused action game set in a dystopian London.', 'Watch_Dogs_Legion.png', 'Watch_Dogs_Legion.mov', 8.4, 5000000),
(18, 'Metal Gear Solid V: The Phantom Pain', 59.99, 'Konami', 'Action/Adventure', '2015-09-01', 'An open-world stealth action game with military espionage elements.', 'Metal_Gear_Solid_V.png', 'Metal_Gear_Solid_V.mov', 9.3, 12000000),
(19, 'Dishonored 2', 39.99, 'Bethesda Softworks', 'Action/Adventure', '2016-11-11', 'A stealth action game set in a steampunk-inspired world.', 'Dishonored_2.png', 'Dishonored_2.mov', 9.0, 4000000),
(20, 'Dying Light 2', 59.99, 'Techland', 'Action/Adventure', '2022-02-04', 'A zombie apocalypse game with parkour-based movement and combat.', 'Dying_Light_2.png', 'Dying_Light_2.mov', 8.7, 6000000),
(21, 'Elden Ring', 59.99, 'Bandai Namco Entertainment', 'RPG', '2022-02-25', 'An open-world action RPG set in a fantasy world with a dark, atmospheric setting.', 'Elden_Ring.png', 'Elden_Ring.mov', 10.00, 20000000),
(22, 'Skyrim (The Elder Scrolls V)', 39.99, 'Bethesda Softworks', 'RPG', '2011-11-11', 'An open-world RPG set in a high fantasy universe filled with dragons and magic.', 'Skyrim.png', 'Skyrim.mov', 9.9, 30000000);