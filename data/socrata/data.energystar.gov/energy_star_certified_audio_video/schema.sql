CREATE TABLE "energy_star_certified_audio_video" (
	"pd_id"	real,
	"energy_star_partner"	text,
	"brand_name"	text,
	"model_name"	text,
	"model_number"	text,
	"additional_model_information"	text,
	"product_type"	text,
	"video_player_type"	text,
	"tuner_included"	text,
	"amplifier_channels"	text,
	"connected_technology"	text,
	"default_auto_power_down_apd_timing_minutes"	real,
	"average_power_consumption_2_minutes_before_apd_watts"	real,
	"average_power_consumption_2_minutes_after_apd_watts"	real,
	"idle_state_power_consumption_watts"	real,
	"sleep_mode_power_consumption_watts"	real,
	"video_playback_power_consumption_watts"	real,
	"audio_playback_power_consumption_watts"	real,
	"is_amplifier_consumer_or_commercial"	text,
	"amplifier_input_power_at_1_8_maximum_undistorted_power_watts"	real,
	"on_mode_amplifier_efficiency"	text,
	"date_available_on_market"	timestamp,
	"date_qualified"	timestamp,
	"markets"	text,
	"energy_star_model_identifier"	text
);
