BEGIN TRANSACTION;
ALTER TABLE acris_master ADD PRIMARY KEY ("document_id", "good_through_date");
--CREATE INDEX ON acris_master ("doc_type");
END TRANSACTION;

BEGIN TRANSACTION;
CREATE INDEX ON acris_references ("document_id", "good_through_date");
--ALTER TABLE acris_references
--      ADD CONSTRAINT "acris_references_master_id"
--          FOREIGN KEY ("Document ID", "Good_through_date") --          REFERENCES "acris_master" ("Document ID", "Good_through date"),
--      ADD CONSTRAINT "acris_references_master_ref"
--          FOREIGN KEY ("Doc_id_ref", "Good_through date")
--          REFERENCES "acris_master" ("Document ID", "Good_through date");
END TRANSACTION;

BEGIN TRANSACTION;
CREATE INDEX ON acris_parties ("document_id", "good_through_date");
      --ADD CONSTRAINT "acris_parties_master"
      --    FOREIGN KEY ("Document ID", "Good_through date")
      --    REFERENCES "acris_master" ("Document ID", "Good_through date");
END TRANSACTION;

BEGIN TRANSACTION;
CREATE INDEX ON acris_legals ("document_id", "good_through_date");
CREATE INDEX ON acris_legals ("borough", "block", "lot", "easement");
  /* FK constraint with pluto doesn't work because of bad {block:0 lot:0} legals
   * records */
--ALTER TABLE acris_legals
--      ADD CONSTRAINT "acris_legals_pluto"
--          FOREIGN KEY ("Borough", "Block", "Lot")
--          REFERENCES "pluto" ("BoroCode", "Block", "Lot");

      --ADD CONSTRAINT "acris_legals_master"
      --    FOREIGN KEY ("Document ID", "Good_through date")
      --    REFERENCES "acris_master" ("Document ID", "Good_through date"),
END TRANSACTION;

BEGIN TRANSACTION;
--INDEX ON pluto ("BoroCode", "Block", "Lot");
ALTER TABLE pluto ADD PRIMARY KEY ("borocode", "block", "lot");
--CREATE INDEX pluto_geom ON pluto USING GIST ("lonlat");
--CREATE INDEX ON pluto (
      --ADD CONSTRAINT "acris_legals_master"
      --    FOREIGN KEY ("Document ID", "Good_through date")
      --    REFERENCES "acris_master" ("Document ID", "Good_through date"),
END TRANSACTION;

--VACUUM acris_master;
--VACUUM acris_parties;
--VACUUM acris_references;
--VACUUM acris_remarks;
--VACUUM acris_legals;

/*select "ZipCode", COUNT(*)
    FROM pluto p
    JOIN acris_legals l ON
        p."BoroCode" = l."Borough" AND
        p."Block" = l."Block" AND
        p."Lot" = l."Lot"
    JOIN acris_master m ON
        l."Document ID" = m."Document ID"
WHERE "Doc_type" IN ('DEED', 'DEEDO')
GROUP BY "ZipCode"
ORDER BY "ZipCode";
WHERE "CD" = 302;*/
--WHERE p."BoroCode" = 3 and p."Block" = 1772 and p."Lot" = 74;


