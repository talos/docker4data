BEGIN TRANSACTION;
ALTER TABLE acris_master
      ADD PRIMARY KEY ("Document ID", "Good_through date");
END TRANSACTION;

BEGIN TRANSACTION;
CREATE INDEX ON acris_references ("Document ID", "Good_through date");
--ALTER TABLE acris_references
--      ADD CONSTRAINT "acris_references_master_id"
--          FOREIGN KEY ("Document ID", "Good_through date")
--          REFERENCES "acris_master" ("Document ID", "Good_through date"),
--      ADD CONSTRAINT "acris_references_master_ref"
--          FOREIGN KEY ("Doc_id_ref", "Good_through date")
--          REFERENCES "acris_master" ("Document ID", "Good_through date");
END TRANSACTION;

BEGIN TRANSACTION;
CREATE INDEX ON acris_parties ("Document ID", "Good_through date");
      --ADD CONSTRAINT "acris_parties_master"
      --    FOREIGN KEY ("Document ID", "Good_through date")
      --    REFERENCES "acris_master" ("Document ID", "Good_through date");
END TRANSACTION;

BEGIN TRANSACTION;
CREATE INDEX ON acris_legals ("Document ID", "Good_through date");
CREATE INDEX ON acris_legals ("Borough", "Block", "Lot", "Easement");
      --ADD CONSTRAINT "acris_legals_master"
      --    FOREIGN KEY ("Document ID", "Good_through date")
      --    REFERENCES "acris_master" ("Document ID", "Good_through date"),
END TRANSACTION;

VACUUM acris_master;
VACUUM acris_parties;
VACUUM acris_references;
VACUUM acris_remarks;
VACUUM acris_legals;
