ALTER TABLE socrata_cityofnewyork_acris_real_property_legals ADD COLUMN bbl BIGINT;

/* Delete rows missing good_through_date */
DELETE FROM socrata_cityofnewyork_acris_real_property_legals WHERE "good_through_date" IS NULL;

/* Populate the bbl column */
UPDATE socrata_cityofnewyork_acris_real_property_legals
   SET bbl = CAST(CAST(borough AS TEXT) ||
                 RIGHT('00000' || CAST(block AS TEXT), 5) ||
                 RIGHT('0000' || CAST(lot AS TEXT),  4) AS BIGINT);
ALTER TABLE socrata_cityofnewyork_acris_real_property_legals ALTER COLUMN document_id TYPE BIGINT USING CAST(document_id AS BIGINT);

/* Convert text document IDs to BIGINT */
UPDATE socrata_cityofnewyork_acris_real_property_legals SET document_id = CASE substr(document_id, 0, 3)
          WHEN '20' THEN document_id
          WHEN 'FT' THEN '100' || substr(document_id, 4)
          WHEN 'BK' THEN '000' || substr(document_id, 4)
          ELSE document_ID
      END;
ALTER TABLE socrata_cityofnewyork_acris_real_property_legals ALTER COLUMN document_id TYPE BIGINT USING CAST(document_id AS BIGINT);


/* Remove outdated data (with expired good_through_date) */
-- Temporary index for creating temporary tables
CREATE INDEX socrata_cityofnewyork_acris_real_property_legals_temp_idx ON socrata_cityofnewyork_acris_real_property_legals ("document_id", "good_through_date");
VACUUM ANALYZE socrata_cityofnewyork_acris_real_property_legals;
SELECT document_id, MAX(good_through_date) last_good_through
    INTO UNLOGGED TABLE socrata_cityofnewyork_acris_real_property_legals_unique_duplicate_ids
    FROM socrata_cityofnewyork_acris_real_property_legals
    GROUP BY document_id HAVING count(DISTINCT good_through_date) > 1;
SELECT DISTINCT document_id, good_through_date
    INTO UNLOGGED TABLE socrata_cityofnewyork_acris_real_property_legals_duplicate_ids
    FROM socrata_cityofnewyork_acris_real_property_legals l
    WHERE document_id IN (SELECT document_id from socrata_cityofnewyork_acris_real_property_legals_unique_duplicate_ids);
SELECT dupes.document_id, dupes.good_through_date
    INTO UNLOGGED TABLE socrata_cityofnewyork_acris_real_property_legals_to_delete
    FROM socrata_cityofnewyork_acris_real_property_legals_duplicate_ids dupes
         FULL OUTER JOIN socrata_cityofnewyork_acris_real_property_legals_unique_duplicate_ids uniques
         ON uniques.document_id = dupes.document_id
         AND uniques.last_good_through != dupes.good_through_date;
DELETE FROM socrata_cityofnewyork_acris_real_property_legals l
  WHERE EXISTS (SELECT 1 FROM socrata_cityofnewyork_acris_real_property_legals_to_delete del WHERE
                      del.good_through_date = l.good_through_date AND
                      del.document_id = l.document_id
                    );

/* Add final key & analyze */
DROP INDEX socrata_cityofnewyork_acris_real_property_legals_temp_idx;
-- doesn't work because of bogus block/lots (=0 & =0)
-- ALTER TABLE socrata_cityofnewyork_acris_real_property_legals ADD PRIMARY KEY ("document_id", "bbl");
CREATE INDEX ON socrata_cityofnewyork_acris_real_property_legals (bbl);
CREATE INDEX ON socrata_cityofnewyork_acris_real_property_legals (document_id);
VACUUM ANALYZE socrata_cityofnewyork_acris_real_property_legals;
