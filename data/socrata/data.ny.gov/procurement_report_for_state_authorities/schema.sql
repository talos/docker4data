CREATE TABLE "procurement_report_for_state_authorities" (
	"authority_name"	text,
	"fiscal_year_end_date"	timestamp,
	"procurements"	text,
	"vendor_name"	text,
	"vendor_city"	text,
	"vendor_state"	text,
	"vendor_postal_code"	text,
	"vendor_province_region"	text,
	"vendor_country"	text,
	"procurement_description"	text,
	"type_of_procurement"	text,
	"award_process"	text,
	"number_of_bids_or_proposals_received"	real,
	"vendor_is_a_mwbe"	text,
	"solicited_mwbe"	text,
	"number_of_mwbe_proposals"	real,
	"award_date"	timestamp,
	"begin_date"	timestamp,
	"end_date"	timestamp,
	"contract_amount"	text,
	"amount_expended_for_fiscal_year"	text,
	"amount_expended_to_date"	text,
	"current_or_outstanding_balance"	text
);
