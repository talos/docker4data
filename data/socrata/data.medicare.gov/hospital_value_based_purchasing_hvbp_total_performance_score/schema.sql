CREATE TABLE "hospital_value_based_purchasing_hvbp_total_performance_score" (
	"provider_number"	text,
	"hospital_name"	text,
	"address"	text,
	"city"	text,
	"state"	text,
	"zip_code"	text,
	"county_name"	text,
	"unweighted_normalized_clinical_process_of_care_domain_score"	real,
	"weighted_clinical_process_of_care_domain_score"	real,
	"unweighted_patient_experience_of_care_domain_score"	real,
	"weighted_patient_experience_of_care_domain_score"	real,
	"unweighted_normalized_outcome_domain_score"	real,
	"weighted_outcome_domain_score"	real,
	"unweighted_normalized_efficiency_domain_score"	real,
	"weighted_efficiency_domain_score"	real,
	"total_performance_score"	real,
	"location"	text
);
