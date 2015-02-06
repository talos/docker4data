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
ALTER TABLE pluto ADD PRIMARY KEY ("borough", "block", "lot");
--CREATE INDEX pluto_geom ON pluto USING GIST ("lonlat");
--CREATE INDEX ON pluto (
      --ADD CONSTRAINT "acris_legals_master"
      --    FOREIGN KEY ("Document ID", "Good_through date")
      --    REFERENCES "acris_master" ("Document ID", "Good_through date"),
END TRANSACTION;

BEGIN TRANSACTION;
CREATE VIEW acris AS
SELECT
  m."document_id", m."crfn", m."recorded_borough", m."doc_type", m."document_date", m."document_amt", m."recorded_datetime", m."modified_date", m."reel_yr", m."reel_nbr", m."reel_pg", m."percent_trans", p."party_type", p."name", p."addr1", p."addr2", p."country", p."city", p."state", p."zip", l."borough", l."block", l."lot", l."easement", l."partial_lot", l."air_rights", l."subterranean_rights", l."property_type", l."street_number", l."street_name", l."addr_unit", pl."lonlat", pl."boroughtext", pl."cd", pl."ct2010", pl."cb2010", pl."schooldist", pl."council", pl."zipcode", pl."firecomp", pl."policeprct", pl."address", pl."zonedist1", pl."zonedist2", pl."zonedist3", pl."zonedist4", pl."overlay1", pl."overlay2", pl."spdist1", pl."spdist2", pl."ltdheight", pl."allzoning1", pl."allzoning2", pl."splitzone", pl."bldgclass", pl."landuse", pl."easements", pl."ownertype", pl."ownername", pl."lotarea", pl."bldgarea", pl."comarea", pl."resarea", pl."officearea", pl."retailarea", pl."garagearea", pl."strgearea", pl."factryarea", pl."otherarea", pl."areasource", pl."numbldgs", pl."numfloors", pl."unitsres", pl."unitstotal", pl."lotfront", pl."lotdepth", pl."bldgfront", pl."bldgdepth", pl."ext", pl."proxcode", pl."irrlotcode", pl."lottype", pl."bsmtcode", pl."assessland", pl."assesstot", pl."exemptland", pl."exempttot", pl."yearbuilt", pl."builtcode", pl."yearalter1", pl."yearalter2", pl."histdist", pl."landmark", pl."builtfar", pl."residfar", pl."commfar", pl."facilfar", pl."bbl", pl."condono", pl."tract2010", pl."xcoord", pl."ycoord", pl."zonemap", pl."zmcode", pl."sanborn", pl."taxmap", pl."edesignum", pl."appbbl", pl."appdate", pl."plutomapid", pl."version"
FROM
acris_master m, acris_parties p, acris_legals l, pluto pl;
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


