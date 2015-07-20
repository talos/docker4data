CREATE TABLE "medicare_hospital_spending_by_claim" (
	"hospital_name"	text,
	"provider_number"	text,
	"state"	text,
	"period"	text,
	"claim_type"	text,
	"avg_spending_per_episode_hospital"	text,
	"avg_spending_per_episode_state"	text,
	"avg_spending_per_episode_nation"	text,
	"percent_of_spending_hospital"	text,
	"percent_of_spending_state"	text,
	"percent_of_spending_nation"	text,
	"measure_start_date"	timestamp,
	"measure_end_date"	timestamp
);
