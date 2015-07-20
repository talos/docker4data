CREATE TABLE "medicaid_inpatient_prevention_quality_indicators_pqi_for_adult_discharges_by_patient_zip_code_beginning_2011" (
	"discharge_year"	real,
	"zip_code"	text,
	"pqi_number"	text,
	"pqi_name"	text,
	"medicaid_pqi_hospitalizations"	real,
	"zip_code_medicaid_population"	real,
	"observed_rate_per_100_000_people"	real,
	"expected_pqi_hospitalizations"	real,
	"expected_rate_per_100_000_people"	real,
	"risk_adjusted_rate_per_100_000_people"	real,
	"difference_in_hospitalizations"	real,
	"dual_status"	real
);
