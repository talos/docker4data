/* Delete rows missing good_through_date */
DELETE FROM socrata_cityofnewyork_acris_real_property_parties WHERE "good_through_date" IS NULL;

/* Convert text document IDs to BIGINT */
UPDATE socrata_cityofnewyork_acris_real_property_parties SET document_id = CASE substr(document_id, 0, 3)
          WHEN '20' THEN document_id
          WHEN 'FT' THEN '100' || substr(document_id, 4)
          WHEN 'BK' THEN '000' || substr(document_id, 4)
          ELSE document_ID
      END;
ALTER TABLE socrata_cityofnewyork_acris_real_property_parties ALTER COLUMN document_id TYPE BIGINT USING CAST(document_id AS BIGINT);

/* Remove outdated data (with expired good_through_date) */
-- Temporary index for creating temporary tables
CREATE INDEX socrata_cityofnewyork_acris_real_property_parties_temp_idx ON socrata_cityofnewyork_acris_real_property_parties ("document_id", "good_through_date");
VACUUM ANALYZE socrata_cityofnewyork_acris_real_property_parties;
SELECT document_id, MAX(good_through_date) last_good_through
    INTO UNLOGGED TABLE socrata_cityofnewyork_acris_real_property_parties_unique_duplicate_ids
    FROM socrata_cityofnewyork_acris_real_property_parties
    GROUP BY document_id
    HAVING count(distinct good_through_date) > 1;
SELECT DISTINCT document_id, good_through_date
    INTO UNLOGGED TABLE socrata_cityofnewyork_acris_real_property_parties_duplicate_ids
    FROM socrata_cityofnewyork_acris_real_property_parties p
    WHERE document_id IN (SELECT document_id from socrata_cityofnewyork_acris_real_property_parties_unique_duplicate_ids);
SELECT dupes.document_id, dupes.good_through_date
    INTO UNLOGGED TABLE socrata_cityofnewyork_acris_real_property_parties_to_delete
    FROM socrata_cityofnewyork_acris_real_property_parties_duplicate_ids dupes
         FULL OUTER JOIN socrata_cityofnewyork_acris_real_property_parties_unique_duplicate_ids uniques
         ON uniques.document_id = dupes.document_id
         AND uniques.last_good_through != dupes.good_through_date;
DELETE FROM socrata_cityofnewyork_acris_real_property_parties p
  WHERE EXISTS (SELECT 1 FROM socrata_cityofnewyork_acris_real_property_parties_to_delete del WHERE
                      del.good_through_date = p.good_through_date AND
                      del.document_id = p.document_id
                    );

/* Add final key & analyze */
DROP INDEX socrata_cityofnewyork_acris_real_property_parties_temp_idx;
-- no suitable unique options
--ALTER TABLE socrata_cityofnewyork_acris_real_property_parties ADD PRIMARY KEY ("document_id", "party_type", "name");
CREATE INDEX ON socrata_cityofnewyork_acris_real_property_parties ("document_id");
CREATE INDEX ON socrata_cityofnewyork_acris_real_property_parties ("name");
VACUUM ANALYZE socrata_cityofnewyork_acris_real_property_parties;
