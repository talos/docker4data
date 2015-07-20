CREATE TABLE "cable_inspections" (
	"date_inspected"	timestamp,
	"date_completed"	timestamp,
	"cable_company"	text,
	"type_area_inspected"	text,
	"street_name"	text,
	"street_type"	text,
	"city"	text,
	"intersection"	text,
	"violation"	real,
	"alert"	real,
	"resident_generated"	real,
	"in_field_violations"	real,
	"site_survey"	real,
	"re_inspection"	real,
	"re_inspection_date"	timestamp,
	"violation_type"	text
);
