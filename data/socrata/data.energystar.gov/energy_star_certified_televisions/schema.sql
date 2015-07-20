CREATE TABLE "energy_star_certified_televisions" (
	"pd_id"	real,
	"energy_star_partner"	text,
	"brand_name"	text,
	"model_name"	text,
	"model_number"	text,
	"additional_model_information"	text,
	"product_type"	text,
	"screen_type"	text,
	"size_inches"	real,
	"screen_area_square_inches"	real,
	"resolution_pixels"	text,
	"vertical_resolution"	text,
	"automatic_brightness_control"	text,
	"is_automatic_brightness_control_enabled_by_default_when_television_is_shipped"	text,
	"measured_on_mode_power_at_ambient_light_level_of_0_lux_watts"	real,
	"measured_on_mode_power_at_ambient_light_level_of_3_lux_watts"	real,
	"measured_on_mode_power_at_ambient_light_level_of_10_lux_watts"	real,
	"measured_on_mode_power_at_ambient_light_level_of_12_lux_watts"	real,
	"measured_on_mode_power_at_ambient_light_level_of_35_lux_watts"	real,
	"measured_on_mode_power_at_ambient_light_level_of_50_lux_watts"	real,
	"measured_on_mode_power_at_ambient_light_level_of_100_lux_watts"	real,
	"measured_on_mode_power_at_ambient_light_level_of_300_lux_watts"	real,
	"power_consumption_in_on_mode_watts"	real,
	"maximum_on_mode_power_for_qualification_watts"	real,
	"power_consumption_in_standby_mode_watts"	real,
	"maximum_standby_passive_mode_power_for_qualification_watts"	real,
	"power_consumption_in_standby_mode_when_network_connected_watts"	text,
	"networking_protocol_enabled"	text,
	"technology_type"	text,
	"other_features"	text,
	"luminance_in_brightest_selectable_picture_setting_cd_sq_meter"	real,
	"luminance_in_default_picture_setting_cd_sq_meter"	real,
	"if_download_acquisition_mode_is_present_energy_consumption_in_dam_watt_hours_day"	real,
	"maximum_allowable_energy_in_dam_watt_hours_day"	real,
	"calculated_tec_value_if_hospitality_tv_watt_hours_day"	real,
	"maximum_allowed_tec_for_hospitality_tvs_watt_hours_day"	real,
	"estimated_annual_energy_use_kilowatt_hours_year"	real,
	"date_available_on_market"	timestamp,
	"date_qualified"	timestamp,
	"markets"	text,
	"energy_star_model_identifier"	text,
	"meets_most_efficient_criteria"	text
);
