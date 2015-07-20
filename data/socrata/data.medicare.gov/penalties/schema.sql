CREATE TABLE "penalties" (
	"federal_provider_number"	text,
	"provider_name"	text,
	"provider_address"	text,
	"provider_city"	text,
	"provider_state"	text,
	"provider_zip_code"	text,
	"penalty_date"	timestamp,
	"penalty_type"	text,
	"fine_amount"	text,
	"payment_denial_start_date"	timestamp,
	"payment_denial_length_in_days"	real,
	"location"	text,
	"processing_date"	timestamp
);
