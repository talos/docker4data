BEGIN TRANSACTION;
ALTER TABLE nyc_acris_master
      ADD PRIMARY KEY ("document_id", "good_through_date");
SELECT document_id, MAX(good_through_date) last_good_through, COUNT(*) cnt
       INTO UNLOGGED TABLE nyc_acris_master_updates
    FROM nyc_acris_master
    GROUP BY document_id
    HAVING count(*) > 1;
DELETE FROM nyc_acris_master WHERE "good_through_date" IS NULL;
DELETE FROM nyc_acris_master m
  WHERE EXISTS (SELECT 1 FROM nyc_acris_master_updates up WHERE
                      up.last_good_through != m.good_through_date AND
                      up.document_id = m.document_id
                    );
ALTER TABLE nyc_acris_master DROP CONSTRAINT nyc_acris_master_pkey;
ALTER TABLE nyc_acris_master ADD PRIMARY KEY ("document_id");
END TRANSACTION;
