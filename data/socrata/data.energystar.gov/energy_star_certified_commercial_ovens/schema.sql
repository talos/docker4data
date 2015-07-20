CREATE TABLE "energy_star_certified_commercial_ovens" (
	"pd_id"	real,
	"energy_star_partner"	text,
	"brand_name"	text,
	"model_name"	text,
	"model_number"	text,
	"additional_model_information"	text,
	"oven_type"	text,
	"size"	text,
	"fuel_type"	text,
	"input_rate_kw"	text,
	"input_rate_btu_h"	real,
	"electric_oven_convection_mode_idle_energy_rate_kw"	text,
	"gas_oven_convection_mode_idle_energy_rate_btu_h"	real,
	"gas_oven_convection_mode_cooking_energy_efficiency"	real,
	"electric_oven_convection_mode_cooking_energy_efficiency"	real,
	"door_type"	text,
	"additional_door_type_s"	text,
	"method_of_steam_generation"	text,
	"steam_pan_capacity"	real,
	"half_size_sheet_pan_capacity"	real,
	"full_size_sheet_pan_capacity"	real,
	"gas_oven_convection_mode_electric_idle_energy_rate_kw"	text,
	"gas_oven_steam_mode_idle_energy_rate_btu_h"	text,
	"gas_oven_steam_mode_electric_idle_energy_rate_kw"	text,
	"electric_oven_steam_mode_idle_energy_rate_kw"	real,
	"convection_mode_production_capacity_lbs_h"	real,
	"convection_mode_average_water_consumption_rate_gal_h"	real,
	"gas_oven_steam_mode_cooking_energy_efficiency"	real,
	"electric_oven_steam_mode_cooking_energy_efficiency"	real,
	"steam_mode_production_capacity_lbs_h"	real,
	"steam_mode_average_water_consumption_rate_gal_h"	real,
	"date_available_on_market"	timestamp,
	"date_qualified"	timestamp,
	"markets"	text,
	"energy_star_model_identifier"	text
);
