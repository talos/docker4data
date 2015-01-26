
/* To run: psql acris < schema.sql */

BEGIN TRANSACTION;
CREATE TABLE "master" (
	"Document ID"	TEXT,
	"Record_type"	TEXT,
	"CRFN"	BIGINT,
	"Recorded_borough"	SMALLINT,
	"Doc_type"	TEXT,
	"Document Date"	DATE,
	"Document_amt"	REAL,
	"Recorded_datetime"	DATE,
	"Modified date"	DATE,
	"Reel_yr"	INTEGER,
	"Reel_nbr"	INTEGER,
	"Reel_pg"	INTEGER,
	"Percent_trans"	REAL,
	"Good_through date"	TEXT,
	PRIMARY KEY ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE TABLE "references" (
	"Document ID"	TEXT,
	"Record_type"	TEXT,
	"CRFN"	TEXT,
	"Doc_id_ref"	TEXT,
	"Reel_yr"	INTEGER,
	"Reel_borough"	INTEGER,
	"Reel_nbr"	INTEGER,
	"Reel_pg"	INTEGER,
	"Good_through date"	TEXT,
	FOREIGN KEY ("Document ID", "Good_through date")
		REFERENCES "master" ("Document ID", "Good_through date"),
	FOREIGN KEY ("Doc_id_ref", "Good_through date")
		REFERENCES "master" ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE TABLE "parties" (
	"Document ID"	TEXT,
	"Record_type"	TEXT,
	"Party_type"	SMALLINT,
	"Name"	TEXT,
	"Addr1"	TEXT,
	"Addr2"	TEXT,
	"Country"	TEXT,
	"City"	TEXT,
	"State"	TEXT,
	"Zip"	TEXT,
	"Good_through date"	TEXT,
	FOREIGN KEY ("Document ID", "Good_through date")
		REFERENCES "master" ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE TABLE "legals" (
	"Document ID"	TEXT,
	"Record_type"	TEXT,
	"Borough"	SMALLINT,
	"Block"	INTEGER,
	"Lot"	INTEGER,
	"Easement"	TEXT,
	"Partial_lot"	TEXT,
	"Air_rights"	TEXT,
	"Subterranean_rights"	TEXT,
	"Property_type"	TEXT,
	"Street_number"	TEXT,
	"Street_Name"	TEXT,
	"Addr_unit"	TEXT,
	"Good_through date"	TEXT,
	FOREIGN KEY ("Document ID", "Good_through date")
		REFERENCES "master" ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE INDEX BBLE ON "legals"
    ("Borough", "Block", "Lot", "Easement");
END TRANSACTION;

BEGIN TRANSACTION;
CREATE TABLE "remarks" (
	"Document ID"	TEXT,
	"Record_type"	TEXT,
	"Reference by CRFN"	TEXT,
	"Reference by Doc ID"	TEXT,
	"Reference by Reel Year"	TEXT,
	"Reference by Reel Borough"	TEXT,
	"Reference by Reel Nbr"	TEXT,
	"Reference by Reel Page"	TEXT,
	"Good_through date"	TEXT,
	FOREIGN KEY ("Document ID", "Good_through date")
		REFERENCES "master" ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE INDEX BBLE ON "legals"
    ("Borough", "Block", "Lot", "Easement");
END TRANSACTION;
