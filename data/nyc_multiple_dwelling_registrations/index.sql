BEGIN TRANSACTION;
CREATE INDEX bbl ON "nyc_multiple_dwelling_registrations" ("BoroID", "Block", "Lot");
END TRANSACTION;
