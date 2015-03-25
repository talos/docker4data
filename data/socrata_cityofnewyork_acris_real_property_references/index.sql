/* Delete rows missing good_through_date */
DELETE FROM socrata_cityofnewyork_acris_real_property_references WHERE "good_through_date" IS NULL;

/* Convert text document IDs to BIGINT */
UPDATE socrata_cityofnewyork_acris_real_property_references SET document_id = CASE substr(document_id, 0, 3)
          WHEN '20' THEN document_id
          WHEN 'FT' THEN '100' || substr(document_id, 4)
          WHEN 'BK' THEN '000' || substr(document_id, 4)
          ELSE document_ID
      END;
ALTER TABLE socrata_cityofnewyork_acris_real_property_references ALTER COLUMN document_id TYPE BIGINT USING CAST(document_id AS BIGINT);

