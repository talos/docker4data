CREATE TABLE "nyc_acris_parties" (
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
