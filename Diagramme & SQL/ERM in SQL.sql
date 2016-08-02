-- #### TODO #######
-- länge bei strings
-- mit AKD abgleich + Reihenfolge
in beschreibung z.b. aktionszustände erklären
-- #################

-- Datenbank erzeugen
CREATE DATABASE HOCHZEITSPLANER;


-- Benutze für alles folgende die gerade eben erzeugte Datenbank
USE HOCHZEITSPLANER;


-- Erzeuge Extra-Tabellen

CREATE TABLE AktionsZustaende (
	aktionsZustandID INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
	beschreibung VARCHAR(250) NOT NULL,
	PRIMARY KEY ( aktionsZustandID )
);

CREATE TABLE AktionsArten (
	aktionsArtID INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
	beschreibung VARCHAR(250) NOT NULL,
	PRIMARY KEY ( aktionsArtID )
);

CREATE TABLE HilfsmittelArten (
	hilfsmittelArtID INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
	beschreibung VARCHAR(250) NOT NULL,
	PRIMARY KEY ( hilfsmittelArtID )
);

CREATE TABLE Telefonnummern (
	telefonnnummerID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	telefonnnummer VARCHAR(100) NOT NULL,
	PRIMARY KEY ( telefonnnummerID )
);

CREATE TABLE EmailAdressen (
	emailAdresseID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	emailAdresse VARCHAR(100) NOT NULL,
	PRIMARY KEY ( emailAdresseID )
);


-- Erzeuge Entity-Tabellen

CREATE TABLE Personen (
 	personID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	name VARCHAR(250) NOT NULL,
	adresse VARCHAR(250) NOT NULL,
	istDienstleister BOOL NOT NULL DEFAULT FALSE,		
	PRIMARY KEY ( personID )		
);

