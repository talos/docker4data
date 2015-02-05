BEGIN TRANSACTION;
CREATE TABLE "acris_master" (
	"document_id"	text,
	"record_type"	text,
	"crfn"	bigint,
	"recorded_borough"	smallint,
	"doc_type"	text,
	"document_date"	date,
	"document_amt"	real,
	"recorded_datetime"	date,
	"modified_date"	date,
	"reel_yr"	integer,
	"reel_nbr"	integer,
	"reel_pg"	integer,
	"percent_trans"	real,
	"good_through_date"	text
	--, primary key ("document_id", "good_through_date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE TABLE "acris_references" (
	"document_id"	text,
	"record_type"	text,
	"crfn"	text,
	"doc_id_ref"	text,
	"reel_yr"	integer,
	"reel_borough"	integer,
	"reel_nbr"	integer, "reel_pg"	integer,
	"good_through_date"	text
	-- , FOREIGN KEY ("Document ID", "Good_through date")
	-- 	REFERENCES "acris_master" ("Document ID", "Good_through date"),
	-- FOREIGN KEY ("Doc_id_ref", "Good_through date")
	-- 	REFERENCES "acris_master" ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE TABLE "acris_parties" (
	"document_id"	text,
	"record_type"	text,
	"party_type"	smallint,
	"name"	text,
	"addr1"	text,
	"addr2"	text,
	"country"	text,
	"city"	text,
	"state"	text,
	"zip"	text,
	"good_through_date"	text
	--, FOREIGN KEY ("Document ID", "Good_through date")
	--	REFERENCES "acris_master" ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE TABLE "acris_legals" (
	"document_id"	text,
	"record_type"	text,
	"borough"	smallint,
	"block"	integer,
	"lot"	integer,
	"easement"	text,
	"partial_lot"	text,
	"air_rights"	text,
	"subterranean_rights"	text,
	"property_type"	text,
	"street_number"	text,
	"street_name"	text,
	"addr_unit"	text,
	"good_through_date"	text
	--, FOREIGN KEY ("Document ID", "Good_through date")
	--	REFERENCES "acris_master" ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
CREATE TABLE "acris_remarks" (
	"document_id"	text,
	"record_type"	text,
	"reference_by_crfn"	text,
	"reference_by_doc_id"	text,
	"reference_by_reel_year"	text,
	"reference_by_reel_borough"	text,
	"reference_by_reel_nbr"	text,
	"reference_by_reel_page"	text,
	"good_through_date"	text
	--, FOREIGN KEY ("Document ID", "Good_through date")
	--	REFERENCES "acris_master" ("Document ID", "Good_through date")
);
END TRANSACTION;

BEGIN TRANSACTION;
create table "pluto" ( "lonlat" geometry, "boroughtext" text, "block"
  integer, "lot" integer, "cd" integer, "ct2010" text,
  "cb2010" integer, "schooldist" integer, "council" integer,
  "zipcode" integer, "firecomp" text, "policeprct" integer,
  "address" text, "zonedist1" text, "zonedist2" text,
  "zonedist3" text, "zonedist4" text, "overlay1" text,
  "overlay2" text, "spdist1" text, "spdist2" text, "ltdheight"
  text, "allzoning1" text, "allzoning2" text, "splitzone" text,
  "bldgclass" text, "landuse" integer, "easements" integer, "ownertype"
  text, "ownername" text, "lotarea" integer, "bldgarea" integer,
  "comarea" integer, "resarea" integer, "officearea" integer,
  "retailarea" integer, "garagearea" integer, "strgearea" integer,
  "factryarea" integer, "otherarea" integer, "areasource" integer,
  "numbldgs" integer, "numfloors" real, "unitsres" integer,
  "unitstotal" integer, "lotfront" real, "lotdepth" real,
  "bldgfront" real, "bldgdepth" real, "ext" text, "proxcode"
  integer, "irrlotcode" text, "lottype" integer, "bsmtcode" integer,
  "assessland" bigint, "assesstot" bigint, "exemptland" bigint,
  "exempttot" bigint, "yearbuilt" integer, "builtcode" text,
  "yearalter1" integer, "yearalter2" integer, "histdist" text,
  "landmark" text, "builtfar" real, "residfar" real, "commfar"
  real, "facilfar" real, "borough" integer, "bbl" text, "condono"
  integer, "tract2010" integer, "xcoord" integer, "ycoord"
  integer, "zonemap" text, "zmcode" text, "sanborn" text, "taxmap"
  integer, "edesignum" text, "appbbl" text, "appdate" text, "plutomapid"
  integer, "version" text
);
END TRANSACTION;
