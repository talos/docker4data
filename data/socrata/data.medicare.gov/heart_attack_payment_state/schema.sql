CREATE TABLE "heart_attack_payment_state" (
	"state"	text,
	"measure_name"	text,
	"measure_id"	text,
	"number_of_hospitals_less_than"	real,
	"number_of_hospitals_same"	real,
	"number_of_hospitals_greater_than"	real,
	"number_of_hospitals_too_few"	real,
	"footnote"	text,
	"measure_start_date"	timestamp,
	"measure_end_date"	timestamp
);
