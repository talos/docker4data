CREATE TABLE "energy_star_certified_commercial_dishwashers" (
	"pd_id"	real,
	"energy_star_partner"	text,
	"brand_name"	text,
	"model_name"	text,
	"model_number"	text,
	"additional_model_information"	text,
	"machine_type"	text,
	"sanitation_method"	text,
	"idle_energy_rate_for_low_temp_kw"	real,
	"idle_energy_rate_for_high_temp_kw"	real,
	"water_use_gallons_per_rack_gpr"	real,
	"water_use_gallons_per_hour_gph"	real,
	"water_use_gallons_per_square_foot_gpsf"	real,
	"date_available_on_market"	timestamp,
	"date_qualified"	timestamp,
	"markets"	text,
	"energy_star_model_identifier"	text
);
