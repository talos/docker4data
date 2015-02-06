/*
 * See where a bank has been making mortgage loans in 2014 -- can change the
 * name of the bank from 'BANK OF AMERICA' to anyone you'd like.
 */

SELECT distinct lonlat
FROM acris
WHERE doc_type = 'MTGE'
  AND name ILIKE 'BANK OF AMERICA'
  AND party_type = 2
  AND DATE_PART('year', document_date) = 2014;

