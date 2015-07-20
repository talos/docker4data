CREATE TABLE "population_health_measures_age_adjusted_mortality_rates" (
	"unique_id"	text,
	"year_range"	text,
	"cause_of_death"	text,
	"race"	text,
	"hispanic_origin"	text,
	"gender"	text,
	"age_adjusted_rate_per_100_000_population"	real,
	"lower_95_confidence_interval"	real,
	"upper_95_confidence_interval"	real
);
