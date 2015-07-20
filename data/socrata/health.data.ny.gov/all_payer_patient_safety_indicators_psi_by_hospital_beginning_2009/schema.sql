CREATE TABLE "all_payer_patient_safety_indicators_psi_by_hospital_beginning_2009" (
	"year"	real,
	"facility_id"	real,
	"hospital_name"	text,
	"hospital_county"	text,
	"hospital_region"	text,
	"psi_code"	text,
	"psi_value"	text,
	"total_cases"	real,
	"numerator"	real,
	"observed_rate"	real,
	"expected_rate"	real,
	"risk_adjusted_rate"	real,
	"lower_95ci_rar"	real,
	"upper_95ci_rar"	real,
	"compare_to_state"	text,
	"compare_to_national"	text
);
