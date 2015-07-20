CREATE TABLE "ems_ambulance_responses_by_month" (
	"month_key"	real,
	"month_start_date"	timestamp,
	"count_responses_all"	real,
	"count_responses_into_coa"	real,
	"count_responses_into_tc"	real,
	"count_responses_into_other"	real,
	"count_responses_into_coa_or_tc"	real,
	"count_responses_into_tc_by_coa"	real,
	"count_responses_into_coa_by_tc"	real,
	"percent_responses_into_coa_by_tc"	text,
	"percent_responses_into_tc_by_coa"	text
);
