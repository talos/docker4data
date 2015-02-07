/*
 * See where a bank has been making mortgage loans in 2014 -- can change the
 * name of the bank from 'BANK OF AMERICA' to anyone you'd like.
 */

SELECT distinct lonlat FROM acris_legals l
  JOIN pluto p ON l.borough = p.borough AND
                  l.block = p.block AND
                  l.lot = p.lot
WHERE document_id IN (
  SELECT document_id FROM acris_parties WHERE document_id IN (
    SELECT document_id FROM acris_master
    WHERE doc_type = 'MTGE'
      AND DATE_PART('year', document_date) = 2014
  ) AND party_type = 2
    AND name LIKE 'BANK OF AMERICA%'
);