CREATE TABLE Hochzeitsveranstaltungen (
	hochzeitsID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	titel VARCHAR(250) NOT NULL,
	motto VARCHAR(250),
	hochzeitsmanagerID INT UNSIGNED NOT NULL,
	hochzeitspaarID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( hochzeitsID ),
	FOREIGN KEY ( hochzeitsmanagerID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	FOREIGN KEY ( hochzeitspaarID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
);

CREATE TABLE Caterer (
	catererID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	beschreibung VARCHAR(255),
	kontaktPerson INT UNSIGNED NOT NULL,
	zumVergleich BOOL NOT NULL DEFAULT FALSE,
	PRIMARY KEY ( catererID ),
	FOREIGN KEY ( kontaktPerson ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
);

CREATE TABLE Aktionen (
	aktionID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	titel VARCHAR(250) NOT NULL,
	beschreibung VARCHAR(250) NOT NULL,
	hochzeitsID INT UNSIGNED NOT NULL,
	notiz VARCHAR(250),
	prioritaet TINYINT NOT NULL,
	anfang DATETIME NOT NULL,
	ende DATETIME NOT NULL,
	aktionsArt INT UNSIGNED NOT NULL,
	versteckt BOOL NOT NULL DEFAULT true,
	aktionsZustand INT UNSIGNED NOT NULL,
	meilenstein BOOL NOT NULL DEFAULT false,
	PRIMARY KEY ( aktionID ),
	FOREIGN KEY ( aktionsZustand ) REFERENCES AktionsZustaende(aktionsZustandID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	FOREIGN KEY ( aktionsArt ) REFERENCES AktionsArten(aktionsArtID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	FOREIGN KEY ( hochzeitsID ) REFERENCES Hochzeitsveranstaltungen(hochzeitsID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
); 

CREATE TABLE Nahrungsmittel (
	nahrungsmittelID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	beschreibung VARCHAR (250),
	menge DOUBLE UNSIGNED NOT NULL,
	mengenbeschreibung VARCHAR(50) NOT NULL,
	PRIMARY KEY ( nahrungsmittelID )
);

CREATE TABLE Medien(
	mediumID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	uri VARCHAR(250) NOT NULL UNIQUE,
	title VARCHAR(250) NOT NULL,
	PRIMARY KEY ( mediumID )
);

CREATE TABLE Belege(
	belegID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	kosten DOUBLE UNSIGNED NOT NULL,
	währung CHAR(3) NOT NULL,
	title VARCHAR(250) NOT NULL,
	beschreibung VARCHAR(250), 
	private BOOL NOT NULL,
	PRIMARY KEY ( belegID )
);

CREATE TABLE Hilfsmittel (
	hilfsmittelID INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
	title VARCHAR(250) NOT NULL,
	beschreibung VARCHAR(250),
	hilfsmittelArt INT UNSIGNED NOT NULL,
	PRIMARY KEY ( hilfsmittelID ),
	FOREIGN KEY ( hilfsmittelArt ) REFERENCES HilfsmittelArten(hilfsmittelArtID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
);

CREATE TABLE Orte (
	ortID INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
	titel VARCHAR(250),
	strasse VARCHAR(250) NOT NULL,
	hausnummer VARCHAR(10) NOT NULL,
	adressZusatz VARCHAR(250),
	stadt VARCHAR(250),
	postleitzahl VARCHAR(50) NOT NULL,
	provinz VARCHAR(250) NOT NULL,
	land CHAR(3) NOT NULL,
	PRIMARY KEY ( ortID )
);

CREATE TABLE NichtInformierteNutzer(
	personID INT UNSIGNED NOT NULL,
	aktionID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( personID, aktionID ),
	FOREIGN KEY ( personID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( aktionID ) REFERENCES Aktionen(aktionID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


-- Erzeuge Relationen

CREATE TABLE Gaeste (
	hochzeitsID INT UNSIGNED NOT NULL,
	personID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( hochzeitsID, personID ),
	FOREIGN KEY ( hochzeitsID ) REFERENCES Hochzeitsveranstaltungen(hochzeitsID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( personID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE HochzeitsCaterer (
	hochzeitsID INT UNSIGNED,
	catererID INT UNSIGNED,
	PRIMARY KEY ( hochzeitsID, catererID ),
	FOREIGN KEY ( hochzeitsID ) REFERENCES Hochzeitsveranstaltungen(hochzeitsID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( catererID ) REFERENCES Caterer(catererID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE HochzeitsUnterhaltunsmanager (
	hochzeitsID INT UNSIGNED,
	unterhaltungsmanagerID INT UNSIGNED,
	PRIMARY KEY ( hochzeitsID, unterhaltungsmanagerID ),
	FOREIGN KEY ( hochzeitsID ) REFERENCES Hochzeitsveranstaltungen(hochzeitsID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( unterhaltungsmanagerID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE AktionsVerantwortliche (
	aktionID INT UNSIGNED NOT NULL,
	personID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( aktionID, personID ),
	FOREIGN KEY ( aktionID ) REFERENCES Aktionen(aktionID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( personID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE AktionsTeilnehmner (
	aktionID INT UNSIGNED NOT NULL,
	personID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( aktionID, personID ),
	FOREIGN KEY ( aktionID ) REFERENCES Aktionen(aktionID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( personID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE CatererEssen (
	catererID INT UNSIGNED NOT NULL,
	essenID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( catererID, essenID ),
	FOREIGN KEY ( catererID ) REFERENCES Caterer(catererID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( essenID ) REFERENCES Nahrungsmittel(nahrungsmittelID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE CatererTrinken (
	catererID INT UNSIGNED NOT NULL,
	trinkenID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( catererID, trinkenID ),
	FOREIGN KEY ( catererID ) REFERENCES Caterer(catererID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( trinkenID ) REFERENCES Nahrungsmittel(nahrungsmittelID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE AktionsOrte (
	aktionID INT UNSIGNED NOT NULL,
	ortID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( aktionID, ortID ),
	FOREIGN KEY ( aktionID ) REFERENCES Aktionen(aktionID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( ortID ) REFERENCES Orte(ortID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE AktionsMedien (
	aktionID INT UNSIGNED NOT NULL,
	mediumID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( aktionID, mediumID ),
	FOREIGN KEY ( aktionID ) REFERENCES Aktionen(aktionID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( mediumID ) REFERENCES Medien(mediumID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE MedienBelege (
	mediumID INT UNSIGNED NOT NULL,
	belegID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( mediumID, belegID ),
	FOREIGN KEY ( mediumID ) REFERENCES Medien(mediumID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( belegID ) REFERENCES Belege(belegID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE AktionsBelege (
	aktioNID INT UNSIGNED NOT NULL,
	belegID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( aktioNID, belegID ),
	FOREIGN KEY ( aktionID ) REFERENCES Aktionen(aktionID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( belegID ) REFERENCES Belege(belegID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE AktionsHilfsmittel (
	aktionID INT UNSIGNED NOT NULL,
	hilfsmittelID INT UNSIGNED NOT NULL,
	anzahl INT UNSIGNED NOT NULL DEFAULT 1,
	PRIMARY KEY ( aktionID, hilfsmittelID ),
	FOREIGN KEY ( aktionID ) REFERENCES Aktionen(aktionID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( hilfsmittelID ) REFERENCES Hilfsmittel(hilfsmittelID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE HilfsmittelBelege (
	hilfsmittelID INT UNSIGNED NOT NULL,
	belegID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( hilfsmittelID, belegID ),
	FOREIGN KEY ( hilfsmittelID ) REFERENCES Hilfsmittel(hilfsmittelID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( belegID ) REFERENCES Belege(belegID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE PersonenMailadressen (
	personID INT UNSIGNED NOT NULL,
	emailAdresseID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( personID, emailAdresseID )	,
	FOREIGN KEY ( personID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( emailAdresseID ) REFERENCES Emailadressen(emailAdresseID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE PersonenTelefonnummern (
	personID INT UNSIGNED NOT NULL,
	telefonnnummerID INT UNSIGNED NOT NULL,
	PRIMARY KEY ( personID, telefonnnummerID ),
	FOREIGN KEY ( personID ) REFERENCES Personen(personID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY ( telefonnnummerID ) REFERENCES Telefonnummern(telefonnnummerID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);