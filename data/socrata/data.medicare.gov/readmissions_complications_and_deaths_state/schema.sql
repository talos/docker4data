CREATE TABLE "readmissions_complications_and_deaths_state" (
	"state"	text,
	"measure_name"	text,
	"measure_id"	text,
	"number_of_hospitals_worse"	real,
	"number_of_hospitals_same"	real,
	"number_of_hospitals_better"	real,
	"number_of_hospitals_too_few"	real,
	"footnote"	text,
	"measure_start_date"	timestamp,
	"measure_end_date"	timestamp
);
