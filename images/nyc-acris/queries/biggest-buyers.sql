/*
 * It is common pratice to use a special-purpose corporation to buy properties
 * in New York; this makes it difficult to establish who owns a swathe of
 * properties by name only.  However, often filings are done from a single
 * address.  Which filing address was used to purchase the most properties last
 * year?
 */

SELECT
  --COUNT(DISTINCT cast(borough as bigint) * 1000000000 + block * 10000 + lot) AS cnt,
  COUNT(DISTINCT m.document_id) cnt,
  addr1, addr2, STRING_AGG(name, ',')
  FROM acris_master m, acris_parties --, acris_legals
  WHERE doc_type IN ('DEED', 'DEEDO')
    AND DATE_PART('year', document_date) = 2014
    AND party_type = 2
  GROUP BY addr1, addr2
  ORDER BY cnt DESC
  LIMIT 20;
