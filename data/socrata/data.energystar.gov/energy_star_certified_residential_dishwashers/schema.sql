CREATE TABLE "energy_star_certified_residential_dishwashers" (
	"pd_id"	real,
	"brand_name"	text,
	"model_number"	text,
	"additional_model_information"	text,
	"type"	text,
	"annual_energy_use_kwh_year"	real,
	"us_federal_standard_kwh_year"	real,
	"better_than_us_federal_standard_kwh_year"	real,
	"energy_factor_ef"	real,
	"water_use_gallons_cycle"	real,
	"us_federal_standard_gallons_cycle"	real,
	"better_than_us_federal_standard_gallons_cycle"	real,
	"date_available_on_market"	timestamp,
	"date_qualified"	timestamp,
	"markets"	text,
	"energy_star_model_identifier"	text,
	"meets_most_efficient_criteria"	text
);
