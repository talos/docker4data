CREATE TABLE "eu_energy_star_certified_displays" (
	"pd_id"	real,
	"energy_star_partner"	text,
	"brand"	text,
	"model_name"	text,
	"model_number"	text,
	"additional_model_information"	text,
	"display_type"	text,
	"panel_technology"	text,
	"backlight_technology"	text,
	"native_resolution_pixels"	text,
	"maximum_resolution_pixels"	text,
	"aspect_ratio"	real,
	"screen_size_inches"	real,
	"screen_area_square_inches"	real,
	"data_network_peripheral_ports"	text,
	"data_network_connection"	text,
	"power_source"	text,
	"power_consumed_in_on_mode_w"	real,
	"power_consumed_in_sleep_mode_w"	real,
	"off_mode_power_in_watts"	real,
	"is_automatic_brightness_control_enabled_when_monitor_display_is_shipped"	text,
	"on_mode_power_at_10_lux_watts"	real,
	"on_mode_power_at_300_lux_watts"	real,
	"maximum_luminance_candelas_per_square_meter"	real,
	"enhanced_performance_display"	text,
	"date_available_on_market"	timestamp,
	"date_qualified"	timestamp,
	"markets"	text,
	"energy_star_model_identifier"	text,
	"meets_most_efficient_criteria"	text,
	"json_additional_model_information"	text
);
