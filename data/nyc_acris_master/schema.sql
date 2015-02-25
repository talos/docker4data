CREATE UNLOGGED TABLE "nyc_acris_master" (
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
	"good_through_date"	date
	--, primary key ("document_id", "good_through_date")
);
