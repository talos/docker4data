BEGIN TRANSACTION;
ALTER TABLE nyc_acris_master ADD PRIMARY KEY ("document_id", "good_through_date");
END TRANSACTION;
