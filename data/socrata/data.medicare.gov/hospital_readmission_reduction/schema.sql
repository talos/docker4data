CREATE TABLE "hospital_readmission_reduction" (
	"hospital_name"	text,
	"provider_id"	text,
	"state"	text,
	"measure_id"	text,
	"number_of_discharges"	text,
	"footnote"	real,
	"readm_ratio"	real,
	"predicted"	real,
	"expected"	real,
	"number_of_readmissions"	real,
	"start_date"	timestamp,
	"end_date"	timestamp
);
