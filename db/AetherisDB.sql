
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE AetherisDB
    CHARACTER SET utf8
    COLLATE utf8_general_ci;

USE AetherisDB;


CREATE TABLE PUBLISHERS (
  PublisherName varchar(50) NOT NULL,

  PRIMARY KEY (PublisherName)
);

CREATE TABLE CATEGORIES (
  CategoryName varchar(50) NOT NULL,

  PRIMARY KEY (CategoryName)
);

CREATE TABLE GAMES (
  Id             int(11) NOT NULL AUTO_INCREMENT,
  Name           varchar(50) NOT NULL,
  Price          decimal(10,2) NOT NULL,
  Publisher      varchar(50) NOT NULL,
  ReleaseDate    date NOT NULL,
  Description    text NOT NULL,
  Trailer        varchar(50) NOT NULL,
  Rating         decimal(10,2) NOT NULL, -- Dato derivato, ma fare la query per calcolarlo è troppo costoso
  CopiesSold     int(11) NOT NULL, -- Idem

  PRIMARY KEY (Id),
  FOREIGN KEY (Publisher) REFERENCES PUBLISHERS(PublisherName),
  UNIQUE KEY (Name)
);

CREATE TABLE GAME_CATEGORIES (
  GameId        int(11) NOT NULL,
  CategoryName  varchar(50) NOT NULL,

  PRIMARY KEY (GameId, CategoryName),
  FOREIGN KEY (GameId) REFERENCES GAMES(Id),
  FOREIGN KEY (CategoryName) REFERENCES CATEGORIES(CategoryName)
);


CREATE TABLE DISCOUNTED_GAMES (
  GameId      int(11) NOT NULL,
  Percentage  int(11) NOT NULL CHECK (Percentage BETWEEN 0 AND 100),
  StartDate   date NOT NULL,
  EndDate     date NOT NULL,

  PRIMARY KEY (GameId, StartDate),
  FOREIGN KEY (GameId) REFERENCES GAMES(Id),
  CHECK (StartDate < EndDate)
);

CREATE TABLE USERS (
    UserID           INT AUTO_INCREMENT PRIMARY KEY,                                  -- Unique identifier for the user
    Username         VARCHAR(50) NOT NULL UNIQUE,                                     -- Unique username for login
    Email            VARCHAR(255) NOT NULL UNIQUE,                                    -- Unique email address
    DELETEMEClearPassword VARCHAR(255),                                              -- Clear password (left possibly null for development)
    PasswordHash     VARCHAR(255),                                                    -- Hashed password (left possibly null for development)
    Salt             VARCHAR(255),                                                    -- Salt for password hashing
    FirstName        VARCHAR(100),                                                    -- User"s first name
    LastName         VARCHAR(100),                                                    -- User"s last name
    Role             ENUM("Admin", "User") DEFAULT "User",                            -- User role (Admin or User)
    PhoneNumber      VARCHAR(20),                                                     -- Contact number
    Address          TEXT,                                                            -- User"s address
    City             VARCHAR(50),                                                     -- User"s city 
    DateOfBirth      DATE,                                                            -- Optional for profile
    CreatedAt        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                             -- Account creation timestamp
    UpdatedAt        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update
    Status           ENUM("Active", "Inactive", "Banned") DEFAULT "Active",           -- Account status
    LastLoginAt      TIMESTAMP NULL,                                                  -- Timestamp of the last login
    LoginAttempts    INT DEFAULT 0,                                                   -- Count for failed login attempts
    Balance          DECIMAL(10,2) DEFAULT 0.00                                       -- User"s account balance
);




CREATE TABLE SHOPPING_CARTS(
  UserId    int(11) NOT NULL references USERS(Username),
  GameId    int(11) NOT NULL references GAMES(Id),
  Quantity  int (11) NOT NULL,

  PRIMARY KEY (UserId,GameId)
);

CREATE TABLE REVIEWS (
  Title        varchar(50) NOT NULL,
  CreatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
  Comment      text NOT NULL,
  Rating       decimal(10,2) NOT NULL CHECK (Rating BETWEEN 0 AND 5),
  GameID       int(11) NOT NULL,
  UserID       int(11) NOT NULL,

  FOREIGN KEY (GameID) REFERENCES GAMES(Id),
  FOREIGN KEY (UserID) REFERENCES USERS(UserID)
);




CREATE TABLE ORDERS (
  Id int(11) NOT NULL AUTO_INCREMENT, -- Unique ID for the order
  UserId varchar(50) NOT NULL, -- Links to USERS table
  OrderDate datetime NOT NULL DEFAULT current_timestamp(), -- When the order was placed
  TotalCost decimal(10,2) NOT NULL, -- Total cost of the order
  Status enum("Pending", "Completed", "Shipped", "Canceled") NOT NULL DEFAULT "Pending", -- Order status
  PRIMARY KEY (Id),
  FOREIGN KEY (UserId) REFERENCES USERS(Username) -- Links to USERS table
);

CREATE TABLE ORDER_ITEMS (
  OrderId int(11) NOT NULL, -- Links to ORDERS table
  GameId int(11) NOT NULL, -- Links to GAMES table
  Quantity int(11) NOT NULL, -- Number of copies ordered
  Price decimal(10,2) NOT NULL, -- Price at the time of the order (for historical data)
  PRIMARY KEY (OrderId, GameId), -- Composite key ensures no duplicate game in the same order
  FOREIGN KEY (OrderId) REFERENCES ORDERS(Id), -- Links to ORDERS table
  FOREIGN KEY (GameId) REFERENCES GAMES(Id) -- Links to GAMES table
);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Gioco fantastico", "Questo gioco è un vero classico, ottima strategia e rigiocabilità!", 4.5, 198, 1),
("Ottimo gioco di strategia", "Adoro la meccanica del gioco e le campagne storiche. A volte è un po' difficile!", 4.0, 198, 2),
("Classico senza tempo", "Il gioco resiste anche oggi, un RTS straordinario con tanta profondità.", 5.0, 198, 3),
("Nostalgico", "Ho passato tantissime ore su questo gioco da bambino. È ancora divertente oggi!", 4.8, 198, 4),
("Gameplay solido", "RTS solido, ma la grafica potrebbe avere qualche aggiornamento moderno.", 3.5, 198, 5),
("Divertente, ma difficile", "Ottimi elementi strategici, ma a volte l'IA è troppo difficile.", 3.8, 198, 6),
("Capolavoro", "Uno dei migliori giochi RTS, la profondità è senza pari.", 5.0, 198, 7),
("Bello, ma datato", "Sebbene sia divertente, si sente decisamente un po' vecchio rispetto agli standard moderni.", 3.9, 198, 8),
("Sfida e dipendenza", "Continuo a tornare su questo gioco. C'è sempre qualcosa da imparare e perfezionare!", 4.7, 198, 9),
("Age of Empires", "Questo gioco ha alzato la soglia per gli RTS, ed è ancora divertente!", 4.2, 198, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Evoluzione fantastica", "Age of Empires III migliora ogni aspetto del suo predecessore, con nuove meccaniche e civiltà interessanti.", 4.5, 199, 1),
("Ottima strategia", "Molto divertente, ma a volte le meccaniche di combattimento possono sembrare ripetitive.", 4.0, 199, 2),
("Gioco interessante", "Le nuove civiltà e le opzioni strategiche sono un grande passo avanti, ma la campagna è un po' debole.", 4.2, 199, 3),
("Migliore di AoE II", "Molto più dinamico rispetto ad Age of Empires II, ma la gestione delle risorse è complicata.", 4.7, 199, 4),
("Strategico ma lungo", "Partite molto lunghe, ma decisamente soddisfacenti se hai pazienza per il micromanagement.", 3.9, 199, 5),
("Gran gioco", "Uno dei migliori RTS, ma la curva di difficoltà è un po' ripida per i nuovi giocatori.", 4.6, 199, 6),
("Divertente, ma va migliorato", "Ottima grafica e gameplay, ma alcune meccaniche di gioco potrebbero essere riviste.", 4.0, 199, 7),
("Un po' noioso", "Pur essendo un buon gioco, a lungo andare la ripetitività delle missioni può stancare.", 3.8, 199, 8),
("Ottimo multiplayer", "Il multiplayer è il punto forte, le partite online sono sempre molto competitive.", 4.9, 199, 9),
("Age of Empires III", "Uno dei migliori RTS di sempre, ma potrebbe essere ancora più rifinito in alcuni aspetti.", 4.3, 199, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Evoluzione moderna", "Age of Empires IV porta il franchise nel futuro con ottima grafica e nuove meccaniche. Perfetto per i fan della saga!", 4.6, 68, 1),
("Molto promettente", "Ottimo gioco con una grafica incredibile, ma la campagna potrebbe essere un po' più variegata.", 4.3, 68, 2),
("Un passo avanti", "Il miglior Age of Empires in termini di meccaniche di gioco, ma ci sono ancora alcuni bug da sistemare.", 4.4, 68, 3),
("Gameplay solido", "Le nuove civiltà sono interessanti e le battaglie sono spettacolari, ma qualche miglioramento è necessario sulla AI.", 4.1, 68, 4),
("Interessante, ma non perfetto", "Il gioco è divertente, ma manca di quel 'qualcosa in più' che aveva Age of Empires II.", 3.9, 68, 5),
("Ottima grafica", "Le animazioni e la grafica sono davvero bellissime, ma mi aspettavo una trama più coinvolgente nella campagna.", 4.0, 68, 6),
("Bel gioco, ma lento", "Il ritmo delle partite può essere un po' lento e la gestione delle risorse non è sempre chiara.", 3.8, 68, 7),
("Buon RTS", "Le meccaniche sono divertenti, ma a volte il gioco può sembrare troppo complesso per i nuovi arrivati nel genere.", 4.2, 68, 8),
("Consolidamento del franchise", "Un ottimo gioco che mantiene vivo il franchise, ma qualche miglioramento nella gestione delle unità non guasterebbe.", 4.5, 68, 9),
("AoE IV", "Un altro classico RTS, ma con un tocco moderno. Alcuni bug nell'interfaccia utente, ma niente che rovini l'esperienza.", 4.0, 68, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Ottimo gioco di sopravvivenza", "Albion Online offre un'esperienza unica di MMO, con molta libertà nelle scelte. La parte PvP è davvero coinvolgente!", 4.5, 128, 1),
("Un gioco che richiede tempo", "È un gioco che richiede impegno, ma la libertà che offre vale sicuramente la pena. La community è anche ottima.", 4.2, 128, 2),
("Molto divertente", "Un MMORPG che non si ferma mai a sorprenderci. Il crafting e l'economia sono davvero ben fatti.", 4.6, 128, 3),
("Non è per tutti", "Richiede molta dedizione per essere apprezzato. Per chi cerca un gioco facile, non è l'ideale.", 3.8, 128, 4),
("Bel mondo, ma pochi contenuti", "Il mondo di gioco è interessante, ma manca un po' di contenuti che lo rendano davvero ricco.", 3.9, 128, 5),
("Flessibilità fantastica", "Mi piace molto come posso scegliere il mio percorso nel gioco, sia in PvE che PvP. Un gioco da giocare con calma.", 4.7, 128, 6),
("Gioco impegnativo", "Richiede molto tempo per diventare competitivo, ma se hai la pazienza, è un'esperienza che vale la pena.", 4.3, 128, 7),
("Un mix interessante", "L'idea di avere un mondo completamente basato sull'economia e sul crafting è affascinante, ma la parte PvP è troppo aggressiva.", 4.1, 128, 8),
("Ottima community", "La community di Albion è molto accogliente. È difficile trovare giochi con un ambiente così positivo!", 4.8, 128, 9),
("Albion Online", "Un buon gioco, ma non adatto a chi cerca un MMO più tradizionale con storyline forti. Flessibile, ma difficile.", 4.0, 128, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Gioco spaventoso", "Amnesia è un capolavoro del genere horror. La suspense è pazzesca e l'atmosfera ti tiene costantemente sull'orlo del panico!", 5.0, 142, 1),
("Un'esperienza unica", "La paura psicologica è ciò che rende questo gioco unico. È un viaggio nel terrore che non dimenticherai facilmente.", 4.8, 142, 2),
("Ottimo, ma difficile", "La trama è fantastica e l'atmosfera da brivido è incredibile, ma alcuni puzzle sono troppo difficili e rallentano il gioco.", 4.2, 142, 3),
("Terrore puro", "Il miglior gioco horror che abbia mai giocato. Le ombre, i suoni e l'ambientazione ti coinvolgono completamente.", 5.0, 142, 4),
("Atmosfera spettrale", "Ottimo gioco, ma a volte le meccaniche di gioco non sono chiare. Il vero protagonista è l'atmosfera.", 4.1, 142, 5),
("Impressionante", "Un gioco horror che sa come terrorizzare senza ricorrere a jump scare. La tensione è palpabile in ogni momento.", 4.9, 142, 6),
("Pieno di tensione", "L'atmosfera è terrificante, e la solitudine nel gioco rende l'esperienza ancora più inquietante. Non adatto a chi ha il cuore debole!", 4.7, 142, 7),
("Un classico dell'horror", "Un must per gli appassionati di giochi horror. La trama è avvincente e ti lascia con molte domande senza risposta.", 4.5, 142, 8),
("Stupendo ma inquietante", "Il gioco ti mette davvero alla prova. Ogni passo è un'incognita, ed è quasi impossibile non sentirsi a disagio.", 4.6, 142, 9),
("Gioco molto immersivo", "Un'esperienza da provare per chi ama l'horror psicologico. Ma attenzione, potrebbe farti restare sveglio la notte!", 4.3, 142, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Divertentissimo in compagnia", "Among Us è un gioco incredibile se giocato con gli amici. Le dinamiche di sospetto e tradimento sono esilaranti!", 4.8, 97, 1),
("Molto divertente", "Il gioco è semplice ma coinvolgente, ottimo per passare del tempo con gli amici, anche se può diventare un po' ripetitivo.", 4.2, 97, 2),
("Il gioco del momento", "Non c'è nulla di meglio che giocare a Among Us con amici. Ogni partita è diversa e ti tiene sempre sulle spine.", 4.7, 97, 3),
("Gioco divertente, ma troppo competitivo", "Ottimo gioco, ma se giocato con persone troppo competitive può diventare frustrante. Comunque, molto divertente!", 4.0, 97, 4),
("Impossibile non ridere", "Le accuse e le difese durante il gioco sono esilaranti. Un gioco da fare in gruppo per un'esperienza davvero divertente.", 5.0, 97, 5),
("Un po' troppo semplice", "Il gioco è molto divertente, ma la meccanica di base è piuttosto semplice e può stancare dopo un po'.", 3.9, 97, 6),
("Ottimo per gruppi", "Among Us è perfetto per i gruppi di amici. La tensione e l'incertezza ti tengono incollato al gioco.", 4.6, 97, 7),
("Gioco carino ma ripetitivo", "Gioco divertente e semplice, ma con il tempo può diventare ripetitivo. Più interessante quando ci sono amici coinvolti.", 4.1, 97, 8),
("Intrigante e divertente", "La strategia e la psicologia dietro ogni partita sono fantastiche. Ogni volta che giochi, l'esperienza è diversa.", 4.7, 97, 9),
("Among Us", "Un gioco che prende vita solo con un gruppo di amici. La suspense e il bluff sono il cuore del gioco.", 4.4, 97, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Gioco rilassante", "Animal Crossing: New Horizons è il gioco perfetto per rilassarsi. Puoi costruire e personalizzare l'isola a tuo piacimento, senza pressioni.", 5.0, 132, 1),
("Adorabile e creativo", "La possibilità di creare la propria isola è fantastica. Ogni giorno è un'opportunità per decorare e fare nuove scoperte.", 4.8, 132, 2),
("Un gioco per tutte le età", "Perfetto per tutti, dai bambini agli adulti. È molto rilassante e la grafica è adorabile!", 4.7, 132, 3),
("Tanto da fare", "Ci sono così tante attività da fare: pescare, raccogliere frutta, decorare la casa e l'isola. Non ci si annoia mai!", 4.6, 132, 4),
("Poco impegnativo, ma divertente", "Non è un gioco che richiede molta abilità, ma è divertente e permette di esprimere la propria creatività.", 4.3, 132, 5),
("Un'isola tutta mia", "L'esperienza di costruire e personalizzare l'isola è unica. È un gioco che ti fa sentire davvero soddisfatto dei progressi.", 4.9, 132, 6),
("Ripetitivo", "Il gioco è bellissimo, ma alla lunga può diventare un po' ripetitivo, soprattutto quando hai esaurito le opzioni di personalizzazione.", 3.8, 132, 7),
("Perfetto per staccare", "Un gioco ideale per chi vuole staccare dalla realtà. Passare del tempo a personalizzare l'isola è molto piacevole.", 4.5, 132, 8),
("Una seconda casa virtuale", "Mi sento come se avessi una seconda casa sull'isola. È incredibile come si possa personalizzare tutto e incontrare nuovi amici virtuali!", 4.7, 132, 9),
("Ottimo per passare il tempo", "Semplice e rilassante, ma allo stesso tempo offre un sacco di cose da fare. È ideale per chi vuole un gioco senza stress.", 4.4, 132, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un grande gioco di strategia", "Anno 1800 è un capolavoro di strategia e gestione delle risorse. La grafica è spettacolare e la varietà di contenuti è impressionante.", 4.8, 73, 1),
("Complessità e profondità", "Ogni partita è una sfida diversa. La gestione delle città e la pianificazione delle rotte commerciali sono il cuore del gioco, ma è difficile all'inizio.", 4.5, 73, 2),
("Un gioco che ti tiene occupato", "Anno 1800 ti cattura con la sua profondità. C'è sempre qualcosa da fare, che si tratti di espandere la città o commerciare con altre nazioni.", 4.7, 73, 3),
("Ottimo ma difficile", "Il gioco è fantastico, ma richiede molta strategia e pianificazione. La curva di apprendimento è ripida, ma ne vale la pena.", 4.3, 73, 4),
("Gestione e commercio", "La parte di commercio e costruzione è ben fatta. Mi piace davvero come ogni città può evolversi in modo diverso a seconda delle scelte fatte.", 4.6, 73, 5),
("Storia e gameplay coinvolgente", "La campagna è ben scritta e offre una buona varietà di missioni. La modalità sandbox è altrettanto interessante.", 4.4, 73, 6),
("Non per tutti", "Anno 1800 è un gioco che richiede molto tempo e dedizione. Non è adatto a chi cerca giochi veloci, ma per gli appassionati di simulazioni è perfetto.", 3.9, 73, 7),
("Un must per gli amanti della strategia", "Se ami i giochi di strategia e gestione, Anno 1800 è un must. La possibilità di costruire una città prospera e gestire il commercio è semplicemente fantastica.", 4.8, 73, 8),
("Perfetto per pianificatori", "Un gioco che premia la pianificazione. Ogni scelta che fai ha un impatto sulla tua economia e sulla prosperità della città.", 4.7, 73, 9),
("Eccellente, ma impegnativo", "Anno 1800 è un gioco incredibile con una grande varietà di meccaniche. Tuttavia, può risultare molto impegnativo, soprattutto se non sei un esperto del genere.", 4.2, 73, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco di corse spettacolare", "Asphalt 9 è una vera gioia per gli amanti delle corse. Le grafiche sono incredibili e la velocità del gioco è esaltante.", 4.9, 166, 1),
("Perfetto per giocare in mobilità", "Un gioco perfetto per giocare in qualsiasi momento. Le meccaniche sono facili da imparare e le corse sono sempre intense.", 4.6, 166, 2),
("Grafica incredibile", "La qualità grafica di Asphalt 9 è davvero sorprendente, ma il gioco diventa un po' ripetitivo se si gioca troppo a lungo.", 4.4, 166, 3),
("Divertente, ma pay-to-win", "Le corse sono molto divertenti, ma c'è una sensazione di pay-to-win a causa degli acquisti in-app che influiscono sulle prestazioni dei veicoli.", 3.8, 166, 4),
("Eccellente gioco di corse arcade", "Un gioco arcade di corse veramente eccellente. Il controllo delle auto è perfetto e la varietà di veicoli è enorme.", 4.7, 166, 5),
("Un gioco veloce e frenetico", "Le corse sono veloci, frenetiche e piene di adrenalina. Un ottimo gioco per gli appassionati di giochi di corsa ad alta velocità!", 4.8, 166, 6),
("Un'esperienza visiva unica", "La grafica è senza dubbio il punto forte di Asphalt 9. Le ambientazioni sono mozzafiato e ogni corsa è un'esperienza visiva unica.", 4.9, 166, 7),
("Gioco di corse adatto a tutti", "Ottimo gioco per chi ama le corse. Non richiede molta esperienza, ed è facile entrare nel ritmo delle corse.", 4.5, 166, 8),
("Divertente ma poco realistico", "Il gioco è molto divertente, ma manca di realismo. Le corse sono più arcade che simulazioni, quindi non aspettarti un'esperienza di guida simulata.", 4.2, 166, 9),
("Buon gioco, ma troppi microtransazioni", "La grafica è fantastica e il gameplay è eccellente, ma il gioco è pieno di microtransazioni che rovinano un po' l'esperienza.", 4.0, 166, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno alle origini", "Assassin's Creed Mirage è un ritorno alle origini della saga, con un gameplay più focalizzato sull'assassinio stealth e l'esplorazione. Ottimo per i fan della serie!", 4.8, 197, 1),
("Affascinante e coinvolgente", "Il gioco offre un'atmosfera affascinante e coinvolgente. Le ambientazioni storiche sono ben curate, ma la storia potrebbe essere più avvincente.", 4.5, 197, 2),
("Ottima grafica, ma la trama è un po' debole", "Le grafica è splendida e le meccaniche di gioco sono solide, ma la trama non è all'altezza di altri capitoli della saga.", 4.2, 197, 3),
("Una buona evoluzione", "Mirage è una buona evoluzione per la serie. Le missioni di assassinio sono più varie e appaganti rispetto ad altri titoli.", 4.6, 197, 4),
("Gioco troppo corto", "Il gioco è ottimo, ma è davvero troppo corto rispetto agli altri capitoli. Avrei voluto più contenuti e missioni secondarie.", 3.9, 197, 5),
("Poco innovativo", "Il gioco è buono, ma non offre grandi novità rispetto ai titoli precedenti. Chi è un veterano della saga potrebbe sentirsi un po' deluso dalla mancanza di innovazione.", 4.0, 197, 6),
("Un ritorno al passato", "Mirage riporta la serie alle radici, con un gameplay che si concentra di più sull'infiltrazione e sull'assassinio, che trovo molto piacevole.", 4.7, 197, 7),
("Buona atmosfera, ma poco coinvolgente", "L'atmosfera di Mirage è fantastica, ma la trama e le meccaniche di gioco non riescono a mantenere alta la tensione per tutta la durata.", 4.1, 197, 8),
("Storia interessante", "La storia di Mirage è interessante, ma a volte sembra un po' forzata. Le missioni sono comunque molto divertenti e impegnative.", 4.3, 197, 9),
("Un gioco solido", "Assassin's Creed Mirage è un gioco solido e ben progettato, con un buon mix di azione e stealth. Sarebbe stato meglio con qualche contenuto in più.", 4.4, 197, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'avventura epica", "Assassin's Creed Odyssey è un'avventura epica con una storia coinvolgente e un mondo vasto da esplorare. Le opzioni di dialogo e le scelte morali sono ottime!", 4.9, 193, 1),
("Troppo lungo", "Il gioco è fantastico, ma le dimensioni e la durata possono diventare opprimenti. A volte ci sono troppe missioni da completare.", 4.2, 193, 2),
("Un gioco stupendo", "La Grecia antica è ricreata magnificamente. La possibilità di esplorare un mondo così vasto è impressionante, ma la trama principale potrebbe essere più focalizzata.", 4.7, 193, 3),
("Un po' troppo grindy", "Il gioco è magnifico, ma alcune missioni richiedono troppo grinding. Nonostante ciò, la storia e il gameplay sono davvero coinvolgenti.", 4.4, 193, 4),
("Un capolavoro", "Assassin's Creed Odyssey è uno dei migliori giochi della saga. La libertà di esplorazione, la battaglia e la personalizzazione sono eccezionali.", 5.0, 193, 5),
("Un po' troppa ripetitività", "Ottimo gioco, ma a volte le missioni si sentono ripetitive. Alcuni combattimenti e situazioni potrebbero essere più variegati.", 4.1, 193, 6),
("Storia coinvolgente", "La storia di Kassandra è avvincente e la possibilità di scegliere il proprio percorso rende il gioco ancora più interessante.", 4.8, 193, 7),
("Eccellente, ma con troppe missioni secondarie", "Il gioco è ottimo, ma la quantità di missioni secondarie può diventare opprimente. Per quanto siano varie, alcune sembrano poco ispirate.", 4.3, 193, 8),
("Un'esperienza unica", "L'esplorazione della Grecia antica è un'esperienza unica. Le battaglie navali e terrestri sono spettacolari, ma a volte il gameplay può risultare un po' ripetitivo.", 4.6, 193, 9),
("Un gioco che ti prende", "Non c'è mai un momento noioso in Odyssey. Le missioni principali e secondarie sono ben progettate e la possibilità di esplorare il mondo è senza pari.", 4.7, 193, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un nuovo inizio", "Assassin's Creed Origins segna un nuovo inizio per la serie, con un gameplay più RPG e una storia che esplora le origini degli Assassini. Veramente coinvolgente!", 4.8, 192, 1),
("Mondo affascinante", "L'antico Egitto è magnificamente ricreato. Il gioco offre un'esplorazione unica in un contesto storico straordinario, ma la trama è un po' prevedibile.", 4.5, 192, 2),
("Gran cambiamento per la saga", "Il cambio di formula rispetto ai titoli precedenti è positivo. Le meccaniche RPG funzionano molto bene, ma la navigazione su terreno può risultare a volte un po' faticosa.", 4.6, 192, 3),
("Ottima ambientazione", "La ricreazione dell'Egitto antico è incredibile. Le missioni sono varie, ma alcune ripetitive. Nel complesso, un gioco davvero solido.", 4.4, 192, 4),
("Un po' troppo grindy", "La storia e l'atmosfera sono ottime, ma il gioco diventa troppo un “grind” con le sue missioni secondarie, che possono sembrare un po' ripetitive.", 4.1, 192, 5),
("Un'esperienza indimenticabile", "Assassin's Creed Origins è un gioco che ti fa sentire come se fossi realmente nell'antico Egitto. La storia è coinvolgente e le battaglie sono ben fatte.", 4.9, 192, 6),
("Battaglie spettacolari", "Le battaglie sono spettacolari e molto più tecniche rispetto ai giochi precedenti. L'esplorazione dell'Egitto è un punto forte, ma la trama potrebbe essere più forte.", 4.7, 192, 7),
("Gran gioco, ma troppo lungo", "Il gioco è fantastico e offre un mondo vasto da esplorare, ma a volte le missioni sembrano troppo lunghe, e la trama principale perde un po' di mordente.", 4.2, 192, 8),
("Gameplay migliorato", "Il gameplay è molto migliorato rispetto ai precedenti capitoli, con una bella aggiunta di elementi RPG. Tuttavia, la parte di combattimento può essere un po' ripetitiva.", 4.3, 192, 9),
("Un inizio perfetto per una nuova era", "Origins reinventa la saga con una solida base RPG, una buona storia e un mondo da esplorare. Non è perfetto, ma è sicuramente un ottimo punto di partenza per la serie.", 4.6, 192, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capitolo sottovalutato", "Assassin's Creed Rogue è un capitolo sottovalutato della saga. La storia è interessante e il gameplay ben strutturato, con un ottimo mix di azione e stealth.", 4.7, 194, 1),
("Un buon gioco, ma meno coinvolgente", "Rogue è un buon gioco, ma non riesce a coinvolgere come altri capitoli della saga. La parte navale è divertente, ma la trama non è altrettanto forte.", 4.2, 194, 2),
("Una storia diversa", "Il cambio di prospettiva, giocando come un Templare, offre una storia interessante e fresca. Le missioni sono buone, ma la grafica potrebbe essere migliore.", 4.4, 194, 3),
("Non all'altezza dei predecessori", "Rogue è un gioco divertente, ma non raggiunge gli stessi standard di qualità di Black Flag o Unity. La parte navale è la migliore, ma la trama è più debole.", 4.0, 194, 4),
("Una bella aggiunta alla saga", "Anche se non ha avuto lo stesso successo di altri titoli, Rogue offre una storia solida e un gameplay che ricorda molto Black Flag, con qualche aggiunta interessante.", 4.6, 194, 5),
("Troppo simile a Black Flag", "Il gioco è praticamente identico a Black Flag, con poche novità. Sebbene la parte navale sia divertente, manca di originalità in molti aspetti.", 3.8, 194, 6),
("Gran gameplay, trama migliorabile", "Il gameplay è davvero coinvolgente, ma la trama poteva essere sviluppata meglio. Giocare da Templare è un'idea interessante, ma non viene esplorata abbastanza in profondità.", 4.3, 194, 7),
("Un buon gioco per i fan", "Per i fan della saga, Rogue è un gioco che vale la pena giocare. La parte navale è ben fatta e la storia, sebbene non eccezionale, ha un buon ritmo.", 4.5, 194, 8),
("Interessante, ma non rivoluzionario", "Rogue offre un'esperienza di gioco simile a Black Flag, ma non riesce a fare quel passo in avanti che molti si aspettavano. La parte navale è la più divertente.", 4.1, 194, 9),
("Un'esperienza solida", "Assassin's Creed Rogue offre una solida esperienza di gioco, ma manca della profondità che altri capitoli della saga hanno. La storia e il mondo sono buoni, ma non eccezionali.", 4.2, 194, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un salto nella Londra vittoriana", "Assassin's Creed Syndicate è un gioco che ti immerge completamente nella Londra vittoriana. Le ambientazioni sono fantastiche e la doppia prospettiva con Jacob e Evie è una gran novità.", 4.8, 196, 1),
("Storia interessante, ma troppo semplice", "La storia è interessante, ma sembra un po' troppo lineare e semplice rispetto ad altri capitoli della saga. Le meccaniche di gioco sono comunque divertenti e ben fatte.", 4.3, 196, 2),
("Divertente ma non innovativo", "Syndicate è divertente, ma non aggiunge molto di nuovo rispetto ai capitoli precedenti. La possibilità di giocare come due protagonisti è interessante, ma non cambia molto il gameplay.", 4.0, 196, 3),
("La Londra vittoriana è spettacolare", "La Londra vittoriana è ricreata magnificamente. La storia di Jacob ed Evie è divertente, anche se alcune missioni possono sembrare un po' ripetitive.", 4.6, 196, 4),
("Un buon capitolo, ma non eccezionale", "Syndicate è un buon capitolo della saga, ma non riesce a competere con altri giochi come Black Flag o Origins. La trama è buona, ma non così avvincente.", 4.1, 196, 5),
("Migliorato rispetto ai precedenti", "Assassin's Creed Syndicate è un miglioramento rispetto ai capitoli precedenti in termini di gameplay. Le meccaniche di combattimento e le missioni secondarie sono molto più interessanti.", 4.7, 196, 6),
("Ottimo per chi ama la storia", "Syndicate offre un'esperienza unica per chi ama la storia. Londra è vivace e le missioni sono variate, ma la trama principale poteva essere più coinvolgente.", 4.5, 196, 7),
("Troppo simile ad altri titoli", "Syndicate è troppo simile a Unity e ad altri giochi della saga, senza grandi innovazioni. Sebbene il gameplay sia divertente, la storia non riesce a catturare come altri titoli.", 3.9, 196, 8),
("Un buon mix di azione e stealth", "Il gioco riesce a bilanciare bene azione e stealth, ma la trama e i personaggi non sono così memorabili. La città di Londra è comunque il punto forte del gioco.", 4.4, 196, 9),
("Divertente ma ripetitivo", "Syndicate è sicuramente divertente, ma a volte le missioni e le attività secondarie possono diventare ripetitive. Londra è bellissima e la meccanica dei carri è un bel tocco.", 4.2, 196, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro grafico", "Assassin's Creed Unity è incredibile dal punto di vista grafico. Parigi è ricreata magnificamente e l'attenzione ai dettagli è fuori dal comune. La trama non è la migliore, ma il gameplay è solido.", 4.8, 195, 1),
("Multiplayer interessante", "Il multiplayer in Unity è un'aggiunta interessante, ma la storia principale non riesce a decollare come nei capitoli precedenti. Nonostante ciò, è comunque un buon gioco.", 4.2, 195, 2),
("Un salto di qualità per la serie", "Unity segna un salto di qualità nella serie con un'ambientazione straordinaria e un'ottima riproduzione di Parigi. La trama è buona, ma il gioco soffre di qualche problema tecnico.", 4.6, 195, 3),
("Troppi bug", "Il gioco è fantastico, ma ha troppi bug che rovinano l'esperienza. Parigi è bellissima, ma a volte il gioco non è così fluido come dovrebbe essere.", 3.9, 195, 4),
("Un'esperienza unica", "Giocare a Unity è un'esperienza unica grazie alla ricreazione di Parigi e alla possibilità di esplorare ogni angolo della città. La trama è solida e il gameplay è migliorato rispetto ai precedenti capitoli.", 4.7, 195, 5),
("Non perfetto, ma divertente", "Nonostante qualche difetto, come bug e problemi di ottimizzazione, Unity è comunque un gioco divertente. Le meccaniche di gioco sono state migliorate e Parigi è davvero affascinante.", 4.1, 195, 6),
("Ottimo ma con qualche difetto", "Unity è un ottimo gioco, ma a volte può risultare troppo ripetitivo e i problemi di performance sono fastidiosi. Tuttavia, la città e la trama compensano questi difetti.", 4.3, 195, 7),
("La Parigi rivoluzionaria è viva", "La Parigi della Rivoluzione Francese è straordinariamente viva e dettagliata. Le meccaniche di gioco sono ottime, ma la trama principale poteva essere un po' più coinvolgente.", 4.6, 195, 8),
("Una città incredibile, ma...", "La città di Parigi è davvero un capolavoro, ma il gioco soffre di alcuni difetti tecnici che influenzano l'esperienza complessiva. Nonostante ciò, è ancora un ottimo capitolo della saga.", 4.0, 195, 9),
("Un'esperienza da non perdere", "Assassin's Creed Unity è un'esperienza da non perdere per i fan della saga. Parigi è stupenda e il gioco è davvero divertente, anche se ci sono alcuni problemi di ottimizzazione.", 4.4, 195, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un viaggio vichingo epico", "Assassin's Creed Valhalla è un gioco straordinario. Le meccaniche di combattimento sono coinvolgenti e la ricreazione dell'Inghilterra e della Norvegia è fenomenale. La storia è solida, ma un po' lunga.", 4.8, 5, 1),
("Vichinghi e battaglie spettacolari", "Il tema vichingo è fantastico, con battaglie epiche e un mondo vasto da esplorare. Alcuni elementi di gioco sono ripetitivi, ma nel complesso è un'esperienza molto divertente.", 4.6, 5, 2),
("Ottimo ma un po' ripetitivo", "Valhalla offre un mondo ricco e combattimenti spettacolari, ma le missioni possono diventare ripetitive. Nonostante ciò, il gioco è ancora uno dei migliori della serie.", 4.3, 5, 3),
("Una grande avventura", "L'avventura vichinga è ben realizzata e la possibilità di esplorare liberamente il mondo è fantastica. Alcune meccaniche di gioco potrebbero essere migliorate, ma il tutto è comunque molto godibile.", 4.7, 5, 4),
("Un'esperienza immersiva", "Valhalla offre un'esperienza immersiva nel mondo dei vichinghi. Le battaglie sono emozionanti, ma alcune sezioni di gioco sono un po' troppo lente e le missioni secondarie si ripetono spesso.", 4.4, 5, 5),
("Gameplay migliorato, ma... ", "Il gameplay è migliorato rispetto ai precedenti capitoli, con un bel mix di stealth e combattimento. Tuttavia, la trama è abbastanza prevedibile e alcune meccaniche sono un po' troppo simili a Origins e Odyssey.", 4.2, 5, 6),
("Un mondo bellissimo, ma non perfetto", "Il mondo di Valhalla è bellissimo e ricco di contenuti, ma la storia potrebbe essere più forte. Alcune missioni secondarie sono divertenti, ma molte sembrano troppo ripetitive.", 4.1, 5, 7),
("Un ottimo capitolo per i fan", "Valhalla è un ottimo capitolo della saga per chi ama i giochi open world e la mitologia vichinga. La trama è interessante, ma il gioco è troppo lungo e alcune meccaniche sono da rivedere.", 4.5, 5, 8),
("Bello ma lungo", "Il gioco è fantastico, con una mappa gigantesca e un mondo ricco da esplorare. Tuttavia, alcune missioni principali e secondarie sono troppo lunghe e cominciano a diventare ripetitive.", 4.0, 5, 9),
("Assassin's Creed al suo meglio", "Assassin's Creed Valhalla è uno dei migliori giochi della saga, con un mondo vasto, battaglie entusiasmanti e un'ottima storia. Alcuni problemi tecnici non rovinano l'esperienza complessiva.", 4.6, 5, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Il miglior simulatore di guida", "Assetto Corsa è senza dubbio uno dei migliori simulatori di guida disponibili. Le sensazioni di guida sono incredibili e la varietà di auto e piste è eccezionale. Un must per ogni appassionato di simulazioni!", 4.9, 94, 1),
("Esperienza di guida realistica", "Il gioco offre un'esperienza di guida molto realistica. Con il giusto hardware, la sensazione di essere al volante è incredibile. Tuttavia, la curva di apprendimento può essere un po' ripida per i nuovi giocatori.", 4.7, 94, 2),
("Un gioco per veri appassionati", "Assetto Corsa è un gioco per veri appassionati di simulazione automobilistica. La fisica e la cura dei dettagli sono eccezionali, ma il gioco potrebbe risultare un po' tecnico per chi non è abituato ai simulatori.", 4.6, 94, 3),
("Grafica buona, ma non eccellente", "La grafica non è perfetta, ma la simulazione di guida è davvero sorprendente. Il gioco offre una vasta gamma di auto e tracciati, ma potrebbe essere ottimizzato meglio per macchine meno potenti.", 4.2, 94, 4),
("Un passo avanti nella simulazione", "Assetto Corsa fa un grande passo avanti nel mondo dei simulatori di guida. Le dinamiche di guida sono profonde, ma la curva di difficoltà può sembrare un po' troppo ripida per i principianti.", 4.8, 94, 5),
("Esperienza immersione totale", "L'esperienza di guida in Assetto Corsa è incredibilmente immersiva. Ogni auto ha un comportamento unico che richiede attenzione e abilità, ma il gioco può essere un po' difficile da approcciare senza esperienza nei simulatori.", 4.6, 94, 6),
("Ottimo per gli amanti delle corse", "Assetto Corsa è fantastico per chi ama la simulazione pura. Le opzioni di personalizzazione delle auto e delle impostazioni di gioco sono eccezionali, ma il gioco non è così adatto a chi cerca un'esperienza arcade.", 4.5, 94, 7),
("Perfetto per simulazioni realistiche", "Se stai cercando una simulazione di guida realistica, Assetto Corsa è il gioco che fa per te. Le sensazioni di guida e la gestione dei veicoli sono incredibili, ma non aspettarti un'esperienza da gioco di corse arcade.", 4.7, 94, 8),
("Ottimo, ma richiede impegno", "Assetto Corsa è un gioco fantastico, ma richiede molto impegno e tempo per essere padroneggiato. Le meccaniche di guida sono complesse, ma soddisfacenti per chi è disposto a dedicare tempo e fatica.", 4.3, 94, 9),
("Un must per gli appassionati di simulatori", "Assetto Corsa è una delle migliori simulazioni di guida. Le auto e i tracciati sono riprodotti fedelmente, ma il gioco richiede un hardware potente per godere pienamente dell'esperienza.", 4.6, 94, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un puzzle game unico", "Baba Is You è un puzzle game davvero unico. Le meccaniche di gioco sono semplici, ma le soluzioni ai puzzle sono molto creative e stimolanti. Ogni livello è una sfida interessante!", 4.9, 159, 1),
("Innovativo e stimolante", "La possibilità di modificare le regole del gioco è una delle cose più innovative che ho visto in un puzzle game. Baba Is You è una vera sfida per la mente e molto divertente.", 4.8, 159, 2),
("Puzzle originali e coinvolgenti", "Il gioco è pieno di puzzle originali che ti fanno pensare fuori dagli schemi. È divertente e stimolante, ma può diventare frustrante in alcune sezioni più difficili.", 4.7, 159, 3),
("Semplice ma difficile", "Baba Is You è un gioco che inizia in modo semplice ma si complica velocemente. Le meccaniche di gioco ti costringono a pensare in modi nuovi, il che rende ogni livello un vero rompicapo.", 4.6, 159, 4),
("Un'esperienza unica", "L'idea di poter cambiare le regole del gioco in tempo reale è geniale. Baba Is You offre un'esperienza unica e stimolante, anche se alcune soluzioni ai puzzle possono sembrare troppo complesse.", 4.7, 159, 5),
("Un gioco di logica brillante", "Le regole del gioco cambiano letteralmente mentre giochi, portandoti a scoprire nuovi modi per risolvere i puzzle. Baba Is You è un gioco brillante per chi ama le sfide logiche.", 4.8, 159, 6),
("A volte frustrante, ma divertente", "Il gioco è molto divertente, ma a volte le soluzioni ai puzzle sono così difficili che diventano frustranti. Non è per chi cerca un gioco facile, ma è perfetto per gli amanti delle sfide mentali.", 4.4, 159, 7),
("Puzzle game innovativo", "Baba Is You è un puzzle game che ti farà pensare in modo diverso. Le sue meccaniche sono fresche e originali, ma può essere difficile avanzare senza rimanere bloccati per un po'.", 4.5, 159, 8),
("Ottimo per chi ama i puzzle", "Baba Is You è un gioco perfetto per chi ama i puzzle e le sfide mentali. La sua idea di manipolare le regole del gioco è davvero interessante e rende ogni livello divertente da risolvere.", 4.6, 159, 9),
("Fantastico ma impegnativo", "Il gioco è fantastico, ma non è facile. Le meccaniche di gioco richiedono molta attenzione e pensiero logico per risolvere i puzzle. Un gioco che premia la pazienza e la creatività.", 4.3, 159, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un classico senza tempo", "Baldur's Gate 2 è un capolavoro del genere RPG. La trama è incredibile, i personaggi sono ben sviluppati e le scelte morali ti fanno riflettere. Un must per gli appassionati di giochi di ruolo.", 5.0, 167, 1),
("Storia avvincente e personaggi memorabili", "La storia di Baldur's Gate 2 è tra le migliori che abbia mai vissuto in un gioco. I personaggi sono profondi, le missioni sono avvincenti e l'ambientazione è fantastica. Un gioco che non delude mai.", 4.9, 167, 2),
("Un RPG leggendario", "Baldur's Gate 2 è un RPG che ha fatto la storia del genere. La libertà di scelta, la complessità della trama e la profondità dei personaggi lo rendono un'esperienza straordinaria, seppur un po' datata graficamente.", 4.8, 167, 3),
("Un gioco che non invecchia mai", "Nonostante gli anni, Baldur's Gate 2 rimane uno dei migliori giochi di ruolo di tutti i tempi. La trama e il gameplay sono ancora attuali, e la possibilità di personalizzare il tuo personaggio rende ogni partita unica.", 4.7, 167, 4),
("Il miglior RPG isometrico", "Baldur's Gate 2 è il miglior esempio di RPG isometrico. La trama è ben scritta, il sistema di combattimento è strategico e il mondo di gioco è ricco di dettagli. Un gioco che ogni appassionato dovrebbe provare.", 4.9, 167, 5),
("Profondità e complessità", "Baldur's Gate 2 offre una trama profonda e una grande varietà di opzioni. Le scelte che fai nel gioco hanno impatti reali sul mondo e sulla storia. Un RPG che richiede tempo e attenzione, ma che ricompensa ampiamente.", 4.8, 167, 6),
("Un viaggio indimenticabile", "Baldur's Gate 2 è una delle esperienze più gratificanti nel mondo dei giochi di ruolo. La possibilità di esplorare il mondo e di interagire con personaggi così ben scritti è impagabile. La grafica può sembrare datata, ma la qualità del gioco è senza pari.", 4.7, 167, 7),
("L'epopea del gioco di ruolo", "Baldur's Gate 2 rappresenta l'epopea del gioco di ruolo. Ogni dettaglio è curato con precisione, dalle battaglie tattiche alla gestione dei personaggi. La narrazione è coinvolgente, ed è difficile non affezionarsi ai vari alleati e nemici.", 5.0, 167, 8),
("Un capolavoro del passato", "Anche se è un gioco un po' datato, Baldur's Gate 2 resta una delle migliori esperienze RPG. La libertà di esplorazione, il sistema di combattimento e la qualità della scrittura sono ancora oggi al top.", 4.6, 167, 9),
("Indispensabile per gli amanti dei RPG", "Baldur's Gate 2 è un must per gli amanti dei giochi di ruolo. Le missioni principali e secondarie sono ben scritte e le opzioni di personalizzazione del personaggio sono infinite. L'unica pecca è la curva di difficoltà, che può essere un po' troppo ripida per i nuovi giocatori.", 4.8, 167, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro moderno", "Baldur's Gate III è un capolavoro moderno nel genere RPG. La storia è coinvolgente, le scelte morali sono significative e le opzioni di personalizzazione sono incredibili. La grafica e la musica sono fantastiche, un gioco che ogni appassionato di RPG dovrebbe giocare.", 5.0, 55, 1),
("Un RPG da sogno", "Baldur's Gate III porta la serie a nuovi livelli. Le meccaniche di combattimento sono coinvolgenti, la trama è affascinante e ogni scelta che fai ha un impatto significativo sul mondo di gioco. È uno dei migliori RPG che abbia mai giocato.", 4.9, 55, 2),
("Impeccabile", "Baldur's Gate III è un gioco impeccabile. L'interazione con i compagni di viaggio è profonda, i combattimenti sono strategici e le possibilità di personalizzazione sono infinite. Un gioco che offre davvero tanto in ogni angolo.", 4.8, 55, 3),
("Storia avvincente, ma lunga", "La trama di Baldur's Gate III è assolutamente avvincente, ma il gioco può risultare molto lungo, soprattutto per chi vuole esplorare ogni angolo del mondo. Il sistema di combattimento è fantastico, ma alcune sezioni possono sembrare un po' ripetitive.", 4.7, 55, 4),
("Un gioco che premia la pazienza", "Baldur's Gate III è un gioco che premia chi ha pazienza. La sua grande profondità e complessità ti fanno immergere completamente nel mondo di gioco, ma la curva di apprendimento è piuttosto ripida, soprattutto per chi non è abituato ai giochi di ruolo.", 4.6, 55, 5),
("L'RPG definitivo", "Questo gioco è l'epitome del RPG. Le scelte che fai influenzano davvero la storia e le tue relazioni con gli altri personaggi, e il combattimento è estremamente soddisfacente. È il miglior RPG che abbia mai giocato.", 5.0, 55, 6),
("Un gioco incredibile", "Baldur's Gate III è un gioco incredibile che ti tiene incollato allo schermo per ore. Ogni scelta è significativa, e la profondità dei personaggi è straordinaria. La grafica e la musica sono impeccabili, ma a volte il ritmo della storia può sembrare lento.", 4.8, 55, 7),
("Un vero capolavoro", "Baldur's Gate III è un vero capolavoro. La libertà che offre al giocatore è straordinaria e le missioni secondarie sono tanto divertenti quanto quelle principali. La narrativa è eccellente e il combattimento è soddisfacente. Un gioco che merita il massimo.", 4.9, 55, 8),
("Incredibile ma impegnativo", "Baldur's Gate III è un gioco incredibile che offre un mondo vasto e ricco di dettagli, ma può risultare impegnativo per i nuovi giocatori, specialmente a causa della profondità del sistema di combattimento e delle interazioni. Non è un gioco per chi cerca una sfida leggera.", 4.7, 55, 9),
("Un RPG che non delude", "Baldur's Gate III è un RPG che non delude. La trama è coinvolgente, i personaggi sono ben scritti e il gameplay è avvincente. Tuttavia, alcune scelte possono essere difficili da comprendere, e il gioco può sembrare un po' lungo per chi cerca una storia più diretta.", 4.8, 55, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un finale epico", "Batman: Arkham Knight è un gioco che conclude magnificamente la trilogia di Arkham. La storia è intensa e il gameplay è perfetto. Il Batmobile è una grande aggiunta, anche se alcune missioni sono un po' ripetitive.", 4.8, 9, 1),
("Grafica e gameplay al top", "La grafica di Batman: Arkham Knight è semplicemente straordinaria. Il combattimento è fluido e soddisfacente, e l'esplorazione della città di Gotham è entusiasmante. Tuttavia, il Batmobile potrebbe non piacere a tutti.", 4.7, 9, 2),
("Un gioco fantastico per i fan di Batman", "Se sei un fan di Batman, questo gioco è un must. La trama è coinvolgente, i personaggi sono ben sviluppati e il gameplay è davvero divertente. Il Batmobile aggiunge varietà, ma alcune sue sezioni sono troppo simili.", 4.9, 9, 3),
("Batman alla sua massima espressione", "Arkham Knight porta Batman alla sua massima espressione. Il sistema di combattimento è migliorato rispetto ai capitoli precedenti e il mondo di gioco è enorme. Alcune sezioni con il Batmobile sono però un po' noiose.", 4.8, 9, 4),
("Un finale perfetto per la saga", "Batman: Arkham Knight offre un finale epico e una storia avvincente che cattura l'essenza del cavaliere oscuro. Tuttavia, alcune missioni secondarie sono ripetitive e il Batmobile non convince sempre.", 4.7, 9, 5),
("Gotham in tutta la sua gloria", "Esplorare Gotham in Batman: Arkham Knight è un'esperienza unica. Le battaglie sono spettacolari e il gameplay è fluido. Anche se il Batmobile aggiunge un elemento interessante, a volte risulta troppo forzato nel gioco.", 4.6, 9, 6),
("Un gioco che ti fa sentire Batman", "Batman: Arkham Knight ti fa sentire davvero come Batman. Il combattimento è incredibile, la trama ti tiene incollato e il mondo di gioco è immenso. Solo le sequenze con il Batmobile potevano essere più variegate.", 4.9, 9, 7),
("Ottima conclusione della saga", "Arkham Knight conclude la trilogia con stile. La storia è intensa e ben scritta, il gameplay è vario e soddisfacente, ma il Batmobile è un po' troppo protagonista in alcune fasi del gioco.", 4.8, 9, 8),
("Un capolavoro action", "Se sei un amante dei giochi action, Batman: Arkham Knight è un capolavoro. La varietà di combattimento, le missioni e la storia ti terranno occupato per ore. Il Batmobile, seppur interessante, a volte rallenta il ritmo del gioco.", 4.7, 9, 9),
("Storia fantastica, gameplay coinvolgente", "La storia di Batman: Arkham Knight è fantastica, e il gameplay è ancora più coinvolgente rispetto ai titoli precedenti. Tuttavia, alcune fasi con il Batmobile sono un po' eccessive e talvolta ripetitive.", 4.6, 9, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro della guerra", "Battlefield 1 è un capolavoro nel genere degli sparatutto. La campagna è emozionante e ben scritta, e le modalità multigiocatore sono incredibili. La sensazione di guerra è palpabile e la grafica è mozzafiato.", 5.0, 187, 1),
("La guerra in modo spettacolare", "Battlefield 1 ti mette nel cuore della Prima Guerra Mondiale in modo spettacolare. Le mappe sono vastissime e i combattimenti sono intensi. La campagna è buona, ma è nel multigiocatore che il gioco dà il meglio di sé.", 4.8, 187, 2),
("Un'esperienza storica coinvolgente", "Battlefield 1 offre una visione unica della Prima Guerra Mondiale. La campagna è breve ma intensa, mentre il multiplayer è adrenalinico e coinvolgente. Non c'è nulla di meglio che combattere in trincea con i tuoi compagni.", 4.9, 187, 3),
("Grafica e gameplay eccellenti", "La grafica di Battlefield 1 è straordinaria, e il gameplay è fluido e divertente. Le modalità multigiocatore sono variate e ben bilanciate. La campagna, purtroppo, non è abbastanza lunga, ma è comunque memorabile.", 4.7, 187, 4),
("Un tuffo nel passato", "Battlefield 1 ti catapulta nella Prima Guerra Mondiale con una ricostruzione storica accurata e affascinante. Il gioco è ben realizzato, con un gameplay frenetico e immersivo. La campagna potrebbe essere più lunga, ma il multiplayer è il vero fiore all'occhiello.", 4.8, 187, 5),
("Un'esperienza intensa e coinvolgente", "Battlefield 1 è un gioco che ti fa vivere la guerra in modo realistico e coinvolgente. Le battaglie sono mozzafiato, la grafica è eccellente e il gameplay è estremamente divertente. La campagna è ben fatta, ma il multiplayer è la parte migliore del gioco.", 4.9, 187, 6),
("Un gioco incredibile", "Battlefield 1 offre un'esperienza incredibile, con combattimenti che ti mettono davvero nel mezzo dell'azione. Le mappe sono fantastiche e la varietà di modalità rende ogni partita unica. Solo la campagna potrebbe essere un po' più lunga.", 4.7, 187, 7),
("Un FPS che conquista", "Battlefield 1 è uno degli FPS migliori in circolazione. La sensazione di combattere nella Prima Guerra Mondiale è unica, le mappe sono enormi e il gameplay è adrenalinico. Il multiplayer è estremamente competitivo e divertente, ma la campagna è un po' troppo breve.", 4.8, 187, 8),
("Una guerra spettacolare", "In Battlefield 1, la guerra è spettacolare e la sensazione di vastità dei campi di battaglia è impressionante. La campagna è coinvolgente, ma è nel multiplayer che il gioco brilla davvero. Un'esperienza intensa che ti terrà incollato allo schermo per ore.", 4.9, 187, 9),
("Guerra e strategia", "Battlefield 1 non è solo un gioco di azione, ma anche di strategia. Ogni battaglia richiede lavoro di squadra e tattiche ben pianificate. La grafica è incredibile e il gameplay è perfetto. Un po' più di varietà nella campagna sarebbe stato bello.", 4.6, 187, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un passo indietro", "Battlefield 2042 purtroppo non riesce a mantenere gli standard elevati dei suoi predecessori. Il gameplay è interessante, ma ci sono troppi problemi con la stabilità e i bug. La mancanza di una campagna singola è un grosso passo indietro.", 3.5, 188, 1),
("Grande potenziale, ma incompleto", "Battlefield 2042 ha un grande potenziale, ma al momento sembra incompleto. Le mappe sono enormi e piene di azione, ma ci sono troppi problemi tecnici che rendono il gioco frustrante. Aspettiamo una patch importante.", 3.8, 188, 2),
("Frenetico ma caotico", "Il gameplay di Battlefield 2042 è frenetico e adrenalinico, ma la mancanza di bilanciamento e i problemi di server rovinano l'esperienza. Le mappe sono grandiose, ma la mancanza di modalità classiche e di una trama rende il gioco meno coinvolgente.", 3.7, 188, 3),
("Prometteva di più", "Battlefield 2042 ha suscitato molte aspettative, ma purtroppo non riesce a soddisfarle del tutto. Le mappe sono spettacolari, ma i problemi con i bug e l'assenza di una campagna rendono il gioco meno interessante rispetto ai precedenti capitoli della serie.", 3.6, 188, 4),
("Incertezze tecniche", "Il gioco ha alcuni difetti evidenti, tra cui problemi di connessione e bug che rovinano l'esperienza. Le modalità di gioco sono divertenti, ma la mancanza di una modalità single-player e il caos nelle battaglie online lo rendono un po' frustrante.", 3.9, 188, 5),
("Un Battlefield diverso", "Battlefield 2042 è un gioco che si distacca molto dalla tradizione della serie. Le mappe sono gigantesche e le battaglie sono spettacolari, ma i bug e le difficoltà tecniche lo rendono difficile da apprezzare appieno. Il gioco ha ancora bisogno di molto lavoro.", 3.8, 188, 6),
("Un passo falso", "Battlefield 2042 non riesce a cogliere lo spirito dei precedenti capitoli. Le battaglie sono epiche, ma il gioco ha troppi difetti tecnici, come lag e crash. Le nuove meccaniche sono interessanti, ma non abbastanza per salvare il gioco da essere una delusione.", 3.5, 188, 7),
("Gioco promettente, ma da migliorare", "Battlefield 2042 è un gioco con un enorme potenziale, ma al momento non riesce a soddisfare le aspettative. La grafica è impressionante e le mappe sono ben progettate, ma i problemi di stabilità e il gameplay caotico lo rendono frustrante da giocare.", 3.7, 188, 8),
("Troppo caos", "Il gioco ha un bel potenziale ma è pieno di caos. La mappa è enorme, ma è difficile trovare un buon equilibrio nelle battaglie. A volte sembra più un allenamento a sopravvivere piuttosto che una vera battaglia strategica. Un po' troppo caotico per i miei gusti.", 3.6, 188, 9),
("Non all'altezza della serie", "Battlefield 2042 non è all'altezza della serie. Pur avendo un bel comparto grafico e un gameplay frenetico, i problemi tecnici e la mancanza di alcune modalità classiche della serie lo rendono inferiore rispetto ai giochi precedenti.", 3.8, 188, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un classico moderno", "Battlefield 3 è uno dei migliori titoli della serie. Il gameplay è incredibilmente fluido, le mappe sono ben progettate, e il sistema di veicoli aggiunge un livello di strategia che molti giochi di guerra non hanno. La campagna è buona, ma è nel multiplayer che il gioco dà il meglio di sé.", 5.0, 189, 1),
("Grafica e azione al top", "Le grafica e l'azione in Battlefield 3 sono semplicemente al top. Le battaglie sono intense, la varietà dei veicoli è fantastica, e la modalità multiplayer è estremamente divertente. La campagna potrebbe essere più lunga, ma è comunque emozionante.", 4.9, 189, 2),
("Un'esperienza di guerra realistica", "Battlefield 3 ti immerge in un'esperienza di guerra realistica con combattimenti intensi e veicoli spettacolari. Le mappe sono vaste e offrono molteplici approcci strategici. Il multiplayer è ancora uno dei migliori, anche se la campagna potrebbe essere un po' breve.", 4.8, 189, 3),
("Un gioco che fa storia", "Battlefield 3 ha fatto la storia del genere FPS. La modalità multiplayer è incredibile, e il gioco è ancora divertente oggi. La campagna è ben fatta, ma il multiplayer è ciò che rende davvero speciale questo gioco.", 4.9, 189, 4),
("Un'esperienza multiplayer senza pari", "La parte migliore di Battlefield 3 è senza dubbio il multiplayer. Le mappe enormi, i veicoli, e il gameplay tattico rendono ogni partita unica. La campagna è buona, ma il multiplayer è ciò che ti tiene incollato per ore.", 5.0, 189, 5),
("Un FPS che non delude", "Battlefield 3 è un FPS che non delude mai. Le battaglie sono intense, la grafica è spettacolare e la varietà di modalità e mappe offre tantissime ore di gioco. Anche se la campagna è corta, il multiplayer compensa ampiamente.", 4.7, 189, 6),
("Il miglior Battlefield?", "Battlefield 3 è uno dei migliori giochi della serie. La modalità multiplayer è perfetta, con battaglie epiche e veicoli da pilotare. La campagna è buona, ma è davvero il multiplayer a fare la differenza in questo gioco.", 4.9, 189, 7),
("Un titolo imperdibile", "Battlefield 3 è imperdibile per gli amanti degli sparatutto. La campagna è solida, ma è il multiplayer che davvero brilla, con la possibilità di vivere grandi battaglie in mappe enormi. La grafica è ancora oggi impressionante.", 4.8, 189, 8),
("Strategia e azione", "La combinazione di strategia e azione in Battlefield 3 è perfetta. Le mappe sono ampie e offrono molte opportunità tattiche. Il multiplayer è eccezionale, anche se la campagna avrebbe potuto essere più lunga e approfondita.", 4.7, 189, 9),
("Un FPS senza rivali", "Battlefield 3 è senza rivali nel suo genere. Il multiplayer è un'esperienza unica, con battaglie su larga scala e una varietà di veicoli e armi. La campagna è buona, ma il vero cuore del gioco è il multiplayer.", 5.0, 189, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un perfezionamento della formula", "Battlefield 4 migliora ciò che di buono c'era in Battlefield 3, con mappe più grandi, veicoli più potenti, e un gameplay ancora più dinamico. La campagna è interessante, ma è nel multiplayer che il gioco raggiunge il suo massimo.", 5.0, 190, 1),
("Più grande, più intenso", "Battlefield 4 è un gioco più grande e più intenso di Battlefield 3, con mappe spettacolari e un gameplay frenetico. Il multiplayer è estremamente competitivo, ma la campagna è un po' deludente e non aggiunge molto alla serie.", 4.8, 190, 2),
("L'evoluzione di un classico", "Battlefield 4 è l'evoluzione di un classico della serie. Le battaglie sono spettacolari, la grafica è impressionante, e le modalità multiplayer sono molto divertenti. La campagna è buona ma non eccelle rispetto ai migliori FPS.", 4.9, 190, 3),
("Un altro capolavoro", "Battlefield 4 continua la tradizione della serie con un gameplay fluido e coinvolgente. Le mappe sono vaste e offrono molteplici strategie. Il multiplayer è estremamente divertente, ma la campagna potrebbe essere migliorata.", 4.7, 190, 4),
("Incredibile ma con qualche difetto", "Battlefield 4 è incredibile, con battaglie spettacolari e una grafica da urlo. Tuttavia, alcuni bug e il bilanciamento del gameplay in alcune modalità multiplayer lasciano a desiderare. La campagna è buona, ma non raggiunge i livelli di altri giochi della serie.", 4.6, 190, 5),
("Un'esperienza di guerra unica", "Battlefield 4 offre un'esperienza di guerra unica con battaglie enormi e intense. I veicoli sono ben progettati, le mappe sono varie e la possibilità di distruggere l'ambiente è spettacolare. La campagna non è perfetta, ma il multiplayer compensa sicuramente.", 4.9, 190, 6),
("Una guerra su larga scala", "Battlefield 4 ti mette al centro di battaglie su larga scala. Le mappe sono enormi, i veicoli sono fantasticamente progettati, e la grafica è incredibile. La campagna è discreta, ma il vero cuore del gioco è nel multiplayer.", 4.8, 190, 7),
("Frenetico e spettacolare", "Battlefield 4 è frenetico e spettacolare. Il gameplay è fluido, le battaglie sono incredibilmente divertenti, e la grafica è impressionante. La campagna è buona, ma il multiplayer è dove il gioco dà il meglio di sé.", 4.9, 190, 8),
("Una sequenza di battaglie epiche", "Battlefield 4 è una sequenza di battaglie epiche che ti catturano e non ti lasciano andare. La varietà di veicoli e la possibilità di distruggere l'ambiente rendono ogni partita unica. La campagna è buona, ma il multiplayer è il vero protagonista.", 4.7, 190, 9),
("Il miglior multiplayer della serie", "Battlefield 4 offre il miglior multiplayer della serie, con mappe spettacolari e combattimenti ad alta intensità. I veicoli sono perfetti e la varietà di modalità è ottima. La campagna è un po' più debole, ma il multiplayer è un'esperienza senza pari.", 5.0, 190, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno alle radici", "Battlefield V offre un ritorno alle radici della serie con un gameplay solido e una grafica stupenda. Le battaglie sono intense e la personalizzazione dei soldati aggiunge un bel tocco. La campagna è interessante, ma il multiplayer è ciò che rende il gioco davvero speciale.", 4.8, 191, 1),
("Belle battaglie, ma un po' ripetitivo", "Battlefield V ha delle battaglie spettacolari e un gameplay divertente, ma alcune modalità e mappe diventano un po' ripetitive dopo un po'. La campagna è interessante, ma il multiplayer è dove il gioco brilla di più.", 4.6, 191, 2),
("Molto bello ma con alcune pecche", "La grafica in Battlefield V è incredibile, e il gameplay è frenetico e coinvolgente. Tuttavia, alcune meccaniche non sono ben bilanciate, e ci sono bug che rovinano l'esperienza. La campagna è buona, ma non è al livello dei migliori capitoli della serie.", 4.7, 191, 3),
("La seconda guerra mondiale in grande stile", "Battlefield V ti fa vivere la seconda guerra mondiale in grande stile, con battaglie epiche e una grafica da urlo. Il gameplay è divertente e la modalità di costruzione del campo di battaglia è un'aggiunta interessante. La campagna è breve ma apprezzabile.", 4.9, 191, 4),
("Difficoltà tecniche, ma ottimo gameplay", "Il gameplay di Battlefield V è fantastico, con azione frenetica e battaglie su larga scala. Tuttavia, i problemi tecnici come i bug e la gestione dei server rovinano l'esperienza. La campagna è solida, ma è il multiplayer che ti fa tornare per altre partite.", 4.6, 191, 5),
("Ottimo ma non perfetto", "Battlefield V è un ottimo gioco, ma ci sono alcuni difetti da sistemare. La grafica e il gameplay sono eccellenti, ma ci sono alcune modalità che sembrano incomplete o mal bilanciate. La campagna è buona ma non così epica come quella di altri giochi della serie.", 4.7, 191, 6),
("Strategia e azione", "Battlefield V mescola strategia e azione in modo perfetto. Le mappe sono enormi e piene di dettagli, e i veicoli aggiungono un bel livello di varietà. La campagna è interessante, ma il multiplayer è dove il gioco brilla di più.", 4.8, 191, 7),
("Divertente ma con qualche difetto", "Battlefield V è divertente, ma non riesce a mantenere lo stesso livello di eccellenza dei suoi predecessori. Le battaglie sono spettacolari e la grafica è impressionante, ma il bilanciamento del gameplay e i bug occasionali possono diventare frustranti.", 4.5, 191, 8),
("Frenetico e strategico", "Le battaglie in Battlefield V sono incredibilmente frenetiche e strategiche. I veicoli e la possibilità di costruire difese cambiano l'approccio a ogni partita. La campagna è buona, ma è nel multiplayer che il gioco trova il suo vero cuore.", 4.8, 191, 9),
("La guerra mondiale rivisitata", "Battlefield V rivisita la seconda guerra mondiale con un approccio fresco e innovativo. Le battaglie sono emozionanti, e le modalità di gioco sono varie e ben realizzate. La campagna è interessante, ma il multiplayer è ciò che rende il gioco davvero coinvolgente.", 4.7, 191, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro narrativo", "BioShock Infinite è un capolavoro. La storia è incredibile e ti tiene incollato fino all'ultimo minuto. La città di Columbia è magnificamente progettata, e i personaggi sono profondi. La gameplay è coinvolgente, ma è la trama che rende questo gioco indimenticabile.", 5.0, 168, 1),
("Una storia indimenticabile", "La trama di BioShock Infinite è una delle più belle che abbia mai visto in un videogioco. La città di Columbia è incredibilmente dettagliata, e la combinazione di azione e riflessioni filosofiche è perfetta. L'unico difetto è che a volte il gameplay diventa ripetitivo.", 4.9, 168, 2),
("Un'esperienza unica", "BioShock Infinite è un'esperienza unica nel suo genere. La storia è incredibile, e il mondo di Columbia è un posto affascinante da esplorare. Le meccaniche di gioco sono divertenti, ma è la trama che ti fa tornare a giocarlo più volte.", 5.0, 168, 3),
("Un mix perfetto di storia e gameplay", "BioShock Infinite riesce a mescolare alla perfezione un gameplay solido con una narrazione mozzafiato. La storia ti lascia senza parole, e il mondo di Columbia è uno dei più affascinanti mai visti. Un must per tutti gli amanti dei videogiochi.", 4.9, 168, 4),
("La bellezza della città di Columbia", "La cosa che mi ha colpito di più di BioShock Infinite è la bellezza e il dettaglio della città di Columbia. Ogni angolo sembra vivo e interessante. La trama è forte, e i personaggi sono incredibilmente ben scritti. Un'esperienza che non dimenticherò.", 5.0, 168, 5),
("Una trama complessa e affascinante", "La trama di BioShock Infinite è complessa e affascinante. Ogni pezzo del puzzle si incastra alla perfezione, e la città di Columbia è uno dei luoghi più memorabili in cui mi sia mai trovato a giocare. La parte di gameplay è solida, ma è la storia che fa davvero la differenza.", 4.8, 168, 6),
("Incredibile sotto ogni aspetto", "BioShock Infinite è incredibile sotto ogni aspetto: la grafica, la storia, e i personaggi. La città di Columbia è affascinante e piena di dettagli. La trama ti sorprende costantemente, e ogni decisione che prendi ha un peso. Un'esperienza da non perdere.", 5.0, 168, 7),
("Storia e design senza pari", "La storia di BioShock Infinite è senza pari. La narrativa è forte e coinvolgente, e la città di Columbia è uno dei luoghi più memorabili in un videogioco. Il gameplay è interessante, ma il vero punto di forza di questo gioco è la sua trama unica.", 4.9, 168, 8),
("Un'esperienza emozionante", "BioShock Infinite è un'esperienza emozionante. La città di Columbia è un mondo affascinante da esplorare, e la trama ti fa riflettere su temi profondi. Anche se il gameplay può sembrare un po' semplice, la storia è talmente potente che compensa ogni piccolo difetto.", 4.8, 168, 9),
("Non solo un gioco, ma un'opera d'arte", "BioShock Infinite non è solo un gioco, è un'opera d'arte. La trama è incredibile, la città di Columbia è mozzafiato, e i personaggi sono ben scritti e memorabili. La combinazione di elementi di gioco e storia è perfetta, e ogni aspetto del gioco è curato nei minimi dettagli.", 5.0, 168, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un MMORPG visivamente impressionante", "Black Desert Online è uno dei MMORPG più visivamente impressionanti che abbia mai giocato. Il mondo è vasto e pieno di dettagli, e la personalizzazione del personaggio è incredibile. Tuttavia, la curva di apprendimento è ripida e può risultare frustrante all'inizio.", 4.8, 125, 1),
("Un mondo ricco di opportunità", "Il mondo di Black Desert Online è enorme e ricco di opportunità. Le meccaniche di combattimento sono fluide e coinvolgenti, e la grafica è stupefacente. Il sistema di grind può essere un po' ripetitivo, ma il gioco è estremamente gratificante per chi ama l'esplorazione.", 4.7, 125, 2),
("Un gioco che ti cattura", "Black Desert Online è un gioco che ti cattura subito con la sua grafica mozzafiato e la sua profondità. La personalizzazione del personaggio è uno dei suoi punti di forza, ma il sistema di progressione può essere lento e richiede molta pazienza.", 4.6, 125, 3),
("Un'esperienza immersiva", "Black Desert Online offre un'esperienza immersiva, con una grafica di altissimo livello e un gameplay avvincente. Il combat system è divertente e fluido, ma il gioco può sembrare troppo grindoso dopo un po'. Tuttavia, è difficile trovare un altro MMORPG che offra un mondo così ricco di contenuti.", 4.8, 125, 4),
("Un MMORPG completo", "Black Desert Online è un MMORPG completo che offre una vasta gamma di attività: combattimento, commercio, artigianato, e tanto altro. La personalizzazione del personaggio è incredibile, ma il sistema di progressione richiede molto tempo e dedizione. La grafica è assolutamente mozzafiato.", 4.9, 125, 5),
("Combat system esaltante", "Il combat system di Black Desert Online è uno dei migliori che abbia mai visto in un MMORPG. È fluido e dinamico, e ti fa sentire davvero potente mentre combatti. La grafica è stupefacente, ma il gioco può diventare grindoso e ripetitivo a lungo andare.", 4.7, 125, 6),
("Un gioco per appassionati", "Black Desert Online è un gioco per appassionati di MMORPG che cercano profondità e personalizzazione. Il mondo di gioco è bellissimo e pieno di contenuti, ma la curva di apprendimento è ripida. Il sistema di combattimento è eccellente, ma può essere difficile orientarsi all'inizio.", 4.6, 125, 7),
("Bellissimo ma impegnativo", "Black Desert Online è un gioco bellissimo, ma è anche molto impegnativo. Il sistema di progressione può sembrare lento, e la grande quantità di contenuti può risultare travolgente. Tuttavia, se sei un fan degli MMORPG, ti offrirà ore di divertimento.", 4.7, 125, 8),
("Un MMORPG con un cuore profondo", "Black Desert Online non è solo un gioco, è un mondo. La profondità dei contenuti e la possibilità di personalizzare ogni aspetto del personaggio rendono il gioco speciale. La grafica è superba, ma il ritmo di gioco può risultare troppo lento per alcuni.", 4.8, 125, 9),
("Un'avventura epica", "Black Desert Online è un'avventura epica con una grafica da fare invidia a qualsiasi altro gioco. Il combat system è fluido e il mondo è vasto e ricco di attività. Tuttavia, il sistema di grind può essere pesante per chi non ha molto tempo da dedicare al gioco.", 4.7, 125, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco divertente e irriverente", "Bully è un gioco che ti mette nei panni di uno scolaro ribelle in una scuola privata. La storia è simpatica e divertente, con un buon mix di missioni di azione e interazioni sociali. La libertà di esplorazione e le missioni secondarie aggiungono molto valore, anche se a volte il gameplay può sembrare ripetitivo.", 4.7, 174, 1),
("Simulazione scolastica unica", "Bully è una simulazione scolastica unica nel suo genere. Ti permette di esplorare una scuola, fare amicizia o litigare con i compagni, e affrontare le varie difficoltà tipiche della vita scolastica. Le missioni sono varie e divertenti, ma alcune possono sembrare un po' troppo simili.", 4.8, 174, 2),
("Una scuola da vivere", "Bully è un gioco che ti fa sentire come se stessi vivendo davvero la vita di uno scolaro problematico. Le meccaniche di gioco sono divertenti e l'umorismo è un altro dei punti di forza. Peccato che a volte il gioco diventi ripetitivo con le stesse dinamiche.", 4.6, 174, 3),
("Divertimento scolastico", "Bully offre un mix perfetto tra azione e narrazione, e l'ambientazione scolastica rende tutto ancora più divertente. Le missioni sono molto varie, ma la grafica è un po' datata. Tuttavia, il gioco è ancora molto divertente e ricco di contenuti.", 4.7, 174, 4),
("Un po' ripetitivo, ma sempre divertente", "Bully è un gioco che offre molta libertà e opzioni per interagire con gli altri studenti. La trama è solida, ma alcune missioni si ripetono un po' troppo. Nonostante ciò, è un gioco che continua a divertire grazie alla sua unicità e umorismo.", 4.5, 174, 5),
("Vita scolastica al massimo", "Bully ti permette di vivere una vita scolastica esagerata e piena di azione. La libertà di fare quello che vuoi, dalle lotte con i bulli alle missioni bizzarre, rende il gioco molto divertente. La storia è anche molto interessante, anche se a volte il gameplay può risultare ripetitivo.", 4.8, 174, 6),
("Gioco originale e ironico", "Bully è un gioco che colpisce per la sua originalità. L'ambientazione scolastica è esplorata in modo divertente e ironico. La storia è coinvolgente, ma a volte il gioco si fa un po' ripetitivo. Nonostante questo, è comunque un'esperienza unica nel suo genere.", 4.7, 174, 7),
("Scolari ribelli e missioni esilaranti", "Bully è un gioco che ti fa divertire con le sue missioni esilaranti e le sue dinamiche scolastiche. La libertà di azione e la possibilità di personalizzare il personaggio sono ottime, ma il gioco può diventare un po' ripetitivo dopo un po'.", 4.6, 174, 8),
("Un'esperienza unica", "Bully offre un'esperienza unica in un mondo scolastico. Le missioni sono creative e divertenti, e il protagonista è un personaggio che riesce a conquistare facilmente il cuore del giocatore. La grafica non è al passo con i tempi, ma l'esperienza resta comunque fantastica.", 4.8, 174, 9),
("Un gioco che ti fa tornare a scuola", "Bully ti fa vivere la scuola in modo esagerato e divertente. Il mix di missioni e interazioni con i compagni di scuola è veramente interessante, e la possibilità di esplorare liberamente l'ambiente scolastico aggiunge molta profondità al gioco. Alcune missioni si ripetono, ma nel complesso è un'esperienza da non perdere.", 4.7, 174, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un salto nel futuro della guerra", "Call of Duty: Advanced Warfare porta la serie nel futuro con nuove meccaniche e una grafica impressionante. Il gameplay è molto fluido e la possibilità di personalizzare le armi e i poteri è un'aggiunta molto interessante. La trama è avvincente, anche se alcuni momenti sembrano un po' forzati.", 4.8, 219, 1),
("Futuro e tecnologia", "Il salto nel futuro di Call of Duty è ben riuscito. Le nuove tecnologie e l'uso degli esoscheletri danno al gioco un senso di freschezza. La grafica è ottima e il multiplayer è coinvolgente, ma la trama a volte può sembrare un po' prevedibile.", 4.7, 219, 2),
("Un'esperienza futuristica", "Advanced Warfare riesce a portare Call of Duty nel futuro in modo interessante. Le meccaniche di movimento e combattimento sono innovative e rendono il gioco molto dinamico. Tuttavia, la trama non è così forte come altri capitoli della serie.", 4.6, 219, 3),
("Grafica e gameplay all'avanguardia", "La grafica di Call of Duty: Advanced Warfare è una delle migliori della serie. Gli esoscheletri e il movimento rapido rendono il gameplay molto interessante e strategico. Il single-player è coinvolgente, ma il multiplayer potrebbe essere più bilanciato.", 4.7, 219, 4),
("Buon salto nella saga", "Call of Duty: Advanced Warfare porta nuove idee e tecnologie, come il doppio salto e il movimento rapido, che danno una sensazione di freschezza. La campagna è interessante, ma il multiplayer, sebbene divertente, non è così innovativo come la parte single-player.", 4.6, 219, 5),
("Un tocco di futurismo", "Advanced Warfare è un buon capitolo della serie, con un'impronta più futuristica rispetto ai suoi predecessori. Gli esoscheletri e la mobilità aggiungono nuove dimensioni al gameplay, ma la trama non è tanto memorabile quanto quella di altri episodi.", 4.5, 219, 6),
("Divertente ma non perfetto", "Advanced Warfare offre un gameplay fluido e dinamico con la sua mobilità migliorata grazie agli esoscheletri. La grafica è spettacolare, ma la storia non aggiunge nulla di particolarmente nuovo alla serie. Il multiplayer è divertente ma può diventare un po' ripetitivo.", 4.6, 219, 7),
("Un buon passo avanti", "Call of Duty: Advanced Warfare è un buon passo avanti nella serie, con un sistema di movimento che cambia il modo in cui affrontiamo le battaglie. La campagna è divertente ma breve, e il multiplayer ha un buon livello di coinvolgimento, seppur con pochi cambiamenti rispetto ai precedenti giochi.", 4.7, 219, 8),
("Ottima innovazione", "Il sistema degli esoscheletri e il movimento veloce rendono Advanced Warfare un gioco unico nella saga. Le missioni della campagna sono interessanti, ma a volte si perdono in momenti di azione poco memorabili. Il multiplayer è ben fatto, ma non rivoluzionario.", 4.8, 219, 9),
("Futuristico ma un po' prevedibile", "Call of Duty: Advanced Warfare riesce a portare qualcosa di nuovo con le sue innovazioni tecnologiche, ma alla fine la trama della campagna non è all'altezza delle aspettative. Il multiplayer è divertente, ma non così innovativo come il gioco singolo.", 4.6, 219, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un classico intramontabile", "Call of Duty: Black Ops è un classico che non delude mai. La campagna è coinvolgente e la modalità multiplayer è sempre apprezzata per il suo gameplay frenetico. La trama è interessante, anche se il focus principale è sempre il combattimento, che è perfettamente equilibrato.", 4.8, 169, 1),
("Storia e azione in equilibrio", "Black Ops offre una miscela perfetta di azione intensa e una trama intrigante. La campagna è ricca di colpi di scena e momenti emozionanti, mentre il multiplayer rimane uno dei migliori della serie, con un grande numero di mappe e modalità per tenere il giocatore impegnato.", 4.7, 169, 2),
("Ottimo gameplay, trama intrigante", "Call of Duty: Black Ops ha un gameplay solido e una campagna che ti tiene incollato allo schermo. Anche se la parte multiplayer è ciò che più appassiona, la modalità storia è ben scritta e piena di azione. I dettagli storici e l'atmosfera sono magnifici.", 4.8, 169, 3),
("Un gioco che non stanca mai", "Anche dopo tanto tempo, Black Ops rimane uno dei giochi più divertenti della saga. La campagna è coinvolgente, e il multiplayer è sempre divertente, grazie a nuove modalità e mappe. La grafica e il gameplay sono ben realizzati, rendendo il gioco ancora oggi un must-have per i fan del genere.", 4.7, 169, 4),
("Un'esperienza completa", "Black Ops offre un'esperienza completa con una campagna ben scritta e un multiplayer coinvolgente. La modalità zombie è una delle migliori aggiunte, offrendo ore di divertimento extra. Nonostante la concorrenza, questo gioco rimane un punto di riferimento per la saga di Call of Duty.", 4.9, 169, 5),
("Un grande capitolo", "Black Ops è uno dei migliori capitoli della saga Call of Duty. La trama della campagna è emozionante e ricca di suspense, mentre il multiplayer è frenetico e ricco di modalità. La modalità zombie è un'aggiunta che non delude mai e offre ore di divertimento extra.", 4.8, 169, 6),
("Classico senza tempo", "Call of Duty: Black Ops è un classico senza tempo. La storia ti prende subito, e l'azione è sempre intensa. Il multiplayer offre infinite ore di gioco, ma la vera sorpresa è la modalità zombie, che rende questo titolo ancora più ricco di contenuti e varietà.", 4.8, 169, 7),
("Una delle migliori campagne", "La campagna di Black Ops è una delle migliori della saga, con un'atmosfera avvincente e una trama che ti tiene con il fiato sospeso. Il multiplayer è altrettanto divertente, con mappe e modalità che rendono ogni partita unica e coinvolgente.", 4.7, 169, 8),
("Azioni spettacolari, trama avvincente", "Black Ops unisce azione spettacolare e una trama che ti cattura. Le missioni sono emozionanti, e il multiplayer è ricco di modalità che continuano a divertire. La modalità zombie è, come sempre, una delle migliori del franchise e aggiunge ore di contenuto extra.", 4.9, 169, 9),
("Impeccabile sotto ogni aspetto", "Black Ops è impeccabile sotto ogni aspetto. La campagna è divertente e coinvolgente, con un grande equilibrio tra azione e narrazione. Il multiplayer rimane uno dei migliori della serie, e la modalità zombie è fantastica per chi cerca qualcosa di diverso dal solito.", 4.8, 169, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Evoluzione perfetta", "Call of Duty: Black Ops 2 rappresenta un'evoluzione perfetta del suo predecessore. La campagna è piena di scelte che influenzano la trama, un'innovazione interessante. Il multiplayer è sempre frenetico, ma la vera sorpresa è la modalità zombie, che offre un sacco di contenuti e varietà.", 4.9, 170, 1),
("Innovazione nella serie", "Black Ops 2 porta Call of Duty a un nuovo livello con la sua trama ramificata e scelte che influenzano gli eventi. Il gameplay è solido come sempre, ma la modalità zombie è davvero il punto forte del gioco. Le nuove armi e mappe sono fantastiche.", 4.8, 170, 2),
("La campagna interattiva", "La campagna di Black Ops 2 è interattiva come mai prima d'ora. Le scelte che fai durante il gioco cambiano il corso degli eventi, offrendo diverse esperienze di gioco. Il multiplayer è sempre un piacere, ma la modalità zombie è ciò che mi ha tenuto a giocare per ore.", 4.8, 170, 3),
("L'apice della serie", "Call of Duty: Black Ops 2 è l'apice della serie per me. Le missioni della campagna sono coinvolgenti e le scelte che compi hanno un impatto tangibile sul gioco. Il multiplayer è, come sempre, perfetto, e la modalità zombie è incredibile. Un gioco completo sotto ogni aspetto.", 5.0, 170, 4),
("Storia e gameplay di qualità", "Black Ops 2 migliora sotto ogni aspetto rispetto al primo gioco. La storia è interessante e coinvolgente, le scelte che influenzano il futuro sono un'aggiunta fantastica. La modalità multiplayer è divertente come sempre, con nuove mappe e modalità da provare.", 4.7, 170, 5),
("Un passo avanti", "Black Ops 2 fa un passo avanti nella saga con la sua trama che si ramifica e offre diverse possibilità. Il multiplayer è veloce e ricco di contenuti, ma la modalità zombie è ciò che rende questo gioco veramente speciale. Un'esperienza che non delude mai.", 4.8, 170, 6),
("Molto più di un FPS", "Call of Duty: Black Ops 2 è molto più di un semplice FPS. La campagna offre una trama interessante, con scelte che cambiano la storia, e il multiplayer è sempre veloce e competitivo. La modalità zombie è, come sempre, un'aggiunta che dà vita a infinite ore di gioco.", 4.9, 170, 7),
("Un gioco che ti fa riflettere", "Le scelte che fai in Black Ops 2 ti fanno davvero riflettere. La trama è avvincente, e il gameplay rimane uno dei migliori nella saga. Il multiplayer è intenso, ma la modalità zombie è la vera chicca di questo titolo. Un'esperienza imperdibile per i fan del genere.", 4.8, 170, 8),
("Sperimentazione e successo", "Black Ops 2 è riuscito a sperimentare con successo la struttura ramificata della campagna. Ogni scelta porta a diverse conseguenze, dando una rigiocabilità incredibile. Il multiplayer è sempre il punto forte della serie, e la modalità zombie è sempre una garanzia di divertimento.", 4.7, 170, 9),
("Innovazione che funziona", "L'innovazione di Black Ops 2 con le scelte che cambiano la storia è ben riuscita. La campagna è coinvolgente e il gameplay è sempre frenetico e divertente. Il multiplayer è ricco di nuove opzioni, e la modalità zombie continua ad essere una delle migliori in assoluto.", 4.8, 170, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un grande passo verso il futuro", "Call of Duty: Black Ops 3 porta la serie nel futuro con nuove meccaniche di movimento e un gameplay estremamente fluido. La campagna è interessante, ma il multiplayer è davvero il cuore del gioco, con modalità innovative che fanno davvero la differenza. La modalità zombie è sempre un'aggiunta fantastica.", 4.8, 171, 1),
("Movimento veloce, azione intensa", "Il sistema di movimento in Black Ops 3 è un grande miglioramento rispetto ai precedenti titoli. Saltare, correre su pareti e scivolare porta un nuovo livello di dinamismo al gameplay. Il multiplayer è adrenalinico, ma la campagna è un po' più debole rispetto agli altri titoli della serie.", 4.7, 171, 2),
("Nuove meccaniche, stessa intensità", "Con Black Ops 3, Call of Duty introduce nuove meccaniche di movimento che arricchiscono l'esperienza di gioco. La modalità zombie è sempre fenomenale, ma il multiplayer rimane la parte migliore del gioco, con nuove modalità e opzioni per i giocatori competitivi.", 4.8, 171, 3),
("L'evoluzione della saga", "Black Ops 3 è senza dubbio un'evoluzione della saga. Le nuove opzioni di movimento rendono il gameplay ancora più veloce e fluido, mentre la trama della campagna è coinvolgente. Tuttavia, la modalità zombie è quella che offre davvero il massimo in termini di contenuti e divertimento.", 4.9, 171, 4),
("Impressionante ma a volte confusionario", "Black Ops 3 offre un'esperienza incredibile dal punto di vista del gameplay. Le nuove meccaniche di movimento sono davvero interessanti, ma a volte la campagna risulta un po' confusionaria. Il multiplayer è ottimo, ma la modalità zombie continua a essere il mio punto forte.", 4.7, 171, 5),
("Sempre più futuristico", "Black Ops 3 ci porta in un futuro ancora più avanzato rispetto ai suoi predecessori, con nuove meccaniche che migliorano l'esperienza di gioco. Il multiplayer è sempre coinvolgente, ma la campagna, sebbene divertente, non riesce a rispecchiare la qualità dei precedenti capitoli.", 4.6, 171, 6),
("Un'esperienza innovativa", "Black Ops 3 porta molte novità alla serie, inclusi nuovi movimenti e la possibilità di personalizzare il proprio soldato. Il multiplayer è adrenalinico come sempre, ma la campagna potrebbe essere migliorata. La modalità zombie è l'aggiunta che rende questo gioco davvero speciale.", 4.8, 171, 7),
("Futuro e innovazione", "Call of Duty: Black Ops 3 è sicuramente una ventata di freschezza per la serie. Il movimento dinamico e veloce rende ogni partita unica, e la campagna è abbastanza interessante, seppur non al livello di altri titoli. Il multiplayer è incredibile e la modalità zombie è ancora una volta fantastica.", 4.7, 171, 8),
("La velocità è la chiave", "Black Ops 3 è il gioco più veloce della saga, grazie alle nuove meccaniche di movimento. La campagna è divertente, ma è il multiplayer che brilla davvero, con tante modalità che ti fanno giocare per ore. La modalità zombie è, come sempre, il miglior modo per divertirsi con gli amici.", 4.9, 171, 9),
("Tanta azione, ma un po' confusionario", "Il gameplay di Black Ops 3 è molto fluido, con un movimento rapido che rende ogni partita emozionante. La campagna offre un buon mix di azione, ma a volte risulta confusionaria. Il multiplayer è sempre il cuore pulsante di Call of Duty, e la modalità zombie è una garanzia di ore di divertimento.", 4.7, 171, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Il futuro del multiplayer", "Call of Duty: Black Ops 4 è un passo audace, abbandonando la campagna per concentrarsi esclusivamente sul multiplayer e sulla modalità battle royale. Il gameplay è velocissimo e frenetico, e la modalità Blackout (battle royale) è sorprendentemente divertente. Una delle migliori esperienze multiplayer degli ultimi anni.", 4.8, 172, 1),
("Multiplayer puro", "Black Ops 4 fa una scelta coraggiosa abbandonando la campagna per concentrarsi solo su multiplayer. Le nuove modalità e l'introduzione del battle royale sono perfetti per chi cerca un'esperienza intensa e adrenalinica. La mancanza di una campagna non è un grande problema per me, ma i fan della trama potrebbero restare delusi.", 4.7, 172, 2),
("Un'ottima evoluzione", "La decisione di Black Ops 4 di concentrarsi sul multiplayer è un successo. Le modalità di gioco sono tante e divertenti, e la modalità battle royale, Blackout, è una piacevole sorpresa. Il gioco è molto equilibrato e offre un'esperienza frenetica che appassiona subito.", 4.8, 172, 3),
("La mancanza della campagna si fa sentire", "Non avere una campagna in Black Ops 4 è una scelta controversa. Tuttavia, il multiplayer è ben fatto e la modalità battle royale è molto divertente. La nuova modalità Zombies è anche un'aggiunta interessante, ma non posso fare a meno di sentire la mancanza di una storia solida.", 4.6, 172, 4),
("Battle Royale al suo meglio", "La modalità Blackout di Black Ops 4 è davvero ben riuscita, offrendo un'esperienza di battle royale completa e appagante. Il multiplayer è veloce e competitivo, ma devo ammettere che mi è mancata la campagna, anche se la modalità Zombies riesce a compensare parzialmente.", 4.7, 172, 5),
("Multiplayer senza freni", "Black Ops 4 punta tutto sul multiplayer, e funziona davvero bene. Le modalità sono molteplici, e l'azione è continua e frenetica. Il battle royale è una novità interessante, ma il multiplayer tradizionale rimane il cuore del gioco. Tuttavia, la mancanza di una campagna single-player è una scelta discutibile.", 4.8, 172, 6),
("Battle Royale coinvolgente", "La modalità Blackout è una delle migliori esperienze di battle royale che abbia mai provato. Il multiplayer è solido, ma è la nuova modalità battle royale che aggiunge una ventata di freschezza al gioco. Mi manca la campagna, ma nonostante tutto è un titolo che consiglio a chi ama l'azione frenetica.", 4.7, 172, 7),
("Un'ottima esperienza multiplayer", "Non ho mai visto un gioco multiplayer così coinvolgente come Black Ops 4. La possibilità di scegliere tra tante modalità e la velocità dell'azione lo rendono davvero appassionante. La modalità Blackout aggiunge valore al pacchetto, ma avrei preferito una campagna più solida.", 4.6, 172, 8),
("Le modalità giuste, ma niente campagna", "Black Ops 4 ha tutto ciò che un appassionato di multiplayer possa desiderare: tante modalità, battaglie frenetiche e una modalità battle royale ben fatta. La grande assenza è la campagna, che personalmente mi sarebbe piaciuta. Nonostante questo, è un gioco che rimane sempre coinvolgente.", 4.7, 172, 9),
("Zombies e battle royale", "Le modalità Zombies e Blackout sono senza dubbio i punti di forza di Black Ops 4. Il multiplayer è veloce e sempre stimolante, ma mi è mancata una campagna ben strutturata. Nonostante ciò, il gioco è comunque molto divertente, specialmente se sei un fan dei battle royale.", 4.8, 172, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno trionfale alla campagna", "Call of Duty: Black Ops 6 segna un ritorno trionfale alla campagna single-player, offrendo una trama avvincente ambientata nel 1991. Le missioni sono varie e coinvolgenti, con una narrazione che tiene il giocatore incollato allo schermo. La modalità multiplayer introduce il sistema Omnimovement, che arricchisce l'esperienza di gioco con movimenti fluidi e dinamici.", 4.9, 173, 1),
("Innovazione e tradizione", "Questo titolo combina perfettamente innovazione e tradizione. La campagna è una delle migliori degli ultimi anni, con missioni che spaziano da operazioni sotto copertura a combattimenti open-world. Il multiplayer beneficia del nuovo sistema di movimento, rendendo ogni partita unica e coinvolgente. La modalità Zombies è tornata alle sue radici, offrendo sfide avvincenti per i fan di lunga data.", 4.8, 173, 2),
("Un passo avanti per la serie", "Black Ops 6 rappresenta un significativo passo avanti per la serie. La campagna è ben scritta e offre una varietà di missioni che mantengono alta l'attenzione del giocatore. Il multiplayer è frenetico e divertente, con il sistema Omnimovement che aggiunge una nuova dimensione al gameplay. La modalità Zombies è solida, con nuove mappe e sfide che terranno occupati i giocatori per ore.", 4.7, 173, 3),
("Esperienza completa", "Con una campagna avvincente, un multiplayer dinamico e una modalità Zombies che non delude, Black Ops 6 offre un'esperienza completa. Il sistema di movimento Omnimovement è un'aggiunta benvenuta, rendendo il gameplay più fluido e interessante. La varietà di missioni nella campagna mantiene il gioco fresco e stimolante.", 4.8, 173, 4),
("Un ritorno alle origini", "Black Ops 6 segna un ritorno alle origini della serie, con una campagna coinvolgente e un multiplayer che offre nuove sfide. Il sistema Omnimovement aggiunge una nuova dimensione al gameplay, rendendo ogni partita unica. La modalità Zombies è tornata alle sue radici, offrendo sfide avvincenti per i fan di lunga data.", 4.7, 173, 5),
("Un gioco che non delude", "Black Ops 6 è un gioco che non delude. La campagna è avvincente, con una trama che tiene il giocatore incollato allo schermo. Il multiplayer è frenetico e divertente, con il sistema Omnimovement che aggiunge una nuova dimensione al gameplay. La modalità Zombies è solida, con nuove mappe e sfide che terranno occupati i giocatori per ore.", 4.8, 173, 6),
("Un'esperienza coinvolgente", "Black Ops 6 offre un'esperienza coinvolgente con una campagna ben scritta e un multiplayer dinamico. Il sistema Omnimovement è un'aggiunta benvenuta, rendendo il gameplay più fluido e interessante. La modalità Zombies è solida, con nuove mappe e sfide che terranno occupati i giocatori per ore.", 4.7, 173, 7),
("Un gioco da non perdere", "Black Ops 6 è un gioco da non perdere. La campagna è avvincente, con una trama che tiene il giocatore incollato allo schermo. Il multiplayer è frenetico e divertente, con il sistema Omnimovement che aggiunge una nuova dimensione al gameplay. La modalità Zombies è solida, con nuove mappe e sfide che terranno occupati i giocatori per ore.", 4.8, 173, 8),
("Un'ottima aggiunta alla serie", "Black Ops 6 è un'ottima aggiunta alla serie. La campagna è ben scritta e offre una varietà di missioni che mantengono alta l'attenzione del giocatore. Il multiplayer è frenetico e divertente, con il sistema Omnimovement che aggiunge una nuova dimensione al gameplay. La modalità Zombies è solida, con nuove mappe e sfide che terranno occupati i giocatori per ore.", 4.7, 173, 9),
("Un gioco che offre tutto", "Black Ops 6 offre tutto ciò che un fan della serie potrebbe desiderare. La campagna è avvincente, con una trama che tiene il giocatore incollato allo schermo. Il multiplayer è frenetico e divertente, con il sistema Omnimovement che aggiunge una nuova dimensione al gameplay. La modalità Zombies è solida, con nuove mappe e sfide che terranno occupati i giocatori per ore.", 4.8, 173, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno alle radici della serie", "Call of Duty: Black Ops Cold War è un ritorno alle radici della serie con una campagna avvincente, piena di azione e colpi di scena. Il sistema di gioco è ben bilanciato, con una modalità multiplayer che offre sia novità che familiarità per i fan della saga. La modalità Zombies è coinvolgente come sempre, con nuove mappe e modalità.", 4.7, 179, 1),
("Una campagna straordinaria", "La campagna di Cold War è una delle migliori degli ultimi anni, con una trama che esplora la Guerra Fredda e offre scelte significative per i giocatori. Il multiplayer è dinamico, e la modalità Zombies è ancora una volta una delle più apprezzate della serie. Una vera gioia per i fan di Call of Duty.", 4.8, 179, 2),
("Multiplayer frenetico e avvincente", "Il multiplayer di Black Ops Cold War è frenetico e adrenalinico. Le mappe sono ben progettate e il sistema di progressione è gratificante. La modalità Zombies è divertente, ma alcune novità potrebbero essere sviluppate ulteriormente. In generale, è un gioco che non delude e offre molte ore di intrattenimento.", 4.6, 179, 3),
("Un passo avanti per la serie", "Black Ops Cold War porta la serie a nuovi livelli con una campagna coinvolgente e un multiplayer che non annoia mai. Il sistema di movimento è fluido, e le modalità diverse (come il multigiocatore e la modalità Zombies) offrono ore di gameplay. È un must per i fan di Call of Duty.", 4.7, 179, 4),
("La migliore esperienza Zombies", "La modalità Zombies di Cold War è una delle migliori in assoluto. Le mappe sono enormi e ricche di dettagli, e le sfide da superare sono sempre nuove e stimolanti. Anche il multiplayer è eccellente, con un sacco di armi da sbloccare e modalità di gioco diverse. La campagna, seppur breve, è emozionante e ben scritta.", 4.8, 179, 5),
("Un'esperienza completa", "Cold War è un'esperienza completa per ogni amante dei giochi sparatutto. La campagna è ricca di azione e si svolge in diverse località, offrendo varietà al gameplay. Il multiplayer è uno dei migliori della serie, e la modalità Zombies è adrenalinica come sempre. Un gioco che merita di essere giocato.", 4.7, 179, 6),
("Un'ottima modalità multiplayer", "Il multiplayer di Black Ops Cold War è il cuore pulsante del gioco. È veloce, competitivo e ricco di contenuti. Le mappe sono varie e ben progettate, e ogni partita è diversa dalle altre. La campagna è buona, ma è il multiplayer che rende questo gioco davvero memorabile.", 4.6, 179, 7),
("Non delude mai", "Call of Duty: Black Ops Cold War è un gioco che non delude mai. La campagna è emozionante e coinvolgente, con una trama che tiene il giocatore sempre sulla corda. Il multiplayer è avvincente, e la modalità Zombies è perfetta per i fan del cooperativo. È un gioco che offre ore e ore di divertimento.", 4.7, 179, 8),
("Un ritorno ai grandi classici", "Cold War è un ritorno ai grandi classici della serie, con una campagna che offre azione senza sosta e un multiplayer che non annoia mai. La modalità Zombies è un'aggiunta fondamentale per chi cerca qualcosa di diverso. In generale, è un gioco che non ti deluderà.", 4.8, 179, 9),
("Il miglior Call of Duty degli ultimi anni", "Black Ops Cold War è il miglior Call of Duty degli ultimi anni. La campagna è coinvolgente e ben scritta, e il multiplayer è estremamente divertente. La modalità Zombies offre nuove sfide e meccaniche che aggiungono valore al gioco. Un gioco che non può mancare nella libreria di un appassionato di Call of Duty.", 4.9, 179, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un passo indietro", "Call of Duty: Ghosts non riesce a mantenere gli stessi standard dei suoi predecessori. La campagna è interessante, ma il gameplay non è innovativo come ci si sarebbe aspettato. Il multiplayer è divertente, ma alcune mappe sono troppo larghe e disperse, rendendo i combattimenti meno intensi. La modalità Extinction è una novità, ma non aggiunge troppo alla formula di base.", 3.7, 220, 1),
("Ottimo ma non perfetto", "Ghosts ha alcune idee interessanti, ma non riesce a raggiungere l'altezza di altri titoli della serie. La campagna è abbastanza buona, ma manca di quell'emozione che caratterizza altri capitoli. Il multiplayer è solido, ma non presenta novità significative. La modalità Extinction è un'aggiunta piacevole, ma potrebbe essere migliorata.", 3.8, 220, 2),
("Buona esperienza ma non memorabile", "Call of Duty: Ghosts offre una buona esperienza complessiva, ma non riesce a lasciare il segno. La campagna è divertente, ma la storia non è all'altezza di altri giochi della saga. Il multiplayer è solido, ma non introduce molte novità. La modalità Extinction è interessante, ma non abbastanza per far emergere questo gioco rispetto ad altri.", 3.9, 220, 3),
("Frenetico ma poco innovativo", "Ghosts mantiene l'azione frenetica che ci si aspetta da un gioco di Call of Duty, ma manca di innovazione. La campagna è più lineare rispetto ad altri titoli, e il multiplayer non offre molta originalità. La modalità Extinction è un tentativo interessante, ma non riesce a competere con le modalità Zombies di altri giochi.", 3.6, 220, 4),
("Un Call of Duty solido ma non eccellente", "Ghosts è un buon gioco, ma non è il migliore della serie. La campagna è piacevole, ma non sorprende. Il multiplayer è abbastanza buono, ma non riesce a mantenere l'interesse a lungo. La modalità Extinction ha un buon potenziale, ma potrebbe essere sviluppata ulteriormente. Nel complesso, un gioco che offre un'esperienza solida ma non memorabile.", 3.7, 220, 5),
("Una buona aggiunta alla serie", "Call of Duty: Ghosts è una buona aggiunta alla serie, anche se non raggiunge i livelli dei titoli precedenti. La campagna è interessante, ma la storia non è abbastanza coinvolgente. Il multiplayer è solido, con alcune nuove opzioni interessanti, ma non ha lo stesso impatto di altri giochi della saga. La modalità Extinction offre qualcosa di nuovo, ma non riesce a superare Zombies.", 3.8, 220, 6),
("Non all'altezza dei predecessori", "Ghosts è un gioco buono, ma non all'altezza dei predecessori. La campagna è interessante, ma manca di quel tocco di epicità che caratterizza altri giochi della serie. Il multiplayer è solido, ma non offre molte novità. La modalità Extinction è un'aggiunta interessante, ma non è abbastanza per risollevare il gioco.", 3.6, 220, 7),
("Sufficiente ma non eccezionale", "Call of Duty: Ghosts è sufficiente ma non eccezionale. La campagna è buona, ma non memorabile. Il multiplayer è divertente, ma non c'è molta innovazione. La modalità Extinction è una novità interessante, ma non riesce a competere con le modalità più riuscite di altri giochi della saga.", 3.7, 220, 8),
("Un titolo piacevole, ma non rivoluzionario", "Ghosts è un titolo che piacerà ai fan della serie, ma non introduce nulla di rivoluzionario. La campagna è solida, ma la storia non è entusiasmante. Il multiplayer è divertente, ma non abbastanza per distinguersi. La modalità Extinction ha un buon potenziale, ma non riesce a competere con la forza di Zombies.", 3.8, 220, 9),
("Un buon gioco, ma manca qualcosa", "Call of Duty: Ghosts è un buon gioco, ma manca qualcosa per renderlo davvero memorabile. La campagna è divertente, ma la storia non riesce a catturare completamente l'attenzione. Il multiplayer è solido, ma non c'è nulla di veramente innovativo. La modalità Extinction offre una buona alternativa, ma non è abbastanza per fare di questo gioco un must-have.", 3.7, 220, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un salto nel futuro", "Call of Duty: Infinite Warfare porta la serie in un futuro lontano, con combattimenti nello spazio e nuove meccaniche di gioco. La campagna è divertente, anche se a volte troppo concentrata sull'azione, lasciando poco spazio alla trama. Il multiplayer è frenetico e interessante, anche se alcuni potrebbero non apprezzare il cambiamento di ambientazione. La modalità Zombies è la solita, ma offre nuove mappe e caratteristiche.", 4.1, 221, 1),
("Una ventata di novità", "Infinite Warfare cerca di portare una ventata di novità alla serie, con combattimenti nello spazio e ambientazioni futuristiche. La campagna è ben costruita e offre una buona varietà di missioni, ma a volte sembra sacrificare la trama a favore dell'azione. Il multiplayer è frenetico e interessante, ma alcuni fan più tradizionali potrebbero non apprezzare il cambio di direzione. La modalità Zombies è divertente, ma non innovativa.", 4.2, 221, 2),
("Futuristico, ma con qualche difetto", "Call of Duty: Infinite Warfare introduce una nuova ambientazione futuristica con combattimenti nello spazio e nuove meccaniche. La campagna è solida e divertente, ma alcuni momenti sembrano più un film d'azione che un videogioco. Il multiplayer è abbastanza divertente, anche se alcune modalità possono risultare ripetitive. La modalità Zombies è la solita, ma offre qualche nuova mappa interessante.", 4.0, 221, 3),
("Troppo futuristico", "Infinite Warfare prova a innovare con la sua ambientazione futuristica e la possibilità di combattere nello spazio, ma sembra perdere un po' dello spirito che ha reso Call of Duty così popolare. La campagna è buona, ma a volte troppo concentrata sull'azione. Il multiplayer è divertente, ma alcune delle nuove caratteristiche non sono così coinvolgenti come sperato. La modalità Zombies è comunque apprezzabile, ma non aggiunge molto di nuovo.", 3.8, 221, 4),
("Un'esperienza spaziale", "Call of Duty: Infinite Warfare offre un'esperienza unica nel suo genere, con combattimenti nello spazio e in ambientazioni futuristiche. La campagna è interessante, ma alcune missioni potrebbero essere più coinvolgenti. Il multiplayer è frenetico e divertente, ma alcuni fan potrebbero non apprezzare il cambiamento di ambientazione. La modalità Zombies è buona, ma non troppo innovativa.", 4.0, 221, 5),
("Un gioco che ha diviso i fan", "Infinite Warfare ha diviso i fan di Call of Duty. La campagna è interessante, ma alcuni trovano che l'ambientazione futuristica non si adatti bene al franchise. Il multiplayer è divertente, ma a volte risulta ripetitivo. La modalità Zombies è comunque solida, con nuove mappe e meccaniche. Nel complesso, è un buon gioco, ma non rivoluzionario.", 3.9, 221, 6),
("Azioni frenetiche, ma poca sostanza", "La campagna di Infinite Warfare è frenetica e ricca di azione, ma manca di profondità nella trama. Il multiplayer è interessante, ma la nuova ambientazione spaziale potrebbe non piacere a tutti. La modalità Zombies è divertente, ma non aggiunge nulla di particolarmente nuovo alla serie. Nel complesso, il gioco è divertente, ma non raggiunge l'eccellenza di altri titoli Call of Duty.", 3.8, 221, 7),
("Un cambiamento interessante", "Infinite Warfare prova a portare qualcosa di nuovo con l'ambientazione spaziale e le battaglie futuristiche, ma a volte sembra che la serie abbia perso il suo tocco. La campagna è buona, ma non così coinvolgente come quella dei titoli precedenti. Il multiplayer è frenetico, ma non aggiunge grandi novità. La modalità Zombies è una solida opzione per i fan del cooperativo, ma non è nulla di speciale.", 4.0, 221, 8),
("In una nuova dimensione", "Call of Duty: Infinite Warfare spinge la serie in una nuova dimensione, con battaglie nello spazio e in ambientazioni futuristiche. La campagna è buona, ma a volte non riesce a catturare l'emozione che ci si aspetta da un gioco di Call of Duty. Il multiplayer è interessante, anche se alcuni preferirebbero il ritorno a una guerra più \"terrestre\". La modalità Zombies è solida, ma non rivoluzionaria.", 3.9, 221, 9),
("Non per tutti i fan", "Infinite Warfare è un buon gioco, ma non è per tutti. La campagna è divertente, ma l'ambientazione futuristica potrebbe non piacere a tutti i fan della serie. Il multiplayer è solido, ma alcune meccaniche potrebbero non piacere a chi preferisce il gameplay più tradizionale. La modalità Zombies è divertente, ma non è così interessante come nelle versioni precedenti.", 3.8, 221, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un classico che resiste nel tempo", "Call of Duty: Modern Warfare 2 è un classico intramontabile. La campagna è emozionante e ricca di momenti memorabili, con una trama avvincente e missioni mozzafiato. Il multiplayer è solido, con mappe ben bilanciate e meccaniche ben rodato. La modalità Spec Ops è un'aggiunta divertente, anche se la rigiocabilità potrebbe essere maggiore. Nel complesso, un gioco che continua a brillare anche dopo tanti anni.", 4.8, 222, 1),
("Il miglior Call of Duty della saga", "Modern Warfare 2 è senza dubbio uno dei migliori Call of Duty mai realizzati. La campagna è spettacolare e il multiplayer è ancora oggi uno dei più divertenti. Le mappe sono perfette, con un ottimo bilanciamento tra tattica e azione frenetica. La modalità Spec Ops è interessante e offre nuove sfide. Se non l'hai mai giocato, è un must!", 4.9, 222, 2),
("Incredibile come sempre", "Anche dopo anni dal suo lancio, Modern Warfare 2 rimane un gioco incredibile. La campagna è epica, con momenti iconici che hanno segnato la serie. Il multiplayer è ancora una delle esperienze più divertenti del genere, con meccaniche che non sono mai diventate obsolete. La modalità Spec Ops aggiunge ancora più valore al gioco. Un vero capolavoro.", 4.8, 222, 3),
("Un must per i fan di Call of Duty", "Modern Warfare 2 è senza dubbio uno dei giochi più amati dai fan di Call of Duty. La campagna è coinvolgente e ricca di momenti spettacolari, mentre il multiplayer è perfetto per ore di divertimento. Le mappe sono ben progettate e il bilanciamento è eccellente. La modalità Spec Ops è una buona aggiunta, ma a volte manca di contenuti.", 4.7, 222, 4),
("Eccellente sotto ogni punto di vista", "Call of Duty: Modern Warfare 2 è un gioco che ha definito un'intera generazione di videogiochi. La campagna è coinvolgente e ricca di colpi di scena, con un gameplay che rimane fresco anche oggi. Il multiplayer è frenetico, ma ben equilibrato. La modalità Spec Ops offre sfide che possono essere davvero intense. Un gioco che vale la pena giocare, ancora oggi.", 4.8, 222, 5),
("Semplicemente leggendario", "Modern Warfare 2 è uno dei giochi più leggendari della saga Call of Duty. La campagna è epica, con missioni spettacolari e una trama che tiene incollati. Il multiplayer è incredibilmente divertente, con modalità che continuano a essere amate anche dopo anni. La modalità Spec Ops è una bella novità, ma non basta a migliorare un'esperienza già perfetta.", 4.9, 222, 6),
("Nonostante gli anni, resta un capolavoro", "Modern Warfare 2 è ancora uno dei migliori giochi mai realizzati. La campagna è ricca di azione e momenti intensi, mentre il multiplayer è frenetico e mai noioso. Anche se gli anni passano, il gioco riesce ancora a mantenere il suo fascino. La modalità Spec Ops è divertente, ma non è abbastanza per battere la forza del multiplayer.", 4.7, 222, 7),
("Un'esperienza senza tempo", "Call of Duty: Modern Warfare 2 è un gioco che ha saputo resistere al passare del tempo. La campagna è sempre emozionante, con una trama ben scritta e missioni avvincenti. Il multiplayer è forse il più divertente della serie, con mappe che non invecchiano mai. La modalità Spec Ops è una gradita aggiunta, anche se potrebbe offrire più sfide per i giocatori esperti.", 4.8, 222, 8),
("Un altro capolavoro di Infinity Ward", "Modern Warfare 2 è un altro capolavoro creato da Infinity Ward. La campagna è perfetta, con una storia che cattura e coinvolge, mentre il multiplayer è incredibilmente bilanciato. Le mappe sono divertenti e offrono ore di intrattenimento. La modalità Spec Ops è un po' sottovalutata, ma comunque aggiunge valore al pacchetto.", 4.9, 222, 9),
("Un gioco che non perde mai il suo fascino", "Anche dopo tanti anni, Modern Warfare 2 riesce a mantenere il suo fascino. La campagna è avvincente, con una trama che ha lasciato il segno nella storia dei videogiochi. Il multiplayer è ancora oggi uno dei più apprezzati della serie, con mappe ben fatte e bilanciate. La modalità Spec Ops è divertente, ma non riesce a superare la qualità del multiplayer.", 4.8, 222, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Una conclusione epica", "Modern Warfare 3 chiude la trilogia con un capitolo ricco di azione e momenti spettacolari. La campagna è intensa, con una trama che coinvolge fino alla fine. Il multiplayer è frenetico e divertente, con nuove armi e modalità. La modalità Spec Ops è ben realizzata, ma a volte potrebbe sembrare ripetitiva. Nel complesso, un ottimo capitolo per concludere la saga.", 4.7, 223, 1),
("Il miglior capitolo della trilogia", "Call of Duty: Modern Warfare 3 è senza dubbio il miglior capitolo della trilogia. La campagna è intensa e ricca di colpi di scena, mentre il multiplayer è sempre un successo con nuove modalità e mappe. La modalità Spec Ops è interessante e offre nuove sfide, anche se a volte può risultare ripetitiva. Un grande finale per una saga epica.", 4.8, 223, 2),
("Un finale degno della saga", "Modern Warfare 3 è un gioco che riesce a concludere la trilogia in modo eccellente. La campagna è avvincente, con momenti di alta tensione e una trama che non delude. Il multiplayer è solido come sempre, con nuove modalità che offrono una buona varietà. La modalità Spec Ops è interessante, ma alcune missioni potrebbero essere più varie. In generale, un grande gioco.", 4.6, 223, 3),
("Tanta azione, ma qualcosa manca", "Call of Duty: Modern Warfare 3 è pieno di azione, con una campagna che non lascia spazio alla noia. Il multiplayer è solido, ma non aggiunge novità rivoluzionarie rispetto ai capitoli precedenti. La modalità Spec Ops è divertente, ma un po' ripetitiva. In generale, il gioco è comunque un ottimo capitolo, anche se potrebbe fare di più in termini di innovazione.", 4.5, 223, 4),
("Un altro grande successo", "Modern Warfare 3 è un altro grande successo della serie. La campagna è emozionante e non delude le aspettative, mentre il multiplayer è sempre un piacere da giocare. La modalità Spec Ops è un buon aggiunta, anche se potrebbe risultare un po' ripetitiva. Nel complesso, un gioco che offre ore di divertimento e un finale epico per la trilogia.", 4.7, 223, 5),
("Un finale che chiude in bellezza", "Call of Duty: Modern Warfare 3 è un gioco che chiude la trilogia con il botto. La campagna è avvincente e ricca di colpi di scena, mentre il multiplayer è sempre veloce e divertente. La modalità Spec Ops aggiunge un ulteriore valore al gioco, anche se alcune missioni sono troppo simili. Nel complesso, un finale che soddisfa le aspettative.", 4.8, 223, 6),
("Un grande finale, ma non perfetto", "Modern Warfare 3 chiude la trilogia con una campagna avvincente e un multiplayer solido. Tuttavia, alcune missioni della campagna potrebbero essere più varie e il multiplayer non offre grosse novità. La modalità Spec Ops è interessante, ma può diventare ripetitiva dopo un po'. In generale, un ottimo gioco che avrebbe potuto fare meglio in alcune aree.", 4.6, 223, 7),
("Il capitolo che conclude tutto", "Modern Warfare 3 è il gioco che conclude la saga con stile. La campagna è emozionante e piena di azione, mentre il multiplayer è sempre frenetico e divertente. La modalità Spec Ops è interessante, ma non così innovativa. Nel complesso, un capitolo solido che conclude la trilogia in modo degno, ma non rivoluzionario.", 4.7, 223, 8),
("Frenetico ma familiare", "Modern Warfare 3 è un gioco che non delude, con una campagna che tiene alta la tensione e un multiplayer che rimane il punto di forza della serie. Tuttavia, non ci sono grandi novità rispetto ai capitoli precedenti. La modalità Spec Ops è divertente, ma a volte manca di contenuti veramente nuovi. Un buon gioco, ma non all'altezza delle aspettative di innovazione.", 4.5, 223, 9),
("Divertente ma senza sorprese", "Call of Duty: Modern Warfare 3 è un gioco che non ha sorprese. La campagna è buona, ma segue una formula ormai ben collaudata. Il multiplayer è il solito, divertente ma non aggiunge granché. La modalità Spec Ops è interessante, ma non riesce a fare la differenza. In generale, è un gioco solido, ma non innovativo.", 4.4, 223, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capitolo solido ma poco originale", "Call of Duty: Vanguard offre un'esperienza di gioco solida, con una campagna interessante che esplora la Seconda Guerra Mondiale, ma non aggiunge nulla di veramente nuovo. Il multiplayer è divertente, ma sembra seguire una formula già vista. La modalità Zombies è un po' ripetitiva, ma comunque divertente per chi cerca un po' di azione in più. Nel complesso, un buon gioco, ma senza troppe sorprese.", 4.2, 224, 1),
("Divertente ma manca di innovazione", "Vanguard è un altro Call of Duty che offre un buon livello di divertimento, soprattutto nel multiplayer. Tuttavia, la campagna non è niente di speciale e non porta novità al genere. La modalità Zombies è simpatica, ma sembra poco ispirata rispetto ai capitoli precedenti. Un gioco che offre ore di svago, ma non riesce a distinguersi per originalità.", 4.1, 224, 2),
("Ritorno alla Seconda Guerra Mondiale", "Vanguard segna il ritorno alla Seconda Guerra Mondiale, ma non riesce a portare una ventata di novità. La campagna è interessante, ma non è abbastanza coinvolgente. Il multiplayer è il solito, frenetico e divertente, ma niente che non si sia già visto. La modalità Zombies è la parte più interessante, ma alla lunga diventa un po' ripetitiva.", 4.3, 224, 3),
("Bello, ma poteva fare di più", "Call of Duty: Vanguard è un buon gioco, ma manca di qualcosa di speciale. La campagna è buona, ma non riesce a coinvolgere come i capitoli precedenti. Il multiplayer è sempre divertente, ma non aggiunge molto rispetto ai giochi passati. La modalità Zombies è una buona aggiunta, ma diventa noiosa dopo un po'. Un gioco che offre ore di intrattenimento, ma senza innovare troppo.", 4.0, 224, 4),
("Un gioco che non brilla", "Vanguard è divertente, ma non riesce a brillare come i suoi predecessori. La campagna è breve e poco memorabile, mentre il multiplayer è il solito frenetico e veloce. La modalità Zombies è interessante ma manca di varietà. Nel complesso, è un gioco che farà divertire i fan della saga, ma non aggiunge nulla di nuovo.", 3.9, 224, 5),
("Un ritorno alle origini", "Call of Duty: Vanguard ci riporta alla Seconda Guerra Mondiale, ma non riesce a farlo in modo particolarmente innovativo. La campagna è interessante, ma poco memorabile. Il multiplayer è divertente, ma sembra troppo simile a quello di altri capitoli della saga. La modalità Zombies è divertente, ma non aggiunge nulla di nuovo. Un gioco che intrattiene, ma che non lascia il segno.", 4.2, 224, 6),
("Piacevole, ma poco originale", "Vanguard è un gioco piacevole da giocare, ma non ha nulla di veramente originale. La campagna è interessante, ma non troppo coinvolgente. Il multiplayer è sempre frenetico e divertente, ma non aggiunge novità. La modalità Zombies è una buona aggiunta, ma non riesce a spiccare come nelle edizioni precedenti. Un gioco che divertirà i fan, ma non innovativo.", 4.0, 224, 7),
("Un capitolo solido ma senza guizzi", "Call of Duty: Vanguard è un gioco solido, ma manca di guizzi di originalità. La campagna è ben fatta, ma non lascia un segno indelebile. Il multiplayer è sempre divertente, ma non presenta novità particolari. La modalità Zombies è la più interessante, ma non riesce a stupire. Nel complesso, un gioco che offre divertimento ma non eccelle.", 4.1, 224, 8),
("Divertente, ma poco innovativo", "Call of Duty: Vanguard è un gioco che offre ore di divertimento, ma non porta novità significative. La campagna è buona, ma non emoziona come quella di altri capitoli. Il multiplayer è il solito, frenetico e pieno di azione. La modalità Zombies è interessante, ma potrebbe essere più varia. Un gioco che soddisfa i fan, ma non spinge oltre.", 4.3, 224, 9),
("Un buon gioco, ma niente di più", "Vanguard è un buon gioco, ma non ha nulla che lo faccia distinguere dagli altri capitoli di Call of Duty. La campagna è interessante, ma non è particolarmente coinvolgente. Il multiplayer è il solito, con alcune mappe divertenti, ma niente di nuovo. La modalità Zombies è la parte più interessante, ma alla lunga risulta monotona.", 4.0, 224, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno al passato", "Call of Duty: WWII ci riporta alle origini della saga, con una campagna che esplora la Seconda Guerra Mondiale. La storia è interessante, ma la trama non offre niente di particolarmente originale. Il multiplayer è divertente, ma sembra non aggiungere novità. La modalità Zombies è solida, ma non fa nulla di troppo innovativo. Un buon gioco, ma senza sorprese.", 4.3, 225, 1),
("Un'esperienza classica", "Call of Duty: WWII è un ritorno alla Seconda Guerra Mondiale che piacerà sicuramente ai fan della saga. La campagna è coinvolgente, ma un po' prevedibile. Il multiplayer è solido e divertente, ma non porta novità rispetto ai giochi precedenti. La modalità Zombies è un'aggiunta interessante, anche se manca di originalità. Nel complesso, un gioco che non delude, ma non spicca.", 4.2, 225, 2),
("Una campagna coinvolgente", "La campagna di Call of Duty: WWII è avvincente e ben realizzata, con una storia interessante che ci riporta alle battaglie della Seconda Guerra Mondiale. Il multiplayer è il solito frenetico e divertente, ma non ci sono particolari innovazioni. La modalità Zombies è buona, ma non riesce a superare quella dei capitoli precedenti. Un gioco che offre tanto divertimento, ma non troppo nuovo.", 4.4, 225, 3),
("Un buon ritorno alla Seconda Guerra Mondiale", "Call of Duty: WWII segna un ritorno alle origini della saga con una campagna solida e un multiplayer che non delude. La trama della campagna è interessante, ma non sorprende troppo. Il multiplayer è sempre divertente, ma non aggiunge granché rispetto ai capitoli precedenti. La modalità Zombies è ben fatta, ma rimane abbastanza simile a quella degli altri giochi. Un buon gioco, ma niente di innovativo.", 4.1, 225, 4),
("Un'esperienza solida", "Call of Duty: WWII è un gioco che offre una solida esperienza di gioco, con una campagna interessante e un multiplayer che soddisfa le aspettative. Tuttavia, manca di novità rispetto ai capitoli precedenti. La modalità Zombies è buona, ma non offre niente di troppo innovativo. Nel complesso, un gioco che piacerà ai fan, ma non spicca per originalità.", 4.3, 225, 5),
("Un classico, ma senza sorprese", "Call of Duty: WWII ci riporta alla Seconda Guerra Mondiale, ma non riesce a sorprenderci come i capitoli precedenti. La campagna è interessante, ma manca di originalità. Il multiplayer è il solito, frenetico e divertente, ma non aggiunge nulla di nuovo. La modalità Zombies è buona, ma potrebbe essere più varia. Un gioco che non delude, ma non innovativo.", 4.0, 225, 6),
("Ben fatto, ma prevedibile", "Call of Duty: WWII è un gioco ben realizzato, con una campagna interessante e un multiplayer che soddisfa le aspettative. Tuttavia, la storia della campagna è un po' prevedibile e il multiplayer non offre particolari novità. La modalità Zombies è divertente, ma non riesce a portare qualcosa di nuovo. In generale, è un buon gioco, ma non sorprende.", 4.2, 225, 7),
("Un buon gioco, ma manca di freschezza", "Call of Duty: WWII è un buon gioco, ma non riesce a rinnovare la formula. La campagna è coinvolgente, ma non offre nulla di nuovo. Il multiplayer è il solito, ma senza aggiungere innovazioni significative. La modalità Zombies è buona, ma non è la migliore della saga. Un gioco che intrattiene, ma manca di freschezza.", 4.1, 225, 8),
("Un ritorno che non delude", "Call of Duty: WWII è un ritorno alle origini della saga che non delude le aspettative. La campagna è ben realizzata e coinvolgente, mentre il multiplayer è il solito frenetico e divertente. La modalità Zombies è solida, ma non aggiunge novità. Nel complesso, è un gioco che soddisfa, ma non spicca per innovazione.", 4.3, 225, 9),
("Un buon capitolo, ma troppo simile ai precedenti", "Call of Duty: WWII è un gioco che offre una buona esperienza, ma manca di novità rispetto ai capitoli precedenti. La campagna è interessante, ma non particolarmente coinvolgente. Il multiplayer è il solito, ma senza innovazioni significative. La modalità Zombies è ben fatta, ma non sorprende. Un buon gioco, ma troppo simile ai precedenti.", 4.0, 225, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Una sfida incredibile", "Celeste è un gioco incredibilmente difficile, ma gratificante. La piattaforma è precisa e ogni errore ti spinge a migliorare. La storia è profonda e ben raccontata, con un messaggio forte di auto-accettazione. La musica è spettacolare e completa l'esperienza. Un must per chi ama le sfide.", 5.0, 96, 1),
("Un platform che non ti lascia mai indifferente", "Celeste è un platform che riesce a combinare difficoltà, precisione e narrativa in modo perfetto. Ogni livello è progettato con cura, e anche quando ti sembra di non farcela, la soddisfazione di superare una sezione difficile è indescrivibile. La storia è emozionante e il messaggio è forte e positivo.", 4.9, 96, 2),
("Difficile ma giusto", "Celeste è un gioco che ti mette alla prova, ma non è mai frustrante. Ogni morte ti fa imparare qualcosa di nuovo e ti spinge a migliorare. La storia di Madeline è commovente e il gioco riesce a trattare tematiche importanti come l'autosuperamento e la salute mentale. Un'esperienza davvero coinvolgente.", 5.0, 96, 3),
("Un platform che insegna la perseveranza", "Celeste è un platform estremamente difficile, ma la bellezza del gioco sta nel suo design. Ogni morte è parte del processo di apprendimento e la sensazione di superare un livello difficile è unica. La storia è toccante, e il messaggio di perseveranza e accettazione è potente. Assolutamente consigliato a chi ama le sfide.", 4.8, 96, 4),
("Una delle migliori esperienze indie", "Celeste è senza dubbio uno dei migliori giochi indie mai creati. La sua difficoltà è giusta, la storia emozionante e la musica incredibile. Ogni livello è progettato alla perfezione e ti fa sentire come se stessi migliorando continuamente. La storia di Madeline è incredibile, e il tema del superamento delle proprie difficoltà personali è trattato con molta delicatezza.", 5.0, 96, 5),
("Una storia che ti tocca", "Oltre ad essere un platform magnifico, Celeste racconta una storia davvero profonda. Il tema dell'autoaccettazione e della lotta contro i propri demoni interiori è trattato con molta sensibilità. Il gameplay è difficile, ma ogni sfida ti fa apprezzare ancora di più la bellezza del gioco. Un'esperienza indimenticabile.", 4.9, 96, 6),
("Un platform con cuore", "Celeste è un platform impegnativo ma gratificante, con un cuore enorme. La narrazione è incredibile, il gameplay è preciso e la difficoltà è ben calibrata. Ogni sezione ti fa sentire che stai davvero facendo progressi, e la storia di Madeline è una delle più emozionanti che abbia mai visto in un gioco.", 5.0, 96, 7),
("La perfezione nei dettagli", "Celeste è un gioco perfetto nei dettagli. Il level design è straordinario, la difficoltà è bilanciata in modo da essere una sfida, ma non frustante. La storia di Madeline e il suo viaggio interiore sono trattati in modo eccezionale. Un gioco che ti lascia qualcosa di profondo anche dopo averlo finito.", 4.8, 96, 8),
("Un platform che cambia la vita", "Celeste è uno di quei giochi che non solo ti intrattengono, ma ti cambiano. La sua difficoltà ti spinge a non arrenderti mai, e la storia di Madeline ti fa riflettere sul proprio valore e sulla lotta contro la depressione. La musica è straordinaria, e il gameplay è uno dei più precisi che abbia mai visto. Un'esperienza che va oltre il semplice gioco.", 5.0, 96, 9),
("Una gemma indie", "Celeste è una gemma del panorama indie. È un platform che mette alla prova le tue abilità, ma che ti premia con una storia emozionante e un gameplay che ti fa sentire ogni successo. La colonna sonora è fantastica e completa l'esperienza in modo perfetto. Se ti piacciono le sfide, questo gioco è un must.", 4.9, 96, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro senza tempo", "Chrono Trigger è un gioco che ha resistito alla prova del tempo. La trama è affascinante e piena di colpi di scena, con personaggi memorabili e una narrazione che ti tiene incollato. Il sistema di battaglia è unico e la possibilità di viaggiare nel tempo aggiunge una profondità incredibile. È un gioco che ogni appassionato di RPG dovrebbe giocare almeno una volta.", 5.0, 60, 1),
("Un classico che non delude", "Chrono Trigger è uno dei RPG più amati di tutti i tempi, e con buona ragione. La trama è coinvolgente, il sistema di battaglie è innovativo e il viaggio nel tempo è uno degli aspetti che lo rende unico. Anche se è un gioco vecchio, la sua qualità non è mai diminuita. Un must per ogni fan del genere.", 4.9, 60, 2),
("Un viaggio nel tempo che non dimenticherai", "Chrono Trigger è una delle esperienze di gioco più iconiche della storia. Il suo mix di avventura, battaglie strategiche e viaggi nel tempo lo rende uno dei giochi più innovativi mai creati. Ogni scelta ha un impatto sulla trama, e il gioco offre numerosi finali che invogliano a rigiocarlo. Se non l'hai mai giocato, stai perdendo una pietra miliare del genere RPG.", 5.0, 60, 3),
("Un RPG che ha fatto storia", "Chrono Trigger è un gioco che ha influenzato profondamente il mondo dei giochi di ruolo. La sua trama coinvolgente, il sistema di battaglia innovativo e i personaggi memorabili lo rendono un capolavoro senza tempo. Il viaggio nel tempo aggiunge una componente unica che rende ogni partita speciale. Imperdibile per chi ama il genere.", 4.9, 60, 4),
("Un'esperienza di gioco indimenticabile", "Chrono Trigger è un RPG che ha definito un'intera generazione di giocatori. La sua trama coinvolgente, l'innovativo sistema di battaglia e l'ambientazione che ti fa viaggiare nel tempo rendono questo gioco un'esperienza indimenticabile. È un gioco che resiste alla prova del tempo e che merita di essere giocato ancora oggi.", 5.0, 60, 5),
("Un gioco che non perde il suo fascino", "Anche dopo tutti questi anni, Chrono Trigger rimane uno dei migliori giochi RPG di sempre. La sua storia, i suoi personaggi e il sistema di battaglie sono ancora freschi e avvincenti. Il gioco riesce a creare un'esperienza unica grazie ai viaggi nel tempo e alle scelte che influiscono sul destino del mondo. Un classico senza tempo.", 4.8, 60, 6),
("Una trama che ti cattura", "Chrono Trigger non è solo un gioco, è un'esperienza. La trama è ricca di colpi di scena e i personaggi sono così ben scritti che ti affezioni a loro fin da subito. I viaggi nel tempo aggiungono una dimensione interessante alla storia, e la possibilità di influenzare gli eventi rende ogni partita unica. Un vero capolavoro del genere RPG.", 5.0, 60, 7),
("Il miglior RPG di tutti i tempi", "Per molti, Chrono Trigger è il miglior RPG mai creato. La sua trama è affascinante, il gameplay è incredibilmente coinvolgente, e i viaggi nel tempo sono un concetto geniale. I personaggi sono ben sviluppati e la colonna sonora è indimenticabile. Se sei un appassionato di giochi di ruolo, non puoi perderti questo capolavoro.", 5.0, 60, 8),
("Un capolavoro che non ha tempo", "Chrono Trigger è uno di quei giochi che non invecchiano mai. La sua narrazione avvincente, il sistema di battaglie dinamico e la possibilità di esplorare diverse epoche lo rendono un'esperienza senza pari. La musica è fantastica, e ogni partita è un'avventura da vivere. Se non lo hai mai giocato, è il momento giusto per farlo.", 4.9, 60, 9),
("Un gioiello del passato", "Chrono Trigger è un RPG che ha definito l'intero genere. La storia ti cattura fin da subito, i personaggi sono unici e ben scritti, e il viaggio nel tempo aggiunge una profondità incredibile al gioco. La possibilità di ottenere finali diversi aumenta il valore di rigiocabilità. Un classico che ogni amante dei giochi di ruolo dovrebbe giocare.", 5.0, 60, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Il miglior simulatore di città", "Cities: Skylines è senza dubbio il miglior simulatore di città che abbia mai giocato. La sua profondità e la libertà di costruzione sono incredibili. Ogni decisione che prendi ha un impatto tangibile sulla città, dalla gestione delle risorse alla pianificazione dei trasporti. È un gioco che offre infinite possibilità, ed è una gioia vedersi crescere la propria metropoli.", 5.0, 74, 1),
("Simulazione realistica e coinvolgente", "La simulazione di Cities: Skylines è assolutamente realistica. Ogni aspetto della città, dalle strade alla gestione dei servizi pubblici, è dettagliato e ti fa sentire davvero come un sindaco. Le espansioni e i modding aumentano ulteriormente la longevità del gioco, facendo sì che ogni partita sia diversa. Se ti piacciono i giochi di simulazione, questo è un must.", 4.9, 74, 2),
("Un gioco che ti assorbe completamente", "Cities: Skylines è il gioco perfetto per chi ama la pianificazione e la gestione. La sua complessità è straordinaria, e ogni aspetto della città deve essere preso in considerazione. Dalla gestione delle risorse alla costruzione delle infrastrutture, il gioco offre una soddisfazione enorme ogni volta che riesci a risolvere un problema o a migliorare la tua città. Assolutamente avvincente.", 5.0, 74, 3),
("Un'esperienza di simulazione incredibile", "Cities: Skylines è una delle esperienze di simulazione più complete e soddisfacenti. Le opzioni per la costruzione della città sono praticamente infinite, e la gestione delle risorse richiede una pianificazione strategica. Ogni volta che risolvi un problema o migliori una parte della tua città, c'è una sensazione di realizzazione che è difficile trovare in altri giochi. Consigliato a chi ama le simulazioni!", 4.8, 74, 4),
("Un mondo in continua evoluzione", "Cities: Skylines è un gioco che ti permette di creare il tuo mondo e vedere come evolve nel tempo. La bellezza del gioco sta nell'abilità di risolvere problemi complessi mentre costruisci una città che cresce e si sviluppa. Ogni scelta che fai ha ripercussioni, e la possibilità di gestire la crescita urbana è incredibile. Un gioco che non stanca mai e offre sempre nuove sfide.", 5.0, 74, 5),
("Un gioco per chi ama i dettagli", "Cities: Skylines è un gioco che premia l'attenzione ai dettagli. Dalla costruzione delle strade alla gestione delle zone residenziali, commerciali e industriali, tutto deve essere pianificato con cura. Le opzioni di personalizzazione e modding sono altrettanto impressionanti, permettendo di espandere l'esperienza di gioco in modi interessanti. Se ami i giochi di simulazione, questo è un must-have.", 4.9, 74, 6),
("Un'esperienza unica di gestione urbana", "Cities: Skylines è il miglior gioco di simulazione di città che abbia mai giocato. Ogni aspetto della tua città, dalle infrastrutture alla gestione delle risorse, è sotto il tuo controllo. La crescita della città è soddisfacente, e ogni sfida che affronti ti spinge a pensare in modo strategico. Le espansioni e i modding ti permettono di espandere ancora di più l'esperienza di gioco. Un vero capolavoro.", 5.0, 74, 7),
("Un gioco che ti mette alla prova", "Cities: Skylines è un gioco che ti sfida continuamente. Non è solo una questione di costruire una città, ma di gestire ogni aspetto della vita urbana: traffico, salute, educazione, ambiente. Ogni decisione che prendi ha un impatto tangibile sulla città, e risolvere i problemi che sorgono è incredibilmente gratificante. Un gioco che ti tiene sempre impegnato.", 4.8, 74, 8),
("Creatività e strategia in un unico gioco", "Cities: Skylines è un mix perfetto di creatività e strategia. La possibilità di costruire una città da zero ti dà un senso di libertà incredibile. Ma allo stesso tempo, la gestione dei problemi, come il traffico o le carenze di servizi, richiede una pianificazione strategica. È un gioco che stimola la mente e ti permette di vedere crescere e prosperare il tuo mondo.", 5.0, 74, 9),
("Un gioco che non smette di sorprendere", "Cities: Skylines è un gioco che non smette mai di sorprendermi. Ogni volta che riesco a risolvere un problema o a migliorare la mia città, mi sento realizzato. La varietà di opzioni per la costruzione e la gestione delle risorse rende il gioco sempre interessante, e le espansioni e i modding offrono infinite possibilità. Se ti piacciono i giochi di simulazione, non puoi perdertelo.", 5.0, 74, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco che ti fa pensare", "Civilization VI è un gioco che ti fa ragionare su ogni mossa. La possibilità di sviluppare una civiltà dalle sue origini fino a diventare una superpotenza globale è entusiasmante. Ogni partita è diversa, e la gestione delle risorse, delle diplomazie e delle guerre richiede una strategia attenta. È un gioco che ti tiene incollato per ore.", 5.0, 67, 1),
("Un capolavoro della strategia", "Civilization VI è uno dei migliori giochi di strategia di sempre. La complessità del gioco è incredibile, ma è anche facile da imparare grazie ai tutorial ben strutturati. Ogni civiltà ha le proprie peculiarità, e la possibilità di esplorare, espandere, sfruttare e distruggere è affascinante. Le infinite variabili fanno sì che ogni partita sia unica e stimolante.", 4.9, 67, 2),
("Strategia e lunghe ore di divertimento", "Civilization VI ti permette di vivere un'esperienza di gioco straordinaria. Le opzioni di costruzione, gestione delle città e diplomatiche sono così complesse che ogni partita si trasforma in una sfida. Le guerre, le alleanze, e la conquista di nuove terre richiedono una pianificazione dettagliata. Ogni partita è lunga e stimolante, un gioco che non stanca mai.", 5.0, 67, 3),
("Un'esperienza di strategia senza pari", "Civilization VI è senza dubbio uno dei giochi più strategici che abbia mai giocato. Ogni scelta che fai ha delle ripercussioni sul lungo periodo, sia a livello politico che economico. La gestione delle risorse è fondamentale, e la diplomazia è complessa ma soddisfacente. È un gioco che ti fa ragionare, pianificare e adattarti in continuazione.", 5.0, 67, 4),
("Un gioco che ti coinvolge per ore", "Civilization VI è un gioco che può sembrare lento all'inizio, ma man mano che ti immergi nel gioco diventa incredibilmente coinvolgente. Ogni partita è unica, e la possibilità di esplorare, costruire e conquistare il mondo ti tiene attaccato al monitor. La varietà di civiltà e strategie rende il gioco molto replayable. Un must per gli amanti della strategia.", 4.8, 67, 5),
("Un gioco che premia la pazienza", "Civilization VI è un gioco che premia chi è disposto a pianificare a lungo termine. Ogni mossa richiede attenzione, e spesso è necessario fare sacrifici per ottenere i risultati migliori. Le scelte diplomatiche, le alleanze e le guerre sono tutte importanti, e riuscire a dominare il mondo è una soddisfazione che richiede tempo e strategia. Un gioco che non stanca mai.", 4.9, 67, 6),
("Il gioco di strategia per eccellenza", "Civilization VI è il gioco di strategia per eccellenza. Le sue meccaniche di gioco sono profonde e offrono una varietà di modi per vincere, che vanno dalla guerra alla diplomazia. Ogni partita è unica, e le possibilità di sviluppare la tua civiltà sono praticamente infinite. Se ti piacciono i giochi di strategia, questo è un gioco che non puoi perderti.", 5.0, 67, 7),
("Ogni partita è una nuova sfida", "Civilization VI è un gioco che non si ripete mai. Ogni civiltà ha le sue peculiarità, e l'interazione tra le diverse civiltà rende ogni partita interessante. La gestione delle risorse è fondamentale, così come la diplomazia e la guerra. È un gioco che ti costringe a pensare a lungo termine e che offre una sfida continua.", 4.9, 67, 8),
("Un'esperienza di gioco epica", "Civilization VI è un gioco epico che ti fa vivere la storia dall'alba della civiltà fino al futuro. La possibilità di guidare una civiltà in modo unico è affascinante, e le scelte strategiche sono davvero tante. Le opzioni diplomatiche, le alleanze e la guerra sono tutte parti importanti del gioco, che ti sfida continuamente a prendere le decisioni migliori.", 5.0, 67, 9),
("Il gioco che ti fa sentire un leader", "Civilization VI ti fa sentire come un vero leader, mentre guidi una civiltà dalle sue origini fino a dominare il mondo. La gestione della diplomazia, delle risorse, della cultura e delle guerre è una sfida costante. Ogni partita è diversa, e la sensazione di costruire qualcosa di duraturo è davvero appagante. Un gioco che ti fa riflettere su ogni mossa.", 4.8, 67, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'esperienza psicologica unica", "Control è un gioco che ti avvolge completamente in un'atmosfera misteriosa e intrigante. La trama è ricca di colpi di scena e ti tiene attaccato alla storia. La combinazione di azione e puzzle, insieme alla possibilità di usare poteri psichici, rende ogni combattimento unico. La direzione artistica è incredibile, con scenari surreali e intriganti che ti fanno sentire parte di un mondo straordinario.", 5.0, 12, 1),
("Un gioco che sfida la mente", "Control è un gioco che stimola la mente come pochi altri. La sua narrazione psicologica e surreale ti coinvolge sin da subito, e la combinazione di azione e poteri psichici ti permette di affrontare ogni sfida in modo creativo. Gli ambienti sono ben curati e il gameplay è fluido, anche se a volte la trama può sembrare un po' complessa. Tuttavia, vale assolutamente la pena giocarlo.", 4.7, 12, 2),
("Stile unico e gameplay coinvolgente", "Control è un gioco che spicca per la sua atmosfera unica e il gameplay coinvolgente. La storia si sviluppa attraverso un mix di esplorazione, azione e puzzle, mantenendo alta la tensione per tutta la durata. La possibilità di usare poteri psichici durante i combattimenti offre una sensazione di potenza e controllo, ed è davvero divertente. L'unico difetto potrebbe essere la struttura della storia, che può sembrare a tratti confusa.", 4.8, 12, 3),
("Un'esperienza visiva straordinaria", "Control è uno dei giochi più affascinanti dal punto di vista visivo. Gli ambienti sono ben progettati, con un'architettura surreale che ti lascia senza fiato. La storia è intrigante e ti spinge a esplorare il mondo misterioso in cui si svolge. La parte migliore del gioco è senza dubbio l'uso dei poteri psichici, che rendono ogni combattimento un'esperienza unica. Un gioco che merita di essere giocato.", 5.0, 12, 4),
("Un tuffo in un mondo sovrannaturale", "Control ti catapulta in un mondo ricco di misteri e fenomeni sovrannaturali. Il mix tra esplorazione, combattimenti e puzzle è ben bilanciato, e l'uso dei poteri psichici è davvero spettacolare. La storia ti coinvolge, anche se alcuni dettagli possono risultare difficili da seguire. Un gioco che sfida le convenzioni e offre un'esperienza unica.", 4.6, 12, 5),
("Innovativo e affascinante", "Control è un gioco innovativo che mescola azione, esplorazione e psicologia. La trama è affascinante e il mondo di gioco è pieno di segreti e misteri da scoprire. La possibilità di usare poteri psichici rende i combattimenti entusiasmanti e diversi da altri giochi del genere. Sebbene la storia possa risultare un po' difficile da seguire in alcuni punti, l'esperienza complessiva è estremamente soddisfacente.", 4.8, 12, 6),
("Atmosfera unica e gameplay variegato", "Control è un gioco che ti sorprende ad ogni angolo. La sua atmosfera unica e la trama misteriosa ti tengono costantemente coinvolto. La combinazione di azione, puzzle e poteri psichici è molto divertente, e la possibilità di utilizzare l'ambiente a proprio favore rende ogni combattimento interessante. La storia è affascinante ma può risultare un po' confusa in alcuni passaggi.", 4.7, 12, 7),
("Un'esperienza intensa e coinvolgente", "Control è un gioco che ti cattura sin dall'inizio. La trama è intrigante e ti spinge a scoprire cosa si nasconde dietro ogni angolo del misterioso edificio in cui ti trovi. I combattimenti sono dinamici e divertenti grazie ai poteri psichici, che ti danno la sensazione di essere veramente potente. La storia è coinvolgente, anche se richiede attenzione per essere compresa appieno.", 5.0, 12, 8),
("Un mix perfetto di azione e psicologia", "Control è un gioco che unisce l'azione frenetica con una trama psicologica e misteriosa. La possibilità di usare poteri psichici per combattere è molto divertente, e la storia ti spinge a riflettere su temi profondi. Gli ambienti sono unici e ben progettati, ma la complessità della trama potrebbe confondere alcuni giocatori. Un gioco che sicuramente lascia il segno.", 4.8, 12, 9),
("Un titolo che non delude", "Control è un gioco che non delude le aspettative. La trama coinvolgente e gli straordinari poteri psichici ti fanno sentire come un vero protagonista di un thriller psicologico. Ogni combattimento è emozionante e ogni angolo da esplorare nasconde un mistero. Sebbene la storia possa sembrare complicata in alcuni punti, il gioco è sicuramente da non perdere per chi ama l'azione e il mistero.", 4.9, 12, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Il miglior gioco competitivo", "Counter-Strike 2 è il gioco competitivo per eccellenza. Ogni partita è una sfida intensa che mette alla prova la tua abilità, strategia e comunicazione con il team. Le mappe sono ben bilanciate e la meccanica di gioco è impeccabile. Non c'è niente di meglio che una vittoria in squadra, dove ogni mossa conta. L'unico difetto è che può essere frustrante all'inizio, ma una volta che impari a giocare, diventa irresistibile.", 5.0, 176, 1),
("Sempre al top", "Nonostante sia un gioco vecchio, Counter-Strike 2 rimane uno dei titoli più giocati e amati. La combinazione di tattiche e riflessi rapidi è ciò che rende ogni partita unica. La comunità è molto attiva e ci sono sempre nuovi aggiornamenti. Se sei un fan dei giochi sparatutto competitivi, non puoi non provare Counter-Strike 2.", 4.8, 176, 2),
("Gioco che ti prende", "Counter-Strike 2 è un gioco che ti cattura fin dalla prima partita. La sensazione di ogni scontro a fuoco è davvero coinvolgente, e il lavoro di squadra è essenziale per vincere. Le mappe e il design delle armi sono eccellenti, anche se a volte il gioco può sembrare un po' punitivo per i principianti. Ma la curva di apprendimento rende ogni vittoria ancora più soddisfacente.", 4.7, 176, 3),
("Esplosivo e strategico", "Counter-Strike 2 è esplosivo, tanto nella sua azione quanto nelle strategie che devi sviluppare con il tuo team. Le partite richiedono grande coordinazione e ogni decisione può cambiare l'esito del match. La meccanica di gioco è molto solida, ma può essere difficile per i neofiti abituarsi al ritmo rapido delle partite.", 4.9, 176, 4),
("Gioco per veri pro", "Counter-Strike 2 è un gioco che premia l'abilità e la preparazione. Ogni mossa deve essere calcolata e il gioco ti costringe a migliorare continuamente. Le mappe sono ben progettate e offrono tante opportunità per strategie differenti. Non è un gioco facile, ma per chi ama la competizione è senza pari.", 5.0, 176, 5),
("Un classico intramontabile", "Counter-Strike 2 è un classico che non muore mai. La formula di gioco è semplice ma estremamente efficace, e ogni partita è diversa. Il sistema di rank e la comunità di giocatori sono sempre attivi, il che garantisce partite sempre competitive. Certo, la curva di apprendimento può essere ripida, ma una volta che capisci come funziona, non ti stanchi mai.", 4.8, 176, 6),
("Perfetto per i giocatori competitivi", "Counter-Strike 2 è perfetto per chi cerca un'esperienza di gioco altamente competitiva. Ogni round è una battaglia dove l'intelligenza e il riflesso veloce sono la chiave per vincere. La possibilità di giocare in team e di comunicare con i compagni di squadra rende ogni partita unica. Se ti piace sfidare te stesso, questo gioco è quello che fa per te.", 5.0, 176, 7),
("Un'esperienza che non stanca mai", "Counter-Strike 2 è uno di quei giochi che non ti stanchi mai di giocare. Le partite sono veloci, intense e richiedono una grande capacità di reazione. La varietà delle armi e delle mappe ti permette di sperimentare diverse tattiche ogni volta che giochi. È il gioco ideale per chi ama la competizione e le sfide costanti.", 4.9, 176, 8),
("Gioco con una curva di apprendimento ripida", "Counter-Strike 2 è senza dubbio un gioco divertente, ma la curva di apprendimento è piuttosto ripida. I nuovi giocatori potrebbero sentirsi frustrati inizialmente, ma se hai pazienza e dedizione, la soddisfazione di migliorare e vincere è impagabile. La comunità è grande, ma ci sono molte persone che giocano da anni, il che può risultare intimidatorio per i novizi.", 4.5, 176, 9),
("Perfetto per le sfide online", "Counter-Strike 2 è perfetto per le sfide online. La meccanica di gioco è estremamente fluida e l'aspetto competitivo ti tiene sempre sulla punta dei piedi. Ogni partita è unica grazie alla varietà di mappe e modalità. La comunità è molto attiva e le partite sono sempre piene di adrenalina. Sicuramente uno dei giochi più competitivi al mondo.", 5.0, 176, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno trionfale", "Crash Bandicoot 4 è un incredibile ritorno per il celebre marsupiale. Il gioco mantiene lo spirito del classico, ma con meccaniche moderne che lo rendono ancora più divertente. I livelli sono ricchi di dettagli e sfide, e la difficoltà è ben bilanciata. Per chi è fan della serie, è un must-have.", 5.0, 112, 1),
("Il miglior Crash", "Crash Bandicoot 4 è senza dubbio il miglior titolo della saga. La grafica è spettacolare, i controlli sono fluidi e le nuove meccaniche di gioco, come la possibilità di cambiare personaggio, aggiungono un livello di varietà che non avevamo visto nei precedenti giochi. La difficoltà è impegnativa, ma mai ingiusta.", 4.8, 112, 2),
("Pura nostalgia", "Crash Bandicoot 4 riesce a catturare perfettamente la nostalgia dei vecchi giochi, ma con un tocco moderno. I livelli sono progettati con grande cura e le nuove abilità di Crash e dei suoi amici aggiungono profondità al gameplay. La difficoltà è elevata, ma questo è ciò che rende il gioco così coinvolgente per i fan del genere.", 4.7, 112, 3),
("Una ventata di freschezza", "Crash Bandicoot 4 offre una ventata di freschezza alla saga. Le nuove abilità e i livelli ricchi di azione sono davvero divertenti. I design delle ambientazioni e delle animazioni sono fantastici, ma ciò che colpisce di più è l'innovazione. Un gioco che piacerà sicuramente sia ai vecchi fan che ai nuovi giocatori.", 4.9, 112, 4),
("Il gioco che aspettavamo", "Crash Bandicoot 4 è il gioco che tutti aspettavamo. Non solo offre la stessa frenesia e sfida che caratterizzava i titoli originali, ma aggiunge anche nuove meccaniche e un livello di politura che lo rende perfetto. Ogni livello è una nuova avventura e la difficoltà crescente mantiene il gioco interessante e impegnativo.", 5.0, 112, 5),
("Divertente ma impegnativo", "Crash Bandicoot 4 è divertente, ma anche piuttosto impegnativo. I livelli sono ricchi di segreti e la difficoltà aumenta rapidamente, il che può essere frustrante, ma allo stesso tempo gratificante. La grafica è splendida e il gameplay è ben progettato, ma solo i giocatori più pazienti arriveranno alla fine.", 4.6, 112, 6),
("Un gioco dal grande cuore", "Crash Bandicoot 4 è un gioco che trasuda passione. Ogni aspetto, dalla grafica al design dei livelli, è stato curato nei minimi dettagli. Le nuove meccaniche di gioco sono una gioia da esplorare, e la sfida è perfetta per i fan dei giochi platform. Non è solo un buon gioco, è un vero e proprio tributo alla serie.", 5.0, 112, 7),
("Un platform di qualità", "Crash Bandicoot 4 è un platform di altissimo livello. La difficoltà è ben calibrata e la varietà dei livelli è sorprendente. Ogni ambiente è unico e offre una nuova sfida. Le nuove abilità dei personaggi aggiungono una buona dose di varietà al gameplay, mantenendo tutto fresco e interessante.", 4.7, 112, 8),
("Un'esperienza impegnativa", "Crash Bandicoot 4 è un gioco impegnativo, ma questo è ciò che lo rende speciale. Ogni livello offre sfide uniche e la difficoltà è bilanciata in modo da non risultare mai frustrante. La varietà dei livelli e delle meccaniche lo rende uno dei migliori platform in circolazione. Se sei un fan del genere, non puoi perdertelo.", 4.8, 112, 9),
("Un platform che fa la differenza", "Crash Bandicoot 4 fa la differenza nel genere dei platform. La combinazione di azione frenetica, livelli ben progettati e nuovi elementi di gameplay rende il gioco unico. La difficoltà può essere alta, ma le ricompense sono all'altezza. Un'esperienza divertente e stimolante per chi ama le sfide.", 4.9, 112, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro della strategia", "Crusader Kings III è un capolavoro nel suo genere. La profondità delle meccaniche politiche e dinastiche è incredibile, e ti permette di vivere l'esperienza di governare un impero in ogni sua sfumatura. Ogni decisione può avere un impatto duraturo sulla tua dinastia. La curva di apprendimento è ripida, ma una volta che capisci le dinamiche, il gioco diventa irresistibile.", 5.0, 71, 1),
("Strategia e politica a un livello superiore", "Crusader Kings III porta la strategia a un livello superiore. La possibilità di costruire una dinastia attraverso le generazioni è affascinante. Le scelte politiche, matrimoniali e religiose sono cruciali per il successo, e ogni partita si sviluppa in modo unico. L'unico problema è la curva di apprendimento, ma una volta superata, il gioco è una vera esperienza immersiva.", 4.9, 71, 2),
("Una simulazione di impero perfetta", "Crusader Kings III è la simulazione di impero definitiva. Non è solo un gioco di strategia, è una narrazione dinamica che si sviluppa a seconda delle tue scelte. Le interazioni tra i vari personaggi sono ricche e la gestione della dinastia è coinvolgente. Il gioco ha una profondità incredibile, ma richiede tempo e pazienza per imparare tutte le meccaniche.", 4.8, 71, 3),
("Un'esperienza di gioco unica", "Crusader Kings III offre un'esperienza di gioco unica nel suo genere. Non si tratta solo di combattere battaglie, ma di navigare attraverso trame politiche, alleanze e intrighi. La creazione di una dinastia e la gestione delle relazioni familiari e regnanti è affascinante. Se sei un fan dei giochi di strategia e di simulazione, questo è un must-have.", 5.0, 71, 4),
("Grande complessità, grande soddisfazione", "Crusader Kings III è un gioco complesso, ma estremamente gratificante. Ogni partita è diversa grazie alle infinite possibilità di interazione e alle dinamiche interne di ciascun regno. La gestione delle alleanze, dei conflitti e dei matrimoni ti farà sentire un vero sovrano. L'unica difficoltà è che può sembrare travolgente all'inizio, ma una volta che impari, il gioco diventa davvero coinvolgente.", 4.7, 71, 5),
("Il gioco di strategia per eccellenza", "Se ti piacciono i giochi di strategia, Crusader Kings III è senza dubbio il miglior titolo che puoi trovare. Non si tratta solo di combattere, ma di creare una dinastia e di gestire una rete complessa di alleanze, matrimoni e intrighi. Ogni scelta ha delle conseguenze, e il fatto che le tue azioni possano ripercuotersi su generazioni future è ciò che rende il gioco così interessante.", 5.0, 71, 6),
("L'evoluzione della saga", "Crusader Kings III è un'evoluzione perfetta della saga. Rispetto ai precedenti titoli, questo gioco offre una grafica migliorata e una gestione della dinastia ancora più ricca e approfondita. Il gameplay è avvincente e la complessità delle decisioni politiche è affascinante. Sebbene possa essere difficile da imparare, una volta che entri nel flusso del gioco, non riesci più a smettere.", 4.8, 71, 7),
("Per veri strateghi", "Crusader Kings III è un gioco per veri strateghi. La gestione di un regno richiede astuzia politica, abilità nella guerra e una comprensione profonda delle dinamiche familiari e dinastiche. Ogni mossa può avere ripercussioni enormi, e la possibilità di creare una dinastia che dura secoli è un'esperienza unica. La curva di apprendimento è ripida, ma ne vale assolutamente la pena.", 4.9, 71, 8),
("Un'esperienza da vivere", "Crusader Kings III ti permette di vivere un'esperienza unica di gioco. Le possibilità di gioco sono infinite e ogni partita offre nuove sfide. La gestione di alleanze, intrighi politici e guerre è affascinante, ma il vero cuore del gioco è la creazione e la gestione della tua dinastia. Ogni successo e fallimento sarà un racconto da ricordare. Un gioco che richiede tempo, ma che ripaga ampiamente.", 4.7, 71, 9),
("Storia e strategia mescolate", "Crusader Kings III è un mix perfetto di storia e strategia. La possibilità di interagire con personaggi storici e di creare la tua dinastia in un contesto storico ben ricostruito è emozionante. La strategia è fondamentale per navigare le sfide politiche e sociali, ma è anche la narrazione che rende il gioco speciale. Un gioco che ogni amante della storia dovrebbe provare.", 5.0, 71, 10);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Stile unico e gameplay impegnativo", "Cuphead è un gioco che ti cattura non solo per la sua estetica retrò, ma anche per la sfida che offre. Ogni livello è progettato con cura, e la difficoltà è costantemente alta. L'aspetto visivo è straordinario, con una grafica che sembra un cartone animato degli anni '30. La musica jazz e il design dei boss completano un'esperienza unica, ma preparati a perdere molte vite!", 4.9, 98, 1),
("Un vero test di abilità", "Cuphead è uno dei giochi più difficili che abbia mai giocato, ma è anche incredibilmente gratificante. Ogni battaglia contro i boss è un vero test di abilità e precisione. La grafica in stile cartone animato è splendida e crea un'atmosfera fantastica, ma non lasciarti ingannare dal suo aspetto: questo gioco è tutt'altro che facile!", 5.0, 98, 2),
("Divertente ma frustrante", "Cuphead è un gioco che trovo estremamente divertente, ma anche frustrante. La difficoltà è davvero alta e i boss sono una vera sfida. Ogni volta che riesci a battere un boss ti senti come un campione, ma le difficoltà sono tali che potresti passare più tempo a morire che a vincere. La grafica è bellissima e il gameplay è coinvolgente, ma devi essere preparato ad affrontare molte sfide.", 4.7, 98, 3),
("Un mix perfetto di estetica e difficoltà", "Cuphead è il tipo di gioco che ti fa sentire vivo e frustrato allo stesso tempo. La sua estetica anni '30 è unica nel suo genere e crea un contrasto affascinante con la difficoltà delle sfide. I boss sono creativi e impegnativi, ma è la precisione e la tempistica che ti faranno impazzire. Se sei alla ricerca di una sfida, questo è il gioco giusto per te.", 5.0, 98, 4),
("Un classico moderno", "Cuphead è un gioco che ha tutto: un'estetica fantastica, una colonna sonora jazz indimenticabile e una difficoltà che mette alla prova anche i più esperti. Ogni livello è unico e ricco di dettagli, ma non aspettarti di finirlo facilmente. Se ami i giochi impegnativi, questo titolo è un must-have. La difficoltà è elevata, ma ogni vittoria è estremamente soddisfacente.", 4.8, 98, 5),
("Design fantastico e gameplay impegnativo", "Cuphead offre una delle esperienze visive più belle che si possano trovare nei videogiochi. La grafica in stile cartone animato è magnifica e ogni boss è un'opera d'arte. La difficoltà, però, non è per tutti. La frustrazione può accumularsi, ma è difficile smettere di giocare grazie alla natura gratificante delle vittorie. Se sei disposto a metterti alla prova, ti piacerà moltissimo.", 4.7, 98, 6),
("Stile incredibile, difficoltà elevata", "Cuphead è un gioco incredibilmente stiloso e curato nei minimi dettagli. Ogni elemento, dalla grafica alla musica, contribuisce a creare un'atmosfera unica. Tuttavia, la difficoltà è piuttosto alta e può risultare frustrante. I combattimenti contro i boss sono emozionanti, ma preparati a fare molta pratica per riuscire a superare ogni livello.", 4.9, 98, 7),
("Una sfida per veri giocatori", "Cuphead è un gioco che ti mette alla prova in ogni momento. Non si tratta solo di abilità nel gioco, ma anche di pazienza. I boss sono spettacolari e ogni battaglia richiede una strategia ben pianificata. La grafica, in stile cartone animato, è davvero unica, e la colonna sonora jazz aggiunge un tocco speciale. Un gioco perfetto per chi cerca una sfida seria.", 5.0, 98, 8),
("Impegnativo ma molto gratificante", "Cuphead è uno di quei giochi che, pur essendo estremamente difficile, ti fa sentire realizzato ogni volta che superi una fase difficile. I boss sono una sfida incredibile e ogni partita è piena di momenti di pura eccitazione. La grafica è assolutamente straordinaria e la colonna sonora jazz ti farà battere il piede. Un gioco che consiglio a chi ama le sfide.", 4.8, 98, 9),
("Cuphead è arte", "Cuphead è una vera e propria opera d'arte, non solo per la sua estetica visiva, ma anche per la cura che è stata messa nella creazione di ogni singolo livello e boss. La difficoltà è sicuramente alta, ma ogni sconfitta ti insegna qualcosa. Il gioco è impegnativo, ma la bellezza del design e la musica jazz lo rendono un'esperienza indimenticabile.", 5.0, 98, 10);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'esperienza immersiva ma con difetti", "Cyberpunk 2077 offre un mondo straordinariamente dettagliato e coinvolgente. Night City è viva e pulsante, e ci sono tantissime cose da fare. Tuttavia, i bug e i problemi tecnici al lancio hanno penalizzato l'esperienza. Con le patch successive, il gioco è migliorato molto, ma resta un'opera che non ha raggiunto tutto il suo potenziale.", 4.2, 23, 11),
("Un capolavoro visivo", "La grafica di Cyberpunk 2077 è semplicemente incredibile, soprattutto su hardware di fascia alta. Night City è un'opera d'arte, piena di dettagli e neon. La trama principale è coinvolgente, e i personaggi, in particolare Johnny Silverhand, sono ben scritti. Peccato per i bug che ancora affliggono alcune versioni.", 4.5, 23, 22),
("Un gioco ambizioso", "Cyberpunk 2077 è uno dei giochi più ambiziosi che abbia mai visto. La libertà di scelta è straordinaria, e il design del mondo è ricco e immersivo. Tuttavia, l'IA dei nemici è sotto le aspettative e alcuni elementi sembrano meno curati. Nonostante tutto, è un'esperienza da provare.", 4.0, 23, 33),
("Night City è incredibile", "Night City è il vero protagonista di Cyberpunk 2077. La città è incredibilmente dettagliata e viva. La trama principale è avvincente, ma alcune missioni secondarie sono ripetitive. Nonostante qualche problema tecnico, il gioco è un'esperienza unica e vale la pena giocarci.", 4.3, 23, 44),
("Un mondo ricco di dettagli", "Cyberpunk 2077 ti trasporta in un mondo ricco di dettagli e pieno di storie da scoprire. Le scelte morali e il design del personaggio aggiungono profondità all'esperienza. Il gameplay è divertente, ma ci sono ancora alcuni bug fastidiosi che rovinano l'immersione.", 4.4, 23, 55),
("Deludente rispetto alle aspettative", "Cyberpunk 2077 è un gioco che ha promesso tanto ma che non ha mantenuto tutte le aspettative. Il mondo di gioco è straordinario, ma i problemi tecnici e alcune meccaniche poco sviluppate lo penalizzano. Con le patch successive è migliorato, ma non è ancora il capolavoro che ci si aspettava.", 3.8, 23, 66),
("Johnny Silverhand è fantastico", "Il personaggio di Johnny Silverhand è uno dei punti forti di Cyberpunk 2077. La storia è avvincente e piena di colpi di scena, e le scelte morali aggiungono profondità. Tuttavia, la mancanza di rifinitura in alcune meccaniche di gioco e i bug iniziali lo rendono un'esperienza mista.", 4.1, 23, 77),
("Un RPG innovativo ma imperfetto", "Cyberpunk 2077 è un RPG che cerca di innovare con il suo mondo aperto e la personalizzazione, ma non è privo di difetti. La grafica è splendida, e la storia è interessante, ma i bug e alcune decisioni di design limitano il potenziale del gioco.", 4.0, 23, 88),
("Un viaggio cyberpunk", "Se ami l'estetica cyberpunk, questo gioco è un sogno che si avvera. Night City è stupenda, e le missioni principali sono emozionanti. Tuttavia, i problemi tecnici possono rovinare l'esperienza, specialmente su hardware meno potente.", 4.3, 23, 99),
("Molto migliorato con le patch", "Al lancio, Cyberpunk 2077 era pieno di problemi, ma con gli aggiornamenti è diventato molto più godibile. La storia è profonda e coinvolgente, e il mondo è ricco di dettagli. Se non lo hai ancora giocato, ora è il momento giusto.", 4.6, 23, 108);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Una sfida continua", "Dark Souls II è un gioco che non perdona. Il gameplay è impegnativo, ma estremamente gratificante. Ogni battaglia ti tiene sul filo del rasoio. Non è perfetto come il primo capitolo, ma rimane una perla per gli amanti delle sfide.", 4.2, 62, 12),
("Atmosfera incredibile", "Il mondo di Dark Souls II è oscuro e misterioso, pieno di segreti e storie da scoprire. La difficoltà è elevata, ma il senso di soddisfazione dopo aver sconfitto un boss è impagabile.", 4.4, 62, 23),
("Non al livello del primo", "Dark Souls II è un ottimo gioco, ma manca della magia e della coesione del primo capitolo. Tuttavia, offre un gameplay solido e una sfida che pochi altri giochi possono eguagliare.", 3.9, 62, 34),
("Un capolavoro di difficoltà", "Se cerchi un gioco che ti metta alla prova, Dark Souls II è perfetto. La varietà dei nemici e dei boss è impressionante, e il level design è ben curato. Alcune aree sono un po' frustranti, ma l'esperienza complessiva è eccellente.", 4.3, 62, 45),
("Ricco di contenuti", "Dark Souls II offre una quantità incredibile di contenuti. La varietà delle armi, delle armature e delle build lo rende un'esperienza rigiocabile. Anche se non è perfetto, è un gioco che ogni appassionato di RPG d'azione dovrebbe provare.", 4.5, 62, 56),
("Un passo indietro rispetto al primo", "Nonostante Dark Souls II sia un buon gioco, alcune scelte di design lo rendono meno memorabile del primo capitolo. Tuttavia, rimane un'esperienza gratificante per chi ama i giochi difficili.", 3.8, 62, 67),
("Boss epici e memorabili", "I boss di Dark Souls II sono alcuni dei migliori della serie. La loro varietà e design sono incredibili. Peccato per alcune aree meno ispirate e per un level design non sempre all'altezza.", 4.0, 62, 78),
("Un mondo oscuro e affascinante", "Dark Souls II crea un'atmosfera unica con il suo mondo oscuro e i suoi personaggi enigmatici. La difficoltà è elevata, ma l'esperienza complessiva è straordinaria.", 4.3, 62, 89),
("Difficile ma giusto", "Dark Souls II è un gioco che ti punisce, ma che ti insegna. Ogni morte è una lezione, e ogni vittoria è una conquista. Anche con i suoi difetti, è uno dei migliori RPG d'azione disponibili.", 4.2, 62, 100),
("Un gioco che ti segna", "Dark Souls II è più di un gioco: è un'esperienza. Ti costringe a migliorarti, a studiare i nemici e a padroneggiare il combattimento. Non è perfetto, ma è indimenticabile.", 4.4, 62, 111);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno epico", "Dark Souls III è un degno successore della serie. Il combattimento è fluido, il design dei livelli è mozzafiato e i boss sono tra i migliori mai creati.", 4.8, 30, 15),
("Perfetta conclusione della saga", "Dark Souls III chiude la trilogia in modo magistrale. Il mix di gameplay veloce e atmosfere cupe è incredibile. Consigliato a tutti i fan.", 4.7, 30, 28),
("Un capolavoro", "Questo gioco prende il meglio dai capitoli precedenti e lo eleva a nuovi livelli. Ogni battaglia e ogni area sono memorabili. Un must per chiunque ami le sfide.", 5.0, 30, 42),
("Picchi di eccellenza", "Alcune aree di Dark Souls III sono tra le migliori della serie. Il gameplay è veloce e preciso, ma alcune zone sembrano meno ispirate rispetto al resto.", 4.4, 30, 57),
("Il miglior gameplay della serie", "Il combattimento in Dark Souls III è il più raffinato della serie. Le armi, le build e le magie offrono un'enorme varietà di possibilità.", 4.9, 30, 64),
("Una gioia e una sofferenza", "Dark Souls III è difficilissimo, ma ti tiene incollato allo schermo. I boss sono epici e ogni vittoria è una soddisfazione unica.", 4.6, 30, 79),
("Atmosfera impeccabile", "Il mondo di Dark Souls III è uno dei più belli mai creati. La colonna sonora, i dettagli visivi e la narrazione criptica lo rendono indimenticabile.", 4.8, 30, 88),
("Un'avventura leggendaria", "Dark Souls III è il gioco che ogni amante degli action RPG dovrebbe provare. È impegnativo, ma ricco di momenti indimenticabili.", 5.0, 30, 95),
("Un'esperienza memorabile", "Ogni area e ogni boss di Dark Souls III sono un'esperienza unica. La difficoltà è ben bilanciata e il gameplay è al top.", 4.7, 30, 102),
("Non per tutti, ma eccellente", "Dark Souls III è brutale e non perdona, ma se riesci a superare le difficoltà, ti offre una delle migliori esperienze di gioco mai create.", 4.6, 30, 117);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'ambientazione mozzafiato", "Days Gone offre un open world ricco di dettagli, con paesaggi splendidi e una natura selvaggia che affascina. La trama è coinvolgente, ma alcune missioni risultano ripetitive.", 4.2, 15, 11),
("Un'avventura emozionante", "La storia di Deacon St. John è piena di momenti toccanti. Il sistema di combattimento e la gestione della moto aggiungono una buona dose di immersione.", 4.5, 15, 22),
("Troppo sottovalutato", "Days Gone merita più riconoscimenti di quelli che ha ricevuto. La narrazione è ben fatta e la varietà di nemici rende il gameplay interessante.", 4.3, 15, 33),
("Un buon open world", "Il mondo di Days Gone è vasto e pieno di attività, ma la ripetitività delle missioni e qualche problema tecnico lo frenano dall'essere un capolavoro.", 3.9, 15, 44),
("Perfetto per gli amanti degli zombie", "La gestione delle orde di zombie è una delle caratteristiche migliori del gioco. Ti tiene costantemente in tensione e rende ogni scontro unico.", 4.4, 15, 55),
("Una trama avvincente", "La storia di Days Gone è uno dei suoi punti di forza. Ti affezioni ai personaggi e vuoi scoprire di più sul loro destino.", 4.6, 15, 66),
("Tecnicamente migliorabile", "Days Gone è un gioco con grandi idee, ma a volte inciampa su problemi tecnici. Nonostante ciò, è un'avventura molto divertente.", 4.0, 15, 77),
("Moto e zombie, cosa vuoi di più?", "La combinazione di azione, sopravvivenza e personalizzazione della moto rende Days Gone unico nel suo genere. Peccato per alcune missioni ripetitive.", 4.2, 15, 88),
("Un gioco sottovalutato", "Days Gone offre un'esperienza coinvolgente, soprattutto grazie al mondo aperto e alla gestione delle risorse. Non è perfetto, ma è molto divertente.", 4.1, 15, 99),
("Un'esperienza unica", "Days Gone mescola una buona storia con un gameplay solido e un'ambientazione spettacolare. La gestione delle orde è una sfida continua.", 4.5, 15, 110);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un rogue-lite perfetto", "Dead Cells combina gameplay frenetico, grafica stupenda e una difficoltà bilanciata. Ogni run è diversa e incredibilmente divertente.", 4.9, 44, 8),
("Adrenalina pura", "Il combattimento è fluido e soddisfacente. Le armi e abilità offrono una varietà incredibile, rendendo ogni partita unica.", 4.8, 44, 17),
("Un'esperienza unica", "Il mix tra platform e rogue-lite è eseguito alla perfezione. Le meccaniche di progressione sono ben studiate.", 4.7, 44, 26),
("Una sfida costante", "Dead Cells ti tiene incollato allo schermo con il suo gameplay impegnativo ma giusto. Il level design è eccellente.", 4.6, 44, 35),
("Arte in movimento", "Lo stile grafico è semplicemente splendido. Ogni dettaglio è curato e contribuisce a creare un'atmosfera unica.", 4.8, 44, 48),
("Gameplay senza paragoni", "Pochi giochi raggiungono la fluidità e il ritmo di Dead Cells. La curva di apprendimento è perfetta.", 5.0, 44, 59),
("Un rogue-lite impegnativo", "La difficoltà potrebbe scoraggiare alcuni giocatori, ma per chi ama le sfide, Dead Cells è un gioiello.", 4.5, 44, 64),
("Rigiocabilità infinita", "Ogni run è diversa grazie alle armi e alle abilità che trovi. Non mi stanco mai di giocare.", 4.9, 44, 72),
("Un capolavoro indie", "Dead Cells mostra quanto i giochi indie possano competere con i grandi titoli. Merita ogni lode.", 5.0, 44, 81),
("Dipendenza pura", "Non riesco a smettere di giocare. Ogni morte ti spinge a migliorare e a riprovare. Un must per gli amanti del genere.", 4.7, 44, 95);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un picchiaduro solido", "Dead or Alive 5 offre combattimenti fluidi e un gameplay tecnico che premia la strategia. Ottima scelta per i fan del genere.", 4.5, 202, 7),
("Divertente e accessibile", "Perfetto per i principianti ma anche profondo per i veterani. Le combo sono spettacolari e intuitive.", 4.6, 202, 14),
("Grande varietà di personaggi", "Il roster è ampio e variegato, permettendo stili di combattimento molto diversi. Gli ambienti interattivi aggiungono profondità.", 4.7, 202, 21),
("Visivamente impressionante", "Le animazioni e la grafica sono fantastiche. Un titolo che mostra la cura nei dettagli.", 4.8, 202, 33),
("Sistema di combattimento raffinato", "Il bilanciamento tra i personaggi è eccellente. La possibilità di interagire con gli scenari è un tocco geniale.", 4.6, 202, 42),
("Ottimo multiplayer", "Il gioco brilla soprattutto nel multiplayer, sia locale che online. Partite sempre intense e competitive.", 4.4, 202, 51),
("Un po' ripetitivo", "Nonostante le ottime meccaniche, alla lunga potrebbe risultare ripetitivo per chi cerca molta varietà.", 4.0, 202, 64),
("Un classico del genere", "Dead or Alive 5 si conferma uno dei migliori picchiaduro, con una giocabilità sempre al top.", 4.5, 202, 78),
("Estremamente fluido", "Le meccaniche di combattimento sono impeccabili, rendendo ogni scontro emozionante. Consigliato agli amanti del genere.", 4.7, 202, 86),
("Richiede abilità", "Non è solo button mashing: il gioco premia chi studia le combo e le meccaniche. Molto soddisfacente.", 4.6, 202, 93);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un degno successore", "Dead or Alive 6 migliora molti aspetti del capitolo precedente, con animazioni più fluide e un sistema di combattimento perfezionato.", 4.7, 155, 5),
("Gameplay sempre eccellente", "Il sistema di combo e le meccaniche avanzate rendono ogni incontro una sfida emozionante. Adatto sia ai principianti che ai veterani.", 4.6, 155, 15),
("Nuovi personaggi interessanti", "L'aggiunta di nuovi personaggi arricchisce il roster, rendendolo ancora più variegato. Gli stili di combattimento sono unici.", 4.8, 155, 25),
("Ambientazioni spettacolari", "Gli scenari interattivi sono ben progettati e aggiungono profondità strategica. Un vero piacere per gli occhi.", 4.7, 155, 32),
("Perfetto per i tornei", "Dead or Alive 6 ha un ottimo bilanciamento e un gameplay competitivo. Ideale per il multiplayer.", 4.5, 155, 48),
("Un po' troppo DLC", "Il gioco base è eccellente, ma la politica sui DLC è un po' eccessiva. Alcuni contenuti dovevano essere inclusi fin dall'inizio.", 3.9, 155, 54),
("Nuove funzionalità gradite", "Le aggiunte al sistema di combattimento, come la barra Break Gauge, portano una ventata di novità senza stravolgere la formula.", 4.6, 155, 69),
("Un titolo imprescindibile", "Dead or Alive 6 è un must per gli appassionati del genere. Un picchiaduro che continua a innovare.", 4.8, 155, 77),
("Esperienza fluida e divertente", "Il gameplay è accessibile ma profondo. Ideale per divertirsi con gli amici o in competitivo.", 4.5, 155, 85),
("Grafica di altissimo livello", "Le animazioni dei personaggi e gli effetti visivi sono incredibili. Il gioco è uno spettacolo visivo.", 4.9, 155, 103);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro horror", "Dead Space 2 è un perfetto mix di azione e horror. La tensione è costante e la storia ti tiene incollato fino alla fine.", 4.9, 177, 3),
("Atmosfera incredibile", "L'ambientazione è spettacolare e claustrofobica. Le sezioni nello spazio sono mozzafiato.", 4.8, 177, 12),
("Un sequel fantastico", "Migliora tutto rispetto al primo capitolo, con gameplay più fluido e una narrazione ancora più coinvolgente.", 4.9, 177, 22),
("Un'esperienza terrificante", "I Necromorfi sono ancora più spaventosi e il design audio ti fa saltare dalla sedia. Consigliatissimo.", 4.7, 177, 30),
("Equilibrio perfetto", "Dead Space 2 riesce a bilanciare momenti di azione con un'atmosfera di pura paura. Un capolavoro.", 5.0, 177, 45),
("Gameplay migliorato", "Le nuove armi e le migliorie al sistema di movimento rendono il gioco più dinamico e divertente.", 4.8, 177, 51),
("Un'esperienza unica", "Il mix tra survival horror e azione è eccezionale. La trama è piena di colpi di scena.", 4.9, 177, 67),
("Un po' meno horror", "Rispetto al primo capitolo, c'è più azione e meno momenti di puro terrore. Rimane comunque eccellente.", 4.5, 177, 73),
("Narrazione eccellente", "La storia di Isaac Clarke è raccontata in modo magistrale, con personaggi ben sviluppati e una trama avvincente.", 4.8, 177, 89),
("Impossibile smettere di giocare", "Ogni momento è carico di tensione. Dead Space 2 è uno dei migliori survival horror mai creati.", 5.0, 177, 104);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Più azione, meno paura", "Dead Space 3 si sposta verso un approccio più action, sacrificando parte dell'atmosfera horror che ha reso unica la serie.", 4.0, 178, 8),
("Co-op divertente", "La modalità cooperativa è una bella aggiunta, anche se riduce un po' la tensione. Giocarlo con un amico è molto divertente.", 4.5, 178, 14),
("Un buon gioco, ma diverso", "Non è il Dead Space che conoscevamo. Rimane un titolo solido, ma manca quel senso di isolamento che caratterizzava i primi capitoli.", 4.2, 178, 23),
("Ambientazioni spettacolari", "Il design dei livelli, soprattutto nelle sezioni spaziali, è incredibile. La grafica è di altissimo livello.", 4.6, 178, 36),
("Sistema di crafting interessante", "La possibilità di creare e personalizzare le armi è un'ottima aggiunta che aumenta la profondità del gameplay.", 4.7, 178, 47),
("Non il migliore della serie", "Il focus sull'azione lo rende meno spaventoso rispetto ai precedenti. Tuttavia, la storia rimane interessante.", 4.0, 178, 55),
("Perfetto per i fan dell'azione", "Se ti piace l'azione più che l'horror, questo capitolo è per te. Gameplay dinamico e frenetico.", 4.4, 178, 68),
("Manca di tensione", "I momenti di puro terrore sono pochi. Un Dead Space più mainstream, ma comunque divertente.", 3.8, 178, 76),
("Trama avvincente", "La storia si espande ulteriormente e offre una conclusione soddisfacente alla trilogia.", 4.5, 178, 84),
("Troppi DLC", "Il gioco di base è buono, ma i contenuti aggiuntivi a pagamento sono un po' troppi. Avrei preferito tutto incluso.", 3.9, 178, 99);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un classico dell'horror", "Dead Space è uno dei giochi horror più iconici mai realizzati. La tensione e il senso di solitudine sono palpabili.", 5.0, 140, 1),
("Paura continua", "Ogni angolo di questo gioco è carico di tensione. I Necromorfi sono spaventosi e ogni suono fa tremare le ossa.", 4.9, 140, 10),
("Horror puro", "La grafica e l'atmosfera sono incredibili, perfette per creare un'esperienza di paura autentica. Un must per gli amanti del genere.", 5.0, 140, 20),
("Capolavoro del survival horror", "La gestione dell'energia, la scarsità di risorse e il design dei mostri rendono questo gioco incredibilmente coinvolgente.", 4.8, 140, 33),
("Gioco troppo spaventoso", "Ottimo gioco, ma troppo spaventoso per me! La tensione è insopportabile, ma comunque una grande esperienza.", 4.7, 140, 45),
("Tensione costante", "Ogni angolo e ogni corridoio sono pieni di paura. Non è solo un gioco horror, ma un'esperienza unica.", 4.9, 140, 50),
("La paura non finisce mai", "Dead Space ti tiene in suspense fino all'ultimo minuto, e il gameplay è ottimo. Ottima trama, ottimi nemici, ottima atmosfera.", 4.8, 140, 60),
("Semplicemente fantastico", "Un'esperienza che segna la storia del genere horror. Nessun gioco come questo ti farà sentire così impotente.", 5.0, 140, 73),
("Non per deboli di cuore", "Il gioco è fantastico, ma la paura che provoca è veramente intensa. Ottimo per chi ama l'adrenalina!", 4.6, 140, 80),
("Un viaggio spaventoso", "Dead Space è l'apice del survival horror. La paura è reale e l'atmosfera è incredibile. Un'esperienza che non si dimentica.", 5.0, 140, 95);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'esperienza unica", "Death Stranding è un gioco che sfida le convenzioni. Non è solo un gioco, è un'esperienza da vivere. La trama è profondamente coinvolgente.", 4.9, 14, 1),
("Un viaggio solitario", "Il gioco ti costringe ad affrontare il mondo da solo. La sensazione di solitudine è unica, ma può risultare anche noiosa dopo un po'.", 4.2, 14, 5),
("Gameplay interessante", "La meccanica di trasportare pacchi può sembrare monotona, ma alla fine ti immerge in un mondo straordinario e unico.", 4.5, 14, 10),
("Troppo lento", "Nonostante il gioco abbia una trama interessante, il ritmo lento e la ripetitività del gameplay mi hanno fatto perdere interesse.", 3.7, 14, 20),
("Grafica mozzafiato", "La qualità visiva di Death Stranding è incredibile. Ogni paesaggio sembra un'opera d'arte. Un vero piacere per gli occhi.", 5.0, 14, 30),
("Il messaggio di Kojima", "Death Stranding è un gioco che parla di connessione umana, e lo fa in un modo mai visto prima. È profondo e riflessivo.", 4.8, 14, 35),
("Gameplay innovativo", "L'idea di un gioco dove la meccanica principale è trasportare oggetti è innovativa. Un mix tra avventura e strategia.", 4.6, 14, 40),
("Troppo lungo", "La storia è interessante, ma il gioco è troppo lungo e diventa ripetitivo. L'esperienza sarebbe stata migliore con un ritmo più veloce.", 3.9, 14, 50),
("Un capolavoro, ma per pochi", "Death Stranding è un capolavoro del design e della narrazione, ma non è per tutti. Devi essere pronto ad affrontare un'esperienza diversa.", 4.7, 14, 60),
("Una nuova forma di gioco", "Kojima ha creato qualcosa di davvero nuovo con Death Stranding. Non è solo un gioco, è una riflessione sul mondo moderno.", 4.8, 14, 70);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno alla gloria", "Diablo IV riporta la serie alle sue radici con un gameplay coinvolgente, nemici epici e un mondo oscuro. Finalmente un ritorno ai vecchi tempi!", 4.9, 31, 1),
("Un gioco affascinante", "La grafica è fantastica, e la storia mi ha davvero coinvolto. Ho passato ore a esplorare il mondo di Sanctuarium.", 5.0, 31, 10),
("Ottimo ma con margini di miglioramento", "Il gioco è fantastico, ma ci sono alcune piccole imperfezioni che potrebbero essere migliorate, soprattutto nella gestione delle risorse.", 4.3, 31, 20),
("Un classico che non delude", "Ogni aspetto di Diablo IV mi ha riportato indietro nel tempo, ma con miglioramenti notevoli. Un must per i fan della serie.", 4.8, 31, 30),
("Diablo non è mai stato così bello", "Le animazioni e la grafica sono sorprendenti, il gameplay è fluido e il sistema di progressione è perfetto. Mi ha catturato fin dal primo minuto.", 5.0, 31, 40),
("Troppo grind", "Il gioco è davvero divertente, ma la componente di grinding per migliorare il proprio personaggio è troppo ripetitiva. Alcuni miglioramenti potrebbero aiutarlo.", 3.8, 31, 50),
("Un gioco avvincente", "Le meccaniche di gioco sono solide, e la narrativa è coinvolgente. Il multiplayer è divertente, ma un po' sbilanciato in alcune fasi del gioco.", 4.6, 31, 60),
("Una nuova era di Diablo", "Il mondo aperto e la libertà di esplorazione sono un grande passo avanti. Diablo IV riesce a unire l'essenza della serie con novità interessanti.", 4.7, 31, 70),
("Diablo per tutti", "Sia i nuovi giocatori che i fan di vecchia data si troveranno a casa con Diablo IV. Un'esperienza completa che non delude, ma ci sono alcune zone grigie.", 4.4, 31, 80),
("Ottimo ma con troppi bug", "Il gioco è veramente divertente, ma ci sono alcuni bug fastidiosi che influenzano l'esperienza. Spero che vengano risolti presto.", 4.1, 31, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Una corsa emozionante", "DiRT 3 è un gioco di corse divertente con una buona varietà di tracciati e modalità. Ottima fisica di guida!", 4.8, 200, 1),
("Gran divertimento in pista", "Le gare sono rapide e frenetiche, ma la fisica di guida è ben bilanciata. Ottimo per chi cerca un'esperienza arcade.", 4.7, 200, 10),
("Non solo corse", "Il gioco offre una varietà di modalità, ma la modalità Gymkhana è una delle mie preferite. Mi fa davvero divertire.", 4.9, 200, 20),
("Una corsa spettacolare", "I tracciati sono ben progettati e la varietà di auto è davvero ampia. Un gioco che riesce a essere sia arcade che realista.", 5.0, 200, 30),
("Un gioco per tutti", "DiRT 3 è facile da giocare per i principianti, ma offre anche una buona sfida per i giocatori esperti. La modalità multiplayer è un'aggiunta fantastica.", 4.6, 200, 40),
("Le gare sono intense", "Il gioco offre un'esperienza di corse intensa, ma la difficoltà aumenta un po' troppo in fretta. A volte diventa frustrante.", 4.2, 200, 50),
("Divertente ma non perfetto", "Le corse sono molto divertenti, ma la AI degli avversari può sembrare un po' troppo prevedibile. Alcuni miglioramenti nelle gare single-player sarebbero utili.", 4.3, 200, 60),
("Un must per gli amanti delle corse", "La varietà di auto e tracciati è impressionante. DiRT 3 è un gioco che saprà accontentare sia i fan delle corse arcade che quelli più realisti.", 4.8, 200, 70),
("Musica fantastica", "La colonna sonora è davvero eccezionale. Ogni gara sembra ancora più eccitante con il giusto sottofondo musicale.", 5.0, 200, 80),
("Divertimento senza fine", "DiRT 3 riesce a bilanciare perfettamente l'accessibilità e la profondità. Ti troverai a giocare ore senza mai annoiarti.", 4.7, 200, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un passo avanti rispetto a DiRT 3", "DiRT 4 migliora molte delle meccaniche di guida del suo predecessore. Le gare sono più fluide e la varietà di tracciati è ancora maggiore.", 4.8, 201, 1),
("Divertimento assicurato", "Le modalità di gioco sono molteplici e ognuna ha il suo fascino. La personalizzazione delle auto è un'altra grande aggiunta.", 4.7, 201, 10),
("Un'esperienza più realistica", "La fisica di guida è migliorata, e si nota. L'esperienza di guida è più gratificante e realistica rispetto a DiRT 3.", 4.9, 201, 20),
("Per i veri amanti delle corse", "La difficoltà del gioco è un po' più alta rispetto al precedente, ma questo lo rende più soddisfacente da giocare per i veri appassionati di corse.", 4.6, 201, 30),
("Ottima varietà di modalità", "Il gioco offre una gamma di modalità che tengono il gioco fresco e interessante. La modalità Career è davvero coinvolgente.", 4.8, 201, 40),
("Migliorato ma non perfetto", "DiRT 4 è sicuramente un miglioramento rispetto a DiRT 3, ma la modalità multiplayer è ancora un po' problematica, con troppi lag in alcune sessioni.", 4.3, 201, 50),
("Più simulazione, meno arcade", "Il gioco è meno arcade rispetto al suo predecessore e offre una simulazione più profonda. Alcuni potrebbero trovarlo un po' troppo tecnico, ma per me è un vantaggio.", 4.7, 201, 60),
("Grafica spettacolare", "La grafica di DiRT 4 è impressionante, con ambientazioni mozzafiato e modelli di auto dettagliati. Ogni gara è visivamente spettacolare.", 5.0, 201, 70),
("Un gioco per tutti i livelli", "Che tu sia un principiante o un esperto di corse, DiRT 4 ha qualcosa da offrire. Il sistema di difficoltà permette a tutti di divertirsi.", 4.5, 201, 80),
("Un capolavoro di corse", "Non è solo un gioco di corse, è un'esperienza che ti porta a superare te stesso in ogni gara. Uno dei migliori giochi di corse degli ultimi anni.", 5.0, 201, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno al divertimento arcade", "DiRT 5 è un gioco di corse che punta più sul divertimento immediato e l'azione piuttosto che sulla simulazione. Ottimo per chi cerca una corsa spensierata.", 4.6, 88, 1),
("Corsa adrenalinica", "Le gare sono rapide e intense, e la varietà di ambientazioni è davvero impressionante. Nonostante manchi di una simulazione profonda, è molto divertente da giocare.", 4.7, 88, 10),
("Il miglior DiRT per divertirsi", "La fisica di guida è un po' più arcade rispetto a DiRT 4, ma la sensazione di velocità e l'adrenalina sono ottimi. Le modalità multiplayer sono davvero coinvolgenti.", 4.8, 88, 20),
("Grafica mozzafiato", "Le ambientazioni sono spettacolari, con tracciati su terreni difficili e in ambienti esotici. La grafica di DiRT 5 è senza dubbio tra le migliori della serie.", 5.0, 88, 30),
("La modalità carriera è divertente", "La modalità carriera è ricca di sfide e competizioni che mantengono alta la motivazione. Ogni gara è una nuova avventura.", 4.5, 88, 40),
("Corsa arcade con il cuore", "Se ti piacciono le corse più casual, DiRT 5 è perfetto per te. Non è un simulatore, ma riesce a divertire e a farti sentire il brivido delle corse.", 4.6, 88, 50),
("Ottimo per il multiplayer", "Il gioco è fantastico per giocare in compagnia. Le modalità multiplayer sono veloci, frenetiche e facili da imparare. Una scelta perfetta per le sessioni di gioco con gli amici.", 4.7, 88, 60),
("Meno tecnica, più spettacolare", "A differenza di DiRT 4, questo gioco punta molto più sullo spettacolo e sulla velocità. Perfetto per chi cerca adrenalina piuttosto che un'esperienza realistica.", 4.4, 88, 70),
("La sensazione di velocità è incredibile", "La sensazione di velocità è davvero ben riprodotta. Quando sei in gara, ti senti davvero immerso nell'azione, e la fisica di guida è divertente anche se non perfetta.", 4.9, 88, 80),
("Divertimento senza pensieri", "DiRT 5 è un gioco che ti permette di staccare la mente e goderti semplicemente le corse. Perfetto per chi cerca un'esperienza di gioco senza troppi pensieri.", 4.6, 88, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro narrativo", "Disco Elysium: The Final Cut è un viaggio coinvolgente nella mente di un detective, con una trama ricca e profondamente scritta. Ogni decisione ha un peso e il mondo di gioco è straordinario.", 5.0, 42, 1),
("Un gioco che sfida la mente", "La profondità dei personaggi e delle scelte narrative rende questo gioco un'esperienza unica. La libertà di esplorare e decidere come affrontare ogni situazione è un punto di forza.", 4.9, 42, 10),
("Una storia indimenticabile", "La trama è così ben costruita che ti tiene incollato al gioco per ore. Le scelte che fai influenzano profondamente il corso degli eventi, rendendo ogni partita unica.", 5.0, 42, 20),
("Personaggi memorabili", "I personaggi di Disco Elysium sono incredibilmente ben scritti e complessi. Il gioco ti permette di entrare nelle loro menti e di scoprire le loro storie in un modo che pochi giochi riescono a fare.", 4.8, 42, 30),
("Un mix di RPG e investigazione", "Il gioco è un mix perfetto di investigazione, dialoghi e scelte morali. Ogni dialogo è ricco di opzioni e la possibilità di sviluppare il personaggio in vari modi aggiunge un livello di profondità in più.", 4.7, 42, 40),
("Grafica unica", "La grafica stilizzata di Disco Elysium è affascinante. Sebbene non sia un gioco tradizionale in termini visivi, il suo stile artistico è perfetto per il tipo di storia che racconta.", 4.6, 42, 50),
("Un'esperienza di gioco ineguagliabile", "Non è solo un gioco, è un'esperienza che ti fa riflettere. La profondità dei temi trattati, come la politica, la psiche umana e la moralità, è rara nel mondo dei videogiochi.", 5.0, 42, 60),
("Il miglior gioco di ruolo che abbia mai giocato", "Disco Elysium è una delle migliori esperienze di gioco di ruolo che abbia mai vissuto. La libertà di scelta e l'intensità della narrazione sono fuori dal comune.", 5.0, 42, 70),
("Un titolo da giocare con calma", "Disco Elysium non è un gioco da fare in fretta. Va giocato con calma, prendendosi il tempo di esplorare e riflettere su ogni scelta. Ogni momento ha un significato.", 4.9, 42, 80),
("Un viaggio psicologico", "Questo gioco è un vero e proprio viaggio psicologico. Ti costringe a confrontarti con le tue scelte morali e a riflettere su chi sei. È un'esperienza unica che consiglio a tutti.", 4.8, 42, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro narrativo", "Disco Elysium: The Final Cut è un viaggio coinvolgente nella mente di un detective, con una trama ricca e profondamente scritta. Ogni decisione ha un peso e il mondo di gioco è straordinario.", 5.0, 42, 1),
("Un gioco che sfida la mente", "La profondità dei personaggi e delle scelte narrative rende questo gioco un'esperienza unica. La libertà di esplorare e decidere come affrontare ogni situazione è un punto di forza.", 4.9, 42, 10),
("Una storia indimenticabile", "La trama è così ben costruita che ti tiene incollato al gioco per ore. Le scelte che fai influenzano profondamente il corso degli eventi, rendendo ogni partita unica.", 5.0, 42, 20),
("Personaggi memorabili", "I personaggi di Disco Elysium sono incredibilmente ben scritti e complessi. Il gioco ti permette di entrare nelle loro menti e di scoprire le loro storie in un modo che pochi giochi riescono a fare.", 4.8, 42, 30),
("Un mix di RPG e investigazione", "Il gioco è un mix perfetto di investigazione, dialoghi e scelte morali. Ogni dialogo è ricco di opzioni e la possibilità di sviluppare il personaggio in vari modi aggiunge un livello di profondità in più.", 4.7, 42, 40),
("Grafica unica", "La grafica stilizzata di Disco Elysium è affascinante. Sebbene non sia un gioco tradizionale in termini visivi, il suo stile artistico è perfetto per il tipo di storia che racconta.", 4.6, 42, 50),
("Un'esperienza di gioco ineguagliabile", "Non è solo un gioco, è un'esperienza che ti fa riflettere. La profondità dei temi trattati, come la politica, la psiche umana e la moralità, è rara nel mondo dei videogiochi.", 5.0, 42, 60),
("Il miglior gioco di ruolo che abbia mai giocato", "Disco Elysium è una delle migliori esperienze di gioco di ruolo che abbia mai vissuto. La libertà di scelta e l'intensità della narrazione sono fuori dal comune.", 5.0, 42, 70),
("Un titolo da giocare con calma", "Disco Elysium non è un gioco da fare in fretta. Va giocato con calma, prendendosi il tempo di esplorare e riflettere su ogni scelta. Ogni momento ha un significato.", 4.9, 42, 80),
("Un viaggio psicologico", "Questo gioco è un vero e proprio viaggio psicologico. Ti costringe a confrontarti con le tue scelte morali e a riflettere su chi sei. È un'esperienza unica che consiglio a tutti.", 4.8, 42, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro RPG", "Divinity: Original Sin 2 è uno dei migliori giochi di ruolo mai realizzati. La libertà di scelta, il combattimento a turni strategico e la trama coinvolgente lo rendono un'esperienza indimenticabile.", 5.0, 54, 1),
("La perfezione del combat system", "Il sistema di combattimento è semplicemente fantastico, con una profondità strategica che ti permette di affrontare ogni battaglia in modo unico. Ogni personaggio ha abilità che ti fanno pensare attentamente a ogni mossa.", 4.9, 54, 10),
("Un mondo ricco di dettagli", "Il mondo di gioco è incredibilmente ricco e variegato. Ogni area è piena di segreti da scoprire e personaggi interessanti da incontrare. La narrazione è ben scritta e ti tiene sempre coinvolto.", 5.0, 54, 20),
("Gioco di ruolo da non perdere", "Le scelte morali che fai nel gioco hanno un impatto reale sulla trama, il che lo rende altamente rigiocabile. Ogni scelta ti fa sentire come se stessi davvero influenzando il mondo che ti circonda.", 5.0, 54, 30),
("Un gioco con una trama incredibile", "La storia di Divinity: Original Sin 2 è avvincente e ricca di colpi di scena. Ogni missione principale e secondaria è ben scritta e coinvolgente, e le relazioni con i compagni di viaggio sono profondamente esplorate.", 4.8, 54, 40),
("Cooperativo fantastico", "Giocare in cooperativa con amici è un'esperienza fantastica. Le battaglie a turni diventano molto più divertenti quando ognuno può dare il proprio contributo strategico. È uno dei migliori giochi cooperativi che abbia mai giocato.", 5.0, 54, 50),
("Ogni personaggio ha una storia unica", "Ogni compagno ha una storia interessante e complessa che si sviluppa durante il gioco. È incredibile come i personaggi interagiscano con il mondo e come le loro storie influenzino la trama principale.", 4.9, 54, 60),
("Il miglior RPG recente", "Divinity: Original Sin 2 ha portato il genere RPG a un nuovo livello. La combinazione di esplorazione, narrazione e combattimento a turni è eseguita perfettamente. Un gioco che ti fa sentire come se stessi vivendo una vera avventura.", 5.0, 54, 70),
("Un'esperienza di gioco unica", "Il gioco è pieno di scelte difficili e combattimenti strategici che richiedono pensiero e pianificazione. L'introduzione della magia e degli elementi ambientali rende ogni battaglia diversa e divertente.", 4.8, 54, 80),
("Indimenticabile", "Divinity: Original Sin 2 è un gioco che rimarrà con te anche dopo averlo finito. Le opzioni di dialogo, le scelte morali e la varietà dei personaggi creano un'esperienza che ogni appassionato di giochi di ruolo dovrebbe provare.", 5.0, 54, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un platform perfetto", "Donkey Kong Country: Tropical Freeze è un platform incredibile. Il design dei livelli è brillante e la difficoltà è ben calibrata, rendendo ogni partita emozionante e coinvolgente.", 5.0, 116, 1),
("Divertimento puro", "Il gameplay è fluido, le animazioni sono fantastiche, e la colonna sonora è fantastica. Un platform che riesce a mantenere il suo fascino senza mai annoiare. Perfetto per i fan dei giochi retrò!", 4.8, 116, 10),
("Un ritorno al passato", "Tropical Freeze porta il meglio della serie Donkey Kong in un formato moderno. La grafica è splendida, la musica è fantastica e le meccaniche di gioco sono perfette. Un vero classico.", 5.0, 116, 20),
("Difficile ma gratificante", "Il gioco è sicuramente impegnativo, ma ogni volta che completi un livello o una sequenza difficile, la soddisfazione è enorme. Un platform impegnativo ma giusto.", 4.9, 116, 30),
("Un gioco che non delude mai", "Donkey Kong Country: Tropical Freeze è un gioco che offre sempre qualcosa di nuovo, con livelli e nemici vari e un gameplay che rimane sempre fresco. Non stanca mai e continua a sorprendere.", 5.0, 116, 40),
("Piattaforme perfette", "La varietà dei livelli è fantastica. Ogni livello è progettato in modo unico, con ostacoli, nemici e segreti che lo rendono interessante da esplorare. Ogni volta che giochi, trovi qualcosa di nuovo.", 4.8, 116, 50),
("Un platform di qualità", "Tropical Freeze non è solo un gioco per fan di Donkey Kong, ma per chiunque ami i platform. La precisione nei controlli e la varietà dei poteri di Donkey Kong rendono ogni livello divertente e dinamico.", 5.0, 116, 60),
("Incredibile come sempre", "Le animazioni sono spettacolari, e l'introduzione dei nuovi personaggi rende il gioco ancora più interessante. Donkey Kong Country è sempre una garanzia di qualità e Tropical Freeze non fa eccezione.", 4.9, 116, 70),
("Divertente e impegnativo", "Tropical Freeze è un gioco che sfida ma che premia i giocatori con livelli pieni di azione, velocità e puzzle. È un gioco che ti fa sorridere ogni volta che riesci a completare un livello difficile.", 5.0, 116, 80),
("Un classico dei platform", "Tropical Freeze è uno dei migliori giochi platform della sua generazione. La combinazione di design dei livelli, difficoltà, e divertimento rende questo gioco un must-have per tutti gli appassionati del genere.", 5.0, 116, 90);



INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un classico intramontabile", "DOOM è uno dei giochi che ha definito il genere degli sparatutto in prima persona. La sua velocità, l'intensità dei combattimenti e l'atmosfera unica lo rendono un'esperienza senza pari.", 5.0, 181, 1),
("Sparatutto puro", "Un gioco che non perde mai la sua intensità. I combattimenti sono frenetici e ogni mossa deve essere veloce. La colonna sonora metal e l'ambientazione infernale rendono ogni scontro epico.", 5.0, 181, 10),
("Un gameplay adrenalinico", "DOOM è un gioco che non smette mai di sorprendere. La velocità del gioco è incredibile e l'azione non si ferma mai. Se vuoi un'esperienza di gioco pura e adrenalinica, DOOM è perfetto.", 4.9, 181, 20),
("Un capolavoro del genere FPS", "L'approccio alla velocità e all'azione in DOOM è senza pari. I livelli sono progettati per massimizzare l'intensità degli scontri, e la trama semplice ma efficace non rallenta mai il ritmo.", 5.0, 181, 30),
("Un gioco che ti mette alla prova", "DOOM non è solo un gioco che si gioca, è un gioco che ti sfida costantemente. Con i suoi combattimenti frenetici e le armi potenti, ogni livello ti mette alla prova e ti premia per la tua velocità.", 4.8, 181, 40),
("Non solo un gioco, un'esperienza", "DOOM è un'esperienza che non puoi descrivere, devi viverla. Il mix tra azione frenetica, grafica spettacolare e colonna sonora heavy metal crea un'atmosfera unica che ti coinvolge completamente.", 5.0, 181, 50),
("Velocità e potenza", "L'essenza di DOOM è nella velocità con cui puoi affrontare i nemici, ma anche nella potenza delle armi che hai a disposizione. Ogni nemico che abbatti ti dà una sensazione di grande potere.", 5.0, 181, 60),
("Una vera rivoluzione nel suo tempo", "DOOM ha segnato una vera rivoluzione per gli sparatutto in prima persona. Con il suo movimento veloce, i combattimenti frenetici e l'innovativa grafica, è uno dei giochi che ha cambiato il panorama videoludico.", 5.0, 181, 70),
("Ritmo inarrestabile", "In DOOM non c'è mai un momento di tranquillità. Il ritmo è costantemente accelerato, e ogni livello ti fa sentire parte di un'avventura che non si ferma mai. La sensazione di velocità è unica.", 4.9, 181, 80),
("Energie pure", "DOOM è energia pura. Difficilmente troverai un gioco che riesca a tenere il passo in termini di intensità. Un must per chi ama i giochi FPS e vuole immergersi in un'avventura adrenalinica.", 5.0, 181, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un DOOM più oscuro", "DOOM 3 è un'esperienza completamente diversa rispetto ai suoi predecessori. Più atmosferico e horror, è un gioco che riesce a combinare azione e paura in modo unico, con una grafica che all'epoca era incredibile.", 4.9, 182, 1),
("Paura e adrenalina", "Il gioco porta la serie DOOM in una direzione più oscura e inquietante. I nemici sono terrificanti e l'atmosfera è tesa, mentre le meccaniche di combattimento mantengono alta l'adrenalina. Un mix perfetto di paura e azione.", 4.8, 182, 10),
("Atmosfera coinvolgente", "DOOM 3 è riuscito a creare un'atmosfera unica di paura e suspense. La grafica, anche se datata, è stata utilizzata in modo magistrale per creare un ambiente veramente inquietante e coinvolgente.", 4.7, 182, 20),
("Un cambio di tono riuscito", "Rispetto ai giochi precedenti, DOOM 3 è molto più focalizzato sul lato horror. La tensione che si costruisce mentre esplori l'oscura base lunare è palpabile. Sebbene manchi la stessa frenesia, il gioco ha un suo fascino.", 4.6, 182, 30),
("Un capolavoro per gli amanti dell'horror", "DOOM 3 riesce a mescolare elementi di sparatutto e horror in modo che pochi giochi riescano a fare. Le ambientazioni claustrofobiche e i nemici che emergono dalle ombre creano un'esperienza davvero spaventosa.", 5.0, 182, 40),
("Un cambio di ritmo interessante", "A differenza dei suoi predecessori, DOOM 3 si concentra di più sull'atmosfera e sull'esplorazione. Non è frenetico come gli altri DOOM, ma riesce a mantenere l'attenzione grazie alla sua eccellente grafica e suspense.", 4.7, 182, 50),
("L'orrore in un FPS", "DOOM 3 ha portato la serie a un livello completamente nuovo, con un forte accento sull'orrore psicologico. La qualità grafica è straordinaria e le sezioni di gioco piene di oscurità e sorprese spaventose ti tengono sempre all'erta.", 5.0, 182, 60),
("Intenso ma inquietante", "Il gioco non è per tutti, ma se ti piace l'horror e i giochi con un'atmosfera tesa, DOOM 3 è perfetto. La gestione della luce e dell'oscurità è magistrale e crea una sensazione costante di paura.", 4.8, 182, 70),
("Ottima grafica per l'epoca", "La grafica di DOOM 3 era davvero impressionante per il periodo in cui è uscito. Le luci, le ombre e i dettagli degli ambienti sono davvero ben curati, contribuendo enormemente all'atmosfera inquietante del gioco.", 4.9, 182, 80),
("Un DOOM diverso", "Se cercavi un gioco d'azione sfrenata come gli altri DOOM, potresti rimanere deluso. Ma se sei un fan degli horror psicologici, DOOM 3 ti offre un'esperienza intensa e unica. La suspense è insostenibile.", 4.6, 182, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Il ritorno di un classico", "DOOM Eternal porta la serie a un nuovo livello. Più veloce, più frenetico, con nuove armi e abilità. Un vero capolavoro per chi ama l'azione sfrenata e il gameplay ad alta intensità.", 5.0, 180, 1),
("Un'azione senza sosta", "DOOM Eternal è la quintessenza dell'azione FPS. I combattimenti sono velocissimi, le armi sono potenti e ogni livello è un'opportunità per distruggere nemici in modi spettacolari. Un'esperienza adrenalinica dal principio alla fine.", 5.0, 180, 10),
("Un capolavoro ad alta velocità", "La velocità e la fluidità del gameplay sono incredibili. Le armi e le nuove meccaniche come il rampino aggiungono una profondità tattica che non esisteva nei precedenti capitoli. DOOM Eternal è la definizione di un FPS moderno.", 5.0, 180, 20),
("Pura adrenalina", "Non c'è mai un momento di calma in DOOM Eternal. La velocità dei combattimenti e la varietà di nemici rendono ogni scontro qualcosa di epico. La sensazione di potenza mentre si abbattono i nemici è indescrivibile.", 5.0, 180, 30),
("La miglior esperienza DOOM", "DOOM Eternal ha perfezionato il suo predecessore, aumentando la velocità, la varietà delle armi e la fluidità dei movimenti. Ogni scontro è emozionante e il gioco ti lascia sempre con la voglia di più.", 5.0, 180, 40),
("Frenesia e precisione", "Il gioco mantiene la sua frenesia ma aggiunge una precisione nelle meccaniche che lo rende ancora più coinvolgente. Non basta premere il grilletto, bisogna essere veloci e astuti per sfruttare ogni abilità al massimo.", 5.0, 180, 50),
("Non solo un FPS", "DOOM Eternal non è solo un gioco d'azione, è un balletto di distruzione e velocità. Ogni mossa è essenziale per sopravvivere, ed è incredibile come il gioco riesca a combinare azione pura con una strategia leggera.", 5.0, 180, 60),
("Un'esperienza unica", "Ogni missione in DOOM Eternal è un tour de force di combattimenti, salti e puzzle. Le ambientazioni sono magnifiche, e la colonna sonora, sempre metal, ti spinge a dare il massimo in ogni scontro.", 4.9, 180, 70),
("Esplosivo e potente", "Le meccaniche di combattimento sono fluide, potenti e stimolanti. DOOM Eternal ti mette costantemente alla prova, ma la soddisfazione di abbattere un nemico con una delle sue armi è impareggiabile.", 5.0, 180, 80),
("Un FPS che non delude mai", "DOOM Eternal ti spinge al limite, ma non è mai frustrante. Ogni livello è una sequenza di azione continua che ti cattura fin dal primo momento. Un gioco imperdibile per gli amanti dell'FPS.", 5.0, 180, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'epica avventura fantasy", "Dragon Age: Inquisition è un gioco che cattura l'essenza delle storie fantasy epiche. Con una trama avvincente, mondi vasti da esplorare e un sistema di combattimento interessante, è uno dei migliori giochi di ruolo degli ultimi anni.", 4.9, 53, 1),
("Un mondo ricco di dettagli", "Il gioco ti offre una storia emozionante e complessa, ma ciò che lo rende speciale sono le sue ambientazioni. Ogni luogo che esplori è ricco di dettagli, e le decisioni che prendi hanno un impatto tangibile sul mondo intorno a te.", 5.0, 53, 10),
("Combattimenti e scelte morali", "Dragon Age: Inquisition è un gioco che ti mette di fronte a scelte difficili. Ogni missione ti sfida moralmente e la personalizzazione del tuo personaggio ti consente di adattarlo al tuo stile di gioco.", 4.8, 53, 20),
("Un RPG che non delude", "La qualità della trama e del gameplay in Dragon Age: Inquisition è impressionante. Con un sistema di combattimento che premia la strategia e personaggi ben scritti, il gioco è perfetto per chi cerca un RPG profondo e ricco di contenuti.", 4.9, 53, 30),
("Immersione totale", "L'atmosfera di Dragon Age: Inquisition è incredibile. Le fazioni, i paesaggi e la trama sono ben costruiti, e la sensazione di essere parte di un mondo vivente è una delle caratteristiche più affascinanti del gioco.", 5.0, 53, 40),
("Un capolavoro del fantasy", "Dragon Age: Inquisition unisce ottimi combattimenti, una trama interessante e personaggi memorabili. Ogni decisione che prendi ha peso e influenza sul mondo e sulle persone che incontrerai.", 4.9, 53, 50),
("La saga continua", "Come terzo capitolo della saga, Dragon Age: Inquisition mantiene alta la qualità e l'emozione. La sua storia è coinvolgente e le missioni principali e secondarie sono tutte ben bilanciate.", 4.8, 53, 60),
("Un gioco che ti fa riflettere", "Le scelte morali che ti vengono proposte in Dragon Age: Inquisition non sono mai facili. Il gioco ti fa riflettere su ciò che è giusto e sbagliato, rendendo ogni decisione più significativa.", 4.9, 53, 70),
("Un RPG perfetto", "Dragon Age: Inquisition è un gioco che soddisfa ogni appassionato di RPG. Le sue missioni sono avvincenti, il sistema di progressione è ben realizzato e la storia ti tiene incollato allo schermo fino alla fine.", 5.0, 53, 80),
("Un viaggio epico", "Il viaggio che intraprendi in Dragon Age: Inquisition è straordinario. Con una trama coinvolgente e un mondo ricco di dettagli, è un gioco che ogni appassionato di RPG dovrebbe provare.", 4.9, 53, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Combattimento spettacolare", "Dragon Ball FighterZ è un gioco che porta l'esperienza di combattimento di Dragon Ball a nuovi livelli. Con grafica straordinaria e un gameplay che mette alla prova le tue abilità, è il sogno di ogni fan della saga.", 5.0, 151, 1),
("Un gioco che fa volare il cuore", "Con il suo stile grafico che ricorda l'animazione originale e la fluidità dei combattimenti, Dragon Ball FighterZ è uno dei migliori picchiaduro degli ultimi anni. Ogni scontro è emozionante e spettacolare.", 5.0, 151, 10),
("Perfetto per i fan di Dragon Ball", "Questo gioco è un omaggio perfetto per i fan di Dragon Ball. I personaggi sono ben curati, i combattimenti sono frenetici e soddisfacenti, e la possibilità di fare mosse spettacolari ti fa sentire come se fossi davvero nell'anime.", 5.0, 151, 20),
("Grafica incredibile e gameplay fluido", "Dragon Ball FighterZ è un picchiaduro incredibile con una grafica che sembra uscita direttamente dall'anime. Il gameplay è fluido e coinvolgente, e le combo sono spettacolari.", 4.9, 151, 30),
("Battaglie mozzafiato", "Ogni combattimento in Dragon Ball FighterZ è un viaggio emozionante. Le mosse speciali, gli attacchi combinati e la grafica 2D curata al dettaglio ti fanno vivere ogni battaglia come se fosse un episodio dell'anime.", 5.0, 151, 40),
("Divertimento puro", "Dragon Ball FighterZ è divertente da giocare, con un sistema di combattimento che premia i riflessi e la strategia. Le animazioni sono spettacolari e ogni mossa sembra realizzata con grande cura.", 5.0, 151, 50),
("Un combattimento che non stanca mai", "Non importa quante volte giochi, Dragon Ball FighterZ è sempre emozionante. La varietà di personaggi e la qualità dei combattimenti mantengono l'esperienza fresca e divertente ogni volta che ci giochi.", 4.9, 151, 60),
("Frenesia e spettacolo", "Le battaglie in Dragon Ball FighterZ sono piene di azione e spettacolari da guardare. La possibilità di combinare mosse e strategie rende ogni partita unica e appassionante.", 5.0, 151, 70),
("Un must per i fan dei picchiaduro", "Dragon Ball FighterZ è uno dei migliori giochi di combattimento degli ultimi anni. La sua grafica e il sistema di gioco sono perfetti per chi ama i picchiaduro veloci e spettacolari.", 4.8, 151, 80),
("Il miglior gioco di Dragon Ball", "Questo è senza dubbio il miglior gioco di Dragon Ball mai creato. Il gameplay è fantastico, la grafica è eccezionale e i fan della serie troveranno sicuramente il loro personaggio preferito.", 5.0, 151, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un classico RPG moderno", "Dragon Quest XI S è un gioco che cattura perfettamente lo spirito dei giochi di ruolo classici. La storia è coinvolgente, i personaggi sono ben scritti e il mondo è vasto e ricco di avventure. Un must per ogni appassionato del genere.", 5.0, 63, 1),
("Un'esperienza indimenticabile", "Questo gioco è una delle migliori esperienze RPG degli ultimi anni. La trama è emozionante, la grafica è splendida e le meccaniche di combattimento sono semplici ma profonde. È un vero gioiello del genere JRPG.", 5.0, 63, 10),
("Un'avventura epica", "Con una storia che ti tiene incollato, Dragon Quest XI S è un'avventura epica che ti farà vivere momenti indimenticabili. La profondità dei personaggi e delle missioni è straordinaria.", 4.9, 63, 20),
("Il miglior Dragon Quest di sempre", "Questo capitolo della saga di Dragon Quest è senza dubbio uno dei migliori. Con una trama avvincente, combattimenti strategici e un mondo magnificamente realizzato, è un gioco che ogni fan dei JRPG dovrebbe giocare.", 5.0, 63, 30),
("Magia e avventura", "La combinazione di magia, combattimenti e avventura in Dragon Quest XI S è perfetta. Ogni zona da esplorare è affascinante, e la personalizzazione dei personaggi è un'altra delle caratteristiche che rende il gioco speciale.", 5.0, 63, 40),
("Un JRPG che non delude", "Dragon Quest XI S è un RPG classico ma con una modernizzazione che lo rende fruibile anche a chi non ha mai giocato ai capitoli precedenti. La trama è ricca di emozioni e i combattimenti sono sempre interessanti.", 4.8, 63, 50),
("Un mondo che ti affascina", "Ogni angolo di Dragon Quest XI S è ricco di dettagli, dai paesaggi incantevoli ai personaggi affascinanti. La storia ti cattura dal primo momento, e le meccaniche di gioco sono semplici ma gratificanti.", 4.9, 63, 60),
("Una gemma nel mondo degli RPG", "Con una trama coinvolgente, mondi da esplorare e combattimenti strategici, Dragon Quest XI S è uno dei migliori RPG in circolazione. Le opzioni di personalizzazione dei personaggi sono ottime e l'atmosfera del gioco è unica.", 5.0, 63, 70),
("Un JRPG che ti fa sognare", "Dragon Quest XI S è un gioco che ti fa sentire parte di un mondo fantasy ricco di magia e avventura. Ogni area da esplorare è affascinante, e le battaglie sono soddisfacenti e ben bilanciate.", 5.0, 63, 80),
("Il ritorno di una saga leggendaria", "Dragon Quest XI S è un ritorno trionfale per una delle saghe più amate del genere. La sua trama, i personaggi e il gameplay sono semplicemente perfetti per gli appassionati di RPG.", 4.9, 63, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco incredibile e complesso", "Dwarf Fortress è uno dei giochi più complessi e affascinanti mai creati. La generazione procedurale e la libertà di creazione offrono infinite possibilità, e ogni partita è unica. Un gioco che richiede tempo ma premia l'ingegno.", 5.0, 77, 1),
("Un'esperienza unica", "Dwarf Fortress è un gioco che mescola gestione, simulazione e avventura in un modo unico. La sua complessità è sia un punto di forza che una barriera per i nuovi giocatori, ma per chi è disposto a imparare, è un'esperienza incredibile.", 5.0, 77, 10),
("Un capolavoro della simulazione", "La simulazione di Dwarf Fortress è una delle più complesse mai create. Ogni decisione che prendi ha un impatto significativo sulla tua colonia e sul mondo che ti circonda. Un gioco che premia la pianificazione e la strategia.", 4.9, 77, 20),
("Un gioco per menti strategiche", "Dwarf Fortress non è un gioco facile, ma per chi ama le sfide è un'esperienza senza pari. La profondità della simulazione e le possibilità di personalizzazione sono fenomenali.", 5.0, 77, 30),
("Complessità infinita", "Dwarf Fortress è un gioco che ti cattura con la sua complessità infinita. Ogni partita è diversa, e ogni scelta che fai può avere enormi conseguenze. È un gioco che ti fa pensare e riflettere su ogni mossa.", 4.9, 77, 40),
("Un gioco che non smette mai di stupire", "Ogni volta che pensi di aver capito tutto in Dwarf Fortress, il gioco ti sorprende con qualcosa di nuovo. La sua capacità di simulare un intero mondo in dettaglio è incredibile, e ogni partita è un'avventura unica.", 5.0, 77, 50),
("Per i veri amanti della simulazione", "Dwarf Fortress è per chi ama la simulazione dettagliata e la gestione complessa. La curva di apprendimento è ripida, ma una volta che inizi a comprenderlo, è difficile smettere di giocare.", 4.8, 77, 60),
("Un gioco di pazienza e strategia", "Dwarf Fortress richiede pazienza e una buona dose di strategia. La gestione della tua colonia e le dinamiche del gioco sono così dettagliate che ogni errore può costarti caro, ma quando riesci a far prosperare la tua colonia, è estremamente soddisfacente.", 5.0, 77, 70),
("Un vero test per la mente", "Dwarf Fortress è un gioco che mette alla prova la tua capacità di pensare strategicamente. Ogni partita è una sfida, e devi essere pronto a improvvisare quando le cose non vanno come previsto.", 4.9, 77, 80),
("Un mondo che vive di vita propria", "La cosa che rende Dwarf Fortress speciale è che ogni mondo che crei è completamente dinamico e vivo. Le tue azioni hanno un impatto sulle generazioni future, e ogni gioco è una storia unica.", 5.0, 77, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'esperienza intensa", "Dying Light 2 è un gioco che mescola azione, esplorazione e sopravvivenza in un mondo aperto devastato. La trama è coinvolgente, le meccaniche di parkour sono straordinarie e la possibilità di influenzare il mondo in base alle tue scelte rende il gioco unico.", 5.0, 20, 1),
("Un gioco che ti tiene sulla punta dei piedi", "La combinazione di combattimento, esplorazione e parkour in Dying Light 2 è incredibile. Ogni angolo della città è da esplorare, e ogni scelta che fai ha un impatto sul mondo che ti circonda.", 5.0, 20, 10),
("Un'avventura mozzafiato", "La libertà di movimento offerta dal parkour è uno degli aspetti migliori di Dying Light 2. La trama, sebbene interessante, non è la parte migliore, ma la sensazione di essere un sopravvissuto in un mondo post-apocalittico è davvero immersiva.", 4.8, 20, 20),
("Un passo avanti rispetto al primo", "Dying Light 2 migliora molti aspetti del suo predecessore, in particolare il sistema di movimento e le scelte narrative. Le città sono immense e piene di opportunità per chi ama esplorare e combattere.", 5.0, 20, 30),
("Un open world vibrante e pericoloso", "Dying Light 2 riesce a ricreare un mondo di gioco vivido e pericoloso. Le notti sono particolarmente emozionanti, e le missioni secondarie sono tanto ricche quanto la trama principale.", 4.9, 20, 40),
("L'evoluzione del genere", "Con il suo gameplay basato su parkour e l'ambientazione post-apocalittica, Dying Light 2 è un ottimo esempio di come i giochi open world possano evolversi. La storia è buona, ma il focus sul movimento e sul combattimento lo rende un gioco da vivere e non solo da giocare.", 5.0, 20, 50),
("Molto divertente, ma con qualche difetto", "Dying Light 2 è incredibilmente divertente grazie alle sue meccaniche di parkour e alla varietà delle missioni. Tuttavia, la storia principale può sembrare un po' prevedibile in certi momenti.", 4.7, 20, 60),
("Un mondo dove le scelte contano", "Le scelte che fai in Dying Light 2 non sono solo estetiche, ma influenzano realmente il mondo che ti circonda. Ogni decisione può cambiare la tua esperienza di gioco in modo significativo.", 5.0, 20, 70),
("Il parkour che rende tutto più dinamico", "Il sistema di parkour è davvero innovativo e rende ogni esplorazione un'esperienza unica. Le ambientazioni sono mozzafiato e l'atmosfera del gioco ti tiene sempre coinvolto.", 4.9, 20, 80),
("Un gioco che non smette mai di sorprendere", "Dying Light 2 offre un mondo vasto e pieno di sorprese. Ogni zona esplorata ha il suo carattere, e le dinamiche di combattimento sono coinvolgenti e soddisfacenti.", 5.0, 20, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro assoluto", "Elden Ring è un gioco che non ha rivali nel suo genere. La vasta libertà di esplorazione, la trama criptica e il combattimento profondo fanno di questo titolo una vera e propria esperienza indimenticabile.", 5.0, 36, 1),
("Un mondo incantevole e letale", "Elden Ring è un mondo che ti accoglie con grande bellezza, ma che è anche spietato. Ogni angolo nasconde un segreto, e la sensazione di progressione è soddisfacente come non mai. Un must per ogni fan dei giochi di ruolo.", 5.0, 36, 10),
("Un'esperienza unica", "Elden Ring ti catapulta in un mondo misterioso e affascinante, dove ogni angolo è una sfida. Il design del mondo aperto è fenomenale e l'atmosfera che crea è unica nel suo genere.", 5.0, 36, 20),
("La sfida di Elden Ring", "Se hai mai giocato a un Soulslike, saprai che ogni vittoria in Elden Ring è una conquista. Con la sua difficoltà, il gioco ti insegna la pazienza, ma le ricompense sono immense. Non è un gioco per tutti, ma per chi è pronto a sfidarsi è un'esperienza imperdibile.", 4.9, 36, 30),
("Il miglior gioco del 2022", "Elden Ring ha ridefinito il concetto di gioco di ruolo open world. Con una storia affascinante e una vastità di contenuti incredibile, questo titolo si distingue come uno dei migliori degli ultimi anni.", 5.0, 36, 40),
("Un viaggio epico", "Ogni parte di Elden Ring è un viaggio epico. La difficoltà è impegnativa, ma non ingiusta, e la libertà di esplorazione è infinita. Le battaglie contro i boss sono alcune delle più memorabili che abbia mai affrontato.", 5.0, 36, 50),
("Un'opera maestosa", "Con il suo mondo aperto, la libertà nelle scelte e la cura nei dettagli, Elden Ring è un gioco che merita di essere giocato da ogni amante dei giochi di ruolo. È un'opera che ti sfida e ti premia allo stesso tempo.", 4.9, 36, 60),
("Il mondo di Elden Ring è vivo", "Elden Ring è uno dei mondi di gioco più affascinanti che abbia mai esplorato. Ogni zona ha il suo carattere e il suo stile, e le meccaniche di gioco sono incredibilmente soddisfacenti.", 5.0, 36, 70),
("Un'esperienza da non perdere", "Elden Ring è una delle esperienze più appaganti che si possano vivere nel mondo dei videogiochi. La sua trama misteriosa e la difficoltà stimolante lo rendono un titolo che non puoi assolutamente perdere.", 5.0, 36, 80),
("Un gioco che cambia la vita", "Elden Ring non è solo un gioco, è un viaggio. La bellezza del mondo di gioco, unita a un combattimento appagante e una trama da scoprire lentamente, lo rende un'esperienza che lascia il segno.", 5.0, 36, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco di puzzle divertente", "Escape Simulator è un gioco di puzzle coinvolgente che ti fa sentire come se stessi davvero cercando di risolvere enigmi per fuggire da una stanza. Ogni livello è unico e offre una sfida interessante.", 4.8, 164, 1),
("Perfetto per gli amanti degli enigmi", "Se sei un fan dei giochi di fuga, Escape Simulator è un titolo che non puoi perdere. La varietà di puzzle e la possibilità di giocare in modalità cooperativa lo rendono ancora più divertente.", 5.0, 164, 10),
("Enigmi intriganti", "Le stanze in Escape Simulator sono ben progettate, e la varietà degli enigmi mantiene il gioco fresco. È perfetto per giocare da soli o con amici, e ti farà pensare molto prima di trovare la soluzione.", 4.7, 164, 20),
("Ottimo per il cooperativo", "Escape Simulator brilla quando giocato in modalità cooperativa. Lavorare insieme per risolvere enigmi è estremamente gratificante, e il gioco offre molte stanze diverse da esplorare.", 5.0, 164, 30),
("Un'esperienza divertente e stimolante", "Ogni livello di Escape Simulator è un nuovo enigma da decifrare. I puzzle sono ben costruiti e stimolanti, e la sensazione di vittoria quando riesci a risolverli è fantastica.", 4.8, 164, 40),
("Gioco ideale per una serata con amici", "Escape Simulator è perfetto per passare una serata con gli amici. È divertente, stimolante e offre una varietà di stanze che manterranno occupati anche i giocatori più esperti.", 4.9, 164, 50),
("Risolvi enigmi e divertiti", "Il gameplay di Escape Simulator è semplice ma efficace: risolvere enigmi per progredire. La grafica è piacevole e le stanze sono ben progettate, facendo del gioco una buona esperienza per chi ama le sfide mentali.", 4.7, 164, 60),
("Un buon passatempo", "Escape Simulator è un gioco che puoi giocare in brevi sessioni, ma che riesce comunque a essere coinvolgente. I puzzle non sono troppo difficili, ma abbastanza stimolanti da far venire voglia di risolverli tutti.", 4.5, 164, 70),
("Puzzle ben fatti", "Ogni stanza ha una sua logica, e i puzzle sono abbastanza vari da tenerti impegnato. Escape Simulator è un ottimo gioco se ami mettere alla prova la tua mente con enigmi creativi.", 4.8, 164, 80),
("Un gioco che ti fa pensare", "Escape Simulator ti fa ragionare, ti costringe a pensare in modo logico e a risolvere enigmi complessi. Le stanze sono varie e divertenti, e l'esperienza complessiva è davvero soddisfacente.", 4.9, 164, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'esperienza di corsa realistica", "F1 23 offre una simulazione di guida incredibile. I dettagli sui circuiti e le dinamiche di guida sono molto realistici, e la modalità carriera è coinvolgente.", 5.0, 203, 1),
("Perfetto per gli appassionati di corse", "Se sei un fan della Formula 1, F1 23 è il gioco che fa per te. La fedeltà alla simulazione è impressionante, e la varietà di modalità di gioco offre molto da fare.", 5.0, 203, 10),
("Un gioco di corse davvero completo", "F1 23 è un gioco che offre sia realismo che divertimento. La grafica è incredibile e la gestione delle auto è così precisa che ti sentirai come un vero pilota di Formula 1.", 4.9, 203, 20),
("Simulazione impeccabile", "La simulazione in F1 23 è perfetta. Ogni dettaglio, dalle dinamiche di pista alla gestione della macchina, è stato pensato per offrire un'esperienza il più realistica possibile.", 5.0, 203, 30),
("Ottimo per la carriera", "La modalità carriera di F1 23 è davvero coinvolgente. Puoi creare il tuo pilota, scegliere la tua squadra e competere in campionati intensi. È un ottimo modo per immergersi completamente nel mondo della Formula 1.", 4.8, 203, 40),
("Un gioco di corse ad alta velocità", "Con F1 23, ogni curva e ogni sorpasso sono intensi. La modalità multigiocatore è fantastica, e le gare online sono sempre emozionanti e competitive.", 4.9, 203, 50),
("Un'esperienza di corse ad alta definizione", "La grafica di F1 23 è semplicemente sbalorditiva, con una resa dei circuiti e delle auto molto dettagliata. Inoltre, le animazioni dei piloti e gli effetti sonori sono molto realistici.", 5.0, 203, 60),
("Un gioco per tutti", "Che tu sia un principiante o un esperto di simulazioni di corse, F1 23 ha modalità per tutti. Le opzioni di personalizzazione delle impostazioni di difficoltà ti permettono di adattare il gioco al tuo livello.", 4.8, 203, 70),
("La competizione è reale", "Le gare in F1 23 sono serrate, e la sensazione di competere contro piloti di livello mondiale ti fa sentire come se fossi davvero su una pista di Formula 1. Il gioco ti sfida e ti fa migliorare.", 5.0, 203, 80),
("L'esperienza completa di F1", "F1 23 è un gioco che offre tutto ciò che un fan della Formula 1 potrebbe desiderare: gare mozzafiato, modalità carriera coinvolgente e la possibilità di competere online contro altri giocatori.", 5.0, 203, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un classico della magia", "Fable Anniversary è un remake fantastico di un classico intramontabile. La storia, il mondo e le scelte morali sono ancora incredibilmente coinvolgenti, e la grafica aggiornata è un piacere per gli occhi.", 4.8, 47, 1),
("Un gioco da rigiocare", "Fable Anniversary offre una narrazione ricca e affascinante. Ogni scelta che fai ha un impatto sul mondo di gioco, e la possibilità di diventare un eroe o un cattivo è sempre divertente.", 4.7, 47, 10),
("Ritorno alla fiera di Albion", "Questo remake di Fable è una meraviglia. La grafica migliorata e l'aggiunta di nuovi contenuti lo rendono un'esperienza fresca, pur mantenendo il fascino dell'originale.", 4.9, 47, 20),
("Un'avventura indimenticabile", "Fable Anniversary conserva tutto il fascino dell'originale, con un sistema di scelte morali che rende ogni partita unica. È un gioco che non si dimentica facilmente.", 4.8, 47, 30),
("Un grande remake", "Questo remake di Fable è il modo perfetto per vivere l'avventura in modo moderno. La grafica è sorprendente e la storia rimane incredibilmente coinvolgente. La personalizzazione del personaggio è un altro punto forte.", 4.9, 47, 40),
("La magia di Albion", "Fable Anniversary ti fa sentire come se stessi vivendo un'avventura epica in un mondo magico. Le scelte che fai hanno un impatto significativo sul mondo, rendendo ogni partita speciale.", 4.7, 47, 50),
("La nostalgia del primo Fable", "Fable Anniversary è una versione aggiornata di un gioco che ha fatto la storia. Nonostante la grafica migliore, il gioco conserva intatto il suo spirito originale e la sua magia.", 4.8, 47, 60),
("Un'esperienza unica", "Fable Anniversary è una delle esperienze più uniche nel mondo dei giochi di ruolo. Ogni scelta che fai conta, e il mondo di Albion è tanto affascinante quanto pericoloso.", 5.0, 47, 70),
("Un tuffo nel passato", "Fable Anniversary è il gioco perfetto per chi vuole rivivere un classico. La nuova grafica lo rende più bello che mai, ma la storia e le scelte morali rimangono il cuore del gioco.", 4.9, 47, 80),
("Un gioco che non stanca mai", "Fable Anniversary è una delle migliori esperienze RPG di sempre. La storia è emozionante, le opzioni di gioco sono ampie, e la possibilità di scegliere il proprio destino è sempre interessante.", 5.0, 47, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un seguito epico", "Fable II è un gioco fantastico che espande l'universo di Albion con una storia coinvolgente e scelte morali che impattano il mondo. La libertà che offre è senza pari.", 4.9, 204, 1),
("Un RPG che fa sognare", "Fable II è un gioco che ti cattura fin da subito. La storia è ricca, il mondo è vivo e le tue scelte influenzano davvero l'evolversi degli eventi. Un RPG che non delude mai.", 5.0, 204, 10),
("Migliore dell'originale", "Fable II migliora ogni aspetto dell'originale, con una trama ancora più affascinante, personaggi più profondi e un mondo aperto che ti invoglia ad esplorare ogni angolo.", 4.8, 204, 20),
("Un gioco di ruolo straordinario", "Fable II è un gioco di ruolo che si distingue per la sua libertà e la profondità delle scelte morali. Puoi essere un eroe o un malvagio, e il mondo reagisce di conseguenza.", 4.9, 204, 30),
("Un'avventura da vivere", "La storia in Fable II è emozionante e le scelte che fai rendono ogni partita unica. La possibilità di costruire la tua vita in Albion è una delle caratteristiche che lo rendono speciale.", 5.0, 204, 40),
("Scelte morali che contano", "Fable II ti mette di fronte a scelte morali significative che influenzano il destino del mondo. Questo è ciò che rende il gioco così interessante e coinvolgente.", 5.0, 204, 50),
("Un mondo vivo", "Il mondo di Albion in Fable II è vibrante e pieno di vita. Ogni angolo nasconde una nuova avventura e il gameplay non diventa mai noioso. È un'esperienza che non ti stancherai mai di esplorare.", 4.8, 204, 60),
("Un'esperienza che ti segna", "Fable II non è solo un gioco, è un'esperienza. Le tue azioni hanno conseguenze e il mondo cambia a seconda delle scelte che fai, creando un legame unico con il gioco.", 5.0, 204, 70),
("La libertà di essere chi vuoi", "In Fable II puoi essere chi vuoi, e il gioco ti lascia totale libertà. Puoi fare ciò che ti pare, e il mondo di Albion ti accoglie in ogni tua decisione.", 4.9, 204, 80),
("Una storia che non si dimentica", "Fable II è una delle storie più emozionanti che un videogioco possa raccontare. Il legame con il personaggio e le sue scelte è forte, e il mondo ti avvolge completamente.", 5.0, 204, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'avventura che ti cambia", "Fable III è una continuazione emozionante della saga. Le scelte politiche e morali sono unici, con un'idea innovativa che aggiunge profondità alla trama.", 4.7, 205, 1),
("Il potere nelle tue mani", "In Fable III, il concetto di potere e responsabilità è al centro della trama. Le tue scelte come sovrano cambiano il destino del regno, rendendo il gioco ancora più coinvolgente.", 4.8, 205, 10),
("Un'evoluzione della serie", "Fable III porta una ventata di novità alla saga, con un gameplay più fluido e una storia ancora più ricca. La gestione del regno è un'aggiunta interessante, ma la parte più affascinante resta la libertà di scelta.", 4.9, 205, 20),
("Un regno nelle tue mani", "Fable III ti mette in posizione di potere, dove ogni decisione ha un impatto diretto sul regno e sul suo popolo. La profondità della trama è una delle sue caratteristiche principali.", 4.7, 205, 30),
("Una storia che evolve", "La storia di Fable III è emozionante, con scelte morali che portano a risultati concreti. Il concetto di leadership rende il gioco diverso dai suoi predecessori, ma altrettanto coinvolgente.", 4.8, 205, 40),
("Eroe o tiranno", "In Fable III, puoi diventare il sovrano che vuoi essere. Le tue azioni e decisioni cambiano il destino del regno, e il gioco fa un ottimo lavoro nel mettere in luce le conseguenze di queste scelte.", 5.0, 205, 50),
("La lotta per il potere", "Fable III mette il giocatore al centro di una lotta per il potere, dove ogni decisione, anche quella più piccola, conta. È un'esperienza che ti fa riflettere.", 4.9, 205, 60),
("Una trama emozionante", "La storia in Fable III è emozionante e ben costruita. Le scelte che fai come sovrano ti pongono di fronte a dilemmi morali che rendono il gioco unico e memorabile.", 5.0, 205, 70),
("Un gioco che non delude", "Fable III offre un'esperienza che non delude mai. La possibilità di influenzare il regno e fare scelte difficili aggiunge una dimensione interessante alla trama, rendendolo uno dei migliori RPG.", 4.8, 205, 80),
("Un'epopea politica", "Fable III non è solo un RPG, ma anche un gioco che esplora la politica, il potere e la responsabilità. Ogni decisione ha una grande ripercussione sulla storia, e il gioco ti fa sentire davvero il peso di essere un sovrano.", 5.0, 205, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un divertimento senza fine", "Fall Guys è un gioco divertentissimo, perfetto per divertirsi con amici. Le partite sono veloci e frenetiche, e ogni round è una sorpresa. Adatto a chi cerca una dose di leggerezza!", 4.9, 130, 1),
("Chaos e risate assicurate", "Fall Guys è il tipo di gioco che non puoi smettere di giocare. Ogni round è un caos totale, ma proprio per questo è così divertente. Le sfide sono sempre diverse, e il design è super colorato.", 5.0, 130, 10),
("Competizione pazza", "Fall Guys mescola competizione e caos in un mix perfetto. Ogni partita è una corsa all'assurdo, dove ci si può trovare a vincere o a perdere in pochi secondi. È molto più divertente di quanto sembri.", 4.8, 130, 20),
("Perfetto per le partite veloci", "Fall Guys è ideale per chi cerca un gioco veloce, divertente e leggero. Non serve molto tempo per divertirsi, e le partite sono sempre diverse, tenendo alto l'interesse.", 4.7, 130, 30),
("Un gioco per tutti", "Fall Guys è accessibile a tutti, anche a chi non è un gamer esperto. Le regole sono semplici, ma le sfide possono essere imprevedibili e divertenti. Ideale per giocare in compagnia!", 4.9, 130, 40),
("Un caos colorato", "Fall Guys è pura energia. I livelli sono esilaranti e il gioco è frenetico. Non ci si annoia mai, perché ogni partita porta qualcosa di nuovo e divertente.", 5.0, 130, 50),
("Un party game perfetto", "Fall Guys è la scelta ideale per una sessione di gioco con amici. È semplice, veloce e incredibilmente divertente, con situazioni assurde che ti fanno ridere di continuo.", 4.8, 130, 60),
("Da non perdere per i fan dei battle royale", "Fall Guys è un battle royale che si distingue per la sua originalità. Invece di sparare, ti ritrovi a correre, saltare e sfidare gli altri giocatori in prove divertenti.", 4.9, 130, 70),
("Risate a non finire", "Fall Guys è il gioco che ti fa ridere a ogni partita. Le sfide sono facili da comprendere, ma mai scontate. Ogni volta che giochi, ti ritrovi a ridere per le disavventure che ti capitano.", 5.0, 130, 80),
("Un gioco semplice ma efficace", "Fall Guys non ha bisogno di complicate meccaniche di gioco per essere divertente. È tutto nel caos e nelle risate che nascono dalla competizione tra giocatori. Consigliato per chi cerca un gioco spensierato!", 4.8, 130, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro post-apocalittico", "Fallout: New Vegas è un gioco che ti catapulta in un mondo post-apocalittico ricco di scelte morali e storie affascinanti. Le decisioni che prendi hanno un impatto significativo sulla trama, rendendo ogni partita unica.", 5.0, 21, 1),
("Un RPG che non delude mai", "Con Fallout: New Vegas, Obsidian ha creato un gioco che mescola perfettamente esplorazione, combattimento e narrazione. La libertà che offre al giocatore è straordinaria, e la storia è piena di colpi di scena.", 4.9, 21, 10),
("La scelta è la chiave", "Fallout: New Vegas ti mette al centro delle scelte morali. Ogni decisione che prendi può cambiare il corso degli eventi e delle alleanze, facendoti sentire veramente responsabile dei tuoi atti.", 5.0, 21, 20),
("Un mondo aperto straordinario", "Il mondo di Fallout: New Vegas è vasto, dettagliato e pieno di missioni secondarie interessanti. Ogni angolo della mappa nasconde segreti e storie che ti terranno impegnato per ore.", 4.8, 21, 30),
("Un RPG da non perdere", "Fallout: New Vegas è uno dei migliori RPG mai creati. La trama è coinvolgente e le opzioni di dialogo sono incredibilmente varie, permettendo di vivere una storia personalizzata a seconda delle tue scelte.", 5.0, 21, 40),
("Un'esperienza unica", "Fallout: New Vegas offre un'esperienza immersiva senza pari. La possibilità di allearti con diverse fazioni e di decidere il destino della città è una delle cose che rende il gioco così speciale.", 4.9, 21, 50),
("Un'ambientazione da urlo", "L'ambientazione di Fallout: New Vegas è una delle migliori nella storia dei giochi post-apocalittici. La sua atmosfera è unica, con dialoghi ben scritti e personaggi indimenticabili.", 4.8, 21, 60),
("Un gioco che ti fa riflettere", "Le scelte che fai in Fallout: New Vegas non sono mai facili. Ogni decisione ha delle conseguenze, e il gioco ti spinge a riflettere sul significato di giustizia, lealtà e potere.", 5.0, 21, 70),
("La libertà è tutto", "Fallout: New Vegas è un gioco che ti permette di scegliere il tuo destino. Puoi essere un eroe o un tiranno, e il gioco ti permette di vivere le tue scelte fino in fondo, con un grande impatto sulla storia.", 4.9, 21, 80),
("Un gioco che non invecchia mai", "Nonostante gli anni, Fallout: New Vegas resta un gioco senza tempo. Le sue meccaniche sono ancora fresche e le storie che racconta sono sempre attuali, facendone uno dei migliori giochi RPG di sempre.", 4.8, 21, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'esperienza di sopravvivenza intensa", "Far Cry 2 è un gioco che ti mette alla prova in ogni aspetto, dalla gestione delle risorse alla lotta per la sopravvivenza. Le ambientazioni sono vaste e realistiche, ma la difficoltà può essere frustrante a volte.", 4.6, 206, 1),
("Un gioco crudo e realistico", "Far Cry 2 è un gioco che ti fa sentire il peso della guerra. Il realismo è impressionante, ma può risultare pesante per chi cerca un'esperienza più leggera. La mappa è vasta, ma può sembrare ripetitiva.", 4.7, 206, 10),
("Un mondo aperto impervio", "Far Cry 2 offre una mappa vasta e un gameplay impegnativo. La necessità di gestire risorse, riparare le armi e affrontare missioni complesse crea un'esperienza immersiva, ma non è per tutti.", 4.5, 206, 20),
("L'arte della sopravvivenza", "Far Cry 2 ti costringe a pensare e a pianificare ogni mossa. Ogni viaggio è rischioso e le scelte fatte lungo il percorso possono determinare la tua sorte. È un gioco che premia la pazienza e la strategia.", 4.8, 206, 30),
("Una sfida costante", "Il gioco è davvero difficile, ma è proprio questa difficoltà che lo rende interessante. Le missioni sono varie, ma il mondo è vasto e alcune aree possono sembrare ripetitive.", 4.6, 206, 40),
("Un gameplay che mette alla prova", "Far Cry 2 è un gioco che richiede molta attenzione ai dettagli. Dalla gestione delle munizioni alla cura delle armi, il gioco ti immerge in un'esperienza realistica, ma richiede un grande impegno.", 4.7, 206, 50),
("Un viaggio attraverso la guerra", "Far Cry 2 è un'esperienza cruda e realistica che ti fa sentire come se fossi davvero in guerra. La storia non è particolarmente forte, ma il mondo di gioco è ricco e ti spinge a esplorarlo in profondità.", 4.5, 206, 60),
("Ottimo ma difficile", "Far Cry 2 è un gioco che offre una grande libertà ma può essere frustrante per via della difficoltà e della gestione delle risorse. Se ti piacciono le sfide, è un gioco che vale la pena provare.", 4.6, 206, 70),
("Un'esperienza dura ma soddisfacente", "Le meccaniche di Far Cry 2 ti sfidano continuamente a sopravvivere. Le battaglie sono intense, ma la ripetitività nelle missioni può sembrare stancante dopo un po'.", 4.7, 206, 80),
("Un po' troppo ripetitivo", "Far Cry 2 offre un'esperienza solida, ma alcune missioni possono sembrare ripetitive. La gestione delle risorse e la difficoltà possono risultare eccessive per alcuni giocatori, ma per chi ama le sfide è un gioco da non perdere.", 4.6, 206, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'ottima evoluzione del franchise", "Far Cry 3 è un capolavoro che ha perfezionato la formula del franchise. Con una trama coinvolgente, personaggi memorabili e un mondo aperto ricco di attività, è uno dei migliori giochi di sempre.", 5.0, 207, 1),
("Un'esperienza di gioco unica", "La libertà che offre Far Cry 3 è incredibile. Puoi esplorare la mappa, affrontare nemici o dedicarti alle missioni secondarie, tutto con grande varietà. La storia è solida e il protagonista è ben caratterizzato.", 4.9, 207, 10),
("Un villaggio di pazzi", "Far Cry 3 ti immerge in un mondo selvaggio dove devi affrontare i pericoli di un'isola infestata da mercenari e criminali. Le meccaniche di combattimento sono migliorate rispetto ai precedenti capitoli e la trama è avvincente.", 5.0, 207, 20),
("Un classico moderno", "Far Cry 3 è un gioco che ti offre un mondo aperto ricco di possibilità. La varietà delle missioni, la possibilità di personalizzare il personaggio e l'esplorazione sono il cuore del gioco, che ti tiene incollato allo schermo.", 4.8, 207, 30),
("Un'isola selvaggia", "Il gioco è ambientato su un'isola tropicale piena di pericoli. I nemici sono intelligenti e le opzioni per affrontarli sono molteplici, il che rende ogni approccio unico. Far Cry 3 è un gioco che premia la creatività.", 4.9, 207, 40),
("Un'ottima combinazione di azione e esplorazione", "Far Cry 3 ti permette di passare dal combattimento intenso all'esplorazione tranquilla dell'isola. La libertà di scelta è enorme, e ogni decisione che prendi può cambiare il corso degli eventi.", 4.8, 207, 50),
("Un villain indimenticabile", "Vaas, il principale antagonista di Far Cry 3, è uno dei villain più memorabili di sempre. La sua presenza nel gioco è inquietante e rende la storia ancora più interessante.", 5.0, 207, 60),
("Mondo aperto da esplorare", "L'isola di Far Cry 3 è un mondo aperto ben progettato, ricco di fauna, missioni secondarie e attività. Ogni angolo della mappa ha qualcosa da scoprire, che si tratti di una nuova zona o di una missione nascosta.", 4.9, 207, 70),
("Difficile non essere catturati", "Far Cry 3 è difficile da lasciare. La trama coinvolgente, i personaggi interessanti e la libertà di esplorare lo rendono un gioco che è facile rigiocare più volte.", 5.0, 207, 80),
("Un gioco che ti fa sentire vivo", "Far Cry 3 ti fa sentire parte del mondo che esplori. Le ambientazioni sono straordinarie, i combattimenti sono esaltanti e il gioco ti immerge completamente in un'esperienza unica.", 4.9, 207, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Miglioramenti rispetto al predecessore", "Far Cry 4 espande le meccaniche di gioco di Far Cry 3, introducendo una nuova mappa e nuovi strumenti. La trama è coinvolgente e l'ambientazione è ricca di dettagli, ma alcune missioni sono troppo simili a quelle precedenti.", 4.7, 208, 1),
("Un gioco di azione pura", "Far Cry 4 ti mette in un mondo pieno di azione e possibilità. Esplorare l'Himalaya è fantastico, e la libertà che il gioco ti offre è davvero unica. La grafica è straordinaria, e ogni angolo della mappa ha qualcosa di interessante.", 4.8, 208, 10),
("Il ritorno del caos", "In Far Cry 4, il caos è ancora protagonista. Combattere contro le forze nemiche e allearsi con diversi gruppi ti permette di giocare come preferisci. La varietà delle missioni è apprezzata, ma alcune sono ripetitive.", 4.6, 208, 20),
("Un mondo ancora più grande", "Far Cry 4 ti offre un mondo ancora più vasto e interessante rispetto al precedente capitolo. La possibilità di esplorare montagne, valli e villaggi è fantastica, ma la difficoltà del gioco è aumentata.", 4.7, 208, 30),
("Un'esperienza ancora più grande", "Far Cry 4 è un'esperienza che espande il successo di Far Cry 3, con nuove meccaniche e una storia che ti tiene incollato. Il protagonista è più interessante, ma alcune meccaniche di gioco sono troppo familiari.", 4.8, 208, 40),
("Un bel gioco, ma un po' ripetitivo", "La formula di Far Cry 4 funziona bene, ma alcuni elementi sono troppo simili al predecessore. La mappa è bellissima, ma le missioni potrebbero essere più varie. Rimane comunque un ottimo gioco di azione e avventura.", 4.6, 208, 50),
("Esplorazione senza fine", "L'aspetto migliore di Far Cry 4 è l'esplorazione. La mappa è incredibilmente grande e ricca di dettagli, e ci sono molte attività da fare oltre alla storia principale, come cacciare animali e raccogliere risorse.", 4.8, 208, 60),
("Semplicemente divertente", "Far Cry 4 è un gioco che non ti fa mai annoiare. Le missioni sono varie, le armi sono fantastiche e la possibilità di giocare in modalità cooperativa lo rende ancora più interessante. La storia non è eccezionale, ma è comunque divertente.", 4.7, 208, 70),
("Molto simile a Far Cry 3, ma con nuove sfide", "Far Cry 4 è molto simile al suo predecessore, ma le nuove aggiunte, come i veicoli e le armi, lo rendono comunque interessante. Le missioni sono divertenti, ma qualche volta si ripetono troppo.", 4.6, 208, 80),
("Un must per gli amanti dell'open world", "Se ami i giochi open world, Far Cry 4 è un must. Le opzioni di combattimento sono fantastiche, e l'esplorazione è appagante. Purtroppo, alcune meccaniche sembrano già viste, ma è comunque un ottimo gioco.", 4.7, 208, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'esperienza di gioco coinvolgente", "Far Cry 5 ti immerge in un mondo di caos e distruzione. La trama è solida, anche se un po' prevedibile, e la libertà di gioco è fantastica. Le meccaniche di combattimento sono migliorate, ma la storia poteva essere più avvincente.", 4.7, 16, 1),
("Un'apocalisse rurale", "Far Cry 5 ambienta la sua storia in una zona rurale degli Stati Uniti, dove una setta religiosa prende il controllo. L'ambientazione è originale e interessante, ma il ritmo della storia è un po' lento in alcuni punti.", 4.6, 16, 10),
("Un gran gioco, ma con qualche difetto", "La formula di Far Cry funziona ancora, ma in Far Cry 5 ci sono alcuni difetti. Le missioni principali sono un po' ripetitive e il villain non è memorabile come quelli dei giochi precedenti. Però, la possibilità di esplorare liberamente è il punto forte.", 4.5, 16, 20),
("Un'ottima evoluzione del gameplay", "Il gameplay di Far Cry 5 è sicuramente migliorato rispetto ai precedenti capitoli. Le armi, i veicoli e la possibilità di affrontare la trama in modo non lineare sono fantastiche. Tuttavia, la trama principale non è all'altezza di Far Cry 3 o 4.", 4.7, 16, 30),
("Un villaggio da salvare", "Far Cry 5 ti mette contro una setta religiosa che minaccia la pace del villaggio. La trama è interessante, ma alcune missioni sono ripetitive. Nonostante ciò, il gioco offre un'esperienza coinvolgente e divertente.", 4.6, 16, 40),
("Il ritorno della violenza", "Come nei precedenti capitoli, Far Cry 5 ti permette di affrontare le missioni come vuoi, con grande libertà. La possibilità di reclutare alleati per combattere le forze della setta è un'aggiunta benvenuta.", 4.8, 16, 50),
("Un buon mix di azione e esplorazione", "Far Cry 5 ti permette di esplorare un'area vasta e ricca di dettagli. Le meccaniche di combattimento sono solite, ma divertenti, mentre la possibilità di personalizzare le armi e scegliere le missioni aggiunge varietà al gioco.", 4.7, 16, 60),
("Tanta azione, ma qualcosa manca", "Far Cry 5 offre molte ore di azione frenetica, ma qualcosa sembra mancare rispetto ai giochi precedenti. Il villain non è memorabile e la trama potrebbe essere più interessante. Nonostante ciò, è un gioco che merita di essere giocato.", 4.6, 16, 70),
("La libertà è il suo punto di forza", "Far Cry 5 ti lascia molta libertà per scegliere come affrontare le situazioni. Puoi affrontare la setta come preferisci, ma la trama sembra meno coinvolgente rispetto ai precedenti capitoli. La possibilità di esplorare la mappa è comunque appagante.", 4.7, 16, 80),
("Un'avventura open world da non perdere", "Far Cry 5 è un gioco che piacerà agli amanti dei mondi aperti. Le missioni sono varie e la possibilità di esplorare l'ambiente circostante è grande. La storia poteva essere più forte, ma il gioco resta comunque divertente.", 4.6, 16, 90),
("Molto divertente, ma con alcuni difetti", "Far Cry 5 offre tanto divertimento, ma la trama non è all'altezza di Far Cry 3 o 4. Il mondo è fantastico da esplorare, ma alcuni aspetti del gioco sembrano un po' ripetitivi. In ogni caso, un'esperienza molto divertente.", 4.7, 16, 100);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco di azione che ti immerge nel caos", "Far Cry 6 ti porta in un mondo dominato da una dittatura. L'ambientazione è ben fatta e la possibilità di esplorare una vasta isola è eccellente. La trama, purtroppo, è un po' scontata, ma le meccaniche di gioco sono solide.", 4.6, 209, 1),
("Un altro capitolo di Far Cry", "Far Cry 6 è un buon gioco, ma non offre molto di nuovo rispetto ai precedenti capitoli. La possibilità di utilizzare nuovi veicoli e armi è interessante, ma la trama è abbastanza prevedibile. Resta comunque un'esperienza divertente.", 4.5, 209, 10),
("Un villain da ricordare", "Il villain di Far Cry 6 è carismatico e ben interpretato. Tuttavia, la trama nel suo complesso non brilla, e alcune missioni sono un po' ripetitive. Nonostante ciò, il gameplay è solido e l'esplorazione è sempre divertente.", 4.7, 209, 20),
("La libertà di scegliere", "Far Cry 6 ti dà un ampio margine di libertà nella scelta delle missioni e nel modo di affrontarle. Puoi scegliere come organizzare la tua ribellione, ma la storia non è abbastanza coinvolgente per mantenere alta la tensione.", 4.6, 209, 30),
("Un'ottima evoluzione del gameplay", "Far Cry 6 espande le meccaniche di gioco dei precedenti capitoli, con nuove armi, gadget e veicoli. Il mondo di gioco è ricco di attività, ma la trama non è altrettanto memorabile. In ogni caso, è un gioco che intrattiene e offre molte ore di divertimento.", 4.7, 209, 40),
("Non abbastanza innovativo", "Far Cry 6 offre molta azione e un bel mondo aperto, ma manca di innovazione. Alcune missioni sembrano già viste e la trama non è particolarmente originale. Tuttavia, rimane un gioco divertente per chi ama la serie.", 4.5, 209, 50),
("Ottima ambientazione, ma poco più", "L'ambientazione di Far Cry 6 è fantastica, con una ricca varietà di paesaggi e nemici. Tuttavia, la trama non riesce a coinvolgere come ci si aspetterebbe, e le missioni risultano spesso ripetitive.", 4.6, 209, 60),
("Un buon gioco, ma non il migliore", "Far Cry 6 è un gioco che offre tanto in termini di gameplay, ma la trama non è così avvincente come in altri capitoli della serie. L'esplorazione è comunque gratificante, ma qualcosa di nuovo sarebbe stato gradito.", 4.6, 209, 70),
("Un'esperienza di gioco intensa", "Far Cry 6 ti mette nei panni di un ribelle contro una dittatura, ma la storia non è originale. Le meccaniche sono ben fatte, e la possibilità di reclutare alleati è una grande aggiunta. Il gioco resta comunque molto divertente.", 4.7, 209, 80),
("Un'avventura che non delude", "Far Cry 6 è un gioco che non delude mai, ma non aggiunge molto di nuovo alla formula. La trama non è eccezionale, ma l'esperienza complessiva è comunque piacevole, grazie anche a un mondo ben progettato e ricco di attività.", 4.6, 209, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Una grande evoluzione", "FC 24 porta la serie a un nuovo livello, con miglioramenti nel gameplay e nell'IA. Le nuove modalità sono divertenti e la grafica è incredibile. Tuttavia, alcuni bug tecnici potrebbero limitare l'esperienza di gioco.", 4.7, 217, 1),
("Un passo in avanti", "Il gioco è molto migliorato rispetto al precedente capitolo, ma la mancanza di innovazione nelle modalità di gioco potrebbe deludere alcuni. La grafica è comunque mozzafiato e il gameplay è fluido.", 4.6, 217, 10),
("Modalità migliorate, ma ancora spazio per crescere", "FC 24 offre nuove modalità di gioco interessanti, ma la ripetitività nelle partite online può diventare frustrante. La personalizzazione dei giocatori è stata migliorata, ma ci sono ancora margini di miglioramento.", 4.5, 217, 20),
("Il calcio che tutti aspettavamo", "FC 24 è finalmente il gioco di calcio che molti aspettavano. La fluidità nei movimenti dei giocatori e la reattività sono sorprendenti, ma alcune meccaniche potrebbero essere affinato per una maggiore profondità.", 4.8, 217, 30),
("Una grafica da urlo", "La grafica di FC 24 è incredibile, i dettagli sui giocatori e gli stadi sono ben fatti. Purtroppo, la parte tattica del gioco è ancora un po' carente rispetto ad altri titoli sportivi.", 4.7, 217, 40),
("Non senza difetti", "FC 24 ha tante cose positive, come un gameplay solido e nuove modalità di gioco, ma i bug tecnici e il matchmaking online a volte rovinano l'esperienza. Nonostante tutto, è un gioco molto divertente da giocare.", 4.6, 217, 50),
("Molto realistico", "Il gioco migliora ogni anno, ma questa volta la serie è davvero realistica. Le animazioni dei giocatori sono fluide, ma il sistema di difesa potrebbe essere più intuitivo.", 4.7, 217, 60),
("Un buon capitolo, ma non il migliore", "FC 24 è sicuramente un buon gioco, ma non riesce a sorprendere come i suoi predecessori. La parte online è divertente, ma la parte manageriale potrebbe essere migliorata.", 4.6, 217, 70),
("Divertente, ma ripetitivo", "Il gameplay è molto solido, ma le modalità di gioco rischiano di diventare ripetitive dopo un po'. Tuttavia, la parte grafica e le animazioni sono incredibili.", 4.5, 217, 80),
("Un gioco per tutti gli amanti del calcio", "FC 24 è un must-have per gli appassionati di calcio. Le modalità online sono molto divertenti, ma la parte offline ha ancora margini di miglioramento. In generale, è un gioco che offre molto divertimento.", 4.7, 217, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'evoluzione ben riuscita", "FC 25 segna una grande evoluzione nella serie, con nuove modalità di gioco e un gameplay fluido. La grafica è ancora migliore, ma alcune meccaniche di gioco potrebbero essere perfezionate per un'esperienza più immersiva.", 4.8, 218, 1),
("Ottima nuova iterazione", "FC 25 è un miglioramento significativo rispetto al precedente capitolo. Le animazioni sono più naturali e la fisica del pallone è più realistica, anche se alcuni bug persistono nelle partite online.", 4.7, 218, 10),
("Miglioramenti visivi e di gameplay", "FC 25 porta alcune innovazioni importanti, ma il gioco online potrebbe migliorare. Nonostante ciò, la grafica e il design complessivo sono fantastici. Un ottimo gioco, ma con margini di crescita.", 4.6, 218, 20),
("Un capitolo solido", "FC 25 migliora la serie in modo significativo, con nuove opzioni e modalità di gioco. Tuttavia, la ripetitività nelle modalità manageriali può diventare un po' noiosa. Resta comunque un buon gioco.", 4.7, 218, 30),
("La perfezione nei dettagli", "Ogni aspetto di FC 25 è curato nei minimi dettagli, dalla grafica ai movimenti dei giocatori. Purtroppo, la parte offline non è tanto profonda quanto quella online, che è comunque molto divertente.", 4.8, 218, 40),
("Innovazione al servizio del gameplay", "FC 25 riesce a innovare, portando nuove dinamiche al gameplay. Le partite online sono equilibrate, ma ci sono ancora alcuni problemi tecnici che potrebbero essere risolti con aggiornamenti futuri.", 4.6, 218, 50),
("Un'esperienza di calcio completa", "FC 25 offre un'esperienza di calcio completa, con modalità single player e multiplayer di alta qualità. Tuttavia, la difficoltà di alcune sfide manageriali può risultare frustrante.", 4.7, 218, 60),
("Tante novità, ma qualcosa manca", "FC 25 introduce molte novità, ma alcune modalità, come quella manageriale, non sono ancora abbastanza approfondite. Resta comunque un gioco che offre molte ore di divertimento, con una curva di apprendimento meno ripida.", 4.6, 218, 70),
("Sempre più realistico", "FC 25 è il gioco di calcio più realistico che abbia mai giocato, con un'intelligenza artificiale ben sviluppata e una grafica che lascia a bocca aperta. Purtroppo, alcuni problemi di lag online abbassano il voto complessivo.", 4.8, 218, 80),
("Un bel salto in avanti", "FC 25 è sicuramente un passo avanti per la serie. Il gameplay è fluido, ma alcune meccaniche potrebbero essere affinate. In ogni caso, un titolo che non delude mai.", 4.7, 218, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un bel passo in avanti", "FIFA 14 è un miglioramento rispetto ai precedenti capitoli, con una fisica della palla più realistica e un gameplay fluido. Tuttavia, la parte manageriale potrebbe essere più approfondita.", 4.6, 210, 1),
("Miglioramenti evidenti", "La grafica e le animazioni sono migliorate molto, ma alcuni bug nei match online rovinano l'esperienza. È comunque un gioco divertente e ben progettato.", 4.5, 210, 10),
("Un ottimo capitolo della serie", "FIFA 14 porta diverse novità, come nuove modalità di gioco e una maggiore immersione. Purtroppo, la difficoltà in alcune modalità di gioco potrebbe non piacere a tutti.", 4.7, 210, 20),
("Un'esperienza migliorata", "Il gameplay è stato notevolmente migliorato rispetto al passato, ma il sistema di difesa può sembrare poco intuitivo. Nonostante ciò, FIFA 14 rimane uno dei migliori giochi sportivi.", 4.6, 210, 30),
("Non perfetto, ma divertente", "FIFA 14 ha tante cose positive, come la grafica e le modalità di gioco, ma il matchmaking online è ancora da affinare. Non è perfetto, ma è comunque molto divertente.", 4.5, 210, 40),
("Il calcio come dovrebbe essere", "FIFA 14 offre una simulazione calcistica davvero realistica. Le animazioni dei giocatori sono ottime, ma la parte manageriale del gioco non offre abbastanza opzioni.", 4.6, 210, 50),
("Un buon inizio", "FIFA 14 segna un buon inizio per la serie, ma alcuni aspetti come l'intelligenza artificiale dei difensori potrebbero essere migliorati. La modalità carriera è interessante, ma potrebbe essere più approfondita.", 4.4, 210, 60),
("Molto realistico, ma non perfetto", "La fisica del pallone e la grafica sono fantastiche, ma il gioco a volte può sembrare troppo facile. La difficoltà nella modalità carriera è un po' sbilanciata, ma è comunque un gioco valido.", 4.5, 210, 70),
("Manca qualcosa", "FIFA 14 è un buon gioco, ma non raggiunge le aspettative di molti. La modalità manageriale è troppo limitata e la parte multiplayer soffre di alcuni bug.", 4.3, 210, 80),
("Un classico intramontabile", "FIFA 14 è un gioco che non delude mai. Anche se ha i suoi difetti, come il sistema di collisione, resta comunque uno dei titoli calcistici più divertenti e realistici mai creati.", 4.7, 210, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'evoluzione importante", "FIFA 17 segna una grande evoluzione con la modalità The Journey e un gameplay molto migliorato. Tuttavia, il sistema di intelligenza artificiale potrebbe essere affinato ulteriormente.", 4.8, 211, 1),
("Un ottimo passo avanti", "FIFA 17 è una ventata di freschezza nella serie, grazie a nuove modalità e miglioramenti nella fisica della palla. Tuttavia, il matchmaking online non è sempre equilibrato.", 4.7, 211, 10),
("Grande novità con The Journey", "The Journey è una delle novità migliori di FIFA 17, portando una nuova esperienza narrativa al gioco. La grafica è migliorata, ma alcuni bug nel gioco online rovinano l'esperienza.", 4.6, 211, 20),
("FIFA 17 migliora su tutti i fronti", "FIFA 17 è sicuramente un miglioramento rispetto ai precedenti, con un gameplay più realistico e l'introduzione di The Journey. Purtroppo, alcuni aspetti come l'intelligenza artificiale dei difensori potrebbero essere migliorati.", 4.7, 211, 30),
("La nuova modalità The Journey è fantastica", "La nuova modalità carriera con il protagonista Alex Hunter è davvero interessante. FIFA 17 è migliorato molto rispetto ai suoi predecessori, ma alcuni bug e la ripetitività nelle partite online abbassano il voto.", 4.6, 211, 40),
("Un gioco che non delude mai", "FIFA 17 ha portato tante novità, inclusa una modalità carriera davvero coinvolgente. La grafica è straordinaria, ma la modalità multiplayer ha bisogno di miglioramenti.", 4.7, 211, 50),
("Innovazioni che piacciono", "The Journey è la grande innovazione di FIFA 17. Il gioco ha anche migliorato il gameplay, ma ci sono ancora margini di miglioramento per quanto riguarda l'interazione tra i giocatori in campo.", 4.6, 211, 60),
("Il miglior FIFA degli ultimi anni", "FIFA 17 ha portato il calcio virtuale a un altro livello, con una nuova modalità carriera e una fisica della palla straordinaria. Purtroppo, il matchmaking online non è sempre soddisfacente.", 4.8, 211, 70),
("Non senza difetti", "FIFA 17 ha migliorato la serie, ma non è privo di difetti. La modalità The Journey è fantastica, ma alcune meccaniche di gioco potrebbero essere più fluide.", 4.5, 211, 80),
("Un FIFA che sa divertire", "FIFA 17 riesce a divertire come pochi altri titoli. La modalità carriera è interessante, ma ci sono ancora margini di miglioramento, specialmente per la parte manageriale e la difficoltà.", 4.7, 211, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco che migliora ogni anno", "FIFA 18 è un altro passo in avanti per la serie, con una grafica migliorata e una maggiore fluidità. Tuttavia, alcune modalità di gioco non sono molto diverse rispetto ai capitoli precedenti.", 4.6, 212, 1),
("FIFA 18 fa il suo dovere", "Nonostante non porti novità significative, FIFA 18 è un buon gioco con ottime animazioni e una fisica migliorata. La modalità carriera è ancora interessante, ma si potrebbe fare di più.", 4.5, 212, 10),
("Un buon capitolo, ma non eccellente", "FIFA 18 è un gioco ben fatto, ma non innovativo come sperato. La modalità multiplayer è solida, ma ci sono ancora problemi di matchmaking e il gameplay a volte può sembrare ripetitivo.", 4.4, 212, 20),
("Molto simile al precedente", "FIFA 18 non ha portato grandi cambiamenti rispetto al suo predecessore, ma la qualità del gioco rimane alta. Il sistema di dribbling è migliorato, ma l'intelligenza artificiale potrebbe fare di più.", 4.5, 212, 30),
("Non è un FIFA indimenticabile", "FIFA 18 non offre molte novità, ma riesce comunque a essere divertente. La parte manageriale potrebbe essere più approfondita e la modalità carriera non è cambiata molto.", 4.3, 212, 40),
("Il calcio virtuale è sempre migliore", "FIFA 18 è un titolo che piacerà agli amanti della serie, ma non porterà nulla di particolarmente nuovo. La modalità online è solida, ma la difficoltà in alcune modalità può sembrare squilibrata.", 4.6, 212, 50),
("Lento ma costante miglioramento", "FIFA 18 continua la tradizione di offrire un calcio virtuale realistico, ma manca di novità significative. Alcuni bug online e una modalità carriera un po' troppo semplice penalizzano il voto finale.", 4.4, 212, 60),
("Un passo in avanti", "Non ci sono cambiamenti radicali in FIFA 18, ma i miglioramenti nel gameplay e nella grafica lo rendono comunque un buon gioco. La modalità carriera, purtroppo, non ha subito grosse modifiche.", 4.5, 212, 70),
("FIFA sempre una garanzia", "FIFA 18 è il solito buon gioco calcistico, ma manca di innovazione. Le animazioni sono eccellenti e il gioco è fluido, ma la parte manageriale è troppo superficiale.", 4.6, 212, 80),
("FIFA 18: Buono ma non sorprendente", "FIFA 18 fa il suo dovere, ma non riesce a sorprendere come alcuni capitoli precedenti. La parte online è ben realizzata, ma la modalità carriera è un po' noiosa.", 4.4, 212, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un FIFA da non perdere", "FIFA 19 introduce novità interessanti come il sistema di dribbling avanzato e miglioramenti nella modalità carriera. Tuttavia, la parte online è ancora un po' instabile.", 4.7, 213, 1),
("Molto divertente, ma...", "FIFA 19 è un gioco che offre un buon divertimento, ma ci sono ancora problemi con il sistema di difesa. Alcuni bug nei match online possono anche essere frustranti.", 4.5, 213, 10),
("L'alto livello della serie FIFA", "FIFA 19 è un altro capitolo di successo per la serie. Le animazioni dei giocatori sono ancora migliorate, ma il sistema di intelligenza artificiale potrebbe essere ulteriormente affinato.", 4.6, 213, 20),
("Siamo sulla strada giusta", "FIFA 19 porta il calcio virtuale a un altro livello, con nuovi movimenti e un gameplay più naturale. Tuttavia, il sistema di difficoltà non sembra equilibrato in tutte le modalità di gioco.", 4.6, 213, 30),
("Un buon FIFA, ma con margini di miglioramento", "FIFA 19 è un gioco solido, ma non perfetto. La nuova modalità “Champions League” è un'aggiunta interessante, ma ci sono ancora bug e problemi di matchmaking online.", 4.5, 213, 40),
("Sempre meglio", "FIFA 19 è una versione migliorata del gioco, con nuove modalità e miglioramenti nelle animazioni, ma alcuni difetti persistono, soprattutto nella parte multiplayer.", 4.6, 213, 50),
("Divertente ma con qualche difetto", "FIFA 19 è molto divertente, ma non è esente da problemi. L'intelligenza artificiale dei difensori e alcuni bug online abbassano un po' il voto finale.", 4.4, 213, 60),
("FIFA 19 è in miglioramento", "Il gioco ha fatto passi avanti rispetto ai suoi predecessori, ma ci sono ancora piccoli problemi con la modalità carriera e l'esperienza online non è perfetta.", 4.5, 213, 70),
("Piacevole, ma manca qualcosa", "FIFA 19 è un buon gioco calcistico, ma alcuni aspetti della carriera e del gameplay potrebbero essere migliorati. La modalità Champions League è sicuramente un'aggiunta interessante.", 4.6, 213, 80),
("FIFA 19: Un altro capitolo solido", "FIFA 19 è un gioco calcistico ben realizzato, ma non presenta novità significative rispetto ai capitoli precedenti. La parte multiplayer potrebbe beneficiare di qualche miglioramento.", 4.5, 213, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("FIFA 20: Grande potenziale, ma...", "FIFA 20 introduce una nuova modalità volta a rendere il calcio più realistico, ma ci sono ancora alcune problematiche con la difesa e il bilanciamento del gioco online.", 4.5, 214, 1),
("Un capitolo che delude", "FIFA 20 presenta una modalità VOLTA interessante, ma la mancanza di innovazione nelle modalità tradizionali rende il gioco meno entusiasmante rispetto ai precedenti.", 4.2, 214, 10),
("Il calcio è sempre bello", "FIFA 20 offre un gameplay che finalmente si avvicina a un'esperienza più realistica, ma la parte online lascia molto a desiderare. Potevano fare di più in termini di gameplay", 4.4, 214, 20),
("Un buon FIFA, ma non il migliore", "FIFA 20 presenta la nuova modalità VOLTA, che è un buon esperimento, ma non basta a fare la differenza rispetto ai precedenti capitoli della serie.", 4.3, 214, 30),
("Divertente ma con difetti", "FIFA 20 ha migliorato la fluidità del gioco, ma ha ancora dei problemi con la difesa e l'intelligenza artificiale. La modalità VOLTA è interessante ma non abbastanza per fare da sola.", 4.5, 214, 40),
("FIFA 20 ha perso un po' di magia", "FIFA 20 è divertente, ma non ci sono innovazioni davvero entusiasmanti. La modalità carriera e il sistema di matchmaking online sono ancora migliorabili.", 4.4, 214, 50),
("Siamo sulla strada giusta", "FIFA 20 tenta di offrire qualcosa di nuovo con VOLTA, ma la modalità principale non cambia molto. È comunque un buon gioco per gli amanti della serie.", 4.5, 214, 60),
("Un buon FIFA", "FIFA 20 non è perfetto, ma offre delle modalità di gioco interessanti. La parte online potrebbe essere più stabile, ma il gameplay e la grafica sono comunque molto belli.", 4.6, 214, 70),
("Buon miglioramento, ma ancora troppo simile", "FIFA 20 non apporta modifiche radicali, ma la nuova modalità VOLTA è divertente. Rimangono comunque alcune problematiche di bilanciamento e IA.", 4.4, 214, 80),
("FIFA 20: Rinnovato, ma non abbastanza", "La nuova modalità VOLTA è un'interessante aggiunta, ma non basta per rendere FIFA 20 un gioco veramente diverso dai suoi predecessori. Ci sono ancora problemi da sistemare.", 4.3, 214, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("FIFA 21: Non cambia molto", "FIFA 21 è simile al suo predecessore, ma non ci sono innovazioni significative. La modalità carriera è divertente, ma la parte online ha bisogno di più stabilità.", 4.3, 215, 1),
("Soli miglioramenti marginali", "FIFA 21 è comunque un buon gioco, ma non offre innovazioni particolarmente interessanti. La modalità carriera e le animazioni sono ben fatte, ma manca di novità.", 4.5, 215, 10),
("Non perfetto, ma divertente", "FIFA 21 è divertente e le nuove modalità sono interessanti, ma ci sono ancora alcuni problemi di gameplay e la parte online è un po' instabile.", 4.4, 215, 20),
("Miglioramenti lenti", "FIFA 21 è simile al suo predecessore, con qualche miglioria qua e là, ma non c'è nulla di rivoluzionario. La parte online continua a essere il punto dolente.", 4.3, 215, 30),
("Un FIFA solido, ma non sorprendente", "FIFA 21 offre un'esperienza calcistica solida, ma senza grandi sorprese. Alcuni bug persistono, ma nel complesso è un buon gioco per gli amanti della serie.", 4.6, 215, 40),
("FIFA 21 è più che sufficiente", "Non ci sono grandi novità in FIFA 21, ma i miglioramenti nelle animazioni e nella fluidità del gioco sono apprezzabili. La parte online può ancora migliorare.", 4.5, 215, 50),
("Nessuna rivoluzione", "FIFA 21 non porta nulla di nuovo e non è il gioco che speravamo, ma riesce comunque a offrire un'esperienza calcistica solida. Alcuni problemi persistono nella modalità carriera e online.", 4.4, 215, 60),
("Divertente ma non innovativo", "FIFA 21 è un buon gioco calcistico, ma non ci sono cambiamenti abbastanza significativi da giustificare l'acquisto rispetto al precedente capitolo.", 4.5, 215, 70),
("FIFA 21: Buon gioco, ma nulla di eccezionale", "FIFA 21 non ha le innovazioni che ci si aspettava, ma è comunque un gioco ben realizzato. Gli appassionati di FIFA apprezzeranno comunque le nuove modalità e l'esperienza complessiva.", 4.3, 215, 80),
("Manca qualcosa", "FIFA 21 è un buon gioco, ma non ha il “wow factor” di altri capitoli della serie. La modalità carriera è migliorata, ma l'esperienza complessiva è simile a quella del passato.", 4.4, 215, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("FIFA 22 è un passo avanti", "FIFA 22 migliora alcuni aspetti del gioco, come l'intelligenza artificiale e la fluidità. Tuttavia, il gameplay rimane in gran parte simile al precedente capitolo.", 4.6, 216, 1),
("Finalmente un passo avanti", "FIFA 22 offre alcune innovazioni che migliorano l'esperienza di gioco, ma non sono sufficienti per giustificare un grande cambiamento. La parte online è solida ma non perfetta.", 4.5, 216, 10),
("FIFA 22 ha bisogno di una revisione", "Nonostante il miglioramento nelle animazioni e nell'IA, FIFA 22 non è un gioco che innova abbastanza. La modalità carriera è interessante, ma potrebbe essere più approfondita.", 4.3, 216, 20),
("Un altro FIFA senza sorprese", "FIFA 22 continua sulla strada dei miglioramenti marginali. La grafica e l'intelligenza artificiale sono migliorate, ma la parte online è ancora poco stabile e la carriera ha bisogno di più profondità.", 4.4, 216, 30),
("Un gioco divertente ma con difetti", "FIFA 22 è divertente, ma la modalità carriera è poco coinvolgente e il matchmaking online potrebbe essere migliorato. Le animazioni sono comunque eccellenti.", 4.5, 216, 40),
("Buon miglioramento, ma non abbastanza", "FIFA 22 è sicuramente migliore rispetto a FIFA 21, ma non ci sono innovazioni rivoluzionarie. La modalità carriera è interessante ma può essere migliorata.", 4.6, 216, 50),
("FIFA 22 fa il suo dovere", "FIFA 22 fa il suo lavoro nel fornire un'esperienza calcistica solida, ma non è un gioco che rivoluziona la serie. La parte online ha bisogno di più attenzione.", 4.5, 216, 60),
("Un FIFA che sembra stanco", "FIFA 22 non è malvagio, ma non offre novità significative rispetto ai suoi predecessori. Le modalità di gioco sono divertenti, ma c'è poca innovazione.", 4.4, 216, 70),
("FIFA 22 è la stessa storia", "FIFA 22 offre miglioramenti tecnici e alcune modifiche alla modalità carriera, ma nel complesso è un gioco che non si distacca molto dai capitoli precedenti della serie.", 4.3, 216, 80),
("Ottimo, ma manca ancora qualcosa", "FIFA 22 è uno dei migliori giochi calcistici, ma non ci sono grandi cambiamenti rispetto ai capitoli precedenti. La parte online è solida ma non perfetta.", 4.5, 216, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("FIFA 23: Il miglior FIFA", "FIFA 23 offre un'esperienza calcistica migliorata con animazioni più fluide e un'intelligenza artificiale più raffinata. La parte online è stabile, ma la modalità carriera potrebbe essere più profonda.", 4.7, 78, 1),
("Ottimo, ma migliorabile", "FIFA 23 è un passo avanti rispetto al passato, con un miglioramento nelle meccaniche di gioco e nelle animazioni. Tuttavia, la modalità carriera può ancora migliorare in termini di profondità e personalizzazione.", 4.6, 78, 10),
("Molto divertente ma con margini di miglioramento", "FIFA 23 è un gioco eccellente, ma la parte online continua a non essere stabile al 100%. Le animazioni sono ottime, ma la modalità carriera necessita di maggiore varietà.", 4.5, 78, 20),
("FIFA 23 è il solito FIFA", "FIFA 23 porta piccoli miglioramenti, ma la formula è sempre la stessa. La parte online funziona bene, ma la modalità carriera ha ancora margini di miglioramento.", 4.4, 78, 30),
("Ottimi miglioramenti ma manca innovazione", "FIFA 23 ha migliorato il gameplay, ma non ci sono cambiamenti radicali. La modalità carriera è ancora interessante, ma avrebbe potuto essere più innovativa.", 4.5, 78, 40),
("FIFA 23: Ottimo gameplay, ma non rivoluzionario", "FIFA 23 è un buon gioco con ottimi miglioramenti nel gameplay e nella grafica, ma non riesce a fare un salto evolutivo significativo rispetto ai capitoli precedenti.", 4.6, 78, 50),
("Poca innovazione", "FIFA 23 è molto simile ai precedenti capitoli. La grafica è migliorata, ma manca quel “wow” che ci si aspettava da un nuovo capitolo della serie. La parte online è buona, ma la carriera è rimasta stagnante.", 4.3, 78, 60),
("FIFA 23 è un buon gioco", "FIFA 23 è un buon gioco calcistico, ma non riesce a fare il salto di qualità che molti si aspettavano. La parte online è stabile, ma la modalità carriera rimane troppo simile ai precedenti capitoli.", 4.4, 78, 70),
("Divertente ma privo di novità", "FIFA 23 è divertente come sempre, ma non offre particolari innovazioni rispetto al passato. La parte online funziona bene, ma la carriera può essere migliorata.", 4.5, 78, 80),
("Un buon FIFA, ma non il migliore", "FIFA 23 è sicuramente uno dei migliori capitoli della serie, ma manca quella spinta innovativa che avrebbe dovuto fare la differenza. Comunque, resta un gioco calcistico di qualità.", 4.5, 78, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Final Fantasy VII Remake: Un capolavoro", "Final Fantasy VII Remake è un gioco eccezionale con una trama coinvolgente, grafica mozzafiato e un sistema di combattimento fantastico. Un must per i fan del gioco originale!", 5.0, 27, 1),
("Una rivisitazione fantastica", "FFVII Remake riporta alla luce la magia del gioco originale con una grafica sorprendente e un gameplay aggiornato. La storia è ancora incredibile, ma avrei voluto vedere più parti del gioco originale.", 4.8, 27, 10),
("Un remake che vale la pena", "Final Fantasy VII Remake ha aggiornato il classico con una nuova esperienza più dinamica e moderna. Nonostante alcune scelte di trama discutibili, è un gioco che i fan apprezzeranno sicuramente.", 4.7, 27, 20),
("Final Fantasy VII Remake: Imperdibile per i fan", "FFVII Remake è il miglior remake che potessero fare. Con una trama avvincente e un combattimento spettacolare, è un gioco che ogni fan della serie deve giocare.", 4.9, 27, 30),
("Un'avventura emozionante", "La grafica e il gameplay di FFVII Remake sono semplicemente fantastici, ma mi sarebbe piaciuto che avessero mantenuto un po' di più dello stile originale. La trama è comunque epica e coinvolgente.", 4.8, 27, 40),
("Un grande remake", "FFVII Remake riesce a mantenere la magia dell'originale, pur aggiornando il gioco per le nuove generazioni. Non è perfetto, ma è sicuramente un'esperienza che vale la pena vivere.", 4.7, 27, 50),
("Bellissimo, ma incompleto", "Final Fantasy VII Remake è uno dei giochi più belli che abbia mai giocato, ma mi ha lasciato con la sensazione di non aver vissuto tutta la storia. Aspetto con ansia il seguito!", 4.6, 27, 60),
("Un remake che supera le aspettative", "Final Fantasy VII Remake è un gioco stupendo che riesce a catturare l'essenza del titolo originale, pur portando alcune novità interessanti. Non vedo l'ora di giocare al prossimo capitolo!", 4.9, 27, 70),
("Un capolavoro moderno", "La qualità grafica, la musica e la storia sono semplicemente incredibili in FFVII Remake. Un gioco che farà battere il cuore di ogni appassionato di RPG e di Final Fantasy.", 5.0, 27, 80),
("Final Fantasy VII Remake: La nuova era", "FFVII Remake è il remake perfetto: bello, emozionante, e completamente coinvolgente. Un'avventura che consiglio a tutti, anche a chi non ha mai giocato al gioco originale.", 4.9, 27, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Final Fantasy XIV: Il miglior MMORPG", "FFXIV è senza dubbio il miglior MMORPG in circolazione. Con una storia coinvolgente, un sistema di gioco ben bilanciato e un supporto continuo da parte degli sviluppatori, è il gioco perfetto per chi ama il genere.", 5.0, 122, 1),
("Un MMORPG che non delude", "Final Fantasy XIV è un gioco che continua a migliorare. Con nuove espansioni e continui aggiornamenti, offre una delle esperienze di gioco online più complete e divertenti.", 4.9, 122, 10),
("Un MMORPG da non perdere", "FFXIV è il MMORPG che ogni appassionato del genere dovrebbe provare. La storia è fantastica e le modalità di gioco sono varie, ma richiede un po' di tempo per essere pienamente apprezzato.", 4.8, 122, 20),
("Final Fantasy XIV è un sogno per i fan dei MMORPG", "Con una storia epica e una comunità incredibile, FFXIV è il miglior MMORPG che esista. Le espansioni aggiungono tantissimo e continuano a mantenere il gioco fresco e interessante.", 5.0, 122, 30),
("Un'esperienza unica", "Final Fantasy XIV è il miglior gioco MMORPG al momento. La trama è fantastica, le espansioni sono grandiose, e la grafica è spettacolare. La curva di apprendimento è un po' ripida, ma ne vale la pena.", 4.7, 122, 40),
("FFXIV: Un gioco che ti conquista", "FFXIV ti cattura fin dal primo momento. La storia, la grafica e il gameplay sono fantastici. È uno dei giochi più coinvolgenti che abbia mai giocato, e continuo a giocarlo da anni.", 4.9, 122, 50),
("Il miglior MMORPG che ci sia", "Final Fantasy XIV è il gioco perfetto per chi ama i MMORPG. La comunità è fantastica, la storia è coinvolgente e ci sono tantissime cose da fare. Se ami il genere, devi provarlo.", 5.0, 122, 60),
("Incredibile, ma complesso", "FFXIV è un MMORPG magnifico, ma la curva di apprendimento può essere difficile all'inizio. Nonostante questo, una volta che entri nel gioco, non vorrai più smettere di giocare.", 4.8, 122, 70),
("Una gemma da scoprire", "Final Fantasy XIV è un gioco incredibile che continua a crescere. Se ami gli MMORPG, non puoi perderlo. Ha tantissime espansioni e una storia che ti terrà incollato al monitor per ore.", 4.9, 122, 80),
("Final Fantasy XIV: Il capolavoro del MMORPG", "FFXIV è il miglior MMORPG mai creato. Con un mondo ricco di dettagli, una trama emozionante e una comunità che rende il gioco ancora più speciale, è un'esperienza che consiglio a tutti.", 5.0, 122, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Final Fantasy XV: Un viaggio emozionante", "Final Fantasy XV offre un mondo aperto incredibile e un sistema di combattimento dinamico. Nonostante alcune scelte di trama discutibili, è un gioco che vale assolutamente la pena giocare.", 4.7, 59, 1),
("Una grande avventura", "FFXV è un'avventura epica che riesce a catturare il cuore del giocatore. La trama è coinvolgente e la grafica è spettacolare. Tuttavia, la parte finale potrebbe essere migliorata.", 4.8, 59, 10),
("Un gioco magnifico, ma con qualche difetto", "FFXV ha una storia incredibile e un gameplay entusiasmante, ma soffre di alcuni difetti nel ritmo e nelle missioni secondarie. Il finale è un po' troppo affrettato.", 4.6, 59, 20),
("Un viaggio indimenticabile", "La storia di FFXV è emozionante e i personaggi sono molto ben sviluppati. Nonostante alcune pecche nel gameplay, il gioco riesce comunque a far vivere un'esperienza unica.", 4.7, 59, 30),
("Final Fantasy XV: La fine di un'era", "FFXV segna la fine di una saga, e lo fa con stile. Il mondo di gioco è vasto e ricco di contenuti, ma alcune scelte narrative non sono all'altezza delle aspettative.", 4.5, 59, 40),
("Un'esperienza molto divertente", "Nonostante i suoi difetti, FFXV è un gioco che non delude. La grafica è fantastica e il gameplay è divertente. I personaggi sono ben scritti e la storia è coinvolgente.", 4.6, 59, 50),
("Molto bello, ma non perfetto", "FFXV è un gioco che offre molte ore di intrattenimento. La trama è buona, ma avrebbe potuto essere più coesa. Nonostante questo, è sicuramente un gioco che consiglio a tutti.", 4.6, 59, 60),
("Storia emozionante, ma gameplay migliorabile", "FFXV ha una delle storie più emozionanti della saga di Final Fantasy, ma il gameplay è meno interessante rispetto ad altri capitoli della serie. La libertà offerta dal mondo aperto è fantastica.", 4.5, 59, 70),
("FFXV: Un gioco da provare", "Final Fantasy XV offre un'avventura coinvolgente, ma presenta anche alcuni problemi nel ritmo e nella gestione della trama. Non è perfetto, ma ha comunque molto da offrire.", 4.7, 59, 80),
("Final Fantasy XV: Il sogno di Noctis", "FFXV è un gioco che non ti lascia mai annoiare. Il mondo è grande e ricco di segreti, ma alcune missioni secondarie possono risultare ripetitive. Comunque, è un titolo che ogni fan dovrebbe giocare.", 4.8, 59, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Final Fantasy XVI: Un capolavoro", "Final Fantasy XVI è un capolavoro visivo e narrativo. La storia è coinvolgente, i combattimenti sono dinamici e il mondo di gioco è spettacolare. Un gioco da non perdere!", 5.0, 26, 1),
("Un'esperienza fantastica", "FFXVI ha una trama fantastica e un gameplay che ti tiene incollato allo schermo. La grafica è incredibile, ma la parte RPG potrebbe essere più profonda. Comunque, è un gioco che vale assolutamente la pena giocare.", 4.8, 26, 10),
("Un altro grande capitolo", "FFXVI è un ottimo capitolo della serie. La storia è coinvolgente e i combattimenti sono estremamente dinamici, ma la personalizzazione dei personaggi potrebbe essere migliorata.", 4.7, 26, 20),
("Final Fantasy XVI: Non delude", "FFXVI è un gioco che non delude le aspettative. La grafica è incredibile, la storia è emozionante, ma a volte il gameplay può sembrare troppo lineare. Comunque, è un must per i fan della serie.", 4.9, 26, 30),
("Un'esperienza indimenticabile", "FFXVI è il migliore capitolo della saga da anni. La trama è profonda, i combattimenti sono fluidi, ma la parte RPG è un po' più leggera rispetto ai giochi precedenti.", 4.8, 26, 40),
("Un grande gioco, ma con qualche difetto", "Final Fantasy XVI è un gioco spettacolare con una trama che ti tiene incollato. Tuttavia, mi sarebbe piaciuto avere più opzioni di personalizzazione e una maggiore libertà nelle decisioni.", 4.7, 26, 50),
("Molto bello, ma non perfetto", "FFXVI è un gioco stupendo dal punto di vista grafico e narrativo. Tuttavia, alcuni aspetti del gameplay possono sembrare ripetitivi e la personalizzazione è limitata.", 4.6, 26, 60),
("Final Fantasy XVI: Una nuova era", "FFXVI segna un nuovo capitolo per la saga, con una trama più matura e una grafica spettacolare. Nonostante ciò, alcuni fan potrebbero sentirsi disorientati dal cambiamento del gameplay.", 4.7, 26, 70),
("FFXVI è spettacolare", "Final Fantasy XVI è un gioco che merita tutta la fama che ha ricevuto. La storia è incredibile e i combattimenti sono divertenti, ma la gestione delle missioni secondarie potrebbe essere migliore.", 4.8, 26, 80),
("Un gioco che non delude", "Final Fantasy XVI è uno dei migliori giochi di ruolo degli ultimi anni. La trama è coinvolgente, i personaggi sono ben sviluppati e i combattimenti sono incredibili. Non vedo l'ora di vedere cosa succederà nei prossimi capitoli.", 4.9, 26, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Fire Emblem: Three Houses: Una strategia eccezionale", "Fire Emblem: Three Houses è un capolavoro della strategia. La trama è profonda, le scelte sono significative e il gameplay è molto coinvolgente. Un must per ogni fan della serie!", 5.0, 183, 1),
("Un gioco strategico da non perdere", "Three Houses offre una combinazione perfetta di combattimento tattico e narrazione. Le scelte che fai influenzano davvero la storia, e questo lo rende un gioco che si può giocare più volte senza annoiarsi.", 4.9, 183, 10),
("Fire Emblem: Three Houses è fantastico", "La profondità del gameplay e la varietà di scelte narrative lo rendono uno dei migliori giochi di strategia. Tuttavia, alcune missioni possono sembrare ripetitive.", 4.8, 183, 20),
("Un capolavoro tattico", "Fire Emblem: Three Houses ha una trama incredibile e un sistema di combattimento strategico che ti tiene impegnato per ore. Le decisioni che prendi durante il gioco sono fondamentali, e ogni percorso offre nuove sorprese.", 5.0, 183, 30),
("Una delle migliori esperienze strategiche", "Three Houses è uno dei migliori giochi di strategia che abbia mai giocato. Le sue meccaniche sono profonde e le opzioni di personalizzazione sono enormi. Un gioco che ogni appassionato di RPG e tattica dovrebbe giocare.", 4.9, 183, 40),
("Molto divertente, ma con margini di miglioramento", "Il gameplay di Three Houses è fantastico, ma alcuni livelli di difficoltà possono sembrare troppo facili, soprattutto dopo aver acquisito familiarità con le meccaniche del gioco.", 4.7, 183, 50),
("Un gioco incredibile", "Three Houses è una combinazione perfetta di strategia e storytelling. Ogni scelta che fai ha un impatto sulla storia, e le diverse case offrono esperienze completamente diverse.", 5.0, 183, 60),
("Un gioco fantastico ma impegnativo", "Three Houses è un gioco che richiede pazienza e strategia. La storia è emozionante, ma il gameplay può risultare difficile da padroneggiare all'inizio. Un must per gli amanti della strategia.", 4.8, 183, 70),
("Fire Emblem: Three Houses è fenomenale", "Questo gioco è un must per chi ama la strategia. Ogni scelta nella storia sembra pesare, e le battaglie sono sempre coinvolgenti. Non vedo l'ora di giocare alla prossima versione!", 4.9, 183, 80),
("Un'esperienza unica nel suo genere", "Three Houses offre una trama ricca di scelte e conseguenze. Il gameplay tattico è profondo e gratificante, e ogni personaggio ha una propria storia interessante.", 4.9, 183, 90);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Fire Emblem: Warriors: Un ottimo spin-off", "Fire Emblem: Warriors è un gioco d'azione che mescola la strategia della saga principale con combattimenti frenetici. Ottimo per chi ama il combattimento in stile musou, ma perde parte della profondità della serie principale.", 4.3, 40, 1),
("Un gioco d'azione divertente", "Nonostante Fire Emblem: Warriors non abbia la stessa profondità strategica dei titoli principali della serie, è comunque un gioco molto divertente con un buon numero di personaggi e missioni.", 4.5, 40, 10),
("Molto divertente, ma ripetitivo", "Il gioco è divertente e pieno di azione, ma a lungo andare le missioni possono diventare un po' ripetitive. Comunque, i fan di Fire Emblem e dei giochi musou troveranno molto da apprezzare.", 4.2, 40, 20),
("Un buon spin-off", "Fire Emblem: Warriors è un buon spin-off, ma manca della profondità che rende unica la serie principale. Tuttavia, i combattimenti sono spettacolari e i fan dei musou si divertono sicuramente.", 4.4, 40, 30),
("Un'esperienza divertente, ma poco profonda", "Il gameplay di Fire Emblem: Warriors è molto divertente, ma non offre la stessa complessità strategica di altri titoli della saga. Se ti piacciono i giochi d'azione veloci, vale la pena provarlo.", 4.3, 40, 40),
("Divertente, ma non per tutti", "Fire Emblem: Warriors è divertente per i fan delle battaglie veloci e dell'azione, ma se cerchi la profondità tipica dei giochi di strategia, questo non fa per te.", 4.1, 40, 50);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("For the King: Un gioco di strategia e cooperazione", "For the King è un gioco di ruolo strategico che richiede cooperazione tra i giocatori. La difficoltà aumenta gradualmente e la varietà di scelte rende ogni partita unica.", 4.6, 51, 1),
("Un gioco cooperativo fantastico", "La combinazione di esplorazione, combattimento a turni e strategia rende For the King un'esperienza avvincente. La cooperazione tra i giocatori è fondamentale per avere successo.", 4.7, 51, 10),
("Strategico ma frustrante", "For the King è un gioco molto strategico, ma alcune meccaniche possono risultare frustranti, soprattutto nelle partite in solitario. La cooperazione è davvero importante per godere appieno del gioco.", 4.4, 51, 20),
("Un bel gioco di strategia", "For the King è un gioco che sfida il giocatore a prendere decisioni difficili in un mondo generato proceduralmente. Le meccaniche di gioco sono solide e offre molte ore di divertimento.", 4.6, 51, 30),
("Un gioco di ruolo solido", "For the King è un gioco di ruolo che ti permette di esplorare un mondo ricco di pericoli e sfide. La modalità cooperativa aggiunge una dimensione in più al gioco, ma a volte può essere difficile da gestire.", 4.5, 51, 40),
("Più difficile di quanto sembri", "For the King è un gioco di strategia che ti mette alla prova. Ogni partita è diversa, ma la difficoltà è spesso elevata, specialmente quando si gioca in solitaria.", 4.3, 51, 50);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Forza Horizon 4: La migliore esperienza di guida", "Forza Horizon 4 è un capolavoro di gioco di corse. Il mondo aperto è vasto e bellissimo, le auto sono fantastiche e il sistema di progressione è coinvolgente. È il miglior gioco di corse degli ultimi anni.", 5.0, 234, 1),
("Un gioco da sogno per gli appassionati di corse", "Forza Horizon 4 è semplicemente incredibile. La grafica è mozzafiato e il gameplay è impeccabile. Non c'è niente di meglio di correre per le strade della Gran Bretagna in una Ferrari.", 4.9, 234, 10),
("Il miglior gioco di corse open-world", "Forza Horizon 4 offre un mondo aperto stupendo da esplorare e un gameplay di guida che è sia divertente che realista. La varietà di auto e eventi è impressionante.", 4.8, 234, 20),
("Un gioco che non delude mai", "Forza Horizon 4 è il miglior gioco di corse open-world che abbia mai giocato. Ogni gara è emozionante e la personalizzazione delle auto è molto profonda. Un must per ogni amante delle corse.", 5.0, 234, 30),
("Stupendo, ma con piccoli difetti", "Forza Horizon 4 è incredibile, ma la difficoltà nelle gare può variare troppo, rendendo alcune esperienze frustranti. Nonostante questo, il gioco è ancora fantastico.", 4.7, 234, 40),
("Il miglior gioco di guida di sempre", "Forza Horizon 4 è il gioco di guida definitivo. La libertà di esplorare il mondo è eccezionale, e le gare sono sempre divertenti. I difetti sono minimi rispetto alla qualità complessiva del gioco.", 4.9, 234, 50);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Forza Horizon 5: Il miglior gioco di corse open-world", "Forza Horizon 5 è un gioco che definisce nuovi standard per i giochi di corse open-world. La grafica è incredibile, l'ambiente è ricco di dettagli e le corse sono sempre emozionanti.", 5.0, 81, 1),
("Un capolavoro della serie", "Forza Horizon 5 porta la serie a nuovi livelli. La varietà di auto e la vastità dell'ambiente open-world in Messico è fenomenale. Un gioco che non delude mai.", 4.9, 81, 10),
("Vibrante e spettacolare", "Il paesaggio messicano in Forza Horizon 5 è spettacolare, con ogni gara che ti fa sentire parte del mondo. È un'esperienza di guida che ti fa sognare.", 4.8, 81, 20),
("Il miglior gioco di corse mai creato", "Forza Horizon 5 è un gioco incredibile. La grafica, la varietà di eventi e la sensazione di guida sono senza pari. È un gioco che ti tiene impegnato per ore.", 5.0, 81, 30),
("Una corsa emozionante", "Forza Horizon 5 offre emozioni pure. Ogni corsa è diversa e offre nuove sfide, con una varietà di modalità che tengono sempre alta l'attenzione.", 4.7, 81, 40),
("Pura adrenalina", "La combinazione di grafica mozzafiato e gameplay coinvolgente rende Forza Horizon 5 un gioco straordinario. Le gare sono sempre intense, e l'esplorazione è entusiasmante.", 4.8, 81, 50),
("Perfetto per gli amanti delle corse", "Se ami i giochi di corse, Forza Horizon 5 è un must. La personalizzazione delle auto, il mondo aperto e la varietà di gare ti tengono incollato allo schermo per ore.", 4.9, 81, 60),
("Un'esperienza unica", "Forza Horizon 5 ti offre una sensazione di libertà unica grazie al suo vasto mondo aperto e alle tante modalità di gioco. Ogni corsa è un'avventura.", 4.7, 81, 70),
("Eccezionale sotto ogni punto di vista", "Forza Horizon 5 è eccezionale in tutti gli aspetti. La grafica, la varietà di contenuti, il gameplay fluido e la sensazione di velocità sono tutti perfetti. Un gioco che ogni appassionato di corse dovrebbe provare.", 5.0, 81, 80),
("Un capolavoro del racing", "Forza Horizon 5 è semplicemente un capolavoro. Non c'è niente di più divertente che sfrecciare attraverso il paesaggio messicano, con un'auto perfettamente personalizzata. Un gioco che ti fa tornare per una corsa dopo l'altra.", 4.9, 81, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Divertente ma caotico", "Il gioco è molto divertente, ma a volte può diventare frustrante per la sua natura caotica.", 4.00, 137, 1),
("Un po' ripetitivo", "La grafica è carina, ma le meccaniche di gioco sono un po' ripetitive, potrebbe essere migliorato.", 3.50, 137, 5),
("Divertimento puro", "Un gioco da giocare con gli amici, risate assicurate!", 5.00, 137, 10),
("Non mi ha convinto", "Non è il mio genere, ma posso capire perché potrebbe piacere ad altri.", 2.00, 137, 20),
("Troppo caos", "Ogni partita è un caos totale, non riesco a godermelo come vorrei.", 3.00, 137, 25),
("Una buona compagnia", "Ottimo per passare il tempo con gli amici, ma la giocabilità è migliorabile.", 4.00, 137, 35),
("Carino, ma noioso dopo un po'", "Dopo qualche ora di gioco, inizia a diventare noioso. Serve più varietà.", 3.00, 137, 40),
("Divertente e adrenalinico", "Mi piace molto, ogni partita è un adrenalina pura!", 4.50, 137, 50),
("Gioco di gruppo", "Perfetto per le serate in compagnia, non ci si annoia mai!", 5.00, 137, 60),
("Troppo caotico per i miei gusti", "Sinceramente, non mi piace l'eccessivo caos che crea.", 2.50, 137, 70);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Gioco fantastico", "Un gioco incredibile, la grafica è pazzesca e le missioni sono molto coinvolgenti.", 5.00, 28, 2),
("Un'esperienza unica", "Non ho mai visto un gioco free-to-play così bello, la storia è avvincente e la musica è magnifica.", 4.50, 28, 15),
("Pochi contenuti", "Nonostante la bellezza del gioco, dopo un po' inizia a mancare di contenuti per i giocatori più esperti.", 3.50, 28, 25),
("Troppo grind", "C'è troppo grinding, anche se il gioco è bello diventa stancante dopo un po' di tempo.", 3.00, 28, 30),
("Ottimo gioco", "Un gioco di ruolo fantastico, ma i sistemi di gacha sono un po' troppo invasivi.", 4.00, 28, 40),
("Storia interessante", "Mi piace molto la trama, ma il gioco è troppo orientato a spingere gli acquisti in-app.", 3.50, 28, 50),
("Un gioco straordinario", "Genshin Impact ha cambiato il mio modo di vedere i giochi open world, è spettacolare!", 5.00, 28, 60),
("Troppo dispendioso", "Il gioco è divertente ma alla fine devi spendere un sacco di soldi per ottenere i personaggi migliori.", 2.50, 28, 70),
("Bellissima grafica", "La grafica è il punto forte del gioco, davvero impressionante per essere un free-to-play.", 4.50, 28, 80),
("Molto coinvolgente", "La storia e la libertà di esplorazione sono fantastiche, ma può diventare pesante senza acquisti.", 4.00, 28, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Incredibile esperienza", "Un capolavoro, la storia e l'ambientazione sono magnifiche. Mi sono sentito parte del Giappone feudale.", 5.00, 6, 3),
("Stupendo ma corto", "Il gioco è bellissimo, ma la trama è troppo breve. Avrei voluto esplorare di più.", 4.00, 6, 7),
("Ottimo, ma non perfetto", "La grafica è superlativa e la storia è interessante, ma ci sono alcune meccaniche di gioco migliorabili.", 4.00, 6, 12),
("Un must per gli amanti degli open world", "La libertà di esplorazione è pazzesca, un gioco da non perdere!", 5.00, 6, 18),
("Non mi ha convinto del tutto", "Il gioco è bello, ma a volte le missioni possono diventare troppo simili tra loro.", 3.00, 6, 23),
("Miglior gioco dell'anno", "Ghost of Tsushima è uno dei migliori giochi che abbia mai giocato. La storia è emozionante e coinvolgente.", 5.00, 6, 33),
("Bellissima ambientazione", "Il Giappone feudale è reso magnificamente. La colonna sonora è fantastica!", 4.50, 6, 40),
("Alcuni difetti", "Purtroppo, la difficoltà non è ben bilanciata, ma resta un gioco ottimo per gli amanti del genere.", 3.50, 6, 47),
("Gioco fantastico, ma poco innovativo", "Mi è piaciuto molto, ma non offre nulla di nuovo rispetto ad altri giochi open world.", 3.00, 6, 55),
("Un gioco che ti coinvolge", "La storia e le missioni secondarie ti tengono incollato allo schermo. Fantastico!", 4.50, 6, 60);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro", "God of War è semplicemente perfetto, un mix di azione e emozioni che non si dimentica facilmente.", 5.00, 3, 5),
("L'unico God of War che mi è piaciuto", "Ho sempre evitato i God of War, ma questo mi ha sorpreso, una trama matura e ben raccontata.", 4.50, 3, 12),
("Un gioco di alta qualità", "La grafica e la storia sono straordinarie, ma alcuni combattimenti possono diventare ripetitivi.", 4.00, 3, 18),
("Il miglior God of War", "È il miglior capitolo della saga, Kratos è finalmente un personaggio profondo e interessante.", 5.00, 3, 25),
("Troppo lineare", "A me è piaciuto, ma alcuni tratti del gioco sono troppo lineari e manca un po' di libertà.", 3.50, 3, 35),
("Lotta tra padre e figlio", "La relazione tra Kratos e Atreus è toccante e molto ben sviluppata, davvero emozionante.", 5.00, 3, 40),
("Difficoltà troppo alta", "Il gioco è troppo difficile, alcune sezioni mi hanno frustato più che divertito.", 2.50, 3, 48),
("Un'avventura epica", "Non ci sono molte parole per descrivere quanto mi sia piaciuto questo gioco. Un'avventura che vale la pena vivere.", 5.00, 3, 53),
("Gioco intenso e coinvolgente", "La trama è fantastica, ma la parte di combattimento potrebbe essere migliorata in alcuni punti.", 4.00, 3, 61),
("Non per tutti", "Molto bello, ma non per tutti. La storia è profonda e un po' triste, non adatta ai gusti di tutti.", 3.00, 3, 70);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Non all'altezza dei predecessori", "Nonostante le meccaniche siano buone, la trama e la varietà non sono al livello degli altri giochi della saga.", 3.00, 226, 4),
("Buon gioco, ma manca qualcosa", "Il gameplay è divertente, ma la storia non è coinvolgente come quella dei capitoli precedenti.", 3.50, 226, 10),
("God of War ma non troppo", "Un capitolo che non riesce a convincere come gli altri, ma comunque intrattenente.", 3.00, 226, 15),
("Sufficiente ma deludente", "I combattimenti sono divertenti, ma la trama è troppo debole per essere veramente memorabile.", 2.50, 226, 20),
("Gioco solido, ma troppo simile", "Non c'è nulla di nuovo che spicca davvero, sembra più un DLC piuttosto che un capitolo vero e proprio.", 3.00, 226, 30),
("Un po' ripetitivo", "Il gioco ha alcune sequenze ripetitive e non riesce a mantenere alta la tensione per tutta la durata.", 3.50, 226, 40),
("Un capitolo che delude", "Sinceramente mi aspettavo di più, la storia non è all'altezza di altri giochi della saga.", 2.00, 226, 50),
("Sotto le aspettative", "Un gioco che non riesce a brillare, i combattimenti sono buoni ma la trama è un po' piatta.", 3.00, 226, 60),
("Gameplay solido", "Mi è piaciuto il gameplay ma la trama è troppo debole. Avrei voluto una storia più coinvolgente.", 3.50, 226, 70),
("Un buon gioco ma niente di speciale", "Il gioco è ok, ma manca quel qualcosa che mi ha fatto amare gli altri God of War.", 3.00, 226, 80);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Capolavoro assoluto", "Un gioco straordinario, storia e gameplay sono impeccabili. Un must per ogni appassionato della saga.", 5.00, 227, 5),
("Il miglior God of War", "Ragnarok ha alzato la barra. Non solo un gioco, ma un'esperienza che ti emoziona ad ogni momento.", 5.00, 227, 12),
("Storia epica", "La trama è coinvolgente, la grafica è sbalorditiva e il gameplay è perfetto. Un gioco imperdibile!", 5.00, 227, 20),
("Perfetto in tutto", "Non c'è nulla che non mi sia piaciuto di questo gioco. Storia, combattimenti, tutto perfetto.", 5.00, 227, 30),
("Eccezionale, ma...", "Il gioco è fantastico, ma alcune meccaniche sono un po' ripetitive. Tuttavia, vale assolutamente la pena giocarlo.", 4.50, 227, 40),
("Una conclusione epica", "Ragnarok conclude magnificamente la saga di Kratos, un gioco emozionante e ricco di sorprese.", 5.00, 227, 50),
("Semplicemente incredibile", "La qualità del gioco è sbalorditiva, ma il prezzo del gioco è un po' alto per quello che offre.", 4.00, 227, 60),
("Gioco di alta qualità", "Una conclusione degna della saga, ma alcuni dettagli potrebbero essere migliorati, soprattutto la gestione delle missioni secondarie.", 4.50, 227, 70),
("Un'epopea fantastica", "La storia e i combattimenti sono leggendari, ma mi sarebbe piaciuto un po' più di esplorazione.", 4.00, 227, 80),
("Gioco da ricordare", "Un'esperienza incredibile, ma ho trovato alcuni momenti un po' troppo lenti. Complessivamente, comunque, un capolavoro.", 4.50, 227, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco di simulazione perfetto", "Gran Turismo 7 è un capolavoro per gli amanti delle simulazioni di guida, tutto è perfetto e realistico.", 5.00, 82, 10),
("Esperienza realistica", "Il gioco offre una simulazione di guida incredibilmente realistica. Un sogno per gli appassionati di auto.", 5.00, 82, 20),
("Fantastico per gli appassionati", "Se ti piacciono le simulazioni di guida, non troverai di meglio. Il realismo è incredibile.", 5.00, 82, 30),
("Ottima esperienza di guida", "Il gameplay è fantastico, ma la varietà di auto e tracciati potrebbe essere migliorata.", 4.00, 82, 40),
("Simulazione top", "Gran Turismo 7 è il miglior simulatore di guida in circolazione. La cura nei dettagli è impressionante.", 5.00, 82, 50),
("Un po' noioso", "Il gioco è bello, ma dopo un po' può diventare un po' ripetitivo e manca di varietà nelle sfide.", 3.50, 82, 60),
("La simulazione perfetta", "Gran Turismo 7 è il punto di riferimento per le simulazioni di guida. Non ha rivali.", 5.00, 82, 70),
("Troppo tecnico per me", "È un gioco che richiede molta pazienza e dedizione, non è adatto a chi cerca un gioco più casual.", 3.00, 82, 80),
("Ottimo ma difficile", "Per gli appassionati di auto, è fantastico, ma per un giocatore casual è davvero troppo difficile.", 4.00, 82, 90),
("Un simulatore eccellente", "La fisica di guida e i dettagli tecnici sono incredibili, ma ci vorrebbe più varietà nelle modalità di gioco.", 4.50, 82, 100);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco intrigante", "La storia è interessante, ma alcuni elementi di gioco sono ripetitivi. Comunque un buon gioco nel complesso.", 4.00, 49, 2),
("Potenziale non sfruttato", "Ottima idea di base, ma la realizzazione lascia un po' a desiderare. La trama è buona, ma la gestione delle quest è scarsa.", 3.50, 49, 12),
("Bella ambientazione", "L'ambientazione è stupenda, ma la progressione del gioco è troppo lenta e le missioni possono risultare ripetitive.", 3.50, 49, 22),
("Molto buono, ma con difetti", "Il gioco ha molte buone idee, ma i combattimenti potrebbero essere più coinvolgenti e le quest secondarie più varie.", 4.00, 49, 32),
("Intrigante ma incompleto", "La storia è molto interessante, ma il gioco sembra incompleto e manca di profondità in alcune meccaniche.", 3.50, 49, 42),
("Avventura interessante", "Un gioco interessante, ma la parte grafica e le animazioni potrebbero essere migliorate. Nel complesso comunque positivo.", 4.00, 49, 52),
("Storia ben scritta", "La trama è coinvolgente, ma le meccaniche di gioco non sono all'altezza delle aspettative. Comunque merita una prova.", 3.50, 49, 62),
("Affascinante ma scivola", "La storia mi ha preso, ma la ripetitività e i bug mi hanno distratto troppo. Un gioco con grande potenziale.", 3.00, 49, 72),
("Gioco di ruolo interessante", "Un buon GDR, con una trama solida e personaggi ben sviluppati. La gestione delle scelte è interessante.", 4.50, 49, 82),
("Prometteva di più", "Il gioco è bello ma alla fine manca di quel qualcosa che lo rende veramente memorabile. Tuttavia, si lascia giocare.", 3.50, 49, 92);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco di ruolo classico", "Grim Dawn è un ottimo gioco di ruolo action, con un sistema di combattimento soddisfacente e tante personalizzazioni.", 4.50, 66, 5),
("Molto divertente", "La costruzione del personaggio è profonda e le battaglie sono molto divertenti. Ottimo gioco per gli amanti dell'action RPG.", 5.00, 66, 15),
("Un classico moderno", "Un gioco di ruolo che prende il meglio dei classici, ma con meccaniche moderne. Adatto a chi cerca sfide e molta personalizzazione.", 4.50, 66, 25),
("Divertente ma ripetitivo", "Il gioco è molto divertente inizialmente, ma dopo un po' le missioni e i nemici diventano un po' ripetitivi.", 4.00, 66, 35),
("Stile vecchio ma efficace", "Un action RPG con grafica e gameplay old-school, che però riesce a divertire grazie alla profondità delle meccaniche.", 4.00, 66, 45),
("Ottimo per gli appassionati", "Se ti piacciono i giochi di ruolo con tanto loot e combattimenti, questo è un titolo che ti terrà impegnato a lungo.", 5.00, 66, 55),
("Un po' troppo grind", "Il gioco offre tanta profondità, ma la ripetitività e il grinding possono diventare un po' noiosi.", 3.50, 66, 65),
("Grafica migliorabile", "Nonostante il gameplay sia divertente, la grafica è un po' datata. Il gioco comunque offre tantissime ore di gioco.", 4.00, 66, 75),
("Un action RPG interessante", "Grim Dawn offre una buona combinazione di combattimenti e personalizzazione, ma la storia non è delle più avvincenti.", 4.00, 66, 85),
("Molto valido, ma non perfetto", "Il gioco ha molto da offrire, ma la ripetitività inizia a farsi sentire. Comunque un ottimo titolo per gli appassionati di RPG.", 4.00, 66, 95);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un'opera d'arte", "Gris è un gioco incredibile, una vera e propria opera d'arte visiva e musicale. La storia è emozionante e profonda.", 5.00, 100, 8),
("Bellissimo ma breve", "Il gioco è visivamente stupendo, ma la durata è troppo breve per giustificare il prezzo. Comunque un'esperienza unica.", 4.50, 100, 18),
("Un viaggio emozionante", "Gris è un gioco che sa emozionare, la grafica e la musica sono incredibili. Ma la durata è veramente troppo corta.", 4.50, 100, 28),
("Poco gameplay, ma bellissimo", "È più un'esperienza che un gioco tradizionale, ma la bellezza visiva e musicale è straordinaria.", 4.00, 100, 38),
("Un viaggio indimenticabile", "La bellezza del gioco e la sua narrazione mi hanno toccato profondamente. La mancanza di combattimenti è compensata dalla sua atmosfera.", 5.00, 100, 48),
("Stile unico", "Gris ha uno stile visivo unico, ma la mancanza di una vera sfida lo rende adatto solo a chi cerca esperienze emotive più che ludiche.", 4.00, 100, 58),
("Un capolavoro visivo", "Un gioco che deve essere giocato almeno una volta per la sua bellezza artistica, ma la storia potrebbe essere più approfondita.", 4.50, 100, 68),
("Emozionante e poetico", "La musica e la grafica sono incredibili, ma il gameplay è troppo semplice per giustificare il prezzo completo.", 4.00, 100, 78),
("Un'esperienza unica", "Gris è emozionante e davvero toccante, ma la mancanza di una vera sfida mi ha un po' deluso.", 4.00, 100, 88),
("Fantastico ma corto", "Un gioco bellissimo ma molto corto. Mi sarebbe piaciuto che durasse di più, soprattutto per l'atmosfera che riesce a creare.", 4.00, 100, 98);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un MMO senza pari", "Guild Wars 2 è uno dei migliori MMO disponibili, offre tantissime opzioni di personalizzazione e una trama interessante.", 5.00, 123, 7),
("Ottimo gioco di ruolo", "La varietà delle classi e la libertà di esplorazione sono fantastici. La community è anche molto attiva e accogliente.", 4.50, 123, 17),
("Un gioco che cresce con te", "Guild Wars 2 è un gioco che ti permette di crescere e adattare il tuo stile di gioco. Non stanca mai.", 5.00, 123, 27),
("Molto divertente ma con difetti", "Ottimo gameplay, ma il sistema di crafting e alcune meccaniche di gioco potrebbero essere migliorate.", 4.00, 123, 37),
("Un MMO da provare", "Il gioco è un buon MMORPG, ma ci sono alcune limitazioni che potrebbero essere migliorate, soprattutto nelle espansioni.", 4.00, 123, 47),
("Mi ha preso molto", "Dopo anni di giochi MMO, Guild Wars 2 è riuscito a conquistarmi grazie al suo sistema di combattimento e alla trama coinvolgente.", 5.00, 123, 57),
("Un gioco di grande profondità", "Guild Wars 2 è un MMO con un sacco di contenuti e storie da scoprire. Certo, alcuni contenuti richiedono molto tempo, ma vale la pena.", 4.50, 123, 67),
("Comunità eccezionale", "La comunità di Guild Wars 2 è fantastica e la cooperazione nelle missioni è molto divertente. Alcuni problemi di bilanciamento però.", 4.00, 123, 77),
("Un gioco che mi ha sorpreso", "Dopo aver giocato ad altri MMO, Guild Wars 2 mi ha sorpreso per la sua originalità e il modo in cui approccia le quest.", 4.50, 123, 43);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un picchiaduro spettacolare", "Guilty Gear Strive è uno dei migliori picchiaduro degli ultimi anni, con una grafica incredibile e un gameplay profondo.", 5.00, 150, 1),
("Frenetico e divertente", "Il gameplay è rapido e ricco di azione, ma può risultare difficile per i principianti. La grafica è straordinaria!", 4.50, 150, 11),
("Combat system solido", "Il sistema di combattimento è perfetto per i fan dei picchiaduro, ma l'impegno richiesto per padroneggiarlo è alto.", 4.00, 150, 21),
("Un gioco visivamente magnifico", "La grafica è di un altro livello, ma il gameplay è decisamente per esperti. Per i principianti, il gioco può essere una sfida enorme.", 4.00, 150, 31),
("Tecnico ma appagante", "Un picchiaduro che premia la tecnica e la precisione, ma è difficile da imparare. La musica e la grafica sono fantastiche.", 4.50, 150, 41),
("Picchiaduro eccellente", "Guilty Gear Strive è un picchiaduro completo, ma alcuni personaggi sembrano un po' sbilanciati. Comunque uno dei migliori titoli del genere.", 4.00, 150, 51),
("Bellissimo e tecnico", "Esteticamente bellissimo e con un gameplay tecnico che premia i giocatori esperti, ma può essere scoraggiante per i nuovi arrivati.", 4.50, 150, 61),
("Ottimo, ma per esperti", "Il gioco è fantastico, ma il suo livello di difficoltà è molto alto, specialmente per chi non è abituato ai picchiaduro.", 3.50, 150, 71),
("Fantastico ma troppo difficile", "Un picchiaduro fantastico con meccaniche complesse. Non è per tutti, ma gli appassionati lo ameranno.", 4.00, 150, 81),
("Un capolavoro visivo", "La grafica è senza pari e le animazioni sono incredibili. Il gameplay è fantastico per chi ama la sfida.", 5.00, 150, 91);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco fantastico", "Hades è un roguelike che riesce a combinare azione, narrazione e combattimenti perfetti. Uno dei migliori giochi del genere.", 5.00, 64, 2),
("Roguelike perfetto", "Ogni run è diversa e la storia che si sviluppa in parallelo è incredibile. La rigiocabilità è altissima.", 5.00, 64, 12),
("Bellissima combinazione di gameplay e storia", "Il gameplay è frenetico e coinvolgente, mentre la narrazione si evolve in modo interessante ad ogni tentativo.", 4.50, 64, 22),
("Un gioiello nel suo genere", "Le meccaniche di gioco sono fantastiche, e la varietà delle armi è notevole. La difficoltà è giusta e la trama è affascinante.", 5.00, 64, 32),
("Grandi meccaniche, ma difficile", "Il gioco è fantastico, ma la difficoltà può risultare frustrante per chi non è abituato ai roguelike. Comunque un ottimo gioco.", 4.00, 64, 42),
("Un'esperienza unica", "Hades è un roguelike ben bilanciato, con una trama che si evolve in modo interessante. Il gameplay è fluido e le animazioni sono top.", 4.50, 64, 52),
("Un gioco che non ti stanchi mai di giocare", "Nonostante il ciclo roguelike, la progressione dei personaggi e della trama ti tiene sempre incollato al gioco.", 5.00, 64, 62),
("Comparto grafico e gameplay eccezionali", "La grafica è spettacolare e le meccaniche di gioco sono ben bilanciate. Un gioco che offre sempre nuove sfide.", 5.00, 64, 72),
("Un'esperienza divertente", "Le battaglie sono coinvolgenti, ma a volte la difficoltà del gioco è un po' eccessiva. In ogni caso, un'esperienza molto divertente.", 4.00, 64, 82),
("Grandi meccaniche roguelike", "Hades è uno dei migliori giochi roguelike. La sua narrazione si evolve in modo interessante e le meccaniche di gioco sono eccellenti.", 4.50, 64, 92);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Uno dei migliori FPS", "Halo 2 è un capolavoro del genere FPS. La campagna è fantastica e il multiplayer è ancora oggi uno dei migliori.", 5.00, 228, 3),
("Grande ritorno", "Halo 2 porta avanti la storia in modo epico, con nuove meccaniche e un multiplayer che non ha eguali.", 5.00, 228, 13),
("Un FPS leggendario", "La campagna è incredibile e il multiplayer è stato una rivoluzione. Halo 2 è un gioco che ha cambiato il genere FPS.", 4.50, 228, 23),
("Grande evoluzione", "Halo 2 migliora tutto ciò che c'era di buono nel primo gioco, con una campagna più intensa e un multiplayer fantastico.", 4.50, 228, 33),
("FPS da urlo", "Halo 2 è un FPS epico che ha definito il genere per anni. La grafica e il gameplay sono straordinari.", 5.00, 228, 43),
("Multiplayer incredibile", "Il multiplayer è sempre stato il cuore del gioco. Nonostante gli anni, Halo 2 è ancora divertente da giocare.", 4.50, 228, 53),
("Una pietra miliare", "Halo 2 è uno dei migliori giochi mai creati, con una campagna indimenticabile e un multiplayer senza pari.", 5.00, 228, 63),
("Capolavoro FPS", "Halo 2 è un gioco che ha fatto scuola per tutti gli FPS successivi. La campagna è emozionante e il multiplayer è leggendario.", 5.00, 228, 73),
("Un must per gli amanti degli FPS", "La campagna di Halo 2 è straordinaria, ma ciò che lo rende davvero speciale è il multiplayer che ha fatto storia.", 4.50, 228, 83),
("Il meglio di Halo", "Halo 2 ha una delle migliori storie mai raccontate in un FPS. Il multiplayer è ancora oggi un punto di riferimento per il genere.", 5.00, 228, 93);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Perfetto sotto ogni aspetto", "Halo 3 è il perfetto equilibrio tra campagna e multiplayer. La storia è coinvolgente e il gameplay è solido come una roccia.", 5.00, 229, 4),
("Il migliore della serie", "Halo 3 ha migliorato tutto rispetto ai capitoli precedenti, con una campagna epica e un multiplayer che è ancora il migliore.", 5.00, 229, 14),
("Storia epica e multiplayer leggendario", "La campagna di Halo 3 è incredibile, con un finale che non si dimentica mai. Il multiplayer è ancora oggi uno dei più giocati.", 5.00, 229, 24),
("Halo 3 è un must", "La campagna è perfetta e il multiplayer è ancora la parte migliore del gioco. Non c'è davvero nulla da criticare.", 5.00, 229, 34),
("FPS leggendario", "La storia è fenomenale, e il multiplayer ha definito lo standard per gli FPS. Halo 3 è senza dubbio un capolavoro.", 5.00, 229, 44),
("Un classico senza tempo", "Halo 3 è un FPS che non ha mai perso il suo fascino. La campagna è appassionante e il multiplayer è sempre divertente.", 4.50, 229, 54),
("Il miglior Halo", "Halo 3 è stato un gioco che ha segnato una generazione. La grafica, la storia e il multiplayer sono incredibili.", 5.00, 229, 64),
("FPS perfetto", "Un gioco che ha reso la saga di Halo famosa in tutto il mondo. La campagna è perfetta e il multiplayer senza eguali.", 5.00, 229, 74),
("Un must per gli appassionati", "Halo 3 è un gioco che ogni amante degli FPS dovrebbe giocare. La campagna è ricca e il multiplayer è incredibile.", 4.50, 229, 84),
("Eccellente in ogni aspetto", "Halo 3 è uno dei migliori FPS di sempre. La storia è epica e il multiplayer è incredibile, ancora oggi uno dei migliori giochi online.", 5.00, 229, 94);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Grande evoluzione della saga", "Halo 4 porta la saga a un nuovo livello, con una grafica straordinaria e una storia interessante. Il multiplayer è altrettanto solido.", 5.00, 230, 5),
("Un ottimo capitolo", "La campagna è avvincente e il gameplay è ben strutturato. Il multiplayer, seppur divertente, non è alla pari con i capitoli precedenti.", 4.50, 230, 15),
("Bellissima grafica, ma...", "La grafica è stupenda, ma la campagna non è all'altezza di Halo 3. Il multiplayer è comunque divertente.", 4.00, 230, 25),
("Un buon gioco", "Halo 4 ha un ottimo gameplay, ma a volte sembra troppo simile ai suoi predecessori. La trama è solida, ma non innovativa.", 4.00, 230, 35),
("Una nuova direzione", "Il gioco segna una nuova direzione per la saga, con una trama più profonda e una grafica impressionante. Tuttavia, il multiplayer manca di freschezza.", 4.50, 230, 45),
("Eccellente ma non perfetto", "Halo 4 è un grande gioco, ma la mancanza di alcune meccaniche classiche mi ha lasciato un po' deluso. La grafica è comunque sbalorditiva.", 4.00, 230, 55),
("Rivoluzione grafica", "Il miglioramento grafico è incredibile e il gameplay è solido, ma la storia non riesce a coinvolgere come in passato.", 4.50, 230, 65),
("Halo inizia a cambiare", "Halo 4 cambia un po' le carte in tavola. La grafica è migliore, ma la storia e il gameplay non mi hanno convinto pienamente.", 3.50, 230, 75),
("Un buon inizio per la nuova trilogia", "Halo 4 segna l'inizio di una nuova trilogia interessante, ma non riesce a eguagliare i grandi successi precedenti della saga.", 4.00, 230, 85),
("Piacevole ma non memorabile", "Il gioco è divertente, ma non lascia un segno indelebile come i capitoli precedenti. La campagna è bella, ma non eccezionale.", 4.00, 230, 95);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Il migliore della serie", "Halo 5: Guardians è un gioco fantastico, con un multiplayer incredibile e una campagna coinvolgente. Ottimo lavoro!", 5.00, 231, 6),
("Multiplayer da urlo", "Il multiplayer di Halo 5 è eccezionale e migliora notevolmente rispetto ai precedenti capitoli. La campagna è buona, ma la storia è un po' debole.", 4.50, 231, 16),
("Un gioco eccezionale", "Halo 5 offre meccaniche innovative e un multiplayer coinvolgente. La storia poteva essere più profonda, ma il gameplay è eccezionale.", 4.50, 231, 26),
("C'è qualcosa di magico nel multiplayer", "La campagna non è al top, ma il multiplayer di Halo 5 è senza pari. È davvero il cuore del gioco.", 4.50, 231, 36),
("La grafica è incredibile", "Halo 5 ha una grafica pazzesca e meccaniche di gioco davvero divertenti. La trama non mi ha convinto completamente, ma il multiplayer è fantastico.", 4.00, 231, 46),
("Molto buono, ma...", "Il gioco è bello, ma la storia della campagna non è all'altezza dei precedenti. In compenso, il multiplayer è davvero ottimo.", 4.00, 231, 56),
("Troppo concentrato sul multiplayer", "Halo 5 è troppo orientato al multiplayer. La campagna è buona, ma non è ciò che mi aspettavo da un Halo.", 3.50, 231, 66),
("Esperienza di gioco solida", "Halo 5 è un ottimo gioco, ma la storia poteva essere meglio. Il multiplayer compensa molte delle sue carenze.", 4.00, 231, 76),
("Gioco divertente, ma con difetti", "Halo 5 è divertente, ma la storia è troppo prevedibile e il multiplayer a volte non è equilibrato. Tuttavia, è comunque un bel gioco.", 4.00, 231, 86),
("Un buon capitolo", "Halo 5 è un capitolo interessante nella saga, con ottimi combattimenti e una bella grafica. La storia avrebbe potuto essere meglio.", 4.00, 231, 96);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un ritorno alle origini", "Halo Infinite è il ritorno che tutti aspettavamo. La campagna è coinvolgente e il multiplayer è finalmente tornato alle origini. Un capolavoro!", 5.00, 232, 7),
("Un grande passo in avanti", "Halo Infinite è un gioco che migliora tutto ciò che c'era di buono nei precedenti. La grafica è fantastica e il gameplay è molto solido.", 5.00, 232, 17),
("Il miglior Halo in anni", "La campagna è coinvolgente, la grafica stupenda e il multiplayer è divertentissimo. Halo Infinite è davvero uno dei migliori della saga.", 5.00, 232, 27),
("Grande ritorno", "Halo Infinite segna il ritorno alle origini della saga, con una campagna aperta e una storia coinvolgente. Finalmente un grande titolo!", 5.00, 232, 37),
("Storia epica", "La campagna di Halo Infinite è grandiosa, con una trama che finalmente mi ha fatto sentire il vero spirito della saga.", 5.00, 232, 47),
("Una nuova era", "Halo Infinite è il nuovo inizio che la saga meritava. La grafica e il gameplay sono al top, ma il multiplayer è ancora in fase di miglioramento.", 4.50, 232, 57),
("Più di un gioco", "Non è solo un gioco, è un'esperienza. Halo Infinite ha tutte le caratteristiche di un capolavoro, ma ci sono ancora alcune cose da perfezionare.", 4.50, 232, 67),
("Un po' troppo lento", "Halo Infinite è un gioco fantastico, ma a volte la progressione della campagna è troppo lenta. In compenso, la grafica è impressionante.", 4.00, 232, 77),
("Gioco promettente", "Halo Infinite ha tutte le carte in regola per diventare un grande capitolo della saga. La campagna è buona, ma il multiplayer ha bisogno di qualche aggiornamento.", 4.00, 232, 87),
("Halo come non l'ho mai visto", "Un Halo completamente rinnovato. La campagna è interessante, ma a volte la formula può sembrare un po' ripetitiva. Il multiplayer è buono, ma non ancora perfetto.", 4.00, 232, 97);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Strategia in tempo reale epica", "Halo Wars è un ottimo gioco di strategia in tempo reale che porta la saga in un nuovo genere. La campagna è coinvolgente e ben strutturata.", 5.00, 233, 8),
("Un'esperienza di strategia unica", "Il gameplay di Halo Wars è solido, con una trama interessante che si adatta perfettamente al genere RTS. Un must per i fan degli strategici.", 4.50, 233, 18),
("Ottimo gioco, ma...", "Halo Wars è divertente, ma la mancanza di una campagna più lunga e la limitata varietà nelle unità lo rendono un po' ripetitivo nel lungo periodo.", 4.00, 233, 28),
("Un buon RTS, ma non per tutti", "Halo Wars è un ottimo gioco per gli amanti degli RTS, ma non è così accessibile per chi cerca un gameplay più frenetico. La storia è comunque interessante.", 4.00, 233, 38),
("Strategia profonda", "Halo Wars offre un gameplay ricco di strategia, con meccaniche uniche e una trama ben scritta. Non è perfetto, ma è un grande passo nel genere RTS.", 4.50, 233, 48),
("Troppo semplificato", "Halo Wars è divertente, ma le meccaniche sono un po' troppo semplici per un gioco di strategia. Mi aspettavo qualcosa di più profondo.", 3.50, 233, 58),
("Un gioco che sorprende", "Non pensavo che un gioco della saga di Halo potesse funzionare come RTS, ma Halo Wars è riuscito a sorprendere. La strategia è appagante, ma la campagna è breve.", 4.00, 233, 68),
("Un buon mix di Halo e RTS", "Halo Wars riesce a combinare perfettamente l'universo Halo con il gameplay RTS. È divertente, ma alcuni aspetti potrebbero essere migliorati.", 4.00, 233, 78),
("Adatto ai fan degli RTS", "Se sei un fan degli RTS, Halo Wars ti piacerà sicuramente. La storia è solida, ma il gameplay a volte può risultare un po' ripetitivo.", 4.00, 233, 88),
("Gioco divertente ma con potenziale non sfruttato", "Halo Wars ha un ottimo potenziale, ma manca di un po' di profondità. È comunque un gioco piacevole, ma non è così memorabile.", 3.50, 233, 98);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro strategico", "Hearts of Iron IV è un gioco di strategia profondo, che ti permette di controllare ogni aspetto della Seconda Guerra Mondiale. Un must per gli appassionati del genere.", 5.00, 75, 9),
("Una sfida per i veterani", "Il gioco è complesso e richiede tempo per essere apprezzato appieno. Ma una volta che capisci le meccaniche, diventa incredibilmente gratificante.", 4.50, 75, 19),
("Strategia a livelli epici", "Hearts of Iron IV è una delle migliori simulazioni di guerra che abbia mai giocato. La varietà di opzioni e strategie rende ogni partita unica.", 5.00, 75, 29),
("Ottimo, ma difficile", "La curva di apprendimento è ripida, ma il gioco offre una profondità che pochi altri giochi di strategia riescono a eguagliare. Un po' complesso, ma divertente.", 4.00, 75, 39),
("Troppo complesso per me", "Hearts of Iron IV è un gioco fantastico, ma troppo complesso per i miei gusti. Ci vuole davvero molto tempo per imparare a giocarci.", 3.50, 75, 49),
("Gran gioco, ma a volte frustrante", "Le meccaniche di gioco sono incredibilmente dettagliate, ma possono essere frustranti se non le si padroneggia. Una volta che ci si riesce, è molto divertente.", 4.00, 75, 59),
("Un gioco profondo", "Se ami la storia e la strategia, Hearts of Iron IV è un gioco che devi provare. La varietà delle scelte e degli scenari rende ogni partita unica.", 4.50, 75, 69),
("Bellissimo ma troppo tecnico", "Le meccaniche sono fantastiche, ma richiedono un impegno notevole per essere padroneggiate. Non è un gioco per tutti, ma sicuramente appagante per i fan del genere.", 4.00, 75, 79),
("Un must per i fan della Seconda Guerra Mondiale", "Hearts of Iron IV è la simulazione perfetta della Seconda Guerra Mondiale. Dettagliato, strategico e ricco di contenuti. Una gioia per gli appassionati.", 5.00, 75, 89),
("Ottima simulazione, ma... ", "Il gioco è incredibilmente dettagliato, ma la sua complessità può renderlo difficile da godere per chi cerca un'esperienza piu' accessibile.", 4.00, 75, 99);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un sogno che diventa realtà", "Hogwarts Legacy è finalmente il gioco che ci permette di vivere nell'universo di Harry Potter come mai prima d'ora. La grafica è impressionante e la storia avvincente.", 5.00, 235, 10),
("Magia in ogni angolo", "Il gioco ti fa sentire come un vero studente di Hogwarts. La possibilità di esplorare il castello e le sue terre è incredibile.", 5.00, 235, 20),
("Un'esperienza immersiva", "La trama è buona e l'esplorazione è fantastica. Mi è piaciuto molto come il gioco ricrea l'atmosfera della saga di Harry Potter.", 4.50, 235, 30),
("Magico ma con qualche difetto", "L'esperienza è davvero immersiva, ma alcune meccaniche di gioco sono un po' ripetitive. La magia è comunque ben realizzata.", 4.00, 235, 40),
("Splendido ma un po' lineare", "Hogwarts Legacy ha una grafica mozzafiato, ma la storia principale potrebbe essere più interessante. La magia e l'esplorazione sono il cuore del gioco.", 4.00, 235, 50),
("Fantastico, ma c'è margine", "Un gioco che porta la magia a un nuovo livello. La grafica è fantastica e la possibilità di personalizzare il personaggio è un'ottima aggiunta, ma c'è ancora spazio per miglioramenti.", 4.50, 235, 60),
("La magia è viva", "Hogwarts Legacy è un gioco che ti fa sentire parte del mondo magico. L'esplorazione di Hogwarts è incredibile, anche se la trama non è sempre avvincente.", 4.00, 235, 70),
("Un gioco fantastico, ma...", "L'esperienza è incredibile, ma il gioco soffre di alcune meccaniche di gioco che potrebbero essere migliorate. La magia è comunque realizzata in modo splendido.", 4.00, 235, 80),
("Magia e avventura", "Hogwarts Legacy è un'esperienza unica per i fan di Harry Potter. La possibilità di esplorare il castello è un sogno, ma la storia principale non è così coinvolgente.", 4.00, 235, 90),
("Un gioco bellissimo ma a volte lento", "La grafica e l'atmosfera sono mozzafiato, ma la storia a volte si fa un po' noiosa. La magia e l'esplorazione sono comunque eccezionali.", 4.00, 235, 100);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro indie", "Hollow Knight è un gioco incredibile. La sua atmosfera, il gameplay e il design dei livelli sono straordinari. Un must per ogni appassionato di Metroidvania.", 5.00, 43, 11),
("Fantastico e impegnativo", "Hollow Knight è difficile ma estremamente gratificante. La sua mappa e le sue ambientazioni sono mozzafiato, con tantissimi segreti da scoprire.", 5.00, 43, 21),
("Una vera gemma indie", "Hollow Knight è un gioco che riesce a combinare perfettamente esplorazione, combattimento e narrazione. Non è facile, ma vale assolutamente la pena giocarlo.", 5.00, 43, 31),
("Stupendo ma difficile", "Il gioco è bellissimo, ma la sua difficoltà a volte è eccessiva. La sensazione di progressione è comunque appagante.", 4.50, 43, 41),
("Un metroidvania eccellente", "Hollow Knight è uno dei migliori metroidvania mai creati. La grafica e il design dei livelli sono incredibili, ma la difficoltà può essere troppo alta per alcuni.", 4.50, 43, 51),
("Un gioco incredibile", "L'atmosfera di Hollow Knight è fantastica, con una trama ben nascosta che si svela solo esplorando. Un gioco che ogni fan del genere dovrebbe provare.", 5.00, 43, 61),
("Bellissimo ma frustrante", "La grafica e il gameplay sono fantastici, ma la difficoltà è davvero alta. Tuttavia, la soddisfazione di superare una zona difficile è unica.", 4.00, 43, 71),
("Impegnativo ma gratificante", "Hollow Knight è davvero difficile, ma la sensazione di migliorare e superare i propri limiti è incredibile. Un gioco che ti lascia senza parole.", 4.50, 43, 81),
("Perfetto per chi ama le sfide", "Il gioco è bellissimo e impegnativo, con tantissime segrete e nemici da affrontare. La difficoltà non è per tutti, ma vale assolutamente la pena.", 4.50, 43, 91),
("Un piccolo capolavoro", "Hollow Knight è uno dei migliori giochi indie che abbia mai giocato. La sua difficoltà ti spinge a migliorare continuamente, e la sua atmosfera è unica.", 5.00, 43, 101);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Esperienza immersiva", "Horizon Call of the Mountain è un gioco VR straordinario che ti immerge nel mondo di Horizon in un modo mai visto prima. Le ambientazioni sono mozzafiato.", 5.00, 268, 12),
("Un'avventura visivamente splendida", "Le immagini in VR sono stupende, ma la storia non è altrettanto coinvolgente. Tuttavia, il gameplay è soddisfacente e la grafica è davvero impressionante.", 4.00, 268, 22),
("Un'esperienza unica", "Se sei un fan di Horizon, questo gioco è imperdibile. L'interazione VR è ben fatta, ma la trama è un po' sotto le aspettative.", 4.50, 268, 32),
("Bellissimo, ma troppo breve", "La qualità visiva è incredibile, ma la durata del gioco è troppo corta. Spero che aggiungano più contenuti in futuro.", 4.00, 268, 42),
("Molto coinvolgente in VR", "Il gioco è estremamente coinvolgente, ma la trama lascia un po' a desiderare. Nonostante ciò, l'esperienza VR è unica.", 4.00, 268, 52),
("Un'avventura in VR degna di Horizon", "Il gioco riesce a portare Horizon nel mondo VR in modo convincente, ma la storia avrebbe potuto essere più profonda. Il gameplay è comunque divertente.", 4.50, 268, 62),
("Bellissimo ma a volte ripetitivo", "L'aspetto grafico e l'interazione VR sono fantastici, ma il gameplay può diventare un po' ripetitivo. Ottimo per gli amanti della realtà virtuale.", 4.00, 268, 72),
("Soddisfacente ma con margini di miglioramento", "Il gioco è bello, ma alcune meccaniche in VR non sono così fluide come ci si aspetterebbe. È comunque un buon inizio per la saga in VR.", 3.50, 268, 82),
("VR fantastico, trama carente", "L'esperienza in VR è fantastica, ma la trama non è all'altezza di altri giochi della serie Horizon. È comunque un'avventura visivamente splendida.", 4.00, 268, 92),
("Sogno ad occhi aperti", "Come fan della saga, il gioco mi ha sorpreso. L'interazione con l'ambiente in VR è incredibile, ma la trama avrebbe potuto essere più coinvolgente.", 4.50, 268, 102);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro visivo", "Horizon Forbidden West porta la serie a nuovi livelli con una grafica straordinaria e un gameplay migliorato. La storia è coinvolgente e le meccaniche ben bilanciate.", 5.00, 39, 13),
("Un gioco epico", "La bellezza visiva e la profondità della trama rendono Horizon Forbidden West un gioco imperdibile. Ci sono però alcune missioni secondarie un po' ripetitive.", 4.50, 39, 23),
("Un'esperienza mozzafiato", "L'esplorazione di Horizon Forbidden West è fantastica, ma la difficoltà nelle missioni di combattimento potrebbe essere migliorata. Comunque, è un gioco stupendo.", 4.50, 39, 33),
("Incredibile, ma...", "Il gioco è stupendo, ma la gestione delle risorse può risultare un po' macchinosa. Comunque, le ambientazioni sono tra le migliori che abbia mai visto.", 4.00, 39, 43),
("Horizon è sempre al top", "Horizon Forbidden West è un grande seguito del primo gioco. Le meccaniche sono migliorate e la trama è coinvolgente. Un gioco che non puoi perderti.", 5.00, 39, 53),
("Da non perdere", "Un grande sequel, con molte migliorie rispetto al primo gioco. La storia è interessante e l'open world è ricco di dettagli, anche se alcune missioni sono troppo lunghe.", 4.50, 39, 63),
("Tanta bellezza ma qualche difetto", "Horizon Forbidden West è bellissimo, ma alcuni aspetti del gameplay, come il crafting, potrebbero essere più fluidi. Nonostante questo, è un gioco che vale ogni minuto.", 4.00, 39, 73),
("Gioco stupendo, ma un po' ripetitivo", "Le ambientazioni e la grafica sono incredibili, ma alcune meccaniche di gioco risultano un po' ripetitive. La trama è comunque interessante.", 4.00, 39, 83),
("Un miglioramento enorme", "Horizon Forbidden West è un grande passo avanti rispetto al primo. La qualità grafica è incredibile e le meccaniche sono molto più rifinite.", 5.00, 39, 93),
("Un'esperienza che merita", "Il gioco offre un mondo ricco di contenuti e una storia che ti tiene incollato. Non è perfetto, ma è senza dubbio uno dei migliori giochi della sua categoria.", 4.50, 39, 103);

INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco spettacolare", "Horizon Zero Dawn è un capolavoro. La storia è avvincente, i personaggi ben scritti, e il gameplay è perfetto. Un must per ogni videogiocatore.", 5.00, 4, 14),
("Impeccabile sotto ogni aspetto", "La trama è incredibile e il mondo aperto è fantastico da esplorare. Gli animali robotici sono un'idea geniale. Non si può chiedere di più.", 5.00, 4, 24),
("Un'avventura unica", "Horizon Zero Dawn è un gioco che ti trascina nel suo mondo. L'ambientazione è straordinaria e il gameplay è pieno di scelte strategiche.", 4.50, 4, 34),
("Ottimo ma troppo lungo", "La storia è incredibile, ma il gioco è un po' troppo lungo a volte. Alcune missioni secondarie sono inutili e poco interessanti.", 4.00, 4, 44),
("Un gioco che ti incolla", "La storia di Horizon Zero Dawn ti tiene incollato fino alla fine. Le meccaniche di combattimento sono fluide e soddisfacenti.", 5.00, 4, 54),
("Uno dei migliori RPG", "Horizon Zero Dawn è un gioco che non lascia nulla al caso. La grafica è splendida, la storia intrigante e il gameplay appagante.", 5.00, 4, 64),
("Bellissimo ma con qualche difetto", "Il gioco è bellissimo, ma alcune meccaniche di combattimento potrebbero essere migliorate. La storia è comunque fantastica e la mappa è ricca di contenuti.", 4.50, 4, 74),
("Un must per gli amanti dei mondi aperti", "Se ami i giochi open world, Horizon Zero Dawn è una delle esperienze migliori. La varietà di missioni e l'ambientazione sono eccezionali.", 5.00, 4, 84),
("Troppo facile in alcuni punti", "Il gioco è incredibile, ma alcuni combattimenti sono troppo facili. La trama e l'ambientazione, però, lo rendono comunque un capolavoro.", 4.00, 4, 94),
("Un'avventura indimenticabile", "Horizon Zero Dawn è un gioco che vale ogni singolo minuto. La trama è fantastica e la possibilità di esplorare un mondo così ricco è impagabile.", 5.00, 4, 104);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un picchiaduro spettacolare", "Injustice 2 è uno dei migliori picchiaduro con personaggi DC. La grafica è incredibile e il gameplay è fluido e ben bilanciato.", 5.00, 152, 16),
("Combattimenti epici", "Ogni combattimento in Injustice 2 è spettacolare. La possibilità di usare i personaggi DC in combattimenti intensi è davvero divertente.", 4.50, 152, 26),
("Un po' ripetitivo", "Injustice 2 è bello da giocare, ma alcune modalità di gioco sono un po' ripetitive. Nonostante ciò, il gameplay e i personaggi sono fantastici.", 4.00, 152, 36),
("Eccellente ma non perfetto", "Il gioco è molto divertente, ma alcune meccaniche di combattimento potrebbero essere migliorate. È comunque uno dei migliori picchiaduro che abbia mai giocato.", 4.50, 152, 46),
("Un must per i fan di DC", "Injustice 2 offre una varietà incredibile di personaggi e modalità di gioco. Gli amanti dei picchiaduro e dei fumetti DC non possono perderselo.", 5.00, 152, 56),
("Tanta azione", "Ogni combattimento è pieno di azione e spettacolari animazioni. Un gioco da non perdere per chi ama i picchiaduro.", 4.50, 152, 66),
("Divertente ma con margini di miglioramento", "La grafica e il combattimento sono ottimi, ma alcune modalità di gioco possono diventare noiose. È comunque un gioco molto divertente.", 4.00, 152, 76),
("Un picchiaduro sopra la media", "Injustice 2 è un gioco molto divertente, ma non è perfetto. La modalità storia è interessante, ma il multiplayer online può essere frustrante.", 4.00, 152, 86),
("Pieno di possibilità", "Il gioco ha una grande varietà di personaggi e di modalità, ma le meccaniche potrebbero essere perfezionate. Comunque, è molto divertente", 4.50, 152, 96),
("Migliorato rispetto al primo", "Injustice 2 è un netto miglioramento rispetto al primo gioco. Le animazioni, la varietà dei personaggi e le nuove meccaniche sono fantastiche.", 5.00, 152, 106);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un gioco che ti tiene incollato", "Inscryption è un'esperienza unica che mescola meccaniche di carte con un'atmosfera psicologica intrigante. Non è un gioco facile, ma ti tiene impegnato.", 5.00, 107, 17),
("Innovativo e inquietante", "La trama di Inscryption è piena di colpi di scena e il gameplay di carte è originale. È un gioco che ti sorprende ad ogni angolo.", 5.00, 107, 27),
("Affascinante ma oscuro", "Inscryption è un gioco che ti affascina con la sua atmosfera cupa e le sue meccaniche innovative, ma può risultare troppo complesso per alcuni.", 4.50, 107, 37),
("Un'esperienza unica", "Se ti piacciono i giochi di carte con una trama avvincente e misteriosa, Inscryption è un gioco da non perdere. È davvero originale.", 5.00, 107, 47),
("Intrigante ma frustrante", "Il gioco ha una storia affascinante e una meccanica di gioco interessante, ma alcune parti possono risultare frustranti e difficili da comprendere.", 4.00, 107, 57),
("Un capolavoro psicologico", "Inscryption è un capolavoro che ti fa riflettere mentre ti intrattiene. Le sue meccaniche e la trama sono uniche e ti sorprendono continuamente.", 5.00, 107, 67),
("Divertente ma difficile", "La combinazione di gioco di carte e horror psicologico è affascinante, ma alcune meccaniche sono difficili da padroneggiare. Non è un gioco per tutti.", 4.00, 107, 77),
("Storia avvincente", "La storia e il mondo che Inscryption costruisce sono fantastici. Nonostante alcune difficoltà, il gioco è estremamente coinvolgente.", 4.50, 107, 87),
("Un gioco che ti sorprende", "Inscryption è difficile da descrivere, ma sicuramente ti sorprenderà. Le sue meccaniche e la trama sono molto originali, ma non è un gioco per chi cerca qualcosa di semplice.", 4.50, 107, 97),
("Misterioso e intrigante", "Inscryption è un gioco che tiene alta la tua attenzione grazie ai suoi continui colpi di scena e alle sue meccaniche uniche. Un must per gli amanti dei giochi misteriosi.", 5.00, 107, 107);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Un capolavoro oscuro", "Inside è un'esperienza unica che mescola suspense e mistero. La sua atmosfera inquietante ti tiene incollato fino alla fine.", 5.00, 110, 18),
("Profondo e affascinante", "Il gioco è visivamente straordinario, e la trama, pur essendo enigmatica, è affascinante. Ogni puzzle ha un significato che si svela piano piano.", 5.00, 110, 28),
("Emozionante e inquietante", "Inside è un gioco che riesce a creare una sensazione di costante tensione. Le meccaniche sono semplici ma efficaci, ed è difficile staccarsi dalla storia.", 4.50, 110, 38),
("Un viaggio oscuro", "Il gioco ha una storia complessa, ma non viene mai esplicitamente raccontata. Il suo fascino sta proprio nell'interpretazione personale di ogni elemento.", 4.50, 110, 48),
("Affascinante ma breve", "Inside è un gioco incredibile che lascia il segno, anche se purtroppo è piuttosto breve. La sua atmosfera è unica e ti fa pensare anche dopo averlo finito.", 4.00, 110, 58),
("Un'esperienza indimenticabile", "Non è solo un gioco, è un'esperienza che ti coinvolge e ti lascia con molte domande senza risposta. Ogni momento è pensato per farti riflettere.", 5.00, 110, 68),
("Bellissimo ma disturbante", "La grafica e la musica sono incredibili, ma l'atmosfera è disturbante. Il gioco è perfetto per chi ama i titoli con una forte componente psicologica.", 4.50, 110, 78),
("Storia enigmatica", "La trama è interessante e ti spinge a scoprire sempre di più, ma l'interpretazione resta aperta. È un gioco che ti fa riflettere profondamente.", 4.00, 110, 88),
("Un thriller psicologico", "Inside è come un thriller psicologico. Ogni puzzle ha una logica che ti sfida a pensare in modo diverso. Un gioco che ti lascia senza fiato.", 5.00, 110, 98),
("Molto intrigante", "Inside è un gioco che non racconta tutto, ma ti invita a riflettere. Le meccaniche di gioco sono semplici, ma la storia ti lascia qualcosa dentro.", 4.50, 110, 108);


-- Recensioni per "It Takes Two" (GameID 163)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Amazing Co-op", "One of the best co-op games I have ever played!", 4.8, 163, 1),
("Creative Levels", "Loved the creativity in the level design.", 4.7, 163, 2),
("Fun Story", "A delightful story with engaging gameplay.", 4.9, 163, 3),
("Best Co-op Experience", "A must-play for friends and couples.", 5.0, 163, 4),
("Challenging Yet Fun", "Some puzzles are tricky but satisfying.", 4.6, 163, 5),
("Great Art Style", "Beautiful visuals and engaging gameplay.", 4.7, 163, 6),
("Innovative Gameplay", "Every level feels fresh and unique.", 4.9, 163, 7),
("Perfect for Two", "The mechanics are perfectly designed for two players.", 4.8, 163, 8),
("Heartwarming", "A beautiful narrative with stunning gameplay.", 4.7, 163, 9),
("Worth the Hype", "Lives up to all expectations!", 5.0, 163, 10);

-- Recensioni per "Jackbox Party Pack 9" (GameID 131)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Hilarious Fun", "Perfect for parties with friends.", 4.5, 131, 11),
("Great Party Game", "So much fun with a group of friends.", 4.4, 131, 12),
("Innovative Mini-games", "Unique and engaging mini-games.", 4.6, 131, 13),
("Tons of Laughs", "Always ends up in fits of laughter.", 4.7, 131, 14),
("Replayable", "Never gets old, even after multiple plays.", 4.8, 131, 15),
("Perfect Icebreaker", "Great for breaking the ice in gatherings.", 4.3, 131, 16),
("Endless Entertainment", "Keeps the fun going for hours.", 4.9, 131, 17),
("User-Friendly", "Easy to set up and play.", 4.5, 131, 18),
("Best Jackbox Yet", "One of the best entries in the series.", 4.6, 131, 19),
("Worth Every Penny", "Totally worth the price for the content.", 4.8, 131, 20);

-- Recensioni per "King of Fighters XV" (GameID 156)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Amazing Combat", "Fast-paced and satisfying fighting mechanics.", 4.7, 156, 21),
("Balanced Gameplay", "Great roster and balanced characters.", 4.6, 156, 22),
("Stunning Visuals", "Graphics are top-notch.", 4.8, 156, 23),
("Improved Mechanics", "A significant step up from previous titles.", 4.5, 156, 24),
("Great Online Play", "Smooth online experience with minimal lag.", 4.4, 156, 25),
("Classic Reborn", "A great revival of the series.", 4.9, 156, 26),
("Fun Roster", "Loved the variety in characters.", 4.7, 156, 27),
("Competitive Fun", "Perfect for competitive players.", 4.6, 156, 28),
("Easily Accessible", "Easy for newcomers to pick up and play.", 4.5, 156, 29),
("Great for Fans", "A must-have for fighting game enthusiasts.", 4.8, 156, 30);

-- Recensioni per "Kingdom Come: Deliverance" (GameID 48)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Immersive RPG", "Incredible attention to historical detail.", 4.7, 48, 31),
("Challenging Combat", "Combat mechanics are tough but rewarding.", 4.5, 48, 32),
("Engaging Storyline", "Loved the realistic narrative.", 4.8, 48, 33),
("Realistic World", "One of the most realistic RPGs I have played.", 4.6, 48, 34),
("Beautiful Graphics", "Stunning visuals with a rich world.", 4.7, 48, 35),
("Unique Experience", "A different take on the RPG genre.", 4.8, 48, 36),
("Slow Start", "Takes time to get into, but worth it.", 4.4, 48, 37),
("Deep Systems", "Crafting and skills are deeply rewarding.", 4.6, 48, 38),
("Memorable NPCs", "Great character design and stories.", 4.7, 48, 39),
("For Hardcore Players", "Not for the casual gamer, but fantastic.", 4.5, 48, 40);

-- Recensioni per "Kirby and the Forgotten Land" (GameID 119)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Charming Adventure", "Kirby never fails to deliver a cute adventure.", 4.9, 119, 41),
("Fun for All Ages", "A delightful game that everyone can enjoy.", 4.8, 119, 42),
("Creative Levels", "Level design is innovative and fun.", 4.7, 119, 43),
("Great Visuals", "The graphics are vibrant and appealing.", 4.8, 119, 44),
("Relaxing Gameplay", "Perfect for a laid-back gaming session.", 4.7, 119, 45),
("Kirby's Best Yet", "One of the best Kirby games in years.", 4.9, 119, 46),
("Fun Powers", "Loved experimenting with all the abilities.", 4.8, 119, 47),
("Co-op Mode Rocks", "Playing with friends is so much fun.", 4.7, 119, 48),
("Perfect for Kids", "My kids absolutely love this game.", 4.9, 119, 49),
("Highly Replayable", "So much content to enjoy repeatedly.", 4.8, 119, 50);

-- Recensioni per "Knack" (GameID 236)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Decent Platformer", "A solid, if simple, platforming experience.", 3.8, 236, 51),
("Family-Friendly", "Great game for the younger audience.", 4.0, 236, 52),
("Fun Concept", "Loved the idea of growing and shrinking Knack.", 4.1, 236, 53),
("Good Graphics", "The visuals are quite polished.", 4.2, 236, 54),
("Simple Gameplay", "A bit too simple for hardcore gamers.", 3.5, 236, 55),
("Entertaining Story", "A fun, lighthearted tale.", 4.0, 236, 56),
("Repetitive Combat", "Combat gets repetitive after a while.", 3.6, 236, 57),
("Great for Kids", "A perfect game for younger players.", 4.2, 236, 58),
("Short but Sweet", "Not very long, but enjoyable.", 3.9, 236, 59),
("Nostalgic Vibes", "Feels like a classic PS2 platformer.", 4.1, 236, 60);


-- Recensioni per "Knack 2" (GameID 237)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Improved Sequel", "Much better than the first game!", 4.2, 237, 61),
("Family Fun", "A great game for the whole family.", 4.3, 237, 62),
("Better Combat", "Combat is more varied and enjoyable.", 4.1, 237, 63),
("Co-op Mode Shines", "Playing co-op is a fantastic experience.", 4.4, 237, 64),
("Great Puzzles", "Enjoyed the platforming and puzzles.", 4.2, 237, 65),
("Polished Graphics", "Looks great on the PS4.", 4.3, 237, 66),
("More Depth", "A big improvement in gameplay mechanics.", 4.2, 237, 67),
("Still Repetitive", "Combat can still feel repetitive at times.", 3.9, 237, 68),
("Good Replay Value", "Offers a lot of replayability.", 4.1, 237, 69),
("Fun for Younger Players", "My kids loved it!", 4.4, 237, 70);

-- Recensioni per "Layers of Fear" (GameID 143)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Terrifying Experience", "One of the scariest games I have ever played.", 4.8, 143, 71),
("Atmospheric Horror", "The atmosphere is absolutely chilling.", 4.7, 143, 72),
("Amazing Visuals", "The art style is creepy yet stunning.", 4.6, 143, 73),
("Psychological Masterpiece", "A fantastic psychological horror game.", 4.9, 143, 74),
("Intriguing Story", "The story kept me hooked until the end.", 4.7, 143, 75),
("Immersive Sound", "The sound design is incredible.", 4.8, 143, 76),
("Not for the Faint of Heart", "Extremely intense and scary.", 4.6, 143, 77),
("Short but Memorable", "A short experience but well worth it.", 4.5, 143, 78),
("Great Replay Value", "Different endings make it replayable.", 4.7, 143, 79),
("A Must-Play", "One of the best horror games out there.", 5.0, 143, 80);

-- Recensioni per "League of Legends" (GameID 238)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Addictive Gameplay", "I can't stop playing!", 4.7, 238, 81),
("Toxic Community", "Great game but the community is toxic.", 3.8, 238, 82),
("Challenging and Fun", "Every match feels intense and rewarding.", 4.5, 238, 83),
("Great Esports Scene", "The competitive scene is amazing.", 4.8, 238, 84),
("Tons of Champions", "Love the variety of champions.", 4.6, 238, 85),
("Steep Learning Curve", "Takes time to learn but worth it.", 4.4, 238, 86),
("Frequent Updates", "The game is always being updated.", 4.7, 238, 87),
("Great Graphics", "Looks fantastic for a MOBA.", 4.5, 238, 88),
("Teamwork is Key", "Best enjoyed with friends.", 4.6, 238, 89),
("Addictive but Frustrating", "Can be frustrating at times, but I keep coming back.", 4.3, 238, 90);


-- Recensioni per "Limbo" (GameID 108)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Beautifully Dark", "A hauntingly beautiful experience.", 4.8, 108, 91),
("Minimalist Masterpiece", "Simple yet incredibly effective.", 4.7, 108, 92),
("Challenging Puzzles", "Some puzzles were really tricky but satisfying.", 4.6, 108, 93),
("Atmospheric and Creepy", "The atmosphere is unmatched.", 4.8, 108, 94),
("Short but Impactful", "A short game, but it left a big impression.", 4.7, 108, 95),
("Eerie Soundtrack", "The sound design adds to the creepiness.", 4.9, 108, 96),
("Unique Art Style", "The black-and-white visuals are stunning.", 4.8, 108, 97),
("Great Platformer", "One of the best indie platformers.", 4.7, 108, 98),
("Emotionally Gripping", "Left me thinking about it for days.", 4.9, 108, 99),
("A True Gem", "One of the most unique games I have played.", 5.0, 108, 100);

-- Recensioni per "Little Nightmares" (GameID 109)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Creepy and Fun", "A fantastic horror platformer.", 4.8, 109, 101),
("Unique World", "The setting is so creepy yet intriguing.", 4.7, 109, 102),
("Great Puzzles", "The puzzles are challenging and rewarding.", 4.6, 109, 103),
("Haunting Atmosphere", "The eerie vibe is perfect.", 4.9, 109, 104),
("Stunning Visuals", "The graphics are fantastic.", 4.8, 109, 105),
("Memorable Bosses", "The enemies are terrifyingly creative.", 4.7, 109, 106),
("Short but Sweet", "I wish it were longer, but it was amazing.", 4.6, 109, 107),
("Emotionally Intense", "I felt tense the whole way through.", 4.9, 109, 108),
("Perfect for Horror Fans", "A must-play for fans of atmospheric horror.", 4.8, 109, 109),
("Incredible Storytelling", "The narrative is subtle but powerful.", 5.0, 109, 110);

-- Recensioni per "Little Nightmares II" (GameID 146)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Bigger and Better", "An improvement over the original in every way.", 4.9, 146, 111),
("Terrifyingly Good", "The scares are even better this time around.", 4.8, 146, 112),
("Great Co-op Elements", "The co-op gameplay is a fantastic addition.", 4.7, 146, 113),
("Incredible Visuals", "Even more stunning than the first game.", 4.9, 146, 114),
("Deeply Unsettling", "The atmosphere is terrifyingly brilliant.", 4.8, 146, 115),
("Emotional Journey", "A heartbreaking yet beautiful story.", 4.9, 146, 116),
("Creative Puzzles", "Even more creative and challenging puzzles.", 4.8, 146, 117),
("Immersive Sound Design", "The audio adds so much to the experience.", 4.9, 146, 118),
("Perfect Sequel", "Takes everything great about the first game and improves it.", 5.0, 146, 1),
("Highly Recommended", "A masterpiece in horror and platforming.", 4.9, 146, 2);


-- Recensioni per "Lost Ark" (GameID 124)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Epic Adventure", "An expansive MMORPG with a lot to do.", 4.6, 124, 3),
("Beautiful Graphics", "The game looks absolutely stunning.", 4.7, 124, 4),
("Great Combat", "The combat mechanics are fluid and satisfying.", 4.8, 124, 5),
("Grindy but Fun", "It's grindy, but the fun factor makes up for it.", 4.5, 124, 6),
("Tons of Content", "So much to explore and accomplish.", 4.7, 124, 7),
("Excellent Raids", "The raids are challenging and rewarding.", 4.8, 124, 8),
("Frequent Updates", "The developers keep adding great content.", 4.6, 124, 9),
("Immersive World", "The world-building is top-notch.", 4.7, 124, 10),
("Pay-to-Win Elements", "Great game but has pay-to-win mechanics.", 4.3, 124, 11),
("A Must-Try MMO", "One of the best MMORPGs out there.", 4.9, 124, 12);

-- Recensioni per "Mafia III" (GameID 239)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Engaging Story", "The narrative is deeply captivating.", 4.7, 239, 13),
("Atmospheric Setting", "The 60s setting is incredibly immersive.", 4.6, 239, 14),
("Repetitive Gameplay", "Good game, but missions feel repetitive.", 3.8, 239, 15),
("Great Characters", "The characters are well-developed and relatable.", 4.7, 239, 16),
("Beautiful Soundtrack", "The music captures the era perfectly.", 4.8, 239, 17),
("Performance Issues", "Great game but plagued by performance problems.", 3.9, 239, 18),
("Excellent Voice Acting", "The voice acting is top-notch.", 4.6, 239, 19),
("Gripping Atmosphere", "The atmosphere keeps you engaged throughout.", 4.5, 239, 20),
("Missed Potential", "Good, but could have been much better.", 4.0, 239, 21),
("Immersive World", "The open world feels alive and real.", 4.5, 239, 22);

-- Recensioni per "Mario Kart 8 Deluxe" (GameID 129)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Party Perfection", "The ultimate party game!", 4.9, 129, 23),
("Timeless Fun", "Never gets old, no matter how much I play.", 5.0, 129, 24),
("Best Mario Kart Yet", "Hands down the best in the series.", 4.9, 129, 25),
("Great for Everyone", "Kids and adults love it equally.", 4.8, 129, 26),
("Amazing Tracks", "The variety of tracks is fantastic.", 4.7, 129, 27),
("Perfect Multiplayer", "Multiplayer is where this game shines.", 5.0, 129, 28),
("Smooth Gameplay", "Runs flawlessly on the Switch.", 4.9, 129, 29),
("Iconic Characters", "Playing as my favorite characters is great.", 4.8, 129, 30),
("DLC Content", "The additional tracks and characters are worth it.", 4.8, 129, 31),
("Fun with Friends", "The most fun I've had in years!", 5.0, 129, 32);


-- Recensioni per "Martha is Dead" (GameID 240)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Disturbing and Unique", "An unforgettable psychological horror experience.", 4.7, 240, 33),
("Eerie Atmosphere", "The game excels at building tension.", 4.6, 240, 34),
("Story-Driven Masterpiece", "The story is gripping and dark.", 4.8, 240, 35),
("Beautiful Graphics", "The photorealistic visuals are stunning.", 4.7, 240, 36),
("Emotionally Heavy", "Not for the faint-hearted.", 4.6, 240, 37),
("Intriguing Plot", "The mystery keeps you hooked till the end.", 4.7, 240, 38),
("Psychological Horror Done Right", "A haunting experience.", 4.8, 240, 39),
("Sound Design is Amazing", "The sound adds to the unsettling atmosphere.", 4.9, 240, 40),
("Not for Everyone", "Can be too disturbing for some players.", 4.5, 240, 41),
("A Dark Gem", "A truly unique horror game.", 4.8, 240, 42);

-- Recensioni per "Mass Effect" (GameID 241)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Sci-Fi Excellence", "A groundbreaking RPG with an epic story.", 5.0, 241, 43),
("Incredible World-Building", "The universe feels alive and immersive.", 4.9, 241, 44),
("Great Characters", "The cast is memorable and well-written.", 4.8, 241, 45),
("Choices Matter", "Decisions have real impact on the story.", 4.9, 241, 46),
("Classic RPG", "A must-play for RPG fans.", 4.7, 241, 47),
("Fantastic Voice Acting", "The dialogue delivery is perfect.", 4.8, 241, 48),
("Engaging Combat", "The combat system is fun and fluid.", 4.6, 241, 49),
("Immersive Story", "The narrative is one of the best in gaming.", 5.0, 241, 50),
("Timeless Adventure", "Still holds up after all these years.", 4.8, 241, 51),
("Highly Recommended", "One of the best RPGs ever made.", 5.0, 241, 52);

-- Recensioni per "Mass Effect 2" (GameID 242)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Phenomenal Sequel", "Improves on the original in every way.", 5.0, 242, 53),
("Amazing Story", "The loyalty missions are incredible.", 4.9, 242, 54),
("Memorable Cast", "Every character feels unique and important.", 5.0, 242, 55),
("Intense Choices", "The decisions are even more impactful.", 4.9, 242, 56),
("Cinematic Experience", "Feels like playing through a movie.", 5.0, 242, 57),
("Perfect RPG", "One of the best RPGs ever created.", 5.0, 242, 58),
("Refined Combat", "The combat is polished and fun.", 4.8, 242, 59),
("Stunning Visuals", "Looks great even today.", 4.9, 242, 60),
("Unforgettable Journey", "A masterpiece from start to finish.", 5.0, 242, 61),
("Must-Play Game", "An iconic title in gaming history.", 5.0, 242, 62);


-- Recensioni per "Mass Effect 3" (GameID 243)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Epic Conclusion", "A fantastic ending to an amazing trilogy.", 4.8, 243, 63),
("Emotional Journey", "The story hits all the right notes.", 4.9, 243, 64),
("Great Gameplay", "Combat and exploration are top-notch.", 4.7, 243, 65),
("Controversial Ending", "Good game, but the ending divided fans.", 4.2, 243, 66),
("Memorable Characters", "A satisfying farewell to beloved characters.", 4.8, 243, 67),
("Stunning Visuals", "The graphics are impressive for the time.", 4.7, 243, 68),
("Best in the Series", "The gameplay improvements shine.", 4.9, 243, 69),
("Powerful Soundtrack", "The music adds so much emotion.", 4.8, 243, 70),
("Meaningful Choices", "Decisions carry a lot of weight.", 4.7, 243, 71),
("A Must-Play", "A worthy finale to an incredible series.", 4.9, 243, 72);

-- Recensioni per "Mass Effect Legendary Edition" (GameID 22)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Ultimate Edition", "The definitive way to experience the trilogy.", 5.0, 22, 73),
("Fantastic Remaster", "The graphics upgrade is incredible.", 4.8, 22, 74),
("Great for New Players", "Perfect for newcomers to the series.", 5.0, 22, 75),
("Nostalgia Trip", "Brought back so many memories.", 4.9, 22, 76),
("All-in-One Package", "Having all DLCs included is fantastic.", 5.0, 22, 77),
("Improved Gameplay", "Combat feels smoother across all games.", 4.8, 22, 78),
("Timeless Story", "The narrative remains as captivating as ever.", 5.0, 22, 79),
("Epic Sci-Fi Adventure", "An unmissable journey for RPG fans.", 5.0, 22, 80),
("Worth Every Penny", "Incredible value for the content provided.", 4.9, 22, 81),
("Best Remaster", "One of the best remastered collections ever.", 5.0, 22, 82);

-- Recensioni per "Metal Gear Solid V: The Phantom Pain" (GameID 18)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Open-World Stealth", "Revolutionizes the stealth genre.", 4.9, 18, 83),
("Amazing Freedom", "So many ways to approach missions.", 4.8, 18, 84),
("Immersive Gameplay", "The mechanics are incredibly detailed.", 5.0, 18, 85),
("Stunning Visuals", "The Fox Engine delivers breathtaking graphics.", 4.9, 18, 86),
("Epic Story", "A great narrative, although it feels unfinished.", 4.6, 18, 87),
("Best in the Series", "Pushes the franchise to new heights.", 4.9, 18, 88),
("Addictive Base Building", "Managing Mother Base is surprisingly fun.", 4.8, 18, 89),
("Perfect Combat", "The gunplay and stealth options are excellent.", 4.9, 18, 90),
("Innovative Design", "Revolutionary for open-world games.", 4.8, 18, 91),
("A True Masterpiece", "Kojima's vision shines through.", 5.0, 18, 92);


-- Recensioni per "Metro Exodus" (GameID 244)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Atmospheric Masterpiece", "A stunning post-apocalyptic adventure.", 4.8, 244, 93),
("Immersive Storytelling", "The narrative is captivating and emotional.", 4.7, 244, 94),
("Breathtaking World", "The graphics and environments are top-notch.", 4.9, 244, 95),
("Great Gameplay", "Exploration and combat are well balanced.", 4.8, 244, 96),
("Detailed Characters", "You truly care about the characters.", 4.7, 244, 97),
("Challenging and Fun", "A rewarding experience for FPS fans.", 4.8, 244, 98),
("Dynamic Weather", "The weather system is incredibly realistic.", 4.9, 244, 99),
("Engaging Side Quests", "Side missions add depth to the world.", 4.7, 244, 100),
("A Visual Feast", "The game is a treat for the eyes.", 4.8, 244, 101),
("One of the Best FPS Games", "A must-play for fans of the genre.", 4.9, 244, 102);

-- Recensioni per "Minecraft" (GameID 186)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Endless Creativity", "A game where your imagination is the limit.", 5.0, 186, 103),
("Timeless Classic", "Minecraft remains relevant even today.", 4.9, 186, 104),
("Relaxing and Fun", "Perfect for unwinding or building epic structures.", 4.8, 186, 105),
("Best Sandbox Game", "Nothing compares to Minecraft's freedom.", 5.0, 186, 106),
("Great for All Ages", "A game that everyone can enjoy.", 4.9, 186, 107),
("Incredible Replayability", "You can keep playing for years.", 5.0, 186, 108),
("Thriving Community", "Mods and servers add endless possibilities.", 4.8, 186, 109),
("Survival Mode is Amazing", "Challenging and rewarding gameplay.", 4.7, 186, 110),
("Constant Updates", "Developers keep the game fresh.", 4.9, 186, 111),
("Iconic Game", "A cultural phenomenon in gaming.", 5.0, 186, 112);

-- Recensioni per "MLB The Show 23" (GameID 80)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Best Baseball Game", "MLB The Show 23 captures the essence of baseball.", 4.7, 80, 113),
("Incredible Graphics", "The visuals are incredibly lifelike.", 4.8, 80, 114),
("Realistic Gameplay", "Feels like playing a real game of baseball.", 4.7, 80, 115),
("Deep Franchise Mode", "A lot of detail for management lovers.", 4.6, 80, 116),
("Improved Mechanics", "Hitting and pitching feel smoother.", 4.8, 80, 117),
("Authentic Presentation", "The commentary and atmosphere are top-notch.", 4.9, 80, 118),
("Great for Fans", "Perfect for die-hard baseball enthusiasts.", 4.6, 80, 1),
("Variety of Modes", "Plenty of options to keep things fresh.", 4.7, 80, 2),
("Fun Online Play", "Multiplayer is engaging and competitive.", 4.8, 80, 3),
("Highly Polished", "Feels like a labor of love for the sport.", 4.9, 80, 4);


-- Recensioni per "Monster Hunter: World" (GameID 29)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Incredible Monster Battles", "The fights are intense and rewarding.", 4.8, 29, 5),
("Stunning Environments", "The world design is breathtaking.", 4.9, 29, 6),
("Addictive Gameplay", "Hunting and crafting keep you hooked.", 4.7, 29, 7),
("Best Co-op Experience", "Playing with friends is a blast.", 4.8, 29, 8),
("Deep Progression System", "Upgrading gear is satisfying.", 4.7, 29, 9),
("Challenging and Fun", "Perfect balance of difficulty and enjoyment.", 4.8, 29, 10),
("Great Variety of Monsters", "Each fight feels unique.", 4.9, 29, 11),
("Amazing Soundtrack", "The music enhances every hunt.", 4.8, 29, 12),
("Expansive World", "So much to explore and discover.", 4.9, 29, 13),
("A Masterpiece", "One of the best action RPGs ever.", 5.0, 29, 14);

-- Recensioni per "Monument Valley" (GameID 161)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Beautiful Design", "The art style is stunning.", 4.9, 161, 15),
("Relaxing Gameplay", "Perfect for casual puzzle fans.", 4.8, 161, 16),
("Innovative Puzzles", "Each level is cleverly designed.", 4.7, 161, 17),
("Great Mobile Game", "One of the best experiences on mobile.", 4.9, 161, 18),
("Unique Perspective", "Mind-bending visuals and mechanics.", 4.8, 161, 19),
("Short but Sweet", "A brief but unforgettable journey.", 4.7, 161, 20),
("Mesmerizing Soundtrack", "The music perfectly complements the visuals.", 4.9, 161, 21),
("Perfect for All Ages", "Simple yet engaging for everyone.", 4.8, 161, 22),
("Artistic Masterpiece", "Feels like playing a work of art.", 5.0, 161, 23),
("Highly Polished", "Every detail is crafted with care.", 4.9, 161, 24);

-- Recensioni per "Mortal Kombat 1" (GameID 184)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Brutal Fights", "The fatalities are more intense than ever.", 4.8, 184, 25),
("Gorgeous Visuals", "The graphics are truly next-gen.", 4.9, 184, 26),
("Smooth Combat", "The gameplay is fluid and satisfying.", 4.8, 184, 27),
("Engaging Story Mode", "A surprisingly deep narrative.", 4.7, 184, 28),
("Great Roster", "The character lineup is fantastic.", 4.8, 184, 29),
("Amazing Multiplayer", "Online battles are addictive.", 4.7, 184, 30),
("Classic MK Vibes", "Feels like a love letter to longtime fans.", 4.9, 184, 31),
("Innovative Mechanics", "New features add depth to combat.", 4.8, 184, 32),
("Outstanding Sound Design", "The audio adds to the visceral experience.", 4.9, 184, 33),
("Best in the Series", "Mortal Kombat has never been better.", 5.0, 184, 34);


-- Recensioni per "Mortal Kombat 11" (GameID 147)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("The Ultimate Fighter", "Mortal Kombat 11 brings the best of the series.", 4.9, 147, 35),
("Brutal and Beautiful", "The fatalities are more brutal and stunning than ever.", 4.8, 147, 36),
("Tight Combat System", "The gameplay is perfectly balanced and responsive.", 4.9, 147, 37),
("Incredible Roster", "A great mix of classic and new characters.", 4.7, 147, 38),
("The Best Mortal Kombat Yet", "Innovative features with a fantastic story mode.", 5.0, 147, 39),
("Fantastic Visuals", "Every fight is a visual spectacle.", 4.8, 147, 40),
("Great Storyline", "The narrative is engaging and cinematic.", 4.7, 147, 41),
("Multiplayer Madness", "Online matches are fast and competitive.", 4.8, 147, 42),
("Perfect for Fans", "A must-have for any Mortal Kombat fan.", 5.0, 147, 43),
("Fantastic Sound Design", "The sound effects make every hit feel impactful.", 4.9, 147, 44);

-- Recensioni per "Mortal Kombat X" (GameID 185)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Epic Battles", "Mortal Kombat X delivered some of the best battles in the series.", 4.8, 185, 45),
("Great Roster", "The character selection is diverse and interesting.", 4.7, 185, 46),
("Immersive Story", "A thrilling story mode that pulls you in.", 4.8, 185, 47),
("Stunning Graphics", "The visuals are incredible for the time.", 4.9, 185, 48),
("Intense Combat", "The combat is fast-paced and brutal.", 4.8, 185, 49),
("Flawless Victory", "The game feels smooth and polished in every way.", 4.7, 185, 50),
("Great New Features", "The X-rays and variations are a fantastic addition.", 4.8, 185, 51),
("Excellent Online Play", "Multiplayer is fast and fun.", 4.7, 185, 52),
("Mortal Kombat at Its Best", "A game that brings the series back to its roots.", 5.0, 185, 53),
("Powerful Soundtrack", "The soundtrack pumps up the intensity of every fight.", 4.9, 185, 54);

-- Recensioni per "MotoGP 22" (GameID 245)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Best MotoGP Game", "The most realistic MotoGP experience to date.", 4.9, 245, 55),
("Incredible Racing", "The racing feels fast and exhilarating.", 4.8, 245, 56),
("Great Physics", "The bike handling is spot on and rewarding.", 4.9, 245, 57),
("Deep Career Mode", "The career mode offers a lot of depth and replayability.", 4.8, 245, 58),
("Realistic Graphics", "The visuals are fantastic, especially the bike models.", 4.9, 245, 59),
("Fantastic Sound Design", "The roar of the engines is incredible.", 4.7, 245, 60),
("Challenging AI", "The AI opponents keep you on your toes.", 4.8, 245, 61),
("Great Online Play", "Competing against others online is a thrill.", 4.7, 245, 62),
("Perfect for MotoGP Fans", "A must-play for any MotoGP enthusiast.", 5.0, 245, 63),
("A True MotoGP Experience", "Everything about the game feels authentic and well-executed.", 4.9, 245, 64);


-- Recensioni per "MotoGP 23" (GameID 89)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Best in the Series", "MotoGP 23 offers the most refined racing experience yet.", 4.9, 89, 65),
("Incredible Realism", "The bike handling and physics are incredible.", 4.8, 89, 66),
("Immersive Career Mode", "A deeply engaging career mode with tons of content.", 4.9, 89, 67),
("Stunning Visuals", "The game looks amazing with realistic bike models and environments.", 4.8, 89, 68),
("Challenging Races", "The AI opponents provide a tough challenge.", 4.7, 89, 69),
("Great for MotoGP Fans", "A must-play for anyone who loves motorcycle racing.", 5.0, 89, 70),
("Perfect Controls", "The controls are intuitive, making for a smooth gameplay experience.", 4.8, 89, 71),
("Exciting Multiplayer", "Online racing is fast and competitive.", 4.7, 89, 72),
("Detailed Soundtrack", "The engine sounds are incredible, adding to the immersion.", 4.9, 89, 73),
("True to the Sport", "MotoGP 23 captures the essence of professional racing.", 5.0, 89, 74);

-- Recensioni per "NBA 2K23" (GameID 79)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Step Forward", "NBA 2K23 improves on the previous titles with better mechanics and graphics.", 4.8, 79, 75),
("Amazing Gameplay", "The game feels more realistic with new animations and physics.", 4.9, 79, 76),
("Deep MyCareer Mode", "The career mode is immersive with plenty of storylines and choices.", 4.8, 79, 77),
("Improved Graphics", "The visual upgrade is noticeable, especially during the games.", 4.7, 79, 78),
("Great Roster", "All the latest rosters and accurate player likenesses make the game feel authentic.", 4.8, 79, 79),
("Solid Online Play", "Multiplayer is fast and smooth, with little lag.", 4.7, 79, 80),
("Realistic Commentary", "The commentary has improved and adds to the atmosphere.", 4.9, 79, 81),
("Variety of Game Modes", "There's something for everyone, whether you prefer playing or managing.", 4.8, 79, 82),
("Great Customization", "You can create and tweak almost everything in the game.", 4.7, 79, 83),
("Highly Polished", "NBA 2K23 is the most polished basketball sim yet.", 5.0, 79, 84);

-- Recensioni per "NBA 2K24" (GameID 246)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A True Evolution", "NBA 2K24 takes everything that made 2K23 great and improves upon it.", 4.9, 246, 85),
("Next-Gen Features", "The new features feel like a true next-gen experience.", 4.8, 246, 86),
("More Realistic", "The game feels even more lifelike with new animations and better AI.", 4.9, 246, 87),
("Fantastic MyCareer Mode", "The story mode is deep and engaging, with new plot twists.", 5.0, 246, 88),
("Impressive Visuals", "The graphics are stunning, and the player models are almost photorealistic.", 4.8, 246, 89),
("Competitive Multiplayer", "The online play is top-tier, with tight controls and fast matchmaking.", 4.7, 246, 90),
("Great Commentary", "The commentary is more dynamic and suits the flow of the game.", 4.9, 246, 91),
("Diverse Game Modes", "There's a mode for everyone, whether you like casual or competitive play.", 4.8, 246, 92),
("Authentic Basketball", "NBA 2K24 captures the true spirit of basketball better than any game before it.", 4.9, 246, 93),
("The Best NBA Sim", "Hands down the best NBA game out there right now.", 5.0, 246, 94);

-- Recensioni per "NBA 2K25" (GameID 247)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A New Era for NBA 2K", "NBA 2K25 brings innovative features and improved mechanics.", 4.9, 247, 95),
("Unmatched Realism", "The graphics and gameplay feel incredibly realistic.", 5.0, 247, 96),
("Incredible Career Mode", "MyCareer mode is deeply immersive with new storylines and gameplay mechanics.", 4.8, 247, 97),
("New Customization Options", "The character and gameplay customization is taken to the next level.", 4.7, 247, 98),
("Smooth Online Play", "The multiplayer matches run flawlessly with little lag.", 4.9, 247, 99),
("More Dynamic Commentary", "The commentary feels more reactive and dynamic this year.", 4.8, 247, 100),
("Immersive Graphics", "The player models and arenas look stunning, as if watching a real game.", 4.9, 247, 101),
("Competitive Gameplay", "The gameplay is challenging, making each game feel like a real contest.", 4.8, 247, 102),
("Deep Game Modes", "From MyCareer to MyTeam, there is so much to do in this game.", 4.7, 247, 103),
("NBA 2K at Its Peak", "This is by far the best NBA 2K experience to date.", 5.0, 247, 104);

-- Recensioni per "Need for Speed: Unbound" (GameID 83)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Thrilling Ride", "Need for Speed: Unbound delivers intense races and fast-paced action.", 4.8, 83, 105),
("Stylish Visuals", "The art style is fresh and vibrant, with amazing car designs.", 4.9, 83, 106),
("Fast and Furious", "The races are fast, exhilarating, and non-stop fun.", 4.8, 83, 107),
("Great Soundtrack", "The soundtrack pumps you up during every race.", 4.7, 83, 108),
("Intense Pursuits", "The cops are relentless, making every chase exciting.", 4.9, 83, 109),
("Fun Car Customization", "Tuning and customizing cars is as fun as the races themselves.", 4.8, 83, 110),
("Perfect for Racing Fans", "This is everything a racing game should be, and more.", 5.0, 83, 111),
("Challenging AI", "The AI opponents will keep you on your toes.", 4.7, 83, 112),
("Great Storyline", "The story mode adds extra depth to the game.", 4.8, 83, 113),
("Pure Racing Fun", "Need for Speed: Unbound is pure, unadulterated racing fun.", 5.0, 83, 114);

-- Recensioni per "New World" (GameID 127)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Amazing World Design", "The world in New World is vast and beautifully designed.", 4.9, 127, 115),
("Engaging Combat System", "The combat feels rewarding, especially when you master the different weapon types.", 4.8, 127, 116),
("Fantastic MMO Experience", "One of the best MMOs out there right now.", 4.9, 127, 117),
("Endless Exploration", "There's always something new to discover in the world.", 4.7, 127, 118),
("Great Crafting and Trading", "The crafting system is deep and engaging, with plenty of resources to gather.", 4.8, 127, 119),
("Strong Community", "The player community is vibrant and helpful.", 4.9, 127, 120),
("Awesome PvP", "The PvP battles are intense and strategic.", 4.7, 127, 121),
("Challenging and Rewarding", "The game rewards persistence with amazing loot and progression.", 4.8, 127, 122),
("Amazing Art Style", "The visuals are stunning, from the environments to the character models.", 4.9, 127, 123),
("A World Like No Other", "New World offers an unforgettable adventure in a beautifully crafted universe.", 5.0, 127, 124);


-- Recensioni per "NFL 25" (GameID 248)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Football at Its Best", "NFL 25 delivers the most realistic football experience yet.", 4.9, 248, 125),
("Fantastic Gameplay", "The gameplay is smooth, with great player controls and physics.", 4.8, 248, 126),
("Realistic AI", "The AI plays smart, making every match feel authentic.", 4.7, 248, 127),
("Great Career Mode", "The career mode is deep and immersive with realistic management options.", 5.0, 248, 128),
("Intense Matches", "The matches are fast-paced, with realistic strategies and plays.", 4.9, 248, 129),
("Incredible Graphics", "The graphics are stunning, capturing the true essence of football.", 4.8, 248, 130),
("Solid Online Play", "Multiplayer matches are exciting and smooth, with little lag.", 4.7, 248, 131),
("Exciting Commentary", "The commentary adds to the atmosphere of the game.", 4.8, 248, 132),
("Authentic NFL Experience", "NFL 25 captures the real NFL experience with perfect precision.", 5.0, 248, 133),
("A Must-Have for Football Fans", "The best football sim out there, hands down.", 4.9, 248, 134);

-- Recensioni per "Ni no Kuni II: Revenant Kingdom" (GameID 56)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Enchanting RPG", "Ni no Kuni II is a magical and beautiful RPG, with a captivating story.", 5.0, 56, 135),
("Charming World", "The world is full of life, and the animation style is mesmerizing.", 4.9, 56, 136),
("Fun Combat System", "The combat is engaging with plenty of room for strategy.", 4.8, 56, 137),
("Great Characters", "The characters are well-developed and easy to relate to.", 4.9, 56, 138),
("Perfect for RPG Lovers", "This is one of the most enjoyable RPGs I've played in years.", 5.0, 56, 139),
("Amazing Music", "The soundtrack is beautiful, complementing the magical atmosphere of the game.", 4.9, 56, 140),
("Rich Storyline", "The story is emotional and keeps you hooked from start to finish.", 4.8, 56, 141),
("A Game for All Ages", "Perfect for both kids and adults, it's a game that anyone can enjoy.", 5.0, 56, 142),
("Fun Side Quests", "The side quests are rewarding and provide hours of additional content.", 4.7, 56, 143),
("Stunning Visuals", "The visuals are colorful and breathtaking, a true feast for the eyes.", 4.9, 56, 144);

-- Recensioni per "Nier: Automata" (GameID 33)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Masterpiece of Gaming", "Nier: Automata is a game that blends story, gameplay, and philosophy perfectly.", 5.0, 33, 145),
("Innovative Combat", "The combat system is fast-paced and exhilarating, blending different genres.", 4.9, 33, 146),
("Deep and Thoughtful Story", "The story is emotional and thought-provoking, leaving a lasting impact.", 5.0, 33, 147),
("Unique Gameplay Mechanics", "The switching between different perspectives and playstyles is refreshing.", 4.8, 33, 148),
("Memorable Soundtrack", "The music is hauntingly beautiful and fits the game's tone perfectly.", 5.0, 33, 149),
("Visually Stunning", "The game's aesthetic is beautiful, with a post-apocalyptic world that feels alive.", 4.9, 33, 150),
("Philosophical Themes", "The game asks deep questions about existence, identity, and purpose.", 4.8, 33, 151),
("Challenging Boss Fights", "The boss fights are intense and require strategy to defeat.", 4.9, 33, 152),
("Multiple Endings", "The multiple endings offer a lot of replay value and different perspectives on the story.", 5.0, 33, 153),
("A Must-Play Game", "Nier: Automata is an unforgettable gaming experience that everyone should play.", 5.0, 33, 154);

-- Recensioni per "Nioh" (GameID 249)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Challenging Samurai Action", "Nioh provides a tough but rewarding action RPG experience.", 4.9, 249, 155),
("Epic Combat System", "The combat is fast-paced and deeply satisfying with plenty of weapon variety.", 4.8, 249, 156),
("Rich Japanese Mythology", "The game incorporates rich Japanese mythology and lore.", 4.7, 249, 157),
("Difficult but Fair", "Nioh is a tough game, but it's fair and keeps you coming back for more.", 5.0, 249, 158),
("Incredible Boss Fights", "The boss fights are some of the best and most challenging in gaming.", 4.9, 249, 159),
("Stunning Visuals", "The environments and character designs are gorgeous, bringing Japan's feudal era to life.", 4.8, 249, 160),
("Deep RPG Elements", "The RPG mechanics are deep, with plenty of skill trees, gear, and customization options.", 4.7, 249, 161),
("Great Co-op Gameplay", "The multiplayer co-op mode adds extra fun and challenge to the game.", 4.9, 249, 162),
("Tough but Addictive", "The difficulty can be overwhelming, but it's highly addictive and rewarding.", 5.0, 249, 163),
("Masterpiece of Combat", "If you love challenging combat, Nioh is a must-play.", 4.8, 249, 164);

-- Recensioni per "No Man"s Sky" (GameID 250)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Infinite Exploration", "No Man's Sky offers infinite possibilities for exploration and adventure in space.", 5.0, 250, 165),
("Stunning Universe", "The procedurally generated universe is vast and beautiful, with countless planets to discover.", 4.9, 250, 166),
("Improved Gameplay", "The game has come a long way since launch, with numerous updates and improvements.", 4.8, 250, 167),
("Fun Base Building", "Building and customizing your base on different planets is incredibly satisfying.", 4.7, 250, 168),
("Challenging Survival", "The survival elements are tough, but they make the game more engaging.", 4.9, 250, 169),
("Great Exploration System", "The exploration system is diverse and engaging, with plenty of discoveries to make.", 4.8, 250, 170),
("Incredible Variety", "There's a great variety of creatures, plants, and environments to discover on each planet.", 4.9, 250, 171),
("Enjoyable Multiplayer", "The multiplayer experience allows for great co-op exploration with friends.", 4.7, 250, 172),
("Endless Possibilities", "No Man's Sky is an endless universe full of new possibilities, and it's a lot of fun to explore.", 5.0, 250, 173),
("A True Space Adventure", "For anyone who loves space exploration, this game is a dream come true.", 5.0, 250, 174);

-- Recensioni per "Octopath Traveler" (GameID 34)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Beautifully Crafted RPG", "Octopath Traveler offers a stunning RPG experience with a unique visual style.", 5.0, 34, 175),
("Great Storytelling", "Each character has their own unique story, adding depth and variety to the game.", 4.9, 34, 176),
("Turn-Based Combat at Its Best", "The turn-based combat is strategic and offers plenty of room for customization.", 4.8, 34, 177),
("Charming Music", "The soundtrack is beautiful, perfectly fitting the game's tone.", 5.0, 34, 178),
("Visually Stunning", "The HD-2D style is absolutely breathtaking, with pixel art fused with modern lighting effects.", 4.9, 34, 179),
("Challenging Boss Fights", "The boss fights are tough but fair, offering great rewards for overcoming them.", 4.8, 34, 180),
("Deep and Engaging World", "The world is rich and full of secrets, making exploration incredibly rewarding.", 4.7, 34, 181),
("Multiple Storylines", "The eight characters each bring something unique, and their stories are well-told and emotional.", 5.0, 34, 182),
("Perfect for RPG Fans", "A fantastic RPG for fans of the genre, with great gameplay and a compelling world.", 4.8, 34, 183),
("A Masterpiece of Design", "Octopath Traveler is a well-crafted, beautiful RPG that every fan of the genre should play.", 5.0, 34, 184);


-- Recensioni per "Ori and the Blind Forest" (GameID 117)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Visual Masterpiece", "The hand-drawn animation is gorgeous, and the game's art direction is nothing short of spectacular. A true visual treat!", 5.0, 117, 185),
("An Emotional Ride", "Ori's story is emotional and heartfelt, with moments that will leave you teary-eyed. Truly one of the best narrative-driven games.", 4.9, 117, 186),
("Platforming Perfection", "The platforming mechanics are smooth and challenging, pushing your skills without being too punishing. A perfect balance.", 4.8, 117, 187),
("Enchanting Soundtrack", "The soundtrack is magical, setting the mood beautifully and enhancing the emotional weight of the story.", 5.0, 117, 188),
("A Beautiful, Yet Difficult Game", "The game can be tough, but it's the kind of challenge that's rewarding when you push through. Absolutely worth the effort!", 4.7, 117, 189),
("Brilliant Worldbuilding", "The world-building is top-tier. You feel connected to every area you explore, and the environments are alive with detail.", 5.0, 117, 190),
("A Challenging, But Fair Journey", "Ori is a tough platformer, but it never feels unfair. Each failure is a learning opportunity, making your eventual success that much sweeter.", 4.8, 117, 191),
("Visually Stunning, Emotionally Moving", "What Ori lacks in combat, it more than makes up for with its emotional story and breathtaking visuals. A must-play for fans of narrative-driven games.", 5.0, 117, 192),
("Frustrating Yet Addictive", "At times, the difficulty is overwhelming, but the addictive gameplay keeps me coming back for more. A truly captivating experience.", 4.7, 117, 193),
("An Instant Classic", "Ori and the Blind Forest is one of those games that sticks with you. It's rare to see a game with such a beautiful combination of visuals, music, and story.", 5.0, 117, 194);

-- Recensioni per "Ori and the Will of the Wisps" (GameID 99)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("The Perfect Sequel", "Ori and the Will of the Wisps improves on everything that made the first game great. A brilliant follow-up that's even better than the original.", 5.0, 99, 195),
("A Gorgeous Sequel", "The visuals are even more stunning, and the world feels even bigger and more expansive than before. It's a visual marvel!", 4.9, 99, 196),
("Incredible Platforming", "The platforming is top-notch, with new mechanics that make the gameplay even more fun and challenging. I can't get enough of it!", 5.0, 99, 197),
("A Masterpiece in Every Way", "From the beautiful visuals to the emotionally-charged story, Ori and the Will of the Wisps is a true masterpiece. A must-play for platformer fans.", 5.0, 99, 198),
("A Stunning Soundtrack", "The soundtrack is even better than the first game, perfectly capturing the emotional highs and lows of the journey.", 5.0, 99, 199),
("Expanded Gameplay", "The new combat and exploration elements add so much depth. I was hooked from the very first moment.", 4.8, 99, 200),
("Larger and More Beautiful", "The world feels so much larger, and it's filled with gorgeous environments that make exploring a true joy.", 4.9, 99, 201),
("A Truly Emotional Journey", "The game takes you on an emotional rollercoaster, and the ending left me in tears. Ori's journey is one I won't soon forget.", 5.0, 99, 202),
("Innovative and Beautiful", "Ori and the Will of the Wisps is the perfect example of how sequels should be done. It innovates, yet stays true to what made the first game so great.", 4.8, 99, 203),
("Satisfying and Rewarding", "Every moment feels satisfying, whether it's completing a difficult puzzle or unlocking a new area. This game is filled with rewards for players.", 4.9, 99, 204);

-- Recensioni per "Outlast" (GameID 252)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A True Horror Experience", "Outlast is a true survival horror experience. The tension is palpable, and the game constantly keeps you on the edge of your seat.", 5.0, 252, 205),
("Gritty and Unsettling", "The game's gritty atmosphere and haunting sound design create a feeling of dread that never lets up. It's disturbing in the best way.", 4.9, 252, 206),
("Heart-Pounding Suspense", "Every step is tense, and the game's unpredictable jump scares keep you jumping every time. Outlast delivers one of the scariest experiences in gaming.", 5.0, 252, 207),
("A Game That Makes You Fear the Dark", "Outlast does an excellent job at making you fear the dark. You feel vulnerable and exposed with no way to defend yourself against the horrors that await.", 4.8, 252, 208),
("Psychological Horror at Its Finest", "This game is more than just jumpscares. It's a psychological horror that makes you question everything around you.", 5.0, 252, 209),
("An Unforgiving Horror", "The lack of combat makes every encounter more nerve-wracking. You'll be running and hiding more than fighting, which adds to the intensity.", 4.7, 252, 210),
("A Terrifying Ride", "Outlast is not for the faint of heart. It's one of the scariest games I've played, and it does a great job of putting you in a constant state of fear.", 5.0, 252, 211),
("Chilling and Thrilling", "The constant tension throughout the game, combined with a chilling atmosphere, makes Outlast a thrilling ride. You never know what's around the corner.", 4.9, 252, 212),
("Horrifyingly Addictive", "Outlast is terrifying, but that's what makes it so addictive. The need to continue playing just to find out what happens next is overpowering.", 4.8, 252, 213),
("Survival Horror Done Right", "Outlast is the perfect survival horror game. It has everything – terrifying moments, a gripping story, and a haunting atmosphere. A must-play for horror fans.", 5.0, 252, 214);


-- Recensioni per "Outlast II" (GameID 141)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Even More Terrifying Than the First", "Outlast II ups the ante with even more horrific moments. The psychological tension and disturbing imagery will leave you breathless.", 5.0, 141, 215),
("A Darker, More Twisted Journey", "The game takes everything great about the first Outlast and cranks it up. It's darker, more twisted, and even more challenging.", 4.9, 141, 216),
("Horrifyingly Beautiful", "The environments are stunning and terrifying at the same time. The level design adds to the game's terrifying atmosphere.", 5.0, 141, 217),
("Gripping and Intense", "Outlast II delivers a gripping narrative that's filled with suspense and terror. The feeling of being hunted is constant, and it never lets up.", 5.0, 141, 218),
("Messed Up and Masterfully Done", "The disturbing imagery and themes can be unsettling, but it's done with such precision. It's a horror experience like no other.", 4.8, 141, 219),
("A Frightening Psychological Horror", "The psychological horror aspects of this game are top-tier. The game messes with your mind as much as it does your nerves.", 4.9, 141, 220),
("Too Scary for Me", "Outlast II might be too terrifying for some players. The jump scares are relentless, and the atmosphere is deeply unnerving.", 4.5, 141, 221),
("Survival Horror at Its Best", "If you're a fan of survival horror, Outlast II is a must-play. It's a beautiful, horrifying, and intensely atmospheric game.", 5.0, 141, 222),
("The Scariest Sequel", "Outlast II took everything from the original and made it scarier, with a more complex story and more terrifying gameplay. Not for the faint of heart!", 4.9, 141, 223),
("Terrifyingly Brilliant", "The pacing, the setting, the story—it all comes together to create an unforgettable horror experience. Outlast II is brilliant in its terror.", 5.0, 141, 224);

-- Recensioni per "Outlast Trials" (GameID 251)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Multiplayer Horror Done Right", "Outlast Trials brings a fresh twist to the franchise with multiplayer. The fear is still there, but it's more fun to experience with friends!", 5.0, 251, 225),
("Co-op Horror Perfection", "Playing Outlast Trials with friends is an absolute blast. The tension is even higher, knowing that you have to rely on each other to survive.", 4.8, 251, 226),
("A New Take on a Classic", "The cooperative gameplay adds a new dimension to the Outlast formula. It's not just about surviving on your own anymore—teamwork is key!", 4.9, 251, 227),
("Scary and Strategic", "Not only do you have to deal with terrifying enemies, but now you also have to strategize with your teammates. It's a perfect mix of horror and tactics.", 5.0, 251, 228),
("Outlast, But With Friends", "The trials are definitely harder when you're trying to coordinate with others, but it makes it all the more fun. A great twist on the classic horror formula.", 4.7, 251, 229),
("A Truly Terrifying Multiplayer Experience", "The co-op experience in Outlast Trials is terrifying. There's nothing more horrifying than trying to escape while others scream in fear beside you.", 5.0, 251, 230),
("Multiplayer Horror That Works", "It's hard to make multiplayer horror work, but Outlast Trials nails it. The tension of being pursued by horrific creatures, now with friends, is an absolute thrill.", 4.9, 251, 231),
("Horror With a Twist", "The new trials system is creative, and the multiplayer experience is fun, but it still holds that classic Outlast terror.", 4.8, 251, 232),
("Not As Scary as the Originals", "While it's fun to play with friends, it's not quite as scary as the original Outlast games. Still a fun experience, though.", 4.5, 251, 233),
("Outlast Gets a Fun Update", "Outlast Trials is a great evolution of the franchise. It's not just about fear anymore—it's about surviving with friends in a world full of monsters.", 4.8, 251, 234);

-- Recensioni per "Overcooked! 2" (GameID 136)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Chaos in the Kitchen", "Overcooked! 2 brings chaos to the kitchen in the best way possible. Playing with friends is a hilarious, stress-inducing experience that I can't stop playing.", 5.0, 136, 235),
("A Fun and Frantic Experience", "The cooperative gameplay is frantic but fun. It's a great game to play with friends, but be ready for some heated moments in the kitchen!", 4.8, 136, 236),
("More Fun, More Chaos", "Overcooked! 2 takes everything that made the first game great and cranks it up a notch. The new levels and mechanics keep the chaos fresh and exciting.", 5.0, 136, 237),
("A Perfect Party Game", "This game is perfect for parties. It's chaotic, fun, and the levels are challenging enough to keep everyone on their toes. Highly recommend!", 5.0, 136, 238),
("Cooking Under Pressure", "The pressure in Overcooked! 2 is real, but that's what makes it so fun. You're constantly rushing to finish orders and trying to avoid burning everything.", 4.7, 136, 239),
("Frantic Fun", "It's frantic, it's stressful, but it's also one of the most fun games I've played with friends. Perfect for a group of people looking for a fun time.", 5.0, 136, 240),
("A Hilarious Cooking Experience", "There's nothing more hilarious than watching your friends try to work together and failing miserably. Overcooked! 2 is a true party game.", 4.9, 136, 241),
("Culinary Mayhem", "If you like stress and chaos, this game delivers! Overcooked! 2 is pure mayhem in the kitchen, and I love every second of it.", 5.0, 136, 242),
("So Much Fun, So Much Chaos", "Trying to coordinate with others to get orders out on time is a fun challenge. It's chaotic and hilarious, but also very rewarding.", 4.8, 136, 243),
("A Recipe for Fun", "Overcooked! 2 is the perfect recipe for fun. It's fast-paced, chaotic, and filled with moments that will make you laugh out loud. A must-have for party nights.", 4.9, 136, 244);

-- Recensioni per "Path of Exile" (GameID 46)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Deep ARPG", "Path of Exile is a deep and engaging action RPG that rewards time spent. The skill tree is vast, offering endless customization and replayability.", 5.0, 46, 245),
("Endgame Content is King", "The game excels in endgame content with its maps, challenges, and leagues. There's always something to do, even after hours of play.", 4.9, 46, 246),
("Addictive and Immersive", "Path of Exile's loot system and skill customization are incredibly addictive. The atmosphere and complexity make it a top-tier ARPG.", 5.0, 46, 247),
("Difficult But Rewarding", "The difficulty of Path of Exile is something to be respected. It doesn't hold your hand, but the rewards for overcoming challenges are well worth it.", 4.8, 46, 248),
("A Hardcore Player's Dream", "If you love hardcore action RPGs, this is a dream come true. The constant updates, leagues, and depth make it endlessly interesting.", 5.0, 46, 249),
("Complex but Engaging", "There's a steep learning curve, but once you get the hang of it, Path of Exile becomes an addictive experience you can't stop playing.", 4.7, 46, 250),
("Overwhelming for New Players", "The game can feel overwhelming at first, but it's incredibly rewarding once you start understanding the systems. A true gem for ARPG fans.", 4.5, 46, 251),
("Free-to-Play Masterpiece", "The fact that Path of Exile is free-to-play is amazing. The microtransactions are cosmetic, and the gameplay is deep and rewarding.", 5.0, 46, 252),
("Endless Replayability", "There's so much to do, from experimenting with builds to pushing through endless endgame content. It's a game you'll keep coming back to.", 5.0, 46, 253),
("A True ARPG Experience", "Path of Exile is one of the best action RPGs I've ever played. Its complex systems and dark atmosphere make it one of a kind.", 4.9, 46, 254);

-- Recensioni per "Payday 3" (GameID 253)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Co-op Heist Madness", "Payday 3 delivers co-op heist madness at its best. Team up with friends and plan the perfect robbery in this high-octane shooter.", 4.9, 253, 255),
("A Thrilling Ride", "Payday 3 is an intense, heart-pounding experience. The heist mechanics are polished, and the thrill of pulling off a successful robbery is unmatched.", 5.0, 253, 256),
("Teamwork Makes the Dream Work", "The game shines when played with friends. Cooperation is key, and the adrenaline rush from a well-executed heist is incredible.", 4.8, 253, 257),
("Great Fun, But Some Bugs", "The gameplay is great, but I've encountered a few bugs that disrupt the experience. Still, it's an excellent co-op shooter overall.", 4.5, 253, 258),
("Good, But Not Groundbreaking", "Payday 3 is more of the same, but that's not necessarily a bad thing. If you enjoyed the previous entries, you'll enjoy this one.", 4.7, 253, 259),
("A Solid Heist Game", "It's not revolutionary, but it's still a fun heist game. The AI could be improved, and more variety in missions would have been nice.", 4.5, 253, 260),
("A Step Forward for Payday", "Payday 3 feels like a proper step forward with new features, improved mechanics, and a more polished experience. It's a blast to play with friends.", 5.0, 253, 261),
("A Lot of Fun, but Can Get Repetitive", "The core gameplay is fantastic, but after a while, the missions start feeling repetitive. Still, a solid game for fans of the franchise.", 4.6, 253, 262),
("Nice Addition to the Series", "Payday 3 adds enough new content to justify the purchase. The heists are fun, and the new mechanics add some much-needed variety.", 4.8, 253, 263),
("Heists Are a Blast", "Executing the perfect heist with friends is incredibly satisfying. The gameplay is fun, and the mechanics are solid, but there's still room for improvement.", 4.7, 253, 264);

-- Recensioni per "Persona 5 Royal" (GameID 25)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Masterpiece in Every Way", "Persona 5 Royal is one of the best RPGs ever made. The story, characters, and music are all top-notch. A must-play for any fan of turn-based combat.", 5.0, 25, 265),
("A Perfect Blend of Style and Substance", "The game strikes the perfect balance between style and substance. The visuals, the music, the combat—everything is done with so much flair.", 5.0, 25, 266),
("A True Work of Art", "Persona 5 Royal elevates the Persona series to new heights. The improved content, the deeper story, and the unforgettable characters make it a standout game.", 5.0, 25, 267),
("Fantastic and Addictive", "The game is incredibly addictive. It's hard to put down once you start playing. The turn-based combat is deep, and the social simulation is charming.", 5.0, 25, 268),
("A Modern RPG Classic", "Persona 5 Royal is a modern classic. Its engaging story and complex characters make it a game worth playing over and over again.", 5.0, 25, 269),
("The Best Persona Game Yet", "Everything about Persona 5 Royal is better than the original. The added content, new characters, and expanded story make it the definitive version.", 5.0, 25, 270),
("Stylish and Fun", "From the stylish menus to the engaging turn-based combat, Persona 5 Royal is a blast. It's an RPG that knows how to entertain.", 4.9, 25, 271),
("A Long, But Rewarding Journey", "The game can be long, but every moment is worth it. The relationships with your friends and the dungeon crawling are both incredibly satisfying.", 4.8, 25, 272),
("A Magical RPG Experience", "Persona 5 Royal combines social simulation, dungeon exploration, and turn-based combat in a way that feels fresh and exciting. Highly recommended!", 5.0, 25, 273),
("Excellence in Every Aspect", "Persona 5 Royal is one of the most polished and well-designed RPGs. The story, the characters, and the gameplay are all top-tier.", 5.0, 25, 274);


-- Recensioni per "Phasmophobia" (GameID 145)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Terrifyingly Fun", "Phasmophobia is one of the scariest co-op games I've ever played. The atmosphere and the ghost mechanics make it an exhilarating experience.", 5.0, 145, 275),
("Perfect for Horror Fans", "If you're into horror, this is a must-play. The tension is real, and every ghost hunt feels like a nightmare waiting to unfold.", 5.0, 145, 276),
("Great Co-op Experience", "Phasmophobia is a fantastic co-op horror game. Playing with friends makes the experience more intense and fun, especially when things go horribly wrong.", 4.8, 145, 277),
("The Ultimate Ghost Hunt", "The interaction with ghosts and the need for teamwork make Phasmophobia a unique and terrifyingly fun game. Highly recommended for horror lovers.", 5.0, 145, 278),
("Scary Yet Addictive", "The game can be extremely scary at times, but the thrill of surviving or discovering the ghost's identity keeps you coming back for more.", 4.9, 145, 279),
("Intense and Atmospheric", "Phasmophobia excels in creating an atmosphere of pure fear. The sound design and the unpredictability of the ghosts are key to its success.", 5.0, 145, 280),
("A Fresh Take on Horror", "This game brings a fresh approach to horror. The fact that you have to communicate with the ghost using your voice adds an extra layer of immersion.", 4.7, 145, 281),
("Fun, But Can Be Frustrating", "While the game is fantastic when it works, there are times when the mechanics or bugs can get in the way of the fun. Still, it's a great experience overall.", 4.5, 145, 282),
("Scary with Friends", "Phasmophobia is terrifying alone, but it's even better when you're with friends. The laughter and screams make the game a memorable experience.", 5.0, 145, 283),
("Great, but Needs More Variety", "Phasmophobia is amazing, but after a few hours, the maps and ghost types start to feel repetitive. Still, it's a great horror experience with friends.", 4.6, 145, 284);

-- Recensioni per "Pillars of Eternity II: Deadfire" (GameID 41)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Masterpiece of RPG Design", "Pillars of Eternity II: Deadfire is an epic RPG that mixes great storytelling, complex characters, and strategic combat. One of the best RPGs of the decade.", 5.0, 41, 285),
("Immersive World, Great Story", "The world-building and lore in Pillars of Eternity II are incredible. The story feels alive, and the choices you make matter, offering great replayability.", 5.0, 41, 286),
("A True RPG Experience", "This game does a great job at blending narrative depth and tactical combat. The complexity can be overwhelming, but it's worth the effort.", 4.8, 41, 287),
("Engaging and Deep", "The game world is incredibly detailed, and the characters feel real. The real-time with pause combat system is also satisfying once you get the hang of it.", 4.9, 41, 288),
("A Bit Too Complex for Some", "Pillars of Eternity II can feel like a daunting experience for new players. The learning curve is steep, but it rewards those who stick with it.", 4.7, 41, 289),
("A Stunning RPG", "The story is fantastic, and the combat is deeply tactical. The only downside is that the pacing can sometimes feel slow. Otherwise, it's a brilliant game.", 4.8, 41, 290),
("Highly Replayable", "The game offers many different paths and choices, making it highly replayable. The characters and their development make this a memorable RPG.", 5.0, 41, 291),
("Great for RPG Fans", "If you're a fan of traditional isometric RPGs, this is a must-play. The combat is strategic, and the world is rich with lore.", 4.9, 41, 292),
("An RPG Masterpiece", "A deep and complex RPG that offers a lot of content, but the sheer amount of options and systems might be overwhelming for casual players.", 4.6, 41, 293),
("Story-driven RPG Excellence", "Pillars of Eternity II excels at storytelling. The choices you make impact the world, and the game's writing is some of the best in the RPG genre.", 5.0, 41, 294);

-- Recensioni per "Planet Zoo" (GameID 76)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Truly Beautiful Sim", "Planet Zoo is a stunning simulation game. The attention to detail in the animals and their habitats is incredible. It's a perfect game for simulation fans.", 5.0, 76, 295),
("Endless Creativity", "The amount of customization you can do with your zoo is insane. It's a perfect sandbox for anyone who loves design and management games.", 5.0, 76, 296),
("Relaxing Yet Challenging", "While the game is relaxing, the challenge of managing a zoo with many different animals and visitors can be overwhelming at times. It's a fantastic experience overall.", 4.8, 76, 297),
("Incredibly Detailed", "Planet Zoo has an insane level of detail, from the animals to the guests. The game lets you create the zoo of your dreams, but it also challenges you to maintain it.", 5.0, 76, 298),
("Highly Addictive", "I didn't think I'd get so hooked on a zoo simulation game, but here we are. Planet Zoo is addictive and offers so much depth and creativity.", 4.9, 76, 299),
("A Beautiful, Complex Simulation", "Planet Zoo is a complex simulation that's both beautiful and engaging. The learning curve is steep, but it's worth the effort if you love these kinds of games.", 4.7, 76, 300),
("Perfect for Sandbox Lovers", "If you love sandbox games, Planet Zoo is a must. It's so satisfying to create your own zoo and watch it grow, even if it's hard work!", 5.0, 76, 301),
("A Great Zoo Management Game", "Planet Zoo is great for fans of management sims. The only downside is that it can sometimes feel repetitive when dealing with the same types of problems over and over again.", 4.6, 76, 302),
("Highly Detailed Yet Fun", "The level of detail in Planet Zoo is mind-blowing. Managing everything from animal happiness to guest satisfaction is both fun and challenging.", 4.9, 76, 303),
("A Perfect Simulation Game", "Planet Zoo is the perfect simulation game for anyone who loves building and managing systems. The animals, staff, and visitors all feel alive in this game.", 5.0, 76, 304);


-- Recensioni per "Pokémon Black" (GameID 254)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Classic Pokémon", "Pokémon Black is a solid entry in the Pokémon series. The storyline is engaging, and the new Unova region is a fresh change from previous games.", 4.8, 254, 305),
("Great but Challenging", "The difficulty level in Pokémon Black feels higher than in previous games, which is a welcome change for long-time fans. The storyline is top-notch.", 4.7, 254, 306),
("A New Generation of Pokémon", "Pokémon Black introduced a new region and fresh Pokémon designs, making it an exciting adventure. The battle mechanics are also some of the best in the series.", 5.0, 254, 307),
("Good, but Missing Some Features", "While the game is enjoyable, it's missing a few of the features I loved from earlier Pokémon games. Still, a strong entry in the series.", 4.5, 254, 308),
("Great for Nostalgia", "Pokémon Black brings back the nostalgia of the classic Pokémon games, but with enough new twists to keep it fresh and exciting.", 4.9, 254, 309),
("Interesting Region and Pokémon", "The Unova region feels different from the others, and the new Pokémon are interesting. The story is also more immersive than I expected.", 5.0, 254, 310),
("One of the Best", "Pokémon Black stands out for its storyline and the improvements in gameplay. The new Pokémon are fantastic, and the overall experience is really polished.", 5.0, 254, 311),
("Solid Entry in the Series", "While it's not the best Pokémon game, it is certainly one of the more solid entries. A fun adventure with great new additions to the series.", 4.6, 254, 312),
("Pokémon at Its Best", "The visuals and music are great, and the gameplay feels fresh and exciting. This is one of my favorite Pokémon games so far.", 5.0, 254, 313),
("A Worthy Pokémon Title", "Pokémon Black is a worthy title that improves on previous games. It's a fun adventure, though it does have some pacing issues at times.", 4.7, 254, 314);

-- Recensioni per "Pokémon Legends: Arceus" (GameID 255)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Fresh Take on Pokémon", "Pokémon Legends: Arceus is a breath of fresh air for the series. The open-world mechanics and the new battle system make it a unique experience.", 5.0, 255, 315),
("Innovative and Fun", "The new gameplay mechanics in Pokémon Legends: Arceus are revolutionary for the Pokémon franchise. The ability to explore the world and catch Pokémon in real-time is amazing.", 5.0, 255, 316),
("A Bold New Direction", "I love the open-world concept of this game. It brings something entirely new to Pokémon, and I hope the future games continue in this direction.", 4.9, 255, 317),
("Not Perfect, But Great", "While the game is groundbreaking, it has some technical issues and a few repetitive elements. Still, it's a must-play for Pokémon fans.", 4.7, 255, 318),
("Amazing New Mechanics", "Pokémon Legends: Arceus introduces a lot of new mechanics that make the gameplay feel fresh and exciting. The open world is a fantastic addition.", 5.0, 255, 319),
("A Beautiful World to Explore", "The world of Pokémon Legends: Arceus is beautiful and vast. It's a joy to explore, and the new Pokémon catching system is much more dynamic.", 4.8, 255, 320),
("Great, But Needs More Content", "The game's open-world mechanics are incredible, but it could use more variety in its quests and Pokémon species to keep things interesting.", 4.6, 255, 321),
("A Game-Changer", "This game completely changes how I look at Pokémon. The ability to roam freely and interact with Pokémon in their natural habitats is amazing.", 5.0, 255, 322),
("Best Pokémon Game in Years", "Pokémon Legends: Arceus has reinvigorated the series. The new mechanics and open-world design make it one of the best Pokémon games I've played.", 5.0, 255, 323),
("A Step in the Right Direction", "I'm loving the new gameplay style. The open world gives a more immersive experience, though I hope future updates improve some of the performance issues.", 4.7, 255, 324);

-- Recensioni per "Pokémon Scarlet" (GameID 256)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Stunning Visual Feast", "Pokémon Scarlet is visually stunning. The open-world environment is breathtaking, and the new Pokémon designs are fantastic. A truly beautiful game.", 5.0, 256, 325),
("Open-World Adventure", "Pokémon Scarlet's open-world features are exciting, allowing you to explore without restrictions. The gameplay is fresh, but it could use more polish.", 4.8, 256, 326),
("Fun but Not Perfect", "The game has great potential, but some mechanics still feel underdeveloped. Nonetheless, it's a fun adventure and worth playing for any Pokémon fan.", 4.6, 256, 327),
("A New Era for Pokémon", "Pokémon Scarlet represents a bold step forward for the franchise with its open-world design and new mechanics. The future of Pokémon looks bright!", 5.0, 256, 328),
("Fantastic But Repetitive", "While the open-world experience is a game-changer, the gameplay itself can get repetitive after a while. Still, it's a solid entry in the series.", 4.7, 256, 329),
("A Unique Pokémon Experience", "Pokémon Scarlet introduces a new way to experience the Pokémon universe. The open world is immersive, and there's a sense of freedom that was previously missing.", 5.0, 256, 330),
("Could Be Better", "The game is great, but some areas feel rushed. The open world is vast but lacks the depth that would make it truly exceptional.", 4.5, 256, 331),
("Innovative and Fun", "I love the new features in Pokémon Scarlet. The game feels fresh, though some technical issues take away from the overall experience.", 4.6, 256, 332),
("Excellent Pokémon Experience", "The open-world exploration and new Pokémon mechanics in Scarlet are brilliant. However, there are some aspects that could use improvement.", 4.8, 256, 333),
("Pokémon at Its Best", "Pokémon Scarlet is a great game. The world feels alive, and there's so much to explore. It's a fantastic evolution for the series!", 5.0, 256, 334);


-- Recensioni per "Pokémon Violet" (GameID 257)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Vibrant World", "Pokémon Violet offers a beautiful open-world experience with rich visuals and dynamic battles. The new Pokémon designs are amazing, and the freedom to explore is exhilarating.", 5.0, 257, 335),
("A Step Forward", "The open-world mechanics in Pokémon Violet are a huge improvement, making the game feel more immersive. The battles are fluid, and the world is vast and full of life.", 4.9, 257, 336),
("Stunning Visuals", "The visuals in Pokémon Violet are some of the best I've seen in the series. The game's world feels alive, and the new Pokémon designs are a real treat.", 5.0, 257, 337),
("Open World Done Right", "Pokémon Violet nails the open-world formula. The world is expansive and diverse, and I love how the battles and Pokémon catching feel more organic.", 4.8, 257, 338),
("A New Pokémon Adventure", "Pokémon Violet takes the series in an exciting direction with its open world and new mechanics. The game is a little rough around the edges, but overall, it's a fantastic experience.", 4.7, 257, 339),
("Solid Experience", "While Pokémon Violet is a beautiful game with great potential, some parts of the gameplay feel unfinished. However, it's still an enjoyable ride and a great addition to the series.", 4.5, 257, 340),
("Amazing New Features", "The exploration in Pokémon Violet is unlike anything we've seen before. The new battle system is fun, and there's a lot of room for customization and discovery.", 5.0, 257, 341),
("One of the Best", "Pokémon Violet is a fantastic game. The open world is a huge step forward for the franchise, and the new Pokémon mechanics make the game feel fresh and exciting.", 5.0, 257, 342),
("Fresh and Exciting", "Pokémon Violet brings a breath of fresh air to the franchise with its open-world gameplay. The battles are dynamic, and the ability to explore the world at your own pace is incredible.", 4.9, 257, 343),
("Could Be Perfect", "There's so much to love about Pokémon Violet, but the game could have benefited from a bit more polish. The world is stunning, and the gameplay is fun, but it's not flawless.", 4.6, 257, 344);

-- Recensioni per "Pokémon White" (GameID 258)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Classic Pokémon Adventure", "Pokémon White is a classic entry in the series. The storyline is compelling, and the Unova region is one of the most unique settings in the franchise.", 4.8, 258, 345),
("Great Gameplay, Great Story", "The gameplay in Pokémon White is top-notch, and the story keeps you invested from start to finish. The new Pokémon are also a highlight of this edition.", 5.0, 258, 346),
("Pokémon at Its Best", "Pokémon White is one of the best games in the series. The region is rich with history, and the new Pokémon designs are memorable. A must-play for any fan.", 5.0, 258, 347),
("A Welcome Addition", "Pokémon White brings a lot of new features and fresh ideas to the franchise. The story is deep, and the Pokémon designs are some of the most creative.", 4.9, 258, 348),
("Solid Pokémon Title", "Pokémon White is a solid Pokémon game. While it doesn't do anything drastically different, it's still a great game with a lot of fun mechanics and a great story.", 4.7, 258, 349),
("Challenging and Fun", "The difficulty level in Pokémon White is higher than in other games, which I really appreciate. The new region and Pokémon add a lot of depth to the game.", 4.8, 258, 350),
("Unique Region and Story", "Unova is a unique region with a great story to match. The Pokémon White adventure feels fresh, and I love the new characters and battle mechanics.", 5.0, 258, 351),
("Well-Designed", "Pokémon White does a great job of balancing the classic gameplay with new features. It's a fun game that stays true to the franchise while still introducing some great innovations.", 4.9, 258, 352),
("A Must-Play for Fans", "Pokémon White is a must-play for fans of the series. The battle system and new Pokémon designs are amazing, and the Unova region feels alive and well-crafted.", 5.0, 258, 353),
("One of My Favorites", "Pokémon White is one of my favorite games in the franchise. The new features, Pokémon, and region make it stand out from the rest.", 5.0, 258, 354);

-- Recensioni per "Pokémon X" (GameID 259)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Revolutionary Pokémon Game", "Pokémon X was a game-changer for the series. The introduction of 3D graphics and the new battle system made the game feel fresh and exciting.", 5.0, 259, 355),
("A Beautiful Adventure", "Pokémon X offers one of the most beautiful worlds in the series. The 3D visuals and dynamic battle system make for a truly enjoyable experience.", 4.9, 259, 356),
("New Features, Great Gameplay", "Pokémon X introduces new features like Mega Evolutions, which add an exciting layer to the gameplay. The story is engaging, and the world is a joy to explore.", 5.0, 259, 357),
("Refreshing and Fun", "Pokémon X is a refreshing take on the franchise. The graphics are stunning, and the new mechanics, like Mega Evolutions, are a fun addition to the series.", 5.0, 259, 358),
("A Classic Reborn", "Pokémon X feels like a rebirth of the series. The transition to 3D is beautiful, and the new features add a lot to the gameplay.", 4.8, 259, 359),
("Fantastic Pokémon Game", "Pokémon X brings a lot of fresh ideas to the series. The new battle mechanics and the stunning 3D world make it one of the best Pokémon games yet.", 5.0, 259, 360),
("Mega Evolutions Are Awesome", "Mega Evolutions are a fantastic addition to the game, adding new depth to battles. Pokémon X feels like a modern take on the classic formula.", 4.9, 259, 361),
("One of the Best Pokémon Games", "Pokémon X is one of the best entries in the series. The 3D graphics and new mechanics make it an unforgettable experience.", 5.0, 259, 362),
("Great Evolution of the Franchise", "The move to 3D was bold, but Pokémon X nails it. The game is visually stunning, and the new features make the gameplay more exciting than ever.", 5.0, 259, 363),
("Solid Pokémon Experience", "Pokémon X is a solid game with great new features, but it doesn't quite have the same charm as the older games. Still, it's a must-play for Pokémon fans.", 4.7, 259, 364);


-- Recensioni per "Pokémon Y" (GameID 260)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A New Pokémon Adventure", "Pokémon Y is a fantastic game that builds on the solid foundations of previous titles. The 3D graphics are a huge improvement, and the new features like Mega Evolutions make the game exciting.", 5.0, 260, 365),
("Fresh and Engaging", "Pokémon Y brings some fresh elements to the table, especially with the new Pokémon designs and the introduction of Mega Evolutions. The 3D world is a great touch.", 4.9, 260, 366),
("Beautiful and Fun", "Pokémon Y is a visually stunning game with great gameplay. The new features and improvements over previous titles make it one of the best in the series.", 5.0, 260, 367),
("Great Addition to the Series", "Pokémon Y is a great game with a lot of new features. The Mega Evolutions are a fantastic addition, and the new region feels vibrant and full of life.", 4.8, 260, 368),
("A Wonderful Experience", "Pokémon Y offers a beautiful world to explore with fantastic battle mechanics. The new Pokémon and features make it a must-play for fans of the series.", 5.0, 260, 369),
("A Step Forward", "The addition of 3D graphics in Pokémon Y is a big step forward for the franchise. The gameplay is solid, and the Mega Evolutions add a new layer of strategy.", 4.9, 260, 370),
("Innovative and Fun", "Pokémon Y introduces Mega Evolutions and a stunning 3D world, making the game feel fresh and exciting. The battles are more dynamic, and there's a lot to explore.", 5.0, 260, 371),
("Perfect for Pokémon Fans", "Pokémon Y has everything a fan of the series could want: great Pokémon designs, engaging gameplay, and an exciting new region to explore.", 5.0, 260, 372),
("Solid Pokémon Title", "While it doesn't reinvent the wheel, Pokémon Y is a solid entry in the franchise. The 3D world is beautiful, and the new features are fun to experiment with.", 4.7, 260, 373),
("Great Game, but Needs More", "Pokémon Y is a great game, but I feel it could have used more content. Still, the gameplay is fun, and the visuals are impressive.", 4.6, 260, 374);

-- Recensioni per "Portal 2" (GameID 157)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Masterpiece", "Portal 2 is a true masterpiece in gaming. The puzzles are brilliant, the story is captivating, and the humor is top-notch. It's a must-play for any gamer.", 5.0, 157, 375),
("Incredible Puzzle Game", "Portal 2 is one of the best puzzle games ever made. The clever mechanics and brilliant writing keep you engaged from start to finish.", 5.0, 157, 376),
("Brilliantly Crafted", "The puzzles in Portal 2 are incredibly well-designed, and the story is surprisingly deep. It's a unique and unforgettable experience.", 5.0, 157, 377),
("Unmatched Puzzle Design", "Portal 2 takes the core mechanics of the first game and expands them in amazing ways. The puzzles are incredibly clever, and the story is fantastic.", 5.0, 157, 378),
("A Unique Experience", "Portal 2 is a perfect blend of puzzle-solving and storytelling. It's a truly unique game that deserves all the praise it gets.", 5.0, 157, 379),
("Genius Puzzle Design", "The puzzles in Portal 2 are unlike anything I've ever seen before. It's a game that rewards creativity and critical thinking, and it's an absolute joy to play.", 5.0, 157, 380),
("Incredible Story and Gameplay", "The story in Portal 2 is brilliant, and the gameplay is challenging yet fun. It's one of the best puzzle games I've ever played.", 5.0, 157, 381),
("A Classic", "Portal 2 is an absolute classic. The puzzles are perfectly designed, and the witty writing and humor make it a joy to play from beginning to end.", 5.0, 157, 382),
("Perfect Sequel", "Portal 2 takes everything great about the first game and improves upon it. The puzzles are more complex, and the story is richer. It's a perfect sequel.", 5.0, 157, 383),
("Timeless Puzzle Game", "Portal 2 is a timeless game that still holds up today. The puzzles are brilliant, and the humor and story make it a standout experience in gaming.", 5.0, 157, 384);

-- Recensioni per "Predator: Hunting Grounds" (GameID 261)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Fun But Repetitive", "Predator: Hunting Grounds is a fun game, but it can get repetitive after a while. The Predator gameplay is exciting, but the missions feel a bit too similar.", 4.0, 261, 385),
("Great Predator Experience", "The Predator gameplay is fantastic. It's a great experience hunting down the opposition, but the game could use more variety in its missions and objectives.", 4.5, 261, 386),
("Exciting Gameplay", "Predator: Hunting Grounds is exciting and fun, but it lacks the depth needed to make it truly great. It's still a good game if you enjoy asymmetrical multiplayer.", 4.3, 261, 387),
("Could Be Better", "Predator: Hunting Grounds has a lot of potential, but it feels like it's missing something. The Predator gameplay is fun, but the human side of the game could use more polish.", 3.9, 261, 388),
("Great Fun with Friends", "The game is a blast to play with friends. Hunting down the Predator or being the Predator is incredibly fun, but the missions can feel a bit repetitive over time.", 4.4, 261, 389),
("Good Concept, Needs Work", "The concept of Predator: Hunting Grounds is great, but the game could benefit from more variety in gameplay and better optimization. Still, it's fun for short sessions.", 4.0, 261, 390),
("Intense Matches", "The matches in Predator: Hunting Grounds are intense and thrilling, but the lack of variety in the missions holds it back from being a truly great game.", 4.2, 261, 391),
("Fun Predator Gameplay", "Being the Predator is the highlight of the game. The gameplay is fun, but the game could use more features to keep things fresh in the long term.", 4.3, 261, 392),
("Decent, But Repetitive", "The game is decent, but it's easy to get bored after a while. The Predator mechanics are fun, but the repetitive nature of the missions can take away from the experience.", 3.8, 261, 393),
("Potential, But Needs More", "Predator: Hunting Grounds has a lot of potential, but it's missing a bit of depth. The core gameplay is fun, but there isn't enough content to keep you engaged for long periods.", 4.0, 261, 394);

-- Recensioni per "Pummel Party" (GameID 135)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Party Game for Friends", "Pummel Party is a fun, chaotic party game perfect for playing with friends. The mini-games are a blast, but it can get a bit repetitive after a while.", 4.5, 135, 395),
("Great for Group Fun", "Pummel Party is great for a group of friends. The variety of mini-games keeps things exciting, but the lack of depth can make it feel shallow after multiple sessions.", 4.2, 135, 396),
("Hilarious and Fun", "This game is full of laughs and great moments, especially when you're playing with friends. It's not the most complex game, but it's definitely entertaining.", 4.8, 135, 397),
("Chaos at Its Best", "Pummel Party offers chaotic and hilarious gameplay. It's a great game to play with a group, but it lacks the replayability to keep playing for long periods.", 4.3, 135, 398),
("Great Party Game", "A fun party game with a lot of mini-games. It's great for social gatherings, but it doesn't have the staying power of other multiplayer games.", 4.4, 135, 399),
("Fun, but Repetitive", "Pummel Party is fun for a short time, but it quickly becomes repetitive. The mini-games are enjoyable, but there isn't much to keep you engaged long-term.", 4.0, 135, 400),
("A Wild Ride", "A fantastic party game that's perfect for groups. The mini-games can get pretty wild, and the interactions between players can create some hilarious moments.", 4.7, 135, 401),
("Perfect for Friends", "If you have a group of friends to play with, Pummel Party is a must-have. It's fast-paced, fun, and can lead to some memorable moments.", 4.5, 135, 402),
("Fun with Friends", "Pummel Party is at its best when played with a group of friends. The mini-games are simple but engaging, though the lack of variety can make it feel repetitive.", 4.1, 135, 403),
("Entertaining but Short-Lived", "Pummel Party is a lot of fun, but it doesn't have the staying power for extended play sessions. It's perfect for a few rounds but gets old after a while.", 4.2, 135, 404);

-- Recensioni per "Puzzle Quest: Challenge of the Warlords" (GameID 162)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Addictive Puzzle Gameplay", "Puzzle Quest is a highly addictive blend of puzzle and RPG gameplay. It's easy to get hooked, and the strategic elements add depth to the simple puzzle mechanics.", 4.9, 162, 405),
("Fun and Engaging", "Puzzle Quest combines puzzle-solving with RPG mechanics in a way that makes it incredibly engaging. It's easy to get lost in the game for hours at a time.", 4.8, 162, 406),
("Challenging and Rewarding", "The puzzles are challenging, and the RPG elements are well done. The game can get tough at times, but the rewards make it worth the effort.", 4.7, 162, 407),
("Perfect Blend of Genres", "Puzzle Quest mixes puzzle and RPG elements in a way that makes for a unique and addictive experience. It's a great game for anyone who loves both genres.", 4.9, 162, 408),
("Strategic Puzzle Game", "The game is highly strategic, combining match-3 puzzle mechanics with RPG-style leveling. It's a fun and challenging experience that keeps you coming back for more.", 4.6, 162, 409),
("Addicting and Fun", "Puzzle Quest is incredibly addictive, with just the right balance of challenge and strategy. It's a game you'll want to keep playing to unlock all the upgrades and abilities.", 4.8, 162, 410),
("Strategic Yet Simple", "A brilliant game that combines simple puzzle mechanics with deep strategy. The RPG elements are a great addition, making the game feel fresh and rewarding.", 4.7, 162, 411),
("Great for Puzzle Fans", "If you enjoy puzzle games with a twist, Puzzle Quest is a must-play. The RPG elements add an extra layer of depth that makes the game really engaging.", 4.8, 162, 412),
("Engaging and Addictive", "Puzzle Quest is highly engaging and addictive. The puzzle mechanics are simple, but the addition of RPG elements keeps the gameplay fresh and exciting.", 4.7, 162, 413),
("Unique Puzzle Experience", "This game takes the classic match-3 puzzle format and adds RPG mechanics, making it a unique and fun experience. Highly recommended for puzzle game lovers.", 4.6, 162, 414);

-- Recensioni per "Rainbow Six Siege" (GameID 262)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Intense Tactical Shooter", "Rainbow Six Siege is a highly tactical shooter that rewards strategy and teamwork. The learning curve is steep, but the game is incredibly rewarding once you master it.", 5.0, 262, 415),
("Great for Competitive Play", "If you're into competitive shooters, Rainbow Six Siege is one of the best. The gameplay is challenging, and the teamwork aspect is crucial to success.", 4.9, 262, 416),
("Highly Tactical", "The game offers a high level of tactical depth that other shooters lack. It's great for people who enjoy planning and executing strategy with their team.", 5.0, 262, 417),
("A Tactical Masterpiece", "Rainbow Six Siege is a tactical shooter that requires a lot of coordination and skill. It's a masterpiece for fans of the genre, offering deep gameplay and intense moments.", 5.0, 262, 418),
("One of the Best Shooters", "Rainbow Six Siege stands out as one of the best tactical shooters out there. The teamwork required to succeed and the constantly evolving gameplay keep it fresh and exciting.", 4.8, 262, 419),
("Challenging and Rewarding", "The gameplay in Rainbow Six Siege can be difficult, but that's part of the charm. The strategic planning and teamwork needed make it incredibly rewarding when you win.", 4.7, 262, 420),
("Excellent Tactical Shooter", "Rainbow Six Siege excels in tactical gameplay. Every match requires careful planning, and the teamwork aspect is what sets it apart from other shooters.", 5.0, 262, 421),
("Deep and Engaging", "The depth of strategy in Rainbow Six Siege is incredible. It's a game that rewards patience and team coordination, making it a great choice for competitive gamers.", 4.9, 262, 422),
("Fantastic Game for Strategy Fans", "If you love tactical shooters and strategy, Rainbow Six Siege is a must-play. It's all about smart planning and working together as a team.", 5.0, 262, 423),
("Amazing Tactical Experience", "Rainbow Six Siege offers one of the best tactical shooter experiences. The game's depth and focus on teamwork make it incredibly satisfying to play.", 4.8, 262, 424);


-- Recensioni per "Ratchet & Clank: Rift Apart" (GameID 114)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Incredibly Fun and Beautiful", "Ratchet & Clank: Rift Apart is a stunning game, both visually and gameplay-wise. The rift mechanic is a fresh twist, and the action is fast-paced and fun.", 4.9, 114, 425),
("A Visual Masterpiece", "The game is a technical marvel. The rift mechanic and beautiful world design keep the game fresh, and the combat is as fun as ever. Highly recommended for any action game fan.", 5.0, 114, 426),
("Action and Adventure at Its Best", "Ratchet & Clank: Rift Apart delivers an exciting, action-packed experience with great humor and jaw-dropping visuals. It's a must-play for platformer fans.", 4.8, 114, 427),
("Amazing Gameplay and Graphics", "The gameplay is smooth, and the graphics are mind-blowing. The rift mechanics offer a new and exciting element to the series. It's an all-around fantastic game.", 5.0, 114, 428),
("Fun and Thrilling", "This game combines the charm of Ratchet & Clank with exciting new mechanics. It's a thrill ride from start to finish, with amazing combat and exploration.", 4.7, 114, 429),
("Stunning and Fun", "Rift Apart is a beautifully crafted game with action-packed sequences. The rift mechanic adds a fresh layer of excitement to the gameplay, and it's highly entertaining.", 4.9, 114, 430),
("An Incredible Journey", "The rift mechanic is an innovative feature, and the game has fantastic combat, platforming, and exploration. It's a joy to play from start to finish.", 5.0, 114, 431),
("Ratchet and Clank at Its Best", "Ratchet & Clank: Rift Apart is the best in the series. The new mechanics and graphics are incredible, making it a must-play for fans and newcomers alike.", 5.0, 114, 432),
("Epic Action Game", "The game is a non-stop action-packed adventure, with great gameplay and jaw-dropping visuals. The new features, including the rift mechanic, make it unique and exciting.", 4.8, 114, 433),
("Fantastic Platformer", "The game combines fast-paced action, beautiful graphics, and fun platforming. The rift mechanic is a game-changer and adds a lot to the gameplay.", 4.9, 114, 434);

-- Recensioni per "Rayman Legends" (GameID 118)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Fun and Beautiful Platformer", "Rayman Legends is an absolutely fun game with beautiful art and design. The levels are creative, and the music is fantastic. A must-play for platformer fans!", 4.9, 118, 435),
("Charming and Challenging", "Rayman Legends offers challenging platforming with stunning visuals and great music. It's a charming experience that will keep you entertained for hours.", 4.8, 118, 436),
("Imaginative and Fun", "The game is filled with creative and beautifully designed levels. The platforming is precise, and the soundtrack is amazing. It's a delightful experience from start to finish.", 4.9, 118, 437),
("A Platformer Masterpiece", "Rayman Legends is one of the best platformers out there. The levels are varied and fun, with great gameplay mechanics and fantastic visuals.", 5.0, 118, 438),
("Fun and Colorful", "The game is colorful, fun, and full of imagination. It's perfect for platformer fans who enjoy both challenge and creativity.", 4.8, 118, 439),
("Perfect for Co-op Play", "Rayman Legends shines when played in co-op mode. The levels are fun and challenging, and working together with friends is a great experience.", 4.9, 118, 440),
("A Platformer Classic", "Rayman Legends is a joy to play. It has everything you could want from a platformer: tight controls, creative levels, and amazing music.", 5.0, 118, 441),
("Colorful and Fun", "The game is a visual treat with fun platforming mechanics. Each level feels unique, and the art style is amazing. Highly recommend for fans of the genre.", 4.9, 118, 442),
("Amazing Co-op Fun", "The co-op mode is a highlight of Rayman Legends. The levels are fun, and the music is awesome. It's a game you'll want to play again and again with friends.", 4.8, 118, 443),
("A Must-Play Platformer", "Rayman Legends is a fantastic platformer. The levels are challenging yet fun, and the game has a great sense of humor. One of the best platformers out there.", 4.9, 118, 444);

-- Recensioni per "Red Dead Redemption 2" (GameID 2)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Absolute Masterpiece", "Red Dead Redemption 2 is an absolute masterpiece in storytelling and open-world design. The characters are compelling, the world is stunning, and the gameplay is immersive.", 5.0, 2, 445),
("Stunning Open-World Game", "The game is a stunning open-world experience. The level of detail is mind-blowing, and the story is deep and emotional. It's one of the best games ever made.", 5.0, 2, 446),
("Breathtaking and Immersive", "Red Dead Redemption 2 offers an immersive experience that few games can match. The world is alive, and the story is gripping. A true masterpiece in every sense.", 5.0, 2, 447),
("A Journey Like No Other", "This game is an unforgettable journey. The world is massive, the story is emotional, and the gameplay is incredibly detailed. It's a must-play for any fan of open-world games.", 5.0, 2, 448),
("The Ultimate Cowboy Experience", "Red Dead Redemption 2 offers the ultimate cowboy experience, with stunning visuals, a gripping story, and immersive gameplay. It's the best open-world game I've played.", 5.0, 2, 449),
("A True Work of Art", "The level of detail in Red Dead Redemption 2 is unmatched. From the environments to the characters, everything feels real and alive. It's a must-play for any gamer.", 5.0, 2, 450),
("An Epic Tale of the Wild West", "Red Dead Redemption 2 is an epic tale of the wild west. The story is amazing, and the world feels alive with activities and NPCs. It's an experience you won't forget.", 5.0, 2, 451),
("Gripping and Beautiful", "From the incredible visuals to the gripping story, Red Dead Redemption 2 is a game that demands attention. The world is huge and detailed, and the characters are unforgettable.", 5.0, 2, 452),
("Incredible Attention to Detail", "The game offers an astonishing level of detail, with everything from the weather to the animals feeling incredibly real. The story is immersive, and the world is breathtaking.", 5.0, 2, 453),
("A Masterclass in Game Design", "Red Dead Redemption 2 is a masterclass in game design. The world is massive and detailed, the story is gripping, and the gameplay is incredibly polished. One of the best games I've ever played.", 5.0, 2, 454);


-- Recensioni per "Resident Evil 4 Remake" (GameID 139)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Perfect Remake", "Resident Evil 4 Remake is a near-perfect reimagining of the original. The visuals are stunning, the combat is thrilling, and the atmosphere is intense. It's a must-play for fans of the franchise.", 5.0, 139, 455),
("Classic Reborn", "The remake of Resident Evil 4 takes the original classic and updates it with modern graphics, controls, and mechanics, while keeping the essence of what made the original so great.", 4.9, 139, 456),
("Survival Horror at Its Best", "The game is a perfect blend of action and survival horror. The tension is real, and the new mechanics make it a fresh experience while still honoring the original.", 5.0, 139, 457),
("A Masterpiece of Horror", "Resident Evil 4 Remake is one of the best horror games I've played in years. The combat is intense, the story is gripping, and the visuals are jaw-dropping. A must-play for horror fans.", 5.0, 139, 458),
("Flawless Remake", "Capcom has truly outdone themselves with Resident Evil 4 Remake. The controls are tighter, the graphics are gorgeous, and the game retains the atmosphere and tension of the original while improving on it.", 5.0, 139, 459),
("A Triumph of Survival Horror", "The remake of Resident Evil 4 is a triumph of survival horror. The gameplay is still as intense as ever, and the updated visuals make it look better than ever.", 4.9, 139, 460),
("Gory and Gorgeous", "The game is a beautiful, gory masterpiece. The combat is fun and challenging, and the survival horror elements are perfectly executed. One of the best remakes of a classic.", 5.0, 139, 461),
("Intense and Gripping", "Resident Evil 4 Remake captures the essence of the original while delivering an intense and gripping experience with modern graphics and mechanics. Highly recommended for both new players and veterans of the series.", 5.0, 139, 462),
("Better Than Ever", "This remake improves on the original in every way. The visuals are stunning, the gameplay is refined, and the story remains as compelling as ever. It's an absolute must-play for horror fans.", 4.9, 139, 463),
("A Stunning Horror Experience", "Resident Evil 4 Remake is a fantastic survival horror experience. The atmosphere is creepy, the combat is thrilling, and the story is just as engaging as it was in the original. A true gem of a remake.", 5.0, 139, 464);

-- Recensioni per "Resident Evil 5" (GameID 263)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Action-Packed Horror", "Resident Evil 5 shifts the focus from pure survival horror to more action-oriented gameplay. The co-op mode is great, but it loses some of the tension from the previous games.", 4.0, 263, 465),
("A Different Kind of Resident Evil", "While Resident Evil 5 is more action-packed than its predecessors, it still has the signature horror elements. The co-op gameplay is fantastic and makes the game much more enjoyable.", 4.2, 263, 466),
("Co-Op Fun", "The co-op gameplay is a blast, and the action is intense. It's a fun, action-packed entry in the series, but it lacks the survival horror atmosphere of the older games.", 4.0, 263, 467),
("A Solid Action Game", "Resident Evil 5 is a solid action game, but it's not as scary or atmospheric as the previous titles. The co-op mode is definitely the highlight here.", 4.1, 263, 468),
("Great Co-op Experience", "The game is a great co-op experience, with intense action and thrilling moments. It may not be as horror-driven as the earlier entries, but it's still a fun game.", 4.2, 263, 469),
("Fun But Not Scary", "Resident Evil 5 is more action-oriented and less focused on horror. While it's fun, it doesn't have the same atmosphere or tension that made the earlier games so memorable.", 4.0, 263, 470),
("Action Over Horror", "This game focuses more on action and less on the survival horror aspect. While it's a fun game, it lacks the same fear factor as Resident Evil 4 and earlier titles.", 3.9, 263, 471),
("Intense Action", "Resident Evil 5 is packed with action, and the co-op mode makes it a fun experience to play with a friend. It may not be the best for fans of traditional horror, but it's still an enjoyable game.", 4.1, 263, 472),
("Action Lovers Will Enjoy It", "Resident Evil 5 is more for action lovers than survival horror fans. The game's co-op mode is great, and the combat is satisfying, but it lacks the creepy atmosphere of the earlier games.", 4.0, 263, 473),
("A Fun Ride", "Resident Evil 5 is a fun, action-packed ride. It's not as scary as some of the previous entries, but the co-op gameplay and intense action make it a solid experience.", 4.2, 263, 474);

-- Recensioni per "Resident Evil 6" (GameID 264)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Too Much Action, Not Enough Horror", "Resident Evil 6 is overloaded with action and loses the survival horror elements that made the series so great. The multiple character campaigns are fun, but it feels more like a generic action game.", 3.5, 264, 475),
("Mixed Feelings", "Resident Evil 6 tries to balance action and horror, but it doesn't quite succeed. The action is fun, but the game lacks the tension and atmosphere of the older titles. It's a decent action game but not a great Resident Evil game.", 3.8, 264, 476),
("A Step Back for the Franchise", "While Resident Evil 6 has fun action sequences, it doesn't feel like a true Resident Evil game. The horror is almost entirely gone, and the game focuses too much on action and spectacle.", 3.6, 264, 477),
("A Chaos of Action", "Resident Evil 6 is an action-packed chaos. The game has multiple campaigns with different characters, but it's too focused on action and not enough on the survival horror that made the series famous.", 3.7, 264, 478),
("Action-Focused, Not Scary", "This game is more about action and less about the fear factor that the older games are known for. The multiple storylines are interesting, but the game lacks the tension that made Resident Evil great.", 3.6, 264, 479),
("Disappointing for Horror Fans", "If you're a fan of the survival horror elements of Resident Evil, this game will disappoint. It focuses more on action and lacks the chilling atmosphere that the earlier games had.", 3.5, 264, 480),
("Fun Co-op, But Too Action-Heavy", "Resident Evil 6 is fun to play in co-op, but it's way too focused on action. The horror elements are almost non-existent, and the game doesn't quite feel like a Resident Evil game.", 3.8, 264, 481),
("Too Much of Everything", "Resident Evil 6 feels like it tries to do too much. The action is fun, but it's a bit overwhelming. It's not the horror experience fans are looking for, but it can still be entertaining.", 3.7, 264, 482),
("Lost Its Charm", "Resident Evil 6 is an action-heavy game that loses the charm of the original games. The story is split into too many campaigns, and the horror is almost gone. It's an enjoyable game, but not a great Resident Evil title.", 3.6, 264, 483),
("Action Overload", "The game is fun in short bursts, but the constant action can get tiring. It lacks the atmospheric tension that made Resident Evil such a unique and scary experience. If you're looking for action, this is for you.", 3.7, 264, 484);


-- Recensioni per "Resident Evil 7" (GameID 265)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Return to Horror", "Resident Evil 7 marks a brilliant return to survival horror. The first-person perspective adds a new layer of immersion, and the atmosphere is terrifying. One of the best in the series.", 5.0, 265, 485),
("Gritty and Intense", "The game goes back to its roots with survival horror and does so excellently. The Baker family is terrifying, and the atmosphere is filled with tension from start to finish.", 4.9, 265, 486),
("True Horror Revival", "Resident Evil 7 is a terrifying journey. The first-person perspective makes everything feel more personal, and the game nails the creepy atmosphere. It's a true horror experience.", 5.0, 265, 487),
("A Horrifying Experience", "This game is a masterpiece of horror. The terrifying moments, combined with tight gameplay and a fantastic story, make it one of the best survival horror games in years.", 5.0, 265, 488),
("A Perfect Horror Game", "The atmosphere in Resident Evil 7 is incredible. It brings the horror back to the series with a creepy setting and an immersive first-person perspective. It's a must-play for any horror fan.", 5.0, 265, 489),
("Horrifying and Brilliant", "Resident Evil 7 offers a terrifying experience that gets under your skin. The gameplay is tight, and the horror elements are intense. This game is a must for fans of survival horror.", 4.8, 265, 490),
("Survival Horror at Its Best", "With Resident Evil 7, Capcom has successfully reinvigorated the series. The eerie atmosphere, creepy enemies, and intense action make this a standout horror title.", 5.0, 265, 491),
("Creepy and Atmospheric", "This is a masterclass in horror. The first-person viewpoint brings a whole new level of tension and dread. The game keeps you on edge from beginning to end.", 5.0, 265, 492),
("A True Horror Classic", "Resident Evil 7 is a breath of fresh air for the series. It's scary, intense, and incredibly atmospheric. A horror game that everyone should play.", 5.0, 265, 493),
("Fear-Inducing Genius", "A perfect blend of survival horror and exploration. Resident Evil 7 is terrifying and immerses you in a world of madness. It's one of the best horror games in recent years.", 4.9, 265, 494);

-- Recensioni per "Resident Evil Village" (GameID 138)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Stunning Sequel", "Resident Evil Village takes everything that was great about Resident Evil 7 and makes it even better. The environments are beautiful, the enemies are terrifying, and the gameplay is intense. A must-play for fans of the series.", 5.0, 138, 495),
("Fantastic Horror and Action", "Resident Evil Village combines great action with terrifying moments. The first-person perspective returns, and the story is fantastic. A brilliant continuation of the series.", 4.9, 138, 496),
("Incredible Visuals and Tension", "The visuals in Resident Evil Village are stunning, and the horror elements are genuinely terrifying. The mix of action and survival horror is perfectly balanced.", 5.0, 138, 497),
("A Gripping Horror Adventure", "Resident Evil Village takes everything that made Resident Evil 7 great and expands it. The game is creepy, intense, and filled with beautiful, horrifying environments.", 5.0, 138, 498),
("A Thrilling Sequel", "Resident Evil Village is a thrilling ride from start to finish. The atmosphere is tense, the characters are memorable, and the action is top-notch. One of the best entries in the series.", 4.8, 138, 499),
("A Beautiful Horror Experience", "The game is visually stunning, with each area feeling unique and horrifying. The tension builds perfectly throughout, making every encounter intense and nerve-wracking.", 5.0, 138, 500),
("A Perfect Mix of Horror and Action", "Resident Evil Village brings a perfect mix of action and survival horror. The enemies are terrifying, the combat is satisfying, and the game looks absolutely gorgeous.", 4.9, 138, 501),
("Masterful Horror", "Resident Evil Village is a masterful blend of horror and action. The story is engaging, and the atmosphere is breathtaking. A perfect follow-up to Resident Evil 7.", 5.0, 138, 502),
("Horrifying and Beautiful", "Resident Evil Village is visually stunning and filled with horrifying moments. The game has a great balance of action and tension, and the setting is incredibly atmospheric.", 4.9, 138, 503),
("A True Survival Horror Gem", "Resident Evil Village continues the legacy of its predecessor, combining terrifying moments with brilliant gameplay. The game feels fresh while retaining everything fans loved about Resident Evil 7.", 5.0, 138, 504);

-- Recensioni per "Riders Republic" (GameID 85)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Epic Extreme Sports Game", "Riders Republic is an amazing extreme sports game that combines fun gameplay with jaw-dropping visuals. The open-world environment is vast, and there's always something exciting to do.", 4.8, 85, 505),
("Fun and Thrilling", "This game is a blast! Whether you're snowboarding, mountain biking, or wingsuit flying, Riders Republic offers endless fun. The open-world design is huge and incredibly fun to explore.", 4.7, 85, 506),
("A Thrill-Seeker's Dream", "Riders Republic delivers an adrenaline-pumping experience. The world is massive, and the variety of sports keeps the gameplay fresh and exciting. It's a perfect game for thrill-seekers.", 4.9, 85, 507),
("A Massive Playground", "The open-world of Riders Republic is enormous, with so many different extreme sports to try. The game offers something for everyone, whether you're into skiing, biking, or just free-roaming.", 4.8, 85, 508),
("Fun, but Somewhat Repetitive", "Riders Republic is a ton of fun, but after a while, the gameplay can feel repetitive. The multiplayer races and challenges are the best parts of the game, and the open world is beautiful.", 4.5, 85, 509),
("Exciting and Beautiful", "This game is a beautiful and exciting way to experience extreme sports. The environments are stunning, and the gameplay is always fast-paced and fun. A great open-world experience.", 4.8, 85, 510),
("Great for Competitive Gamers", "Riders Republic offers a variety of challenges and competitions that will keep any competitive gamer hooked. The sports are diverse, and the open-world setting adds so much to the experience.", 4.6, 85, 511),
("A Blast to Play", "Riders Republic is a blast to play solo or with friends. The extreme sports are thrilling, and the open world is packed with challenges and activities. It's a must-try for fans of extreme sports.", 4.7, 85, 512),
("Fast, Fun, and Exciting", "Riders Republic offers fast-paced, exciting gameplay with a huge world to explore. There are a lot of fun activities to do, and the racing is thrilling. A great game for extreme sports fans.", 4.7, 85, 513),
("Amazing Visuals and Gameplay", "The visuals in Riders Republic are incredible, and the gameplay is just as exciting. The game gives you a ton of freedom to explore and take part in extreme sports, making it one of the best in the genre.", 4.8, 85, 514);


-- Recensioni per "RimWorld" (GameID 105)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Deep Colony Simulator", "RimWorld is a deeply engaging colony simulation game. The complexity of managing a colony, dealing with random events, and shaping your story is addicting. It's one of the best in its genre.", 5.0, 105, 515),
("Endless Replayability", "The random events and the complexity of managing a colony keep me coming back for more. The modding community is huge, making RimWorld an experience that keeps evolving.", 4.9, 105, 516),
("A Unique Experience", "There's no other game like RimWorld. The unpredictability of the AI storyteller creates unique and interesting scenarios every time you play. It's a must-have for fans of simulation games.", 5.0, 105, 517),
("Unpredictably Fun", "RimWorld's simulation is incredible. Every playthrough is different, and the decisions you make have a real impact on the survival of your colony. The amount of depth is insane.", 5.0, 105, 518),
("Challenging and Rewarding", "This game offers a deep and rewarding experience. It's difficult but incredibly satisfying to watch your colony survive against the odds. It's a game that always feels fresh.", 4.8, 105, 519),
("The Best Colony Sim", "RimWorld is hands down the best colony management simulator. The game is complex, but every decision you make feels meaningful, making for a deeply rewarding experience.", 5.0, 105, 520),
("Masterpiece of Simulation", "There's nothing like RimWorld. The depth of management, storytelling, and customization is incredible. It's a game you can play for hundreds of hours and still find new ways to play.", 5.0, 105, 521),
("Fantastic Game", "RimWorld is a masterpiece of colony simulation. The AI storyteller creates dynamic and unpredictable situations that keep you on your toes. I can't stop playing it.", 5.0, 105, 522),
("Compelling and Addictive", "The story your colony tells is unique and captivating. RimWorld is addictive, with so much depth that every new colony feels like a fresh start. The challenge and satisfaction are unmatched.", 5.0, 105, 523),
("Unbelievable Depth", "Every playthrough of RimWorld feels completely different. The complexity of the systems is amazing, and I love the random events and the fact that every decision has weight.", 4.9, 105, 524);

-- Recensioni per "Rocket League" (GameID 84)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Addictive Game", "Rocket League is a fantastic mix of soccer and rocket-powered cars. The gameplay is fast, fun, and incredibly addictive. It's easy to pick up, but hard to master.", 5.0, 84, 525),
("Fast and Fun", "This game is incredibly fun. The blend of soccer and cars makes for an action-packed experience that's always exciting. The skill ceiling is high, making it rewarding for competitive players.", 4.9, 84, 526),
("A Unique and Thrilling Game", "Rocket League is unlike anything else. The mechanics are simple, but the level of skill and strategy required to be successful is impressive. It's a blast to play, both casually and competitively.", 5.0, 84, 527),
("Endless Fun", "Rocket League is one of the most fun multiplayer games. The matches are quick, exciting, and full of action. The game is simple to learn but offers a lot of depth for players looking to improve.", 4.8, 84, 528),
("A Game Like No Other", "Rocket League is a unique and exciting game that combines soccer and cars. The game is fast, fun, and incredibly rewarding once you start mastering the mechanics.", 5.0, 84, 529),
("Perfect for Casual and Competitive Play", "The best thing about Rocket League is how it's perfect for both casual and competitive play. The learning curve is steep, but the satisfaction when you pull off great moves is worth it.", 4.9, 84, 530),
("Incredibly Fun and Addictive", "Rocket League is pure fun. Whether you're playing with friends or facing off against strangers online, the action is always exciting. It's an addictive game that keeps you coming back for more.", 5.0, 84, 531),
("Exciting and Challenging", "Rocket League is an incredibly exciting and challenging game. The physics and the mechanics behind the gameplay are brilliant. It's a game that you can play forever and still find new ways to improve.", 4.9, 84, 532),
("Great for Team Play", "Rocket League is amazing when played with friends. It requires teamwork, coordination, and skill to succeed. It's perfect for both casual play and competitive tournaments.", 4.8, 84, 533),
("Fun and Competitive", "Rocket League offers a great mix of fun and competition. The controls are easy to learn, but mastering the game takes time. It's fun to play casually or competitively, making it a great all-around game.", 5.0, 84, 534);

-- Recensioni per "Sackboy: A Big Adventure" (GameID 120)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Fun and Charming Adventure", "Sackboy: A Big Adventure is a delightful platformer with a lot of heart. The game is fun for all ages and filled with creative levels and charming characters.", 4.8, 120, 535),
("A Beautiful Platformer", "Sackboy: A Big Adventure is a visually stunning and fun platformer. The levels are creative, and the gameplay is smooth. It's a great game for fans of family-friendly adventures.", 4.7, 120, 536),
("A Perfect Family Game", "Sackboy is back, and this time he's bringing a fantastic platforming adventure. The game is fun and accessible, with co-op gameplay that's perfect for family or friends.", 5.0, 120, 537),
("Charming and Fun", "Sackboy: A Big Adventure is a charming game with a lot of creativity. The gameplay is fun, and the levels are filled with hidden secrets. It's a perfect game for platformer fans.", 4.8, 120, 538),
("Colorful and Fun", "The game is bright, colorful, and filled with fun platforming challenges. Sackboy's charm shines through in every level, and it's a joy to play from start to finish.", 4.9, 120, 539),
("A Delightful Experience", "Sackboy: A Big Adventure is a delightful, lighthearted platformer. The creative levels and the charming art style make this game perfect for players of all ages.", 4.8, 120, 540),
("Fantastic for Co-op Play", "The game offers great co-op multiplayer, making it perfect for playing with friends or family. The platforming is solid, and the world is full of charm and humor.", 5.0, 120, 541),
("A Platforming Gem", "Sackboy: A Big Adventure is a fantastic platformer. The levels are creative, and the game offers great cooperative play. It's fun for both solo and multiplayer experiences.", 4.8, 120, 542),
("Fun for All Ages", "This game is an absolute joy to play. The platforming is smooth and enjoyable, and the game's whimsical world is a perfect fit for players of all ages.", 4.7, 120, 543),
("A Fun Adventure with Heart", "Sackboy: A Big Adventure is a platforming game full of charm and heart. The game is fun for all ages, and the creative levels keep you entertained throughout.", 4.9, 120, 544);


-- Recensioni per "Sea of Thieves" (GameID 266)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Ocean of Fun", "Sea of Thieves is an amazing game if you love pirates and open-world exploration. Sailing the seas with friends, hunting for treasure, and fighting other pirates is an absolute blast.", 4.9, 266, 545),
("Epic Pirate Adventures", "The open-world nature of Sea of Thieves lets you live out your pirate fantasies. The graphics are stunning, and the co-op gameplay is a perfect way to enjoy the adventure with friends.", 5.0, 266, 546),
("Best with Friends", "Sea of Thieves is an unforgettable experience when played with friends. Sailing, raiding, and exploring together is extremely fun. The game could use a bit more variety in missions, but overall, it's a great time.", 4.8, 266, 547),
("A Pirate's Life", "Sea of Thieves is a fantastic pirate simulator, where you can experience the thrill of piracy in a stunning, open-world setting. The dynamic world and the interactions with other players are incredibly fun.", 4.9, 266, 548),
("A Unique Experience", "The game offers a unique experience in multiplayer games. It's less about competition and more about the adventure of sailing and exploring, which is refreshing. It's a fun and relaxing game.", 4.7, 266, 549),
("Great for Exploration", "Sea of Thieves is all about exploration and treasure hunting. It's a beautiful, open-world game that encourages you to work with others to discover hidden secrets.", 5.0, 266, 550),
("Relaxed Fun", "Sea of Thieves is an incredibly fun and relaxing game. The sailing mechanics are smooth, and the world is vibrant and filled with things to discover. It's a great game for unwinding with friends.", 4.8, 266, 551),
("Not for Everyone, But Great Fun", "The gameplay can get repetitive at times, but the freedom and sense of adventure you get from being a pirate make it a very enjoyable experience. It's best with a group of friends.", 4.6, 266, 552),
("A Beautiful World", "The world of Sea of Thieves is absolutely beautiful. The ocean is vast, the islands are varied, and the overall environment is immersive. If you enjoy co-op play and exploration, you'll love this game.", 5.0, 266, 553),
("A Pirate's Dream", "If you've ever dreamed of being a pirate, Sea of Thieves lets you live that dream. The game is full of pirate lore, hidden treasure, and epic battles with other players. It's a blast to play with a crew.", 4.9, 266, 554);

-- Recensioni per "Sekiro: Shadows Die Twice" (GameID 13)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Challenging Masterpiece", "Sekiro: Shadows Die Twice is a brutal but incredibly rewarding game. The combat is fast-paced and requires precision. The story and world-building are fantastic, and it offers a unique take on the Souls-like genre.", 5.0, 13, 555),
("Unforgiving But Fair", "The difficulty of Sekiro is one of its greatest strengths. Every challenge is tough, but the satisfaction from overcoming each one is immense. It's a game that rewards skill and patience.", 4.9, 13, 556),
("A Masterpiece of Combat", "Sekiro is a challenging game, but its combat system is incredibly satisfying once you get the hang of it. The game rewards skillful play, and each victory feels earned.", 5.0, 13, 557),
("Unique and Brutal", "Sekiro offers a unique experience compared to other FromSoftware games. The emphasis on parrying and precise timing makes combat feel fresh and different from the typical Souls-like experience. It's unforgiving but rewarding.", 4.9, 13, 558),
("A True Test of Skill", "Sekiro is a true test of your gaming skills. The combat system is tough to master, but once you get the timing right, it's incredibly satisfying. The world design and boss fights are also top-notch.", 5.0, 13, 559),
("Beautiful and Brutal", "The game is both beautiful and brutally difficult. The setting is immersive, and the combat is like nothing I've ever experienced. The challenge can be frustrating, but it's always fair and rewarding.", 4.8, 13, 560),
("A Perfectly Executed Samurai Adventure", "Sekiro nails the samurai fantasy. It's challenging, fast-paced, and has some of the best combat in gaming. The world design is incredible, and the bosses are intense and memorable.", 5.0, 13, 561),
("Frustrating But Incredible", "The difficulty in Sekiro is definitely high, but that makes every success even more rewarding. The game is beautiful, and the combat system is deep. Be prepared for a tough but satisfying journey.", 4.7, 13, 562),
("Immersive World, Challenging Combat", "The world of Sekiro is immersive, and the combat is incredibly satisfying. It's definitely not a game for the faint of heart, but if you enjoy a good challenge, it's one of the best out there.", 5.0, 13, 563),
("A Hardcore Experience", "Sekiro is not for the casual gamer. The difficulty is intense, but the payoff is worth it. The combat is rewarding, and the world is rich in story and design. A must-play for those who love a challenge.", 4.9, 13, 564);

-- Recensioni per "Session: Skate Sim" (GameID 93)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A True Skateboarding Sim", "Session: Skate Sim offers a true-to-life skateboarding experience. The controls are realistic, and the game truly captures the feeling of skateboarding. It's a game for those who love the sport.", 4.8, 93, 565),
("For Real Skateboarders", "Session is not a casual skateboarding game. It's aimed at players who love the sport and want to experience the challenge of realistic controls and physics. If you're looking for an arcade-style skateboarding game, this isn't for you.", 4.9, 93, 566),
("Realistic and Challenging", "The controls in Session are unique and require practice, but they offer a much more realistic experience than other skateboarding games. If you're up for the challenge, it's a rewarding game to master.", 5.0, 93, 567),
("For Skateboard Enthusiasts", "Session captures the feel of skateboarding perfectly. The controls are tough to get used to, but once you do, the game feels incredibly authentic. A must-try for fans of skateboarding and simulation games.", 4.7, 93, 568),
("Skateboarding at its Best", "Session is a skateboarding simulator, and it nails the feel of the sport. The controls are challenging at first, but they make the game feel rewarding once you get the hang of them. Great for skateboard fans.", 4.9, 93, 569),
("A Real Skateboarder's Game", "If you're a true skateboarder, Session will feel like a breath of fresh air. The realistic controls, physics, and attention to detail make it a great game for anyone who loves skateboarding.", 5.0, 93, 570),
("Not for Everyone, But Great for Skate Fans", "Session isn't the easiest game to pick up, but it's perfect for those who enjoy realistic skateboarding simulations. If you're looking for an arcade experience, this game isn't for you.", 4.6, 93, 571),
("Skateboarding Reimagined", "Session takes skateboarding games to a whole new level with its realistic controls and physics. It's not easy to get into, but it's incredibly rewarding once you do.", 4.8, 93, 572),
("Challenging and Rewarding", "Session's learning curve is steep, but once you get the controls down, it's an incredibly rewarding experience. The game offers a true simulation of skateboarding that's perfect for enthusiasts.", 5.0, 93, 573),
("A True Test of Skateboarding Skill", "Session is challenging and realistic. It offers a true-to-life skateboarding experience, making it one of the most authentic skateboarding games out there. It's a game that truly tests your skills.", 4.9, 93, 574);


-- Recensioni per "Silent Hill: Downpour" (GameID 289)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Terrifying Return", "Silent Hill: Downpour brings back the eerie atmosphere of the franchise. The setting is haunting, and the storyline keeps you on edge. While not perfect, it's a solid addition to the series.", 4.5, 289, 575),
("Underrated Horror", "Despite mixed reviews, Silent Hill: Downpour offers a great psychological horror experience. The open-world elements are a bit jarring, but the story and atmosphere make up for it.", 4.7, 289, 576),
("Great Horror, Weak Combat", "The game delivers some truly terrifying moments, but the combat feels clunky. It's still worth playing for the story and creepy atmosphere, though.", 4.3, 289, 577),
("A Deep Dive into Madness", "Silent Hill: Downpour brings back the unsettling ambiance of the earlier games. While the mechanics are a bit rough, the story and eerie environments make it an intriguing horror experience.", 4.6, 289, 578),
("Haunting Yet Flawed", "Silent Hill: Downpour has a lot of potential, with a dark atmosphere and psychological horror elements, but the gameplay and controls aren't as tight as they could be. Still, it's a great horror game.", 4.4, 289, 579),
("Creepy and Atmospheric", "Downpour does a great job at building tension. The story, world-building, and atmosphere are fantastic. The combat mechanics could be better, but it's still a worthy entry for fans of the series.", 4.5, 289, 580),
("Atmosphere Over Action", "The strength of Silent Hill: Downpour lies in its atmosphere and story. While the action and combat might be a bit clunky, the psychological horror moments are still powerful and creepy.", 4.8, 289, 581),
("Dark and Gritty", "The world of Silent Hill is as dark and gritty as ever. Downpour offers a great mix of eerie environments, disturbing monsters, and an intriguing narrative. It's not perfect, but it's certainly enjoyable for fans of the series.", 4.7, 289, 582),
("A Horror That Sticks With You", "Silent Hill: Downpour is full of unsettling moments. The atmosphere is haunting, and it does a good job at keeping you on edge. The gameplay might feel a bit dated, but it's worth playing for the eerie vibes.", 4.6, 289, 583),
("Classic Silent Hill Vibes", "While it's not the strongest entry in the Silent Hill series, Downpour still delivers classic psychological horror and a gripping narrative that will keep you hooked.", 4.5, 289, 584);

-- Recensioni per "Silent Hill: Shattered Memories" (GameID 290)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Unique Reimagining", "Silent Hill: Shattered Memories takes a fresh approach to the series. The story is intriguing, and the psychological elements are well-executed, though it's more of a psychological thriller than traditional horror.", 4.8, 290, 585),
("Innovative and Scary", "The game plays with your emotions and expectations in a way no other Silent Hill game has done. It's a unique take on the series, blending horror with psychological depth.", 4.7, 290, 586),
("Scary and Thought-Provoking", "Shattered Memories focuses on building psychological horror, and it does so effectively. It's not about monsters jumping out at you, but more about unsettling tension and deep emotional storytelling.", 4.9, 290, 587),
("An Unconventional Horror", "Shattered Memories takes Silent Hill in a new direction, with an emphasis on psychological horror and player choices. While it may not appeal to all fans, it offers a fresh and thought-provoking experience.", 4.6, 290, 588),
("Clever and Chilling", "The psychological elements of Shattered Memories are brilliant. It's a departure from traditional Silent Hill gameplay but still manages to keep the tension high and the scares unsettling.", 4.8, 290, 589),
("Fresh and Unique", "Silent Hill: Shattered Memories offers a unique experience. It's not the traditional survival horror, but it manages to capture the eerie vibe of the series with a focus on psychological horror.", 4.7, 290, 590),
("Psychological Horror at Its Best", "This game focuses on the player's emotions, and the story changes based on how you respond to situations. The tension and paranoia make it an unforgettable experience.", 5.0, 290, 591),
("A Different Kind of Horror", "While it's not a typical survival horror game, Shattered Memories still delivers an emotionally charged experience. It's a fresh take on the Silent Hill series, and the psychological horror is top-notch.", 4.6, 290, 592),
("Mysterious and Intriguing", "The game offers a deep narrative that relies on your own responses to push the story forward. The eerie atmosphere and chilling moments keep you engaged throughout the experience.", 4.8, 290, 593),
("A Different Path for Silent Hill", "Shattered Memories takes Silent Hill in an unexpected direction with a psychological twist. The game's approach to fear is different but effective, making it a standout in the series.", 4.7, 290, 594);

-- Recensioni per "Slay the Spire" (GameID 102)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Roguelike Masterpiece", "Slay the Spire is a perfect blend of strategy and roguelike gameplay. The deck-building mechanic is incredibly deep, and every run feels fresh. It's easy to get addicted to trying different strategies.", 5.0, 102, 595),
("Endless Replayability", "With its infinite variety of cards, relics, and enemies, Slay the Spire offers endless replayability. Every run feels different, and the challenge keeps you coming back for more.", 4.9, 102, 596),
("A Card Game Like No Other", "Slay the Spire is a brilliant deck-building roguelike that constantly tests your strategy. It's hard to stop playing once you get started, and every run feels like a new challenge.", 5.0, 102, 597),
("Challenging and Addictive", "Slay the Spire is both challenging and addictive. You'll keep coming back to improve your strategy and build better decks. The game's difficulty curve is perfect, and the thrill of victory is always rewarding.", 4.8, 102, 598),
("A Deck-Building Dream", "If you love card games and strategy, Slay the Spire is a must-play. The combination of roguelike elements and deck-building creates a game that is both fun and endlessly replayable.", 4.9, 102, 599),
("Great for Strategy Lovers", "Slay the Spire is an excellent game for anyone who loves strategic planning. Every decision you make matters, and each run is a test of your ability to build the perfect deck.", 5.0, 102, 600),
("Challenging and Fun", "Every run in Slay the Spire is a new challenge. It's a game that requires you to think carefully about your deck choices, and the more you play, the better you get at finding optimal strategies.", 4.8, 102, 601),
("Strategic and Rewarding", "Slay the Spire combines tactical gameplay with a lot of randomness, creating a highly replayable experience. Each deck build feels different, and the game constantly keeps you on your toes.", 5.0, 102, 602),
("Addictive Deck-Building", "Slay the Spire is one of the most addictive deck-building games out there. The gameplay is fast, fun, and always presents new challenges. You'll never get tired of trying to improve your strategy.", 4.9, 102, 603),
("The Perfect Roguelike", "Slay the Spire blends roguelike mechanics with deck-building in a way that's both fun and challenging. The game's variety ensures you'll always have a new experience with each run.", 5.0, 102, 604);


-- Recensioni per "SnowRunner" (GameID 92)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A True Off-Road Experience", "SnowRunner offers a deep and realistic off-road driving experience. The maps are vast, and the sense of freedom is incredible. The challenge of navigating through tough terrain is addictive!", 4.9, 92, 605),
("Challenging but Rewarding", "The game is tough, but the satisfaction of overcoming obstacles with your truck is unmatched. It's not for everyone, but if you love off-road challenges, SnowRunner is a must-play.", 4.8, 92, 606),
("Off-Road Adventure at Its Best", "SnowRunner offers a fantastic experience for fans of off-road driving games. The physics, terrain, and sense of scale make it feel like you're really driving through the wilderness.", 5.0, 92, 607),
("Difficult Yet Engaging", "The game can be a bit slow at times, but the challenge and beauty of the environments make it very engaging. It's an experience that's perfect for those looking for a relaxed but challenging adventure.", 4.7, 92, 608),
("A Masterpiece of Off-Road Simulation", "SnowRunner is one of the best off-road simulators out there. It's all about patience and strategy, and the game does a great job at making every journey feel like an achievement.", 4.9, 92, 609),
("Satisfying but Slow", "SnowRunner's slow pace may not be for everyone, but once you get into the rhythm, it's incredibly satisfying. The variety of trucks and terrains adds to the fun.", 4.6, 92, 610),
("Realistic and Addictive", "The driving mechanics in SnowRunner are excellent, with a great focus on realism. Each mission is a tough but rewarding experience, and the sense of progression is highly motivating.", 5.0, 92, 611),
("A Beautifully Challenging Game", "The environments are stunning, and the challenge of off-road driving keeps me hooked. It's not a quick game, but it's definitely a rewarding one.", 4.8, 92, 612),
("Perfect for Off-Road Enthusiasts", "SnowRunner is perfect for anyone who enjoys off-road driving. The variety of trucks and terrain types makes each mission feel unique and satisfying.", 4.9, 92, 613),
("Addictive but Time-Consuming", "SnowRunner can be time-consuming with its long journeys and tough missions, but the sense of accomplishment is well worth it. A great game for fans of off-road adventures.", 4.7, 92, 614);

-- Recensioni per "Sonic Frontiers" (GameID 115)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A New Sonic Adventure", "Sonic Frontiers brings the blue blur to an open-world environment, and it's a refreshing change. The world is huge, and the new mechanics are a blast to explore. It's a fun and fast-paced adventure!", 4.8, 115, 615),
("Sonic Meets Open-World", "Sonic Frontiers introduces a great open-world concept that works really well with the classic speed of Sonic. The world is fun to explore, and the combat adds a new layer to the experience.", 4.7, 115, 616),
("A Fresh Take on Sonic", "The game takes a more experimental approach to the Sonic franchise, with an open-world setting and new gameplay mechanics. While it's not perfect, it's an exciting step forward for the series.", 4.6, 115, 617),
("A Step in the Right Direction", "Sonic Frontiers offers a fresh experience with great visuals and exciting exploration. The combat could use some refinement, but it's definitely a fun time for Sonic fans.", 4.5, 115, 618),
("Fun and Free-Flowing", "The open-world aspect of Sonic Frontiers is amazing! It's fun to zoom around and explore new areas. The controls are smooth, and there's a lot to discover in the vast world.", 4.9, 115, 619),
("Sonic in a New Light", "Sonic Frontiers is a unique take on the franchise. The open-world structure offers plenty of freedom and exploration, but it's still very much a Sonic game with fast-paced action and platforming.", 4.7, 115, 620),
("An Open-World Success", "Sonic Frontiers successfully mixes open-world exploration with the classic Sonic speed. The game is exciting to play, though the story feels a bit weak at times. Still, it's a great Sonic experience overall.", 4.8, 115, 621),
("Great for Sonic Fans", "Sonic Frontiers is a blast to play, offering lots of freedom and new gameplay mechanics. The game still has some issues, but it's a step in the right direction for the Sonic series.", 4.6, 115, 622),
("A Bold New Sonic Game", "Frontiers brings something new to the table for Sonic fans. The open-world setting and new mechanics are fun, though there are some elements that could be polished further.", 4.7, 115, 623),
("Exciting Yet Imperfect", "Sonic Frontiers is a lot of fun, and the open-world concept works really well. However, the game could use a bit more refinement in its combat and level design, but overall it's a great experience.", 4.5, 115, 624);

-- Recensioni per "Soulcalibur VI" (GameID 154)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Fantastic Fighter", "Soulcalibur VI is an excellent addition to the series with beautiful graphics, smooth combat mechanics, and a great roster of characters. It's a must-play for any fighting game fan.", 4.9, 154, 625),
("The Ultimate Fighter", "Soulcalibur VI offers fantastic combat and deep mechanics, making it a great fighting game. The character customization options are also a great addition, making the game even more enjoyable.", 5.0, 154, 626),
("A Beautiful and Fun Fighter", "The game looks amazing, and the combat is as fun as ever. Soulcalibur VI stays true to its roots while also adding new features and mechanics. A great experience for fans of the series.", 4.8, 154, 627),
("Soulcalibur at Its Best", "Soulcalibur VI is one of the best in the series. The combat is fluid, the characters are diverse, and the graphics are stunning. It's the perfect fighting game for both casual and competitive players.", 5.0, 154, 628),
("A Solid Fighting Game", "Soulcalibur VI delivers exactly what fans expect: fast-paced combat, great characters, and solid gameplay. It's fun, but the story mode feels a bit lacking compared to previous entries.", 4.7, 154, 629),
("Great Combos and Characters", "The combat system is rewarding and fun, with tons of character variety. Soulcalibur VI is an enjoyable fighting game, though the story mode could use more depth.", 4.6, 154, 630),
("A Fighting Game Masterpiece", "Soulcalibur VI is a masterpiece of the fighting game genre. The battles are fast and exciting, and the visuals are top-notch. If you love fighting games, this one is a must-have.", 5.0, 154, 631),
("Fun and Competitive", "Soulcalibur VI provides a fun and competitive environment for fighting game enthusiasts. It's not as complex as some other fighters, but it's still very enjoyable.", 4.5, 154, 632),
("Smooth and Enjoyable", "The combat is smooth, and the characters feel unique. Soulcalibur VI does a great job at capturing the essence of what makes fighting games fun, and the character roster is impressive.", 4.8, 154, 633),
("A Great Fighting Game", "Soulcalibur VI offers fun gameplay, a great roster, and excellent visuals. The game could use some work on its story, but the competitive aspect makes it worth playing for any fighting game fan.", 4.7, 154, 634);


-- Recensioni per "Spider-Man 2" (GameID 267)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Stunning Spider-Man Adventure", "Spider-Man 2 delivers an incredible open-world superhero experience. The graphics are stunning, and the new gameplay mechanics add even more fun to the swinging and combat. A must-play for fans of the series!", 5.0, 267, 635),
("Amazing Web-Slinging Fun", "The combat and web-swinging are incredibly fluid, and the story is engaging. Spider-Man 2 offers an unforgettable superhero experience with tons of side missions and collectibles!", 4.9, 267, 636),
("Spider-Man at His Best", "Spider-Man 2 brings the superhero experience to a new level with fantastic gameplay, amazing visuals, and a compelling story. The new characters and powers make it an exciting experience from start to finish.", 5.0, 267, 637),
("Superb and Immersive", "The game takes everything good about the first and expands it beautifully. The open-world design, swinging through the city, and the combat system are all top-notch. Spider-Man 2 is a treat!", 4.8, 267, 638),
("Web-Slinging Perfection", "This is the ultimate Spider-Man game. The mechanics are fluid, the combat is rewarding, and the world feels alive. A beautiful and exciting experience for fans of Marvel's Spider-Man.", 5.0, 267, 639),
("Great Sequel, Bigger and Better", "Spider-Man 2 is an amazing sequel with improved mechanics, an engaging story, and a much larger world to explore. The new characters add depth to the experience, making it a true superhero adventure.", 4.9, 267, 640),
("Incredible Open World", "The city feels more alive than ever, and the story takes Spider-Man's journey to new heights. The addition of new powers and characters adds variety and excitement to the gameplay.", 4.8, 267, 641),
("Best Spider-Man Game Yet", "Spider-Man 2 improves on everything that made the first game so great. The visuals, the combat, and the overall world-building are exceptional. The perfect game for any superhero fan!", 5.0, 267, 642),
("Epic Adventure", "Spider-Man 2 is a thrilling and beautiful adventure. The world feels so expansive, and the story is emotional. The combat is fluid and satisfying, making this one of the best Spider-Man games ever made.", 4.9, 267, 643),
("Fantastic Sequel", "Spider-Man 2 improves on the original in every way. The world feels richer, the combat is better, and the story is more engaging. It's an experience that no Spider-Man fan should miss.", 4.8, 267, 644);

-- Recensioni per "Spider-Man: Miles Morales" (GameID 10)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Perfect Spin-off", "Miles Morales shines in his own adventure. The combat feels fresh, the new powers are fun, and the story is heartwarming. It's a great addition to the Spider-Man universe.", 4.9, 10, 645),
("Amazing Story and Gameplay", "Miles Morales is a fantastic game with a heartfelt story and dynamic gameplay. The new powers and combat mechanics make this a fun, fresh take on the Spider-Man formula.", 5.0, 10, 646),
("A Solid Sequel", "Spider-Man: Miles Morales brings a fresh twist to the Spider-Man formula. The combat is satisfying, the new abilities are fun to use, and the story is both emotional and impactful.", 4.8, 10, 647),
("Miles' Adventure Shines", "The game is visually stunning, with smooth combat and a wonderful story that highlights Miles' growth as Spider-Man. It's a thrilling and emotional journey from start to finish.", 4.9, 10, 648),
("A Unique Spider-Man Experience", "Miles Morales offers a unique and engaging Spider-Man experience with fresh mechanics and a heartwarming story. The world feels vibrant, and the gameplay is fluid and fun.", 5.0, 10, 649),
("Superb Game", "A fantastic spin-off that introduces new gameplay elements and an emotional story. Miles' character development and powers make this a standout superhero game.", 4.8, 10, 650),
("Incredible Gameplay", "The swinging mechanics, combat, and powers make Miles Morales feel like a fresh experience. The emotional story adds another layer of depth to this fantastic Spider-Man game.", 4.9, 10, 651),
("A Great Adventure", "Spider-Man: Miles Morales delivers a thrilling adventure with exciting new powers and a heartfelt story. It's a must-play for any Spider-Man fan or those looking for an exciting superhero game.", 4.7, 10, 652),
("A Hero's Journey", "Miles Morales is an outstanding game. The combat is satisfying, the graphics are beautiful, and the story is touching. A great continuation of the Spider-Man saga.", 5.0, 10, 653),
("A Perfect Spin-off Game", "The new powers and the way they're integrated into the story make this a truly memorable Spider-Man experience. Miles Morales is just as enjoyable as the original.", 4.8, 10, 654);

-- Recensioni per "Spiritfarer" (GameID 103)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Heartfelt Journey", "Spiritfarer offers a touching and emotional experience. The gameplay is simple, but it's filled with heart and beautiful moments. It's a great game to reflect on life and loss.", 5.0, 103, 655),
("A Beautiful Adventure", "Spiritfarer is a gorgeous game with a unique premise. The world is beautiful, the music is calming, and the emotional depth of the story makes it unforgettable.", 4.9, 103, 656),
("A Masterpiece of Emotion", "Spiritfarer is a deeply emotional game that deals with themes of death and friendship in a unique way. The gameplay is relaxing and meditative, but it also tugs at your heartstrings.", 5.0, 103, 657),
("An Emotional Journey", "Spiritfarer is a game that touches your heart. The art style is beautiful, and the gameplay is relaxing, but the real magic lies in its emotional narrative about loss, love, and letting go.", 4.8, 103, 658),
("A Beautiful and Calm Experience", "The art is stunning, the music is peaceful, and the story is heartfelt. Spiritfarer is a wonderful experience, though it can be a bit slow at times. Still, it's a rewarding journey.", 4.7, 103, 659),
("A Heartwarming Experience", "Spiritfarer is a beautiful game about life, death, and friendship. The journey is calm and reflective, but it's also deeply moving. A wonderful game for anyone who loves stories with emotional depth.", 5.0, 103, 660),
("Unique and Moving", "Spiritfarer's story is incredibly moving, and the gameplay offers a mix of exploration and management. It's a game that stays with you long after you've finished playing.", 4.9, 103, 661),
("Beautifully Crafted", "The game is a beautiful journey about letting go, and its themes of friendship and loss are handled wonderfully. Spiritfarer is a gem that will stick with you long after you finish it.", 5.0, 103, 662),
("A Calm Yet Powerful Game", "Spiritfarer is relaxing but also deeply powerful. It's a game about helping souls move on, and it's a reminder of the beauty and sorrow of life. The gameplay is soothing, and the story is profound.", 4.8, 103, 663),
("A Deeply Emotional Game", "Spiritfarer takes you on an emotional journey. It's calm, thoughtful, and deals with big themes like death and moving on. A beautiful and unique experience that everyone should try.", 5.0, 103, 664);


-- Recensioni per "Splatoon 3" (GameID 133)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Colorful and Fun Shooter", "Splatoon 3 brings the fun and excitement of ink-based combat to a new level. The new weapons and modes are fantastic, and the gameplay is fast-paced and engaging. A great game for multiplayer action!", 5.0, 133, 665),
("Ink and Fun", "The game's multiplayer modes are fast and fun. Splatoon 3 takes everything good about the previous games and adds new features to make it more exciting. The art style and overall feel are amazing!", 4.9, 133, 666),
("Fantastic New Additions", "Splatoon 3 is everything I hoped for. The new weapons, maps, and modes add so much depth to the game, making it even more fun and competitive. The ink battles never get old!", 5.0, 133, 667),
("Splat-tastic Gameplay", "The addition of new features like custom matches and a more robust single-player campaign make Splatoon 3 an absolute blast. It's the most fun I've had with a shooter in a while!", 4.8, 133, 668),
("A Splash of Freshness", "Splatoon 3 feels fresh with its vibrant visuals, tight controls, and fun multiplayer modes. The new weapons and maps bring an exciting twist to the classic formula.", 4.9, 133, 669),
("A Unique Shooter", "Splatoon 3 is a unique twist on the shooter genre, and it does it well. The ink-based combat is a lot of fun, and the game constantly introduces new features to keep things interesting. Highly recommend!", 5.0, 133, 670),
("Fun for All Ages", "This game is just pure fun. Whether you're a competitive player or just looking for some casual ink battles, Splatoon 3 delivers in every way. It's got that special Nintendo charm!", 4.7, 133, 671),
("Ink Warfare", "Splatoon 3 delivers intense ink-based warfare with loads of new content. The battles are fun, and the variety in weapons and special abilities make every match feel fresh and exciting.", 5.0, 133, 672),
("A Colorful Chaos", "Splatoon 3 takes everything that made its predecessors great and elevates it. The multiplayer is hectic, the colors are vibrant, and there's always something new to try. Highly recommended for fans of competitive shooters!", 4.8, 133, 673),
("Incredible Multiplayer", "The multiplayer is what really shines in Splatoon 3. The game keeps things fresh with constant updates, new maps, and exciting challenges that keep me coming back for more.", 5.0, 133, 674);

-- Recensioni per "Spyro Reignited Trilogy" (GameID 113)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Nostalgic Journey", "Spyro Reignited Trilogy brings the classic Spyro games back to life with beautiful visuals and revamped gameplay. It's a perfect nostalgia trip for fans and a great introduction to new players.", 5.0, 113, 675),
("A Brilliant Remaster", "The remastered trilogy of Spyro looks stunning. The old-school gameplay still holds up, and the updated visuals and audio make it feel fresh. A must-have for platformer fans!", 4.9, 113, 676),
("Spyro Returns Better Than Ever", "The Spyro Reignited Trilogy does a fantastic job of preserving the charm of the original games while updating them with modern graphics. It's a blast to play through these classics again.", 5.0, 113, 677),
("Spyro in HD", "The visuals are incredible, and the classic platforming gameplay remains as fun as ever. The new coat of paint and added quality of life improvements make the trilogy feel like a modern game, while keeping the spirit of the originals.", 4.8, 113, 678),
("A Perfect Remaster", "Spyro Reignited Trilogy is a true remaster done right. The gameplay is timeless, the controls are tight, and the updated visuals and sound design make it feel like a whole new experience.", 5.0, 113, 679),
("Timeless Platformer", "Even with the remaster, Spyro's platforming still feels great. The updated visuals are gorgeous, and the trilogy contains hours of content that will keep you coming back for more.", 4.9, 113, 680),
("A Trip Down Memory Lane", "Spyro Reignited Trilogy is a wonderful reminder of what made the original games so special. The updated graphics, while impressive, don't take away from the nostalgia that these games bring.", 4.7, 113, 681),
("Perfect for Platformer Lovers", "If you love platformers, Spyro Reignited Trilogy is a must-play. It retains the magic of the original Spyro games while updating the visuals to be absolutely stunning. It's a pure joy to play.", 5.0, 113, 682),
("The Ultimate Spyro Collection", "Spyro Reignited Trilogy is the ultimate collection for fans of the classic platformer. It's got everything that made the originals great, but with much better visuals and sound.", 4.8, 113, 683),
("An Incredible Remaster", "Spyro Reignited Trilogy is a perfect remaster. The updated visuals are stunning, and the gameplay remains as fun as ever. The trilogy includes everything fans love about Spyro in one beautiful package.", 5.0, 113, 684);

-- Recensioni per "Star Wars: The Old Republic" (GameID 126)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Classic MMO", "Star Wars: The Old Republic is a fantastic MMO that truly captures the spirit of the Star Wars universe. The storylines are engaging, the combat is fun, and the world is rich and immersive.", 5.0, 126, 685),
("An Epic Star Wars Experience", "The Old Republic offers an incredible Star Wars experience with immersive storylines and exciting combat. It's perfect for fans of both Star Wars and MMORPGs.", 4.9, 126, 686),
("A Must-Play for Star Wars Fans", "The Old Republic combines a compelling Star Wars narrative with deep MMORPG gameplay. Whether you're a fan of the story or the combat, it offers something for everyone in the Star Wars universe.", 5.0, 126, 687),
("A Great Star Wars Adventure", "The Old Republic gives you the chance to live out your own Star Wars story with engaging quests, exciting combat, and the chance to explore a galaxy far, far away.", 4.8, 126, 688),
("Epic Star Wars Storytelling", "The Old Republic does a brilliant job of combining epic Star Wars storytelling with classic MMORPG mechanics. The game has tons of content and allows you to live your own adventure in the galaxy.", 5.0, 126, 689),
("Fantastic World-Building", "Star Wars: The Old Republic is an incredibly detailed MMO that feels like it's truly part of the Star Wars universe. The factions, the lore, and the vast galaxy are all wonderfully realized.", 4.9, 126, 690),
("A Stellar Star Wars MMO", "This game has a lot to offer, from great storylines to exciting PvP and PvE content. The Old Republic is a must-play for anyone who loves Star Wars or MMORPGs in general.", 4.8, 126, 691),
("Live Your Star Wars Fantasy", "The Old Republic lets you live out your own Star Wars story. The questlines are engaging, the world is expansive, and the combat is enjoyable. An incredible experience for any Star Wars fan.", 5.0, 126, 692),
("A Huge Star Wars Adventure", "Star Wars: The Old Republic is one of the best Star Wars video games. With its engaging quests and deep lore, it's a must-play for any fan of the franchise or MMORPGs.", 4.9, 126, 693),
("Immersive Star Wars Universe", "This game immerses you in the Star Wars universe with amazing detail, great quests, and dynamic gameplay. The Old Republic is a fantastic experience for anyone who loves Star Wars or MMORPGs.", 4.8, 126, 694);


-- Recensioni per "Stardew Valley" (GameID 95)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Cozy Farming Adventure", "Stardew Valley is the ultimate cozy farming simulator. The variety of crops, animals, and community events make this game incredibly addictive. The perfect escape from the daily grind!", 5.0, 95, 695),
("Charming and Relaxing", "Stardew Valley offers a relaxing experience with its farming and crafting mechanics. It's perfect for those who want to unwind and enjoy a charming rural life. So many things to do, you'll never get bored!", 4.9, 95, 696),
("The Best Life Simulator", "If you enjoy life simulators, Stardew Valley is the best there is. Between farming, fishing, and building relationships with the town's residents, there's always something fun to do. Highly recommended!", 5.0, 95, 697),
("A Farm for the Soul", "This game is a peaceful retreat. The farming mechanics are simple but deep, and the relationships with the townsfolk are charming. You can easily lose yourself in Stardew Valley for hours on end!", 4.8, 95, 698),
("An Addictive Farm Sim", "Stardew Valley is deceptively simple, but it becomes incredibly engaging as you upgrade your farm, make friends, and participate in seasonal events. It's a must-play for anyone who loves simulation games!", 5.0, 95, 699),
("A Perfect Blend of Farming and Exploration", "Stardew Valley offers a perfect balance between farming, exploration, and story-driven elements. The customization options and seasonal events make it a deeply rewarding experience.", 4.9, 95, 700),
("A Great Escape", "Stardew Valley is the ultimate escape. Between planting crops, tending to animals, and interacting with the quirky townsfolk, this game has a way of pulling you in and making you feel right at home.", 4.8, 95, 701),
("Endless Fun in a Small Town", "The depth of gameplay in Stardew Valley is remarkable. With so many things to do – from farming to fishing and mining – it's easy to get lost in this tiny town for hours.", 5.0, 95, 702),
("A Peaceful, Yet Engaging Game", "Stardew Valley offers a calming experience while still being engaging enough to keep you hooked. It's a wonderful balance of farming, crafting, and socializing with the townspeople.", 4.7, 95, 703),
("A Wonderful Game for Relaxation", "Stardew Valley is a delightful game that gives you the chance to unwind and build your own little paradise. Whether you're farming, fishing, or exploring the caves, there's always something enjoyable to do.", 5.0, 95, 704);

-- Recensioni per "Starfield" (GameID 57)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Vast Space Adventure", "Starfield offers an expansive and immersive space exploration experience. The freedom to explore different planets and the deep narrative make this game truly special. It's a dream come true for sci-fi fans!", 5.0, 57, 705),
("A Stellar RPG", "The RPG elements in Starfield are fantastic. From building your own ship to engaging in complex storylines, the game delivers a rich experience. The world-building is exceptional, and the space travel mechanics are incredibly well-done.", 4.9, 57, 706),
("A Universe to Explore", "Starfield's universe is absolutely massive, with endless planets to explore. The attention to detail in the world-building is amazing, and there's so much to discover in every corner of the galaxy.", 5.0, 57, 707),
("Immersive Sci-Fi Journey", "This game takes you on an incredible journey across the stars. With its deep lore, vast exploration options, and captivating storylines, Starfield is a must-play for fans of space RPGs.", 4.8, 57, 708),
("Incredible Space Exploration", "Starfield is a thrilling adventure that lets you explore the unknown depths of space. The graphics are stunning, and the amount of content available is mind-blowing. A must-have for any fan of open-world RPGs.", 5.0, 57, 709),
("A Dream for Space Lovers", "The level of freedom and customization in Starfield is extraordinary. From shipbuilding to customizing your character, this game gives you full control over your space adventure. It's perfect for fans of space exploration and RPGs alike.", 5.0, 57, 710),
("A Galactic Experience", "Starfield takes space exploration to a whole new level. The visuals are breathtaking, and the deep story and multiple paths to take make it a rewarding experience. Truly a game to get lost in!", 4.9, 57, 711),
("Endless Possibilities", "The world of Starfield is vast and filled with possibilities. Whether you're exploring distant planets, engaging in space battles, or following the main storyline, there's always something exciting to do.", 5.0, 57, 712),
("A Masterpiece of Sci-Fi", "Starfield is a true masterpiece of the sci-fi genre. The exploration mechanics are top-notch, and the intricate world-building makes the game feel alive. The best space RPG I've played in years.", 4.9, 57, 713),
("A Thrilling Journey Beyond Earth", "Starfield is a thrilling space RPG that provides an expansive universe full of exploration, combat, and mystery. It's an unforgettable experience that every RPG fan should try.", 5.0, 57, 714);

-- Recensioni per "Steep" (GameID 269)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Adrenaline-Fueled Snowboarding", "Steep offers a thrilling snowboarding experience with incredible freedom. The open-world design and various challenges give players the chance to enjoy a variety of extreme sports at their own pace.", 4.9, 269, 715),
("A Beautiful Winter Playground", "Steep is visually stunning and offers a massive open world for winter sports enthusiasts. Whether you're snowboarding, skiing, or paragliding, the game provides a rush of adrenaline at every turn.", 4.8, 269, 716),
("The Ultimate Winter Sports Game", "Steep is the ultimate winter sports game. The freedom to explore the mountains and take on challenges with friends or solo is both exciting and rewarding. It's a fun and exhilarating experience for anyone who loves snow sports!", 5.0, 269, 717),
("Incredible Snowboarding Experience", "Steep provides a one-of-a-kind snowboarding experience. The massive open world is beautiful, and the various challenges keep the game exciting. The freedom to go anywhere and do anything in the snow makes this a must-play for fans of extreme sports.", 4.9, 269, 718),
("An Addictive Rush", "Steep's mechanics are smooth, and the variety of winter sports available ensures the game stays fresh. The open-world design is vast, and it's easy to get lost in the mountain ranges. It's an adrenaline-packed adventure that I can't put down.", 5.0, 269, 719),
("A Beautiful Snowy World", "The snowboarding mechanics in Steep are fantastic, and the world is gorgeous to explore. The mountain landscapes and snowy peaks are mesmerizing, and the game offers plenty of content to keep players entertained.", 4.7, 269, 720),
("Unleash Your Inner Adventurer", "Steep allows you to unleash your inner adventurer by offering a huge world filled with challenges and adrenaline-pumping stunts. Whether you're on a snowboard or skis, this game will keep you coming back for more.", 5.0, 269, 721),
("Freedom in the Snow", "The open-world design in Steep offers unparalleled freedom. You can tackle challenges at your own pace, whether you're gliding across snowy peaks or performing epic stunts on skis. It's a great game for those who love extreme sports.", 4.8, 269, 722),
("Epic Winter Adventures", "Steep gives you the chance to explore epic mountain ranges while performing thrilling stunts. The game's attention to detail and realistic physics make every jump and trick feel exhilarating. A must-play for snow sports fans!", 5.0, 269, 723),
("Snowboarder's Dream", "Steep is a snowboarder's dream come true. The open-world design and the variety of challenges, along with breathtaking visuals, make this game a must-play for anyone who loves winter sports.", 4.9, 269, 724);


-- Recensioni per "Stellaris" (GameID 70)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Deep Space Strategy", "Stellaris offers a rich and immersive experience for fans of grand strategy. The game's depth, from managing your empire to exploring uncharted galaxies, is unmatched. It's a must-play for strategy enthusiasts!", 5.0, 70, 725),
("A Galactic Empire Awaits", "Stellaris lets you build your own empire and guide it through the stars. The vast customization options and the ever-changing galaxy keep the game fresh. It's an incredibly rewarding strategy experience.", 4.9, 70, 726),
("Endless Possibilities in Space", "Stellaris provides an endless number of ways to conquer the galaxy. With intricate politics, science, and warfare systems, this game offers a fantastic blend of strategy and sci-fi.", 5.0, 70, 727),
("A Universe to Conquer", "This game is perfect for those who love deep strategy and space exploration. Stellaris combines empire-building, diplomacy, and warfare, and the result is an incredibly detailed and immersive experience.", 5.0, 70, 728),
("A Must-Play for Strategy Fans", "Stellaris is the ultimate grand strategy game, with a sprawling galaxy full of diverse species and endless strategic opportunities. Every playthrough feels unique, offering hours of entertainment.", 4.9, 70, 729),
("Mastering the Stars", "The depth of Stellaris is staggering. From managing resources to waging war with alien species, every decision you make can impact the fate of your empire. A truly deep and rewarding game for strategy lovers.", 5.0, 70, 730),
("A Space Opera Strategy", "Stellaris blends grand strategy with space exploration perfectly. The game gives you the power to design your empire, develop technologies, and conquer the stars. The best space strategy game out there!", 4.8, 70, 731),
("A Brilliant Space Strategy Game", "The combination of strategy, exploration, and diplomacy makes Stellaris one of the best grand strategy games available. It's packed with depth and replayability, with a huge variety of possible playstyles.", 5.0, 70, 732),
("Complex, but Rewarding", "Stellaris can be complex, but once you get the hang of it, it becomes incredibly rewarding. The thrill of exploring the galaxy and building your empire makes it one of the best strategy games of all time.", 4.7, 70, 733),
("A Galactic Adventure", "Stellaris offers a true galactic adventure, where every decision counts. Whether you're forming alliances, conquering planets, or managing your resources, it's an endless experience that keeps you engaged for hours.", 5.0, 70, 734);

-- Recensioni per "Street Fighter 6" (GameID 148)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("The King of Fighters", "Street Fighter 6 has everything you need in a fighting game: smooth mechanics, exciting new characters, and fantastic visuals. The online mode is also a blast, and the game's training mode helps newcomers get into the action.", 5.0, 148, 735),
("A New Era of Fighting", "Street Fighter 6 revitalizes the franchise with a modern twist while staying true to its roots. The new mechanics are fantastic, and the inclusion of new modes keeps things fresh and exciting for both veterans and newcomers.", 4.9, 148, 736),
("Perfect for Fighting Game Fans", "Street Fighter 6 is a perfect blend of traditional fighting game mechanics and new innovations. The characters are diverse, and the gameplay is incredibly smooth. It's a joy to play!", 5.0, 148, 737),
("The Ultimate Street Fighter Experience", "Street Fighter 6 improves on everything that made the previous games great. The controls are tight, the roster is expansive, and the visuals are stunning. A must-play for any fighting game enthusiast.", 5.0, 148, 738),
("A True Fighting Masterpiece", "With its improved mechanics, new roster, and stunning visuals, Street Fighter 6 is a true masterpiece in the fighting game genre. The combo system is deep, and the game's modes provide hours of entertainment.", 4.8, 148, 739),
("A Fighting Game Like No Other", "Street Fighter 6 is a beautifully crafted game that takes fighting games to a whole new level. The new mechanics make combat feel fluid, and the character diversity keeps the gameplay fresh.", 5.0, 148, 740),
("Exciting and Dynamic", "The gameplay in Street Fighter 6 is fast-paced and dynamic, offering a thrilling experience for both new players and veterans. The new features breathe new life into the franchise, making it one of the best fighting games ever.", 4.9, 148, 741),
("A Next-Gen Fighter", "Street Fighter 6 takes the iconic series into the next generation of gaming with impressive visuals, refined mechanics, and exciting new characters. It's the perfect game for anyone looking for a challenging and fun fighting game.", 5.0, 148, 742),
("Innovative and Fun", "Street Fighter 6 introduces some fun and innovative gameplay mechanics, such as the new drive system. It's a blast to play, and there's something for everyone, whether you're into casual play or competitive fighting.", 4.9, 148, 743),
("The Ultimate Showdown", "Street Fighter 6 brings together everything that makes the series great. The online modes are robust, the single-player content is deep, and the gameplay is as satisfying as ever. It's the best installment in the franchise in years.", 5.0, 148, 744);

-- Recensioni per "Super Mario Odyssey" (GameID 111)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Magical Mario Adventure", "Super Mario Odyssey is a masterpiece. The gameplay is fresh and exciting, with new mechanics like Cappy. The worlds are vibrant, the puzzles are creative, and the platforming is top-notch. It's an unforgettable experience.", 5.0, 111, 745),
("A Journey Like No Other", "Super Mario Odyssey takes you on a wild ride around the world. The variety of kingdoms is incredible, and the Cappy mechanic adds an innovative twist. It's the perfect Mario game for fans of all ages.", 5.0, 111, 746),
("Mario at His Best", "Super Mario Odyssey is the best Mario game in years. The platforming is incredibly fun, and the new mechanics make it feel fresh. Each kingdom is a joy to explore, and the level design is nothing short of brilliant.", 5.0, 111, 747),
("A Brilliant Mario Game", "Super Mario Odyssey is a true 3D platforming gem. The levels are packed with secrets, the Cappy mechanic is super fun, and the creativity of the developers shines through. Highly recommended!", 5.0, 111, 748),
("Pure Platforming Perfection", "Super Mario Odyssey is an absolute blast to play. The platforming feels smooth, the controls are precise, and the variety of gameplay in each world keeps things exciting. It's a must-play for Mario fans!", 5.0, 111, 749),
("A Journey Through Amazing Worlds", "The creativity in Super Mario Odyssey is off the charts. The variety of kingdoms is a treat to explore, and the Cappy mechanic adds a whole new layer of depth to the gameplay. Simply fantastic.", 4.9, 111, 750),
("An Epic Mario Adventure", "Super Mario Odyssey is everything you could want in a Mario game. The visuals are stunning, the levels are full of surprises, and the new gameplay mechanics make it feel completely fresh. A must-have for any Nintendo fan!", 5.0, 111, 751),
("An Amazing 3D Platformer", "Super Mario Odyssey is a fantastic 3D platformer. The levels are full of creativity and the Cappy mechanic adds a new dimension to the gameplay. The game is a joy to play from start to finish.", 5.0, 111, 752),
("Mario's Best Adventure Yet", "Super Mario Odyssey is an absolute joy to play. The game is packed with unique worlds to explore, and the Cappy mechanic makes the gameplay even more fun and dynamic. It's an essential Mario title.", 5.0, 111, 753),
("A Fun and Creative Odyssey", "Super Mario Odyssey is a fantastic adventure that's full of fun and creativity. The levels are varied and packed with secrets, and the Cappy mechanic keeps things fresh. It's one of Mario's best adventures ever.", 4.9, 111, 754);


-- Recensioni per "Super Smash Bros. Ultimate" (GameID 153)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("The Ultimate Brawler", "Super Smash Bros. Ultimate lives up to its name by offering the most comprehensive roster of fighters and exciting battle modes. It's a perfect game for both casual players and competitive gamers.", 5.0, 153, 755),
("A Brawler's Paradise", "Super Smash Bros. Ultimate brings together the best of the series with stunning visuals and gameplay that is easy to pick up but hard to master. It's the ultimate fighting game for fans of any age.", 5.0, 153, 756),
("Smash Bros. at Its Best", "The variety of fighters in Super Smash Bros. Ultimate is amazing, and the new mechanics and stages make the game feel fresh and exciting. It's a must-have for any Nintendo fan and fighting game enthusiast.", 5.0, 153, 757),
("The Best Smash Bros. Yet", "Super Smash Bros. Ultimate is the definitive version of the series. With an incredible roster of characters and fantastic gameplay, it's an absolute blast to play with friends. The game is pure fun!", 5.0, 153, 758),
("An Epic Crossover Fighter", "The sheer amount of content in Super Smash Bros. Ultimate is staggering. With a massive roster and numerous modes to explore, it's the perfect fighting game for anyone looking for variety and fun.", 4.9, 153, 759),
("The Ultimate Crossover", "Super Smash Bros. Ultimate takes everything that's great about the series and makes it bigger and better. It's a perfect blend of nostalgia and new content, and the gameplay is as fun and accessible as ever.", 5.0, 153, 760),
("Perfect for Competitive and Casual Play", "Super Smash Bros. Ultimate is a fantastic game for both competitive players and those just looking for some fun with friends. The gameplay is fluid, and the variety of fighters is unbeatable.", 5.0, 153, 761),
("Endless Fun", "With a vast roster of characters and a ton of stages, Super Smash Bros. Ultimate offers endless fun. Whether you're playing solo or with friends, it's a game that always delivers exciting moments.", 5.0, 153, 762),
("A Fighting Game for Everyone", "Super Smash Bros. Ultimate is accessible for beginners but offers depth for advanced players. It's fun for everyone and provides hours of competitive play. A must-have for any Switch owner.", 5.0, 153, 763),
("A Smash Hit", "This game is the best way to enjoy a party with friends or to compete in a serious tournament. Super Smash Bros. Ultimate offers a fun and exciting experience that can be enjoyed by anyone.", 4.9, 153, 764);

-- Recensioni per "Tales of Arise" (GameID 61)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Captivating Tale", "Tales of Arise brings a captivating story and beautiful visuals to the RPG genre. The characters are well-developed, and the combat system is fluid and enjoyable. It's a fantastic entry in the Tales series.", 5.0, 61, 765),
("An Epic Journey", "Tales of Arise features an unforgettable story set in a stunning world. The combat is fast-paced and satisfying, and the character development is top-notch. It's one of the best RPGs I've played in a long time.", 5.0, 61, 766),
("A Beautiful RPG", "The world of Tales of Arise is breathtaking, and the characters are compelling. The combat system is a joy to use, and the game keeps you engaged with its rich lore and fantastic side quests.", 5.0, 61, 767),
("Tales of Arise is a Masterpiece", "This game blends stunning visuals, great storytelling, and fluid combat into a fantastic experience. The narrative is emotionally gripping, and the world-building is exceptional. A must-play for any RPG fan.", 5.0, 61, 768),
("A Story of Freedom and Hope", "Tales of Arise offers a deeply emotional story and beautiful animation. The battle mechanics are smooth, and the characters' interactions make the game a heartfelt journey worth experiencing.", 4.9, 61, 769),
("One of the Best Tales Games", "Tales of Arise delivers an exceptional RPG experience. The combat is dynamic, and the story is both immersive and impactful. It's a perfect balance of action and narrative depth.", 5.0, 61, 770),
("A Gorgeous RPG", "Tales of Arise has incredible visuals, an engaging combat system, and a powerful story. The characters are well-written and the combat is a lot of fun. This game is an RPG lover's dream come true.", 5.0, 61, 771),
("A Brilliant RPG Experience", "Tales of Arise excels in every aspect. The story, the characters, and the world design are all beautifully crafted, and the combat feels intuitive yet deep. A standout RPG of the generation.", 5.0, 61, 772),
("A Journey Worth Taking", "Tales of Arise is an unforgettable journey with great characters and a compelling story. The combat system is exhilarating, and the environments are gorgeous. It's a must-play for anyone who loves JRPGs.", 5.0, 61, 773),
("An Unmissable RPG", "The captivating world and story of Tales of Arise kept me hooked from start to finish. The characters are lovable, and the battle system is exhilarating. An unmissable game for RPG fans.", 5.0, 61, 774);

-- Recensioni per "Tekken 7" (GameID 149)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("The Ultimate Fighting Game", "Tekken 7 takes the series to new heights with incredible gameplay, a deep roster, and an engaging story. The movesets are intricate, and the visuals are stunning. It's a must-play for fighting game enthusiasts.", 5.0, 149, 775),
("Masterful Combat", "Tekken 7 features some of the best combat mechanics in the fighting game genre. The roster is diverse, and the visuals are gorgeous. Whether you're a casual player or a competitive fighter, Tekken 7 delivers an exciting experience.", 5.0, 149, 776),
("Tekken's Best Entry Yet", "Tekken 7 brings a perfect mix of classic mechanics and new features. The story mode is engaging, and the online multiplayer is as competitive as ever. A fantastic game for any fan of fighting games.", 5.0, 149, 777),
("Fighting at Its Finest", "Tekken 7 offers incredibly smooth combat and a deep roster of characters. The mechanics are finely tuned, and the game offers plenty of ways to engage, from single-player to online matches. A brilliant entry in the Tekken series.", 5.0, 149, 778),
("A Fighting Game Masterpiece", "Tekken 7 is one of the best fighting games ever made. The depth of the combat system is unmatched, and the roster of characters offers plenty of variety. The visuals and sound design are top-notch as well.", 5.0, 149, 779),
("Tekken 7 Perfected", "Tekken 7 refines everything that made the series great. The fighting mechanics are incredibly satisfying, the characters are well-designed, and the online multiplayer is intense. A must-play for fighting game fans.", 5.0, 149, 780),
("A True Tekken Experience", "Tekken 7 is a fantastic fighting game that combines technical depth and accessibility. The movesets are complex, but the game is easy to pick up and play. The online mode is excellent, and the game's visuals are stunning.", 5.0, 149, 781),
("Fighting Done Right", "Tekken 7 nails everything a fighting game needs. The combat is fluid, the roster is varied, and the game offers multiple ways to enjoy it, whether you're playing alone or with friends. One of the best in the genre.", 4.9, 149, 782),
("Incredible Combat and Characters", "Tekken 7's combat system is superb, with a ton of moves and strategies to master. The game has a great roster of fighters and offers one of the best fighting experiences out there.", 5.0, 149, 783),
("An Outstanding Fighting Game", "Tekken 7 is a true masterpiece in the fighting genre. The combat feels incredibly smooth, and the character balance is perfect. Whether playing solo or online, this game is an absolute joy to play.", 5.0, 149, 784);


-- Recensioni per "Tekken 8" (GameID 270)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Next-Level Fighting", "Tekken 8 pushes the series to new heights with enhanced graphics, deep combat mechanics, and an exciting roster of characters. The gameplay is fluid and rewarding, making it the best Tekken game yet.", 5.0, 270, 785),
("A Revolution in Fighting Games", "Tekken 8 improves upon every aspect of the series with stunning visuals and an even more refined combat system. The gameplay is satisfying, and the roster is diverse. An essential title for fighting game fans.", 5.0, 270, 786),
("The Future of Fighting", "Tekken 8 takes the iconic franchise to the next level. The visuals are mind-blowing, and the combat mechanics feel more dynamic and complex. It's a fantastic addition to the Tekken legacy.", 5.0, 270, 787),
("Tekken 8 Delivers", "The changes to the combat system in Tekken 8 are revolutionary, and the characters look better than ever. Whether playing offline or online, Tekken 8 is an exceptional fighting game.", 5.0, 270, 788),
("A True Masterpiece", "Tekken 8 features flawless combat mechanics, a beautiful roster, and engaging multiplayer options. It's a must-have for anyone who loves the genre, offering depth and accessibility for all players.", 5.0, 270, 789),
("Tekken at Its Peak", "Tekken 8 takes what made previous entries great and refines it. The gameplay is fast-paced, and the character animations are top-notch. It's a game that keeps you coming back for more.", 5.0, 270, 790),
("An Epic Fighting Game", "Tekken 8 is a thrilling fighting game with impressive graphics, fantastic combat mechanics, and a wealth of content. Whether you're a newcomer or a veteran, there's something for everyone.", 5.0, 270, 791),
("The Pinnacle of Tekken", "Tekken 8 is the best version of Tekken yet. The combat is smooth, the visuals are gorgeous, and the roster of fighters is diverse. This game is an absolute must for any fighting game fan.", 5.0, 270, 792),
("Masterful Combat and Stunning Graphics", "Tekken 8 is a true masterpiece, with superb combat mechanics and amazing graphics. It's the best Tekken game in the franchise, with both solo and online play being incredibly fun and engaging.", 5.0, 270, 793),
("A Stunning Fighting Game", "Tekken 8 is a visual and mechanical triumph. The game feels great to play, and the characters are wonderfully designed. The new mechanics add layers of depth to the combat system, making every match exciting.", 5.0, 270, 794);

-- Recensioni per "Terraria" (GameID 35)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Endless Possibilities", "Terraria is a sandbox dream come true, offering endless exploration and creativity. The crafting and building systems are incredibly satisfying, and the procedurally generated worlds ensure that no two playthroughs are ever the same.", 5.0, 35, 795),
("A World of Adventure", "Terraria offers a world filled with opportunities for exploration, building, and combat. It's a game that can be played for hours, offering nearly infinite replayability. It's perfect for fans of sandbox games.", 5.0, 35, 796),
("A Perfect Sandbox Game", "Terraria combines exploration, building, and combat into a delightful mix. The world is vast, and the freedom it offers is unparalleled. Every playthrough is different, and there's always something new to discover.", 5.0, 35, 797),
("Unmatched Creativity", "With its deep crafting system and endless world, Terraria lets you unleash your creativity like no other game. The satisfaction of building your own world and conquering tough bosses makes it a must-play for sandbox game fans.", 5.0, 35, 798),
("The Ultimate Sandbox Experience", "Terraria gives you the freedom to build, explore, and conquer. The game constantly surprises you with its depth, and there are always new ways to approach your objectives. It's a masterpiece of the sandbox genre.", 5.0, 35, 799),
("A Game with No Limits", "Terraria offers virtually limitless gameplay, from crafting to exploration and combat. The procedurally generated world means no two sessions are the same, and the depth of the mechanics keeps you coming back for more.", 5.0, 35, 800),
("Incredibly Addictive", "Terraria is the perfect sandbox game that blends crafting, exploration, and combat into one amazing package. The world is vast and filled with surprises, making it easy to get lost for hours on end.", 5.0, 35, 801),
("A World to Build and Explore", "Terraria is a fantastic sandbox game where your creativity and exploration can thrive. The depth of the mechanics and the variety of things to do makes this one of the best games for players who love open-ended experiences.", 5.0, 35, 802),
("Endless Exploration and Fun", "There's so much to do in Terraria. Whether you're building your own world or exploring dungeons, there's always something exciting to do. The depth of the game ensures it never gets old, and the sense of progression is fantastic.", 5.0, 35, 803),
("An Amazing Adventure", "Terraria blends exploration, building, and combat into an unforgettable experience. The world is vast, and there's always something new to discover. It's the perfect sandbox game for players of all types.", 5.0, 35, 804);

-- Recensioni per "Tetris Effect" (GameID 271)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Beautiful Puzzle Experience", "Tetris Effect takes the classic Tetris formula and elevates it with stunning visuals and a mesmerizing soundtrack. The gameplay is addictive as ever, and the new modes add fresh twists to the classic.", 5.0, 271, 805),
("Tetris Like Never Before", "Tetris Effect reimagines the iconic puzzle game with beautiful visuals and a soothing soundtrack that makes every session feel like a new experience. It's a perfect combination of old and new.", 5.0, 271, 806),
("A Mesmerizing Experience", "Tetris Effect offers a unique twist on the classic Tetris gameplay with mesmerizing visuals and an incredible soundtrack. The experience is immersive, and the game remains incredibly addictive, just like the original.", 5.0, 271, 807),
("A Stunning Reinterpretation", "Tetris Effect is a breathtaking reimagining of the classic puzzle game. The visuals are stunning, and the soundtrack creates a truly immersive experience. It's a must-have for fans of Tetris and puzzle games alike.", 5.0, 271, 808),
("The Ultimate Tetris Experience", "Tetris Effect takes everything that's great about the classic game and adds a layer of beauty and immersion with stunning visuals and a calming soundtrack. It's the perfect version of Tetris for both new and old fans.", 5.0, 271, 809),
("Perfect for Relaxation and Focus", "Tetris Effect offers a relaxing and focused experience with its beautiful visuals and ambient soundtrack. It's a unique take on the classic Tetris gameplay, providing a meditative and enjoyable experience.", 5.0, 271, 810),
("A Puzzler's Dream", "Tetris Effect offers a soothing, mesmerizing experience that redefines what Tetris can be. The visuals are gorgeous, and the soundtrack creates an atmosphere that enhances the gameplay experience. It's a must-play for puzzle fans.", 5.0, 271, 811),
("An Artistic Puzzle Game", "Tetris Effect is an artistic take on the iconic game, combining beautiful visuals, great music, and the classic puzzle mechanics that make Tetris so addictive. A must-try for any puzzle game enthusiast.", 5.0, 271, 812),
("Immersive and Beautiful", "Tetris Effect takes the puzzle game to new heights. The visual design and soundtrack are immersive, and the gameplay remains as addictive as ever. It's a fresh take on a classic game that still retains the magic.", 5.0, 271, 813),
("A Beautiful Experience", "Tetris Effect is not just a game, it's an experience. The visuals, soundtrack, and gameplay come together in a way that feels both relaxing and exhilarating. It's the best way to enjoy Tetris.", 5.0, 271, 814);


-- Recensioni per "Tetris Effect: Connected" (GameID 158)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Gorgeous Co-op Experience", "Tetris Effect: Connected takes the classic Tetris gameplay and introduces an immersive cooperative multiplayer mode. The visuals and soundtrack are even better than the original, creating an emotional and connected experience.", 5.0, 158, 815),
("Tetris Evolved", "Tetris Effect: Connected expands on the original with beautiful graphics, a soothing soundtrack, and fantastic co-op gameplay. It's an excellent addition to the Tetris franchise that makes multiplayer even more enjoyable.", 5.0, 158, 816),
("Connected in Every Way", "The addition of multiplayer makes Tetris Effect: Connected a must-play. The visuals are stunning, the music is immersive, and playing together with friends elevates the experience to new heights.", 5.0, 158, 817),
("A Stunning Rework", "Tetris Effect: Connected reworks the original formula with new features like multiplayer and even more spectacular visuals. The co-op mode is a game changer, making this the best version of Tetris.", 5.0, 158, 818),
("Perfect for Social Play", "Tetris Effect: Connected offers the same captivating visuals and soundtrack as the original, but with the added bonus of multiplayer. It's a perfect way to enjoy Tetris with friends.", 5.0, 158, 819),
("A Masterpiece of Multiplayer", "Tetris Effect: Connected takes everything great about the original and adds a brilliant multiplayer component. The combination of cooperative gameplay and stunning design makes this version stand out.", 5.0, 158, 820),
("Even Better Together", "The multiplayer mode in Tetris Effect: Connected is absolutely fantastic. It's the perfect way to experience the magic of Tetris with friends while enjoying the hypnotic visuals and calming music.", 5.0, 158, 821),
("Connected Experience", "Tetris Effect: Connected enhances the original with vibrant visuals, an incredible soundtrack, and new co-op multiplayer modes that make the game feel even more immersive and fun.", 5.0, 158, 822),
("The Ultimate Tetris Experience", "Tetris Effect: Connected is the definitive version of Tetris. The graphics are breathtaking, the music is mesmerizing, and the cooperative gameplay makes it an unforgettable experience for Tetris fans.", 5.0, 158, 823),
("A True Evolution of Tetris", "Tetris Effect: Connected brings a fresh twist to the classic puzzle game with multiplayer, gorgeous visuals, and a stunning soundtrack. It's a game that appeals to both solo players and groups alike.", 5.0, 158, 824);

-- Recensioni per "The Banner Saga" (GameID 65)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Beautiful and Epic Tale", "The Banner Saga is a stunningly beautiful tactical RPG with an unforgettable story. The hand-drawn art style and emotional narrative make it an immersive experience that will stay with you long after finishing the game.", 5.0, 65, 825),
("Epic Storytelling", "The Banner Saga blends excellent tactical combat with a deeply engaging story. The choices you make throughout the game feel meaningful, and the world-building is top-notch. The art style and music elevate the experience.", 5.0, 65, 826),
("An Epic Journey", "The Banner Saga offers an emotional journey with stunning visuals and a story that hooks you from the start. The tactical combat is challenging, and the game's choices have real consequences.", 5.0, 65, 827),
("A Masterpiece of Art and Story", "The Banner Saga is a visually gorgeous RPG that combines strategic battles with a gripping story. The choices you make throughout the game feel impactful, and the art style is nothing short of breathtaking.", 5.0, 65, 828),
("Tactical and Beautiful", "The Banner Saga's blend of tactical combat and narrative depth is what makes it stand out. The art is stunning, and the story is captivating. It's a game that you'll remember long after you finish it.", 5.0, 65, 829),
("A Deep and Rewarding Experience", "With strategic gameplay and meaningful narrative choices, The Banner Saga delivers a deeply satisfying experience. The world is rich with lore, and the hand-drawn art style makes it a visual treat.", 5.0, 65, 830),
("Stunning and Engaging", "The Banner Saga excels in its deep storytelling and tactical gameplay. The art style is beautiful, and the choices you make throughout the game feel significant, making it an unforgettable RPG experience.", 5.0, 65, 831),
("A Game with Heart", "The Banner Saga captivates with its beautiful art, gripping narrative, and challenging tactical gameplay. Every decision matters, and the emotional weight of the story makes this a standout RPG.", 5.0, 65, 832),
("Epic and Unforgettable", "The Banner Saga combines tactical gameplay with a rich, emotional narrative. The art style is visually striking, and the story keeps you invested from beginning to end. It's a must-play for RPG fans.", 5.0, 65, 833),
("One of the Best RPGs", "The Banner Saga offers a perfect blend of strategy and storytelling. The visuals are breathtaking, and the choices you make feel meaningful. It's one of the best RPGs I've played in recent years.", 5.0, 65, 834);

-- Recensioni per "The Binding of Isaac: Rebirth" (GameID 104)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Dark, Addictive Roguelike", "The Binding of Isaac: Rebirth offers a deeply addictive and dark roguelike experience. The random levels and power-ups ensure that every playthrough is different, and the challenge is ever-present. A must-play for roguelike fans.", 5.0, 104, 835),
("Challenging and Rewarding", "The Binding of Isaac: Rebirth is a roguelike that keeps you coming back for more. The gameplay is fun, the difficulty is brutal, and the variety of power-ups and enemies makes each run exciting. It's one of the best in the genre.", 5.0, 104, 836),
("A Fantastic Roguelike", "With its dark, twisted theme and highly addictive gameplay, The Binding of Isaac: Rebirth is a top-tier roguelike. The randomness keeps the gameplay fresh, and the challenge is both tough and rewarding.", 5.0, 104, 837),
("The Ultimate Roguelike", "The Binding of Isaac: Rebirth is a brutal and rewarding experience. The variety of items and enemies makes each run different, and the challenge keeps you coming back for more. It's a standout in the roguelike genre.", 5.0, 104, 838),
("A Game with Endless Depth", "The Binding of Isaac: Rebirth is a roguelike masterpiece. The game offers an incredible amount of content, and the randomized levels and power-ups ensure that no two playthroughs are alike. The difficulty curve is steep but fair.", 5.0, 104, 839),
("Addictively Fun", "The Binding of Isaac: Rebirth is one of the most addictive roguelikes out there. The gameplay is tough but rewarding, and the variety of items and enemies ensures that each run is unique.", 5.0, 104, 840),
("A Roguelike Done Right", "With its tight gameplay mechanics and dark humor, The Binding of Isaac: Rebirth is a roguelike that gets everything right. It's challenging, fun, and has a ton of replay value.", 5.0, 104, 841),
("Endless Replayability", "The Binding of Isaac: Rebirth offers a near-infinite number of combinations with its random item drops and enemies. It's a roguelike that's constantly fresh, and the challenge is always there to keep you coming back.", 5.0, 104, 842),
("Perfect for Roguelike Fans", "The Binding of Isaac: Rebirth is a fantastic roguelike with a dark, twisted aesthetic and a satisfying difficulty curve. Each run is different, and the challenge keeps you hooked. Highly recommend it!", 5.0, 104, 843),
("A Dark Gem", "The Binding of Isaac: Rebirth is a brutal yet rewarding roguelike. The variety of items and enemies keeps each playthrough fresh, and the difficulty is always challenging. It's one of the best roguelikes I've played.", 5.0, 104, 844);


-- Recensioni per "The Callisto Protocol" (GameID 175)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Horror Masterpiece", "The Callisto Protocol is a truly terrifying survival horror experience. The atmosphere is bleak, the combat is intense, and the monsters are deeply unsettling. It's a must-play for fans of the genre.", 5.0, 175, 845),
("A Fearful Journey", "This game provides an intense survival horror experience with fantastic graphics and a chilling atmosphere. The combat is brutal, and the narrative is captivating. It's not for the faint of heart.", 5.0, 175, 846),
("Gripping Horror", "The Callisto Protocol has everything a horror fan could want: an atmospheric setting, intense combat, and disturbing enemies. The pacing and storyline keep you on edge throughout, making it an unforgettable horror experience.", 5.0, 175, 847),
("Intense and Terrifying", "From start to finish, The Callisto Protocol keeps you on the edge of your seat. The dark atmosphere and heart-pounding gameplay make it a true survival horror masterpiece. The combat can be brutal, but it's all part of the terrifying experience.", 5.0, 175, 848),
("Survival Horror Perfection", "The Callisto Protocol delivers a dark and horrifying experience with incredible visuals and a terrifying atmosphere. The combat is tense and challenging, and the story keeps you hooked. Highly recommended for horror fans.", 5.0, 175, 849),
("A Horror Journey Like No Other", "This game is a terrifying ride from start to finish. The setting is perfectly crafted, and the combat is brutal but satisfying. The enemies are disturbing, and the story is gripping. It's a must-play for horror lovers.", 5.0, 175, 850),
("A Must-Play Horror Game", "The Callisto Protocol offers a terrifying and immersive experience with incredible graphics and tense combat. The atmosphere is dark and oppressive, and the storyline keeps you engaged from start to finish.", 5.0, 175, 851),
("Uneasy and Tense", "With its deeply unsettling atmosphere and intense gameplay, The Callisto Protocol creates a nerve-wracking experience. Every encounter feels dangerous, and the visuals are incredible. One of the best horror games I've played.", 5.0, 175, 852),
("Chilling and Brutal", "The Callisto Protocol is a survival horror experience that's both chilling and brutal. The enemies are terrifying, and the story is compelling. The atmosphere and combat mechanics make it a standout horror game.", 5.0, 175, 853),
("Pure Horror", "If you're a fan of survival horror, The Callisto Protocol is a must-play. The game does an excellent job at creating a terrifying atmosphere, and the combat is unforgiving and intense. It's a fantastic addition to the genre.", 5.0, 175, 854);

-- Recensioni per "The Chant" (GameID 272)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Haunting Experience", "The Chant blends survival horror with cosmic horror to create a truly eerie experience. The environment is unsettling, and the narrative is intriguing. It's a game that keeps you on edge, wondering what's coming next.", 5.0, 272, 855),
("Psychological Horror at Its Best", "The Chant has an eerie atmosphere and a deep, psychological horror experience. The way it plays with your mind and builds tension is amazing. The game does a great job at keeping you uncomfortable throughout.", 5.0, 272, 856),
("Mind-Bending Horror", "With its mysterious setting and psychological horror elements, The Chant is an unsettling journey into the unknown. The puzzles and story build a feeling of dread that permeates every part of the game.", 5.0, 272, 857),
("Unnerving and Beautiful", "The Chant offers a terrifying experience with its blend of psychological and cosmic horror. The atmosphere is beautiful yet disturbing, and the story draws you in. It's a game that stays with you long after you've finished.", 5.0, 272, 858),
("Atmospheric and Disturbing", "The Chant builds a unique and unnerving atmosphere that makes it stand out. The psychological horror elements are especially strong, and the visuals enhance the eerie experience.", 5.0, 272, 859),
("A Mind-Twisting Horror Game", "The Chant creates a unique mix of psychological and cosmic horror. The narrative is captivating, and the atmosphere is creepy, making it a great choice for fans of unsettling horror games.", 5.0, 272, 860),
("A Terrifying Journey", "The Chant is an immersive horror experience with deep psychological elements and unsettling visuals. The gameplay keeps you on edge, and the story builds a chilling sense of dread.", 5.0, 272, 861),
("Disturbing and Intense", "The Chant creates an atmosphere of discomfort and fear with its unique blend of horror. The unsettling environment and psychological aspects keep you engaged, and it's a game that you won't forget easily.", 5.0, 272, 862),
("Fascinating Horror", "The Chant offers a fresh take on psychological horror, with a deep and disturbing storyline. The world-building and visuals are outstanding, and it's an experience you don't want to miss.", 5.0, 272, 863),
("A Chilling Experience", "The Chant combines psychological horror with an eerie atmosphere to deliver a terrifying experience. The story is fascinating and full of twists, making it a standout in the horror genre.", 5.0, 272, 864);

-- Recensioni per "The Division" (GameID 273)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Tactical Masterpiece", "The Division offers a deep and rewarding tactical gameplay experience. The open world is beautifully crafted, and the combat is intense. The story is engaging, and the multiplayer adds a lot of replayability.", 5.0, 273, 865),
("A Realistic Shooter", "The Division brings realistic gunplay and tactical mechanics into a beautifully detailed open world. The multiplayer is engaging, and the story keeps you invested throughout. It's one of the best tactical shooters out there.", 5.0, 273, 866),
("Immersive and Engaging", "The Division's combination of tactical gameplay, realistic shooting mechanics, and an engaging storyline make it a standout. The open world is a joy to explore, and the multiplayer keeps you coming back for more.", 5.0, 273, 867),
("Tactical Action at Its Best", "The Division delivers an excellent tactical shooter experience. The world is immersive, the combat is satisfying, and the multiplayer adds endless replay value. The story is strong, and the game overall is an intense thrill ride.", 5.0, 273, 868),
("An Addictive Shooter", "The Division is an addictive online shooter with a detailed open world, challenging AI, and engaging multiplayer modes. The tactical gameplay is deep, and the game keeps you coming back for more.", 5.0, 273, 869),
("A Brilliant Tactical Shooter", "The Division's mix of tactical combat, a gripping narrative, and immersive open world make it one of the best shooters I've played in recent years. The multiplayer is especially fun, offering countless hours of playtime.", 5.0, 273, 870),
("Realistic and Exciting", "The Division is a superb tactical shooter with fantastic gameplay and stunning graphics. The multiplayer modes keep things exciting, and the open world is massive and full of detail. It's a shooter that's hard to put down.", 5.0, 273, 871),
("A Tactical World", "The Division combines the thrill of tactical combat with an engaging open world. The multiplayer options offer plenty of replayability, and the game feels immersive and real. It's a great choice for fans of shooters and tactical games.", 5.0, 273, 872),
("Exciting and Challenging", "The Division provides a thrilling and tactical experience in an expansive open world. The game's multiplayer adds depth, and the story keeps things interesting from start to finish.", 5.0, 273, 873),
("A Fun Shooter with Depth", "The Division blends tactical combat with an immersive open world, creating a fun yet challenging experience. The multiplayer keeps the game fresh, and the story is engaging from start to finish.", 5.0, 273, 874);


-- Recensioni per "The Elder Scrolls V: Skyrim" (GameID 38)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Timeless Classic", "Skyrim is a masterpiece that has stood the test of time. Its open world is vast and filled with secrets, and the story is compelling. The freedom it offers in exploration and gameplay is unparalleled.", 5.0, 38, 875),
("Immersive Fantasy", "Skyrim offers an epic journey through a world filled with magic, dragons, and adventure. The open-world design is breathtaking, and the RPG elements are deep. A must-play for any fantasy fan.", 5.0, 38, 876),
("A World of Wonders", "From its detailed landscapes to its engaging storyline, Skyrim is a world that pulls you in and doesn't let go. The sheer amount of content and freedom of choice is something few games can match.", 5.0, 38, 877),
("Endless Adventures", "Skyrim is a game that feels endless. Every corner of its vast world is filled with something to explore, and its RPG mechanics offer deep customization. It's a game you can get lost in for hours.", 5.0, 38, 878),
("Epic and Timeless", "Skyrim is an epic RPG that offers incredible freedom and a truly immersive experience. Its open world is massive, the quests are varied, and the combat is satisfying. A classic in every sense of the word.", 5.0, 38, 879),
("An Unforgettable Journey", "Skyrim's world is incredibly rich, and the game offers an unforgettable journey filled with dragons, magic, and countless quests. The game has stood the test of time, and it's easy to see why it's still loved by so many.", 5.0, 38, 880),
("Masterpiece RPG", "Skyrim is one of the best RPGs ever created. Its world is stunning, the combat is fun, and the story is full of twists and turns. Every playthrough feels different, and the game never gets old.", 5.0, 38, 881),
("An Immersive World", "The beauty of Skyrim lies in its open world. Every region has its own unique charm, and the game's rich lore and depth make it a truly immersive experience. A must-play for RPG fans.", 5.0, 38, 882),
("Timeless Adventure", "Skyrim offers a vast world full of storylines and rich lore. The game allows you to immerse yourself in a beautiful fantasy world, and the freedom it offers in terms of exploration is unmatched.", 5.0, 38, 883),
("Endlessly Replayable", "Skyrim offers so much to explore and experience that it's almost impossible to run out of content. The game's replay value is incredible, and the mods only add to the already massive experience.", 5.0, 38, 884);

-- Recensioni per "The Evil Within 2" (GameID 144)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Terrifying Sequel", "The Evil Within 2 improves upon its predecessor in every way. The survival horror is intense, and the story is gripping. The game's atmosphere is eerie and disturbing, making for an unforgettable experience.", 5.0, 144, 885),
("Psychological Horror Perfection", "The Evil Within 2 blends psychological horror with action in a way that's terrifying and thrilling. The game keeps you on edge the entire time, and the storyline is hauntingly good.", 5.0, 144, 886),
("A Gripping Nightmare", "The Evil Within 2 offers a chilling experience with an engaging story and plenty of tension-filled moments. The gameplay is immersive, and the survival horror elements are top-notch.", 5.0, 144, 887),
("Atmospheric Horror at Its Best", "With its disturbing visuals and psychological horror elements, The Evil Within 2 is an atmospheric masterpiece. The gameplay is intense, and the story keeps you hooked until the very end.", 5.0, 144, 888),
("Master of Horror", "The Evil Within 2 is a survival horror game that gets everything right. The story is compelling, the gameplay is intense, and the atmosphere is terrifying. This is a must-play for any fan of the genre.", 5.0, 144, 889),
("Unsettling and Terrifying", "This game is a perfect example of how psychological horror should be done. The tension is palpable, and the story keeps you invested throughout. The Evil Within 2 is not for the faint of heart.", 5.0, 144, 890),
("Horrific and Thrilling", "The Evil Within 2 brings a gripping story and terrifying gameplay. The horror elements are unnerving, and the action keeps things exciting. It's a thrilling ride that never lets up.", 5.0, 144, 891),
("Twisted and Tense", "This game delivers a great mix of psychological horror and action. The atmosphere is deeply unsettling, and the story is dark and gripping. The Evil Within 2 is a fantastic survival horror experience.", 5.0, 144, 892),
("Dark and Beautifully Crafted", "The Evil Within 2 is a dark, atmospheric horror game with incredible attention to detail. The story is twisted and deeply engaging, and the gameplay is unsettling but satisfying.", 5.0, 144, 893),
("An Intense Journey", "The Evil Within 2 is a haunting journey full of disturbing imagery and psychological horror. The pacing is perfect, and the action is just intense enough to keep you on the edge of your seat.", 5.0, 144, 894);

-- Recensioni per "The Forest" (GameID 274)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Surreal Survival Horror", "The Forest offers a truly unique survival horror experience. The open world is rich with resources and dangers, and the story keeps you intrigued. The game is terrifying, especially when you encounter the mutated creatures in the forest.", 5.0, 274, 895),
("A Thrilling Survival Adventure", "The Forest mixes survival mechanics with horror in a perfect way. The creatures lurking in the forest are terrifying, and the sense of isolation makes the game even scarier. It's a must-play for horror and survival fans.", 5.0, 274, 896),
("Terrifying and Addictive", "This game keeps you on edge with its survival mechanics and the ever-present threat of monstrous enemies. The forest is vast, and it's up to you to survive and uncover its secrets. A thrilling and terrifying experience.", 5.0, 274, 897),
("Survival Horror at Its Finest", "The Forest is a survival horror game that knows how to make you feel fear. The creatures are terrifying, and the game does an excellent job of balancing survival elements with horror. It's a truly unique experience.", 5.0, 274, 898),
("Exploration Meets Horror", "The Forest combines exploration and horror in a way that makes for a gripping experience. The open-world setting is vast, and the story slowly unravels as you survive in this twisted forest. A perfect blend of both genres.", 5.0, 274, 899),
("Survival with a Terrifying Twist", "The Forest is a survival game that doesn't hold back. The mutated enemies lurking in the shadows keep you on edge, and the crafting system makes survival feel like a challenge. The horror aspects make it truly unforgettable.", 5.0, 274, 900),
("A Deep and Disturbing World", "The Forest offers a deep and eerie experience. The open world is rich with resources, but the real challenge lies in surviving the horrors that lurk within. The game is as unsettling as it is fun.", 5.0, 274, 901),
("Terror in the Wilderness", "The Forest offers a unique twist on survival horror. As you scavenge for resources and build shelters, you're also constantly on the lookout for the terrifying creatures that roam the forest. It's an exhilarating and terrifying experience.", 5.0, 274, 902),
("Creepy and Addictive", "The Forest is an addictive survival game with a horrifying twist. The creatures in the game are terrifying, and the sense of isolation keeps you on edge the entire time. It's a must-play for fans of horror and survival games.", 5.0, 274, 903),
("A Must-Play for Horror Fans", "The Forest combines survival mechanics with intense horror. The creatures are terrifying, and the game does an excellent job of keeping you on edge. The world is immersive, and the horror is truly unsettling.", 5.0, 274, 904);


-- Recensioni per "The Last of Us Part 1" (GameID 278)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Masterpiece of Storytelling", "The Last of Us Part 1 is an emotional rollercoaster. The game's narrative is powerful and unforgettable. The characters are deep, and the post-apocalyptic world feels incredibly real.", 5.0, 278, 905),
("Unparalleled Emotional Depth", "The Last of Us Part 1 excels in its emotional depth and storytelling. The bond between Joel and Ellie is heart-wrenching, and the world is beautifully detailed. It's one of the best games ever made.", 5.0, 278, 906),
("A True Work of Art", "The Last of Us Part 1 combines exceptional storytelling with fantastic gameplay mechanics. The atmosphere is tense, and the emotional impact of the game is immense. It's a must-play for any gamer.", 5.0, 278, 907),
("Incredible Worldbuilding", "The Last of Us Part 1 does an incredible job of world-building. The world feels lived-in, and the story is heart-breaking and hopeful at the same time. The game is emotional, gripping, and beautifully crafted.", 5.0, 278, 908),
("A Journey of Survival", "This game is about more than just survival. The narrative, the character development, and the interactions between Joel and Ellie are incredibly powerful. It's an emotional journey that stays with you long after the credits roll.", 5.0, 278, 909),
("Unforgettable Experience", "The Last of Us Part 1 is an unforgettable experience. The emotional rollercoaster, intense action, and superb voice acting make this a game that truly stands out. A masterpiece in the world of gaming.", 5.0, 278, 910),
("Heart-wrenching and Beautiful", "The Last of Us Part 1 offers a heart-wrenching story of survival, loss, and hope. The bond between Joel and Ellie is at the core of the game, and it makes every moment feel meaningful.", 5.0, 278, 911),
("An Emotional Journey", "The Last of Us Part 1 is one of the most emotional journeys I've ever experienced in gaming. The world is dark and gritty, and the story is powerful. It's a truly unforgettable game.", 5.0, 278, 912),
("Brilliant Storytelling", "The Last of Us Part 1 is a game that blends action, survival, and narrative in a way few others can. The game is tense, emotional, and beautifully written. It's a must-play for any fan of story-driven games.", 5.0, 278, 913),
("A Timeless Classic", "The Last of Us Part 1 has all the right elements: a compelling story, strong characters, and intense gameplay. It's a masterpiece that has set a new bar for narrative-driven games.", 5.0, 278, 914);

-- Recensioni per "The Last of Us Part II" (GameID 11)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Bold Sequel", "The Last of Us Part II is a daring sequel that pushes the boundaries of storytelling in games. It's intense, emotional, and filled with morally complex moments that will leave you questioning your choices.", 5.0, 11, 915),
("Emotional Rollercoaster", "The Last of Us Part II is a true emotional rollercoaster. It's an intense, heartbreaking, and incredibly well-written game that takes risks with its narrative and characters. A masterpiece.", 5.0, 11, 916),
("A Dark and Beautiful Story", "This game is a perfect example of how video games can tell profound stories. The Last of Us Part II dives deep into themes of vengeance, grief, and redemption, all while delivering heart-pounding gameplay.", 5.0, 11, 917),
("A Journey of Pain and Redemption", "The Last of Us Part II is a game about pain, revenge, and the cost of survival. The game challenges players emotionally and morally, making it a powerful experience. The narrative and character development are second to none.", 5.0, 11, 918),
("Intense and Thought-Provoking", "The Last of Us Part II is one of the most intense and thought-provoking games I've ever played. It's not just about the gameplay; the story will stick with you long after you finish the game.", 5.0, 11, 919),
("Bold and Beautiful", "The Last of Us Part II takes risks, and it pays off. The emotional weight of the story is heavy, and the gameplay is as intense as ever. It's an unforgettable journey that pushes the medium forward.", 5.0, 11, 920),
("A Powerful Sequel", "This game is as beautiful as it is heartbreaking. The narrative is gripping, and the gameplay is exhilarating. The Last of Us Part II is an emotional rollercoaster that raises the bar for video games.", 5.0, 11, 921),
("A Game That Challenges You", "The Last of Us Part II doesn't just tell a story; it challenges you. It makes you question your choices and the characters' motivations, all while providing gripping gameplay and stunning visuals.", 5.0, 11, 922),
("Masterful Storytelling", "The Last of Us Part II's storytelling is nothing short of masterful. The game dives deep into difficult topics, and the emotional impact is unparalleled. It's a gaming experience that will leave a lasting impression.", 5.0, 11, 923),
("A Sequel Worth the Wait", "The Last of Us Part II is a sequel that was worth every second of the wait. It's a story of survival, revenge, and redemption, and it challenges players in ways few games ever do. A true masterpiece.", 5.0, 11, 924);

-- Recensioni per "The Legend of Zelda: Breath of the Wild" (GameID 1)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Revolution in Open World Design", "Breath of the Wild redefines the open-world genre. Its freedom of exploration, the vast world to discover, and the sense of adventure are unmatched. A must-play for any fan of Zelda or adventure games.", 5.0, 1, 925),
("A Breath of Fresh Air", "The Legend of Zelda: Breath of the Wild brings something new and exciting to the series. The open-world design allows for so much exploration and experimentation. Every corner of the world has something unique to offer.", 5.0, 1, 926),
("An Open-World Masterpiece", "Breath of the Wild is an open-world masterpiece that changes the way we think about exploration in games. The world feels alive and constantly rewarding, and the puzzles are challenging but fair. It's a true work of art.", 5.0, 1, 927),
("Freedom Like Never Before", "Breath of the Wild offers an unprecedented level of freedom. Whether you're climbing mountains, solving puzzles, or discovering new locations, the game lets you approach everything in your own way. A true innovation in gaming.", 5.0, 1, 928),
("Epic Adventure Awaits", "Breath of the Wild is an epic adventure that invites players to explore every inch of its vast world. The gameplay is fluid, and the combat is satisfying. The game is constantly rewarding, whether you're exploring or completing quests.", 5.0, 1, 929),
("A New Standard for Zelda", "Breath of the Wild sets a new standard for the Zelda series. The open-world mechanics are revolutionary, and the game is filled with hidden secrets and challenges. It's an unforgettable experience from start to finish.", 5.0, 1, 930),
("Innovative and Beautiful", "Breath of the Wild is a stunning reinvention of the Zelda formula. The world is massive, and the puzzles are challenging but rewarding. The freedom to explore and solve problems your way is what makes this game stand out.", 5.0, 1, 931),
("A World of Discovery", "Breath of the Wild's world is filled with discoveries, and the sense of wonder it evokes is unparalleled. The game lets you explore, experiment, and figure out things on your own, making it one of the best adventure games ever made.", 5.0, 1, 932),
("Endless Exploration", "Breath of the Wild is a game that keeps on giving. Its open-world design is vast and full of life, and there's always something new to discover. It's the perfect balance of freedom, adventure, and discovery.", 5.0, 1, 933),
("Masterpiece of Exploration", "Breath of the Wild revolutionizes open-world games. The exploration is unrivaled, the combat is exciting, and the puzzles are clever. It's the most engaging and rewarding adventure I've had in years.", 5.0, 1, 934);


-- Recensioni per "The Legend of Zelda: Tears of the Kingdom" (GameID 37)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Epic Continuation", "Tears of the Kingdom takes everything great about its predecessor and expands it into an even grander experience. The story, puzzles, and world-building are top-notch. An essential Zelda game.", 5.0, 37, 935),
("A Masterful Sequel", "This game takes the series to new heights. The mechanics are refined, the world is more expansive, and the storyline deepens the Zelda lore in surprising ways. It's a must-play for any Zelda fan.", 5.0, 37, 936),
("Innovation at its Finest", "Tears of the Kingdom introduces brilliant new mechanics that elevate the gameplay and exploration. The puzzles are more intricate, the combat is more satisfying, and the world feels even more alive.", 5.0, 37, 937),
("Unparalleled Adventure", "Tears of the Kingdom offers one of the most expansive and rewarding adventures in recent gaming history. It's everything I loved about Breath of the Wild, but bigger and better. Simply incredible.", 5.0, 37, 938),
("A Truly Immersive Experience", "This game is a work of art. The exploration is endless, the puzzles are incredibly well-designed, and the story is full of surprises. Tears of the Kingdom has raised the bar for open-world games.", 5.0, 37, 939),
("A Journey Worth Taking", "From the beautifully crafted world to the deep lore and puzzle mechanics, this game is a masterpiece. It's an unforgettable experience that will keep you coming back for more.", 5.0, 37, 940),
("Tears of Genius", "Tears of the Kingdom is a genius evolution of the series. The world feels even more alive, and the variety in puzzles and challenges is incredible. It's the perfect balance of challenge and discovery.", 5.0, 37, 941),
("A Stunning Sequel", "Tears of the Kingdom is a stunning sequel that improves upon everything that made Breath of the Wild great. The world is rich with detail, and the gameplay is as captivating as ever.", 5.0, 37, 942),
("A True Zelda Masterpiece", "Tears of the Kingdom captures the essence of Zelda in a truly innovative way. The game is massive, the story is gripping, and every moment of gameplay feels rewarding. A true masterpiece for any fan of the series.", 5.0, 37, 943),
("The Ultimate Zelda Experience", "Tears of the Kingdom is the ultimate Zelda game. It refines and builds on everything from the previous title, offering an even more immersive and rewarding experience. You won't want to put it down.", 5.0, 37, 944);

-- Recensioni per "The Outer Worlds" (GameID 45)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Sci-Fi Gem", "The Outer Worlds combines clever writing, solid RPG mechanics, and a fantastic setting to create one of the best RPG experiences in recent years. The choices are meaningful, and the world is rich with detail.", 5.0, 45, 945),
("A Fresh Take on RPGs", "This game offers a fresh and exciting take on the RPG genre. The humor, world-building, and character interactions are standout elements that keep the game fun and engaging from start to finish.", 5.0, 45, 946),
("An Engaging Adventure", "The Outer Worlds is a highly engaging and well-designed RPG. The world feels alive, the combat is fun, and the story is filled with interesting twists and turns. A must-play for RPG fans.", 5.0, 45, 947),
("A Perfect Blend of Humor and Seriousness", "The Outer Worlds strikes a perfect balance between humor and serious storytelling. The game offers a unique universe filled with quirky characters and deep choices that impact the story.", 5.0, 45, 948),
("An RPG with Heart", "This game combines solid RPG mechanics with a narrative-driven experience that feels personal and meaningful. The Outer Worlds is an enjoyable and thoughtful experience that's hard to put down.", 5.0, 45, 949),
("A Brilliant RPG", "The Outer Worlds is one of the best RPGs in recent years. Its characters, setting, and branching narratives make it a standout in the genre. It's a game that keeps you thinking long after you've finished.", 5.0, 45, 950),
("Sci-Fi Perfection", "The Outer Worlds offers a sci-fi universe that's both expansive and filled with character. The game's humor and charm keep it light, while the moral choices and consequences give it real depth.", 5.0, 45, 951),
("A Journey Through Space and Choice", "The Outer Worlds offers a fantastic mix of humor, space exploration, and meaningful choice. Every decision you make impacts the story, and the world is rich with interesting characters and settings.", 5.0, 45, 952),
("Fantastic Writing and Gameplay", "The Outer Worlds excels in both writing and gameplay. The narrative is sharp, the dialogue is witty, and the choices are genuinely impactful. It's a must-play for RPG lovers.", 5.0, 45, 953),
("Unique and Fun", "This game is a unique blend of great writing, humor, and choice-driven gameplay. It's a breath of fresh air in the RPG genre, and I had a blast playing it.", 5.0, 45, 954);

-- Recensioni per "The Quarry" (GameID 275)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Horror Masterpiece", "The Quarry delivers a tense, thrilling experience that keeps you on the edge of your seat. The narrative is gripping, and the character choices add a personal touch to the horror genre.", 5.0, 275, 955),
("Perfect for Horror Fans", "If you love horror games, The Quarry is a must-play. It's a mix of supernatural and psychological terror with a branching narrative that makes each playthrough unique. The atmosphere is incredible.", 5.0, 275, 956),
("Intense and Suspenseful", "The Quarry is a game that keeps you on edge. The suspense is constant, and the story twists and turns as you make decisions that affect the characters' fates. It's an unforgettable horror experience.", 5.0, 275, 957),
("Horror at its Finest", "The Quarry is a fantastic example of horror done right in games. The choices matter, the atmosphere is intense, and the characters feel real. It's a game that makes you think and feel as you play.", 5.0, 275, 958),
("A Gripping Horror Experience", "The Quarry is a gripping horror game that masterfully blends narrative choices with thrilling gameplay. The characters are well-developed, and the story keeps you hooked from beginning to end.", 5.0, 275, 959),
("Creepy and Fun", "The Quarry is a creepy, fun, and suspenseful game that will keep you on the edge of your seat. The decision-making aspect is what really sets it apart, making each playthrough feel fresh and intense.", 5.0, 275, 960),
("Thrilling and Full of Twists", "The Quarry offers an experience filled with shocking twists and turns. The tension is palpable throughout, and the choices you make can lead to vastly different outcomes. A thrilling game from start to finish.", 5.0, 275, 961),
("The Ultimate Horror Game", "The Quarry delivers an unforgettable horror experience. The decision-making mechanics are brilliant, and the fear is constant. This is a game that horror fans will absolutely love.", 5.0, 275, 962),
("Perfect Horror for the Modern Gamer", "The Quarry blends the horror genre with modern storytelling techniques. The game is engaging, filled with suspense, and full of surprises. A fantastic addition to any horror enthusiast's library.", 5.0, 275, 963),
("A Must-Play Horror Game", "The Quarry is one of the best horror games I've played in a long time. It's a combination of great writing, tense atmosphere, and meaningful choices. It's an experience that horror fans should not miss.", 5.0, 275, 964);


-- Recensioni per "Titanfall" (GameID 276)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Thrilling Shooter", "Titanfall delivers a fast-paced, action-packed experience that revolutionizes movement in first-person shooters. The use of parkour and mechs makes for an exciting and unique combat system.", 5.0, 276, 965),
("Innovative and Fun", "Titanfall takes a fresh approach to first-person shooters with its dynamic movement and mech gameplay. It's a fast, fun, and exciting game that sets itself apart from the competition.", 5.0, 276, 966),
("Great Gameplay, Great Mechs", "The gameplay in Titanfall is unmatched. The fluid movement and ability to hop into giant mechs adds a layer of excitement to the shooter genre. Definitely worth playing for fans of fast-paced combat.", 5.0, 276, 967),
("Fast and Furious", "Titanfall is a blast to play. The game's fast movement and unique mech combat system make it a standout. It's a fast and furious experience that you'll enjoy every second of.", 5.0, 276, 968),
("Intense and Addictive", "Titanfall is intense and addictive. The fast-paced action and dynamic movement make it stand out in the crowded FPS market. The mechs are an absolute blast to control, adding a unique twist.", 5.0, 276, 969),
("Fresh and Fun FPS", "Titanfall brings something fresh to the FPS genre. The fast-paced combat, wall-running, and mechs make for a thrilling and enjoyable experience that's hard to put down.", 5.0, 276, 970),
("A New Breed of Shooter", "Titanfall is a new breed of first-person shooter. Its unique blend of fast movement and mech combat makes it stand out from other FPS games. The mechanics are smooth and fun, offering a great shooter experience.", 5.0, 276, 971),
("Exciting and Unique", "Titanfall is an exciting and unique shooter. The movement system and inclusion of giant mechs makes it an engaging and fresh experience for anyone who enjoys high-speed combat and fast action.", 5.0, 276, 972),
("A Must-Play for FPS Fans", "Titanfall is a must-play for any FPS fan. The gameplay is fast, the movement mechanics are fluid, and the mech combat is a fun addition that changes the dynamic of traditional shooters.", 5.0, 276, 973),
("A Shooter Like No Other", "Titanfall takes traditional FPS mechanics and flips them on their head with innovative movement and combat mechanics. The inclusion of mechs only adds to the thrill of the game. Highly recommended.", 5.0, 276, 974);

-- Recensioni per "Titanfall 2" (GameID 277)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An FPS Masterpiece", "Titanfall 2 improves on the already excellent formula of the first game with a deeper campaign and refined multiplayer mechanics. The single-player story is a standout, offering an emotional and thrilling experience.", 5.0, 277, 975),
("A Perfect Sequel", "Titanfall 2 is the perfect sequel. The campaign is well-crafted and emotional, and the multiplayer offers even more excitement. The game has great pacing and an immersive experience throughout.", 5.0, 277, 976),
("Outstanding Campaign", "Titanfall 2's campaign is one of the best in the FPS genre. It's engaging, emotional, and full of action. The story is excellent, and the gameplay is smooth and exciting from start to finish.", 5.0, 277, 977),
("The Complete Package", "Titanfall 2 takes everything great about the original and adds a fantastic single-player campaign and more refined multiplayer mechanics. The pacing is perfect, and the mech combat is as fun as ever.", 5.0, 277, 978),
("A Masterclass in FPS Design", "Titanfall 2 is a masterclass in first-person shooter design. The campaign is fantastic, with unique mechanics and an emotionally engaging story. The multiplayer is just as exciting and refined.", 5.0, 277, 979),
("A Step Above", "Titanfall 2 improves on its predecessor in every way. The campaign is amazing, the story is emotional, and the multiplayer is fast and fun. It's one of the best FPS games I've ever played.", 5.0, 277, 980),
("An Incredible Journey", "Titanfall 2's campaign takes you on an incredible journey full of heart-pounding moments, and the multiplayer keeps you hooked with its refined mechanics and fast-paced action. Highly recommended for any FPS fan.", 5.0, 277, 981),
("Revolutionary Shooter", "Titanfall 2 revolutionizes the FPS genre. The campaign offers an immersive and emotional story, while the multiplayer builds on the fast-paced mechanics that made the original so fun. A must-play for shooter fans.", 5.0, 277, 982),
("The Ultimate FPS Experience", "Titanfall 2 offers the ultimate FPS experience with its incredible single-player campaign and thrilling multiplayer. The mechanics are refined, and the story is unforgettable. It's a must-play game.", 5.0, 277, 983),
("FPS Perfection", "Titanfall 2 takes everything that worked in the first game and perfects it. The single-player is outstanding, with tight gameplay and an emotional story. The multiplayer is as fun as ever and just as fast-paced.", 5.0, 277, 984);

-- Recensioni per "Tomb Raider (2013)" (GameID 7)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Stunning Reboot", "Tomb Raider (2013) is a stunning reboot of the franchise, offering an emotional and gripping journey for Lara Croft. The gameplay is fluid, and the story is engaging from start to finish.", 5.0, 7, 985),
("A Perfect Rebirth for Lara Croft", "This reboot brings Lara Croft to life in a new and emotional way. The world is immersive, the gameplay is solid, and the story of Lara's transformation is compelling and well-paced.", 5.0, 7, 986),
("A Thrilling Adventure", "Tomb Raider (2013) delivers a thrilling adventure with fantastic combat and exploration. The game brings Lara Croft to life, offering a compelling narrative and fun gameplay that keeps you hooked.", 5.0, 7, 987),
("A New Beginning for Lara Croft", "This Tomb Raider reboot offers a fresh and exciting take on Lara Croft's origins. The game's narrative, mechanics, and graphics are all fantastic, making for an engaging adventure.", 5.0, 7, 988),
("Lara's Best Adventure Yet", "Tomb Raider (2013) is a reboot that reinvents Lara Croft for the modern age. The story is gripping, the world is immersive, and the gameplay is fun and rewarding. One of the best action-adventure games out there.", 5.0, 7, 989),
("An Unforgettable Experience", "Tomb Raider (2013) is an unforgettable adventure. The game mixes exploration, puzzle-solving, and combat seamlessly. Lara's journey from survivor to hero is a fantastic experience to witness.", 5.0, 7, 990),
("The Ultimate Tomb Raider", "This game is a perfect example of how to reboot a classic. The narrative is compelling, the graphics are stunning, and the gameplay is thrilling. Tomb Raider (2013) is a must-play for any fan of action-adventure games.", 5.0, 7, 991),
("A New Era for Lara Croft", "Tomb Raider (2013) marks the beginning of a new era for Lara Croft. The game is well-paced, with emotional depth and plenty of action. It's a fantastic journey that every gamer should experience.", 5.0, 7, 992),
("A Thrilling Rebirth", "Tomb Raider (2013) is a thrilling rebirth of Lara Croft. The combination of adventure, survival, and puzzle-solving is fantastic. The story is deep and emotional, and the game offers a great mix of gameplay styles.", 5.0, 7, 993),
("Lara Croft's Best Adventure", "Tomb Raider (2013) offers Lara Croft's best adventure yet. The story is gripping, the mechanics are solid, and the world is rich with detail. It's a perfect mix of action and adventure.", 5.0, 7, 994);


-- Recensioni per "Tony Hawk's Pro Skater 1+2" (GameID 86)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Perfect Remake", "Tony Hawk's Pro Skater 1+2 is the perfect remake of two classic games. The gameplay is as smooth and satisfying as ever, and the updated visuals and soundtrack bring a fresh new feel to these iconic games.", 5.0, 86, 995),
("Nostalgic and Fun", "Tony Hawk's Pro Skater 1+2 brings back all the nostalgia and fun of the original games, with updated graphics and controls. The levels are still as fun to skate through as they were back in the day, and the soundtrack is amazing!", 5.0, 86, 996),
("The Ultimate Skating Experience", "This remake is a love letter to fans of the original Tony Hawk games. The tight controls and thrilling tricks make it an incredibly fun experience. Whether you're a long-time fan or new to the series, it's an absolute blast.", 5.0, 86, 997),
("Perfect for Old and New Fans", "Tony Hawk's Pro Skater 1+2 is the perfect way to introduce new players to the series while also catering to long-time fans. The game is fast, fun, and full of tricks, with a fantastic soundtrack to back it all up.", 5.0, 86, 998),
("Skateboarding Bliss", "The remake of Tony Hawk's Pro Skater 1+2 is a skateboarding fan's dream. The game looks great, plays like a charm, and offers hours of fun as you attempt to master the tricks and complete challenges. Highly recommend!", 5.0, 86, 999),
("A Love Letter to Skateboarding", "Tony Hawk's Pro Skater 1+2 is a perfect recreation of two beloved classics. The game's controls are tight, the levels are as fun as ever, and the soundtrack is spot-on. It's a fantastic reminder of why these games were so loved.", 5.0, 86, 1000),
("Classic Skating Fun", "This remake brings all the skating action you loved from the original games but with a modern update. The mechanics are still rock-solid, and the fun factor is off the charts. It's pure, unadulterated skating joy.", 5.0, 86, 1001),
("A Timeless Classic", "Tony Hawk's Pro Skater 1+2 is a perfect remake. The levels, tricks, and fast-paced gameplay are still as enjoyable as they were when the original games first came out. The game looks fantastic, and the music is great too.", 5.0, 86, 1002),
("Endless Fun", "Tony Hawk's Pro Skater 1+2 is a blast to play. Whether you're reliving the classics or experiencing them for the first time, the game is full of fun moments, tight controls, and rewarding tricks. You won't want to stop playing!", 5.0, 86, 1003),
("Skateboarding Perfection", "Tony Hawk's Pro Skater 1+2 is the ultimate skateboarding experience. The revamped visuals, tight controls, and iconic levels are as great as ever. It's everything fans of the series could want and more.", 5.0, 86, 1004);

-- Recensioni per "Tormented Souls" (GameID 279)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Modern Classic", "Tormented Souls is a fantastic survival horror game that blends classic Resident Evil-style gameplay with modern mechanics. The eerie atmosphere, puzzles, and dark story are sure to keep you on edge throughout.", 5.0, 279, 1005),
("A Terrifying Journey", "Tormented Souls brings back the old-school survival horror experience with a modern twist. The creepy atmosphere, challenging puzzles, and terrifying enemies make for a great experience for horror fans.", 5.0, 279, 1006),
("Perfect Horror Experience", "This game nails the survival horror experience. The eerie atmosphere, difficult puzzles, and creepy monsters create a tense and terrifying adventure. Fans of the genre will definitely enjoy this one.", 5.0, 279, 1007),
("A Nostalgic Horror Game", "Tormented Souls feels like a love letter to the survival horror genre. The fixed camera angles, creepy mansion setting, and challenging puzzles remind me of classic Resident Evil games, but with a fresh twist.", 5.0, 279, 1008),
("Horror Done Right", "Tormented Souls is a great example of how to do survival horror right. It combines traditional gameplay with modern elements to create a terrifying experience that keeps you hooked from start to finish.", 5.0, 279, 1009),
("A Creepy Masterpiece", "Tormented Souls is a great throwback to classic survival horror. The atmosphere is tense, the puzzles are engaging, and the story is dark and mysterious. A must-play for fans of old-school horror.", 5.0, 279, 1010),
("Thrilling and Chilling", "Tormented Souls delivers an unforgettable horror experience. The game is full of tense moments, creepy visuals, and a great story. If you're a fan of the survival horror genre, you'll love this game.", 5.0, 279, 1011),
("Horror at its Best", "Tormented Souls is a well-crafted survival horror game that will keep you on the edge of your seat. The fixed camera angles, eerie atmosphere, and creepy monsters make for an excellent experience.", 5.0, 279, 1012),
("A True Horror Gem", "Tormented Souls is a true horror gem. The atmosphere is oppressive, the puzzles are challenging, and the game keeps you on edge throughout. If you're a fan of survival horror, you'll absolutely love it.", 5.0, 279, 1013),
("Chilling and Intriguing", "Tormented Souls is an excellent survival horror game. It combines the best elements of classic survival horror with a modern sensibility, delivering an immersive and terrifying experience that's hard to put down.", 5.0, 279, 1014);

-- Recensioni per "Total War: Warhammer" (GameID 291)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Epic Strategy", "Total War: Warhammer combines epic strategy with fantastic fantasy elements. The game's attention to detail and the variety of factions make for a thrilling experience. If you're a fan of strategy games, this is a must-play.", 5.0, 291, 1015),
("An Epic Battle", "Total War: Warhammer delivers an epic battle experience with its massive armies and detailed world-building. The strategic depth and variety of factions create a rich and rewarding gameplay experience.", 5.0, 291, 1016),
("The Ultimate Fantasy Strategy Game", "Total War: Warhammer is the ultimate fantasy strategy game. The combination of real-time battles and turn-based strategy gives you complete control over your armies and kingdoms. The factions are diverse and each one is a joy to play.", 5.0, 291, 1017),
("A Fantasy Strategist's Dream", "Total War: Warhammer is a dream come true for fans of both fantasy and strategy games. The tactical battles are thrilling, and the campaign management is deep and rewarding. The fantasy setting makes it even more enjoyable.", 5.0, 291, 1018),
("Total Warfare in Fantasy", "Total War: Warhammer brings the strategy genre into the world of fantasy in the best way possible. The game is full of strategic depth, exciting battles, and detailed lore. It's the perfect game for fans of epic warfare and fantasy.", 5.0, 291, 1019),
("A Deep and Rewarding Game", "Total War: Warhammer is deep, rewarding, and challenging. The strategic elements are fantastic, and the fantasy setting adds an extra layer of enjoyment. The game is perfect for anyone who loves complex strategy games.", 5.0, 291, 1020),
("Masterful Fantasy Strategy", "Total War: Warhammer is a masterful blend of fantasy and strategy. The variety of factions and their unique playstyles keep things fresh, while the large-scale battles are absolutely epic. A must-play for strategy fans.", 5.0, 291, 1021),
("Epic Fantasy Warfare", "Total War: Warhammer offers epic fantasy warfare in a way that few games can. The strategic depth and variety of armies make each playthrough unique. If you love grand strategy and fantasy, this is the game for you.", 5.0, 291, 1022),
("Fantasy and Strategy Combined", "Total War: Warhammer is an incredible combination of fantasy and strategy. The massive battles, unique factions, and in-depth campaigns make this a game that will keep you coming back for more.", 5.0, 291, 1023),
("The Best of Both Worlds", "Total War: Warhammer blends strategy and fantasy perfectly. The tactical battles are intense, and the fantasy world is full of interesting lore and factions. It's a fantastic game for anyone who loves both genres.", 5.0, 291, 1024);


-- Recensioni per "Total War: Warhammer II" (GameID 292)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Incredible Sequel", "Total War: Warhammer II improves upon the first game with new factions, better mechanics, and even more epic battles. The game's tactical depth and fantasy world are absolutely amazing. Highly recommended for strategy fans!", 5.0, 292, 1025),
("The Ultimate Strategy Game", "Total War: Warhammer II takes everything that made the first game great and makes it even better. The new factions are fun to play, and the campaign is more engaging than ever. If you loved the first game, this is a must-play.", 5.0, 292, 1026),
("Strategic Masterpiece", "Total War: Warhammer II is a strategic masterpiece. The new factions, improved gameplay, and epic battles make it one of the best strategy games ever. The world-building and tactical depth will keep you hooked for hours.", 5.0, 292, 1027),
("Fantastic Expansion", "This game builds on the original in every way. The factions are diverse and unique, and the battles are bigger and more epic than ever. Total War: Warhammer II is a fantastic sequel that every strategy fan should play.", 5.0, 292, 1028),
("A Worthy Successor", "Total War: Warhammer II improves on its predecessor with new units, factions, and deeper mechanics. The grand battles and strategic gameplay are more enjoyable than ever. A must-play for fans of strategy and fantasy games.", 5.0, 292, 1029),
("Better than the First", "Total War: Warhammer II is a significant improvement over the first game. The new factions are fantastic, the battles are even more epic, and the world-building is better than ever. If you love strategy games, this one is for you.", 5.0, 292, 1030),
("Incredible Fantasy Strategy", "Total War: Warhammer II takes everything great about the first game and turns it up to eleven. The new factions, improved mechanics, and massive battles make it an unforgettable experience. A must-play for strategy and fantasy fans.", 5.0, 292, 1031),
("Endless Replayability", "With new factions, improved mechanics, and deeper campaigns, Total War: Warhammer II offers endless replayability. The strategic depth is fantastic, and the game keeps you hooked for hours. A great game for any strategy fan.", 5.0, 292, 1032),
("A Must-Play for Strategy Fans", "Total War: Warhammer II is a fantastic game for fans of strategy. The factions are diverse, the battles are epic, and the world is rich with lore. It's a must-play for anyone who loves deep and rewarding strategy games.", 5.0, 292, 1033),
("Strategic Perfection", "Total War: Warhammer II is a masterpiece of strategy. The game is complex, rewarding, and full of new content. Whether you're a newcomer or a veteran, the game offers an unforgettable experience.", 5.0, 292, 1034);

-- Recensioni per "Total War: Warhammer III" (GameID 69)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Epic Conclusion", "Total War: Warhammer III is an epic conclusion to the trilogy. The new factions and massive battles make it a fitting end to the saga. If you're a fan of strategy games, you can't miss this one.", 5.0, 69, 1035),
("The Final Chapter", "Total War: Warhammer III delivers an incredible final chapter to the series. The new factions are exciting, and the tactical battles are more intense than ever. It's the perfect way to wrap up the trilogy.", 5.0, 69, 1036),
("A Triumphant Finale", "Total War: Warhammer III is a triumph. The game takes everything great about the previous titles and elevates it with new factions, deeper gameplay, and even more epic battles. A must-play for fans of the series.", 5.0, 69, 1037),
("The Ultimate Fantasy Strategy", "With new factions and an even bigger world, Total War: Warhammer III is the ultimate fantasy strategy game. The tactical depth and grand battles make it one of the best strategy games of all time. A fitting conclusion to the series.", 5.0, 69, 1038),
("A Grand Strategy Game", "Total War: Warhammer III brings the trilogy to a satisfying close. The new mechanics, factions, and epic battles make this one of the best games in the series. It's a must-play for any fan of strategy games.", 5.0, 69, 1039),
("Epic in Every Way", "Total War: Warhammer III is epic in every sense of the word. The grand scale of the battles, the new factions, and the engaging campaign make this the ultimate strategy experience. An unforgettable conclusion to a fantastic series.", 5.0, 69, 1040),
("Incredible Strategy", "Total War: Warhammer III brings the series to a spectacular conclusion. The new factions and deeper mechanics make the game more engaging than ever. If you love strategy games, this one is a must-play.", 5.0, 69, 1041),
("An Incredible Finale", "Total War: Warhammer III is the perfect conclusion to the trilogy. The new factions are a blast to play, and the epic battles are bigger than ever. A must-play for fans of the series and strategy games in general.", 5.0, 69, 1042),
("A Worthy Ending", "Total War: Warhammer III is a worthy ending to the series. The new mechanics, factions, and epic battles are fantastic, and the game offers hours of strategic gameplay. A great game for any strategy fan.", 5.0, 69, 1043),
("A Stunning Conclusion", "Total War: Warhammer III wraps up the trilogy with a stunning conclusion. The battles are epic, the factions are unique, and the gameplay is more engaging than ever. A must-play for any fan of strategy games.", 5.0, 69, 1044);

-- Recensioni per "TrackMania" (GameID 90)
INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("The Ultimate Racing Game", "TrackMania is the ultimate racing game for fans of speed and precision. The tracks are crazy, the cars are fast, and the competition is fierce. If you love racing games, this one is a must-play!", 5.0, 90, 1045),
("Addictive and Fun", "TrackMania is an incredibly fun and addictive racing game. The tracks are full of twists and turns, and the fast-paced gameplay will keep you hooked for hours. Whether you're a casual gamer or a competitive player, TrackMania is a blast.", 5.0, 90, 1046),
("A Thrilling Racing Experience", "TrackMania is a thrilling racing game that offers fast-paced action, tight controls, and a huge variety of tracks. The game's addictive nature will have you racing over and over again to beat your best times.", 5.0, 90, 1047),
("Fast, Fun, and Competitive", "TrackMania offers a fast, fun, and highly competitive racing experience. The tracks are challenging, the controls are responsive, and the community-driven leaderboards will keep you coming back for more.", 5.0, 90, 1048),
("Racing Redefined", "TrackMania is a racing game like no other. The crazy tracks and lightning-fast gameplay will keep you on the edge of your seat. It's a great game for both casual players and those who want to master every track.", 5.0, 90, 1049),
("The Racing Game of the Future", "TrackMania is the racing game of the future. The crazy tracks, tight controls, and community-driven elements make it a blast to play. Whether you're playing solo or competing with friends, it's always a fun time.", 5.0, 90, 1050),
("Endless Fun", "TrackMania offers endless fun with its wide variety of tracks and racing challenges. The fast-paced gameplay and competitive leaderboards will keep you coming back for more. A must-play for any racing fan.", 5.0, 90, 1051),
("Highly Competitive", "TrackMania is highly competitive, offering a challenge for both beginners and expert racers. The tracks are unique, the gameplay is fast-paced, and the online community adds another layer of excitement to the experience.", 5.0, 90, 1052),
("Speed, Precision, and Fun", "TrackMania delivers a racing experience that's all about speed, precision, and fun. The tight controls, creative tracks, and constant competition make this an addictive and enjoyable game to play.", 5.0, 90, 1053),
("A Racing Phenomenon", "TrackMania is a racing phenomenon. The game is fast, exciting, and endlessly replayable. Whether you're racing against friends or trying to set new records, it's always a great time.", 5.0, 90, 1054);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Charming Adventure", "Tunic is an absolute gem! The puzzles are challenging but not overwhelming, and the art style is so unique. It's a must-play for fans of Zelda-like games.", 4.5, 106, 2),
("A Bit Confusing at First", "While I appreciate the minimalist design and clever puzzles, I did feel a bit lost at times. Still, it's a rewarding game once you get the hang of it.", 3.5, 106, 10),
("Masterpiece in Simplicity", "The world of Tunic is wonderfully crafted. The cryptic language and environment kept me coming back for more. A beautifully simple yet deep experience.", 5.0, 106, 15),
("Frustrating Yet Addictive", "It's an incredibly hard game, but it keeps pulling you back in. The combat could be smoother, but the exploration is worth the effort.", 4.0, 106, 23),
("A Visual Delight", "The graphics in Tunic are fantastic! It's like playing through a storybook. The puzzles are intriguing, though sometimes it feels like a guessing game.", 4.0, 106, 30),
("Challenging But Rewarding", "Tunic's difficulty is its main charm. Once you start understanding the mechanics, the satisfaction is immense. A beautiful, challenging game.", 4.5, 106, 45),
("Interesting, but Too Hard", "I can see the appeal, but it's just too tough for me. The puzzles took forever to figure out, and the combat was clunky.", 2.5, 106, 60),
("Cute and Fun", "Tunic is a cute little game with a lot of charm. While the difficulty can be high, the world is so inviting and fun to explore.", 4.0, 106, 73),
("Tough Yet Addictive", "I spent hours trying to figure out the puzzles. The learning curve is steep, but it's satisfying when you finally make progress.", 4.0, 106, 82),
("Could Be Better", "I really wanted to like it, but the game felt too cryptic for me. I understand the appeal, but I just couldn't get into it.", 3.0, 106, 95);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("An Epic Adventure", "Uncharted 4 is a masterpiece. The storytelling is top-notch, and the action sequences are exhilarating. It's definitely one of the best in the series.", 5.0, 8, 1),
("A Great Finale", "The game was a fitting end to Nathan Drake's journey. The environments are breathtaking, and the character development is excellent.", 4.5, 8, 5),
("A Cinematic Experience", "It feels like playing through a blockbuster movie. The pacing and action are fantastic, although the platforming can be a bit repetitive.", 4.0, 8, 12),
("Stunning Visuals", "The graphics are stunning. I found myself stopping just to admire the scenery. The game has a great story, but the mechanics feel a bit outdated.", 3.5, 8, 20),
("A Thrilling Ride", "Uncharted 4 never lets up. The story, the combat, and the puzzles kept me hooked from start to finish. Highly recommended for action-adventure lovers.", 4.5, 8, 35),
("Fun But Short", "It's a fun ride, but I felt like the game was a little shorter than I expected. The gameplay is solid, though, and I enjoyed the story.", 4.0, 8, 40),
("Impressive, But Could Be Better", "The game was fantastic, but the treasure hunting and exploration felt a bit too linear. Still, the action made up for it.", 4.0, 8, 55),
("A True Adventure", "I loved every moment of it. The character interactions were great, and the puzzles were challenging without being frustrating.", 5.0, 8, 63),
("The Best Uncharted Yet", "I played through all the Uncharted games, and this one is by far the best. The story and gameplay are perfectly balanced.", 5.0, 8, 70),
("Not as Good as the Previous Games", "I expected more. The story was good, but not as engaging as earlier entries, and the shooting mechanics felt too familiar.", 3.5, 8, 85);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Masterpiece of Storytelling", "Undertale is a unique experience. The way it mixes humor, deep storytelling, and gameplay mechanics is unmatched. It's an unforgettable journey.", 5.0, 101, 3),
("A Different Kind of RPG", "Undertale is quirky and fun, offering an RPG experience that's unlike anything else. The choices you make really matter, and I love the replay value.", 4.5, 101, 8),
("A Bit Overhyped", "While I understand the love for this game, I didn't quite get the magic. It's good, but not as groundbreaking as people say.", 3.0, 101, 18),
("A Rollercoaster of Emotions", "Undertale's story is emotional, and the characters are endearing. It has a unique charm, and I found myself caring about every little decision.", 4.5, 101, 25),
("Memorable Characters", "The characters in Undertale are so memorable, and the music is fantastic. It's definitely a game I'll come back to in the future.", 5.0, 101, 36),
("Charming But Confusing", "I had a hard time understanding some of the mechanics, but the game's charm kept me going. It's a lot of fun and has great humor.", 4.0, 101, 44),
("Unexpectedly Deep", "Undertale surprised me with how deep it was. The story and the moral choices made it stand out from other games in the genre.", 4.5, 101, 51),
("A Cult Classic", "I can see why Undertale has such a following. It's an indie gem with tons of heart. However, I feel it could've been a bit longer.", 4.0, 101, 62),
("Love It or Hate It", "I didn't love Undertale as much as others did, but I can respect its creativity and charm. It's not for everyone, but it's certainly unique.", 3.5, 101, 75),
("A Game That Stays With You", "Undertale is one of those rare games that stays with you long after you finish it. The impact it has is undeniable.", 5.0, 101, 90);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Charming Story of Relocation", "Unpacking is a soothing game that lets you enjoy the little things in life. It's simple, but it tells a beautiful story through the process of unpacking.", 4.5, 165, 3),
("Relaxing Yet Engaging", "I didn't expect a game about unpacking to be so compelling, but it really kept me engaged. The subtle narrative built through each room was delightful.", 4.0, 165, 8),
("Too Simple", "The game felt a bit too simple for my taste. It's relaxing, but after a while, it becomes repetitive. Not much to keep you coming back after finishing.", 3.0, 165, 15),
("A Peaceful Journey", "Unpacking is a peaceful experience that made me reflect on my own belongings. The art style and music create a perfect atmosphere for relaxation.", 4.5, 165, 22),
("Unexpectedly Deep", "What started as a simple puzzle game turned into something meaningful. It's a reflection of life's small moments, and I didn't expect to feel emotional about it.", 5.0, 165, 30),
("Charming but Short", "The game is charming, but it didn't last long enough for me to feel truly invested. It's a nice one-time experience, but not something I'd replay often.", 3.5, 165, 40),
("A Quiet Escape", "Unpacking is a lovely escape from the usual hectic games. It's a calming experience that helps you unwind, even though it's a bit light on challenge.", 4.0, 165, 50),
("A Pleasant Surprise", "I didn't expect to love this game, but it really drew me in. The puzzles are simple, but the story and the satisfaction of unpacking are very rewarding.", 4.5, 165, 55),
("Touching Storytelling", "The game tells a unique and touching story through its environment. It's simple, but it left a lasting impression on me.", 5.0, 165, 63),
("Therapeutic but Boring", "While I found the game relaxing, it became quite boring after a while. It was nice for a short time, but I wouldn't recommend playing it for hours.", 3.0, 165, 72),

("A Dark and Engaging RPG", "Vampyr is an atmospheric RPG with a strong narrative. The moral choices and combat system kept me hooked from beginning to end.", 4.5, 50, 5),
("Unique Vampire Experience", "The setting and the story in Vampyr are great. The combat feels a little clunky, but the choices you make really affect the outcome.", 4.0, 50, 12),
("Could Be Better", "While Vampyr has a great premise, the gameplay can feel repetitive at times. I was hoping for more depth in the combat and exploration.", 3.5, 50, 20),
("Underrated Gem", "Vampyr offers a great mix of action and storytelling. The dialogue and character development are strong, even if the combat isn't the best.", 4.0, 50, 28),
("Intriguing Story, Mediocre Gameplay", "I loved the story in Vampyr, but the gameplay didn't live up to the narrative. The combat was frustrating, and I felt the game could have been more polished.", 3.5, 50, 35),
("An Emotional Journey", "The moral decisions in Vampyr are thought-provoking, and the story had a real emotional impact on me. The combat could be improved, but it's still a solid RPG.", 4.5, 50, 44),
("Gothic and Atmospheric", "Vampyr does a great job of creating a gothic atmosphere. The world is immersive, and the story is captivating. It's not perfect, but it's definitely worth playing.", 4.0, 50, 50),
("A Slow Burn", "Vampyr starts off slow, but once the story picks up, it's hard to stop. The gameplay can be repetitive, but the narrative makes it worthwhile.", 4.0, 50, 63),
("Dark and Moody", "I enjoy the dark atmosphere and the decisions you make in Vampyr, but the combat system could be more fluid. The story kept me going, though.", 3.5, 50, 70),
("Disappointing Ending", "The game started strong, but I felt the ending was rushed and unsatisfying. The combat was also a letdown, but the story was compelling.", 3.0, 50, 80),

("Fascinating World", "Watch Dogs: Legion takes the series to new heights with its unique mechanic of playing as anyone. The world-building is incredible, but the story falls a little flat.", 4.0, 17, 2),
("Fun but Repetitive", "The game has a lot of potential, but the missions felt repetitive after a while. The ability to recruit anyone is amazing, but it doesn't quite make up for the lack of variety in gameplay.", 3.5, 17, 10),
("Impressive but Flawed", "Watch Dogs: Legion introduces an interesting concept with its character recruitment, but the execution isn't perfect. It's fun for a while but gets tedious.", 3.5, 17, 15),
("Great Concept, Poor Execution", "The ability to control any NPC is awesome, but the gameplay is lacking. The world is massive and immersive, but the story could have been better.", 3.0, 17, 25),
("A New Take on the Franchise", "I love the concept of playing as anyone, but I feel the game lacks the depth that the previous Watch Dogs had. Still, the hacking mechanics are fun.", 4.0, 17, 34),
("Innovative, But Needs Polish", "Watch Dogs: Legion brings something new with its recruit-anyone system, but the gameplay and story are weaker compared to previous entries. Still, a solid open-world experience.", 3.5, 17, 42),
("Enjoyable but Forgettable", "It's fun to play for a while, but after completing the main story, I felt like I was done. The concept is great, but the game didn't keep me hooked long enough.", 3.5, 17, 50),
("An Entertaining Game", "The gameplay is enjoyable, especially with the recruit-anyone feature. The story isn't as compelling as I hoped, but the action and hacking mechanics make up for it.", 4.0, 17, 60),
("Massive, Yet Lacking Depth", "Watch Dogs: Legion is massive in scope, but the gameplay doesn't offer enough variety. The story is forgettable, but the world itself is fun to explore.", 3.0, 17, 75),
("Not What I Expected", "The game looked amazing on paper, but I was disappointed with the execution. It's a good open-world game, but it lacks the impact of its predecessors.", 2.5, 17, 85);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Revolutionary Idea", "Watch Dogs was a groundbreaking game when it came out. The concept of hacking into the city around you was amazing, but the gameplay became repetitive after a while.", 3.5, 280, 4),
("Innovative but Repetitive", "Watch Dogs started with an exciting concept, but I got bored quickly. The open world and hacking mechanics were cool, but the missions felt too similar.", 3.0, 280, 12),
("Good, but Could Be Better", "The hacking mechanics are fun, but the story felt flat and the missions became monotonous. I expected more variety from such an interesting premise.", 3.5, 280, 18),
("Overhyped", "Watch Dogs looked great in trailers, but the final product didn't live up to the expectations. The world is big, but it didn't feel as alive as I hoped it would be.", 2.5, 280, 26),
("Enjoyable, but Flawed", "The game has a lot of potential, especially with its hacking system. But the story was lackluster, and I found the side missions to be repetitive.", 3.0, 280, 35),
("A Fun But Brief Experience", "I had a good time playing Watch Dogs, but it was over too quickly. The hacking mechanics were fun, but the story wasn't engaging enough to keep me hooked.", 3.5, 280, 43),
("Solid Foundation", "Watch Dogs laid a solid foundation for future games in the series. The open-world exploration and hacking were fun, but the game lacked polish in some areas.", 4.0, 280, 50),
("Promising, but Lacking", "Watch Dogs had a great concept, but it didn't quite live up to the hype. The story and missions felt underdeveloped, and the world could have been more interactive.", 3.0, 280, 58),
("Uninspired", "I couldn't shake the feeling that Watch Dogs was just another open-world game with a few cool gimmicks. It wasn't terrible, but it wasn't anything special either.", 2.5, 280, 67),
("Could Have Been So Much More", "I really wanted to like Watch Dogs, but it ended up feeling like a missed opportunity. The hacking was fun, but the story and gameplay just didn't hold my attention.", 2.5, 280, 75),

("A Better Sequel", "Watch Dogs 2 improved on everything that the first game lacked. The story is more fun, the world is vibrant, and the characters are much more likable.", 4.5, 281, 3),
("A Great Improvement", "Watch Dogs 2 is a much more enjoyable experience than its predecessor. The story and characters are far better, and the hacking mechanics feel more refined.", 4.5, 281, 11),
("Fun, But a Little Crazy", "The second installment is definitely an improvement. The hacking and gadgets are more fun, but sometimes the game feels a bit too chaotic for my liking.", 4.0, 281, 19),
("Vibrant and Enjoyable", "Watch Dogs 2 offers a much more colorful and fun world than the first. The story is much better, and I liked the new characters a lot more.", 4.5, 281, 27),
("Engaging and Full of Personality", "The characters and story in Watch Dogs 2 are much more engaging. The game is full of personality, and the world feels much more alive than the first one.", 5.0, 281, 35),
("A Fun Sequel", "Watch Dogs 2 is a much better game than the original. The gameplay is smoother, the hacking is more fun, and the story is more engaging.", 4.5, 281, 43),
("The Perfect Sequel", "Watch Dogs 2 fixed all the problems of the first game. The story is interesting, the characters are better, and the world is a lot more fun to explore.", 5.0, 281, 51),
("A Step in the Right Direction", "While the first game was a bit dry, Watch Dogs 2 takes everything to a new level. The world is vibrant, and the story is much more engaging.", 4.5, 281, 59),
("Better Than the First", "Watch Dogs 2 is definitely a better game than the original. The gameplay improvements are clear, and the world feels more alive and interactive.", 4.0, 281, 66),
("Fun, but Too Much Chaos", "Watch Dogs 2 is great, but sometimes the missions get too chaotic for my liking. It's fun, but there's a bit too much going on at times.", 3.5, 281, 74),

("A Classic Game", "Wii Sports is a timeless classic. The simplicity of the gameplay makes it easy to pick up and enjoy with friends and family. It's still fun even years later.", 4.5, 134, 2),
("A Fun Family Game", "Wii Sports was one of the first games I played with my family, and it's still a lot of fun. The motion controls work surprisingly well, and it's easy to get into.", 4.5, 134, 9),
("Timeless Fun", "Even after all these years, Wii Sports is still a blast to play. It's simple, but it's a great way to have fun with friends and family, and the motion controls still feel fresh.", 5.0, 134, 17),
("Perfect for Parties", "Wii Sports is a fantastic game to play at parties. It's easy for anyone to pick up, and it's a great way to get people involved in gaming without much of a learning curve.", 4.0, 134, 25),
("Nostalgic", "Wii Sports brings back so many memories of my childhood. The sports are simple, but they are still incredibly fun to play with friends and family.", 4.5, 134, 34),
("Fun but Simple", "Wii Sports is fun, but it's very simple. I enjoy playing it every now and then, but it doesn't have the depth that modern games have.", 3.5, 134, 42),
("Great for Casual Play", "Wii Sports is great for casual gaming sessions. It's not as in-depth as some other sports games, but it's definitely fun for a quick game with friends.", 4.0, 134, 51),
("Nostalgic but Outdated", "Wii Sports is a great nostalgia trip, but it feels a bit outdated compared to modern games. It's still fun in short bursts, but it's not something I play often.", 3.0, 134, 60),
("A Great Introduction to Gaming", "For newcomers to gaming, Wii Sports is a fantastic introduction. The motion controls are simple to understand, and the games are fun for all ages.", 4.5, 134, 68),
("Slightly Limited", "Wii Sports is great for a few games, but it feels limited after a while. It's fun for short sessions, but I wish there were more sports to play.", 3.5, 134, 76);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Great Prequel", "The Witcher 2: Assassins of Kings is a fantastic RPG. The combat and story are well-crafted, but the game can be difficult at times. Still, it's a great experience overall.", 4.5, 58, 4),
("A Masterpiece", "Witcher 2 is a masterpiece of storytelling and combat. The decisions you make really affect the outcome, and the world is beautifully crafted. One of my favorite RPGs.", 5.0, 58, 12),
("Great World-Building", "Witcher 2 really excels in world-building and creating moral ambiguity in its story. The combat was a bit difficult at first, but it's worth sticking with it.", 4.5, 58, 20),
("A Truly Immersive Experience", "Witcher 2 pulls you into its world like few RPGs can. The story is engaging, and the characters are memorable, though the combat system can be a bit tricky to master.", 4.0, 58, 28),
("Good, but Could Be Better", "While Witcher 2 is a great game, I found the combat to be a little cumbersome at times. Still, the story is rich and the world is immersive.", 3.5, 58, 36),
("A Difficult Yet Rewarding Journey", "Witcher 2 can be difficult, but the rewards are worth it. The combat and story are top-notch, but be prepared for some challenging encounters.", 4.5, 58, 44),
("The Story Is Amazing", "The Witcher 2 has a fantastic story that keeps you hooked from start to finish. It's a bit tough at times, but I love the depth and complexity of the characters.", 5.0, 58, 52),
("Enjoyable but Frustrating", "Witcher 2 is a solid RPG, but the difficulty spike in some areas can be frustrating. Overall, it's still an enjoyable experience with a great narrative.", 3.5, 58, 60),
("A Beautiful, But Tough RPG", "Witcher 2 is visually stunning and features excellent storytelling, but some of the combat sections are brutal. Still, a must-play for RPG fans.", 4.0, 58, 68),
("One of the Best RPGs", "Witcher 2 is one of the best RPGs I've played. The characters are complex, the combat is deep, and the world feels so alive. Highly recommend it to any fan of the genre.", 5.0, 58, 76),

("An Epic Masterpiece", "Witcher 3: Wild Hunt is one of the greatest RPGs of all time. The world is massive, the story is gripping, and the side quests are just as engaging as the main story.", 5.0, 24, 3),
("A True Masterpiece", "Witcher 3 has it all—excellent combat, a gripping story, and a beautifully detailed world. This is the gold standard for RPGs, and it's hard to imagine a better game.", 5.0, 24, 11),
("An Immersive Experience", "Witcher 3 is a fantastic RPG with an incredible open world. The main story is compelling, but the side quests are even more engaging. A must-play for RPG fans.", 5.0, 24, 19),
("Epic and Engaging", "Witcher 3 is epic in every sense. The world is beautiful, the story is captivating, and the characters are well-written. It's a truly immersive experience.", 5.0, 24, 27),
("A Legend in the Making", "Witcher 3 is a legendary RPG. The story is top-notch, the combat is satisfying, and the world is expansive and full of life. I can't recommend it enough.", 5.0, 24, 35),
("A New Benchmark", "Witcher 3 has set a new benchmark for open-world RPGs. The depth of the story and the variety of quests make it a game that you can lose yourself in for hours.", 5.0, 24, 43),
("A Masterpiece of Gaming", "Witcher 3 is one of those rare games that you play and immediately know is a masterpiece. The attention to detail, the storytelling, and the gameplay are unparalleled.", 5.0, 24, 51),
("Stunning World", "The world of Witcher 3 is breathtaking. It feels alive, and the quests are deep and meaningful. It's hard to imagine a better open-world RPG than this.", 5.0, 24, 59),
("A Truly Incredible Game", "Witcher 3 exceeded all my expectations. The story is amazing, the world is stunning, and the side quests are some of the best I've ever played. This game is unforgettable.", 5.0, 24, 67),
("An Epic Journey", "Witcher 3 takes you on an epic journey full of twists and turns. The world is huge and beautifully crafted, and the story keeps you hooked until the very end.", 5.0, 24, 75),

("A Stunning Revival", "Wolfenstein: The New Order is a fantastic reboot of the series. The story is engaging, and the action is fast-paced and intense. Definitely one of the best FPS games I've played.", 4.5, 282, 5),
("Great Action", "Wolfenstein: The New Order delivers intense action and a gripping story. The alternate history setting is fascinating, and the gameplay is solid. Highly recommend it to fans of FPS games.", 4.5, 282, 13),
("Nostalgic and Fun", "Wolfenstein: The New Order reminds me of the classic FPS games from the 90s. The fast-paced action and engaging story make it a must-play for fans of the genre.", 4.5, 282, 21),
("Intense and Thrilling", "This game is fast-paced and full of intense moments. The story is great, and the alternate history setting adds an interesting layer. Highly recommend it.", 4.5, 282, 29),
("A Welcome Return", "Wolfenstein: The New Order is a fantastic reboot of the classic series. The combat is satisfying, and the story is compelling. It's a great return to form for the franchise.", 4.5, 282, 37),
("Brutal and Fun", "Wolfenstein: The New Order is brutal, fun, and highly addictive. The story is engaging, and the gameplay is intense. It's one of the best FPS games I've played in recent years.", 4.5, 282, 45),
("A Solid FPS", "Wolfenstein: The New Order is a solid first-person shooter. The gameplay is smooth, and the story is interesting. It's not groundbreaking, but it's still a lot of fun.", 4.0, 282, 53),
("Engaging Story", "The story in Wolfenstein: The New Order is engaging and the gameplay is solid. The combat is satisfying, and the alternate history setting is a cool twist.", 4.5, 282, 61),
("One of the Best FPS", "Wolfenstein: The New Order is one of the best FPS games I've played. The action is fast-paced, and the story is intriguing. Definitely worth playing.", 4.5, 282, 69),
("Gripping from Start to Finish", "This game is gripping from the moment you start. The story is engaging, and the combat is satisfying. I couldn't put it down until I finished it.", 4.5, 282, 77);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Solid Prequel", "Wolfenstein: The Old Blood is a solid prequel to The New Order. The gameplay is just as intense, and the story is engaging. It's a great addition to the series, though a bit short.", 4.5, 283, 6),
("Fun and Intense", "Wolfenstein: The Old Blood brings the fast-paced action of the franchise back. The levels are well-designed, and the story is compelling. I just wish it was a bit longer!", 4.0, 283, 14),
("Great Action", "The Old Blood keeps the same intensity and fun of The New Order. The combat is satisfying, and the levels are well-crafted. Overall, a fun shooter that's worth playing.", 4.5, 283, 22),
("Good, but Short", "Wolfenstein: The Old Blood is a fun game, but it's much shorter than its predecessor. The action is great, but I feel like it could have been more fleshed out.", 3.5, 283, 30),
("A Great Spin-Off", "The Old Blood is a great spin-off with solid gameplay and intense action. The story isn't as strong as The New Order, but it still offers a lot of fun.", 4.0, 283, 38),
("More of the Same", "While Wolfenstein: The Old Blood delivers more of the same intense action, it doesn't do much to improve on The New Order. It's a fun game, but doesn't feel as fresh.", 3.5, 283, 46),
("Good Fun", "The Old Blood is a fun and solid shooter. It doesn't reinvent the wheel, but if you loved The New Order, you'll enjoy this one too. It's a bit shorter, but still worth the playthrough.", 4.0, 283, 54),
("A Nice Addition", "Wolfenstein: The Old Blood is a nice addition to the series. The story is decent, and the combat is fun, though it feels a bit familiar to The New Order.", 4.0, 283, 62),
("Intense, but Short", "The Old Blood offers great action, but it's much shorter than I expected. Still, it's a solid prequel with some fun moments.", 4.0, 283, 70),
("Solid Shooter", "Wolfenstein: The Old Blood is a solid shooter, though not as groundbreaking as The New Order. The action is still fun, and the gameplay is satisfying.", 4.0, 283, 78),

("Interesting Concept", "Wolfenstein: The Young Blood introduces a new dynamic with co-op gameplay. It's a fun and engaging experience, but the story doesn't quite live up to the previous games in the series.", 4.0, 284, 7),
("A Fresh Take", "The Young Blood brings a fresh take on the Wolfenstein series with co-op. It's fun, but the lack of strong narrative makes it feel like it's missing something.", 4.0, 284, 15),
("Fun Co-Op Shooter", "Wolfenstein: The Young Blood is a fun co-op shooter. The levels are designed with teamwork in mind, and it's enjoyable to play with a friend, but the story is weaker than the others.", 3.5, 284, 23),
("A Bit Repetitive", "While the co-op mode in The Young Blood is enjoyable, the gameplay becomes a bit repetitive after a while. Still, a fun game to play with friends.", 3.5, 284, 31),
("Co-Op Fun", "Wolfenstein: The Young Blood is a fun co-op experience. The gameplay is solid, but the story feels a bit shallow compared to the earlier games in the series.", 4.0, 284, 39),
("Decent Co-Op", "The co-op mode is fun, but The Young Blood doesn't have the same impact as its predecessors. The lack of depth in the story hurts it a little, but it's still a good time.", 3.5, 284, 47),
("Disappointing", "The Young Blood's story didn't grab me, and the co-op gameplay, while fun, doesn't make up for the lack of a strong narrative. It's not bad, but it's not great either.", 3.0, 284, 55),
("Fun With Friends", "Wolfenstein: The Young Blood is a fun experience, especially when played with friends. It doesn't quite reach the heights of the previous games, but it's still enjoyable.", 4.0, 284, 63),
("Co-Op Chaos", "If you love co-op games, The Young Blood is a blast. The story may not be the best, but the gameplay is chaotic and fun. It's a great game to play with a friend.", 4.0, 284, 71),
("A Different Take", "While Wolfenstein: The Young Blood offers a new co-op dynamic, it doesn't have the same intensity as the other games in the series. Still, it's an interesting diversion.", 3.5, 284, 79),

("An Iconic MMO", "World of Warcraft is one of the most iconic MMORPGs ever. The world is vast, the quests are engaging, and the community is amazing. It's an incredible game that has stood the test of time.", 5.0, 121, 8),
("A Timeless Classic", "World of Warcraft has been my go-to MMO for years. The depth, content, and lore are incredible. No other MMO has come close to the same level of immersion and variety.", 5.0, 121, 16),
("Unmatched Depth", "World of Warcraft offers unparalleled depth in an MMO. From the vast world to the intricate quests and dungeons, there's always something to do. It's a game I keep coming back to.", 5.0, 121, 24),
("A World of Wonders", "World of Warcraft is the game that defined MMORPGs. The world feels alive, and there's always something new to discover. It's an unforgettable experience that never gets old.", 5.0, 121, 32),
("A Game That Keeps Giving", "World of Warcraft has a vast world with tons of content. Even after all these years, there's always something new to experience. It's a game that keeps on giving.", 5.0, 121, 40),
("Great MMO, But Time-Consuming", "World of Warcraft is a fantastic MMO with endless content, but it can be very time-consuming. If you don't mind putting in the hours, it's a great game to immerse yourself in.", 4.5, 121, 48),
("Amazing, But Hard to Get Into", "World of Warcraft is a great game with a ton of depth, but it can be hard for new players to get into. The learning curve is steep, but once you're in, it's an unforgettable experience.", 4.5, 121, 56),
("Immersive and Addictive", "World of Warcraft is incredibly immersive and can be very addictive. It's hard to stop playing once you start, and the community is always active and engaging.", 5.0, 121, 64),
("A Vast and Engaging World", "The world of Warcraft is vast and full of life. The quests are fun, the raids are challenging, and the community is awesome. It's a game that offers endless hours of entertainment.", 5.0, 121, 72),
("A True MMORPG Experience", "World of Warcraft is the ultimate MMORPG. With a massive world, endless quests, and a huge player base, it's hard to beat. The game has stood the test of time and remains the best in the genre.", 5.0, 121, 80);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Sea of Battles", "World of Warships offers thrilling naval battles with a great selection of ships and tactics. The graphics and detail are amazing, and the game is constantly updated with new content.", 4.5, 285, 9),
("Naval Combat at Its Best", "World of Warships is a fantastic naval combat game. The strategic depth, ship variety, and teamwork make every match exciting. It's a must-play for fans of tactical shooters.", 4.5, 285, 17),
("A Fun Experience", "World of Warships is enjoyable, but it takes some time to master. The battles are fun, and there's plenty of room for growth, though it can feel a bit grindy at times.", 4.0, 285, 25),
("A Bit Repetitive", "While the naval combat in World of Warships is fun, the game can become repetitive after a while. It's still a great game for fans of naval strategy.", 3.5, 285, 33),
("Great Strategy Game", "World of Warships offers great strategic gameplay. The ship customization and the tactics involved in each battle make for a fun and challenging experience.", 4.5, 285, 41),
("Enjoyable, But Needs More Content", "The core gameplay is solid, but World of Warships could use more maps and ships. It's fun, but I feel like it's lacking in content compared to other similar games.", 3.5, 285, 49),
("Naval Action Done Right", "World of Warships is a great way to experience naval warfare. The mechanics are deep, and there's always something new to unlock and explore. Highly recommend it!", 4.5, 285, 57),
("Impressive Visuals", "The game has beautiful visuals, and the naval combat is engaging. However, I wish the progression system was a bit less grindy.", 4.0, 285, 65),
("Strategic Fun", "World of Warships requires both strategy and skill. The tactical nature of each battle makes it highly engaging, though it can be frustrating at times with teammates who aren't as skilled.", 4.0, 285, 73),
("Solid Naval Combat", "While it can get a little repetitive, World of Warships is still a solid naval combat game with great strategic depth and a fun progression system.", 4.0, 285, 81),

("A Thrilling Rally Game", "WRC10 is a fantastic rally simulation game. The handling of cars feels real, and the tracks are beautifully designed. It's a must-play for any rally fan!", 4.5, 91, 10),
("Great Rally Racing", "WRC10 brings the excitement of rally racing to life. The controls are tight, and the races are challenging. It's one of the best rally games I've played in recent years.", 4.5, 91, 18),
("Solid Racing Game", "WRC10 delivers a solid rally racing experience. The car physics are realistic, and the tracks are well-designed. It's a great game for rally fans, though the difficulty can be a bit steep.", 4.0, 91, 26),
("Fun but Frustrating", "WRC10 offers great racing, but it can be frustrating at times, especially with the AI. Still, the thrill of racing on different terrains makes it a fun experience.", 3.5, 91, 34),
("Realistic and Challenging", "WRC10 offers a very realistic rally experience. The tracks are challenging, and the car handling is spot on. It's a great rally game, but it takes time to get used to the controls.", 4.5, 91, 42),
("A Good Rally Game", "WRC10 is a solid rally game, but the learning curve is steep. The gameplay is great once you get the hang of it, but it may be frustrating for beginners.", 4.0, 91, 50),
("Impressive, but Needs More Variety", "WRC10 does a great job of simulating rally racing, but I feel like it could use more variety in the tracks and cars. It's fun, but not groundbreaking.", 3.5, 91, 58),
("Great for Rally Fans", "If you love rally racing, WRC10 is a fantastic game. The tracks, cars, and overall experience are top-notch, though it might be a bit too realistic for casual players.", 4.5, 91, 66),
("Challenging but Rewarding", "WRC10 is a challenging racing game that rewards patience and skill. The physics are spot on, and the tracks are a joy to race on. Highly recommend it!", 4.5, 91, 74),
("Tough but Fair", "WRC10 can be tough, especially for newcomers, but once you get used to the controls and the handling, it's a very rewarding game. Definitely worth playing for rally enthusiasts.", 4.0, 91, 82),

("A Fun Wrestling Game", "WWE 2K23 brings back the excitement of wrestling with smooth gameplay and a lot of customization options. It's not perfect, but it's a step up from previous installments.", 4.0, 286, 11),
("A Great Wrestling Experience", "WWE 2K23 is a great wrestling game with smooth animations and a fun career mode. The controls are easy to pick up, but it's still challenging for seasoned players.", 4.5, 286, 19),
("Better Than Expected", "I was skeptical about WWE 2K23, but it actually turned out to be a great game. The gameplay is smooth, and the matches are intense. Definitely a fun experience for wrestling fans.", 4.0, 286, 27),
("Fun, but Not Perfect", "WWE 2K23 is fun, but it has some issues with the AI and occasional bugs. The roster is solid, and the wrestling is fun, but the game could use some improvements.", 3.5, 286, 35),
("Enjoyable but Flawed", "WWE 2K23 is enjoyable, but there are still some issues with the game. The character models and animations are impressive, but the gameplay can feel a bit sluggish at times.", 3.5, 286, 43),
("A Step Forward", "WWE 2K23 is a step forward for the series. The gameplay is smoother, and there are plenty of new features to enjoy, but there are still some bugs that need fixing.", 4.0, 286, 51),
("Good, But Needs Work", "WWE 2K23 is a good wrestling game, but it's not perfect. The controls are solid, and the game modes are fun, but the AI can be frustrating at times.", 3.5, 286, 59),
("Wrestling Done Right", "WWE 2K23 offers a solid wrestling experience with great matches and customization. It's a lot of fun, but it still has room for improvement in terms of polish and stability.", 4.0, 286, 67),
("Great for Wrestling Fans", "If you're a wrestling fan, WWE 2K23 is a great game. The matches are intense, and there's plenty of content to keep you entertained. It's one of the better WWE games in recent years.", 4.5, 286, 75),
("A Fun Wrestling Game", "WWE 2K23 is a lot of fun, with great customization and solid wrestling mechanics. There are a few bugs, but overall, it's an enjoyable game for wrestling enthusiasts.", 4.0, 286, 83);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("Improvement Over 2K23", "WWE 2K24 improves upon its predecessor in many ways. The gameplay is smoother, the graphics are better, and the roster is top-notch. It's a great choice for wrestling fans!", 4.5, 287, 12),
("A Great Wrestling Experience", "WWE 2K24 is a solid wrestling game. The controls are responsive, and the matches feel exciting. It's a must-play for fans of the series, even though some bugs remain.", 4.0, 287, 20),
("Better Than 2K23", "WWE 2K24 feels like a big improvement over 2K23. The career mode is deeper, and the animations are more fluid. There are still some issues with the AI, but overall it's a fun game.", 4.0, 287, 28),
("Solid, but Needs More", "WWE 2K24 is a great wrestling game, but it still feels like there's room for improvement. The gameplay is enjoyable, but the lack of major new features is a little disappointing.", 3.5, 287, 36),
("A Fun Wrestling Game", "I had a blast playing WWE 2K24. The new features are great, but I wish the game would focus more on improving the AI and less on flashy animations. Still a fun experience overall.", 4.0, 287, 44),
("Great for Fans", "If you're a wrestling fan, WWE 2K24 is a great choice. The action is thrilling, and there's plenty of customization. However, the game could use some polish in terms of stability.", 4.0, 287, 52),
("A Step Forward", "WWE 2K24 is a step in the right direction for the series. The controls are tighter, and the game is overall more polished. I hope future updates continue to improve the experience.", 4.5, 287, 60),
("Enjoyable but Flawed", "WWE 2K24 is fun, but it still has some issues. The AI can be frustrating at times, and there are still some bugs that affect the experience. It's a good game, but not perfect.", 3.5, 287, 68),
("Wrestling Done Right", "The gameplay in WWE 2K24 is solid, and the visuals are fantastic. The game has a lot of depth, but it could benefit from more stability and fewer bugs.", 4.0, 287, 76),
("Fun for Wrestling Fans", "WWE 2K24 is a great game for wrestling fans. The matches are fun, and the new features are a great addition, even though there are still a few minor issues to iron out.", 4.0, 287, 84),

("A Tactical Masterpiece", "XCOM Enemy Unknown is one of the best tactical strategy games I've ever played. The difficulty is high, but the rewarding feeling after a successful mission is unmatched. It's a must-play!", 5.0, 72, 13),
("Addictive and Challenging", "XCOM Enemy Unknown is highly addictive, with deep strategy elements and intense tactical gameplay. It's a fantastic game that will challenge even the most experienced strategy players.", 5.0, 72, 21),
("Tense and Strategic", "XCOM Enemy Unknown is an amazing tactical strategy game. The turn-based combat is intense, and the decisions you make matter. It's not for the faint of heart, but it's an incredibly rewarding experience.", 4.5, 72, 29),
("Challenging but Rewarding", "The game can be incredibly difficult, but it's one of the most rewarding tactical games out there. Every decision feels impactful, and the story is great. Highly recommend!", 4.5, 72, 37),
("A Brilliant Strategy Game", "XCOM Enemy Unknown combines great strategy with intense combat. It's a game that will test your decision-making, and the high stakes make every mission feel meaningful.", 5.0, 72, 45),
("Tough but Fun", "The difficulty in XCOM Enemy Unknown can be brutal at times, but it makes victories all the more satisfying. The game's strategy mechanics are top-notch, and the tension is real.", 4.0, 72, 53),
("A Masterclass in Strategy", "XCOM Enemy Unknown is a masterpiece of tactical strategy. The game's difficulty may scare some away, but those who stick with it will find an incredibly rewarding experience.", 5.0, 72, 61),
("An Intense Challenge", "XCOM Enemy Unknown offers an intense challenge for strategy lovers. The game requires careful planning, and mistakes are costly. It's a fantastic tactical experience.", 4.5, 72, 69),
("Amazing Strategy, Great Replayability", "XCOM Enemy Unknown has fantastic tactical gameplay and high replayability. Every mission feels tense, and every failure leads to valuable lessons. It's a great game for anyone who loves strategy.", 5.0, 72, 77),
("A Strategy Gem", "XCOM Enemy Unknown is one of the best tactical games I've played. The difficulty curve is steep, but the payoff is worth it. The game is deep, challenging, and highly enjoyable.", 4.5, 72, 85),

("Great Team-Based Shooter", "XDefiant brings a fresh take on the team-based shooter genre. The fast-paced action is thrilling, and the variety of characters keeps the gameplay feeling fresh.", 4.0, 288, 14),
("A Fun, Fast-Paced Game", "XDefiant offers fun and fast-paced gameplay, but the character balance could use some work. The matches are exciting, and it's a great option for people who love shooters.", 4.0, 288, 22),
("Good Concept, Needs More Polishing", "XDefiant has great potential, but it feels a bit unpolished. The gameplay is fun, but there are still bugs that detract from the experience. Hopefully, these issues are addressed in future updates.", 3.5, 288, 30),
("A Good Shooter", "XDefiant is a solid shooter with great mechanics. The variety of characters adds depth, but the game can feel a bit unbalanced at times. It's still fun and worth playing if you enjoy team-based games.", 4.0, 288, 38),
("Entertaining, but Needs Work", "XDefiant is fun to play, but it has some balancing issues and a few technical problems. The core gameplay is exciting, but the game needs a little more polish to reach its full potential.", 3.5, 288, 46),
("Exciting but Unfinished", "XDefiant has a lot of exciting potential, but it still feels unfinished. The gameplay is fun, but the lack of balance and stability issues hold it back from being great.", 3.5, 288, 54),
("Great FPS Action", "The FPS action in XDefiant is fantastic. The fast-paced gameplay keeps you on your toes, but the game still needs work in terms of balancing and bug fixing.", 4.0, 288, 62),
("Fun, but Needs Balance", "XDefiant is a fun game, but it feels a little imbalanced at times. The different characters are great, but some of them need better balancing to make the game more fair for everyone.", 3.5, 288, 70),
("A Promising Shooter", "XDefiant has a lot of promise, but it still has a few rough edges. The gameplay is solid, but balancing and bugs are an issue. I'm excited to see where this game goes in the future.", 4.0, 288, 78),
("Fun, but Needs Polish", "XDefiant offers fast and exciting gameplay, but it needs more work. The game is fun, but it's held back by balancing issues and occasional bugs.", 3.5, 288, 86);


INSERT INTO REVIEWS (Title, Comment, Rating, GameID, UserID) VALUES
("A Masterpiece of Storytelling", "Xenoblade Chronicles 3 is an incredible RPG with a gripping story, expansive world, and deep characters. The combat is fun and engaging, and it's easily one of the best RPGs of its generation.", 5.0, 32, 10),
("Immersive and Engaging", "The world of Xenoblade Chronicles 3 is beautifully crafted, and the story keeps you hooked from start to finish. The combat is fluid and strategic, making it an unforgettable experience.", 4.5, 32, 18),
("Epic Journey", "Xenoblade Chronicles 3 delivers an epic adventure with amazing character development and an emotionally charged story. The combat is complex, but rewarding. A must-play for RPG fans.", 5.0, 32, 26),
("Incredible World and Story", "Xenoblade Chronicles 3 has one of the most immersive worlds I've ever experienced in an RPG. The storyline is captivating, and the battles are well-designed. Highly recommend!", 4.5, 32, 34),
("A Truly Stunning RPG", "The gameplay in Xenoblade Chronicles 3 is fantastic, and the narrative is so engaging. There's a lot to explore, and the game constantly surprises you with its depth and charm.", 5.0, 32, 42),
("Deep and Emotional", "Xenoblade Chronicles 3 combines a deep narrative with a fantastic battle system. The world is beautifully designed, and the music is memorable. The characters are well-written, and the story is emotional.", 4.5, 32, 50),
("A Truly Special Game", "Xenoblade Chronicles 3 is a special game. The story is amazing, the combat is deep, and the characters are unforgettable. It's a game that truly makes you feel something.", 5.0, 32, 58),
("Masterpiece of Design", "Xenoblade Chronicles 3 is a design masterpiece. The vast world and the intricate combat system make it an incredibly satisfying RPG. The characters and story are top-tier as well.", 4.5, 32, 66),
("Fantastic RPG Experience", "Xenoblade Chronicles 3 is one of the best RPGs I've ever played. The game offers an emotional and thrilling journey, with plenty of memorable characters and epic battles.", 5.0, 32, 74),
("An RPG Like No Other", "Xenoblade Chronicles 3 sets a new standard for RPGs. It's got an amazing world, brilliant combat, and a story that really pulls you in. It's an unforgettable experience.", 4.5, 32, 82),

("A New Beginning for the Yakuza Series", "Yakuza: Like a Dragon takes the series in a new direction with a turn-based combat system and a fresh protagonist. It's still got the heart of the series, but with a more modern twist.", 4.0, 52, 11),
("A Fresh Take on Yakuza", "Yakuza: Like a Dragon introduces new mechanics that breathe new life into the series. The story is engaging, the characters are memorable, and the turn-based combat is a refreshing change.", 4.5, 52, 19),
("A Fantastic New Direction", "Yakuza: Like a Dragon is a fantastic new entry in the series. The new turn-based combat system is a fun twist, and Ichiban is a great new protagonist. The side stories are as crazy and fun as ever.", 4.5, 52, 27),
("Fresh and Entertaining", "Yakuza: Like a Dragon takes the series in a new direction, but it keeps the quirky side missions and interesting characters that make the Yakuza series so unique. It's a refreshing change.", 4.0, 52, 35),
("Yakuza Like Never Before", "Yakuza: Like a Dragon is a great addition to the series. The new combat system works really well, and Ichiban is a fantastic character. The story is engaging, and the side activities are as entertaining as ever.", 4.5, 52, 43),
("A New Chapter", "Yakuza: Like a Dragon introduces a new combat system that works surprisingly well. Ichiban is a likable lead, and the story is packed with both heart and humor. The side content is also a blast.", 4.5, 52, 51),
("A Reinvented Classic", "Yakuza: Like a Dragon is a reinvented classic. The new turn-based combat system fits perfectly with the series, and Ichiban is a welcome addition. The game retains the humor and charm that made the series so beloved.", 4.5, 52, 59),
("A Perfect Balance of Drama and Comedy", "Yakuza: Like a Dragon strikes a perfect balance between serious moments and absurd humor. The turn-based combat adds a new layer of strategy, and the story is emotional and heartfelt.", 4.5, 52, 67),
("A Bold Move", "Yakuza: Like a Dragon is a bold move for the series. The new protagonist and combat system are a great change, but the game still has all the wild side content you love. Definitely worth playing!", 4.0, 52, 75),
("Yakuza at Its Best", "Yakuza: Like a Dragon is one of the best in the series. The new combat system is fun and strategic, and Ichiban is a character I immediately connected with. The side content is quirky and fun, as always.", 4.5, 52, 83);



-- Insert Categories
INSERT INTO CATEGORIES (CategoryName) VALUES
("Action/Adventure"),
("RPG"),
("FPS"),
("Survival"),
("Strategy"),
("Sports/Racing"),
("Indie Games"),
("Platformers"),
("MMORPG"),
("Party/Casual"),
("Horror"),
("Fighting"),
("Multiplayer"),
("Simulation"),
("Single-Player"),
("Offline"),
("Online"),
("Puzzle/Logic");





INSERT INTO PUBLISHERS (PublisherName) VALUES
("343 Industries"),
("Riot Games"),
("Nintendo"),
("NetherRealm Studios"),
("EA"),
("Gameloft"),
("Microsoft Studios"),
("Rockstar Games"),
("Sony Interactive Entertainment"),
("Sony Computer Entertainment"),
("Ubisoft"),
("Square Enix"),
("Warner Bros. Interactive Entertainment"),
("505 Games"),
("Activision"),
("Konami"),
("Bethesda Softworks"),
("Bethesda"),
("Techland"),
("Bandai Namco Entertainment"),
("Electronic Arts"),
("CD Projekt Red"),
("Larian Studios"),
("Atlus"),
("miHoYo"),
("Capcom"),
("Blizzard Entertainment"),
("ConcernedApe"),
("Re-Logic"),
("Obsidian Entertainment"),
("ZA/UM"),
("Toby Fox"),
("Team Cherry"),
("Motion Twin"),
("Grinding Gear Games"),
("Xbox Game Studios"),
("Warhorse Studios"),
("Focus Home Interactive"),
("IronOak Games"),
("SEGA"),
("Supergiant Games"),
("Stoic Studio"),
("Crate Entertainment"),
("2K Games"),
("Paradox Interactive"),
("Kalypso Media"),
("Wube Software"),
("Ludeon Studios"),
("Frontier Developments"),
("11 bit studios"),
("Bay 12 Games"),
("Rebellion Developments"),
("Shiro Games"),
("EA Sports"),
("2K Sports"),
("San Diego Studio"),
("Criterion Games"),
("Psyonix"),
("Team17"),
("Codemasters"),
("Milestone"),
("KT Racing"),
("Saber Interactive"),
("Crea-ture Studios"),
("Kunos Simulazioni"),
("Maddy Makes Games"),
("Innersloth"),
("Studio MDHR"),
("Moon Studios"),
("Nomada Studio"),
("MegaCrit"),
("Thunder Lotus Games"),
("Nicalis"),
("Andrew Shouldice"),
("Daniel Mullins Games"),
("Playdead"),
("Tarsier Studios"),
("Toys for Bob"),
("Insomniac Games"),
("Retro Studios"),
("HAL Laboratory"),
("Sumo Digital"),
("ZeniMax Online Studios"),
("ArenaNet"),
("Smilegate RPG"),
("Pearl Abyss"),
("Jagex"),
("BioWare"),
("Amazon Games"),
("Sandbox Interactive"),
("Mediatonic"),
("Jackbox Games"),
("Rebuilt Games"),
("Boneloaf"),
("Bloober Team"),
("EA Motive"),
("Frictional Games"),
("Kinetic Games"),
("Arc System Works"),
("Koei Tecmo"),
("SNK"),
("Valve"),
("Thekla, Inc."),
("Monstars"),
("Hempuli"),
("No Brakes Games"),
("ustwo games"),
("Infinity Plus 2"),
("Pine Studio"),
("Microsoft"),
("Microsoft Game Studios"),
("Guerrilla Games"),
("CD Projekt"),
("LKA"),
("Deep Silver"),
("Hello Games"),
("Red Barrels"),
("Starbreeze Studios"),
("IllFonic"),
("Rare"),
("Prime Matter"),
("Endnight Games"),
("Respawn Entertainment"),
("Naughty Dog"),
("Dual Effect"),
("Wargaming.net"),
("Striking Distance Studios"),
("id Software"),
("Mojang Studios"),
("Witch Beam");

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(198, 'Strategy'),
(198, 'Single-Player'),
(198, 'Multiplayer'),
(199, 'Strategy'),
(199, 'Single-Player'),
(199, 'Multiplayer'),
(68, 'Strategy'),
(68, 'Single-Player'),
(68, 'Multiplayer'),
(128, 'MMORPG'),
(128, 'Online'),
(128, 'Multiplayer'),
(142, 'Horror'),
(142, 'Single-Player'),
(142, 'Offline'),
(142, 'Puzzle/Logic');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(97, 'Multiplayer'),
(97, 'Party/Casual'),
(97, 'Online'),
(132, 'Simulation'),
(132, 'Single-Player'),
(132, 'Offline'),
(73, 'Strategy'),
(73, 'Simulation'),
(73, 'Single-Player'),
(166, 'Sports/Racing'),
(166, 'Multiplayer'),
(166, 'Online'),
(197, 'Action/Adventure'),
(197, 'RPG'),
(197, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(193, 'Action/Adventure'),
(193, 'RPG'),
(193, 'Single-Player'),
(192, 'Action/Adventure'),
(192, 'RPG'),
(192, 'Single-Player'),
(194, 'Action/Adventure'),
(194, 'RPG'),
(194, 'Single-Player'),
(196, 'Action/Adventure'),
(196, 'RPG'),
(196, 'Single-Player'),
(195, 'Action/Adventure'),
(195, 'RPG'),
(195, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(5, 'Action/Adventure'),
(5, 'RPG'),
(5, 'Single-Player'),
(94, 'Sports/Racing'),
(94, 'Simulation'),
(94, 'Multiplayer'),
(159, 'Puzzle/Logic'),
(159, 'Single-Player'),
(159, 'Indie Games'),
(167, 'RPG'),
(167, 'Single-Player'),
(55, 'RPG'),
(55, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(9, 'Action/Adventure'),
(9, 'Single-Player'),
(187, 'FPS'),
(187, 'Multiplayer'),
(187, 'Online'),
(188, 'FPS'),
(188, 'Multiplayer'),
(188, 'Online'),
(189, 'FPS'),
(189, 'Multiplayer'),
(189, 'Online'),
(190, 'FPS'),
(190, 'Multiplayer'),
(190, 'Online');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(191, 'FPS'),
(191, 'Multiplayer'),
(191, 'Online'),
(168, 'FPS'),
(168, 'Action/Adventure'),
(168, 'Single-Player'),
(125, 'MMORPG'),
(125, 'Online'),
(125, 'Multiplayer'),
(174, 'Action/Adventure'),
(174, 'Single-Player'),
(219, 'FPS'),
(219, 'Multiplayer'),
(219, 'Online');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(169, 'FPS'),
(169, 'Multiplayer'),
(169, 'Online'),
(170, 'FPS'),
(170, 'Multiplayer'),
(170, 'Online'),
(171, 'FPS'),
(171, 'Multiplayer'),
(171, 'Online'),
(172, 'FPS'),
(172, 'Multiplayer'),
(172, 'Online'),
(173, 'FPS'),
(173, 'Multiplayer'),
(173, 'Online');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(179, 'FPS'),
(179, 'Multiplayer'),
(179, 'Online'),
(220, 'FPS'),
(220, 'Multiplayer'),
(220, 'Online'),
(221, 'FPS'),
(221, 'Multiplayer'),
(221, 'Online'),
(222, 'FPS'),
(222, 'Multiplayer'),
(222, 'Online'),
(223, 'FPS'),
(223, 'Multiplayer'),
(223, 'Online');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(224, 'FPS'),
(224, 'Multiplayer'),
(224, 'Online'),
(225, 'FPS'),
(225, 'Multiplayer'),
(225, 'Online'),
(96, 'Platformers'),
(96, 'Indie Games'),
(96, 'Single-Player'),
(60, 'RPG'),
(60, 'Single-Player'),
(74, 'Simulation'),
(74, 'Strategy'),
(74, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(67, 'Strategy'),
(67, 'Simulation'),
(67, 'Single-Player'),
(12, 'Action/Adventure'),
(12, 'Single-Player'),
(176, 'FPS'),
(176, 'Multiplayer'),
(176, 'Online'),
(112, 'Platformers'),
(112, 'Single-Player'),
(71, 'Strategy'),
(71, 'Simulation'),
(71, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(98, 'Platformers'),
(98, 'Indie Games'),
(98, 'Single-Player'),
(23, 'RPG'),
(23, 'Action/Adventure'),
(23, 'Single-Player'),
(62, 'RPG'),
(62, 'Action/Adventure'),
(62, 'Single-Player'),
(30, 'RPG'),
(30, 'Action/Adventure'),
(30, 'Single-Player'),
(15, 'Action/Adventure'),
(15, 'RPG'),
(15, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(44, 'Platformers'),
(44, 'Indie Games'),
(44, 'Single-Player'),
(202, 'Fighting'),
(202, 'Multiplayer'),
(202, 'Online'),
(155, 'Fighting'),
(155, 'Multiplayer'),
(155, 'Online'),
(177, 'Action/Adventure'),
(177, 'Horror'),
(177, 'Single-Player'),
(178, 'Action/Adventure'),
(178, 'Horror'),
(178, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(140, 'Action/Adventure'),
(140, 'Horror'),
(140, 'Single-Player'),
(14, 'Action/Adventure'),
(14, 'RPG'),
(14, 'Single-Player'),
(31, 'RPG'),
(31, 'Action/Adventure'),
(31, 'Online'),
(200, 'Sports/Racing'),
(200, 'Simulation'),
(200, 'Multiplayer'),
(201, 'Sports/Racing'),
(201, 'Simulation'),
(201, 'Multiplayer'),
(88, 'Sports/Racing'),
(88, 'Simulation'),
(88, 'Multiplayer'),
(42, 'RPG'),
(42, 'Single-Player'),
(19, 'Action/Adventure'),
(19, 'Single-Player'),
(54, 'RPG'),
(54, 'Single-Player'),
(116, 'Platformers'),
(116, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(181, 'FPS'),
(181, 'Single-Player'),
(182, 'FPS'),
(182, 'Horror'),
(182, 'Single-Player'),
(180, 'FPS'),
(180, 'Single-Player'),
(53, 'RPG'),
(53, 'Action/Adventure'),
(53, 'Single-Player'),
(151, 'Fighting'),
(151, 'Multiplayer'),
(151, 'Online'),
(63, 'RPG'),
(63, 'Single-Player'),
(77, 'Simulation'),
(77, 'Strategy'),
(20, 'Action/Adventure'),
(20, 'RPG'),
(20, 'Single-Player'),
(36, 'RPG'),
(36, 'Action/Adventure'),
(36, 'Single-Player'),
(164, 'Puzzle/Logic'),
(164, 'Indie Games'),
(164, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(203, 'Sports/Racing'),
(203, 'Simulation'),
(203, 'Multiplayer'),
(47, 'RPG'),
(47, 'Action/Adventure'),
(47, 'Single-Player'),
(204, 'RPG'),
(204, 'Action/Adventure'),
(204, 'Single-Player'),
(205, 'RPG'),
(205, 'Action/Adventure'),
(205, 'Single-Player'),
(130, 'Party/Casual'),
(130, 'Multiplayer'),
(130, 'Online'),
(21, 'RPG'),
(21, 'Action/Adventure'),
(21, 'Single-Player'),
(206, 'FPS'),
(206, 'Action/Adventure'),
(206, 'Single-Player'),
(207, 'FPS'),
(207, 'Action/Adventure'),
(207, 'Single-Player'),
(208, 'FPS'),
(208, 'Action/Adventure'),
(208, 'Single-Player'),
(16, 'FPS'),
(16, 'Action/Adventure'),
(16, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(209, 'FPS'),
(209, 'Action/Adventure'),
(209, 'Single-Player'),
(217, 'Sports/Racing'),
(217, 'Simulation'),
(217, 'Multiplayer'),
(218, 'Sports/Racing'),
(218, 'Simulation'),
(218, 'Multiplayer'),
(210, 'Sports/Racing'),
(210, 'Simulation'),
(210, 'Multiplayer'),
(211, 'Sports/Racing'),
(211, 'Simulation'),
(211, 'Multiplayer'),
(212, 'Sports/Racing'),
(212, 'Simulation'),
(212, 'Multiplayer'),
(213, 'Sports/Racing'),
(213, 'Simulation'),
(213, 'Multiplayer'),
(214, 'Sports/Racing'),
(214, 'Simulation'),
(214, 'Multiplayer'),
(215, 'Sports/Racing'),
(215, 'Simulation'),
(215, 'Multiplayer'),
(216, 'Sports/Racing'),
(216, 'Simulation'),
(216, 'Multiplayer');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(78, 'Sports/Racing'),
(78, 'Simulation'),
(78, 'Multiplayer'),
(27, 'RPG'),
(27, 'Action/Adventure'),
(27, 'Single-Player'),
(122, 'MMORPG'),
(122, 'RPG'),
(122, 'Online'),
(59, 'RPG'),
(59, 'Action/Adventure'),
(59, 'Single-Player'),
(26, 'RPG'),
(26, 'Action/Adventure'),
(26, 'Single-Player'),
(183, 'RPG'),
(183, 'Strategy'),
(183, 'Single-Player'),
(40, 'RPG'),
(40, 'Action/Adventure'),
(40, 'Multiplayer'),
(51, 'RPG'),
(51, 'Strategy'),
(51, 'Indie Games'),
(234, 'Sports/Racing'),
(234, 'Simulation'),
(81, 'Sports/Racing'),
(81, 'Simulation');



INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(137, 'Party/Casual'),
(137, 'Multiplayer'),
(137, 'Online'),
(28, 'MMORPG'),
(28, 'Action/Adventure'),
(28, 'RPG'),
(28, 'Online'),
(6, 'Action/Adventure'),
(6, 'Single-Player'),
(3, 'Action/Adventure'),
(3, 'Single-Player'),
(226, 'Action/Adventure'),
(226, 'Single-Player'),
(227, 'Action/Adventure'),
(227, 'Single-Player'),
(87, 'Party/Casual'),
(87, 'Multiplayer'),
(87, 'Online'),
(82, 'Sports/Racing'),
(82, 'Simulation'),
(49, 'RPG'),
(49, 'Action/Adventure'),
(49, 'Single-Player'),
(66, 'RPG'),
(66, 'Action/Adventure'),
(66, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(100, 'Indie Games'),
(100, 'Platformers'),
(100, 'Single-Player'),
(123, 'MMORPG'),
(123, 'RPG'),
(123, 'Online'),
(150, 'Fighting'),
(150, 'Multiplayer'),
(150, 'Online'),
(64, 'RPG'),
(64, 'Action/Adventure'),
(64, 'Indie Games'),
(64, 'Single-Player'),
(228, 'FPS'),
(228, 'Action/Adventure'),
(228, 'Multiplayer'),
(229, 'FPS'),
(229, 'Action/Adventure'),
(229, 'Multiplayer'),
(230, 'FPS'),
(230, 'Action/Adventure'),
(230, 'Multiplayer'),
(231, 'FPS'),
(231, 'Action/Adventure'),
(231, 'Multiplayer'),
(232, 'FPS'),
(232, 'Action/Adventure'),
(232, 'Multiplayer'),
(233, 'Strategy'),
(233, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(75, 'Strategy'),
(75, 'Simulation'),
(75, 'Single-Player'),
(235, 'RPG'),
(235, 'Action/Adventure'),
(235, 'Single-Player'),
(43, 'Indie Games'),
(43, 'Platformers'),
(43, 'Action/Adventure'),
(43, 'Single-Player'),
(268, 'Action/Adventure'),
(268, 'Single-Player'),
(39, 'Action/Adventure'),
(39, 'Single-Player'),
(4, 'Action/Adventure'),
(4, 'Single-Player'),
(160, 'Puzzle/Logic'),
(160, 'Indie Games'),
(160, 'Multiplayer'),
(152, 'Fighting'),
(152, 'Multiplayer'),
(152, 'Online'),
(107, 'Indie Games'),
(107, 'Puzzle/Logic'),
(107, 'Single-Player'),
(110, 'Indie Games'),
(110, 'Platformers'),
(110, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(163, 'Action/Adventure'),
(163, 'Puzzle/Logic'),
(163, 'Multiplayer'),
(163, 'Online'),
(131, 'Party/Casual'),
(131, 'Multiplayer'),
(131, 'Online'),
(156, 'Fighting'),
(156, 'Multiplayer'),
(156, 'Online'),
(48, 'RPG'),
(48, 'Action/Adventure'),
(48, 'Single-Player'),
(119, 'Platformers'),
(119, 'Action/Adventure'),
(119, 'Single-Player'),
(236, 'Platformers'),
(236, 'Action/Adventure'),
(236, 'Single-Player'),
(237, 'Platformers'),
(237, 'Action/Adventure'),
(237, 'Single-Player'),
(143, 'Horror'),
(143, 'Puzzle/Logic'),
(143, 'Single-Player'),
(238, 'Multiplayer'),
(238, 'Online'),
(238, 'Strategy'),
(108, 'Indie Games'),
(108, 'Platformers'),
(108, 'Puzzle/Logic'),
(108, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(109, 'Horror'),
(109, 'Puzzle/Logic'),
(109, 'Platformers'),
(109, 'Single-Player'),
(146, 'Horror'),
(146, 'Puzzle/Logic'),
(146, 'Platformers'),
(146, 'Single-Player'),
(124, 'MMORPG'),
(124, 'Action/Adventure'),
(124, 'RPG'),
(124, 'Online'),
(239, 'Action/Adventure'),
(239, 'Single-Player'),
(129, 'Sports/Racing'),
(129, 'Multiplayer'),
(129, 'Party/Casual'),
(240, 'Horror'),
(240, 'Action/Adventure'),
(240, 'Single-Player'),
(241, 'RPG'),
(241, 'Action/Adventure'),
(241, 'Single-Player'),
(242, 'RPG'),
(242, 'Action/Adventure'),
(242, 'Single-Player'),
(243, 'RPG'),
(243, 'Action/Adventure'),
(243, 'Single-Player'),
(22, 'RPG'),
(22, 'Action/Adventure'),
(22, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(18, 'Action/Adventure'),
(18, 'Single-Player'),
(244, 'FPS'),
(244, 'Action/Adventure'),
(244, 'Single-Player'),
(186, 'Indie Games'),
(186, 'Multiplayer'),
(186, 'Online'),
(80, 'Sports/Racing'),
(80, 'Single-Player'),
(29, 'RPG'),
(29, 'Action/Adventure'),
(29, 'Multiplayer'),
(29, 'Online'),
(161, 'Puzzle/Logic'),
(161, 'Indie Games'),
(161, 'Single-Player'),
(184, 'Fighting'),
(184, 'Multiplayer'),
(184, 'Online'),
(147, 'Fighting'),
(147, 'Multiplayer'),
(147, 'Online'),
(185, 'Fighting'),
(185, 'Multiplayer'),
(185, 'Online'),
(245, 'Sports/Racing'),
(245, 'Simulation'),
(245, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(89, 'Sports/Racing'),
(89, 'Simulation'),
(89, 'Single-Player'),
(79, 'Sports/Racing'),
(79, 'Multiplayer'),
(79, 'Online'),
(246, 'Sports/Racing'),
(246, 'Multiplayer'),
(246, 'Online'),
(247, 'Sports/Racing'),
(247, 'Multiplayer'),
(247, 'Online'),
(83, 'Sports/Racing'),
(83, 'Single-Player'),
(127, 'MMORPG'),
(127, 'RPG'),
(127, 'Online'),
(248, 'Sports/Racing'),
(248, 'Single-Player'),
(56, 'RPG'),
(56, 'Action/Adventure'),
(56, 'Single-Player'),
(33, 'Action/Adventure'),
(33, 'RPG'),
(33, 'Single-Player'),
(249, 'RPG'),
(249, 'Action/Adventure'),
(249, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(250, 'Action/Adventure'),
(250, 'RPG'),
(250, 'Multiplayer'),
(250, 'Online'),
(34, 'RPG'),
(34, 'Strategy'),
(34, 'Single-Player'),
(117, 'Action/Adventure'),
(117, 'Platformers'),
(117, 'Single-Player'),
(99, 'Action/Adventure'),
(99, 'Platformers'),
(99, 'Single-Player'),
(252, 'Horror'),
(252, 'Single-Player'),
(141, 'Horror'),
(141, 'Single-Player'),
(251, 'Horror'),
(251, 'Multiplayer'),
(251, 'Online'),
(136, 'Party/Casual'),
(136, 'Multiplayer'),
(136, 'Online'),
(46, 'RPG'),
(46, 'Action/Adventure'),
(46, 'Online'),
(253, 'FPS'),
(253, 'Action/Adventure'),
(253, 'Multiplayer'),
(253, 'Online');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(25, 'RPG'),
(25, 'Single-Player'),
(145, 'Horror'),
(145, 'Multiplayer'),
(145, 'Online'),
(41, 'RPG'),
(41, 'Strategy'),
(41, 'Single-Player'),
(76, 'Simulation'),
(76, 'Strategy'),
(76, 'Single-Player'),
(254, 'RPG'),
(254, 'Single-Player'),
(255, 'RPG'),
(255, 'Action/Adventure'),
(255, 'Single-Player'),
(256, 'RPG'),
(256, 'Single-Player'),
(257, 'RPG'),
(257, 'Single-Player'),
(258, 'RPG'),
(258, 'Single-Player'),
(259, 'RPG'),
(259, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(260, 'RPG'),
(260, 'Single-Player'),
(157, 'Puzzle/Logic'),
(157, 'Action/Adventure'),
(157, 'Single-Player'),
(261, 'Action/Adventure'),
(261, 'Multiplayer'),
(261, 'Online'),
(135, 'Party/Casual'),
(135, 'Multiplayer'),
(135, 'Online'),
(162, 'Puzzle/Logic'),
(162, 'RPG'),
(162, 'Single-Player'),
(262, 'FPS'),
(262, 'Multiplayer'),
(262, 'Online'),
(114, 'Action/Adventure'),
(114, 'Platformers'),
(114, 'Single-Player'),
(118, 'Action/Adventure'),
(118, 'Platformers'),
(118, 'Single-Player'),
(2, 'Action/Adventure'),
(2, 'RPG'),
(2, 'Single-Player'),
(2, 'Multiplayer'),
(2, 'Online'),
(139, 'Horror'),
(139, 'Action/Adventure'),
(139, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(263, 'Horror'),
(263, 'Action/Adventure'),
(263, 'Single-Player'),
(263, 'Multiplayer'),
(264, 'Horror'),
(264, 'Action/Adventure'),
(264, 'Single-Player'),
(264, 'Multiplayer'),
(265, 'Horror'),
(265, 'Action/Adventure'),
(265, 'Single-Player'),
(138, 'Horror'),
(138, 'Action/Adventure'),
(138, 'Single-Player'),
(85, 'Sports/Racing'),
(85, 'Multiplayer'),
(105, 'Simulation'),
(105, 'Strategy'),
(105, 'Single-Player'),
(84, 'Sports/Racing'),
(84, 'Multiplayer'),
(84, 'Online'),
(120, 'Action/Adventure'),
(120, 'Platformers'),
(120, 'Single-Player'),
(266, 'Action/Adventure'),
(266, 'Multiplayer'),
(266, 'Online'),
(13, 'Action/Adventure'),
(13, 'RPG'),
(13, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(93, 'Sports/Racing'),
(93, 'Simulation'),
(93, 'Single-Player'),
(289, 'Horror'),
(289, 'Action/Adventure'),
(289, 'Single-Player'),
(290, 'Horror'),
(290, 'Action/Adventure'),
(290, 'Single-Player'),
(102, 'Strategy'),
(102, 'Single-Player'),
(92, 'Simulation'),
(92, 'Sports/Racing'),
(92, 'Single-Player'),
(92, 'Multiplayer'),
(115, 'Action/Adventure'),
(115, 'Platformers'),
(115, 'Single-Player'),
(154, 'Fighting'),
(154, 'Multiplayer'),
(154, 'Online'),
(267, 'Action/Adventure'),
(267, 'Single-Player'),
(10, 'Action/Adventure'),
(10, 'Single-Player'),
(103, 'Simulation'),
(103, 'Action/Adventure'),
(103, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(133, 'Multiplayer'),
(133, 'Online'),
(113, 'Platformers'),
(113, 'Action/Adventure'),
(113, 'Single-Player'),
(126, 'MMORPG'),
(126, 'RPG'),
(126, 'Online'),
(95, 'Simulation'),
(95, 'RPG'),
(95, 'Single-Player'),
(57, 'RPG'),
(57, 'Single-Player'),
(269, 'Sports/Racing'),
(269, 'Simulation'),
(269, 'Single-Player'),
(269, 'Multiplayer'),
(70, 'Strategy'),
(70, 'Simulation'),
(70, 'Single-Player'),
(70, 'Multiplayer'),
(148, 'Fighting'),
(148, 'Multiplayer'),
(148, 'Online'),
(111, 'Platformers'),
(111, 'Action/Adventure'),
(111, 'Single-Player'),
(153, 'Fighting'),
(153, 'Multiplayer'),
(153, 'Online');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(61, 'RPG'),
(61, 'Action/Adventure'),
(61, 'Single-Player'),
(149, 'Fighting'),
(149, 'Multiplayer'),
(149, 'Online'),
(270, 'Fighting'),
(270, 'Multiplayer'),
(270, 'Online'),
(35, 'Indie Games'),
(35, 'Multiplayer'),
(271, 'Puzzle/Logic'),
(271, 'Single-Player'),
(158, 'Puzzle/Logic'),
(158, 'Multiplayer'),
(158, 'Online'),
(65, 'RPG'),
(65, 'Strategy'),
(65, 'Single-Player'),
(104, 'Indie Games'),
(104, 'Single-Player'),
(175, 'Horror'),
(175, 'Action/Adventure'),
(175, 'Single-Player'),
(272, 'Horror'),
(272, 'Action/Adventure'),
(272, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(273, 'Multiplayer'),
(273, 'Online'),
(38, 'RPG'),
(38, 'Action/Adventure'),
(38, 'Single-Player'),
(144, 'Horror'),
(144, 'Action/Adventure'),
(144, 'Single-Player'),
(274, 'Survival'),
(274, 'Multiplayer'),
(274, 'Online'),
(278, 'Action/Adventure'),
(278, 'Horror'),
(278, 'Single-Player'),
(11, 'Action/Adventure'),
(11, 'Horror'),
(11, 'Single-Player'),
(1, 'Action/Adventure'),
(1, 'RPG'),
(1, 'Single-Player'),
(37, 'Action/Adventure'),
(37, 'RPG'),
(37, 'Single-Player'),
(45, 'RPG'),
(45, 'Action/Adventure'),
(45, 'Single-Player'),
(275, 'Horror'),
(275, 'Action/Adventure'),
(275, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(276, 'FPS'),
(276, 'Multiplayer'),
(276, 'Online'),
(277, 'FPS'),
(277, 'Multiplayer'),
(277, 'Online'),
(7, 'Action/Adventure'),
(7, 'Single-Player'),
(86, 'Sports/Racing'),
(86, 'Single-Player'),
(86, 'Multiplayer'),
(279, 'Horror'),
(279, 'Action/Adventure'),
(279, 'Single-Player'),
(291, 'Strategy'),
(291, 'Single-Player'),
(291, 'Multiplayer'),
(292, 'Strategy'),
(292, 'Single-Player'),
(292, 'Multiplayer'),
(69, 'Strategy'),
(69, 'Single-Player'),
(69, 'Multiplayer'),
(90, 'Sports/Racing'),
(90, 'Multiplayer'),
(90, 'Online'),
(106, 'Action/Adventure'),
(106, 'Single-Player');


INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(8, 'Action/Adventure'),
(8, 'Single-Player'),
(101, 'RPG'),
(101, 'Single-Player'),
(101, 'Puzzle/Logic'),
(165, 'Puzzle/Logic'),
(165, 'Single-Player'),
(50, 'RPG'),
(50, 'Action/Adventure'),
(50, 'Single-Player'),
(17, 'Action/Adventure'),
(17, 'RPG'),
(17, 'Single-Player'),
(17, 'Online'),
(280, 'Action/Adventure'),
(280, 'RPG'),
(280, 'Single-Player'),
(280, 'Online'),
(281, 'Action/Adventure'),
(281, 'RPG'),
(281, 'Single-Player'),
(281, 'Online'),
(134, 'Sports/Racing'),
(134, 'Multiplayer'),
(134, 'Offline'),
(58, 'RPG'),
(58, 'Action/Adventure'),
(58, 'Single-Player'),
(24, 'RPG'),
(24, 'Action/Adventure'),
(24, 'Single-Player');

INSERT INTO GAME_CATEGORIES (GameId, CategoryName) VALUES
(282, 'Action/Adventure'),
(282, 'FPS'),
(282, 'Single-Player'),
(283, 'Action/Adventure'),
(283, 'FPS'),
(283, 'Single-Player'),
(284, 'Action/Adventure'),
(284, 'FPS'),
(284, 'Multiplayer'),
(121, 'MMORPG'),
(121, 'Online'),
(285, 'Action/Adventure'),
(285, 'Strategy'),
(285, 'Online'),
(91, 'Sports/Racing'),
(91, 'Simulation'),
(91, 'Single-Player'),
(91, 'Multiplayer'),
(286, 'Sports/Racing'),
(286, 'Fighting'),
(286, 'Single-Player'),
(286, 'Multiplayer'),
(287, 'Sports/Racing'),
(287, 'Fighting'),
(287, 'Single-Player'),
(287, 'Multiplayer'),
(72, 'Strategy'),
(72, 'Single-Player'),
(288, 'FPS'),
(288, 'Online'),
(288, 'Multiplayer'),
(32, 'RPG'),
(32, 'Action/Adventure'),
(32, 'Single-Player'),
(52, 'RPG'),
(52, 'Action/Adventure'),
(52, 'Single-Player');



INSERT INTO USERS (UserID, Username, Email, DELETEMEClearPassword, PasswordHash, Salt, FirstName, LastName, Role, PhoneNumber, Address, City, DateOfBirth, CreatedAt, UpdatedAt, Status, LastLoginAt, LoginAttempts, Balance) VALUES
(1, "AleniMarco", "marco.aleni@example.com", "[jYVd%$2HRB{vpC)9zvBsLqQFAxRDAY8WGY8U555h//VLVJp9?XXKAPQ4e=dZu3q", "3a9947843db7c3a794705c1157f79e289f899c0c9f5c56cf8c62814c25e65982", "209fe985374f4e56ce22fd2006066a88", "Marco", "Aleni", "User", "3331234567", "Via Roma 12", "Milano", "1985-03-15", "2025-01-17 10:00:00", "2025-01-17 22:22:07", "Active", "2023-06-01 22:00:00", 0, 6975.58),
(2, "CostanziGiulia", "giulia.costanzi@example.com", "ZLB[*M[bS9p7eYP9(cFWr{M7BQA+mgh@a8Dj2sKbY_+mE-^AG.)/rqLtJgAu8qB!", "595840be44a03b5de61ba319eacef606c843024d5a24c38428cdf3fa80406989", "64c39a06461883153a08106371dbe958", "Giulia", "Costanzi", "User", "3332345678", "Piazza Garibaldi 5", "Roma", "1990-07-22", "2025-01-16 14:30:00", "2025-01-17 22:22:07", "Active", "2023-05-28 22:00:00", 0, 2223.56),
(3, "LeonforteLuca", "luca.leonforte@example.com", "e8?9YNZ6@V2A6FN=zy)$h{KZ3@*)T!nU/wA$RQ6=X4EJuxVTvn&Ts{6MDz9%M[Uk", "4f63e9ff013bd0267ef692ead9be998dd6370c99ff89c5201a620bfc4b0bf07c", "93606ffb0a3e84d6d3b63cc15063b747", "Luca", "Leonforte", "Admin", "3333456789", "Corso Italia 8", "Torino", "1982-11-30", "2025-01-15 09:45:00", "2025-01-17 22:22:07", "Active", "2024-03-21 23:00:00", 0, 1571.92),
(4, "SemeraroFrancesco", "francesco.semeraro@example.com", "s3}%M$TD/6^j-V(Q8*?UvJ6{5>}FLxcF2z[P(48DEb>S6s2bMF[NrnmnTY+W5eJ>", "17e24b7c49b6b6656f9bd37dba58c811afe43585d141dd2a597e7f47e69bb0ed", "57da3349db150e5b0fcd209195ef7174", "Francesco", "Semeraro", "User", "3334567890", "Via Dante 20", "Napoli", "1978-02-10", "2025-01-14 16:20:00", "2025-01-17 22:22:07", "Inactive", "2022-07-22 22:00:00", 0, 5285.17),
(5, "SaponaroClaudia", "claudia.saponaro@example.com", "HA7]hh=Z]QP9qXKk$U4U+8y+qdKLQzkbhB?uqa%Hv($HQe*@RCBa9[Uqx&>uB4fd", "8d8398eef901580bb421024b1d9336b5c1436559dd25e3db7f47edfa1b5b1654", "1e37c1659a67e1b71a95963ddf2c5155", "Claudia", "Saponaro", "User", "3335678901", "Viale Europa 15", "Bologna", "1995-06-05", "2025-01-13 11:10:00", "2025-01-17 22:22:07", "Active", "2023-02-22 23:00:00", 0, 1951.82),
(6, "ArgentieriGiovanni", "giovanni.argentieri@example.com", "@X?3gUpH=^D3J?=urr@7k3rn7[Rawsn_3[T$asMT*G*tv7XWS!SZz@s>3qX{AebZ", "f8371e437120cf60db34583a0a51877ba5fa7c5618001c0a1c787268c2918e21", "aefb2615d965b1f121e86ce68bf305d9", "Giovanni", "Argentieri", "Admin", "3336789012", "Via Mazzini 3", "Firenze", "1988-09-25", "2025-01-12 08:30:00", "2025-01-17 22:22:07", "Active", "2023-09-05 22:00:00", 0, 3321.38),
(7, "PrencipeMaria", "maria.prencipe@example.com", "H7NA868hu%*FxV6W3=q@V7z7P.6ju(N*a-cnxKFU^Gcm%=@xEA7v]-j-+QuAc73F", "2494d997481b00643d7f267412fcf298f868989642bf05c9ab7cf6fdffba1b04", "5170347068df1cac495ad60f93699d08", "Maria", "Prencipe", "User", "3337890123", "Piazza del Duomo 7", "Palermo", "1992-12-18", "2025-01-11 17:00:00", "2025-01-17 22:22:07", "Active", "2022-06-04 22:00:00", 0, 8079.35),
(8, "CatapanoAntonio", "antonio.catapano@example.com", "L8X/57)cV9RB_L+kXrp[H[8x!yQWF2]h5G?.v_[g95AR!5v>mN$88EzmV5SCe{tg", "2399e31663501adb7dfb488f6797230574f78dc5a23244adb2e89c50fbb8df35", "67c96142dd5b60b12fdc2cfba7169edf", "Antonio", "Catapano", "User", "3338901234", "Via Verdi 10", "Genova", "1980-04-02", "2025-01-10 14:15:00", "2025-01-17 22:22:07", "Active", "2023-12-05 23:00:00", 0, 6117.95),
(9, "PalumboGiuseppe", "giuseppe.palumbo@example.com", "Zqg6bwFLLp/rsHWNT>9rgwxnSt@2xX}>^%JG2q=q>Ah@eytu}]z?CpMwftfd7@P-", "bcc6b0dc8f10806ecc7a84667fac4e151634b1199d53b0321283629fdae86290", "b156236c92061fba4556192480d2e541", "Giuseppe", "Palumbo", "Admin", "3339012345", "Corso Francia 25", "Bari", "1975-08-20", "2025-01-09 13:30:00", "2025-01-17 22:22:07", "Active", "2023-11-21 23:00:00", 0, 9209.22),
(10, "CavalloAlessandro", "alessandro.porco@example.com", "C@!.p7x8xwgHPn2g{3){XuZn5D9-r>8Ah$XY?KH$HtdBp=V(sgaHJY?KwZ59/hJ&", "522d66a092929b6ebeb286cf34c0c439b5afffc2ebd90987b9886c8557297c44", "795e056bc191213da894c668cede06ca", "Alessandro", "Porco", "User", "3330123456", "Via Garibaldi 18", "Catania", "1990-01-05", "2025-01-08 12:00:00", "2025-01-17 22:22:07", "Active", "2023-05-27 22:00:00", 0, 1717.57),
(11, "GalloFrancesca", "francesca.gallo@example.com", "=2%Daj>4FV4.T6xjt+qv4@E^Ash/r5P$JwKL+.Lzp!nSMZX-G3S_qpSpF[]cq=K6", "723d36eb13ba727e75f61142b6d2b3d8b2b5011792b0217e2d12f30733d3d800", "a91d2811389e9e1f233aefe0bc86371d", "Francesca", "Gallo", "User", "3331234567", "Piazza San Marco 4", "Venezia", "1987-10-30", "2025-01-07 10:30:00", "2025-01-17 22:22:07", "Active", "2023-04-04 22:00:00", 0, 7589.65),
(12, "VolpeLuca", "luca.volpe@example.com", "$*Q+M63m$VXH3*DN8w^P@ffnP?PA+zawZDZDmyTr4Q+.9FE]R3ev8n!Q9xtSC%Uf", "3731d77b2529638fd7e146d28675a55d1e05ccb7ac3b017062f265041683bc55", "157bb96015d1d1aea646ad873673acb8", "Luca", "Volpe", "User", "3332345678", "Via dei Mille 22", "Verona", "1993-05-15", "2025-01-06 09:00:00", "2025-01-17 22:22:07", "Active", "2022-02-26 23:00:00", 0, 413.51),
(13, "LeporeGiulia", "giulia.lepore@example.com", "ueU2[S_dhQn/h+cxJw%a(U2m_jNGSuH+b5+LFmFCH/mX>qtYkRL&[fZ]8HhpgL%S", "e535b7509aed056c934a823c7ff075c47d0e8aca74e73628f66ded50a211ca81", "4b64aa4de1141b61784954a641334380", "Giulia", "Lepore", "User", "3333456789", "Corso Vercelli 10", "Padova", "1991-11-25", "2025-01-05 08:30:00", "2025-01-17 22:22:07", "Active", "2023-10-25 22:00:00", 0, 6274.16),
(14, "LupoMarco", "marco.lupo@example.com", "{D48GHk3s{5[*c*5MXc^Hf}Xp$byf(*r-K>LB^mvruv/.ynTaPWKePBu$yRCt*&x", "985a34f8508e5e20438e32f3b4df3cf027f5d5e5f2352a5f128eae638766055c", "827533de3addebf86b145ba76525bdca", "Marco", "Lupo", "User", "3334567890", "Via Dante Alighieri 8", "Trieste", "1983-07-10", "2025-01-04 17:45:00", "2025-01-17 22:22:07", "Active", "2023-07-20 22:00:00", 0, 9772.17),
(15, "AmmazzalorsoFrancesco", "francesco.ammazzalorso@example.com", "{.$]JpFKcg598N2cB$y]zUNg[p)@}Bh9Rre[a_3/RtsJ_Q{=_d>[VJCTg.YSkkL5", "fae27bebb44ac8ea2d05ab09cbe4b01c5af799e639eb615a6121792035abe1b3", "1d137cd3d48e8ea39b198384ab80cb8c", "Francesco", "Ammazzalorso", "User", "3335678901", "Piazza della Repubblica 12", "Reggio Calabria", "1980-02-20", "2025-01-03 16:00:00", "2025-01-17 22:22:07", "Active", "2022-07-18 22:00:00", 0, 2811.65),
(16, "ScannavaccaGiovanni", "giovanni.scannavacca@example.com", "xBs9kW@x9({L2$t)MtZz2ZJ26PZH_eymVJ9/+*VVkE*Ns%c9tS^uv+.N_HeW]U$9", "72919e0b7ce988979954adc120b9bc5d08e1eff609a2af7606ac59e77093e890", "66d51b3fbd2df2d42abd60cb3a3e037f", "Giovanni", "Scannavacca", "User", "3336789012", "Via Roma 25", "Messina", "1992-09-05", "2025-01-02 14:30:00", "2025-01-17 22:22:07", "Active", "2024-03-04 23:00:00", 0, 4223.31),
(17, "DiMartellaOrsiClaudia", "claudia.dimartellaorsi@example.com", "qEwC4CmycvMgLDEfNg]>X2gyfg)*=Pn[R!f/t$$62Z}d/.J4yj$P4u%vY>SEh%?X", "7ced361c3ec71b62266a83058397a8f79e23ee564df0a70c27c9cac8b7bd00de", "62c29f89b9b5dfb18a2893de74a8f3b0", "Claudia", "DiMartellaOrsi", "User", "3337890123", "Corso Umberto 15", "Cagliari", "1985-06-30", "2025-01-01 13:00:00", "2025-01-17 22:22:07", "Active", "2024-03-26 23:00:00", 0, 9105.39),
(18, "SpaccarotellaAntonio", "antonio.spaccarotella@example.com", "zVWw+_RS3n(Z(6r$5@QbDY!DJvMtTfs)Gq[Rv^_4mc_UbgbQYde6v2K>F[7kE-S]", "39559bddf1d29351d3453af2b22f54a455d22a69b3d7cb6013a71bbb7d7d9f33", "44893578067f76930adf6caee521e1fe", "Antonio", "Spaccarotella", "User", "3338901234", "Via San Giovanni 18", "Ancona", "1990-03-25", "2024-12-31 11:30:00", "2025-01-17 22:22:07", "Active", "2022-12-21 23:00:00", 0, 1558.38),
(19, "AlzalamiraGiuseppe", "giuseppe.alzalamira@example.com", "StE/xSjuWCr4R$-XdK+HKC8Y.XevbejNFX2!2Jyy4$+hwvgGk@N&N_?YKL/%E^B>", "37d4ca234e6d94d070f1113a7f82a79a7278da071ac8a2ee7906f5a8569afa8a", "2f56ad73870354a09a237e0ffabcf7a1", "Giuseppe", "Alzalamira", "User", "3339012345", "Piazza del Popolo 10", "Perugia", "1982-08-15", "2024-12-30 10:00:00", "2025-01-17 22:22:07", "Active", "2024-10-23 22:00:00", 0, 1423.65),
(20, "LupoRosso", "federico.derosa@example.com", "VdQPqV!3N@_7a+aDX^H*6}H6+MdsH4!FVCdwPS*a2jdJ^3p_sgc97*MF(A8Adg%U", "ab9c77052deab072dfeffb111588822ef7b1f376f1062ddb6b729a8db985e922", "70a39bd9b40c3f984bf30af4774e66ff", "Federico", "De Rosa", "User", "3409876543", "Via Dante Alighieri 14", "Milano", "1990-02-11", "2025-01-17 14:00:00", "2025-01-17 22:22:07", "Active", "2023-12-09 23:00:00", 0, 8395.99),
(21, "VentoNero", "giulia.cavalli@example.com", "A{5*]qstKpH!va/}hX9^Cv7R77Lnv[d/Q{LRnj&hJFw(DB>^@HnC.%VYUvWgr>T{", "21d4a0eea1c471614a82925aeab15a054c7e6308194f22df7a1a4c0fa6ad8c1d", "dd8be0fe425c23b16b3ca3b9329fac84", "Giulia", "Cavalli", "User", "3471234567", "Corso Italia 9", "Roma", "1985-06-15", "2025-01-16 09:30:00", "2025-01-17 22:22:07", "Active", "2025-01-09 23:00:00", 0, 8252.70),
(22, "FiammaBlu", "andrea.bianchi@example.com", "kFj.P+Jd$HQcY{D!zyYP.jw&+pE>qBy@mbAzrbVs/Lw?{B*v/^jR4kYYFHMx+H9h", "6db905048c8872aab667421ea2064153da537d256e738884c65447e807e8e78f", "e2c0c68e87bb68951ee80d1ac1998e0a", "Andrea", "Bianchi", "Admin", "3462345678", "Via Garibaldi 22", "Torino", "1991-11-05", "2025-01-15 16:45:00", "2025-01-17 22:22:07", "Active", "2022-10-21 22:00:00", 0, 1229.45),
(23, "SoleLuna", "maria.deluca@example.com", "srWcKAMdLkw7KxvChyqraDQ8DW+^QzSx}V@8.6uDLX/@r[c&Qvcm73x{VTCqY+Q_", "a7abd7db38ce2c70e46fe14b577a236f5f7f7254637f458aba1cff638d372994", "b4c63f7b5facb08acd16a16d21133540", "Maria", "De Luca", "User", "3403456789", "Viale Europa 33", "Napoli", "1993-08-12", "2025-01-14 12:00:00", "2025-01-17 22:22:07", "Active", "2024-09-02 22:00:00", 0, 2112.37),
(24, "NuvolaRosa", "stefano.ferrari@example.com", "T6S6_qUetTBX=+[DvfnjgB-D.r.65/Q9&pfCj.ya[/NuVV*/$L*5zfdE5-KuDrz)", "482ac8371f8085da0f3e9b82640d0c2b3c6581d9a4ebaafa240e06bdd9855c3f", "0664dcd1183fa096c7825d7f7de94650", "Stefano", "Ferrari", "User", "3474567890", "Piazza San Marco 5", "Venezia", "1988-01-25", "2025-01-13 17:30:00", "2025-01-17 22:22:07", "Active", "2022-08-01 22:00:00", 0, 4805.56),
(25, "TempestaGialla", "alessandro.ricci@example.com", "xaQ@mNBXWu2?t)/w+D7yRbHu&s!QY.E*Zb2fHA=3yCF5Uwq-Muh+)nE}WDap5-Uj", "895298f44bfb897622dde81112ef7a50d542d1ae4a8122b84664701e103c3107", "8098a3f5dd4f31c37c59197d12c0cca2", "Alessandro", "Ricci", "User", "3405678901", "Via Mazzini 18", "Genova", "1994-09-18", "2025-01-12 13:00:00", "2025-01-17 22:22:07", "Active", "2023-07-30 22:00:00", 0, 8272.50),
(26, "CieloAzzurro", "elena.russo@example.com", "X_JjPe?{}d/3K7?!q+c+EPtva(dFkXnHjDaB>NWC4z/X*n/Z2srU8Qs}aq9gz$Qb", "e2ae619afdc6f4fca87c06acbf9175ed61e0f1fe01d5d919cd2a0f83516189a2", "fb4ac6034907570028764b5e8a553f31", "Elena", "Russo", "Admin", "3486789012", "Piazza del Popolo 8", "Firenze", "1987-03-05", "2025-01-11 14:30:00", "2025-01-17 22:22:07", "Active", "2024-11-26 23:00:00", 0, 2408.32),
(27, "RaggioVerde", "giovanni.marino@example.com", "vaD$bMuQYhq=pBh5sjhQm*r-un!}uW6yeC}{Fa%t6-+Z]tLhn2h/3{Aygt[@!cF.", "fbff32367b3bbc41015c352201a30885f75a2faa992a1dbcd08ab0d372250fc6", "27c49f6d6d07d804ad44d3eadadac715", "Giovanni", "Marino", "User", "3467890123", "Viale Roma 7", "Bologna", "1990-05-13", "2025-01-10 11:00:00", "2025-01-17 22:22:07", "Active", "2024-09-27 22:00:00", 0, 2152.39),
(28, "MareaAlta", "francesca.lombardi@yahoo.com", "U!xx)h]W$(bxU{8.aCM&da+?R}U_r7H$48hw)DwB9eR(yq4yLj?-HnQG5we!z[WT", "c4a2702e3e8672ea29f9c3d8aa9ca633d25528d5223e1af4b3110595a8c96902", "642c1170a7b9a08f11a9523241bbe90f", "Francesca", "Lombardi", "User", "3488901234", "Via XX Settembre 4", "Palermo", "1982-02-08", "2025-01-09 18:00:00", "2025-01-17 22:22:07", "Active", "2024-10-26 22:00:00", 0, 1036.69),
(29, "FuocoRosso", "luca.palumbo@example.com", "_?$-T5@LMTNPCx$kLrRzeUAa+J=C+-(!Cn/6FRrgdbBu-(2M3xt{9qecQZ!^2T8n", "5fb36215ded663a8c84c38dbcbda5ba902b1970d2d292cbb8e3c2bc007d23509", "5dc5dec459e45313b627b6af301ab59d", "Luca", "Palumbo", "User", "3479012345", "Corso Francia 10", "Catania", "1995-07-30", "2025-01-08 10:30:00", "2025-01-17 22:22:07", "Active", "2022-05-22 22:00:00", 0, 7850.25),
(30, "NebbiaPura", "claudia.basso@example.com", "A_/@t4N?7P?N4)wDgzA!J[%y6-Rrb$9Qxm+UCD@}5X(G%W!n!3GENwJn3.YNKFDE", "3b8193cabc7d599af8898a7b95d70a2c4a134d0cdac66b8f6e333e5dc29661ea", "12e3c4e531865954aad12fb3f785c42c", "Claudia", "Basso", "Admin", "3460123456", "Piazza della Repubblica 6", "Trieste", "1986-11-18", "2025-01-07 15:30:00", "2025-01-17 22:22:07", "Active", "2023-07-27 22:00:00", 0, 3739.18),
(31, "VentoFreddo", "fabio.moretti@example.com", "+Jc=W@GUmnRwHzD4S8xx49{xYp*urHH)uTR9KRyJu4Jy7Ftm>vv?d53?/(w8V*._", "4714df6579c76b7836dda9b782aad78ee2c912eb4f3e5ccf66bfb1343747c1f6", "a3769510c4a02d0b3e506fe994846c73", "Fabio", "Moretti", "User", "3471239876", "Via Roma 14", "Reggio Emilia", "1984-06-22", "2025-01-06 12:00:00", "2025-01-17 22:22:07", "Active", "2022-07-08 22:00:00", 0, 1663.48),
(32, "LunaCrescente", "carla.santoro@example.com", "TB(yb2U]k_n_bQ8BP.Bt*dUJqsrUrBm}$zEs8L/R-bZ26Z_msw6.xmygCt@V$E2!", "8d0075ad31dafb31c0145291bb71f748b34e0574702732cc487004d7e911a4d2", "91836699d2347547fed9da7aa138e2cf", "Carla", "Santoro", "User", "3482345678", "Corso Garibaldi 10", "Bari", "1992-10-03", "2025-01-05 11:00:00", "2025-01-17 22:22:07", "Active", "2024-04-22 22:00:00", 0, 1357.82),
(33, "AriaFresca", "andrea.caputo@example.com", "UpmrRdM>U.tkj}Ca(BM&NMc8T{%Eu$f3LC.jeH>r?FHv%)^*tG$2e[@S2]QU]-v!", "7a320d43040f55b43e4aefcdb2310a893c547afefc3036698bce1332dc088f38", "907f3a9d0454be6a9aad6eba14a84109", "Andrea", "Caputo", "User", "3403456789", "Viale dei Tigli 9", "Pescara", "1991-12-11", "2025-01-04 14:00:00", "2025-01-17 22:22:07", "Active", "2023-09-04 22:00:00", 0, 6797.61),
(34, "RocciaAlta", "francesco.conte@example.com", "JTLA{.2aXv-8-4?(-?Dy36!&j]u.7hURT>.7xFwB$5jKu7GmTDN.w9d2$JjL6_Ez", "ab47b3349f18b0d541aab6b84890cb65f79dba24f6d3dfdaff12749fdae5f9f8", "ff0de5e690d58657ea591e32cfa58107", "Francesco", "Conte", "User", "3465678901", "Piazza Vittorio Veneto 5", "Lecce", "1983-04-20", "2025-01-03 17:30:00", "2025-01-17 22:22:07", "Active", "2022-08-12 22:00:00", 0, 3022.75),
(35, "VentoDiMare", "simona.ventura@example.com", "}.rycy3Dv$}>m.2}cf[dbmXtB=*s*UM{}*@RTMDk+NG9}Wf5Fkbr-!mZHLuQ4)%Z", "6163babd357e0d182732ae6cfcdbd5550233a4267b1dd58a59be82dfc68f907c", "e9da382f51be1948e61fa40f9738145e", "Simona", "Ventura", "User", "3476789012", "Via San Giovanni 11", "Messina", "1994-01-15", "2025-01-02 10:30:00", "2025-01-17 22:22:07", "Active", "2023-02-23 23:00:00", 0, 457.49),
(36, "AcquaTurbina", "salvatore.esposito@example.com", "E7jCTq*h=ec>(fJEC2Q@AR{Fpj?ZyTPDv5u=@UQ$Qghz?z2SpDj)eW?SAqS.H5[V", "4f76fc289aa5a24e9eb1c985d85e65a1ce9af0f83a4da5b2c54b1a297b1f8b0e", "bb37caa2a1fe05a4d6f81e9d3e18f537", "Salvatore", "Esposito", "Admin", "3487890123", "Piazza del Duomo 2", "Siena", "1989-03-12", "2025-01-01 14:30:00", "2025-01-17 22:22:07", "Active", "2022-03-23 23:00:00", 0, 6067.48),
(37, "NeveCandida", "maria.galli@example.com", "e[+jb8$SHu%f[u{VZDx{s/2j..!qZHZ]uE]7FnMr^j.yJ^3[EahWK>NLV5+tL9ru", "cf8e7f034af256a8b1ce44625d3e123124e80a31f533a7547ce36fe8bc50a56c", "f9df067972b4de581e936308a15f3d3c", "Maria", "Galli", "User", "3468901234", "Via della Libertà 7", "Livorno", "1991-06-17", "2024-12-31 11:00:00", "2025-01-17 22:22:07", "Active", "2024-01-20 23:00:00", 0, 319.74),
(38, "TempestaBianca", "giuseppe.ricci@example.com", "A%3hN_r^Swjk8[g!WT>pzuJhp{XSbZjkM4@7DrhvADHKP=2+b.5UrP=p%Mx6g$>T", "a97304e992fed78f5655d2fdf2495c1dc7115e428c1335a7e1931434d50526ee", "781b8de4c39b9de4c28f4ec16bfb2479", "Giuseppe", "Ricci", "User", "3479012345", "Viale Verdi 9", "Vicenza", "1987-10-01", "2024-12-30 10:15:00", "2025-01-17 22:22:07", "Active", "2023-03-12 23:00:00", 0, 9432.90),
(39, "MisteroNero", "luigi.marini@example.com", "tU}DKM=*!@[*uzX9pHu]{4UW2u&44jP$2j.C.T]nuQ_3?Qh4@=AuHgA*b@.U8+LZ", "8f7b6d64b156c2b43dbb878a40af6c430e5fd528137b5b5ebb28f5669bf9553b", "6e29b8fe9ae96cc3e15afa83a7075d05", "Luigi", "Marini", "User", "3480123456", "Piazza della Vittoria 3", "Como", "1992-02-24", "2024-12-29 14:00:00", "2025-01-17 22:22:07", "Active", "2022-06-05 22:00:00", 0, 6462.68),
(40, "FuocoBlu", "rita.luzzi@example.com", "+$j)UY_Ks^U.XbRbwBn]kGPj>dCwY2d4]DvP4M9S?k4KB+w3PsuEgPwRK6G/=8$Y", "0fc963867523bf081642239a3d0e09ff2e8ae46dfb54d88da29b9a211ddb9861", "ea6075c3e7164eed176544b0c757c6ee", "Rita", "Luzzi", "Admin", "3401234567", "Corso Umberto 8", "Cagliari", "1993-11-18", "2024-12-28 16:30:00", "2025-01-17 22:22:07", "Active", "2023-12-04 23:00:00", 0, 9522.27),
(41, "SoleDorado", "mario.fabbri@example.com", "ebEkKDz9hF=j%rJb=T[Q3%NYV5*JhyUb[*r^K44mTk??N(Aafz&}>DC7B>4uHQG-", "7a3510d64f723a420922988ea9e2c256971f4b6c5219b0ae45547668a60cc4c6", "69e8f44788a4b50d3b67628a260a41f4", "Mario", "Fabbri", "User", "3472345678", "Via dei Mille 12", "Reggio Calabria", "1986-05-10", "2024-12-27 10:00:00", "2025-01-17 22:22:07", "Active", "2024-08-26 22:00:00", 0, 267.56),
(42, "EcoVerde", "simona.giordano@example.com", "$sX3E)&rQX.29Q&J5+Ya*jJVjNBxXEvpaeM?.]}355$[]Sn9VKN5!^3LpM])@nH9", "3d7b135dbc9af71f60aa03a5b1f605e08cc1926718f8aef2611da995f2419725", "59643346ccf381c2471bd297e4d889f9", "Simona", "Giordano", "User", "3474567890", "Via Roma 22", "Brescia", "1990-08-05", "2024-12-25 12:00:00", "2025-01-17 22:22:07", "Active", "2024-08-12 22:00:00", 0, 9733.54),
(43, "SqualoArgento", "roberto.martini@example.com", "H]8$$2Y%8h4rr)D^G>$[Xp2)P9RdJvhs.K2u(BdymcFNZyyrg7XAKC{p6BcN](e_", "d8b71aa38a7c58a099652bb563a67172e2bbe2b9771d79607cfc2bbd85ed5dd8", "3b06a8f1bdb2b6f41d5cf40d5b588625", "Roberto", "Martini", "User", "3409876543", "Viale del Mare 20", "Napoli", "1989-12-02", "2025-01-17 14:00:00", "2025-01-17 22:22:07", "Active", "2023-12-24 23:00:00", 0, 5226.83),
(44, "PianetaBlu", "cristina.lazzari@example.com", "9&vMWZ-n]Q88NV{xu-3$4EGYGhz4]z6{qR*>Qv48W4&&n&CKQMvY$Jz4dV4Zs>AP", "c8a9a38ad95e97e0dbc115c63e62cd0d860b0831b6802c297ff1f404783a4ddb", "dca46ea421577d388600d438a58c24c1", "Cristina", "Lazzari", "User", "3471234567", "Via Mazzini 18", "Torino", "1992-05-25", "2025-01-16 09:30:00", "2025-01-17 22:22:07", "Active", "2024-07-27 22:00:00", 0, 958.56),
(45, "VentoSelvaggio", "luca.santini@example.com", "aVq4%Xx+D}ET9ALBnE)cFh%?yT_cwPwb]5!eD[3V@&)HY}UZefN&LDzeJ@+9{wdZ", "529167e29ace8974f31ba5906eb6526e9e2c38bf5f64ef4e745064eef469387f", "65f221f65eec239fa5aa8135ba63943e", "Luca", "Santini", "Admin", "3462345678", "Corso Venezia 12", "Milano", "1988-03-11", "2025-01-15 16:45:00", "2025-01-17 22:22:07", "Active", "2023-12-05 23:00:00", 0, 9884.40),
(46, "NebbiaSottili", "giulia.barbieri@example.com", "j5ZX%pT7ehTmQ2ndP2%)7!}@DuDSq%Tq=Tjuy8y>U*bV%u/b^k6Cc^@!7+4>z/LY", "fd5eb304eba419e19e1cb4e7f9300b52a1c33df4d42d987421572c2b3220f092", "42a565651746923009fa324c1e2a566b", "Giulia", "Barbieri", "User", "3403456789", "Piazza della Libertà 8", "Roma", "1994-01-17", "2025-01-14 12:00:00", "2025-01-17 22:22:07", "Active", "2023-02-10 23:00:00", 0, 7218.98),
(47, "CacciaOscura", "matteo.pietroboni@example.com", "?53XS*$U{?jXf/HktG)^V]mH&/%N^QV9/B[p?3ya*$ww}7)fc[$7Myaw*v?*rug)", "d1d2eb664f4e80ac762eb11d6d91d3f09f0d366f908dfb4135fe27bac645cb9a", "3a48863a3e1ba04b1475f4eab2ea3cbf", "Matteo", "Pietroboni", "User", "3474567890", "Viale Europa 33", "Genova", "1991-08-03", "2025-01-13 17:30:00", "2025-01-17 22:22:07", "Active", "2024-05-24 22:00:00", 0, 139.03),
(48, "CieloGrigio", "elisa.carmine@example.com", "G%KE+.fxQ=Nkzw=s?ar_2&6rK8e6L{k.)nTN]((YFjD&3gbSV3_]nfkftn9FKKU8", "850889a618df96bfc4e42b0c370ee8740090f7b77cca0a51786fd66905f5dd58", "74864d277f0f5e462d44032597ada4a4", "Elisa", "Carmine", "Admin", "3465678901", "Via Roma 25", "Firenze", "1987-10-15", "2025-01-12 13:00:00", "2025-01-17 22:22:07", "Active", "2025-01-04 23:00:00", 0, 7261.02),
(49, "RaggioDiFuoco", "giovanni.bianchi@example.com", "(6kM*Eb_G&t$/AnXFE7}TPB_BJ$vUVS+HXk^9r@e4.mq%%TNE&_/m@J+anH8_V-/", "6d69330c8ec86e0545aa8e545c5687411f20f0be5b36ed66e4284653621634bb", "4892f3bb8065ea5eab7c667624957649", "Giovanni", "Bianchi", "User", "3486789012", "Corso Italia 9", "Venezia", "1990-02-27", "2025-01-11 14:30:00", "2025-01-17 22:22:07", "Active", "2023-10-05 22:00:00", 0, 3464.30),
(50, "TempestaAzzurra", "rita.gagliardi@example.com", "bHMSR53XBZ9/>Aem5x-D$7y%9mh]gPe9Cx!.vFQ7mD6>qcsZ^g*VGPuT+Y)L[.yS", "f07c39def74d71d7c83500a2dccd45ae6f3947073f49e05730f9d9cbf6278b7e", "045cabc25aec15efe99833939d0f9255", "Rita", "Gagliardi", "User", "3405678901", "Viale dei Tigli 18", "Bologna", "1986-11-08", "2025-01-10 11:00:00", "2025-01-17 22:22:07", "Active", "2023-07-23 22:00:00", 0, 8594.20),
(51, "MareInTempesta", "loredana.monti@example.com", "upVJ5ebfewES=rkDQ_NSVJza[ycR5AB@.-C88bxk>}gw+5AMt%K2/7z3+yL$=4sx", "c19eb5c591c71d0501f7d2709e116cc493fa928bdc88b677e782044c92638716", "df312fd7339226b0d34def62ef335177", "Loredana", "Monti", "Admin", "3479012345", "Piazza Cavour 7", "Palermo", "1992-04-19", "2025-01-09 18:00:00", "2025-01-17 22:22:07", "Active", "2023-01-13 23:00:00", 0, 4.84),
(52, "FiammaViva", "claudio.sassano@example.com", "DUb67Zx=8w9NJVT/YuN.UP>_M/r3[@>qpEj2xCZ?-}HTF.-*UkG-7F(kS95]m!mV", "48aa5a384fd2e94aaae8a250d46a811938f8fcd8e39735f0019b873aa593f61f", "02d431884f2f7bbfd3949b8125d8fe23", "Claudio", "Sassano", "User", "3487890123", "Corso Umberto 10", "Catania", "1994-12-01", "2025-01-08 10:30:00", "2025-01-17 22:22:07", "Active", "2024-08-04 22:00:00", 0, 2598.45),
(53, "AlbaRossa", "francesca.lombardi@example.com", "X_QGRzKQ&+SvJBvJ%u2]4XRd$S-y4jR&ExrY^HY=hm^!?pM=cxU4c+B9SaB&^2Wk", "e6eef53fd0254827999bb349b2591da74080c7083c8aae9820a6856fda854ce6", "c3f5dbb196897359dad85bdd7fd4ca5b", "Francesca", "Lombardi", "User", "3460123456", "Piazza San Giovanni 3", "Trieste", "1989-07-21", "2025-01-07 15:30:00", "2025-01-17 22:22:07", "Active", "2022-04-20 22:00:00", 0, 2615.21),
(54, "CorvoNero", "riccardo.giordano@example.com", ">]!6=yXcjJUupdU(=9SV3>8YXLg4_r>k_a2LYgv_U>.WQU]vZgp($e{k$GD.37%%", "20f608fcb5bf1e0004773a7e8990396debe96dd6f2e4f70cd78a393bc31ca448", "7e96b542f653edfc83296d48710d8a4f", "Riccardo", "Giordano", "User", "3472345678", "Via Pio IX 14", "Livorno", "1990-04-22", "2025-01-06 12:00:00", "2025-01-17 22:22:07", "Active", "2022-11-01 23:00:00", 0, 4001.38),
(55, "OcchioDiFalco", "silvia.castellani@example.com", "!U=bty$LDehz=tDVtp$utng3shRjeHJUx?j2JmW+$d%ahB*EQgy9RB$jge?6E?kc", "a5d2d5a7c71aa4844ffc915136f194ed12cbc8b9d7866db7eaa0731f96c9df27", "fc9f8de55b0267fd773154319a2d8f30", "Silvia", "Castellani", "User", "3473456789", "Corso Mazzini 5", "Brescia", "1992-11-05", "2025-01-05 11:00:00", "2025-01-17 22:22:07", "Active", "2022-09-07 22:00:00", 0, 5677.65),
(56, "LunaPiena", "carlo.ricci@example.com", "uWs8A+Mt5WRk=7[BbDN$Wm3Xsm=fkgV>=PmHR25p=q5CaE*>)nRjC$x>_x&XzN{r", "7cb5e9a2dadfa2160aa96fd607fd9946c0913c4e9b4c46a3cf027b3a6170c3cf", "b9da641b6fbdc557b4fe90bf797743fd", "Carlo", "Ricci", "Admin", "3402345678", "Via Matteotti 20", "Reggio Emilia", "1985-08-13", "2025-01-04 14:00:00", "2025-01-17 22:22:07", "Active", "2022-05-18 22:00:00", 0, 5973.86),
(57, "SoleDoro", "alessandro.ferraro@example.com", "/HV&GkWS(-q+@txTk53_g.ug/9(NeGf_.s]X@$>zeXq}^Y47R*(Es2-VsH_P{(Nn", "e28b50598acdffef3fb104ad7ade133daa41feed31e36e1d53bb144546dadafa", "709d04e0f1d50351c25a2aee5cd72b4d", "Alessandro", "Ferraro", "User", "3481234567", "Viale dei Fiori 12", "Ferrara", "1991-06-18", "2025-01-03 17:30:00", "2025-01-17 22:22:07", "Active", "2023-03-13 23:00:00", 0, 3945.77),
(58, "FruscioSilenzioso", "elena.dimauro@example.com", "U{N?yv?b$_R_J]PujwQ_=QR_%{.jL7cbM.F}Yfvch8>h]VP-8JmQ5PPchX-ww/=S", "3a933aaf18e77c2494665f9aa246d6f28fba33afdb50c7fc6e570973afd62825", "6c6fce58fbb4c69171746d0270878990", "Elena", "Di Mauro", "User", "3475678901", "Via Torino 9", "Siena", "1988-02-28", "2025-01-02 10:30:00", "2025-01-17 22:22:07", "Active", "2022-06-21 22:00:00", 0, 792.50),
(59, "TempestaLuminosa", "giorgio.mancini@example.com", "GqQ[?G!}R]8B_WMVJuYbe(5D&({2WG!%UPWzgH5g{nRwJdE>qER_szhBD*9TMPqP", "3e726a5952764246f6ec01d280c71023b398678fdd0e5e28d7158eb9315bed4b", "0bc0c959f33d506463dd2f8a3d5ee1c1", "Giorgio", "Mancini", "User", "3486789012", "Piazza San Marco 3", "Vicenza", "1993-05-24", "2025-01-01 14:30:00", "2025-01-17 22:22:07", "Active", "2023-02-03 23:00:00", 0, 7138.80),
(60, "FiammeVerdi", "luca.ventura@example.com", "&TRue2HSP!t-8qrJvP}RkHBPKrm?895cVZ]CvwP(T-yXeX@K(=C3SFyQDL>TUxmw", "022f9864159f55cdf80a6bf442797e4fc63fc00e13722956ad00a0634b2d109e", "16640109969babc9d7086359311f4633", "Luca", "Ventura", "Admin", "3467890123", "Via Dante 5", "Messina", "1990-01-09", "2024-12-31 11:00:00", "2025-01-17 22:22:07", "Active", "2024-05-22 22:00:00", 0, 5109.77),
(61, "SognoBianco", "martina.desantis@example.com", "g7Vds^8S4dQBbK+SFT8^=3-k!yh+CE!ss^ab}nD{VXCguWTBybR?7C}uuRh-x-RC", "5ff76440885a1dbe6deb03563467875081a7eae69e36bce8b5dd87ecb9c8282f", "4fff30e9d26291fcbbc7b30a74820502", "Martina", "De Santis", "User", "3408901234", "Corso Francia 10", "Cagliari", "1984-12-15", "2024-12-30 10:15:00", "2025-01-17 22:22:07", "Active", "2023-01-21 23:00:00", 0, 7093.66),
(62, "EclissiTotale", "stefano.deluca@example.com", "x}f92yKBw@xn43))rDa6K_Z46zZeMj)3j3vcMFJh@KYzy5gtMeb7DNuZbXX89{Sd", "60d4bc08147ed611b39a41f68743d67624dd18e013d1bbcddc5d7b7ccd43c1b4", "01202a680c0e632dca47a8d0a4f0aa90", "Stefano", "De Luca", "User", "3489012345", "Piazza della Repubblica 4", "Vibo Valentia", "1991-10-22", "2024-12-29 14:00:00", "2025-01-17 22:22:07", "Active", "2022-10-25 22:00:00", 0, 3209.33),
(63, "StradaDellaLuna", "valeria.santoro@example.com", "%s*]xCtmDr(U%&2Nw/_q99Kh@bqmK$4=9ra]Ly&fs!*>WY3)S-7{_M29KfegczhS", "fa3a525f72c2c33ec2a7e9e20c1eb73d52235e83fb598934e85cf2c64e5fd865", "a3fe4b3d9ac31e58fc349e6d13b8df3d", "Valeria", "Santoro", "User", "3400123456", "Viale Europa 3", "Reggio Calabria", "1992-02-05", "2024-12-28 16:30:00", "2025-01-17 22:22:07", "Active", "2023-09-29 22:00:00", 0, 7965.27),
(64, "NebbiaChiara", "francesca.luciani@example.com", "$$CS@a%!mC)b[(K_)qQ$^3+E)F.>2J^USZ.m5u@e]8Aze/Kd]bz^pL(K*c+gGGL7", "17483c775788973d52c2993a3b8dfbf82b6fa5157814a1824d32042804ad1748", "a9d9338ceae503b2140d185520cd6bc7", "Francesca", "Luciani", "Admin", "3472345678", "Corso Italia 6", "Bologna", "1989-05-19", "2024-12-27 10:00:00", "2025-01-17 22:22:07", "Active", "2023-10-12 22:00:00", 0, 7547.50),
(65, "OmbraLunga", "nicola.toscano@example.com", "QDq(a.EErc2gtKMEQww!c].qkZdBte_k?&beJM+EH!zdD9qxzk(CHG7^.4&kbFu>", "5ad5fc66d543a009be14b501a15cd092b3a25a4b1735769e2a0f129f16573d1b", "eceb1c48a1874ca3eaa00e40242fb906", "Nicola", "Toscano", "User", "3482345678", "Via Dei Mille 7", "Livorno", "1986-09-04", "2024-12-26 13:30:00", "2025-01-17 22:22:07", "Active", "2023-07-09 22:00:00", 0, 382.68),
(66, "VentoDiFuoco", "alessandra.giannini@example.com", "n(&PWB&Jxsxb-A]mb78$q^Db.ATzKXtUNU%-{eEhetwHw5hHXDNLc*92q2D2UvRt", "28e3d74408bb74f1f595d0ed5406e079ad1566fcb6b53f3e374e44a58fe44ff3", "5c8c6d3aa22d07cdd5f54de3e9598bfa", "Alessandra", "Giannini", "User", "3467890123", "Piazza della Vittoria 12", "Perugia", "1993-03-30", "2024-12-25 12:00:00", "2025-01-17 22:22:07", "Active", "2022-12-02 23:00:00", 0, 8257.50),
(67, "GokuFury", "matteo.rossi@example.com", "W{NHdNb]2+CE{Mp9[2a^vy25j-t&@/@>U/6ZeG6ArrTf]gF+%ykPWS&dnEJ475jh", "89cf348e0d5acd04864e2acd811acc021e96dee8b4872aeb8e8347f7a3c6b75a", "b38e9d27ac01b24ed63c05cccc1dfd8a", "Matteo", "Rossi", "User", "3401122334", "Via Monte Nero 21", "Roma", "1998-11-15", "2025-01-17 09:00:00", "2025-01-17 22:22:07", "Active", "2024-11-25 23:00:00", 0, 2827.19),
(68, "NinjaTobi", "andrea.bianchi@yahoo.com", "W[n+6$XY$etMq=4UZSbjyP-_$>zfgv3!c9f2Q[Qx{q.G_)n7@^6f&e^UFgnwwjPR", "d267de460357341d8db199454ba13d8079b70fb28e7a217c94fdd6698de59d6f", "25e9646c2067987f80fad3d169026b17", "Andrea", "Bianchi", "User", "3472233445", "Corso Italia 15", "Milano", "2000-06-22", "2025-01-16 10:30:00", "2025-01-17 22:22:07", "Active", "2023-09-02 22:00:00", 0, 8325.53),
(69, "ShadowXx", "luca.migliori@example.com", "-t_W)KBqQeYB_xd2Ceq_JYd+pvQU]{w2j^Sf+vC/J!X?dgZRn>DZ[j!Ps&fBc=ag", "d568cfeac9a46d1c0920708044bd1b18796b22104fbcfcdb95363003f09e1dda", "5224b341fb21b25f515bc8e8dec17b31", "Luca", "Migliori", "User", "3463344556", "Via Garibaldi 3", "Napoli", "1999-02-10", "2025-01-15 14:00:00", "2025-01-17 22:22:07", "Active", "2023-09-22 22:00:00", 0, 1180.12),
(70, "ZorroKing", "giuseppe.dipietro@example.com", "?Sugt$vQ&{4g6zjC7qE(MbAUvqaqNn-NX/Xq3Fp)7@bxzgC*!9A)xf-Ey){&9RVp", "beaf54bf2e18c4443ca857d3c0ecbdff3cf54e4bd2aa775c7f6ef9d7a9b9123b", "4a62335cb9b31d8e1b62923b9eb4fefe", "Giuseppe", "Di Pietro", "User", "3484455667", "Viale Marconi 9", "Firenze", "2001-03-05", "2025-01-14 08:45:00", "2025-01-17 22:22:07", "Active", "2024-07-08 22:00:00", 0, 5577.00),
(71, "PixelRider", "antonio.sartori@example.com", "sYNcd6}&tguuG/6$y&m>L{N6!nCU^%HwMLZSeUww%sv=kBQL4TVU/QF=!=uAf]5Y", "97f30b059338e1b208817c1ea0ede616f6494d1652ac5f6f96181de33866ebda", "5eed9b5a239aa32d794921a939c0fd1a", "Antonio", "Sartori", "User", "3405566778", "Via dei Mille 8", "Torino", "1997-08-19", "2025-01-13 11:15:00", "2025-01-17 22:22:07", "Active", "2023-06-19 22:00:00", 0, 5444.96),
(72, "MegaByteX", "davide.lombardi@example.com", "-V)GaxgVBmb-w$[^L]ccTh7TrUPPs*7m&L54u9H3W@3X%e6/D28h9L6(DQ)Kp*?c", "af8e0cfbc6f34fd76baf2635327ac38d1656b124456704a0f6e18593d1805c6e", "699e992a6534c248bf92043548c0c564", "Davide", "Lombardi", "User", "3466677889", "Viale dei Giardini 25", "Bologna", "1996-09-29", "2025-01-12 17:45:00", "2025-01-17 22:22:07", "Active", "2023-07-24 22:00:00", 0, 8946.63),
(73, "IceWolf9000", "marco.conti@example.com", "2PWSP+MP(@[XHKE]B*VJ8k>_rLhK!+hWvAfY/JxV/^kJ^)GGaXj/L7qB4b$x_gkw", "ea7a04673207d0f353cddde4c9ef687a5ae96805142bdb201aa920f6e2c09893", "6c5d867bf159a494366685c00520f47e", "Marco", "Conti", "User", "3477788990", "Piazza Duomo 16", "Venezia", "2002-04-14", "2025-01-11 13:30:00", "2025-01-17 22:22:07", "Active", "2022-08-07 22:00:00", 0, 4896.33),
(74, "FuryRaptorX", "giulia.gatti@example.com", "T9=.2yv.{9>$_gV))){!tjskMJmmX[AbuzvVk_^7xYhVS}WM^/4[+&MU>G5-rgt)", "df49c1312d9a9335e27c767612e62db8c591a4230a97963951ed7ee33b638e38", "542e7d88c7f71e4cca7274b2a612445c", "Giulia", "Gatti", "User", "3488899001", "Corso della Libertà 11", "Catania", "1998-12-09", "2025-01-10 12:00:00", "2025-01-17 22:22:07", "Active", "2023-03-09 23:00:00", 0, 5861.29),
(75, "DarkPhoenix_", "riccardo.valente@example.com", "_Q4@$}6792MJkdRq-JWNLmz>)c]KaC[&K&rG+AA-Q8RAhD[VBJGs&(Us(Ap[CcT6", "5a497303e4117411e30782ca4c619225e71c02bfcf65c78f4a5728acf45b0b5d", "ac4f4de2c6b34e0eedb3015c83f2bc94", "Riccardo", "Valente", "User", "3409900112", "Via Pio IX 22", "Palermo", "2000-02-18", "2025-01-09 15:30:00", "2025-01-17 22:22:07", "Active", "2024-12-08 23:00:00", 0, 4059.57),
(76, "DragonFlare23", "alessandro.cavallo@example.com", "TW+AAe92E+2^C4zLEpUpf{F^pF7YPu_n_Cn-YaR&mY&s=HQxt/s%9wgknH(hwLz*", "a47ef4d3c7cf8ac8e7b6a399cd562567300e78223d76dd5ed42bc48de9891a9d", "d12ab55c36d8c9357c912006846c2c6c", "Alessandro", "Cavallo", "User", "3470011223", "Piazza della Repubblica 14", "Milano", "1995-11-27", "2025-01-08 14:00:00", "2025-01-17 22:22:07", "Active", "2023-02-22 23:00:00", 0, 4063.37),
(77, "JediMasterX", "francesca.marino@yahoo.com", "fvxCnHHgP)T8FA(^e)DWxPw*p(7.r?Bgza[dVcQ/dwtd(pPKZN/VtUC)=eu%TD![", "df84af96c3a706f0c67ff1145d50de77b0cc9ba273b7995af81d2d1dd61e79b5", "0090f457658d9c33faa1a49c09a8375f", "Francesca", "Marino", "User", "3461122334", "Viale Europa 19", "Napoli", "1999-10-04", "2025-01-07 09:45:00", "2025-01-17 22:22:07", "Active", "2024-08-13 22:00:00", 0, 6917.56),
(78, "Th3_RealBeast", "stefano.sofia@example.com", "6w{U(6kHQ_Yu%d+@xKDLTg$Ws/yfeUcum.vjWbVpuba%_V%_zsY$d$K*hq>V&H6z", "6f5b39c1de6c712ff4bfc5c65cbe0890a8b09a7f181b003b47b26042ed0ec610", "c2a9d842add846027ca918289ad7e4c3", "Stefano", "Sofia", "User", "3482233445", "Via Roma 3", "Firenze", "2001-01-18", "2025-01-06 17:30:00", "2025-01-17 22:22:07", "Active", "2022-08-06 22:00:00", 0, 5759.72),
(79, "GhostInShell_", "claudia.ricci@example.com", "s]s%=d*(>DF48^YQMgr-PaBZ_F2@[2nwtrth*82+GFNW{{57CUqwdQXb{C9u}/+P", "04a2fc99c11b3e325bced41dcc0829e1ebc093b623aada3a8bd4dc633b8fbc25", "10ffa67218cb9bf09b3fafb84b9816fc", "Claudia", "Ricci", "User", "3463344556", "Piazza San Giovanni 8", "Cagliari", "2000-09-26", "2025-01-05 10:00:00", "2025-01-17 22:22:07", "Active", "2022-12-20 23:00:00", 0, 9356.37),
(80, "BlackOutX", "daniele.moretti@example.com", "5q*ZrA}Ctd2?n38pE)*UWasTr%%{j+6$yt.EYu/HUaG9!Y5)Zp)7/TB6k3NnY@e}", "a304dbe13286aa63f458a20cebd531a75b75dd87b24918561f2a17f260e338de", "c2cb60100512caad8888a2fcbc7687fd", "Daniele", "Moretti", "User", "3474455667", "Viale Europa 17", "Genova", "1998-07-15", "2025-01-04 16:45:00", "2025-01-17 22:22:07", "Active", "2023-11-21 23:00:00", 0, 9824.59),
(81, "ElectricVenom", "sara.ferrari@example.com", "qfS+*L{[FC+MP&G2KzFVKDz(jXBk6khVDVBMntpmx3s6LXtkU@Zy9fk]m5]-e!RX", "fc55636b37de6b2308dac18c82e23d4eff73b90f022be6875ec2d589458a95b1", "3c5936439766906efd4fe02cb5400371", "Sara", "Ferrari", "User", "3405566778", "Via San Giovanni 21", "Venezia", "1996-02-23", "2025-01-03 12:15:00", "2025-01-17 22:22:07", "Active", "2023-11-19 23:00:00", 0, 8806.56),
(82, "ViperStrikeX", "michele.carmine@example.com", "V3By&=ek8{r{>dmp8FMWJ-s2=8{@267Eyb5)]t*QCJCqQtv9cZL6?rjbapuTZca?", "b3ff6319d68add141407bc5479c319279050ff3e0be4eda4ddd7fc2462b87609", "5e6d2eac9e9e83ba146c0ad29cd15b93", "Michele", "Carmine", "User", "3486677889", "Corso Italia 22", "Pescara", "2002-05-11", "2025-01-02 14:30:00", "2025-01-17 22:22:07", "Active", "2023-03-05 23:00:00", 0, 1691.94),
(83, "TheSkyWalker", "antonio.costa@example.com", "xHRq%x[=-rFX+a_f8ecP-s42H9-w!+C7K9P]X-gL!w_jGE7v@7$d]s5p6DxM5_uB", "d1600ae3c4db4960ccbc07080d0f53f33b7fea9058c3bd4a75c50e39294a23d5", "94969956d7015f632c9463d7f989d55a", "Antonio", "Costa", "User", "3477788990", "Via Roma 18", "Trieste", "2000-01-08", "2025-01-01 09:30:00", "2025-01-17 22:22:07", "Active", "2023-02-02 23:00:00", 0, 842.74),
(84, "ZeroXtreme", "lorenzo.amato@example.com", "GkVeb$f[D.B?GH.6_G+jd=UU-$NctMGEpd)w7qN/gR}3gaZ2_(u3BUh[s5cmYuj=", "bded409b02ad4aa02dee24775c81e8f6c9168c261664880f12baca636f49e808", "d043892d9f17c60aac03a7ba29646f7b", "Lorenzo", "Amato", "User", "3408899001", "Piazza Verdi 10", "Bologna", "1999-11-20", "2024-12-31 15:00:00", "2025-01-17 22:22:07", "Active", "2022-12-15 23:00:00", 0, 5162.83),
(85, "XxDarkViperxX", "paolo.luciani@example.com", "=?FB4{EA5?-^u2f_Pv{SVaj%eux%]*z95VE%{93@3Va!&H+Qy@Q2+MRLHx{$fBW[", "7fb54a4df1db0f0a3d04528ecc9a9b5ce7e9f961e528fe70ec7483a9c79d6507", "466341ffd9fb55b8bf5cac6656d94ec7", "Paolo", "Luciani", "User", "3480011223", "Viale del Mare 14", "Napoli", "1995-12-12", "2024-12-30 12:45:00", "2025-01-17 22:22:07", "Active", "2023-03-26 22:00:00", 0, 9973.50),
(86, "ThunderStrike_", "giovanni.pellegrini@example.com", "W}csqJ@N4)dzffqrKX!BFZ?CMJAgpCaMy7D?VyF@4SvD][mY@/zZqaR$wUR]*LU7", "c1e185b4084ce7ced088a4c10c1d5d6bdf0247906b2ba874a3160b675e3f720b", "aa9ee7b6440d7f2ab0e025bbc9c87697", "Giovanni", "Pellegrini", "User", "3471122334", "Via della Libertà 5", "Messina", "1998-08-09", "2024-12-29 16:30:00", "2025-01-17 22:22:07", "Active", "2022-11-11 23:00:00", 0, 4888.51),
(87, "SonicBoomX", "luca.neri@example.com", "6kxtS(LeL/_@)L?HCrW)Gj_TQNL8EUmpz$BJ._@xwHa.X8F@+g2Ss_bEC}CXPs&m", "91de31005ee287f405182c2fd9649561fc90fb649f946fe329748382686ee043", "1bf9037afd5cfa521b58bee9e079bd90", "Luca", "Neri", "User", "3402233445", "Via San Pietro 23", "Pisa", "1999-04-14", "2024-12-28 10:00:00", "2025-01-17 22:22:07", "Active", "2024-05-06 22:00:00", 0, 9537.49),
(88, "FrostBite23", "francesca.giorgi@example.com", "@U>-.kTM2sW-ZW6*T/rXj&Ty&Aztsz&{bnVg}u4pKpu7drZ>LxG]hU+Xb5.B*=Hp", "10e6888be275e517a28f56ade3352a10c78bdb908d80669b31ec24f933155b7d", "e6d4f98e91022435845db878298c9bad", "Francesca", "Giorgi", "User", "3463344556", "Corso della Repubblica 7", "Siena", "1997-11-20", "2024-12-27 15:15:00", "2025-01-17 22:22:07", "Active", "2022-05-16 22:00:00", 0, 7324.30),
(89, "TurboFalconX", "riccardo.rossi@example.com", "JuC!gf*T]sQ!jf!LB{8>qnEsQ(=-ktX(cVP*{]pTFC^}_E95J5pD@JpHdY]V/j]h", "4bbf7d05ebef51b9cb01a93b91b0b6ac2839cc08731ac4ad6ac6f677938ce0e4", "c0ca79cc64beb7967684da7d968b517c", "Riccardo", "Rossi", "User", "3474455667", "Viale Cavour 19", "Verona", "1998-10-10", "2024-12-26 18:30:00", "2025-01-17 22:22:07", "Active", "2023-09-23 22:00:00", 0, 7496.19),
(90, "QuantumXx", "alessandro.distefano@example.com", "8eKRcbN@CbGP.^kZ6kMLc}(S}vt*@v4s_2kL6vAp&+xK&7gXZL.>2Vt/Pb(M@z26", "dca5a734ed99158d241bcaf0a848b482a781b3eeb4567bf31febcfcb43c8dd1e", "2a68e86518080c37716c7f9343499d4e", "Alessandro", "Di Stefano", "User", "3485566778", "Via Mazzini 12", "Perugia", "2000-02-22", "2024-12-25 14:45:00", "2025-01-17 22:22:07", "Active", "2024-06-01 22:00:00", 0, 8164.25),
(91, "Phoenix_44", "luca.bianchi@example.com", "}BA-$Z2f/hc]H9>&xwKpWCc}EvR2PeRLsKsdgCQ+qX3eyjFQ7g3-JW+}!VPZ(XM?", "df7b7c90f5ba4c785f4d829d139acd3afc5e3977d5cf4875414864bb4985d72d", "94dee77a4ce2de1c1e4fb574de781b04", "Luca", "Bianchi", "User", "3472233445", "Via Monte Grappa 11", "Roma", "2001-07-17", "2025-01-17 12:00:00", "2025-01-17 22:22:07", "Active", "2022-12-24 23:00:00", 0, 5968.08),
(92, "DarkStorm12", "lorenzo.ricci@example.com", ">5Z+&]@.nxrZg(tp=78X@+=KN/_2LcubQhpPP*Sx=bQA)%{tC%{Q}G(aF^?/wF>=", "244066b39026d56143d648e0e15ccf54696d85f91ddffca554a89f0b4bcf3be9", "c3f0b50113d9a8cf0ffc00d2129af100", "Lorenzo", "Ricci", "User", "3403344556", "Viale dei Colli 25", "Milan", "1999-03-14", "2025-01-16 14:30:00", "2025-01-17 22:22:07", "Active", "2022-05-22 22:00:00", 0, 4839.38),
(93, "BlueNova23", "giulia.piazza@example.com", ">fHaS*T-Ph($]c[hMxDPA.cW6yvp%D9)Z!maF}A@%@8UDw)XY+uemN{^7UbrYyQ4", "3e9ec6e11e67065449e7c1e6beb0146750a65c9cbc4dbb59f797f239c711c0bf", "1e26462a7d5d38cb1a50444193699a52", "Giulia", "Piazza", "User", "3475566778", "Piazza San Marco 30", "Venice", "2000-11-10", "2025-01-15 10:15:00", "2025-01-17 22:22:07", "Active", "2024-07-17 22:00:00", 0, 7610.98),
(94, "DragonbornXx", "paolo.lombardi@example.com", "6=*](4y$weqGms8=cc=U6Y%-x-/P.CUxTLTKeM/.@NZdW6VzXFXq2/cy&^{.2x7/", "1a801014f8fc2e488da5c719ba2a73e15c89a6132232d3023a93c2d7cfdc2738", "784413ed12175a4c77328a7bac433b7f", "Paolo", "Lombardi", "User", "3486677889", "Via Garibaldi 18", "Florence", "1998-09-03", "2025-01-14 16:45:00", "2025-01-17 22:22:07", "Active", "2024-04-28 22:00:00", 0, 1135.54),
(95, "RagingInferno", "martina.rossi@example.com", "y^Wvr]kB!3ftA$q/Wm2!Eau+?_nasQG]LPgkZfkdwAP)U-2]x).g]C+x*?h)q$7G", "edb213c70a2d9862071d1b3bd22829982bfc98d20552d744ce6c8064c9359298", "31378d22bb39b3aa7aa6105a3505df05", "Martina", "Rossi", "User", "3407788990", "Corso Vittorio Emanuele 7", "Rome", "1997-06-02", "2025-01-13 18:00:00", "2025-01-17 22:22:07", "Active", "2023-08-03 22:00:00", 0, 2583.79),
(96, "SpaceGhostX", "giuseppe.marino@example.com", "Tuv[)5d74FFe?N*N_RV]e(=fGtCy3[St8Gv[L5&e5C93a&mr5-VDz?!6UvS}jF-d", "ca68218183d4e185aa4a991c80288c2c19f35ac760b2bf4ce0b5c54db43c46d9", "8eb3bb48cbb3dccd6d3a604e2f229cad", "Giuseppe", "Marino", "User", "3478899001", "Viale delle Magnolie 20", "Naples", "2001-04-21", "2025-01-12 11:30:00", "2025-01-17 22:22:07", "Active", "2024-01-09 23:00:00", 0, 6566.89),
(97, "ViperKnight91", "alessandro.damico@example.com", "%5b{]4/d}J@LQ*>ZKbT]77]&&SxHUJMVb_V.6BGRHMWT[P+yQcqB.&yMV[s_JJJU", "44c9ae52e1429e34e0e0f5ca0f9500f08d0997e3d53978649ca54157fcee225d", "3eb08dcfa76387d762f14bbeb67341b9", "Alessandro", "D'Amico", "User", "3489900112", "Via Trento 16", "Catania", "1996-05-10", "2025-01-11 09:00:00", "2025-01-17 22:22:07", "Active", "2023-10-02 22:00:00", 0, 3913.22),
(98, "ShadowVortex_", "fabio.bianchi@example.com", "%fKZh>3-6DQ@AL!2!DUY=!AW.FvWvmRhG9DL4T4U)2mT(bqafTme(SEE@>Wpdh95", "4691c152c2c6d39ee4e5856e0593e537d45a552a36454ee2714c44447fa51430", "f95071080b7d68d9f087639031ccc775", "Fabio", "Bianchi", "User", "3462233445", "Corso Roma 13", "Bologna", "1999-12-30", "2025-01-10 17:45:00", "2025-01-17 22:22:07", "Active", "2024-10-12 22:00:00", 0, 2676.23),
(99, "CyberNinja_23", "marco.gatti@example.com", ">cH=.%MEFUeJ5jEWq[5*MHxDV=b&5QENAY3c)q7/8{Ab2L[yR@zgqqJZTZ)P7=WV", "54e92d6ae152ee812f96257ff3fece86fa3f1a741823e74c46f62cf57f3cea4a", "82f9ed7e46c4f8ec8dac4fc1196cdcd4", "Marco", "Gatti", "User", "3473344556", "Via Dante 4", "Turin", "1998-02-07", "2025-01-09 14:30:00", "2025-01-17 22:22:07", "Active", "2024-02-06 23:00:00", 0, 942.55),
(100, "BlueTigerZx", "stefano.bertini@example.com", "R!4[G/CMc5P6>U?&35k>@vhA_r^(X^7VbZP62wM^M+QKZKKrLUG2aDjXwd@Y&^aZ", "fa01aaf27a51cc79872ff71858f0eb07a5f3c0e34666ddb819a13639e1e801b4", "06c26ed1d63543d3e8cf3785faf2510a", "Stefano", "Bertini", "User", "3484455667", "Viale Europa 12", "Milan", "1997-07-22", "2025-01-08 10:15:00", "2025-01-17 22:22:07", "Active", "2022-07-11 22:00:00", 0, 8850.13),
(101, "IronWolf_92", "francesca.marino@example.com", "FHggU57?Z5mFhC>p49Vhtx@MVxg_HQzRz4kVA!7UJPTsCu^H]dqw=S29pZ>8=-Qp", "4a9848b3ca0d731ce1b87293e63da0f7f64ec68f30aeca1b765ae25a7bb71e3d", "55a0cd4cdf3cafc8f5e588a5ec755dad", "Francesca", "Marino", "User", "3475566778", "Piazza Roma 18", "Genoa", "1999-05-12", "2025-01-07 11:00:00", "2025-01-17 22:22:07", "Active", "2022-02-15 23:00:00", 0, 8625.39),
(102, "AlphaBlazeX", "sara.conte@example.com", "2)){9b5jGSd[2tTXc.svYXj_VKK428%}VmEdA.Ubcv&gr4K=G%]^H6>3uuA4@H=U", "a1f305608669e71b82277b64af7f3a8ada9be4577284087f2bc65986441d2920", "0fdc05abb8f5b839d25eef670313f61d", "Sara", "Conte", "User", "3406677889", "Corso Firenze 11", "Florence", "2000-08-25", "2025-01-06 15:00:00", "2025-01-17 22:22:07", "Active", "2024-08-26 22:00:00", 0, 6249.51),
(103, "VoltRushXx", "davide.cavalli@example.com", "XJMMk+X>(qeB>7yCkwAqNqTek^NHZwHqJwHP>FUHce2CH%xrR(5unG3YV.8Ttk>[", "b5b27f5bb63a63624a42399dd805ef7aae59a1a2fa1395cd1d30f49329a46039", "d6687f33345639734acd137cfe487fb0", "Davide", "Cavalli", "User", "3471122334", "Viale Piave 9", "Verona", "1998-11-30", "2025-01-05 16:30:00", "2025-01-17 22:22:07", "Active", "2024-10-07 22:00:00", 0, 8472.04),
(104, "MegaForceX", "riccardo.conti@example.com", ".4kZfnC>H{B>S[R>)Hp&hUuDSs[YRp._z*L(R8s(%aYa%_TXgt+x?b{DK$yb^yDL", "464f5f1473abfe8f6c10e78033a1fb65a45bea946a44bd2e06c591d0aa80d6c8", "d0ddd240e0103f8e262927112635ee6c", "Riccardo", "Conti", "User", "3402233445", "Via Roma 5", "Trieste", "2001-02-18", "2025-01-04 10:45:00", "2025-01-17 22:22:07", "Active", "2022-01-15 23:00:00", 0, 9153.01),
(105, "FuryShadowX", "marco.rossi@example.com", "+5Q8eQLr7M3?%6ZR[&3VDgtw]V*t{>EXgR@s?Vc3-tAAabJusK/h.KxDFRxT*BU3", "b20bca24496747e1b7d937494570e833e780e558cf3730671606a0ec94e6a986", "80da4cd2d66c9344180e5694e9a092d1", "Marco", "Rossi", "User", "3473344556", "Via San Giuseppe 14", "Messina", "1996-04-25", "2025-01-03 12:00:00", "2025-01-17 22:22:07", "Active", "2023-09-22 22:00:00", 0, 1669.17),
(106, "ThunderXtreme_", "claudia.giorgi@example.com", "*dvgXvPMP^NCRz7{+Lung4{=p>rS)^8[]*wRb^8Y]q$ExmK+%L=Ay[U[FQ(mtg(S", "aa17abdeec4a6f3561380a9afdd5275e2cae32d0df1bbb7d656f231fe6fd8106", "631a4023f137b110a38cde369a60d9ff", "Claudia", "Giorgi", "User", "3484455667", "Corso Libertà 18", "Rome", "1999-10-02", "2025-01-02 13:30:00", "2025-01-17 22:22:07", "Active", "2022-01-24 23:00:00", 0, 2055.04),
(107, "SilentRiderXx", "antonio.delfino@example.com", "4EnVMapkWFs[^/Qn4dVw6_ZZdnvph_KTzf(N9dfcfKHeHE2+ZJ]j]K3K*Y}.e.@a", "237c5cbe32740791a98e5993561d41e26cc3decf4b5ea7f5cba6890cecc180b7", "5b7ff8b654564ca5da4fa3ed3dcdd8e2", "Antonio", "Delfino", "User", "3405566778", "Viale dei Cedri 22", "Bologna", "1998-05-14", "2025-01-01 11:15:00", "2025-01-17 22:22:07", "Active", "2022-08-03 22:00:00", 0, 4653.63),
(108, "CyberKnightX", "elena.giordano@example.com", "KeH.b(XcvvVN&!R3*M[e/-}tJv--Q5GdE%2R8w}y>P.+huApzq+.Yk3rb5)zx2aq", "f283e7a9504324c92e04b68e96cd8191652a81fe8896995b90b8848bfe580a50", "b0740d8d3cc68606869a2c355b62470c", "Elena", "Giordano", "User", "3477788990", "Via della Vittoria 13", "Naples", "2002-03-22", "2024-12-31 16:45:00", "2025-01-17 22:22:07", "Active", "2023-11-11 23:00:00", 0, 9271.64),
(109, "StealthWarriorX", "francesco.lombardi@example.com", "qe^Qb7LMn@JwKZ^SbY?{eAS_Jf-hWPdp*tfuu7x+N@ZJt%U$_k+?Y(97rEsYG?r=", "c7405d24f28f1cd23381e67c2d5ae73495552f14998a02e9dcf4273c18114aa7", "b3e27fb31e1c387958b054e2fec5681b", "Francesco", "Lombardi", "User", "3408899001", "Corso Milano 7", "Florence", "1997-08-03", "2024-12-30 14:00:00", "2025-01-17 22:22:07", "Active", "2022-02-08 23:00:00", 0, 6778.62),
(110, "BlazeDragonXx", "sofia.tarantino@example.com", "h8MV+mev&4WxQ78YEETdv.EQ@r27(f2S5C&sy@8V=e}(]F4jTVrYDZ$2*HK[@qnD", "67d1e6c66d2bee0ea06a82f5d935f8030eca1fcb591ed65008821d86f28d371c", "028add4c768e8bcc9b47a72fadc594e8", "Sofia", "Tarantino", "User", "3489900112", "Piazza dei Mirti 18", "Genoa", "2001-01-16", "2024-12-29 10:30:00", "2025-01-17 22:22:07", "Active", "2022-11-01 23:00:00", 0, 6677.41),
(111, "GhostKnightX", "giovanni.martino@example.com", "Hsf^ag5H[&KcCMk)jCD^Zy%kJpW$D.CZ%4vCg7aGmRjb{+PTyZR]pP!hucLHww?y", "a8136e19c8b1cacf0169a7a6202bab52b54b72632b09a3dd6a689d25f6fd2552", "39c21995f419955b257c0e93d9b82682", "Giovanni", "Martino", "User", "3472233445", "Viale Verdi 15", "Turin", "1999-07-24", "2024-12-28 13:30:00", "2025-01-17 22:22:07", "Active", "2023-07-06 22:00:00", 0, 9303.67),
(112, "KingCobra_23", "alessandro.baldini@example.com", "&2EecC7G5.xMV{ux_]g97WVFjgZKm84MBBFQh!%AD+yf8&qt{=%.XdMfF9fATaPM", "d19dc7b118ecfdd9922be408d92d7aa00f529e7a9a0ad955cd90b8b9cab9968b", "70d051af7be29f8cf3d4b3a9d186e8d2", "Alessandro", "Baldini", "User", "3463344556", "Via Mazzini 12", "Bologna", "1998-10-17", "2024-12-27 15:45:00", "2025-01-17 22:22:07", "Active", "2023-08-19 22:00:00", 0, 7275.32),
(113, "BlueTigerX_", "maria.santoro@example.com", "e(?C(S>DJpB%Ge8bDFE8%/$tkD}FmRJ3AFbVFQ{[f&_k&KJs)crp{puaK@%98Uxm", "84ffbeb8359a56e29cecced04caeaa1221bb1f914f935b8f5801244f0190c18e", "4490184de1cf0e0a45953042fe78f04c", "Maria", "Santoro", "User", "3474455667", "Corso Italia 10", "Venice", "2002-11-14", "2024-12-26 14:00:00", "2025-01-17 22:22:07", "Active", "2022-11-17 23:00:00", 0, 24.87),
(114, "NightRiderX", "riccardo.verdi@example.com", "yQWBLBj]XjG@-S-hB%zD+/nBcv@*!D.gk>-Xag}]Q]f[q6L8VVy*Jnw5t[3bb}M6", "70ae64a4e50fe096f3a066bb50c4fcc12e8ef659a3fb7451997539c6a2157bdf", "6fe43728d6abea4d61d310c6b93e079a", "Riccardo", "Verdi", "User", "3406677889", "Viale dei Tigli 6", "Rome", "1997-02-01", "2024-12-25 17:30:00", "2025-01-17 22:22:07", "Active", "2024-05-27 22:00:00", 0, 9735.70),
(115, "ShadowHunterXx", "alessia.caruso@example.com", "Z?EJU_q?=aNa}w{rnLM+q4_pL)FMp.Rp*6SALX5E[)/2>!}T}hQ>z>*-(-K3S+6T", "f17d5af15ebb072699af6b0589da4c8429ef5c328efe17fc00a5056d1b2836bd", "a241c6919e5a15efb2e428ad2c3905b3", "Alessia", "Caruso", "User", "3482233445", "Via Palmiro Togliatti 10", "Palermo", "1999-11-06", "2024-12-24 12:00:00", "2025-01-17 22:22:07", "Active", "2024-09-28 22:00:00", 0, 3983.02),
(116, "FrozenFuryX_", "michele.neri@example.com", "E=$)Pmj-}vyr{ZYx]M}Cw&(DZa!3HL+m=5>/4G-+ztQj?$v$4zzVDAps4J8cUmSD", "f7e709812049d8b232cef89ea02e9d8662d0eb67dee1837f006a71457e233bac", "1a31cbd7e44f7fbfed4952ca67a81418", "Michele", "Neri", "User", "3403344556", "Corso del Popolo 4", "Venice", "2000-01-25", "2024-12-23 14:45:00", "2025-01-17 22:22:07", "Active", "2024-10-15 22:00:00", 0, 3981.17),
(117, "RedPhoenixX", "alessandro.cappelli@example.com", "U45)JqScSkdn[v7V4u@*3-6N$7W{4vLz+${!x}?{Vxq$b{GTnrm(tS-XumD]&+ZY", "b29ab90f8cb77c7db7ac89ef9f13aa53b713e419a4a4c2b2524d666179662133", "66a5a878c65f6542a242f9708c3836b9", "Alessandro", "Cappelli", "User", "3475566778", "Viale Roma 6", "Naples", "1998-03-09", "2024-12-22 11:30:00", "2025-01-17 22:22:07", "Active", "2023-02-19 23:00:00", 0, 1054.73),
(118, "SteelBladeX_", "stefano.caruso@example.com", "!DvC%s%rk63Rf=4Y7W_EbSg>T)}JtM/%^unjR.Fw8!a{M%T3Nw!-{qL=$5mJv2E?", "149d68c0b4548f715e1c076afdc93d4d6d9dfc759c64edcfd7a5586fd8929612", "016732b077e539298acf35da600ea16d", "Stefano", "Caruso", "User", "3486677889", "Piazza dell'Indipendenza 20", "Genoa", "2002-07-01", "2024-12-21 16:00:00", "2025-01-17 22:22:07", "Active", "2025-01-07 23:00:00", 0, 2906.08);




INSERT INTO GAMES (Id, Name, Price, Publisher, ReleaseDate, Description, Trailer, Rating, CopiesSold) VALUES
(1, "The Legend of Zelda: Breath of the Wild", 59.99, "Nintendo", "2017-03-03", "An open-world adventure game set in the Zelda universe.", "https://www.youtube.com/watch?v=zw47_q9wbBE", 10.00, 10000000),
(2, "Red Dead Redemption 2", 59.99, "Rockstar Games", "2018-10-26", "A Western-themed open-world action game.", "https://www.youtube.com/watch?v=gmA6MrX81z4", 9.80, 20000000),
(3, "God of War (2018)", 49.99, "Sony Interactive Entertainment", "2018-04-20", "A brutal and emotional journey in the world of Norse mythology.", "https://www.youtube.com/watch?v=K0u_kAWLJOA", 9.70, 15000000),
(4, "Horizon Zero Dawn", 39.99, "Sony Interactive Entertainment", "2017-02-28", "An open-world action RPG with a futuristic setting.", "https://www.youtube.com/watch?v=u4-FCsiF5x4", 9.60, 9000000),
(5, "Assassin\'s Creed Valhalla", 59.99, "Ubisoft", "2020-11-10", "A Viking-themed action RPG with open-world exploration.", "https://www.youtube.com/watch?v=rKjUAWlbTJk", 9.20, 12000000),
(6, "Ghost of Tsushima", 59.99, "Sony Interactive Entertainment", "2020-07-17", "A samurai action RPG set in feudal Japan.", "https://www.youtube.com/watch?v=rTNfgIAi3pY", 9.40, 7000000),
(7, "Tomb Raider (2013)", 19.99, "Square Enix", "2013-03-05", "A re-imagining of the classic action-adventure series.", "https://www.youtube.com/watch?v=M4SG6DfVvLs", 8.50, 14000000),
(8, "Uncharted 4: A Thief\'s End", 59.99, "Sony Interactive Entertainment", "2016-05-10", "A treasure hunter's adventure filled with action and puzzle-solving.", "https://www.youtube.com/watch?v=hh5HV4iic1Y", 9.70, 16000000),
(9, "Batman: Arkham Knight", 29.99, "Warner Bros. Interactive Entertainment", "2015-06-23", "A superhero action game featuring Batman in Gotham City.", "https://www.youtube.com/watch?v=JeGAQXY2FzI", 9.10, 9000000),
(10, "Spider-Man: Miles Morales", 49.99, "Sony Interactive Entertainment", "2020-11-12", "The story of Miles Morales as the new Spider-Man.", "https://www.youtube.com/watch?v=3wHL2VIaFcs", 9.60, 8000000),
(11, "The Last of Us Part II", 59.99, "Sony Interactive Entertainment", "2020-06-19", "A post-apocalyptic action-adventure with deep narrative elements.", "https://www.youtube.com/watch?v=vhII1qlcZ4E", 9.50, 11000000),
(12, "Control", 39.99, "505 Games", "2019-08-27", "A surreal third-person action game with supernatural elements.", "https://www.youtube.com/watch?v=PT5yMfC9LQM", 9.20, 7000000),
(13, "Sekiro: Shadows Die Twice", 59.99, "Activision", "2019-03-22", "A punishing action RPG set in a war-torn feudal Japan.", "https://www.youtube.com/watch?v=rXMX4YJ7Lks", 9.80, 4000000),
(14, "Death Stranding", 59.99, "Sony Interactive Entertainment", "2019-11-08", "An open-world action game set in a post-apocalyptic world.", "https://www.youtube.com/watch?v=Mpn-MC2B6Zc", 9.10, 8000000),
(15, "Days Gone", 39.99, "Sony Interactive Entertainment", "2019-04-26", "An open-world survival action game set in a post-apocalyptic world.", "https://www.youtube.com/watch?v=FKtaOY9lMvM", 8.80, 6000000),
(16, "Far Cry 5", 59.99, "Ubisoft", "2018-03-27", "An open-world shooter set in a Montana county taken over by a cult.", "https://www.youtube.com/watch?v=Kdaoe4hbMso", 8.70, 8000000),
(17, "Watch Dogs: Legion", 59.99, "Ubisoft", "2020-10-29", "A hacker-focused action game set in a dystopian London.", "https://www.youtube.com/watch?v=srXrGKGAU20", 8.40, 5000000),
(18, "Metal Gear Solid V: The Phantom Pain", 59.99, "Konami", "2015-09-01", "An open-world stealth action game with military espionage elements.", "https://www.youtube.com/watch?v=C19ap2M7DDE", 9.30, 12000000),
(19, "Dishonored 2", 39.99, "Bethesda Softworks", "2016-11-11", "A stealth action game set in a steampunk-inspired world.", "https://www.youtube.com/watch?v=32LDc_66r5U", 9.00, 4000000),
(20, "Dying Light 2", 59.99, "Techland", "2022-02-04", "A zombie apocalypse game with parkour-basedement and combat.", "https://www.youtube.com/watch?v=uL6OeuicjyU", 8.70, 6000000),
(21, "Fallout: New Vegas", 19.99, "Bethesda Softworks", "2010-10-19", "A post-apocalyptic open-world RPG in the Fallout series.", "https://www.youtube.com/watch?v=l-x-1fm2cq8", 9.80, 12000000),
(22, "Mass Effect Legendary Edition", 59.99, "Electronic Arts", "2021-05-14", "A remastered trilogy of the critically acclaimed Mass Effect series.", "https://www.youtube.com/watch?v=n8i53TtQ6IQ", 9.60, 5000000),
(23, "Cyberpunk 2077", 59.99, "CD Projekt Red", "2020-12-10", "An open-world action RPG set in a dystopian cyberpunk future.", "https://www.youtube.com/watch?v=DvVjkqB3LH0", 9.00, 20000000),
(24, "Witcher 3: Wild Hunt", 39.99, "CD Projekt Red", "2015-05-19", "An open-world fantasy RPG set in the Witcher universe.", "https://www.youtube.com/watch?v=XHrskkHf958", 10.00, 50000000),
(25, "Persona 5 Royal", 59.99, "Atlus", "2019-10-31", "An enhanced edition of Persona 5 with new characters and stories.", "https://www.youtube.com/watch?v=QnDzJ9KzuV4", 9.80, 6000000),
(26, "Final Fantasy XVI", 69.99, "Square Enix", "2023-06-22", "A high fantasy RPG with action-packed combat.", "https://www.youtube.com/watch?v=KOhs9ZLImgE", 9.50, 5000000),
(27, "Final Fantasy VII Remake", 59.99, "Square Enix", "2020-04-10", "A remake of the classic Final Fantasy VII with modern graphics and gameplay.", "https://www.youtube.com/watch?v=eHdaWMP7D2s", 9.70, 8000000),
(28, "Genshin Impact", 0.00, "miHoYo", "2020-09-28", "An open-world RPG with gacha mechanics and stunning visuals.", "https://www.youtube.com/watch?v=HLUY1nICQRY", 9.20, 50000000),
(29, "Monster Hunter: World", 39.99, "Capcom", "2018-01-26", "A co-op action RPG where players hunt monsters in diverse ecosystems.", "https://www.youtube.com/watch?v=OotQrKEqe94", 9.50, 20000000),
(30, "Dark Souls III", 59.99, "Bandai Namco Entertainment", "2016-03-24", "A challenging action RPG set in a dark fantasy world.", "https://www.youtube.com/watch?v=cWBwFhUv1-8", 9.60, 10000000),
(31, "Diablo IV", 69.99, "Blizzard Entertainment", "2023-06-06", "The latest installment in the dark fantasy action RPG series.", "https://www.youtube.com/watch?v=HukrLKMCz1I", 9.10, 10000000),
(32, "Xenoblade Chronicles 3", 59.99, "Nintendo", "2022-07-29", "An open-world RPG with deep storytelling and vast exploration.", "https://www.youtube.com/watch?v=Fwuw3PB7Hrc", 9.40, 4000000),
(33, "Nier: Automata", 39.99, "Square Enix", "2017-02-23", "A thought-provoking action RPG with multiple endings.", "https://www.youtube.com/watch?v=wJxNhJ8fjFk", 9.50, 6000000),
(34, "Octopath Traveler", 59.99, "Square Enix", "2018-07-13", "A pixel art JRPG with eight unique protagonists.", "https://www.youtube.com/watch?v=NyHXpDzuys4", 9.30, 3000000),
(35, "Terraria", 9.99, "Re-Logic", "2011-05-16", "A sandbox adventure RPG with exploration and crafting.", "https://www.youtube.com/watch?v=9DwRYw2g9Sc", 9.30, 35000000),
(36, "Elden Ring", 69.99, "Bandai Namco Entertainment", "2022-02-25", "An open-world action RPG designed by FromSoftware and George R.R. Martin.", "https://www.youtube.com/watch?v=AKXiKBnzpBQ", 9.90, 20000000),
(37, "The Legend of Zelda: Tears of the Kingdom", 69.99, "Nintendo", "2023-05-12", "A direct sequel to Breath of the Wild with new mechanics and exploration.", "https://www.youtube.com/watch?v=SSVYVgm4tH4", 10.00, 17000000),
(38, "The Elder Scrolls V: Skyrim", 39.99, "Bethesda Softworks", "2011-11-11", "A legendary open-world fantasy RPG with extensive modding support.", "https://www.youtube.com/watch?v=JSRtYpNRoN0", 9.70, 30000000),
(39, "Horizon Forbidden West", 69.99, "Sony Interactive Entertainment", "2022-02-18", "A sequel to Horizon Zero Dawn featuring robotic wildlife and exploration.", "https://www.youtube.com/watch?v=Lq594XmpPBg", 9.20, 10000000),
(40, "Fire Emblem: Warriors", 59.99, "Nintendo", "2019-07-26", "A tactical RPG with branching storylines and complex relationships.", "https://www.youtube.com/watch?v=dTdVvQv5Mfw", 9.50, 5000000),
(41, "Pillars of Eternity II: Deadfire", 49.99, "Obsidian Entertainment", "2018-05-08", "A sequel to the critically acclaimed isometric RPG, Pillars of Eternity.", "https://www.youtube.com/watch?v=W63cZxreR7g", 9.10, 1000000),
(42, "Disco Elysium: The Final Cut", 39.99, "ZA/UM", "2021-03-30", "A groundbreaking RPG with a focus on narrative and character development.", "https://www.youtube.com/watch?v=nk_K5DM0UTk", 9.80, 3000000),
(43, "Hollow Knight", 14.99, "Team Cherry", "2017-02-24", "A metroidvania RPG set in a hauntingly beautiful world.", "https://www.youtube.com/watch?v=kWo5g-tsBNk", 9.60, 3000000),
(44, "Dead Cells", 24.99, "Motion Twin", "2018-08-07", "A rogue-lite metroidvania with fast-paced combat.", "https://www.youtube.com/watch?v=RvGaSPTcTxc", 9.40, 5000000),
(45, "The Outer Worlds", 59.99, "Obsidian Entertainment", "2019-10-25", "A satirical sci-fi RPG with branching narratives.", "https://www.youtube.com/watch?v=zNmjNA6dtEA", 8.70, 4000000),
(46, "Path of Exile", 0.00, "Grinding Gear Games", "2013-10-23", "A free-to-play action RPG with a deep skill system.", "https://www.youtube.com/watch?v=brZT-Qdg8TY", 9.20, 20000000),
(47, "Fable Anniversary", 34.99, "Xbox Game Studios", "2014-02-04", "A remastered version of the original Fable.", "https://www.youtube.com/watch?v=W8GevE4Lugw", 8.50, 3000000),
(48, "Kingdom Come: Deliverance", 39.99, "Warhorse Studios", "2018-02-13", "A realistic medieval RPG with immersive gameplay.", "https://www.youtube.com/watch?v=tpnuBdG9txM", 9.00, 3000000),
(49, "GreedFall", 49.99, "Focus Home Interactive", "2019-09-10", "An action RPG with a unique 17th-century fantasy setting.", "https://www.youtube.com/watch?v=PmqWaDwKS6M", 8.40, 2000000),
(50, "Vampyr", 39.99, "Focus Home Interactive", "2018-06-05", "An action RPG about a doctor turned vampire in 1918 London.", "https://www.youtube.com/watch?v=QfB_4A-jL_k", 8.20, 1500000),
(51, "For the King", 19.99, "IronOak Games", "2018-04-19", "A turn-based strategy RPG with roguelike elements.", "https://www.youtube.com/watch?v=B2qF39qKrXo", 8.50, 2000000),
(52, "Yakuza: Like a Dragon", 59.99, "SEGA", "2020-11-10", "A turn-based RPG reboot of the Yakuza series.", "https://www.youtube.com/watch?v=hkygiqC7ulQ", 9.00, 3000000),
(53, "Dragon Age: Inquisition", 39.99, "Electronic Arts", "2014-11-18", "A fantasy RPG with vast exploration and engaging character stories.", "https://www.youtube.com/watch?v=1HY2bOdzVD0", 9.10, 6000000),
(54, "Divinity: Original Sin 2", 44.99, "Larian Studios", "2017-09-14", "A critically acclaimed RPG with deep mechanics and co-op gameplay.", "https://www.youtube.com/watch?v=-E-TTpfsBZE", 9.80, 3000000),
(55, "Baldur\'s Gate III", 59.99, "Larian Studios", "2023-08-03", "A continuation of the iconic Baldur\'s Gate series with modern RPG elements.", "https://www.youtube.com/watch?v=1T22wNvoNiU", 9.90, 2000000),
(56, "Ni no Kuni II: Revenant Kingdom", 59.99, "Bandai Namco Entertainment", "2018-03-23", "A visually stunning RPG with a heartfelt story and kingdom-building elements.", "https://www.youtube.com/watch?v=2MJs869kavY", 8.80, 2000000),
(57, "Starfield", 69.99, "Bethesda Softworks", "2024-09-06", "A space exploration RPG set in an expansive galaxy.", "https://www.youtube.com/watch?v=kfYEiTdsyas", 9.40, 5000000),
(58, "Witcher 2: Assassins of Kings", 19.99, "CD Projekt Red", "2011-05-17", "A dark fantasy RPG with political intrigue and impactful choices.", "https://www.youtube.com/watch?v=HedLjjlSy3Y", 9.20, 2000000),
(59, "Final Fantasy XV", 49.99, "Square Enix", "2016-11-29", "An action RPG following the journey of Prince Noctis and his friends.", "https://www.youtube.com/watch?v=fGdPVsTliT8", 9.00, 10000000),
(60, "Chrono Trigger", 14.99, "Square Enix", "1995-03-11", "A timeless classic RPG with a legendary story and multiple endings.", "https://www.youtube.com/watch?v=2fl-AylaHY8", 9.90, 3000000),
(61, "Tales of Arise", 59.99, "Bandai Namco Entertainment", "2021-09-10", "An action RPG with breathtaking visuals and an emotional story.", "https://www.youtube.com/watch?v=ykWm2kOCpE4", 9.20, 2000000),
(62, "Dark Souls II", 39.99, "Bandai Namco Entertainment", "2014-03-11", "A challenging RPG with intricate level design and lore.", "https://www.youtube.com/watch?v=qByFob7-8VY", 9.00, 3000000),
(63, "Dragon Quest XI S: Echoes of an Elusive Age", 39.99, "Square Enix", "2020-12-04", "A definitive edition of the classic turn-based RPG.", "https://www.youtube.com/watch?v=73FRi8W1oCM", 9.50, 6000000),
(64, "Hades", 24.99, "Supergiant Games", "2020-09-17", "A rogue-like dungeon crawler with a rich narrative and addictive gameplay.", "https://www.youtube.com/watch?v=mD8x5xLHRho", 9.80, 3000000),
(65, "The Banner Saga", 19.99, "Stoic Studio", "2014-01-14", "A tactical RPG with a rich story set in a Norse-inspired world.", "https://www.youtube.com/watch?v=TPhu-96zxz4", 8.90, 2000000),
(66, "Grim Dawn", 24.99, "Crate Entertainment", "2016-02-25", "A dark fantasy action RPG with deep character customization.", "https://www.youtube.com/watch?v=BfABNZqU-PA", 9.00, 1500000),
(67, "Civilization VI", 59.99, "2K Games", "2016-10-21", "A turn-based strategy game where players build and expand their civilizations.", "https://www.youtube.com/watch?v=5KdE0p2joJw", 9.20, 11000000),
(68, "Age of Empires IV", 59.99, "Xbox Game Studios", "2021-10-28", "A real-time strategy game set in historical settings.", "https://www.youtube.com/watch?v=Ovt7d34_hRA", 9.00, 2000000),
(69, "Total War: Warhammer III", 59.99, "SEGA", "2022-02-17", "A strategy game that blends real-time battles with turn-based empire building.", "https://www.youtube.com/watch?v=HAr7yUlM0Po", 8.90, 1500000),
(70, "Stellaris", 39.99, "Paradox Interactive", "2016-05-09", "A sci-fi grand strategy game where players explore and conquer galaxies.", "https://www.youtube.com/watch?v=KanCiSGxSKM", 9.30, 3000000),
(71, "Crusader Kings III", 49.99, "Paradox Interactive", "2020-09-01", "A medieval grand strategy game focusing on dynasties and intrigue.", "https://www.youtube.com/watch?v=xjn66Cl3pMA", 9.50, 2000000),
(72, "XCOM Enemy Unknown", 59.99, "2K Games", "2016-02-05", "A tactical strategy game where players lead resistance forces against alien invaders.", "https://www.youtube.com/watch?v=rfTB-fHKnZY", 9.00, 3000000),
(73, "Anno 1800", 59.99, "Ubisoft", "2019-04-16", "A city-building and strategy game set during the industrial revolution.", "https://www.youtube.com/watch?v=7ZwaZMuc1TQ", 8.90, 2500000),
(74, "Cities: Skylines", 29.99, "Paradox Interactive", "2015-03-10", "A modern city-building simulator with deep mechanics.", "https://www.youtube.com/watch?v=7vlKoMi4Qr0", 9.40, 12000000),
(75, "Hearts of Iron IV", 39.99, "Paradox Interactive", "2016-06-06", "A grand strategy game set during World War II.", "https://www.youtube.com/watch?v=F-uGP2DkZKE", 9.10, 3000000),
(76, "Planet Zoo", 44.99, "Frontier Developments", "2019-11-05", "A zoo-building simulator with detailed animal management.", "https://www.youtube.com/watch?v=UCgppIh1tnY", 9.20, 2000000),
(77, "Dwarf Fortress", 39.99, "Bay 12 Games", "2022-12-06", "A complex colony management and simulation game.", "https://www.youtube.com/watch?v=xawsp16oxb0", 9.50, 1000000),
(78, "FIFA 23", 69.99, "EA Sports", "2022-09-30", "The latest iteration of the popular football simulation game.", "https://www.youtube.com/watch?v=0tIW1X2dv0c", 8.50, 10000000),
(79, "NBA 2K23", 69.99, "2K Sports", "2022-09-09", "A basketball simulation game featuring NBA teams and players.", "https://www.youtube.com/watch?v=MCU18y25WeQ", 8.20, 8000000),
(80, "MLB The Show 23", 69.99, "San Diego Studio", "2023-03-28", "A baseball simulation game featuring MLB teams.", "https://www.youtube.com/watch?v=Sj-VxaY7iMk", 8.60, 3000000),
(81, "Forza Horizon 5", 59.99, "Xbox Game Studios", "2021-11-09", "An open-world racing game set in a vibrant Mexico.", "https://www.youtube.com/watch?v=Rv7xLt5yNsM", 9.50, 15000000),
(82, "Gran Turismo 7", 69.99, "Sony Interactive Entertainment", "2022-03-04", "A realistic racing simulator with stunning visuals.", "https://www.youtube.com/watch?v=oz-O74SmTSQ", 9.00, 5000000),
(83, "Need for Speed: Unbound", 69.99, "Criterion Games", "2022-12-02", "An arcade-style street racing game.", "https://www.youtube.com/watch?v=H2Y8XCe7F9E", 8.30, 3000000),
(84, "Rocket League", 19.99, "Psyonix", "2015-07-07", "A mix of soccer and driving with fast-paced gameplay.", "https://www.youtube.com/watch?v=SgSX3gOrj60", 9.20, 20000000),
(85, "Riders Republic", 59.99, "Ubisoft", "2021-10-28", "A multiplayer extreme sports game.", "https://www.youtube.com/watch?v=0gCyYbFVAdE", 8.00, 1000000),
(86, "Tony Hawk's Pro Skater 1+2", 39.99, "Activision", "2020-09-04", "A remastered collection of the first two Tony Hawk games.", "https://www.youtube.com/watch?v=22MQBu_jiH4", 8.90, 2000000),
(87, "Golf With Your Friends", 14.99, "Team17", "2020-05-19", "A fun multiplayer mini-golf game.", "https://www.youtube.com/watch?v=no_IUGXGFEI", 8.30, 1000000),
(88, "Dirt 5", 59.99, "Codemasters", "2020-11-06", "An off-road racing game with arcade-style gameplay.", "https://www.youtube.com/watch?v=rPIj7Lxi-Q8", 8.00, 1000000),
(89, "MotoGP 23", 49.99, "Milestone", "2023-06-08", "A motorcycle racing simulator featuring MotoGP riders.", "https://www.youtube.com/watch?v=PvgTSrE5bzA", 7.80, 500000),
(90, "TrackMania", 29.99, "Ubisoft", "2020-07-01", "A fast-paced arcade racing game focused on track building.", "https://www.youtube.com/watch?v=54XMox87psc", 8.40, 2000000),
(91, "WRC10", 59.99, "KT Racing", "2022-11-03", "A rally racing game based on the World Rally Championship.", "https://www.youtube.com/watch?v=JYTlwGdgjZw", 8.50, 800000),
(92, "SnowRunner", 29.99, "Saber Interactive", "2020-04-28", "A simulation game about driving heavy vehicles in extreme conditions.", "https://www.youtube.com/watch?v=hcFSFjJ2b6o", 8.70, 2000000),
(93, "Session: Skate Sim", 39.99, "Crea-ture Studios", "2022-09-22", "A realistic skateboarding simulation game.", "https://www.youtube.com/watch?v=qBMqPMPzGUY", 7.60, 300000),
(94, "Assetto Corsa", 19.99, "Kunos Simulazioni", "2014-12-19", "A highly realistic racing simulator.", "https://www.youtube.com/watch?v=TDFN-E30jhU", 9.30, 2000000),
(95, "Stardew Valley", 14.99, "ConcernedApe", "2016-02-26", "A charming farming simulator and role-playing game.", "https://www.youtube.com/watch?v=8A7A1X1TVNc", 9.60, 20000000),
(96, "Celeste", 19.99, "Maddy Makes Games", "2018-01-25", "A challenging platformer about climbing a mountain and overcoming personal struggles.", "https://www.youtube.com/watch?v=70d9irlxiB4", 9.20, 1000000),
(97, "Among Us", 4.99, "Innersloth", "2018-11-16", "A multiplayer social deduction game.", "https://www.youtube.com/watch?v=vlVeaz_l5Jg", 8.90, 50000000),
(98, "Cuphead", 19.99, "Studio MDHR", "2017-09-29", "A visually stunning run-and-gun game with a 1930s cartoon art style.", "https://www.youtube.com/watch?v=NN-9SQXoi50", 9.40, 6000000),
(99, "Ori and the Will of the Wisps", 29.99, "Moon Studios", "2020-03-11", "A visually breathtaking platformer with emotional storytelling.", "https://www.youtube.com/watch?v=2kPSl2vyu2Y", 9.50, 3000000),
(100, "Gris", 16.99, "Nomada Studio", "2018-12-13", "A serene and evocative platformer about grief.", "https://www.youtube.com/watch?v=BRiKQIVo7ao", 9.10, 1000000),
(101, "Undertale", 9.99, "Toby Fox", "2015-09-15", "A role-playing game where your choices matter.", "https://www.youtube.com/watch?v=1Hojv0m3TqA", 9.60, 5000000),
(102, "Slay the Spire", 24.99, "MegaCrit", "2019-01-23", "A deck-building rogue-like game.", "https://www.youtube.com/watch?v=9SZUtyYSOjQ", 9.40, 3000000),
(103, "Spiritfarer", 29.99, "Thunder Lotus Games", "2020-08-18", "A cozy management game about death and saying goodbye.", "https://www.youtube.com/watch?v=7QJSRmyrQPY", 9.00, 1000000),
(104, "The Binding of Isaac: Rebirth", 14.99, "Nicalis", "2014-11-04", "A rogue-like dungeon crawler with dark themes.", "https://www.youtube.com/watch?v=7fTPuAlCWEk", 9.10, 3000000),
(105, "RimWorld", 34.99, "Ludeon Studios", "2018-10-17", "A colony simulation game with emergent storytelling.", "https://www.youtube.com/watch?v=3tDrxOASUog", 9.40, 2000000),
(106, "Tunic", 29.99, "Andrew Shouldice", "2022-03-16", "A charming action-adventure game inspired by classic Zelda titles.", "https://www.youtube.com/watch?v=Q5XpgTO7YN0", 9.00, 500000),
(107, "Inscryption", 19.99, "Daniel Mullins Games", "2021-10-19", "A mind-bending card-based rogue-like game.", "https://www.youtube.com/watch?v=RN5GSIWIN1k", 9.30, 1000000),
(108, "Limbo", 9.99, "Playdead", "2010-07-21", "A monochrome puzzle-platformer with a haunting atmosphere.", "https://www.youtube.com/watch?v=Y4HSyVXKYz8", 9.00, 5000000),
(109, "Little Nightmares", 19.99, "Tarsier Studios", "2017-04-28", "A dark and eerie puzzle-platformer.", "https://www.youtube.com/watch?v=aOadxZBsPiA", 9.20, 2000000),
(110, "Inside", 19.99, "Playdead", "2016-06-29", "A cinematic platformer with a mysterious narrative.", "https://www.youtube.com/watch?v=oo-2UIkrqe8", 9.50, 3000000),
(111, "Super Mario Odyssey", 59.99, "Nintendo", "2017-10-27", "Embark on a globe-trotting adventure to rescue Princess Peach in this iconic platformer.", "https://www.youtube.com/watch?v=wGQHQc_3ycE", 9.80, 24000000),
(112, "Crash Bandicoot 4: It's About Time", 39.99, "Toys for Bob", "2020-10-02", "A challenging and vibrant continuation of the Crash Bandicoot series.", "https://www.youtube.com/watch?v=375dqL15O9E", 8.90, 5000000),
(113, "Spyro Reignited Trilogy", 39.99, "Toys for Bob", "2018-11-13", "A remastered collection of the beloved Spyro trilogy with stunning graphics.", "https://www.youtube.com/watch?v=orzNU1R4wb8", 9.00, 3000000),
(114, "Ratchet & Clank: Rift Apart", 69.99, "Insomniac Games", "2021-06-11", "A visually spectacular platformer and shooter adventure.", "https://www.youtube.com/watch?v=55PRv_e00wc", 9.20, 2000000),
(115, "Sonic Frontiers", 59.99, "SEGA", "2022-11-08", "An open-world Sonic adventure with fast-paced gameplay.", "https://www.youtube.com/watch?v=hv_zibBXjlg", 8.80, 1000000),
(116, "Donkey Kong Country: Tropical Freeze", 59.99, "Retro Studios", "2014-02-21", "A challenging and beautifully designed platformer featuring Donkey Kong.", "https://www.youtube.com/watch?v=_5p0SiWHwvw", 9.00, 3000000),
(117, "Ori and the Blind Forest", 19.99, "Moon Studios", "2015-03-11", "A visually stunning and emotional platformer.", "https://www.youtube.com/watch?v=VrbGwU5Zx4M", 9.50, 2000000),
(118, "Rayman Legends", 39.99, "Ubisoft", "2013-08-29", "A highly creative and fun platformer with cooperative gameplay.", "https://www.youtube.com/watch?v=afqO1qGr2XM", 9.40, 5000000),
(119, "Kirby and the Forgotten Land", 59.99, "HAL Laboratory", "2022-03-25", "Join Kirby in his first 3D adventure in a mysterious world.", "https://www.youtube.com/watch?v=wrEoqAywBao", 9.10, 2000000),
(120, "Sackboy: A Big Adventure", 59.99, "Sumo Digital", "2020-11-12", "A charming and family-friendly platformer.", "https://www.youtube.com/watch?v=C3I6SoCN5bI", 8.70, 1000000),
(121, "World of Warcraft", 39.99, "Blizzard Entertainment", "2004-11-23", "An iconic MMORPG set in the expansive fantasy world of Azeroth.", "https://www.youtube.com/watch?v=vlVSJ0AvZe0", 9.30, 120000000),
(122, "Final Fantasy XIV", 39.99, "Square Enix", "2010-09-30", "A critically acclaimed MMORPG with a rich story and vibrant community.", "https://www.youtube.com/watch?v=dc5HY3KEqug", 9.50, 27000000),
(123, "Guild Wars 2", 0.00, "ArenaNet", "2012-08-28", "A dynamic and free-to-play MMORPG with an innovative event system.", "https://www.youtube.com/watch?v=dQDx1I-IsgA", 8.90, 16000000),
(124, "Lost Ark", 0.00, "Smilegate RPG", "2018-12-04", "A visually stunning MMORPG with action-oriented gameplay.", "https://www.youtube.com/watch?v=iwnk9XrhN54", 8.50, 20000000),
(125, "Black Desert Online", 9.99, "Pearl Abyss", "2015-07-14", "An immersive MMORPG with incredible graphics and deep gameplay systems.", "https://www.youtube.com/watch?v=cjniChD6UiI", 8.60, 10000000),
(126, "Star Wars: The Old Republic", 0.00, "BioWare", "2011-12-20", "An MMORPG set in the Star Wars universe with rich storytelling.", "https://www.youtube.com/watch?v=cEs2CgiQ6Xw", 8.50, 10000000),
(127, "New World", 39.99, "Amazon Games", "2021-09-28", "An ambitious MMORPG set in a supernatural version of the Americas.", "https://www.youtube.com/watch?v=jqIdYtW3je0", 7.80, 5000000),
(128, "Albion Online", 0.00, "Sandbox Interactive", "2017-07-17", "A player-driven MMORPG with a classless combat system and an emphasis on economy.", "https://www.youtube.com/watch?v=eBU_Fxd0Jf4", 8.10, 5000000),
(129, "Mario Kart 8 Deluxe", 59.99, "Nintendo", "2017-04-28", "A fun-filled racing game perfect for parties, featuring iconic Nintendo characters.", "https://www.youtube.com/watch?v=tKlRN2YpxRE", 9.40, 55000000),
(130, "Fall Guys: Ultimate Knockout", 19.99, "Mediatonic", "2020-08-04", "A hilarious party game where players compete in chaotic obstacle courses.", "https://www.youtube.com/watch?v=AyADwdiW7rQ", 8.30, 15000000),
(131, "Jackbox Party Pack 9", 29.99, "Jackbox Games", "2022-10-20", "A collection of hilarious party games that are easy to pick up and play.", "https://www.youtube.com/watch?v=GP8JEeOOwY0", 8.50, 2000000),
(132, "Animal Crossing: New Horizons", 59.99, "Nintendo", "2020-03-20", "A relaxing life-simulation game where you create your perfect island getaway.", "https://www.youtube.com/watch?v=_3YNL0OWio0", 9.60, 42000000),
(133, "Splatoon 3", 59.99, "Nintendo", "2022-09-09", "A colorful and fun multiplayer game centered around ink-splattering battles.", "https://www.youtube.com/watch?v=-xh-HuNsoBw", 9.00, 12000000),
(134, "Wii Sports", 0.00, "Nintendo", "2006-11-19", "An iconic collection of sports games that revolutionized casual gaming.", "https://www.youtube.com/watch?v=zqaPFAZS1K8", 9.20, 82000000),
(135, "Pummel Party", 14.99, "Rebuilt Games", "2018-09-20", "A chaotic and humorous party game with brutal mini-games.", "https://www.youtube.com/watch?v=oiYG0Ov5jKE", 8.10, 2000000),
(136, "Overcooked! 2", 24.99, "Team17", "2018-08-07", "A frantic co-op cooking game that challenges players to work together.", "https://www.youtube.com/watch?v=lcVISRmANIo", 8.60, 5000000),
(137, "Gang Beasts", 19.99, "Boneloaf", "2017-12-12", "A wacky multiplayer game where gelatinous characters fight in absurd arenas.", "https://www.youtube.com/watch?v=Vz0BriND6pE", 8.00, 3000000),
(138, "Resident Evil Village", 59.99, "Capcom", "2021-05-07", "A survival horror game that follows Ethan Winters as he searches for his kidnapped daughter in a village filled with terrifying creatures.", "https://www.youtube.com/watch?v=QKocYiRHYlI", 9.30, 12000000),
(139, "Resident Evil 4 Remake", 59.99, "Capcom", "2023-03-24", "A complete remake of the classic horror game, with modern graphics and gameplay while preserving the original experience.", "https://www.youtube.com/watch?v=j5Xv2lM9wes", 9.50, 8000000),
(140, "Dead Space Remake", 59.99, "EA Motive", "2023-01-27", "A remake of the 2008 classic survival horror game, set on a haunted spaceship with a horrifying atmosphere.", "https://www.youtube.com/watch?v=C1yiuM7blIw", 9.20, 4000000),
(141, "Outlast II", 29.99, "Red Barrels", "2017-04-25", "A first-person psychological horror game that challenges players to survive against terrifying enemies and solve puzzles.", "https://www.youtube.com/watch?v=MKrUZ36IVAY", 8.70, 5000000),
(142, "Amnesia: The Dark Descent", 19.99, "Frictional Games", "2010-09-08", "A survival horror game that immerses players in a dark, creepy mansion filled with terrifying creatures and puzzles.", "https://www.youtube.com/watch?v=u1nY_5-UrY4", 9.00, 8000000),
(143, "Layers of Fear", 19.99, "Bloober Team", "2016-02-16", "A psychological horror game where players experience a disturbed artist's descent into madness.", "https://www.youtube.com/watch?v=CyDs5UJfvks", 8.20, 4000000),
(144, "The Evil Within 2", 39.99, "Bethesda Softworks", "2017-10-13", "A survival horror game set in a nightmarish world filled with horrifying enemies and puzzles.", "https://www.youtube.com/watch?v=aEBnIsVvECA", 8.40, 3000000),
(145, "Phasmophobia", 13.99, "Kinetic Games", "2020-09-18", "A co-op horror game where players must investigate paranormal activity in haunted locations.", "https://www.youtube.com/watch?v=adFNARIHlOs", 8.80, 6000000),
(146, "Little Nightmares II", 29.99, "Tarsier Studios", "2021-02-11", "A dark and eerie platformer that follows a young boy and girl as they escape terrifying creatures in a nightmarish world.", "https://www.youtube.com/watch?v=AI9zBBTyX-E", 8.90, 4000000),
(147, "Mortal Kombat 11", 59.99, "Warner Bros. Interactive Entertainment", "2019-04-23", "A brutal fighting game that continues the iconic Mortal Kombat series with new characters and fatalities.", "https://www.youtube.com/watch?v=7zwQPJmg-Kg", 9.00, 12000000),
(148, "Street Fighter 6", 59.99, "Capcom", "2023-06-02", "A modern entry in the legendary fighting franchise, featuring new mechanics and characters.", "https://www.youtube.com/watch?v=4EnsDg6DCTE", 9.20, 5000000),
(149, "Tekken 7", 49.99, "Bandai Namco Entertainment", "2017-06-02", "A long-running fighting game series with deep mechanics and a huge roster of characters.", "https://www.youtube.com/watch?v=1V-_q3SKh5w", 8.80, 8000000),
(150, "Guilty Gear Strive", 59.99, "Arc System Works", "2021-06-11", "A visually stunning and fast-paced fighting game that features a cast of unique characters and deep mechanics.", "https://www.youtube.com/watch?v=-rbffP5aQoA", 9.10, 3000000),
(151, "Dragon Ball FighterZ", 59.99, "Bandai Namco Entertainment", "2018-01-26", "A highly regarded fighting game featuring characters from the Dragon Ball universe with fast-paced, visually impressive combat.", "https://www.youtube.com/watch?v=LwdLKPumEaU", 9.00, 7000000),
(152, "Injustice 2", 9.99, "Warner Bros. Interactive Entertainment", "2017-05-16", "A superhero-based fighting game where players battle as characters from the DC Comics universe.", "https://www.youtube.com/watch?v=GXplrOBNfcU", 8.70, 6000000),
(153, "Super Smash Bros. Ultimate", 59.99, "Nintendo", "2018-12-07", "A chaotic and exciting brawler with characters from various franchises.", "https://www.youtube.com/watch?v=58Mm4zm5ZAk", 9.50, 33000000),
(154, "Soulcalibur VI", 59.99, "Bandai Namco Entertainment", "2018-10-19", "A weapon-based fighting game with a long history and roster of unique characters.", "https://www.youtube.com/watch?v=ipt2YiTpr0k", 8.50, 4000000),
(155, "Dead or Alive 6", 59.99, "Koei Tecmo", "2019-03-01", "A fast-paced fighting game known for its highly detailed graphics and fluid combat mechanics.", "https://www.youtube.com/watch?v=_-ZZzvxAwtk", 8.30, 3000000),
(156, "King of Fighters XV", 59.99, "SNK", "2022-02-17", "A classic 2D fighting game with a cast of diverse characters and fast-paced gameplay.", "https://www.youtube.com/watch?v=i-R_EQUIRA8", 8.60, 2000000),
(157, "Portal 2", 19.99, "Valve", "2011-04-18", "A first-person puzzle game that combines innovative mechanics and dark humor.", "https://www.youtube.com/watch?v=8_Ki0Gfczfo", 9.50, 11000000),
(158, "Tetris Effect: Connected", 39.99, "Monstars", "2020-11-10", "A visually stunning version of the classic Tetris game with new modes and effects.", "https://www.youtube.com/watch?v=DVN1fBewyL8", 9.00, 2000000),
(159, "Baba Is You", 14.99, "Hempuli", "2019-03-13", "A unique puzzle game where players manipulate the rules of the game to solve challenges.", "https://www.youtube.com/watch?v=z3_yA4HTJfs", 9.20, 1500000),
(160, "Human: Fall Flat", 14.99, "No Brakes Games", "2016-07-22", "A physics-based puzzle game that challenges players to solve puzzles with unique mechanics.", "https://www.youtube.com/watch?v=T_uA48H1-g4", 8.50, 8000000),
(161, "Monument Valley", 4.99, "ustwo games", "2017-11-06", "A visually captivating puzzle game where players manipulate the environment to guide characters through an abstract world.", "https://www.youtube.com/watch?v=tW2KUxyq8Vg", 9.30, 7000000),
(162, "Puzzle Quest: Challenge of the Warlords", 0.00, "Infinity Plus 2", "2021-10-01", "A match-3 puzzle game with RPG elements that features story-driven gameplay and strategic battles.", "https://www.youtube.com/watch?v=fwW7Th09WBg", 8.00, 4000000),
(163, "It Takes Two", 39.99, "Electronic Arts", "2021-03-26", "A cooperative puzzle platformer that follows two characters on an emotional journey through imaginative worlds.", "https://www.youtube.com/watch?v=2AysHTv7X8k", 9.40, 6000000),
(164, "Escape Simulator", 19.99, "Pine Studio", "2021-10-19", "A puzzle game that simulates real-life escape rooms where players solve puzzles to escape each room.", "https://www.youtube.com/watch?v=2VT7_tfRYV8", 8.60, 2000000),
(165, "Unpacking", 19.99, "Witch Beam", "2021-11-02", "A relaxing puzzle game where players unpack boxes and organize items in various rooms of a new home.", "https://www.youtube.com/watch?v=m8veArgF8rw", 8.80, 3000000),
(166, "Asphalt 9", 0.00, "Gameloft", "2018-07-25", "Asphalt 9 is a fast-paced arcade racing game featuring stunning graphics, an expansive roster of cars, and adrenaline-filled races.", "https://www.youtube.com/watch?v=ot63S91Ihwk", 4.50, 100000000),
(167, "Baldur\'s Gate 2", 49.99, "BioWare", "2000-09-24", "Baldur\'s Gate 2 is a classic RPG set in the Dungeons & Dragons universe, featuring a deep story, memorable characters, and tactical combat.", "https://www.youtube.com/watch?v=EPm_mHZYKqQ", 4.80, 4000000),
(168, "BioShock Infinite", 59.99, "2K Games", "2013-03-26", "BioShock Infinite is a first-person shooter set in the floating city of Columbia, blending a gripping story with unique combat and a stunning art style.", "https://www.youtube.com/watch?v=T9CcbwO9LFk", 4.90, 11000000),
(169, "Call of Duty: Black Ops", 59.99, "Activision", "2010-11-09", "Call of Duty: Black Ops takes players into covert Cold War operations with a gripping campaign, multiplayer, and the iconic Zombies mode.", "https://www.youtube.com/watch?v=OPTOVQFRggI", 4.60, 30000000),
(170, "Call of Duty: Black Ops 2", 59.99, "Activision", "2012-11-13", "Black Ops 2 features a futuristic setting with branching storylines, advanced weapons, and enhanced Zombies mode.", "https://www.youtube.com/watch?v=x3tedlWs1XY", 4.70, 31000000),
(171, "Call of Duty: Black Ops 3", 59.99, "Activision", "2015-11-06", "Black Ops 3 introduces co-op campaigns, a revamped Zombies mode, and fluid multiplayerement mechanics.", "https://www.youtube.com/watch?v=NoqpX0AS_1g", 4.50, 26000000),
(172, "Call of Duty: Black Ops 4", 59.99, "Activision", "2018-10-12", "Black Ops 4 brings a battle royale mode, expanded Zombies content, and classic multiplayer action.", "https://www.youtube.com/watch?v=6kqe2ICmTxc", 4.30, 24000000),
(173, "Call of Duty: Black Ops 6", 59.99, "Activision", "2024-11-10", "Black Ops 6 continues the iconic series with a mix of futuristic tech, gripping storylines, and expanded multiplayer modes.", "https://www.youtube.com/watch?v=LrBzuHF0sHs", 4.50, 20000000),
(174, "Bully", 19.99, "Rockstar Games", "2006-10-17", "Bully is an open-world game where players assume the role of a mischievous student navigating the social hierarchy of Bullworth Academy.", "https://www.youtube.com/watch?v=88KNf0MtU14", 4.50, 8000000),
(175, "The Callisto Protocol", 59.99, "Striking Distance Studios", "2022-12-02", "The Callisto Protocol is a survival horror game set in a prison on Jupiter\'s moon, blending terrifying combat and immersive storytelling.", "https://www.youtube.com/watch?v=IT7swHyN8FQ", 4.20, 3000000),
(176, "Counter-Strike 2", 0.00, "Valve", "2023-09-27", "Counter-Strike 2 is a competitive first-person shooter with updated graphics, new mechanics, and the classic tactical gameplay fans love.", "https://www.youtube.com/watch?v=c80dVYcL69E", 4.80, 50000000),
(177, "Dead Space 2", 59.99, "EA", "2011-01-25", "Dead Space 2 continues the horror with Isaac Clarke fighting Necromorphs in an intense, action-packed sequel.", "https://www.youtube.com/watch?v=776fi2I8e6U", 4.70, 5000000),
(178, "Dead Space 3", 59.99, "EA", "2013-02-05", "Dead Space 3 introduces co-op gameplay and expands the series\' sci-fi horror with new environments and storylines.", "https://www.youtube.com/watch?v=OvTR_gkgYZM", 4.40, 4500000),
(179, "Call of Duty: Black Ops Cold War", 59.99, "Activision", "2020-11-13", "Cold War takes players back to the 1980s with a Cold War-themed campaign, multiplayer, and Zombies.", "https://www.youtube.com/watch?v=JXOY-HWTErs", 4.40, 25000000),
(180, "DOOM Eternal", 59.99, "Bethesda", "2020-03-20", "DOOM Eternal is a high-octane first-person shooter where players slay demons across stunning environments with brutal weapons.", "https://www.youtube.com/watch?v=_UuktemkCFI", 4.90, 7000000),
(181, "DOOM", 59.99, "id Software", "1993-12-10", "DOOM is the iconic first-person shooter that defined the genre, featuring fast-paced demon-slaying gameplay.", "https://www.youtube.com/watch?v=RO90omga8D4", 4.90, 10000000),
(182, "DOOM 3", 59.99, "id Software", "2004-08-03", "DOOM 3 takes a more horror-focused approach, blending intense combat with atmospheric storytelling.", "https://www.youtube.com/watch?v=j8NaZZa54cs", 4.60, 5000000),
(183, "Fire Emblem: Three Houses", 59.99, "Nintendo", "2019-07-26", "Three Houses is a tactical RPG where players guide students at a military academy and make choices that shape the story.", "https://www.youtube.com/watch?v=rkux5h0PeXo&t=14s", 4.80, 4500000),
(184, "Mortal Kombat 1", 59.99, "NetherRealm Studios", "2023-09-14", "Mortal Kombat 1 reboots the iconic fighting game series with new storylines, characters, and brutal gameplay.", "https://www.youtube.com/watch?v=MYa7L4jp11E", 4.70, 5000000),
(185, "Mortal Kombat X", 59.99, "NetherRealm Studios", "2015-04-14", "Mortal Kombat X introduces a new generation of fighters with visceral combat and an engaging storyline.", "https://www.youtube.com/watch?v=KCHmqJgs1ow", 4.50, 7000000),
(186, "Minecraft", 29.99, "Mojang Studios", "2011-11-18", "Minecraft is a sandbox game that allows players to build, explore, and survive in a blocky, procedurally generated world.", "https://www.youtube.com/watch?v=MmB9b5njVbA", 4.90, 238000000),
(187, "Battlefield 1", 59.99, "Electronic Arts", "2016-10-21", "Battlefield 1 takes you back to World War I, featuring epic battles, trench warfare, and large-scale destruction.", "https://www.youtube.com/watch?v=YwSFUNMrWvk", 4.50, 15000000),
(188, "Battlefield 2042", 59.99, "Electronic Arts", "2021-11-19", "Battlefield 2042 is set in the near future, offering cutting-edge warfare with massive maps, dynamic weather, and new game modes.", "https://www.youtube.com/watch?v=ASzOzrB-a9E", 3.20, 5000000),
(189, "Battlefield 3", 49.99, "Electronic Arts", "2011-10-25", "Battlefield 3 features modern-day warfare with immersive graphics, vehicle combat, and intense multiplayer modes.", "https://www.youtube.com/watch?v=9DM7NsxOS0Q", 4.70, 25000000),
(190, "Battlefield 4", 59.99, "Electronic Arts", "2013-10-29", "Battlefield 4 offers next-gen graphics, large-scale destruction, and a dynamic battlefield environment with an emphasis on team play.", "https://www.youtube.com/watch?v=hl-VV9loYLw", 4.60, 22000000),
(191, "Battlefield V", 59.99, "Electronic Arts", "2018-11-20", "Battlefield V focuses on World War II with new modes, improved destruction, and enhanced teamwork mechanics in a variety of historic battles.", "https://www.youtube.com/watch?v=9OTkhsJUK0U", 4.30, 18000000),
(192, "Assassin\'s Creed Origins", 59.99, "Ubisoft", "2017-10-27", "Explore the origins of the Assassin Brotherhood in ancient Egypt.", "https://www.youtube.com/watch?v=-1gZLmI9e5w", 4.80, 10000000),
(193, "Assassin\'s Creed Odyssey", 59.99, "Ubisoft", "2018-10-05", "Dive into ancient Greece and shape your destiny as a legendary Spartan hero.", "https://www.youtube.com/watch?v=_ddQqzwH__4", 4.70, 11000000),
(194, "Assassin\'s Creed Rogue", 39.99, "Ubisoft", "2014-11-11", "Follow the journey of Shay, an Assassin turned Templar, during the Seven Years War.", "https://www.youtube.com/watch?v=RDeyI31pG8A", 4.40, 5000000),
(195, "Assassin\'s Creed Unity", 49.99, "Ubisoft", "2014-11-11", "Join Arno in the French Revolution and experience a stunningly detailed Paris.", "https://www.youtube.com/watch?v=m7Tb1pFl5_8", 4.20, 8000000),
(196, "Assassin\'s Creed Syndicate", 59.99, "Ubisoft", "2015-10-23", "Lead the Frye twins to liberate Victorian London from Templar control.", "https://www.youtube.com/watch?v=aSM_HzyOWOA", 4.30, 6000000),
(197, "Assassin\'s Creed Mirage", 49.99, "Ubisoft", "2023-10-05", "Return to the roots of Assassin\'s Creed in this Baghdad-based adventure.", "https://www.youtube.com/watch?v=IRNOoOYVn80", 4.60, 4000000),
(198, "Age of Empires II", 29.99, "Microsoft", "1999-09-30", "A classic real-time strategy game set across different historical periods.", "https://www.youtube.com/watch?v=N6kd1SYHW5k", 4.90, 25000000),
(199, "Age of Empires III", 39.99, "Microsoft", "2005-10-18", "A sequel to the acclaimed Age of Empires series, focusing on the colonial era.", "https://www.youtube.com/watch?v=UJ6T4BquQH0", 4.60, 20000000),
(200, "DiRT 3", 39.99, "Codemasters", "2011-05-24", "DiRT 3 is an off-road racing game featuring rally and gymkhana events with a wide variety of vehicles and challenging environments.", "", 4.50, 8000000),
(201, "DiRT 4", 59.99, "Codemasters", "2017-06-06", "DiRT 4 offers a thrilling off-road racing experience with dynamic weather, new modes, and over 50 rally cars.", "https://www.youtube.com/watch?v=V_DcVA2QzDM", 4.20, 5000000),
(202, "Dead or Alive 5", 39.99, "Koei Tecmo", "2012-09-25", "Dead or Alive 5 is a fast-paced, action-packed fighting game featuring a diverse roster of characters with intricate combat mechanics.", "https://www.youtube.com/watch?v=Qqui4LkqsrI", 4.30, 4000000),
(203, "F1 23", 69.99, "Codemasters", "2023-07-30", "F1 23 brings the excitement of Formula 1 racing to life with realistic tracks, cars, and a career mode that challenges players to be the best.", "https://www.youtube.com/watch?v=ewOZTzM3vUY", 4.70, 3000000),
(204, "Fable II", 19.99, "Microsoft Game Studios", "2008-10-21", "Fable II is an action RPG with a vast open world, offering rich quests, character development, and choices that shape the story.", "https://www.youtube.com/watch?v=5pouqKKjh_M", 4.60, 6000000),
(205, "Fable III", 29.99, "Microsoft Game Studios", "2010-10-26", "Fable III continues the series with a more refined action RPG experience, featuring moral choices, new abilities, and a deeper narrative.", "https://www.youtube.com/watch?v=QJnT3u01k18", 4.40, 5000000),
(206, "Far Cry 2", 49.99, "Ubisoft", "2008-10-21", "Far Cry 2 is a first-person shooter with an open-world setting, where players are tasked with eliminating a warlord in a dangerous African country.", "https://www.youtube.com/watch?v=gf5h4co4Ydc", 3.90, 8000000),
(207, "Far Cry 3", 59.99, "Ubisoft", "2012-12-04", "Far Cry 3 offers an open-world tropical island adventure with a compelling narrative, dangerous wildlife, and intense combat mechanics.", "https://www.youtube.com/watch?v=i2c1f_RDgGg", 4.70, 15000000),
(208, "Far Cry 4", 59.99, "Ubisoft", "2014-11-18", "Far Cry 4 expands the series with a new Himalayan setting, new vehicles, and improved multiplayer features while maintaining the core gameplay elements.", "https://www.youtube.com/watch?v=xI6uV47jKME", 4.50, 12000000),
(209, "Far Cry 6", 59.99, "Ubisoft", "2021-10-07", "Far Cry 6 brings a new island nation, where players fight against a ruthless dictator with a variety of weapons and guerrilla tactics.", "https://www.youtube.com/watch?v=DFze21M_O6s", 3.80, 8000000),
(210, "FIFA 14", 59.99, "EA Sports", "2013-09-24", "FIFA 14 brings improved gameplay mechanics, enhanced graphics, and a refined career mode to the popular football simulation series.", "https://www.youtube.com/watch?v=ZVx7vqtzACE", 4.50, 10000000),
(211, "FIFA 17", 59.99, "EA Sports", "2016-09-29", "FIFA 17 introduces a new story mode, enhanced career features, and improved graphics for the most realistic football simulation experience.", "https://www.youtube.com/watch?v=-3fjoe5Njpc", 4.60, 15000000),
(212, "FIFA 18", 59.99, "EA Sports", "2017-09-29", "FIFA 18 introduces new gameplay mechanics and features like the story mode and improved ball control, with stunning visuals for next-gen consoles.", "https://www.youtube.com/watch?v=Hocyr5izAAQ", 4.50, 18000000),
(213, "FIFA 19", 59.99, "EA Sports", "2018-09-28", "FIFA 19 introduces UEFA Champions League and enhanced gameplay for an even more immersive football experience.", "https://www.youtube.com/watch?v=OumZxTdMq_c", 4.40, 19000000),
(214, "FIFA 20", 59.99, "EA Sports", "2019-09-27", "FIFA 20 features new VOLTA Football, offering a fresh take on street and futsal football, as well as updates to the core gameplay mechanics.", "https://www.youtube.com/watch?v=XilsKZmWoBY", 4.30, 16000000),
(215, "FIFA 21", 59.99, "EA Sports", "2020-10-09", "FIFA 21 brings new gameplay innovations, including improved AI and skilles, as well as career mode improvements and VOLTA updates.", "https://www.youtube.com/watch?v=wppi4Kjzubk", 4.20, 14000000),
(216, "FIFA 22", 59.99, "EA Sports", "2021-10-01", "FIFA 22 features new HyperMotion technology for improved player animations, as well as more detailed career mode and ultimate team features.", "https://www.youtube.com/watch?v=SYsi5QuOJNE", 4.40, 17000000),
(217, "FC 24", 69.99, "EA Sports", "2023-09-29", "FC 24 is the latest entry in the FIFA franchise with enhanced graphics, improved gameplay, and a new experience for both career and ultimate team modes.", "https://www.youtube.com/watch?v=N91EB85mq4E", 4.50, 5000000),
(218, "FC 25", 69.99, "EA Sports", "2024-09-29", "FC 25 pushes the football simulation genre with next-gen features, better ball physics, and a deeper dive into player emotions and career paths.", "https://www.youtube.com/watch?v=RefXbk1_taI", 4.70, 2000000),
(219, "Call of Duty: Advanced Warfare", 59.99, "Activision", "2014-11-04", "Call of Duty: Advanced Warfare introduces futuristic warfare with exoskeletons, new weapons, and high-tech combat.", "https://www.youtube.com/watch?v=YSp8ZqIKEIM", 4.30, 21000000),
(220, "Call of Duty: Ghosts", 59.99, "Activision", "2013-11-05", "Call of Duty: Ghosts offers an engaging narrative with new gameplay mechanics, including customizable soldiers and new killstreaks.", "https://www.youtube.com/watch?v=tUBcYogq-3M", 3.90, 20000000),
(221, "Call of Duty: Infinite Warfare", 59.99, "Activision", "2016-11-04", "Call of Duty: Infinite Warfare takes players to space, with futuristic combat, space warfare, and a rich single-player campaign.", "https://www.youtube.com/watch?v=EeF3UTkCoxY", 3.70, 15000000),
(222, "Call of Duty: Modern Warfare 2", 59.99, "Activision", "2009-11-10", "Modern Warfare 2 is a classic entry in the series, featuring intense combat and a compelling storyline, set in modern-day conflicts.", "https://www.youtube.com/watch?v=blshENwbHgs", 4.80, 30000000),
(223, "Call of Duty: Modern Warfare 3", 59.99, "Activision", "2011-11-08", "Modern Warfare 3 continues the action-packed narrative with high-stakes missions and advanced multiplayer modes.", "https://www.youtube.com/watch?v=1xjCdN_rWCE", 4.60, 28000000),
(224, "Call of Duty: Vanguard", 59.99, "Activision", "2021-11-05", "Call of Duty: Vanguard brings WWII back to the series with fast-paced combat, a gripping single-player campaign, and exciting multiplayer.", "https://www.youtube.com/watch?v=6hE_DTx_i0M", 3.80, 10000000),
(225, "Call of Duty: WWII", 59.99, "Activision", "2017-11-03", "Call of Duty: WWII takes players back to the roots of the franchise with classic combat and a story set during World War II.", "https://www.youtube.com/watch?v=D4Q_XYVescc", 4.50, 20000000),
(226, "God of War: Ascension", 39.99, "Sony Computer Entertainment", "2013-03-12", "God of War: Ascension is a prequel to the original series, exploring Kratos\' early years and his struggle for redemption before becoming the God of War.", "https://www.youtube.com/watch?v=VJMK8oFY1rA", 4.10, 7000000),
(227, "God of War: Ragnarok", 69.99, "Sony Interactive Entertainment", "2022-11-09", "God of War: Ragnarok continues Kratos\' journey with his son Atreus, exploring Norse mythology in an epic story filled with action, puzzles, and powerful enemies.", "https://www.youtube.com/watch?v=g1wr0DfV73E", 4.90, 20000000),
(228, "Halo 2", 29.99, "Microsoft Game Studios", "2004-11-09", "Halo 2 continues the saga of Master Chief, with new weapons, vehicles, and an expanded multiplayer mode, delivering an even more intense combat experience.", "https://www.youtube.com/watch?v=QHnljglQ8Ag", 4.70, 8000000),
(229, "Halo 3", 29.99, "Microsoft Game Studios", "2007-09-25", "Halo 3 concludes the trilogy, bringing the epic battle against the Covenant to a dramatic conclusion, with enhanced multiplayer features and co-op gameplay.", "https://www.youtube.com/watch?v=yMwXD_zQfRw", 4.80, 14000000),
(230, "Halo 4", 59.99, "343 Industries", "2012-11-06", "Halo 4 introduces a new chapter in the Master Chief saga with an exciting new enemy, the Prometheans, and an expanded multiplayer experience.", "https://www.youtube.com/watch?v=GO376G4tbGM", 4.60, 10000000),
(231, "Halo 5: Guardians", 59.99, "343 Industries", "2015-10-27", "Halo 5: Guardians delivers intense multiplayer action with a focus on teamwork, while continuing the story of Master Chief and the mysterious Spartan Locke.", "https://www.youtube.com/watch?v=Rh_NXwqFvHc", 4.40, 8000000),
(232, "Halo Infinite", 69.99, "343 Industries", "2021-12-08", "Halo Infinite brings the iconic franchise back to its roots with an open-world campaign, new weapons, and expansive multiplayer modes, offering an immersive experience.", "https://www.youtube.com/watch?v=PyMlV5_HRWk", 4.70, 12000000),
(233, "Halo Wars", 49.99, "Microsoft Game Studios", "2009-02-26", "Halo Wars is a real-time strategy game set in the Halo universe, where players command units and lead humanity's defense against the Covenant in the early years of the war.", "https://www.youtube.com/watch?v=l785cqiTPpw", 4.20, 4000000),
(234, "Forza Horizon 4", 59.99, "Microsoft Studios", "2018-10-02", "Forza Horizon 4 is an open-world racing game with dynamic seasons, stunning visuals, and a variety of cars, offering an exhilarating racing experience.", "https://www.youtube.com/watch?v=RCRYs7yfeo4", 4.80, 10000000),
(235, "Hogwarts Legacy", 69.99, "Warner Bros. Interactive Entertainment", "2023-02-10", "Hogwarts Legacy is an open-world action RPG set in the Harry Potter universe, where players experience life as a student at Hogwarts in the 1800s.", "https://www.youtube.com/watch?v=BtyBjOW8sGY", 4.70, 8000000),
(236, "Knack", 39.99, "Sony Computer Entertainment", "2013-11-15", "Knack is an action-platformer where players control a small creature who can grow in size and power, fighting through various levels to save the world.", "https://www.youtube.com/watch?v=wbjR-_1cgTA", 3.80, 4000000),
(237, "Knack 2", 49.99, "Sony Interactive Entertainment", "2017-09-05", "Knack 2 improves upon its predecessor with enhanced gameplay mechanics, a co-op mode, and an even more engaging story.", "https://www.youtube.com/watch?v=peYgPDKFXIA", 4.20, 3000000),
(238, "League of Legends", 0.00, "Riot Games", "2009-10-27", "League of Legends is a competitive multiplayer online battle arena game where players control powerful champions in 5v5 matches.", "https://www.youtube.com/watch?v=BEbPi89HZ0I", 4.60, 150000000),
(239, "Mafia III", 59.99, "2K Games", "2016-10-07", "Mafia III is an open-world action-adventure game set in the 1960s, where players control Lincoln Clay, a war veteran seeking revenge on the mob.", "https://www.youtube.com/watch?v=TNiHOpHbCzM", 4.10, 8000000),
(240, "Martha is Dead", 49.99, "LKA", "2022-02-24", "Martha is Dead is a psychological horror game set in Italy during World War II, where the player must uncover dark secrets surrounding a twin sister\'s death.", "https://www.youtube.com/watch?v=vN-d-8nEo4w", 4.20, 2000000),
(241, "Mass Effect", 59.99, "Electronic Arts", "2021-05-14", "Mass Effect is a collection of the iconic Mass Effect trilogy with updated graphics and improved gameplay, offering a thrilling sci-fi RPG experience.", "https://www.youtube.com/watch?v=Dcg9_iaDhNk", 4.90, 12000000),
(242, "Mass Effect 2", 59.99, "Electronic Arts", "2010-01-26", "Mass Effect 2 continues the story of Commander Shepard as he assembles a crew to stop a galactic threat, blending RPG elements with action-packed gameplay.", "https://www.youtube.com/watch?v=lx9sPQpjgjU", 4.80, 13000000),
(243, "Mass Effect 3", 59.99, "Electronic Arts", "2012-03-06", "Mass Effect 3 concludes the trilogy with epic battles, story-driven choices, and intense combat, where Commander Shepard faces the Reapers to save humanity.", "https://www.youtube.com/watch?v=AluTOOCVXVQ", 4.80, 14000000),
(244, "Metro Exodus", 59.99, "Deep Silver", "2019-02-15", "Metro Exodus is a first-person shooter set in a post-apocalyptic Russia, combining stealth, exploration, and tactical combat with a gripping story.", "https://www.youtube.com/watch?v=c_YddLpfD5o", 4.50, 6000000),
(245, "MotoGP 22", 69.99, "Milestone", "2022-04-21", "MotoGP 22 offers a realistic motorcycle racing experience, featuring all official teams, riders, and circuits, with enhanced AI and physics for immersive gameplay.", "https://www.youtube.com/watch?v=kkami8prCjI", 4.30, 2000000),
(246, "NBA 2K24", 59.99, "2K Sports", "2023-09-08", "NBA 2K24 is a basketball simulation game offering realistic gameplay, enhanced graphics, and an expanded MyCareer mode for basketball fans worldwide.", "https://www.youtube.com/watch?v=BZvwJpvEjWE", 4.70, 5000000),
(247, "NBA 2K25", 59.99, "2K Sports", "2024-09-01", "NBA 2K25 continues the series with new game mechanics, more detailed player models, and exciting updates to the MyCareer and MyTeam modes.", "https://www.youtube.com/watch?v=qx0A921z8mA", 4.60, 3000000),
(248, "NFL 25", 59.99, "EA Sports", "2014-08-26", "NFL 25 is a sports simulation game that celebrates the 25th anniversary of the NFL franchise with enhanced graphics, gameplay, and a focus on the next generation of NFL stars.", "https://www.youtube.com/watch?v=oqHo4SLScgM", 4.50, 4000000),
(249, "Nioh", 59.99, "Sony Interactive Entertainment", "2017-02-07", "Nioh is an action RPG set in feudal Japan, where players fight samurai, demons, and mythical creatures in a quest for power and vengeance.", "https://www.youtube.com/watch?v=aMTH7Byv5vE", 4.40, 5000000),
(250, "No Man\'s Sky", 59.99, "Hello Games", "2016-08-09", "No Man\'s Sky is an exploration game set in an infinite, procedurally generated universe, offering players the chance to discover new planets, species, and resources.", "https://www.youtube.com/watch?v=aozqa_7PLhE", 4.30, 8000000),
(251, "Outlast Trials", 39.99, "Red Barrels", "2023-05-18", "Outlast Trials is a co-op survival horror game set in the Outlast universe, where players must escape terrifying environments while solving complex puzzles.", "https://www.youtube.com/watch?v=Ny1xR_4-6QA", 4.50, 2000000),
(252, "Outlast", 19.99, "Red Barrels", "2013-09-04", "Outlast is a first-person survival horror game where players must navigate through a mental asylum, using stealth and wits to survive deadly encounters.", "https://www.youtube.com/watch?v=Q97yE2zkNvs", 4.40, 8000000),
(253, "Payday 3", 59.99, "Starbreeze Studios", "2023-09-21", "Payday 3 is a cooperative first-person shooter where players take on the role of master criminals pulling off heists in various locations around the world.", "https://www.youtube.com/watch?v=TlkwDNirzF8", 4.50, 3000000),
(254, "Pokémon Black", 39.99, "Nintendo", "2010-09-18", "Pokémon Black is an RPG where players catch and train Pokémon in the Unova region, featuring a new set of Pokémon and a deeper storyline.", "https://www.youtube.com/watch?v=B-7gZIMxBoQ", 4.60, 15000000),
(255, "Pokémon Legends: Arceus", 59.99, "Nintendo", "2022-01-28", "Pokémon Legends: Arceus is an action RPG that introduces an open-world exploration experience in the Pokémon universe, set in the past of the Sinnoh region.", "https://www.youtube.com/watch?v=qZcgXYapc8Q", 4.80, 10000000),
(256, "Pokémon Scarlet", 59.99, "Nintendo", "2022-11-18", "Pokémon Scarlet is an open-world RPG in the Pokémon series that allows players to explore the Paldea region and catch hundreds of Pokémon.", "https://www.youtube.com/watch?v=yBPdzeF0lC4", 4.70, 12000000),
(257, "Pokémon Violet", 59.99, "Nintendo", "2022-11-18", "Pokémon Violet is a companion title to Pokémon Scarlet, featuring a futuristic version of the Paldea region and new gameplay mechanics.", "https://www.youtube.com/watch?v=yBPdzeF0lC4", 4.70, 12000000),
(258, "Pokémon White", 39.99, "Nintendo", "2010-09-18", "Pokémon White is the companion game to Pokémon Black, featuring similar gameplay with exclusive Pokémon and story elements in the Unova region.", "https://www.youtube.com/watch?v=B-7gZIMxBoQ", 4.60, 13000000),
(259, "Pokémon X", 39.99, "Nintendo", "2013-10-12", "Pokémon X is a role-playing game set in the Kalos region, introducing new gameplay features and 3D graphics to the series.", "https://www.youtube.com/watch?v=IfclgYT7h-A", 4.80, 16000000),
(260, "Pokémon Y", 39.99, "Nintendo", "2013-10-12", "Pokémon Y is the counterpart to Pokémon X, introducing new Pokémon and gameplay features in the Kalos region.", "https://www.youtube.com/watch?v=IfclgYT7h-A", 4.80, 15000000),
(261, "Predator: Hunting Grounds", 39.99, "IllFonic", "2020-04-24", "Predator: Hunting Grounds is an asymmetrical multiplayer shooter where players either control a fireteam of soldiers or the deadly Predator in intense 4v1 combat.", "https://www.youtube.com/watch?v=JG8WUSnGrqQ", 4.20, 2000000),
(262, "Rainbow Six Siege", 49.99, "Ubisoft", "2015-12-01", "Rainbow Six Siege is a tactical first-person shooter where players control elite operators from various counter-terrorism units in strategic 5v5 multiplayer matches.", "https://www.youtube.com/watch?v=ebwGwlBK-jQ", 4.70, 70000000),
(263, "Resident Evil 5", 29.99, "Capcom", "2009-03-05", "Resident Evil 5 is a survival horror action game where players control Chris Redfield as he navigates Africa to stop a new outbreak of the virus.", "https://www.youtube.com/watch?v=5lYNJQVz_Pc", 4.30, 9000000),
(264, "Resident Evil 6", 39.99, "Capcom", "2012-10-02", "Resident Evil 6 offers a mix of survival horror and action gameplay, with multiple protagonists and global settings as players fight to survive against bio-terrorism threats.", "https://www.youtube.com/watch?v=sS_bGpe9qE8", 4.20, 11000000),
(265, "Resident Evil 7", 59.99, "Capcom", "2017-01-24", "Resident Evil 7 returns to the series\' horror roots, featuring a first-person perspective as players try to escape a creepy plantation house filled with terrifying creatures.", "https://www.youtube.com/watch?v=RgYqQsbKn6w", 4.80, 13000000),
(266, "Sea of Thieves", 39.99, "Rare", "2018-03-20", "Sea of Thieves is an open-world pirate adventure game where players sail, fight, and explore together, seeking treasure and battling legendary foes.", "https://www.youtube.com/watch?v=r5JIBaasuE8", 4.30, 10000000),
(267, "Spider-Man 2", 59.99, "Insomniac Games", "2023-10-20", "Spider-Man 2 is an action-adventure game where players control both Peter Parker and Miles Morales as they fight new threats and explore a detailed open-world New York City.", "https://www.youtube.com/watch?v=9fVYKsEmuRo", 4.90, 5000000),
(268, "Horizon Call of the Mountain", 59.99, "Guerrilla Games", "2022-02-22", "Horizon Call of the Mountain is a VR spin-off in the Horizon series, offering a new perspective on the world of Aloy as players experience intense exploration and combat in virtual reality.", "https://www.youtube.com/watch?v=cUWB3NBpcbo", 4.60, 2000000),
(269, "Steep", 59.99, "Ubisoft", "2016-12-02", "Steep is an extreme sports game that allows players to snowboard, ski, paraglide, and wingsuit across open-world mountains, with a focus on multiplayer challenges.", "https://www.youtube.com/watch?v=TNhyWptLq_Y", 4.20, 4000000),
(270, "Tekken 8", 59.99, "Bandai Namco Entertainment", "2023-01-26", "Tekken 8 continues the iconic fighting series with new mechanics, characters, and a deep story mode focused on the Mishima family feud.", "https://www.youtube.com/watch?v=3pwiP6oEMmw", 4.70, 3000000),
(271, "Tetris Effect", 39.99, "Monstars", "2018-11-09", "Tetris Effect is a mesmerizing reinvention of the classic puzzle game, combining vibrant visuals, music, and immersive environments to create an unforgettable experience.", "https://www.youtube.com/watch?v=PFVL6t8IHE8", 4.80, 6000000),
(272, "The Chant", 39.99, "Prime Matter", "2022-11-03", "The Chant is a psychological horror game that blends exploration, combat, and puzzle-solving in a mysterious cult setting where players must survive terrifying encounters.", "https://www.youtube.com/watch?v=i2x45LEoU0E", 4.10, 2000000),
(273, "The Division", 59.99, "Ubisoft", "2016-03-08", "The Division is an online open-world action RPG set in a post-apocalyptic New York, where players must restore order by completing missions and fighting against enemies in a tactical combat environment.", "https://www.youtube.com/watch?v=uElsBflqgYw", 4.30, 15000000),
(274, "The Forest", 19.99, "Endnight Games", "2018-04-30", "The Forest is a survival horror game where players must navigate through a forest filled with cannibalistic mutants, crafting weapons and shelters to survive.", "https://www.youtube.com/watch?v=ay3tDjnBziY", 4.50, 7000000),
(275, "The Quarry", 59.99, "2K Games", "2022-06-10", "The Quarry is an interactive drama and horror game where players control a group of teenagers at a summer camp, making decisions that determine who lives and who dies.", "https://www.youtube.com/watch?v=2Cst4YHdHXI", 4.60, 5000000),
(276, "Titanfall", 59.99, "Respawn Entertainment", "2014-03-11", "Titanfall is a futuristic first-person shooter where players control highly mobile soldiers and massive mechs in fast-paced multiplayer battles.", "https://www.youtube.com/watch?v=3FPtT4C870c", 4.50, 10000000),
(277, "Titanfall 2", 59.99, "Respawn Entertainment", "2016-10-28", "Titanfall 2 improves upon its predecessor with an enhanced single-player campaign, deeper multiplayer options, and an exciting new story involving mechs and pilots.", "https://www.youtube.com/watch?v=ktw2k3m7Qko", 4.90, 7000000),
(278, "The Last of Us Part 1", 69.99, "Naughty Dog", "2022-09-02", "The Last of Us Part 1 is a remake of the beloved action-adventure game, following Joel and Ellie as they navigate a post-apocalyptic world filled with infected and dangerous survivors.", "https://www.youtube.com/watch?v=R2Ebc_OFeug", 4.80, 10000000),
(279, "Tormented Souls", 29.99, "Dual Effect", "2021-08-27", "Tormented Souls is a survival horror game with fixed-camera perspectives, focusing on exploration and puzzle-solving to escape a creepy mansion filled with disturbing secrets.", "https://www.youtube.com/watch?v=JN4DmhYZbz0", 4.40, 2000000),
(280, "Watchdogs", 59.99, "Ubisoft", "2014-05-27", "Watchdogs is an open-world action game where players control Aiden Pearce, a hacker seeking revenge, using his ability to manipulate the city\'s infrastructure.", "https://www.youtube.com/watch?v=PFko4Kut39s", 4.30, 15000000),
(281, "Watchdogs 2", 59.99, "Ubisoft", "2016-11-15", "Watchdogs 2 continues the story of hacking and rebellion in San Francisco, where Marcus Holloway fights against corporate control with his elite hacking skills.", "https://www.youtube.com/watch?v=2GIVVsTKTLg", 4.40, 10000000),
(282, "Wolfenstein: The New Order", 59.99, "Bethesda Softworks", "2014-05-20", "Wolfenstein: The New Order follows BJ Blazkowicz as he battles an alternate reality where Nazis won World War II and control the world with advanced technology.", "https://www.youtube.com/watch?v=Pht8Bsq8Cno", 4.80, 12000000),
(283, "Wolfenstein: The Old Blood", 29.99, "Bethesda Softworks", "2015-05-05", "Wolfenstein: The Old Blood is a prequel to The New Order, offering new locations and a fresh storyline as BJ Blazkowicz faces Nazi threats in 1946.", "https://www.youtube.com/watch?v=Viv8e9_-kHo", 4.70, 6000000),
(284, "Wolfenstein: The Young Blood", 39.99, "Bethesda Softworks", "2019-07-26", "Wolfenstein: The Young Blood follows BJ Blazkowicz\'s twin daughters in an alternate 1980s where they fight against Nazis in Paris.", "https://www.youtube.com/watch?v=Zjwo5EJxn9E", 4.40, 5000000),
(285, "World of Warships", 0.00, "Wargaming.net", "2015-09-17", "World of Warships is a free-to-play naval combat MMO where players control warships and engage in large-scale online battles in historic naval settings.", "https://www.youtube.com/watch?v=RQK6hH5-nwU", 4.60, 30000000),
(286, "WWE 2K23", 59.99, "2K Sports", "2023-03-17", "WWE 2K23 brings the excitement of professional wrestling with improved graphics, animations, and gameplay mechanics, featuring all the latest WWE superstars and legends.", "https://www.youtube.com/watch?v=Y1Fewy9QcOI", 4.70, 4000000),
(287, "WWE 2K24", 59.99, "2K Sports", "2024-03-17", "WWE 2K24 continues the series with enhanced gameplay features, new match types, and the latest roster of WWE stars, delivering an authentic wrestling experience.", "https://www.youtube.com/watch?v=j-2y-ZYezIo", 4.80, 3000000),
(288, "XDefiant", 0.00, "Ubisoft", "2023-07-15", "XDefiant is a free-to-play multiplayer shooter that mixes fast-paced action with factions inspired by Ubisoft\'s games, offering customizable loadouts and intense combat.", "https://www.youtube.com/watch?v=NoNpmAzGyB8", 4.30, 1000000),
(289, "Silent Hill: Downpour", 49.99, "Konami", "2012-03-13", "Silent Hill: Downpour is a survival horror game that follows the story of Murphy Pendleton as he navigates the eerie town of Silent Hill, encountering psychological horrors and moral choices.", "https://www.youtube.com/watch?v=kz_-YNwxslw", 4.20, 2000000),
(290, "Silent Hill: Shattered Memories", 39.99, "Konami", "2009-12-08", "Silent Hill: Shattered Memories is a reimagining of the original Silent Hill, featuring psychological profiling and a unique approach to survival horror gameplay.", "https://www.youtube.com/watch?v=bpWp195CYTk", 4.40, 1500000),
(291, "Total War: Warhammer", 59.99, "SEGA", "2016-05-24", "Total War: Warhammer is a turn-based strategy game combined with real-time tactical battles, set in the fantasy Warhammer universe, featuring legendary heroes, monstrous units, and epic campaigns.", "https://www.youtube.com/watch?v=vakF40RDWnU", 4.80, 5000000),
(292, "Total War: Warhammer II", 59.99, "SEGA", "2017-09-28", "Total War: Warhammer II expands the series with new factions, epic campaigns, and a unique story-driven Vortex Campaign set in the fantasy Warhammer world.", "https://www.youtube.com/watch?v=2sIyxYwJzLY", 4.90, 6000000);

COMMIT;