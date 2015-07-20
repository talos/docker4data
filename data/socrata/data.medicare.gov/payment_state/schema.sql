CREATE TABLE "payment_state" (
	"state"	text,
	"measure_name"	text,
	"measure_id"	text,
	"number_of_less_than_national_payment"	real,
	"number_of_same_as_national_payment"	real,
	"number_of_greater_than_national_payment"	real,
	"number_of_hospitals_too_few"	real,
	"footnote"	text,
	"measure_start_date"	timestamp,
	"measure_end_date"	timestamp
);
