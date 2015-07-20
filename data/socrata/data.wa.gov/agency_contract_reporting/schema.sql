CREATE TABLE "agency_contract_reporting" (
	"agency_name"	text,
	"agency_contract_no"	text,
	"contractor_name"	text,
	"contractor_name_d_b_a_optional"	text,
	"purpose_of_the_contract"	text,
	"purpose_of_the_contract_description_optional"	text,
	"contract_effective_start_date"	timestamp,
	"contract_effective_end_date"	timestamp,
	"period_of_performance_start_date"	timestamp,
	"period_of_performance_end_date"	timestamp,
	"federal_amount"	text,
	"state_amount"	text,
	"other_amount"	text,
	"cost_of_contract"	text,
	"explanation_of_costs_optional"	text,
	"procurement_type_competitive_or_non_competitive"	text,
	"small_business_status_optional"	text
);
