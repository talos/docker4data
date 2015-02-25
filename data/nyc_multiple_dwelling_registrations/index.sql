BEGIN TRANSACTION;
CREATE INDEX bbl ON "nyc_multiple_dwelling_registrations" ("boroid", "block", "lot");
END TRANSACTION;
