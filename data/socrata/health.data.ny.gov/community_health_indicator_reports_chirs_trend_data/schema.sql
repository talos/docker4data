CREATE TABLE "community_health_indicator_reports_chirs_trend_data" (
	"county_name"	text,
	"county_code"	real,
	"health_topic_number"	real,
	"health_topic"	text,
	"indicator_id"	text,
	"indicator_name"	text,
	"date_years"	text,
	"trend_data_county_value"	real,
	"comment_for_trend_data_county_value"	text,
	"trend_data_nyc_value"	real,
	"trend_data_nys_exc_nyc_value"	real,
	"three_year_average_county_value"	real,
	"comment_for_three_year_average_county_value"	text,
	"data_source"	text
);
