CREATE TABLE "energy_star_certified_commercial_clothes_washers" (
	"pd_id"	real,
	"brand_name"	text,
	"model_number"	text,
	"additional_model_information"	text,
	"upc"	text,
	"load_configuration"	text,
	"intended_market"	text,
	"volume_cubic_feet"	real,
	"modified_energy_factor_mef"	real,
	"us_federal_standard_mef"	text,
	"annual_energy_use_kwh_year"	real,
	"water_factor_wf"	real,
	"us_federal_standard_wf"	real,
	"date_available_on_market"	timestamp,
	"date_qualified"	timestamp,
	"markets"	text,
	"energy_star_model_identifier"	text
);
