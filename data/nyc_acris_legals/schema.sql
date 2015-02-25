CREATE TABLE UNLOGGED "nyc_acris_legals" (
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
	"good_through_date"	date
	--, FOREIGN KEY ("Document ID", "Good_through date")
	--	REFERENCES "acris_master" ("Document ID", "Good_through date")
);
