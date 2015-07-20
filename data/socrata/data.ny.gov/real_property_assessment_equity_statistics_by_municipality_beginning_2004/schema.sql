CREATE TABLE "real_property_assessment_equity_statistics_by_municipality_beginning_2004" (
	"survey_year"	real,
	"swis_code"	text,
	"county"	text,
	"municipality"	text,
	"population_per_square_mile"	real,
	"population_group"	text,
	"method_of_evaluating_equity_for_residential_property"	text,
	"residential_coefficient_of_dispersion"	real,
	"residential_price_related_differential"	real,
	"residential_market_value_ratio"	real,
	"method_of_evaluating_equity_for_all_property"	text,
	"all_property_coefficient_of_dispersion"	real,
	"all_property_price_related_differential"	real,
	"subsequent_year_of_reassessment"	real,
	"does_municipality_have_a_plan_for_cyclical_reassessment"	text,
	"report_or_data_preparation_date"	timestamp,
	"equalization_rate"	real,
	"municipality_stated_uniform_percentage"	real
);
